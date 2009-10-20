Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbZJTTCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbZJTTCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 15:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbZJTTCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 15:02:03 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:57231 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbZJTTCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 15:02:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Ux+KzVLb5U5pIIrU8JhNk9sJG6/v0ubzYGsLiDET//CCpXIVjfOWbUyNrlQXsxQbs5
         8O1Oc7VReyxVuNjt7sKvDTKeiltyBSunPIqnwflTJy+9uQ1vara5MF+IC+KpXyJhNOvb
         M0twAT2SyXCRDfthkrOX41o4QH01ll7Pnvn5w=
Message-ID: <4ADE0928.6080104@clamav.net>
Date: Tue, 20 Oct 2009 22:02:00 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwin@clamav.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, aCaB <acab@clamav.net>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Mutex vs semaphores scheduler bug
References: <1255359207.10420.31.camel@twins> <4AD0A0F7.9070700@clamav.net>	 <24718.1255650266@redhat.com> <1255793527.8152.4.camel@laptop>
In-Reply-To: <1255793527.8152.4.camel@laptop>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-10-17 18:32, Peter Zijlstra wrote:
> On Fri, 2009-10-16 at 00:44 +0100, David Howells wrote:
>> Peter Zijlstra <peterz@infradead.org> wrote:
>>
>>> The problem appears to be that rwsem doesn't allow lock-stealing
>> With good reason.  rwsems can be read or write locked for a long time - so if
>> readers can jump the queue on read-locked rwsems, then writer starvation is a
>> real possibility.  I carefully implemented it so that it is a strict FIFO to
>> avoid certain problems I was having.
> 
> Well, it kinda sucks that rwsem is slower than a mutex.
> 
> What about allowing writer stealing when the next contending task is a
> writer?
> 

Also can the scheduler be improved so it doesn't unnecessarily wake up
processes if they can't take the semaphore?

AFAICT (in linux 2.6.31.3) this is what happens:
 semaphore fails to get acquired -> rwsem.c:rwsem_down_failed_common
  -> if nobody holds the semaphore, wake up the process(es) that can
acquire it
  -> loop calling schedule(), until woken

 the thread holding the semaphore releases it (no wakeups!), and the
scheduler will schedule the next process

There are several things that are suboptimal here IMHO:
1. The task calls schedule(), but does that prevent the scheduler from
scheduling it again if waiter->task is non-null? If not, then there are
useless wakeups (task gets scheduled, waiter->task is non-null, task
calls schedule again).

2. The process in the front of the queue is woken only if there was
contention, which introduces unnecessary latency for the task in the
front of the queue waiting for the semaphore.

3. Due to 2) a task on another CPU waiting for the semaphore is only
woken: when schedule() is called, when another thread tries to acquire
the lock and fails

Suggested solution:
schedule() should know that scheduling this process is useless, it won't
get the lock, so it shouldn't attempt to schedule it (maybe by setting a
flag in the task state).
When a thread releases a semaphore, it should also try to wake other
threads that were waiting on it (if any).

With both of these changes the scheduler will know that when it
schedules the task it'll be able to acquire the semaphore (it was called
by wake_up_process in rwsem_do_wake which will clear the do-not-wake
flag). Also the thread will be scheduled as soon as another thread (on
another CPU) released the semaphore, and it doesn't need to wait for the
timeslice to elapse.

Here is a snippet of ftrace of sched_switch:
<...>-27515 [000] 44338.386867:  27515:120:R   + [000] 27522:120:D <...>
           <...>-27515 [000] 44338.386868:  27515:120:R   + [000]
27511:120:D <...>
           <...>-27515 [000] 44338.386869:  27515:120:R   + [001]
27523:120:D <...>
           <...>-27515 [000] 44338.386875:  27515:120:R   + [003]
27512:120:D <...>
           <...>-27515 [000] 44338.386877:  27515:120:R   + [000]
27517:120:S <...>
           <...>-27515 [000] 44338.386905:  27515:120:D ==> [000]
27517:120:R <...>
           <...>-27517 [000] 44338.386907:  27517:120:S ==> [000]
27522:120:R <...>
           <...>-27522 [000] 44338.386915:  27522:120:D ==> [000]
27511:120:R <...>
           <...>-27511 [000] 44338.386917:  27511:120:R   + [001]
27523:120:D <...>
           <...>-27511 [000] 44338.386918:  27511:120:D ==> [000]
0:140:R <idle>
          <idle>-0     [000] 44338.386973:      0:140:R ==> [000]
27522:120:R <...>

If I interpret this correctly 27515 wakes a bunch of readers (27511,
27523, 27512, 27517), then it switches to 27517.
However 27517 immediately schedules again (!) after 2ns, wakes 27522, it
runs for 8ns, then schedules to 27511, which runs for a short while
again, finally it schedules to idle. All this scheduling ping-pong looks
like a waste, none of the tasks woken up did useful work.

Another situation is this scheduler ping-pong with md4_raid10, notice
how 27961 wakes up md4_raid10, switches to it, md4_raid10 schedules back
to 27961, which then schedules to idle (2ns later). md4_raid10 could
have gone directly to idle ....:

md4_raid10-982   [000] 44746.579830:    982:115:S ==> [000] 27961:120:R
lt-clamd
        lt-clamd-27964 [003] 44746.579892:  27964:120:R   + [001]
27966:120:D lt-clamd
        lt-clamd-27964 [003] 44746.580065:  27964:120:D ==> [003]
0:140:R <idle>
        lt-clamd-27961 [000] 44746.580069:  27961:120:R   + [003]
27964:120:D lt-clamd
          <idle>-0     [003] 44746.580073:      0:140:R ==> [003]
27964:120:R lt-clamd
        lt-clamd-27961 [000] 44746.580912:  27961:120:R   + [002]
27960:120:S lt-clamd
        lt-clamd-27961 [000] 44746.580945:  27961:120:D   + [000]
982:115:S md4_raid10
        lt-clamd-27961 [000] 44746.580946:  27961:120:D ==> [000]
982:115:R md4_raid10
      md4_raid10-982   [000] 44746.580948:    982:115:S ==> [000]
27961:120:D lt-clamd
        lt-clamd-27961 [000] 44746.580950:  27961:120:D ==> [000]
0:140:R <idle>
        lt-clamd-27964 [003] 44746.581054:  27964:120:R   + [000]
27961:120:D lt-clamd
          <idle>-0     [000] 44746.581064:      0:140:R ==> [000]
27961:120:R lt-clamd
        lt-clamd-27964 [003] 44746.581092:  27964:120:R   + [002]
27960:120:S lt-clamd
        lt-clamd-27964 [003] 44746.581125:  27964:120:D   + [000]
982:115:S md4_raid10
        lt-clamd-27964 [003] 44746.581128:  27964:120:D ==> [003]
27965:120:R lt-clamd
        lt-clamd-27961 [000] 44746.581128:  27961:120:R ==> [000]
982:115:R md4_raid10


Best regards,
--Edwin
