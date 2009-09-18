Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbZIRQt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbZIRQt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 12:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbZIRQtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 12:49:55 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53797 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbZIRQty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 12:49:54 -0400
Date: Fri, 18 Sep 2009 09:49:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu
Subject: [PATCH tip/core/rcu 0/3] Cleanups/bugfixes for large systems and
	TREE_PREEMPT_RCU
Message-ID: <20090918164955.GA22272@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches does some cleanups and fixes a bug that prevents
TREE_PREEMPT_RCU from running reliably on large systems (more than
64 CPUs, or on 32-bit systems, more than 32 CPUs).  The patches are
as follows:

1.	Add WARN_ON_ONCE() consistency checks to catch bugs.  These
	are all on slowpaths, so are appropriate for production use.

2.	Apply the results of a code walkthrough of rcutree_plugin.h.
	This includes a fix for a theoretical race that could result in
	excessively long RCU grace periods, or perhaps even hangs/OOMs.

3.	Fix a bug introduced in a bugfix commit #de078d875 that caused
	large systems to only partially initialize the fields in the
	rcu_node tree.  TREE_RCU doesn't care about any of these fields,
	which explains why only TREE_PREEMPT_RCU was broken.

With these fixes, large systems using TREE_PREEMPT_RCU pass moderate
rcutorture runs (but with Josh Triplett's mods that force frequent
preemption within RCU read-side critical sections).  I am sure that
there are more bugs, but these fixes get things much closer.

 b/kernel/rcutree.c        |   13 +++++++++----
 b/kernel/rcutree_plugin.h |   21 ++++++++++++++-------
 kernel/rcutree.c          |   38 +++++++++-----------------------------
 kernel/rcutree_plugin.h   |   16 +++++++++-------
 4 files changed, 41 insertions(+), 47 deletions(-)
