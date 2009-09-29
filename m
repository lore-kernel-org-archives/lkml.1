Return-Path: <linux-kernel-owner+w=401wt.eu-S1751609AbZI2Un1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbZI2Un1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 16:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbZI2Un1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 16:43:27 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:53535 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZI2Un0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 16:43:26 -0400
Message-ID: <4AC2712C.4080901@gmail.com>
Date: Tue, 29 Sep 2009 22:42:20 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Linux 2.6.32-rc1
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain>	<4AC060AE.1090401@gmail.com>	<alpine.LFD.2.01.0909280829100.3349@localhost.localdomain> <20090928191506.40b61793@mschwide.boeblingen.de.ibm.com> <4AC10365.7090802@gmail.com>
In-Reply-To: <4AC10365.7090802@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 29 Sep 2009 22:42:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Martin Schwidefsky a écrit :
>> On Mon, 28 Sep 2009 08:39:31 -0700 (PDT)
>> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>>> On Mon, 28 Sep 2009, Eric Dumazet wrote:
>>>> Linus Torvalds a écrit :
>>>>> Go wild, test it out, and let us know about any regressions you find,
>>>> Something seems wrong with process time accounting.
>>>>
>>>> Following program should consume 10*8 seconds of cpu on a 8 cpu machine, but
>>>> with 2.6.32-rc1 numbers are crazy.
>>> Ok, so the top-level process time looks sane _while_ the thing is running 
>>> (sum of all threads), but the per-thread times look broken (as if they had 
>>> randomly had the times of the other threads added into them - looks to me 
>>> like they on average had half the other threads' time accounted into 
>>> them).
>>>
>>> And then at the end, it looks like the time of the threads (which was 
>>> over-accounted) get re-accounted back into the main process, so the final 
>>> time is indeed wildly inflated.
>>>
>>> IOW, looks like we're adding thread times multiple times to other threads 
>>> (and then finally to the parent).
>>>
>>> I'm adding the usual suspects to the cc, and leaving your results and 
>>> test-program quoted here for them.. Thomas, Martin, John - if you're not 
>>> the people I should blame for this, let me know.
>> Uh-oh.. usual suspects, eh?
>>
>> For starters I run the test program on an s390 with
>> VIRT_CPU_ACCOUNTING=y:
>>
>> time ./burn-cpu 
>>   PID TTY      STAT   TIME COMMAND 
>>  2979 pts/0    -      0:08 ./burn-cpu
>>     - -        Sl+    0:00 -         
>>     - -        Rl+    0:01 -         
>>     - -        Rl+    0:01 -         
>>     - -        Rl+    0:01 -         
>>     - -        Rl+    0:01 -         
>>     - -        Rl+    0:01 -         
>>     - -        Rl+    0:01 -         
>>     - -        Rl+    0:01 -         
>>     - -        Rl+    0:01 -         
>>   PID TTY      STAT   TIME COMMAND   
>>  2979 pts/0    -      0:16 ./burn-cpu
>>     - -        Sl+    0:00 -         
>>     - -        Rl+    0:02 -         
>>     - -        Rl+    0:02 -         
>>     - -        Rl+    0:02 -         
>>     - -        Rl+    0:02 -         
>>     - -        Rl+    0:02 -         
>>     - -        Rl+    0:02 -         
>>     - -        Rl+    0:02 -         
>>     - -        Rl+    0:02 -         
>>   PID TTY      STAT   TIME COMMAND   
>>  2979 pts/0    -      0:25 ./burn-cpu
>>     - -        Sl+    0:00 -         
>>     - -        Rl+    0:03 -         
>>     - -        Rl+    0:03 -         
>>     - -        Rl+    0:03 -         
>>     - -        Rl+    0:03 -         
>>     - -        Rl+    0:03 -         
>>     - -        Rl+    0:03 -         
>>     - -        Rl+    0:03 -         
>>     - -        Rl+    0:03 -         
>>   PID TTY      STAT   TIME COMMAND   
>>  2979 pts/0    -      0:33 ./burn-cpu
>>     - -        Sl+    0:00 -         
>>     - -        Rl+    0:04 -         
>>     - -        Rl+    0:04 -         
>>     - -        Rl+    0:04 -         
>>     - -        Rl+    0:04 -         
>>     - -        Rl+    0:04 -         
>>     - -        Rl+    0:04 -         
>>     - -        Rl+    0:04 -         
>>     - -        Rl+    0:04 -         
>>   PID TTY      STAT   TIME COMMAND   
>>  2979 pts/0    -      0:41 ./burn-cpu
>>     - -        Sl+    0:00 -         
>>     - -        Rl+    0:05 -         
>>     - -        Rl+    0:05 -         
>>     - -        Rl+    0:05 -         
>>     - -        Rl+    0:05 -         
>>     - -        Rl+    0:05 -         
>>     - -        Rl+    0:05 -         
>>     - -        Rl+    0:05 -         
>>     - -        Rl+    0:05 -         
>>   PID TTY      STAT   TIME COMMAND   
>>  2979 pts/0    -      0:50 ./burn-cpu
>>     - -        Sl+    0:00 -
>>     - -        Rl+    0:06 -
>>     - -        Rl+    0:06 -
>>     - -        Rl+    0:06 -
>>     - -        Rl+    0:06 -
>>     - -        Rl+    0:06 -
>>     - -        Rl+    0:06 -
>>     - -        Rl+    0:06 -
>>     - -        Rl+    0:06 -
>>   PID TTY      STAT   TIME COMMAND
>>  2979 pts/0    -      0:58 ./burn-cpu
>>     - -        Sl+    0:00 -
>>     - -        Rl+    0:07 -
>>     - -        Rl+    0:07 -
>>     - -        Rl+    0:07 -
>>     - -        Rl+    0:07 -
>>     - -        Rl+    0:07 -
>>     - -        Rl+    0:07 -
>>     - -        Rl+    0:07 -
>>     - -        Rl+    0:07 -
>>   PID TTY      STAT   TIME COMMAND
>>  2979 pts/0    -      1:07 ./burn-cpu
>>     - -        Sl+    0:00 -
>>     - -        Rl+    0:08 -
>>     - -        Rl+    0:08 -
>>     - -        Rl+    0:08 -
>>     - -        Rl+    0:08 -
>>     - -        Rl+    0:08 -
>>     - -        Rl+    0:08 -
>>     - -        Rl+    0:08 -
>>     - -        Rl+    0:08 -
>>   PID TTY      STAT   TIME COMMAND
>>  2979 pts/0    -      1:15 ./burn-cpu
>>     - -        Sl+    0:00 -
>>     - -        Rl+    0:09 -
>>     - -        Rl+    0:09 -
>>     - -        Rl+    0:09 -
>>     - -        Rl+    0:09 -
>>     - -        Rl+    0:09 -
>>     - -        Rl+    0:09 -
>>     - -        Rl+    0:09 -
>>     - -        Rl+    0:09 -
>>   PID TTY      STAT   TIME COMMAND
>>  2979 pts/0    -      1:25 ./burn-cpu
>>     - -        S+     1:25 -
>>
>> real    0m10.708s
>> user    1m25.051s
>> sys     0m0.174s
>>
>> looks better, gives an average of 10.63 seconds per thread and the per
>> thread numbers are fine. I'll see what happens with the test case on my
>> pc@home.
>>
> 
> 
> I did a bisection and found commit def0a9b2573e00ab0b486cb5382625203ab4c4a6
> was the origin of the problem on my x86_32 machine.
> 
> def0a9b2573e00ab0b486cb5382625203ab4c4a6 is first bad commit
> commit def0a9b2573e00ab0b486cb5382625203ab4c4a6
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Fri Sep 18 20:14:01 2009 +0200
> 
>     sched_clock: Make it NMI safe
> 
>     Arjan complained about the suckyness of TSC on modern machines, and
>     asked if we could do something about that for PERF_SAMPLE_TIME.
> 
>     Make cpu_clock() NMI safe by removing the spinlock and using
>     cmpxchg. This also makes it smaller and more robust.
> 
>     Affects architectures that use HAVE_UNSTABLE_SCHED_CLOCK, i.e. IA64
>     and x86.
> 
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     LKML-Reference: <new-submission>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 

