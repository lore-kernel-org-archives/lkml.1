Return-Path: <linux-kernel-owner+w=401wt.eu-S933752AbZHEIAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933752AbZHEIAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 04:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933710AbZHEIAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 04:00:47 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:38215 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933681AbZHEIAq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 04:00:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pnVP7lcxfhtw793FZ+wRQj1QH58BQ2aAXuin/n+11FzzybdB98PFDI6vaotWQDY66E
         v9Hk+fgKZBHzxgSVpv5NJUbNUH2Nol3dlkpJOespY1mFEOBDvdgvj9SQObD3/ES6xRcK
         aNoZayar5mv4uKScUMXsWxePkZ36/AD4tL3ok=
MIME-Version: 1.0
In-Reply-To: <20090805070822.GC30892@infomag.iguana.be>
References: <4A69CE00.10401@gmail.com>
	 <20090804201032.GB30892@infomag.iguana.be>
	 <e68bb3470908041955t7e07929bv612a25e0bc0264c1@mail.gmail.com>
	 <20090805070822.GC30892@infomag.iguana.be>
Date: Wed, 5 Aug 2009 16:00:45 +0800
Message-ID: <e68bb3470908050100n4f6f8ed3hbd227a13e038e55f@mail.gmail.com>
Subject: Re: [PATCH] Add watchdog driver for w90p910
From: Wan ZongShun <mcuos.com@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear wim,


2009/8/5 Wim Van Sebroeck <wim@iguana.be>:
> Hi Wan,
>
>>  I'm much obliged to you for helping me.
>
> With pleasure :-).
>
>> >> +static irqreturn_t w90p910_wdt_irq(int irq, void *dev_id)
>> >> +{
>> >> +     w90p910_wdt_keepalive();
>> >> +     return IRQ_HANDLED;
>> >> +}
>> >
>> > How does the interrupt work? what does the watchdog do when it times out?
>> > (Is there a datasheet available somewhere?)
>> >
>>
>> The mechanism of watchdog of w90p910 is that the interrupt will occur
>> periodicity every a given time interval.
>>
>> Hmm, there are only two choices to confirm the system running, one to
>> clear this WTIF and  WTR bits in handler of interrupt, the other to
>> reset them in user application before interrupt occurs.
>
> Hmm, I'm confused now. how does the watchdog then reboot your system?
> The way we implement watchdog's in linux is that you start the watchdog and that userspace needs to trigger/ping/keep-the-watchdog-alive before the timeout period is finished/over. If the userspace daemon can keep doing this (or with other words: the system is healthy enough to operate normally without to much delay) your system doesn't get rebooted. If it doesn't manage to do it, then the watchdog knows that your system is not stable/healthy enough and will reboot your system.

Thanks a lot for your reviewing again.

Good, above what you said is just apply to my watchdog.


> Here I think that the watchdog is started. Then userspace start pinging the watchdog and everything is OK. If userspace doesn't ping the watchdog in time an interrupt is being generated and instead of rebooting the system, the watchdog is being triggered... If this is indeed what it does then this is wrong.

If so, I can not do handling  the interrupt and only provide a api for
userspace to trigger/ping/keep-the-watchdog-alive.

>
>> > The read-write cyclus to REG_WTCR should also be guarded with a spinlock.
>> > Can you incorporate the call to w90p910_wdt_start() in the ioctl code into this function?
>> >
>>
>> Do you mean that I should merge the "w90p910_wdt_settimeout" to
>> "w90p910_wdt_start()"? or contrary?
>
> I mean the contrary.
> If your watchdog needs to be restarted when you set a new timeout, then it is best to have this in the settimeout function.
> It is also better to do a ping to the watchdog once the new timeout was set. It might however be that a ping is enough and that a restart is not needed.
> So something like the following diff could be it:
> --- w90p910_wdt.c       2009-08-05 06:44:14.286477908 +0000
> +++ w90p910_wdt.c       2009-08-05 06:46:04.496353102 +0000
> @@ -144,6 +144,9 @@
>        __raw_writel(val, w90p910_wdt->wdt_base + REG_WTCR);
>
>        wdt_time = new_time_level;
> +
> +       w90p910_wdt_start();
> +
>        return 0;
>  }
>
> @@ -182,9 +185,7 @@
>                        return -EFAULT;
>                if (w90p910_wdt_settimeout(new_value))
>                        return -EINVAL;
> -
> -               w90p910_wdt_start();
> -
> +               w90p910_wdt_keepalive();
>                return put_user(wdt_time, p);
>        case WDIOC_GETTIMEOUT:
>                return put_user(wdt_time, p);
> ---
>

Okay, got it.

> I have an additional question: which timeout values can you set? is it 0, 1, 2 and 3 seconds?

The 0, 1, 2 and 3 is not seconds, rather than 'level' , it means my
watchdog controller can only set four grades,
When WTIS bit of REG_WTCR was set one value of  the 0, 1, 2 and 3, the
 real time interval can be calculated via following formula .

WTIS                 real time interval (formula)
0x00                   ((2^ 14 ) * ((external crystal freq) / 256))seconds
0x01                   ((2^ 16 ) * ((external crystal freq) / 256))seconds
0x02                   ((2^ 18 ) * ((external crystal freq) / 256))seconds
0x03                   ((2^ 20 ) * ((external crystal freq) / 256))seconds

The external crystal freq is 15Mhz in w90p910 evaluation board. so I
set the '0x00' as a default value, it means the real time interval is
0.28 second approximately.



>
> Kind regards,
> Wim.
>
>



-- 
Wan z.s
