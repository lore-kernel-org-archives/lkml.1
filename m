Return-Path: <linux-kernel-owner+w=401wt.eu-S1750892AbZGXAOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750892AbZGXAOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 20:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750773AbZGXAOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 20:14:32 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50917 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbZGXAOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 20:14:31 -0400
Date: Thu, 23 Jul 2009 17:14:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org
Subject: [PATCH RFC -tip 0/4] RCU cleanups and simplified preemptable RCU
Message-ID: <20090724001429.GA17374@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Not for inclusion.]

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
which would remove 2099 lines of code from the kernel.

This patchset is undoubtably buggy, and does not have RCU priority
boosting, though it does have the necessary tracking of tasks blocked
in RCU read-side critical sections.

 Documentation/RCU/trace.txt   |   14 
 b/Documentation/RCU/trace.txt |    7 
 b/include/linux/init_task.h   |   15 
 b/include/linux/rcupdate.h    |   21 -
 b/include/linux/rcupreempt.h  |    4 
 b/include/linux/rcutree.h     |  211 ------------
 b/include/linux/sched.h       |   13 
 b/init/Kconfig                |   22 -
 b/kernel/Makefile             |    1 
 b/kernel/exit.c               |    1 
 b/kernel/fork.c               |    6 
 b/kernel/rcupreempt.c         |    8 
 b/kernel/rcutree.c            |    2 
 b/kernel/rcutree.h            |  238 +++++++++++++
 b/kernel/rcutree_plugin.h     |  414 +++++++++++++++++++++++
 b/kernel/rcutree_trace.c      |    1 
 b/kernel/sched.c              |    2 
 b/kernel/softirq.c            |    4 
 include/linux/rcupdate.h      |  136 ++++++-
 include/linux/rcupreempt.h    |   20 -
 include/linux/rcutree.h       |  707 +---------------------------------------
 kernel/rcupreempt.c           |   16 
 kernel/rcutree.c              |  317 ++++++++++++------
 kernel/rcutree.h              |  730 +++++++++++++++++++++++++++++++++++++++++-
 kernel/rcutree_trace.c        |   63 +--
 kernel/sched.c                |    4 
 kernel/softirq.c              |    8 
 27 files changed, 1882 insertions(+), 1103 deletions(-)
