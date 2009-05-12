Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbZELQRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbZELQRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 12:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbZELQRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 12:17:06 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:41564 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbZELQRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 12:17:04 -0400
Message-ID: <4A09A09A.7030009@linux.vnet.ibm.com>
Date: Tue, 12 May 2009 09:15:22 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/5] perf_counter: rework ioctl()s
References: <20090508165219.469818319@chello.nl> <20090508170028.837558214@chello.nl> <18951.32643.749495.538351@drongo.ozlabs.ibm.com> <4A086A89.6030905@linux.vnet.ibm.com> <18952.36878.942836.803265@cargo.ozlabs.ibm.com> <4A08A8C6.1090302@linux.vnet.ibm.com> <18953.5194.205862.75538@drongo.ozlabs.ibm.com>
In-Reply-To: <18953.5194.205862.75538@drongo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Corey Ashford writes:
> 
>> I was seeing that on Power5.  On 5/6/2009, I sent along a test case that was 
>> supposed to duplicate the sequence of operations, without using PAPI, to Peter 
>> Zijlstra, cc'ing you.  However, I was unable to get any signals delivered to 
>> user space with that code, so I was unable to reproduce the problem outside of 
>> the PAPI test case.  I don't know why signal delivery doesn't work with that 
>> test case... I spent quite a lot of time verifying that it was doing the right 
>> thing, but could never get it to work.
> 
> I tried your test program out today, with the ioctl calls changed to
> add an extra 0 argument, like this:
> 
>    ioctl(fd[0], PERF_COUNTER_IOC_ENABLE, 0);
> 
> and similarly for the disable call.  It all seemed to be fine.  There
> is still a little problem with enabling counters - it doesn't happen
> right away.  I have a patch to fix that, which I'll send out, and with
> that patch I get:
> 
> # ./test_group_disable 
> evt[0].config = 0
> evt[1].config = 4
> group_leader = -1
> evt[i].wakeup_events = 0
> successfully opened evt[0].  fd[0] = 3
> group_leader = 3
> evt[i].wakeup_events = 0
> successfully opened evt[1].  fd[1] = 4
> successfully attached signal handler
> fd 3's mmap buffer is located at 0xfffab4b3000
> successfully tuned up fd 3
> fd 4's mmap buffer is located at 0xfffab4aa000
> successfully tuned up fd 4
> enable was successful
> CYCLES: 20904
> BRANCHES: 2413
> signal received while counters are enabled. fd = 3
> signal received while counters are enabled. fd = 3
> signal received while counters are enabled. fd = 3
> signal received while counters are enabled. fd = 3
> signal received while counters are enabled. fd = 3
> signal received while counters are enabled. fd = 4
> signal received while counters are enabled. fd = 3
> signal received while counters are enabled. fd = 3
> signal received while counters are enabled. fd = 3
> signal received while counters are enabled. fd = 3
> signal received while counters are enabled. fd = 3
> signal received while counters are enabled. fd = 3
> signal received while counters are enabled. fd = 4
> signal received while counters are enabled. fd = 3
> signal received while counters are enabled. fd = 3
> signal received while counters are enabled. fd = 3
> signal received while counters are enabled. fd = 3
> signal received while counters are enabled. fd = 3
> signal received while counters are enabled. fd = 3
> signal received while counters are enabled. fd = 4
> signal received while counters are enabled. fd = 3
> signal received while counters are enabled. fd = 3
> signal received while counters are enabled. fd = 3
> disable was successful
> CYCLES: 180149676
> BRANCHES: 30030826
> CYCLES: 180149676
> BRANCHES: 30030826
> CYCLES data_head: 141b0
> BRANCHES data_head: 35a0
> #
> 
> So clearly it is getting signals when the leader is enabled, one per
> page of events, and not when the leader is disabled.  I notice you
> have evt[].wakeup_events set to 0, which is presumably why we don't
> get more signals than we do.

Interesting. Thanks for finding that ioctl error!  That really had me 
stumped.

Another hypothesis is that the old PAPI code would open, mmap, close, 
then reopen, and mmap again.  I wonder if because I wasn't munmap'ing 
before the close, that I got some strange behavior from the kernel. 
I'll try that today with that test case.

Thanks!

- Corey


