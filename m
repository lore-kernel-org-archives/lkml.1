Return-Path: <linux-kernel-owner+w=401wt.eu-S932962AbZLOXS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962AbZLOXS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761224AbZLOXSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:18:24 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44861 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762105AbZLOXCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:02:17 -0500
Date: Tue, 15 Dec 2009 15:02:13 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH RFC tip/core/rcu 0/18] rcu: simplify race conditions, add
	checking
Message-ID: <20091215230213.GA9093@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This is just a sneak preview of RCU patches that I have in flight, not
yet for inclusion.

Patches 1-10 simplify TREE_RCU's (and TREE_PREEMPT_RCU's) race conditions
by prohibiting grace periods from starting while force_quiescent_state()
is active.  Patch 10 maintains grace-period latency by the simple
expedient of having force_quiescent_state() check to see if someone
wanted to start a grace period, and, if so, starting one on their behalf.

Patch 11 adds parameters to rcutorture to allow testing with extremely
rapid re-invocations of force_quiescent_state() -- microseconds rather
than the previous milliseconds.

Patch 12 makes the RCU and rcutorture entries of the MAINTAINERS file
call out the correct source files, which have changed due to the recent
re-implementation.

Patches 13-18 add debugging checks, so that an rcu_dereference(p)
can now be rcu_dereference(p, rcu_read_lock_held()), which
will complain if invoked outside of an RCU read-side critical
section when CONFIG_PROVE_LOCKING is specified.  There are
also rcu_read_lock_bh_held(), rcu_read_lock_sched_held(), and
srcu_read_lock_held() for the other flavors of RCU.

One can also do something like:

	p = rcu_dereference_check(gp, rcu_read_lock_bh_held() ||
				  lockdep_is_held(my_lock));

to handle the case where either the access must either be protected
by RCU-bh or by my_lock.

Again, strictly FYI, not yet for inclusion.

							Thanx, Paul