Pretty calm lkml these days... must be some kind of event in the states ? :)

Checking this commit, I believe problem comes from cmpxchg(), which doesnt 
handle 64 bit on X86_32 (no compilation error, and  null operation :( )

We have two (or three choices) :

1) Use cmpxchg64()

2) Fix cmpxchg() to handle 64bit as well (or issue a compilation error)

3) Revert Peter patch :(

Here is the patch I used to get proper operation.

[PATCH] sched_clock: Use cmpxchg64()

Commit def0a9b2573e00ab0b486cb5382625203ab4c4a6 
(sched_clock: Make it NMI safe) assumed cmpxchg() of 64bit values was available on X86_32

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---

diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index ac2e1dc..479ce56 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -127,7 +127,7 @@ again:
 	clock = wrap_max(clock, min_clock);
 	clock = wrap_min(clock, max_clock);
 
-	if (cmpxchg(&scd->clock, old_clock, clock) != old_clock)
+	if (cmpxchg64(&scd->clock, old_clock, clock) != old_clock)
 	goto again;
 
 	return clock;
@@ -163,7 +163,7 @@ again:
 	val = remote_clock;
 	}
 
-	if (cmpxchg(ptr, old_val, val) != old_val)
+	if (cmpxchg64(ptr, old_val, val) != old_val)
 		goto again;
 
 	return val;
