Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbZIHWxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbZIHWxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbZIHWxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:53:50 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37308 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbZIHWxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:53:49 -0400
Date: Tue, 8 Sep 2009 15:53:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org
Subject: [PATCH tip/core/rcu 0/3] increase rcutorture intensity and fix a
	couple resulting bugs
Message-ID: <20090908225349.GA19524@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series increases the intensity of rcutorture testing for
TREE_PREEMPT_RCU and provides fixes for a couple resulting bugs.

o	Make rcutorture's RCU read-side critical sections occasionally
	spin for a few tens of milliseconds, which greatly increases
	the probability that they will be preempted and that quiescent
	states will be forced.  Yes, this does uncover some bugs in
	TREE_PREEMPT_RCU (though TREE_RCU passes with flying colors).

o	Fix a bug where rnp->gpnum was not being updated.  This
	increases TREE_PREEMPT_RCU's reliability considerably, though
	bugs still remain.

o	Make the initialization of multi-node trees of rcu_node
	structures unconditionally acquire rnp->lock.  This simplifies
	the code a bit and will make it easier to allow grace-period
	initialization become preemptable, should this be needed.

Next steps include applying review comments, adding expedited grace
periods, and chasing down remaining bugs.  Longer term, RCU priority
boosting.

 b/kernel/rcutorture.c |   16 +++++++++-------
 b/kernel/rcutree.c    |    7 +++++--
 kernel/rcutree.c      |   42 ++++++++++++------------------------------
 3 files changed, 26 insertions(+), 39 deletions(-)
