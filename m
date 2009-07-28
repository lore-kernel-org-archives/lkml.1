Return-Path: <linux-kernel-owner+w=401wt.eu-S1752278AbZG1Kih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbZG1Kih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbZG1Kih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:38:37 -0400
Received: from smtp.nokia.com ([192.100.105.134]:65529 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbZG1Kid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:38:33 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Pierre Ossman <pierre@ossman.eu>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Matt Fleming <matt@console-pimps.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jul 2009 13:38:50 +0300
Message-Id: <20090728103850.2371.83700.sendpatchset@ahunter-laptop>
In-Reply-To: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
References: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
Subject: [PATCH V2 2/32] mmc: allow host claim / release nesting
X-OriginalArrivalTime: 28 Jul 2009 10:38:18.0531 (UTC) FILETIME=[85474F30:01CA0F6F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 93e60ec163a4ef242e88056c9c642c227f256628 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Mon, 27 Apr 2009 13:38:42 +0300
Subject: [PATCH] mmc: allow host claim / release nesting

This change allows the MMC host to be claimed in
situations where the host may or may not have
already been claimed.  Also 'mmc_try_claim_host()'
is now exported.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/core/core.c  |   34 +++++++++++++++++++++++++---------
 include/linux/mmc/core.h |    1 +
 include/linux/mmc/host.h |    2 ++
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 9bc8d27..bab5015 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -461,16 +461,18 @@ int __mmc_claim_host(struct mmc_host *host, atomic_t *abort)
 	while (1) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		stop = abort ? atomic_read(abort) : 0;
-		if (stop || !host->claimed)
+		if (stop || !host->claimed || host->claimer == current)
 			break;
 		spin_unlock_irqrestore(&host->lock, flags);
 		schedule();
 		spin_lock_irqsave(&host->lock, flags);
 	}
 	set_current_state(TASK_RUNNING);
-	if (!stop)
+	if (!stop) {
 		host->claimed = 1;
-	else
+		host->claimer = current;
+		host->claim_cnt += 1;
+	} else
 		wake_up(&host->wq);
 	spin_unlock_irqrestore(&host->lock, flags);
 	remove_wait_queue(&host->wq, &wait);
@@ -481,29 +483,43 @@ int __mmc_claim_host(struct mmc_host *host, atomic_t *abort)
 
 EXPORT_SYMBOL(__mmc_claim_host);
 
-static int mmc_try_claim_host(struct mmc_host *host)
+/**
+ *	mmc_try_claim_host - try exclusively to claim a host
+ *	@host: mmc host to claim
+ *
+ *	Returns %1 if the host is claimed, %0 otherwise.
+ */
+int mmc_try_claim_host(struct mmc_host *host)
 {
 	int claimed_host = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&host->lock, flags);
-	if (!host->claimed) {
+	if (!host->claimed || host->claimer == current) {
 		host->claimed = 1;
+		host->claimer = current;
+		host->claim_cnt += 1;
 		claimed_host = 1;
 	}
 	spin_unlock_irqrestore(&host->lock, flags);
 	return claimed_host;
 }
+EXPORT_SYMBOL(mmc_try_claim_host);
 
 static void mmc_do_release_host(struct mmc_host *host)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&host->lock, flags);
-	host->claimed = 0;
-	spin_unlock_irqrestore(&host->lock, flags);
-
-	wake_up(&host->wq);
+	if (--host->claim_cnt) {
+		/* Release for nested claim */
+		spin_unlock_irqrestore(&host->lock, flags);
+	} else {
+		host->claimed = 0;
+		host->claimer = NULL;
+		spin_unlock_irqrestore(&host->lock, flags);
+		wake_up(&host->wq);
+	}
 }
 
 void mmc_host_deeper_disable(struct work_struct *work)
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 7ac8b50..e4898e9 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -139,6 +139,7 @@ extern unsigned int mmc_align_data_size(struct mmc_card *, unsigned int);
 
 extern int __mmc_claim_host(struct mmc_host *host, atomic_t *abort);
 extern void mmc_release_host(struct mmc_host *host);
+extern int mmc_try_claim_host(struct mmc_host *host);
 
 /**
  *	mmc_claim_host - exclusively claim a host
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 338a9b3..631a2fe 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -182,6 +182,8 @@ struct mmc_host {
 	struct mmc_card		*card;		/* device attached to this host */
 
 	wait_queue_head_t	wq;
+	struct task_struct	*claimer;	/* task that has host claimed */
+	int			claim_cnt;	/* "claim" nesting count */
 
 	struct delayed_work	detect;
 
-- 
1.5.6.3

