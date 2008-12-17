Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757362AbYLQAiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbYLQAiA (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYLQAhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:37:48 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57759 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbYLQAhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:37:47 -0500
Date: Tue, 16 Dec 2008 16:37:44 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: cl@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org,
        manfred@colorfullife.com, dipankar@in.ibm.com,
        josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
        dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
        rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
        andi@firstfloor.org, tglx@linutronix.de
Subject: [PATCH -tip] v10 scalable classic RCU implementation
Message-ID: <20081217003744.GA26660@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081202222157.GA14911@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202222157.GA14911@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch fixes a long-standing performance bug in classic RCU that
results in massive internal-to-RCU lock contention on systems with
more than a few hundred CPUs.  Although this patch creates a separate
flavor of RCU for ease of review and patch maintenance, it is intended
to replace classic RCU.

This patch still handles stress better than does mainline, so I am still
calling it ready for inclusion.  This patch is against the -tip tree.
Nevertheless, experience on an actual 1000+ CPU machine would still be
most welcome.

Most of the changes noted below were found while creating an rcutiny
(which should permit ejecting the current rcuclassic) and while doing
detailed line-by-line documentation.

Updates from v9 (http://lkml.org/lkml/2008/12/2/334):

o	Fixes from remainder of line-by-line code walkthrough,
	including comment spelling, initialization, undesirable
	narrowing due to type conversion, removing redundant memory
	barriers, removing redundant local-variable initialization,
	and removing redundant local variables.

	I do not believe that any of these fixes address the CPU-hotplug
	issues that Andi Kleen was seeing, but please do give it a whirl
	in case the machine is smarter than I am.

	A writeup from the walkthrough may be found at the following
	URL, in case you are suffering from terminal insomnia or
	masochism:

	http://www.kernel.org/pub/linux/kernel/people/paulmck/tmp/rcutree-walkthrough.2008.12.16a.pdf

o	Made rcutree tracing use seq_file, as suggested some time
	ago by Lai Jiangshan.

o	Added a .csv variant of the rcudata debugfs trace file, to allow
	people having thousands of CPUs to drop the data into
	a spreadsheet.	Tested with oocalc and gnumeric.  Updated
	documentation to suit.

Updates from v8 (http://lkml.org/lkml/2008/11/15/139):

o	Fix a theoretical race between grace-period initialization and
	force_quiescent_state() that could occur if more than three
	jiffies were required to carry out the grace-period
	initialization.  Which it might, if you had enough CPUs.

o	Apply Ingo's printk-standardization patch.

o	Substitute local variables for repeated accesses to global
	variables.

o	Fix comment misspellings and redundant (but harmless) increments
	of ->n_rcu_pending (this latter after having explicitly added it).

o	Apply checkpatch fixes.

Updates from v7 (http://lkml.org/lkml/2008/10/10/291):

o	Fixed a number of problems noted by Gautham Shenoy, including
	the cpu-stall-detection bug that he was having difficulty
	convincing me was real.  ;-)

o	Changed cpu-stall detection to wait for ten seconds rather than
	three in order to reduce false positive, as suggested by Ingo
	Molnar.

o	Produced a design document (http://lwn.net/Articles/305782/).
	The act of writing this document uncovered a number of both
	theoretical and "here and now" bugs as noted below.

o	Fix dynticks_nesting accounting confusion, simplify WARN_ON()
	condition, fix kerneldoc comments, and add memory barriers
	in dynticks interface functions.

o	Add more data to tracing.

o	Remove unused "rcu_barrier" field from rcu_data structure.

o	Count calls to rcu_pending() from scheduling-clock interrupt
	to use as a surrogate timebase should jiffies stop counting.

o	Fix a theoretical race between force_quiescent_state() and
	grace-period initialization.  Yes, initialization does have to
	go on for some jiffies for this race to occur, but given enough
	CPUs...

Updates from v6 (http://lkml.org/lkml/2008/9/23/448):

o	Fix a number of checkpatch.pl complaints.

o	Apply review comments from Ingo Molnar and Lai Jiangshan
	on the stall-detection code.

o	Fix several bugs in !CONFIG_SMP builds.

o	Fix a misspelled config-parameter name so that RCU now announces
	at boot time if stall detection is configured.

o	Run tests on numerous combinations of configurations parameters,
	which after the fixes above, now build and run correctly.

Updates from v5 (http://lkml.org/lkml/2008/9/15/92, bad subject line):

o	Fix a compiler error in the !CONFIG_FANOUT_EXACT case (blew a
	changeset some time ago, and finally got around to retesting
	this option).

o	Fix some tracing bugs in rcupreempt that caused incorrect
	totals to be printed.

o	I now test with a more brutal random-selection online/offline
	script (attached).  Probably more brutal than it needs to be
	on the people reading it as well, but so it goes.

o	A number of optimizations and usability improvements:

	o	Make rcu_pending() ignore the grace-period timeout when
		there is no grace period in progress.

	o	Make force_quiescent_state() avoid going for a global
		lock in the case where there is no grace period in
		progress.

	o	Rearrange struct fields to improve struct layout.

	o	Make call_rcu() initiate a grace period if RCU was
		idle, rather than waiting for the next scheduling
		clock interrupt.

	o	Invoke rcu_irq_enter() and rcu_irq_exit() only when
		idle, as suggested by Andi Kleen.  I still don't
		completely trust this change, and might back it out.

	o	Make CONFIG_RCU_TRACE be the single config variable
		manipulated for all forms of RCU, instead of the prior
		confusion.

	o	Document tracing files and formats for both rcupreempt
		and rcutree.

Updates from v4 for those missing v5 given its bad subject line:

o	Separated dynticks interface so that NMIs and irqs call separate
	functions, greatly simplifying it.  In particular, this code
	no longer requires a proof of correctness.  ;-)

o	Separated dynticks state out into its own per-CPU structure,
	avoiding the duplicated accounting.

o	The case where a dynticks-idle CPU runs an irq handler that
	invokes call_rcu() is now correctly handled, forcing that CPU
	out of dynticks-idle mode.

o	Review comments have been applied (thank you all!!!).
	For but one example, fixed the dynticks-ordering issue that
	Manfred pointed out, saving me much debugging.  ;-)

o	Adjusted rcuclassic and rcupreempt to handle dynticks changes.

Attached is an updated patch to Classic RCU that applies a hierarchy,
greatly reducing the contention on the top-level lock for large machines.
This passes 10-hour concurrent rcutorture and online-offline testing on
128-CPU ppc64 without dynticks enabled, and exposes some timekeeping
bugs in presence of dynticks (exciting working on a system where
"sleep 1" hangs until interrupted...), which were fixed in the
2.6.27 kernel.  It is getting more reliable than mainline by some
measures, so the next version will be against -tip for inclusion.
See also Manfred Spraul's recent patches (or his earlier work from
2004 at http://marc.info/?l=linux-kernel&m=108546384711797&w=2).
We will converge onto a common patch in the fullness of time, but are
currently exploring different regions of the design space.  That said,
I have already gratefully stolen quite a few of Manfred's ideas.

This patch provides CONFIG_RCU_FANOUT, which controls the bushiness
of the RCU hierarchy.  Defaults to 32 on 32-bit machines and 64 on
64-bit machines.  If CONFIG_NR_CPUS is less than CONFIG_RCU_FANOUT,
there is no hierarchy.  By default, the RCU initialization code will
adjust CONFIG_RCU_FANOUT to balance the hierarchy, so strongly NUMA
architectures may choose to set CONFIG_RCU_FANOUT_EXACT to disable
this balancing, allowing the hierarchy to be exactly aligned to the
underlying hardware.  Up to two levels of hierarchy are permitted
(in addition to the root node), allowing up to 16,384 CPUs on 32-bit
systems and up to 262,144 CPUs on 64-bit systems.  I just know that I
am going to regret saying this, but this seems more than sufficient
for the foreseeable future.  (Some architectures might wish to set
CONFIG_RCU_FANOUT=4, which would limit such architectures to 64 CPUs.
If this becomes a real problem, additional levels can be added, but I
doubt that it will make a significant difference on real hardware.)

In the common case, a given CPU will manipulate its private rcu_data
structure and the rcu_node structure that it shares with its immediate
neighbors.  This can reduce both lock and memory contention by multiple
orders of magnitude, which should eliminate the need for the strange
manipulations that are reported to be required when running Linux on
very large systems.

Some shortcomings:

o	More bugs will probably surface as a result of an ongoing
	line-by-line code inspection.

	Patches will be provided as required.

o	There are probably hangs, rcutorture failures, &c.  Seems
	quite stable on a 128-CPU machine, but that is kind of small
	compared to 4096 CPUs.  However, seems to do better than
	mainline.

	Patches will be provided as required.

o	The memory footprint of this version is several KB larger
	than rcuclassic.

	A separate UP-only rcutiny patch will be provided, which will
	reduce the memory footprint significantly, even compared
	to the old rcuclassic.  One such patch passes light testing,
	and has a memory footprint smaller even than rcuclassic.
	Initial reaction from various embedded guys was "it is not
	worth it", so am putting it aside.

Credits:

o	Manfred Spraul for ideas, review comments, and bugs spotted,
	as well as some good friendly competition.  ;-)

o	Josh Triplett, Ingo Molnar, Peter Zijlstra, Mathieu Desnoyers,
	Lai Jiangshan, Andi Kleen, Andy Whitcroft, and Andrew Morton
	for reviews and comments.

o	Thomas Gleixner for much-needed help with some timer issues
	(see patches below).

o	Jon M. Tollefson, Tim Pepper, Andrew Theurer, Jose R. Santos,
	Andy Whitcroft, Darrick Wong, Nishanth Aravamudan, Anton
	Blanchard, Dave Kleikamp, and Nathan Lynch for keeping machines
	alive despite my heavy abuse^Wtesting.

To build, start with 2.6.28-rc3, and apply:

	http://www.rdrop.com/users/paulmck/patches/linux-2.6-tip.2008.11.29a.patch
	http://www.rdrop.com/users/paulmck/patches/2.6.28-rc3-tip-treeRCU-7.patch

The former gets you to commit #29cbda77a67cf263d636feea65d3bbc9c7de2e24
in /tip/core/rcu in the -tip tree, and the latter is the following patch.

Thoughts?

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

