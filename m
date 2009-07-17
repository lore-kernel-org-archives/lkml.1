Return-Path: <linux-kernel-owner+w=401wt.eu-S933950AbZGQBoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933950AbZGQBoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 21:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933931AbZGQBoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 21:44:12 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:57971 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933497AbZGQBoL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 21:44:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jLyWTq6Wcm87OINHF9PvmPmGAB/+BCaiK/FfMLtFNjhcy5F3v37GYDMIjNE8BPGCzh
         WBN2V+9tGSa8N5Ird5YUmQ0acm1nvAvzwhAOH08I5/Ub/qcS2jb/b7iS0ODmoeg4McuT
         rAB6yw45/2J76mU386Bdy+z6YyW/+hJKVwE+g=
MIME-Version: 1.0
In-Reply-To: <20090716233836.GF27757@cs.fsu.edu>
References: <1247412708.6704.105.camel@laptop> <1247505941.7500.39.camel@twins>
	 <5B78D181-E446-4266-B9DD-AC0A2629C638@soe.ucsc.edu>
	 <20090713201305.GA25386@cs.fsu.edu> <4A5BAAE7.5020906@nortel.com>
	 <20090715231109.GH14993@cs.fsu.edu> <1247731113.15471.24.camel@twins>
	 <20090716221514.GC27757@cs.fsu.edu>
	 <1ca41c0f0907161534j1918bb44m73f8005d47258534@mail.gmail.com>
	 <20090716233836.GF27757@cs.fsu.edu>
Date: Thu, 16 Jul 2009 21:44:09 -0400
Message-ID: <1ca41c0f0907161844l14176743y3520b1376389bfc@mail.gmail.com>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Karthik Singaram Lakshmanan <karthiksingaram@gmail.com>
To: Ted Baker <baker@cs.fsu.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, Chris Friesen <cfriesen@nortel.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>, Raistlin <raistlin@linux.it>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>, Raj Rajkumar <raj@ece.cmu.edu>,
       dionisio@sei.cmu.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This does not solve the problem of avoiding queue reordering in
> response to dynamic priority changes, since where you insert the
> task in the queue (including the bit setting for the priority and
> the linking/unlinking) depends on the curent priority.
>

I completely agree with this. The bit map needs to be modified for
dynamic priority changes. However, atomic operations (like
Compare-And-Swap) can be used to modify the bitmap. Barring any
(highly unlikely but bounded) contention scenarios from other
processors, this implementation would still continue to be efficient
than maintaining a priority-ordered queue.

> By the way, the use of bit-maps is very appealing for the O(1)
> operations, including bit-scan, especially if your machine has
> atomic set/test bit instructions.  We used this structure for some
> single-processor RT kernels in the 1980's.  The task scheduling
> and sleep/wakeup operations were just a few instructions.  However
> the use of bit-maps forced us to set a fixed limit on the number
> of tasks in the system.  We also could not change priorities
> without doing an ugly (non-atomic) re-shuffling of the structures.
>
> You are proposing one bit per priority level, of course, rather
> than one bit per task.  This allows you to use linked lists within
> priorities, but you lose the one-instruction suspend/unsuspend.
>

We can still maintain the O(1) instruction-suspend/unsuspend, if we
maintain a counter for each priority level.

(a) When a task suspends on a lock, we can do an atomic increment of
the counter for its priority level and set the bit on the priority map
of tasks waiting for the lock. Attaching the task to a
per-priority-level linked list queue should take O(1) assuming that
there is a tail pointer.

(b) When the lock is released, find the highest priority bit set on
the lock's priority map, index into the appropriate per-priority-level
linked list, and wake up the task at the head of the queue (delete
operation with O(1)). Do an atomic decrement of the counter, if it
reaches zero unset the bit on the priority map.

While there are still contention issues that arise with updating the
linked list and counters, these are restricted to tasks within the
same priority level (highly unlikely that multiple tasks from the same
priority level decide to acquire the same lock within a window of a
couple of instructions), and should be much less than the contention
arising from all the tasks in the system.

> It is not immediately obvious how to extend this technique to
> deadline-based scheduling.
>
> There can only be a finite number of distinct deadlines in a
> system at any one time.  So at any point in time a finite number
> of bits is sufficient.  The problem is that the deadlines are
> advancing, so a fixed mapping of bit positions to deadlines does
> not work.
>
> There is one way this can be used with EDF, at least for a single
> processor, which is related to the way I came up with the SRP.  If
> you keep a stack of preempting tasks (earliest deadline on top),
> the positions in the stack do map nicely to a bit vector.
>
> You then need some other structure for the tasks with deadlines
> later than the bottom of your stack.
>
Yes. I did not think about EDF based schedulers when I proposed the
implementation mechanism. I believe we can work on the SRP idea to get
a corresponding version for EDF.

> I don't see how this generalizes to SMP.
>

I agree that there needs to be more work to generalize the idea to EDF
based schedulers on SMP, however, the idea still applies to
fixed-priority scheduling in the SMP context. Many SMP processors
support atomic instructions (for example:
http://software.intel.com/en-us/articles/implementing-scalable-atomic-locks-for-multi-core-intel-em64t-and-ia32-architectures/).
We can utilize these instructions to efficiently implement such locks
at least in fixed-priority schedulers (like Deadline Monotonic
Schedulers) for SMP systems.

Thanks
- Karthik
