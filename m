Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbZKQWPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbZKQWPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756278AbZKQWPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:15:33 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:51413 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271AbZKQWPb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:15:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UmxC+wklMUCG8V7kQPN+L2SoQCb4LWoik5ZmeJ6Vt0yPmar6rDEIXZIPt0jlMubxo7
         iVnuWwmFY02QZyZsBqdwDPk94M6Y+Z1h1TEfIywHeHD4/b+71l9dvRu2PMo4jqfU20Y8
         6LPTr3BsAxrTsWxJXnKWaGc5VLUoFH+LCiNfE=
MIME-Version: 1.0
In-Reply-To: <768725.48321.qm@web53403.mail.re2.yahoo.com>
References: <768725.48321.qm@web53403.mail.re2.yahoo.com>
Date: Tue, 17 Nov 2009 14:15:37 -0800
X-Google-Sender-Auth: 0701e0cb5416e36f
Message-ID: <1f1b08da0911171415r12503874kdfc6b50aa376c9c0@mail.gmail.com>
Subject: Re: Jiffies jumping with the x86 HPET
From: john stultz <johnstul@us.ibm.com>
To: Lee Merrill <lee_merrill@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 3:59 PM, Lee Merrill <lee_merrill@yahoo.com> wrote:
> We are seeing jiffies go forward occasionally, by 300 seconds, this it appears is due to the following code in the 2.6.16 kernel:
>
> mark_offset_tsc_hpet(void):
> ...
> 1       hpet_current = hpet_readl(HPET_COUNTER);
> 2       rdtsc(last_tsc_low, last_tsc_high);
> 3
> 4       /* lost tick compensation */
> 5       offset = hpet_readl(HPET_T0_CMP) - hpet_tick;
> 6       if (unlikely(((offset - hpet_last) > hpet_tick) && (hpet_last != 0))
> 7                                       && detect_lost_ticks) {
> 8               int lost_ticks = (offset - hpet_last) / hpet_tick;
> 9               jiffies_64 += lost_ticks;
> 10      }
> 11      hpet_last = hpet_current;
>
> where "offset - hpet_last" is an
> unsigned -9, thus the test passes, and jiffies is incremented by a
> large and invalid amount (by a bit less than 300 seconds). Now the
> HPET_T0_CMP register being the timer comparison register, when the HPET's counter
> reaches that value, the comparison register is incremented by
> hpet_tick, and an interrupt is generated.
>
> So let's say hpet_tick is 100, thus the
> timer interrupts at every 100 HPET ticks, and let's say that just
> before line 1, we get delayed, so that another timer interrupt becomes
> pending.Then we read the counter (say, 809) and HPET_T0_CMP (900), and
> store the counter value of 809 in "hpet_last". Then we get our pending
> timer interrupt, and HPET_T0_CMPis still 900, so "offset" is 900 - 100
> or 800, and "offset - hpet_last" would be unsigned -9, and jiffies gets
> a large increment.

[snip]

> The above scenario requires that the timer interrupt routine be either interrupted itself (can you tell what priority each interrupt is?) or that it get preempted, if such preemption of a timer interrupt is possible, or some such. The fix would be simple, to just make the comparison "((offset - hpet_last) > hpet_tick)" be a signed comparison.
>
> The timer system being rewritten in 2.6.18 means this problem is not present from this version on, but we see one failure a week or so in the lab, and in several systems in the field, so a patch or at least a note for kernels before 2.6.18 might be helpful.

So yea, its concerning your hardware is skipping ticks and doing it in
irq context as well. The timekeeping rework was done to avoid this
sort of issue from bad hardware. So I'd recommend upgrading, but I
understand that's not always an option.

No promises on if there's not other issues here, but it would seem the
issue is stemming from mixing the HPET_COUNTER and HPET_T0_CMP.
Instead, hpet_last should be the hpet_readl(HPET_T0_CMP), which avoids
issues if you get blocked (likely due to an SMI).

So the code would look something like:

/* lost tick compensation */
hpet_cmp = hpet_readl(HPET_T0_CMP)
offset = hpet_cmp - hpet_tick;
 if (unlikely(((offset - hpet_last) > hpet_tick) && (hpet_last != 0))
                                      && detect_lost_ticks) {
                    int lost_ticks = (offset - hpet_last) / hpet_tick;
                    jiffies_64 += lost_ticks;
}
hpet_last = hpet_cmp;

Again, no promises that this doesn't have other side effects, but
seems like it would avoid the negative offsets properly and make sure
the hpet_last actually stores the time of the irq, rather then the
time it was serviced.

thanks
-john
