Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbZG0SOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbZG0SOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZG0SOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:14:08 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51963 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295AbZG0SOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:14:07 -0400
Date: Mon, 27 Jul 2009 11:14:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org
Subject: [PATCH RFC -tip 0/4] v2 RCU cleanups and simplified preemptable RCU
Message-ID: <20090727181401.GA14120@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Not yet for inclusion, but making good progress.]

This patchset contains some RCU cleanups as follows:

o	Move private definitions from include/linux/rcutree.h to
	kernel/rcutree.h

o	Rename variables and functions so that RCU-sched is an
	underlying definition, along with RCU-bh and (when so
	configured) RCU-preempt.  RCU then maps to either RCU-sched
	or RCU-preempt, depending on configuration.

o	Consolidate sparse and lockdep into include/linux/rcupdate.h
	so that all RCU implementations are set up properly.

With these in place, we add configurable preemptable-RCU functionality
to kernel/rcutree.c.  This new implementation has much faster and
simpler read-side primitives (roughly that of Classic RCU built with
CONFIG_PREEMPT), and has update-side performance equal to Classic RCU (at
least in absence of blocking/preemption of read-side critical sections).
This new implementation should eventually replace the old preemptable RCU,
which would remove 2099 lines of code from the kernel, for a net removal
of more than 1000 lines of code.

This patchset is undoubtably buggy, and does not have RCU priority
boosting, though it does have the necessary tracking of tasks blocked
in RCU read-side critical sections.

Changes from v1 (http://lkml.org/lkml/2009/7/23/294):

o	Fixes some locking problems detected by lockdep.

o	Disable irqs in quiescent-state-detection code, and fix handling
	of scheduling-clock interrupt always occurring in RCU read-side
	critical section.

o	Fix sparse annotations.

o	Apply feedback from Mathieu Desnoyers.

o	Fix x86 kernel-build errors.

o	Now passes moderate (multi-hour) rcutorture tests.

Shortcomings:

o	Only moderately tested, probably still quite buggy.  CPU hotplug
	not yet tested heavily, for example.

o	Probably does not even compile for all of the relevant
	combinations of kernel configuration variables.

o	Lacks RCU priority boosting.

 b/Documentation/RCU/trace.txt |    7 
 b/include/linux/init_task.h   |   15 +
 b/include/linux/rcupdate.h    |   21 +-
 b/include/linux/rcupreempt.h  |    4 
 b/include/linux/rcutree.h     |  211 --------------------
 b/include/linux/sched.h       |   37 +++
 b/init/Kconfig                |   22 +-
 b/kernel/Makefile             |    1 
 b/kernel/exit.c               |    1 
 b/kernel/fork.c               |    5 
 b/kernel/rcupreempt.c         |    8 
 b/kernel/rcutree.c            |    2 
 b/kernel/rcutree.h            |  238 +++++++++++++++++++++++
 b/kernel/rcutree_plugin.h     |  428 ++++++++++++++++++++++++++++++++++++++++++
 b/kernel/rcutree_trace.c      |    2 
 b/kernel/sched.c              |    2 
 b/kernel/softirq.c            |    5 
 include/linux/rcupdate.h      |   48 ++++
 include/linux/rcupreempt.h    |    8 
 include/linux/rcutree.h       |   43 ++--
 kernel/rcutree.c              |  207 +++++++++++++-------
 kernel/rcutree.h              |   13 +
 kernel/rcutree_trace.c        |   40 ++-
 23 files changed, 1018 insertions(+), 350 deletions(-)
