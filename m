Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbYIATgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbYIATgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 15:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYIATg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 15:36:28 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:53907 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750737AbYIATg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 15:36:28 -0400
Message-ID: <48BC444D.5030601@lwfinger.net>
Date: Mon, 01 Sep 2008 14:36:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 1 Sep 2008, Larry Finger wrote:
>> Thomas Gleixner wrote:
>>>> The critical differences in the dmesg output between the "good" and "bad"
>>>> results indicate a factor of 2 difference in the clock speed, and are
>>>> shown
>>>> below:
>>>> +Clocksource tsc unstable (delta = 500037272 ns)
>>>> -Clocksource tsc unstable (delta = 83950402 ns)
>>> In both cases the TSC is ahead of the pm_timer, which looks like the
>>> pm_timer is behaving strange.
>>>
>>> Can you please disable the pm_timer (in the kernel config,
>>> unfortunately there is no command line option for that) for a test and
>>> provide the relevant output of demsg ?
>> It took a while to figure out how to kill the pm_timer. I finally did it by
>> changing the default to no rather than yes. I also reset the bisection and
>> compiled a full -rc4 kernel.
>>
>> What I hope is the relevant output of dmesg is below. The clock rate is
>> correctly determined, and the b43legacy errors are gone.
> 
> Hmm. Haven't seen that before, but if confirms what I guessed from
> your previous dmesg information. I wonder why you did not observe
> strange behaviour with older kernel versions. I don't mean the
> b43legacy errors, which might be caused by the wrong calibrated TSC,
> but those even should show strange behaviour vs. time.
> 
> Can you please provide the output of an older "working" kernel version
> from:
> 
> # cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> 
> after the TSC was set to unstable. It should say acpi_pm.
> 
> If that's the case please run
>  
> # time sleep 60
> 
> on a shell and provide the output and verify it against a knwn to be
> halfways correct stopwatch.
> 
> Then do the same on the current mainline with pm_timer
> disabled. current clocksource should be either jiffies or tsc.

Both the openSUSE 2.6.22 kernel and the one with the pm_timer disabled 
return "pit". I don't think pm_timer had ever been used until the 
commit in question.

The timed sleep is as accurate as I can measure.

I put in some test prints. The value of pm2 is zero when the else 
branch of the "if (hpet)" is entered; however, pm1 is 15768471. When 
we reach the do_div(tsc2, tsc1) statement, tsc2 is zero, which I think 
means that the two calls to tsc_read_refs() are returning the same 
junk value.

Larry
