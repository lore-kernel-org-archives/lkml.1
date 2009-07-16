Return-Path: <linux-kernel-owner+w=401wt.eu-S933625AbZGPXik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625AbZGPXik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 19:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933616AbZGPXij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 19:38:39 -0400
Received: from smtpout.cs.fsu.edu ([128.186.122.75]:1987 "EHLO mail.cs.fsu.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933609AbZGPXii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 19:38:38 -0400
Date: Thu, 16 Jul 2009 19:38:36 -0400
From: Ted Baker <baker@cs.fsu.edu>
To: Karthik Singaram Lakshmanan <karthiksingaram@gmail.com>
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
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
Message-ID: <20090716233836.GF27757@cs.fsu.edu>
References: <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir> <1247505941.7500.39.camel@twins> <5B78D181-E446-4266-B9DD-AC0A2629C638@soe.ucsc.edu> <20090713201305.GA25386@cs.fsu.edu> <4A5BAAE7.5020906@nortel.com> <20090715231109.GH14993@cs.fsu.edu> <1247731113.15471.24.camel@twins> <20090716221514.GC27757@cs.fsu.edu> <1ca41c0f0907161534j1918bb44m73f8005d47258534@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ca41c0f0907161534j1918bb44m73f8005d47258534@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 05:34:25PM -0500, Karthik Singaram Lakshmanan wrote:

> Just chiming in that from an implementation perspective, we could use
> a priority bitmap of active tasks contending for the lock. An
> implementation similar to the one used by the O(1) scheduler can be of
> great use here. Hardware support like "find_first_bit" can drastically
> reduce the time taken to search for the highest-priority task pending
> on the lock. Given realistic values for the number of distinct
> priority values required by most practical systems, such an
> implementation could prove effective.

This does not solve the problem of avoiding queue reordering in
response to dynamic priority changes, since where you insert the
task in the queue (including the bit setting for the priority and
the linking/unlinking) depends on the curent priority.

This queue reordering is a huge pain, since you need to do it not
only whenever a priority is explicitly changed by the user; you
need to do it whenever a task gains or loses priority through
inheritance.  The latter can happen asynchronously, in response to
a time-out or signal, for example.

By the way, the use of bit-maps is very appealing for the O(1)
operations, including bit-scan, especially if your machine has
atomic set/test bit instructions.  We used this structure for some
single-processor RT kernels in the 1980's.  The task scheduling
and sleep/wakeup operations were just a few instructions.  However
the use of bit-maps forced us to set a fixed limit on the number
of tasks in the system.  We also could not change priorities
without doing an ugly (non-atomic) re-shuffling of the structures.

You are proposing one bit per priority level, of course, rather
than one bit per task.  This allows you to use linked lists within
priorities, but you lose the one-instruction suspend/unsuspend.

It is not immediately obvious how to extend this technique to
deadline-based scheduling.

There can only be a finite number of distinct deadlines in a
system at any one time.  So at any point in time a finite number
of bits is sufficient.  The problem is that the deadlines are
advancing, so a fixed mapping of bit positions to deadlines does
not work.   

There is one way this can be used with EDF, at least for a single
processor, which is related to the way I came up with the SRP.  If
you keep a stack of preempting tasks (earliest deadline on top),
the positions in the stack do map nicely to a bit vector.

You then need some other structure for the tasks with deadlines
later than the bottom of your stack.

I don't see how this generalizes to SMP.

Ted



