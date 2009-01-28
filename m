Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbZA1N4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbZA1N4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 08:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbZA1N42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:56:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60273 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbZA1N41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:56:27 -0500
Message-Id: <20090128135253.599881679@chello.nl>
References: <20090128135137.632938951@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 28 Jan 2009 14:51:38 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, efault@gmx.de
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/3] sched: symmetric sync vs avg_overlap
Content-Disposition: inline; filename=sched-sync_vs_overlap.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reinstate the weakening of the sync hint if set. This yields a more
symmetric usage of avg_overlap.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2360,9 +2360,15 @@ static int try_to_wake_up(struct task_st
 	if (!sched_feat(SYNC_WAKEUPS))
 		sync = 0;
 
-	if (!sync && (current->se.avg_overlap < sysctl_sched_migration_cost &&
-			    p->se.avg_overlap < sysctl_sched_migration_cost))
-		sync = 1;
+	if (!sync) {
+		if (current->se.avg_overlap < sysctl_sched_migration_cost &&
+			  p->se.avg_overlap < sysctl_sched_migration_cost)
+			sync = 1;
+	} else {
+		if (current->se.avg_overlap >= sysctl_sched_migration_cost ||
+			  p->se.avg_overlap >= sysctl_sched_migration_cost)
+			sync = 0;
+	}
 
 #ifdef CONFIG_SMP
 	if (sched_feat(LB_WAKEUP_UPDATE)) {

-- 

