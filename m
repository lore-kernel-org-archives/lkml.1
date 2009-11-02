Return-Path: <linux-kernel-owner+w=401wt.eu-S1757024AbZKBVvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbZKBVvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 16:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbZKBVvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 16:51:46 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:57613 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbZKBVvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 16:51:45 -0500
Date: Mon, 2 Nov 2009 13:51:47 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/3] v2 rcu: fix synchronization for
	->completed and ->gpnum fields
Message-ID: <20091102215147.GA9704@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again!

This updated patch series imposes a clear locking model on accesses to the
->completed and ->gpnum fields, significantly increasing the reliability
of RCU.  To be fair, in order to induce failures in current -tip,
you have to run long rcutorture tests on particular hardware with
particular kernel configuration parameters, while having modified the RCU
implementation itself to invoke force_quiescent_state() several times as
often as normal.  By "particular hardware", I do mean specific machines
that appear otherwise identical to other machines with much lower (and
sometimes even nonexistent) failure rates.  After all, these are race
conditions, and as such can be affected by very subtle factors.

That said, RCU really needs to stand up to whatever abuse shows up,
hence these patches.

1.	The first patch puts non-NO_HZ accesses to the ->completed field
	under a well-defined locking design, eliminating the
	unsynchronized accesses to rsp->completed from the
	dyntick_recall_completed() function.

2.	The second patch puts the rcu_process_gp_end() function's use
	of the ->completed field under a well-defined locking design,
	eliminating its previously unsynchronized accesses to
	rsp->completed.

3.	The third and final patch puts accesses to the ->gpnum field
	under a well-defined locking design, eliminating the
	unsynchronized accesses to rsp->gpnum from the note_new_gpnum()
	function.

A number of unsynchronized accesses remain, but these are of the form
of an unsynchronized check followed by a lock acquisition followed by
a repeat of the check.  With these patches applied, RCU passes a set
of ten-hour test runs under seventeen combinations of configuration
parameters.

Changes from v1 (http://lkml.org/lkml/2009/10/30/212):

o	Fix irqsave/irqrestore nesting problem.

o	Update log messages to reflect test results.

							Thanx, Paul
