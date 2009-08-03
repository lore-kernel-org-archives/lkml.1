Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbZHCNDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbZHCNDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 09:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbZHCNDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 09:03:37 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55102 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818AbZHCNDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 09:03:37 -0400
Date: Mon, 3 Aug 2009 06:03:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org
Subject: Re: [PATCH RFC -tip 0/4] v2 RCU cleanups and simplified preemptable
	RCU
Message-ID: <20090803130342.GX6854@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090727181401.GA14120@linux.vnet.ibm.com> <20090803082047.GA12498@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090803082047.GA12498@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 10:20:47AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > [Not yet for inclusion, but making good progress.]
> > 
> > This patchset contains some RCU cleanups as follows:
> > 
> > o	Move private definitions from include/linux/rcutree.h to
> > 	kernel/rcutree.h
> > 
> > o	Rename variables and functions so that RCU-sched is an
> > 	underlying definition, along with RCU-bh and (when so
> > 	configured) RCU-preempt.  RCU then maps to either RCU-sched
> > 	or RCU-preempt, depending on configuration.
> > 
> > o	Consolidate sparse and lockdep into include/linux/rcupdate.h
> > 	so that all RCU implementations are set up properly.
> > 
> > With these in place, we add configurable preemptable-RCU functionality
> > to kernel/rcutree.c.  This new implementation has much faster and
> > simpler read-side primitives (roughly that of Classic RCU built with
> > CONFIG_PREEMPT), and has update-side performance equal to Classic RCU (at
> > least in absence of blocking/preemption of read-side critical sections).
> > This new implementation should eventually replace the old preemptable RCU,
> > which would remove 2099 lines of code from the kernel, for a net removal
> > of more than 1000 lines of code.
> > 
> > This patchset is undoubtably buggy, and does not have RCU priority
> > boosting, though it does have the necessary tracking of tasks blocked
> > in RCU read-side critical sections.
> > 
> > Changes from v1 (http://lkml.org/lkml/2009/7/23/294):
> > 
> > o	Fixes some locking problems detected by lockdep.
> > 
> > o	Disable irqs in quiescent-state-detection code, and fix handling
> > 	of scheduling-clock interrupt always occurring in RCU read-side
> > 	critical section.
> > 
> > o	Fix sparse annotations.
> > 
> > o	Apply feedback from Mathieu Desnoyers.
> > 
> > o	Fix x86 kernel-build errors.
> > 
> > o	Now passes moderate (multi-hour) rcutorture tests.
> > 
> > Shortcomings:
> > 
> > o	Only moderately tested, probably still quite buggy.  CPU hotplug
> > 	not yet tested heavily, for example.
> > 
> > o	Probably does not even compile for all of the relevant
> > 	combinations of kernel configuration variables.
> > 
> > o	Lacks RCU priority boosting.
> > 
> >  b/Documentation/RCU/trace.txt |    7 
> >  b/include/linux/init_task.h   |   15 +
> >  b/include/linux/rcupdate.h    |   21 +-
> >  b/include/linux/rcupreempt.h  |    4 
> >  b/include/linux/rcutree.h     |  211 --------------------
> >  b/include/linux/sched.h       |   37 +++
> >  b/init/Kconfig                |   22 +-
> >  b/kernel/Makefile             |    1 
> >  b/kernel/exit.c               |    1 
> >  b/kernel/fork.c               |    5 
> >  b/kernel/rcupreempt.c         |    8 
> >  b/kernel/rcutree.c            |    2 
> >  b/kernel/rcutree.h            |  238 +++++++++++++++++++++++
> >  b/kernel/rcutree_plugin.h     |  428 ++++++++++++++++++++++++++++++++++++++++++
> >  b/kernel/rcutree_trace.c      |    2 
> >  b/kernel/sched.c              |    2 
> >  b/kernel/softirq.c            |    5 
> >  include/linux/rcupdate.h      |   48 ++++
> >  include/linux/rcupreempt.h    |    8 
> >  include/linux/rcutree.h       |   43 ++--
> >  kernel/rcutree.c              |  207 +++++++++++++-------
> >  kernel/rcutree.h              |   13 +
> >  kernel/rcutree_trace.c        |   40 ++-
> >  23 files changed, 1018 insertions(+), 350 deletions(-)
> 
> The structure looks really nice. If feasible i'd suggest to remove 
> preemptible-rcu in this same patch-set as well, to simplify the 
> testing matrix and to get the net code removal effect as well.

Glad you like it, and I do like the idea of removing the old rcupreempt
in the same patch set.  I will include that in the next submission.
Currently having strange problems with CPU hotplug -- RCU does just
fine, but CPU hotplug operations hang.  Might be related to the problem
that you have been seeing.

> An added benefit is that that way the -rt folks will test out the 
> new preemptible-rcu code with enthusiasm as well ;-)

;-)

							Thanx, Paul
