Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbZJGEsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbZJGEsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 00:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbZJGEs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 00:48:29 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51067 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbZJGEs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 00:48:28 -0400
Date: Tue, 6 Oct 2009 21:47:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/3] rcu: prevent hangs by simplifying
	rcu_barrier/CPU-hotplug, fix lockdep complaint
Message-ID: <20091007044748.GA12763@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes a couple of issues with TREE_PREEMPT_RCU:

1.	The current implementation of rcu_barrier() waits for any
	prior CPU-hotplug operation to complete.  This code path has
	resulted in some hangs, so first move this code from rcupdate.c
	to rcutree.c and then use a simpler algorithm that avoids the
	waiting, eliminating the possibility of such hangs.

2.	The lockdep facility complains from time to time due to the
	fact that certain combinations of CPU-hotplug operations can
	cause the TREE_PREEMPT_RCU code to acquire the root rcu_node
	structure's lock while holding a leaf rcu_node structure's
	lock.  This patch places the root rcu_node structure's lock
	into its own lockdep class to prevent this false positive.

Ingo, please rewind tip/core/rcu to commit #135c8aea before applying this
series, as these patches really need to go into 2.6.32.  Reworked and
retested rcutiny (for 2.6.33, as Linus requested) will follow in a
few days.  Or more patches for more bug fixes, as the case may be.  ;-)

 b/kernel/rcupdate.c       |  120 -----------------------------------
 b/kernel/rcutree.c        |  120 +++++++++++++++++++++++++++++++++++
 b/kernel/rcutree.h        |   11 ++-
 b/kernel/rcutree_plugin.h |   34 ++++++++++
 b/kernel/rcutree_trace.c  |    5 -
 kernel/rcutree.c          |  156 ++++++++++++++++++++++++----------------------
 6 files changed, 248 insertions(+), 198 deletions(-)
