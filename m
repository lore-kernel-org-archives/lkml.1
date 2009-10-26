Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbZJZULw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbZJZULw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbZJZULv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:11:51 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:61378 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbZJZULu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:11:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RZyxkRB5LXfvemBDO8EBGVF2srpooyb0+ZYnKymSVAJWKSB/sn51WTQGj0XoZdb+Yt
         DB27x1LHImBNMYEKtHT8TjXk+HK4LkkoLG4rvVE3yw4HCsOx6tx6n3LRgLVnEfm24XdO
         LvdqLg8cXvU6DC+UpfaZo7stxexW3FvxSEE2s=
MIME-Version: 1.0
In-Reply-To: <4AE5EA71.2050304@sgi.com>
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
	 <20091023233756.941535000@alcatraz.americas.sgi.com>
	 <b647ffbd0910241309u7b2f8c94t1f886ef31882539e@mail.gmail.com>
	 <Pine.LNX.4.61.0910242207180.2439@ginsburg.homenet>
	 <b647ffbd0910241545g4697a170peb00e541298d5a30@mail.gmail.com>
	 <20091025163704.GE20391@elte.hu> <4AE5EA71.2050304@sgi.com>
Date: Mon, 26 Oct 2009 21:11:54 +0100
Message-ID: <b647ffbd0910261311n4ac4471el7a32ac41104cf93b@mail.gmail.com>
Subject: Re: [PATCH 6/8] SGI x86_64 UV: Limit the number of microcode messages
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Andreas Mohr <andi@lisas.de>,
       Hugh Dickins <hugh@veritas.com>, Hannes Eder <hannes@hanneseder.net>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/26 Mike Travis <travis@sgi.com>:
>
>
> Ingo Molnar wrote:
>>
>> * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
>>
>>> 2009/10/24 Tigran Aivazian <tigran@aivazian.fsnet.co.uk>:
>>>>
>>>> On Sat, 24 Oct 2009, Dmitry Adamushko wrote:
>>>>>>
>>>>>> -       printk(KERN_INFO "microcode: CPU%d sig=0x%x, pf=0x%x,
>>>>>> revision=0x%x\n",
>>>>>> +       if (cpu_num < 4 || !limit_console_output(false))
>>>>>> +               printk(KERN_INFO
>>>>>> +                       "microcode: CPU%d sig=0x%x, pf=0x%x,
>>>>>> revision=0x%x\n",
>>>>>>                       cpu_num, csig->sig, csig->pf, csig->rev);
>>>>>>
>>>>> Hmm, I guess we wouldn't lose a lot by simply removing those messages
>>>>> completely. Per-cpu pf/revision is available via /sys anyway.
>>>>
>>>> The reason for printing them is that the pf (possibly others?) can
>>>> change by the update and so the log has this info handy.
>>>
>>> We might store the old sig/pf/revision set as well, export them via
>>> /sys or/and print them at update-to-new-microcode time.
>>>
>>> If it's really so useful to have this info in the log and, at the same
>>> time, to avoid the flood of messages (which, I guess for the majority
>>> of systems, are the same) at startup time, we might delay the printout
>>> until the end of microcode_init(). Then do something like this:
>>>
>>> microcode cpu0: up to date version sig, pf, rev          // let's say,
>>> it was updated by BIOS
>>> microcode cpus [1 ... 16] : update from sig, pf, rev to sig, pf2, rev2.
>>>
>>> Anyway, my humble opinion, is that (at the very least) the current
>>> patch should be accompanied by a similar version for amd.
>>
>> yeah. Since we load new microcode on all cpus it's enough to print it for
>> the boot CPU or so.
>>
>> Having the precise microcode version printed (or exposed somewhere in
>> /sys) is useful - sometimes when there's a weird crash in some prototype CPU
>> one of the first questions from hw vendors is 'which precise microcode
>> version was that?'.
>>
>>        Ingo
>
> I would agree especially in the case where not all the cpus are exactly
> the same.  But so far, I've only seen variations of the speed of the cpus
> not it's generic type, in an SSI.  So the version of the microcode was
> identical in all cases.

I guess that (at least) a bootup cpu can be updated by BIOS so that it
may appear to be different.
Perhaps, cases where some 'broken' cpus have been replaced for others
with a different "revision" (but still compatible otherwise) might be
rare but possible (say, big machines with hot-pluggable cpus) ?

btw., I was thinking of having something like this:

microcode: cpus [K...L]  platform-specific-format (e.g. for Intel :
sig, pf, rev)
microcode: updating...
microcode: cpus [K...L]  platform-specific-format (e.g. for Intel :
sig, pf, rev)

or even just,

microcode: cpus [ K...L] updated from platform-specific-format-1 to
platform-specific-format-2


>
> Thanks,
> Mike
>


-- Dmitry
