Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbYJXJ7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbYJXJ7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 05:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbYJXJ6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 05:58:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:36223 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbYJXJ6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 05:58:42 -0400
Message-Id: <20081024091109.585167877@chello.nl>
References: <20081024090611.936552213@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 24 Oct 2008 11:06:14 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, efault@gmx.de, vatsa@in.ibm.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/8] sched: weaken sync hint
Content-Disposition: inline; filename=mike-weaken-sync.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Galbraith <efault@gmx.de>

Mysql+oltp and pgsql+oltp peaks are still shifted right. The below puts
the peaks back to 1 client/server pair per core.

Use the avg_overlap information to weaken the sync hint.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1228,10 +1228,9 @@ wake_affine(struct sched_domain *this_sd
 	if (!(this_sd->flags & SD_WAKE_AFFINE) || !sched_feat(AFFINE_WAKEUPS))
 		return 0;
 
-	if (!sync && sched_feat(SYNC_WAKEUPS) &&
-	    curr->se.avg_overlap < sysctl_sched_migration_cost &&
-	    p->se.avg_overlap < sysctl_sched_migration_cost)
-		sync = 1;
+	if (sync && (curr->se.avg_overlap > sysctl_sched_migration_cost ||
+			p->se.avg_overlap > sysctl_sched_migration_cost))
+		sync = 0;
 
 	/*
 	 * If sync wakeup then subtract the (maximum possible)

-- 

