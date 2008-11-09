Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbYKIKnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbYKIKnr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 05:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbYKIKng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 05:43:36 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:2571 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbYKIKne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 05:43:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=fLPvzGOhSw2GibTqjdT2/iUXtrtSzCI0VqlxgFm9j5Ujq8uD0VarRmDC2s6cjVeL+Q
         SYqOCKlv3xT5lPz5rR8G6KWGPVTz/hcAPe1kl9KTjVOJNXTL1itLiOxCaV84YfOKYlSJ
         GaeCMyRqG2q6ftSLj95qWbK8E1e1nbbI6XEpM=
Message-ID: <4916BED0.4090700@tuffmail.co.uk>
Date: Sun, 09 Nov 2008 10:43:28 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: Bugs on aspire one A150
References: <491506DB.1070000@gmail.com> <49157E97.60503@tuffmail.co.uk> <49163435.20301@gmail.com>
In-Reply-To: <49163435.20301@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Levitsky wrote:
> Alan Jenkins wrote:
>> Maxim Levitsky wrote:
>>> I have just bought an Aspire one A150, XP version,
>>> as it was the only available here, and installed ubuntu on it.
>>>
>>> Bugs I discovered so far:
>>>
>>>
>>> ** 1 - embedded controler works in polling mode, due to this:
>>>
>>> [    0.708571] ACPI: EC: non-query interrupt received, switching to
>>> interrupt mode
>>> [    1.224043] ACPI: EC: missing confirmations, switch off interrupt
>>> mode.
>>>
>>>
>>> Maybe this is the reason for the fact that gnome power manager
>>> freezes when I unplug
>>> the AC, and freezes often when I try to see battery status.
>>>
>>>
>>> (Note: same is seen on my acer aspire 5720)
>>
>> That sounds like a known issue.  It has been resolved by "ACPI: EC:
>> revert msleep patch".  Happily Len submitted it for mainline this
>> week.  You will also find it if you try the acpi-test git tree. 
>> We're all hoping 2.6.28 will be much improved in terms of reliable
>> operation of different ECs :).
>>
> Yes, this almost fixes all issues with that.
> Almost because, it looks like the EC changes screen brightness on his
> own when battery is plugged/unplugged,
> but so does the gnome-power-manager, and thus it still hangs as before
> on battery removal (but doesn't hang otherwise)
> I disabled that behaver in gnome-power-manager and now no more hangs.
>

Please do report it as an ACPI EC bug.  It's popular hardware, and if
nothing else it is important that upstream be aware of the workarounds
people are having to use.

> I see that this fix fixes the polled mode. Any chance to make irq mode
> work?
>

Probably not.  It doesn't seem important, it may not be possible, and
even if you could fix the EC driver for your hardware, there's the risk
of breaking other peoples hardware.

The presumption is that you have weird hardware and it genuinely needs a
polling workaround.  It's not too bad, now it uses udelay() it should
not impose any wakeups or significant latency, just some extra cpu time
in a busy loop.  EC events such as acpi hotkeys are still received as
interrupts (although we then have to query the type of event using a
polled transaction).


I assume you get something like (text not exact):

"EC: started in polling mode"
...
"EC: non-query interrupt received, switching to interrupt mode"
...
"EC: missing confirmations, switching to polling mode"

all during boot.


There's one outstanding issue on a different machine, where the
occasional EC read fails and triggers polling mode sometime _after_
boot.  It can be fixed by retrying the transaction

    http://bugzilla.kernel.org/show_bug.cgi?id=11896

but I don't really expect your machine has the same problem.

<snip non-acpi problems>

>
> Also noticed another bug:
>
>
> If I suspend/resume with compiz running, on resume I see wallpaper and
> mouse cursor, everything hangs for minute or two, and sometimes forever.
>
> 2.6.27 worked fine.

Weird.

Did you try sysrq-W during the hang?  That's supposed to dump a list of
blocked tasks to dmesg.

>
> Also hibernate doesn't work on my main notebook, but it is probably
> fixed, I update kernel to really latest -git
> and tell you.
>

But suspend to ram works?  Usually it is the other way round :).  If you
haven't already, you might read

    Documentation/power/basic-pm-debugging.txt

it suggests some tests to narrow down the problem.

>
> Big thanks for bugfixes, you saved me a lot of work and bisecting.
>

I can't take credit for actual fixes.  But I'm very happy to help people
avoid bisecting for known problems.  I hope you have time to crack the
unknown ones :).

Alan
