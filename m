Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966728Ab0B0Aie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 19:38:34 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:41858 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966700Ab0B0Aid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 19:38:33 -0500
Date: Fri, 26 Feb 2010 16:38:31 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/3] rcu: fixes for lockdep RCU and
	accelerated dyntick GPs
Message-ID: <20100227003831.GA27703@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset includes three fixes for problems in tip/core/rcu:

1.	Convert grace-period acceleration for the last non-dynticked
	RCU to a trivial state machine in order to avoid illegally
	invoking __rcu_process_callbacks() with irqs disabled.

2.	Make the non-PROVE_RCU variant of rcu_read_lock_sched_held()
	understand that preemption is disabled during boot before
	the scheduler starts.  (The earlier patch did the PROVE_RCU
	variant, but missed the non-PROVE_RCU variant.)

3.	Add some irq-disabling to the grace-period acceleration
	in #1 above and also enforce a hold-off period so that the
	last non-dynticked CPU doesn't softirq itself to death when
	there are multiple RCU callbacks in flight.

							Thanx, Paul

 b/include/linux/rcupdate.h |    3 -
 b/kernel/rcutree.c         |    3 +
 b/kernel/rcutree.h         |    1 
 b/kernel/rcutree_plugin.h  |   74 ++++++++++++++++++++++++++++++++-------------
 kernel/rcutree_plugin.h    |   11 +++++-
 5 files changed, 67 insertions(+), 25 deletions(-)
