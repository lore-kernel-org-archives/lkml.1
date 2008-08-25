Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbYHYVbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbYHYVbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 17:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbYHYVbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 17:31:33 -0400
Received: from smtpauth.hypersurf.com ([209.237.0.8]:60392 "EHLO
	smtpauth.hypersurf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbYHYVbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 17:31:32 -0400
Message-ID: <48B32468.7090601@hypersurf.com>
Date: Mon, 25 Aug 2008 14:30:16 -0700
From: Kevin Diggs <kevdig@hypersurf.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i486; en-US; rv:1.8b2) Gecko/20050724
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Add low level PLL config register interface module
References: <48B28C62.2000600@hypersurf.com> <5430DEC7-39DB-4316-8E7E-949CA4280403@kernel.crashing.org>
In-Reply-To: <5430DEC7-39DB-4316-8E7E-949CA4280403@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> 
> On Aug 25, 2008, at 5:41 AM, Kevin Diggs wrote:
> 
>> This adds a small module to handle the low level details of dealing  
>> with the
>> PLL config register (HID1) found in the IBM 750GX. It provides 2  
>> possible
>> interfaces, both selectable via kernel config options. One is a  sysfs 
>> attribute
>> and the other is a normal function API. It is called pll_if.
>>
>> The determination of the bus frequency is what worked on a PowerMac  
>> 8600. Any
>> suggestions on a more general solution are welcome.
>>
>> WARNING - I used some #ifdefs - Let the fur fly!
>>
>> My name is Kevin Diggs and I approve this patch.
> 
> 
> This really should be split into two patches.  One for the perl script  
> and one for the actual kernel code.
> 
First, thanks for taking the time for the review!

I can do that. But how? Do I respin everything as x/5? Do I only send out
the PERL script as 5/4? Do I redo patch 1 as 1a/4 and 1b/4 (or 1.1/4 and
1.2/4)?

> Scanning the actual kernel code you have a lot of #ifdef's that should  
> be cleaned up:
> 
> Can't #ifdef CONFIG_PPC_750GX_DUAL_PLL_IF_SYSFS just be #ifdef  
> CONFIG_SYSFS and the same for CONFIG_PPC_750GX_DUAL_PLL_IF_HRTIMER &  
> CONFIG_PPC_750GX_DUAL_PLL_IF_CPU_FREQ?
> 
I like flexibility. So I allow this module to be configured with either
one or both (or none - if you just want some dead code!) of the available
interfaces. As an example, CONFIG_..._PLL_IF_SYSFS adds the sysfs
attribute to directly control the PLL from user space via writes to the
attribute file under /sys. On my system, a PowerMac 8600, this shows up in
/sys/devices/system/cpu/cpu0/ppc750gxpll. CONFIG_..._PLL_IF_CPU_FREQ adds
the public API functions that are used by the cpufreq driver.
CONFIG_..._PLL_IF_HRTIMER causes it to use the HR timer stuff. This
results in MUCH lower latencies (102 usec vs 3900 usec (HZ=250)). But I
did not want to REQUIRE HR timers (even though they are pretty cool!).
Did I mention that I like flexibility?

Seriously, should I add a check that at least one of ..._SYSFS or
..._CPU_FREQ is defined and refuse to compile otherwise? Via a pragma
or something?

> #ifdef CONFIG_PPC_OF seems unnecessary as all PPC always has this set.
> 
I ... uh ... have no idea? Should I remove it?

> What's up with #define MULFIRST and the #if 0?
> 
This was just some goofing off in a debug message. I was playing around
trying to see what effect various code arrangements had on accuracy.
Since this is in debug code I was kinda hoping for some leniancy.

The "#if 0" is removing code that ... prevented preemption between the
processor speed switch and the changing of the loops_per_jiffy value.
The idea was that I did not want to change any sleeps. I now think
that processor speed is not a determining factor in delays. I think
the time base register (or decrementer) are used. I don't even change
the loops_per_jiffy any more (Maybe that is incorrect?). I left this
code in there to potentially jog my memory if I find myself debugging
some problem in the future? Would a comment be helpful?

> - k
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
> 
> 
At the tone the timebase will be 12499983. No trailing 0s. Very bad
for accuracy.
