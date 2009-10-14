Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbZJNR2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbZJNR2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 13:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbZJNR2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 13:28:51 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43673 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbZJNR2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 13:28:50 -0400
Date: Wed, 14 Oct 2009 10:15:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, npiggin@suse.de,
       jens.axboe@oracle.com
Subject: [PATCH tip/core/rcu 0/6] rcu: fix synchronize_rcu_expedited(),
	update docs, improve perf
Message-ID: <20091014171517.GA13635@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains a bug fix, a performance improvement, and
documentation updates:

o	Update Documentation/RCU/trace.txt to reflect recent changes
	(including the removal of rcupreempt.c).

o	Fix to the severe performance problem with excessive IPIs and
	lock contention in presence of very large (but legal) numbers
	of RCU callbacks (reported by Nick Piggin).

o	Stopgap fix for a bug in TREE_PREEMPT_RCU's implementation of
	synchronize_rcu_expedited().  This fix is correct, but no faster
	than synchronize_rcu().

o	Add exports for the updated synchronize_rcu_expedited()
	implementation, which moved from a static inline in
	include/linux/rcupdate.h to a separately compiled function
	in kernel/rcutree_plugin.h.

o	Add the new rnp->blocked_tasks field to the rcuhier trace file
	in debugfs.

o	Update the Documentation/RCU/trace.txt documentation to include
	the rnp->blocked_tasks tracing.

I believe that this is 2.6.32 material.

 Documentation/RCU/trace.txt   |   22 ++-
 b/Documentation/RCU/trace.txt |  232 +++++-------------------------------------
 b/include/linux/rcutree.h     |    6 -
 b/kernel/rcutree.c            |   29 ++++-
 b/kernel/rcutree.h            |    5 
 b/kernel/rcutree_plugin.h     |   20 +++
 b/kernel/rcutree_trace.c      |    8 -
 kernel/rcutree_plugin.h       |    3 
 8 files changed, 103 insertions(+), 222 deletions(-)
