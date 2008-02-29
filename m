Return-Path: <linux-kernel-owner+w=401wt.eu-S1761519AbYB2Tbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761519AbYB2Tbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbYB2Tb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:31:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45590 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbYB2Tb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:31:27 -0500
Date: Fri, 29 Feb 2008 20:31:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler updates, #2
Message-ID: <20080229193118.GA20825@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

Two more rcupreempt updates (that i forgot about for the previous pull 
request - they hid in the middle of the queue). Thanks,

	Ingo

------------------>
Paul E. McKenney (2):
      rcupreempt: fix hibernate/resume in presence of PREEMPT_RCU and hotplug
      rcupreempt: remove never-migrates assumption from rcu_process_callbacks()

 kernel/rcupreempt.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index c7c5209..e951701 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -918,8 +918,9 @@ void rcu_offline_cpu(int cpu)
 	 * fix.
 	 */
 
+	local_irq_save(flags);
 	rdp = RCU_DATA_ME();
-	spin_lock_irqsave(&rdp->lock, flags);
+	spin_lock(&rdp->lock);
 	*rdp->nexttail = list;
 	if (list)
 		rdp->nexttail = tail;
@@ -951,9 +952,11 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 {
 	unsigned long flags;
 	struct rcu_head *next, *list;
-	struct rcu_data *rdp = RCU_DATA_ME();
+	struct rcu_data *rdp;
 
-	spin_lock_irqsave(&rdp->lock, flags);
+	local_irq_save(flags);
+	rdp = RCU_DATA_ME();
+	spin_lock(&rdp->lock);
 	list = rdp->donelist;
 	if (list == NULL) {
 		spin_unlock_irqrestore(&rdp->lock, flags);
