Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbZHOQvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbZHOQvy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 12:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbZHOQvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 12:51:54 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50506 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549AbZHOQvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 12:51:53 -0400
Date: Sat, 15 Aug 2009 09:51:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       hugh.dickins@tiscali.co.uk, benh@kernel.crashing.org
Subject: [PATCH -tip/core/rcu 1/6] Cleanups and fixes for RCU in face of
	heavy CPU-hotplug stress
Message-ID: <20090815165153.GA8886@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set provides the following cleanups and fixes for RCU in
workloads that involve lots of CPU hotplugging.  Ingo, please reset
core/rcu to 240ebbf before applying these patches.

o	Split Hierarchical RCU initialization into boot-time and
	CPU-hotplug pieces, so that other CPUs never see the data
	structures in the act of being stitched together.

o	Introduce a cpu_notifier() that works as does the current
	hotcpu_notifier(), but also notifies during boot time even
	if !HOTPLUG_CPU.

o	Make RCU use the new cpu_notifier() to simplify hotplug code
	and reduce the number of notifiers in use.  (This also fixes
	the problem Ingo and Hugh found.)

o	Preemptable RCU had a bug due to its overly clever attempt
	to move counts from CPUs going offline.  This is "unsafe
	at any speed", so remove the cleverness.

o	Since offline CPUs now can have non-zero counts, they must
	now be included in the tracing.

o	Fix typo in preemptable RCU's rcu_irq_enter() comment
	submitted by Josh Triplett.

These pass tests combining rcutorture and continuous CPU-hotplug
operations, in other words, no sleeping between successive CPU-hotplug
operations.  This set does not fix the bug involving deadlocks through
rcutorture, kthread_stop(), and migration threads.  However, this bug
does not affect production systems, so should not stand in the way of
applying these patches.

							Thanx, Paul

 b/include/linux/cpu.h       |   18 +++++++++-----
 b/kernel/rcupdate.c         |   16 ++++++++++++-
 b/kernel/rcupreempt.c       |   25 +-------------------
 b/kernel/rcupreempt_trace.c |    6 ++--
 b/kernel/rcutree.c          |   54 ++++++++++++++++++++++++++------------------
 kernel/rcupreempt.c         |   12 +--------
 kernel/rcutree.c            |   18 ++++----------
 7 files changed, 72 insertions(+), 77 deletions(-)
