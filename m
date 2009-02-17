Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbZBQQkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbZBQQkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 11:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbZBQQke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 11:40:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57747 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbZBQQkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 11:40:33 -0500
Date: Tue, 17 Feb 2009 17:40:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fix
Message-ID: <20090217164025.GA4539@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      sched: cpu hotplug fix


 kernel/sched.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c1d0ed3..410eec4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6944,20 +6944,26 @@ static void free_rootdomain(struct root_domain *rd)
 
 static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 {
+	struct root_domain *old_rd = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(&rq->lock, flags);
 
 	if (rq->rd) {
-		struct root_domain *old_rd = rq->rd;
+		old_rd = rq->rd;
 
 		if (cpumask_test_cpu(rq->cpu, old_rd->online))
 			set_rq_offline(rq);
 
 		cpumask_clear_cpu(rq->cpu, old_rd->span);
 
-		if (atomic_dec_and_test(&old_rd->refcount))
-			free_rootdomain(old_rd);
+		/*
+		 * If we dont want to free the old_rt yet then
+		 * set old_rd to NULL to skip the freeing later
+		 * in this function:
+		 */
+		if (!atomic_dec_and_test(&old_rd->refcount))
+			old_rd = NULL;
 	}
 
 	atomic_inc(&rd->refcount);
@@ -6968,6 +6974,9 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 		set_rq_online(rq);
 
 	spin_unlock_irqrestore(&rq->lock, flags);
+
+	if (old_rd)
+		free_rootdomain(old_rd);
 }
 
 static int __init_refok init_rootdomain(struct root_domain *rd, bool bootmem)
