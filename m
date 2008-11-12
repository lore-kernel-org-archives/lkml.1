Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbYKLRtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbYKLRtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYKLRst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:48:49 -0500
Received: from ik-out-1112.google.com ([66.249.90.177]:58991 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbYKLRsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:48:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aZDtKKeNBMoiXsIijEdgseu6jNxLFVp7FTAHAgZyuXuQCKzDjtwSmvvZB5fYSAZzuE
         mV6P07TaLd0gPEdx98aIUhY5Qc1Xua76P9EHSclDiqpAKDNs5FpAe9ychRV2N2i9eDL7
         O2WEJfEHjOglLOMYx3bjAlF1bM/sQeSoJWtPE=
Message-ID: <491B16F9.8030608@gmail.com>
Date: Wed, 12 Nov 2008 19:48:41 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: Bugs on aspire one A150
References: <491506DB.1070000@gmail.com> <49157E97.60503@tuffmail.co.uk> <49163435.20301@gmail.com> <4916BED0.4090700@tuffmail.co.uk>
In-Reply-To: <4916BED0.4090700@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Maxim Levitsky wrote:
>> Alan Jenkins wrote:
>>> Maxim Levitsky wrote:
>>>> I have just bought an Aspire one A150, XP version,
>>>> as it was the only available here, and installed ubuntu on it.
>>>>
>>>> Bugs I discovered so far:
>>>>
>>>>
>>>> ** 1 - embedded controler works in polling mode, due to this:
>>>>
>>>> [    0.708571] ACPI: EC: non-query interrupt received, switching to
>>>> interrupt mode
>>>> [    1.224043] ACPI: EC: missing confirmations, switch off interrupt
>>>> mode.
>>>>
>>>>
>>>> Maybe this is the reason for the fact that gnome power manager
>>>> freezes when I unplug
>>>> the AC, and freezes often when I try to see battery status.
>>>>
>>>>
>>>> (Note: same is seen on my acer aspire 5720)
>>> That sounds like a known issue.  It has been resolved by "ACPI: EC:
>>> revert msleep patch".  Happily Len submitted it for mainline this
>>> week.  You will also find it if you try the acpi-test git tree. 
>>> We're all hoping 2.6.28 will be much improved in terms of reliable
>>> operation of different ECs :).
>>>
>> Yes, this almost fixes all issues with that.
>> Almost because, it looks like the EC changes screen brightness on his
>> own when battery is plugged/unplugged,
>> but so does the gnome-power-manager, and thus it still hangs as before
>> on battery removal (but doesn't hang otherwise)
>> I disabled that behaver in gnome-power-manager and now no more hangs.
>>
> 
> Please do report it as an ACPI EC bug.  It's popular hardware, and if
> nothing else it is important that upstream be aware of the workarounds
> people are having to use.
> 
>> I see that this fix fixes the polled mode. Any chance to make irq mode
>> work?
>>
> 
> Probably not.  It doesn't seem important, it may not be possible, and
> even if you could fix the EC driver for your hardware, there's the risk
> of breaking other peoples hardware.
> 
> The presumption is that you have weird hardware and it genuinely needs a
> polling workaround.  It's not too bad, now it uses udelay() it should
> not impose any wakeups or significant latency, just some extra cpu time
> in a busy loop.  EC events such as acpi hotkeys are still received as
> interrupts (although we then have to query the type of event using a
> polled transaction).
> 
> 
> I assume you get something like (text not exact):
> 
> "EC: started in polling mode"
> ...
> "EC: non-query interrupt received, switching to interrupt mode"
> ...
> "EC: missing confirmations, switching to polling mode"
> 
> all during boot.
Yes, this is what I see.

> 
> 
> There's one outstanding issue on a different machine, where the
> occasional EC read fails and triggers polling mode sometime _after_
> boot.  It can be fixed by retrying the transaction
> 
>     http://bugzilla.kernel.org/show_bug.cgi?id=11896
> 
> but I don't really expect your machine has the same problem.
> 
> <snip non-acpi problems>
> 
>> Also noticed another bug:
>>
>>
>> If I suspend/resume with compiz running, on resume I see wallpaper and
>> mouse cursor, everything hangs for minute or two, and sometimes forever.
>>
>> 2.6.27 worked fine.
> 
> Weird.
> 
> Did you try sysrq-W during the hang?  That's supposed to dump a list of
> blocked tasks to dmesg.
Well, I see the wallpaper and can move the mouse, I will try to suspend from console
I think this is graphics bug.
nether ctrl+alt+bks nor SAK kill X.

After 2 minute wait, kernel log doesn't show anything unusual.
printk times, jump that 2 minutes around wireless association, but I tested it without ath5k loaded
and still the same happens.

Also if I disable compiz, everything resumes correctly, and instantly.

> 
>> Also hibernate doesn't work on my main notebook, but it is probably
>> fixed, I update kernel to really latest -git
>> and tell you.
>>
> 
> But suspend to ram works?  Usually it is the other way round :).  If you
> haven't already, you might read
> 
>     Documentation/power/basic-pm-debugging.txt
> 
Well, this is long story
details at http://lkml.org/lkml/2008/9/20/75
speaking shortly, bios doesn't pass control to kernel on second resume.
Thus I don't test it, but I see how it works now.

Suspend to disk still doesn't work.
First of all system hangs in the end of image writeout.
If I power it down manually, and boot, system resumes from disk, and then hangs.
2.6.27 works fine.

(This is about my main notebook)


> it suggests some tests to narrow down the problem.
> 
>> Big thanks for bugfixes, you saved me a lot of work and bisecting.
>>
> 
> I can't take credit for actual fixes.  But I'm very happy to help people
> avoid bisecting for known problems.  I hope you have time to crack the
> unknown ones :).
> 
> Alan


Best regards,
	Maxim Levitsky


PS: sorry for late reply
