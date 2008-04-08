Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbYDHEEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbYDHEEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 00:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbYDHEE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 00:04:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:36205 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbYDHEE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 00:04:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ld2KyYBc0nr3DKv2d4OuFAPbiS1d/zX4sPQVjOmjN/T3uruOM/DmeCoGXj0kMxVilomHKA01m/esbpXx0uzchca0niSZqzaxdlQVb+Hxu3bvebvY9hMpPmD6DAi6+fTbddi7gq3D4KiV4x3YBFRSRPcBNoPIB/7MCAYM3+PAmb0=
Message-ID: <f17812d70804072104k69711417h641ff73ed4e77009@mail.gmail.com>
Date: Tue, 8 Apr 2008 12:04:24 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "linux-arm-kernel email list" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-fbdev-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] pxafb: use completion for LCD disable wait code
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Mack" <daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7fc5217e6d466262e8b59c07cc7bbea2e82a09e8 Mon Sep 17 00:00:00 2001
From: Eric Miao <eric.miao@marvell.com>
Date: Thu, 27 Mar 2008 09:37:07 +0800
Subject: [PATCH] pxafb: use completion for LCD disable wait code

Signed-off-by: eric miao <eric.miao@marvell.com>
---
 drivers/video/pxafb.c |   12 ++++--------
 drivers/video/pxafb.h |    2 ++
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/video/pxafb.c b/drivers/video/pxafb.c
index 27d9fed..fb24ca3 100644
--- a/drivers/video/pxafb.c
+++ b/drivers/video/pxafb.c
@@ -39,6 +39,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/clk.h>
 #include <linux/err.h>
+#include <linux/completion.h>

 #include <asm/hardware.h>
 #include <asm/io.h>
@@ -801,11 +802,6 @@ static void pxafb_disable_controller(struct
pxafb_info *fbi)
 {
 	uint32_t lccr0;

-	DECLARE_WAITQUEUE(wait, current);
-
-	set_current_state(TASK_UNINTERRUPTIBLE);
-	add_wait_queue(&fbi->ctrlr_wait, &wait);
-
 	/* Clear LCD Status Register */
 	lcd_writel(fbi, LCSR, 0xffffffff);

@@ -813,8 +809,7 @@ static void pxafb_disable_controller(struct pxafb_info *fbi)
 	lcd_writel(fbi, LCCR0, lccr0);
 	lcd_writel(fbi, LCCR0, lccr0 | LCCR0_DIS);

-	schedule_timeout(200 * HZ / 1000);
-	remove_wait_queue(&fbi->ctrlr_wait, &wait);
+	wait_for_completion_timeout(&fbi->disable_done, 200 * HZ / 1000);

 	/* disable LCD controller clock */
 	clk_disable(fbi->clk);
@@ -831,7 +826,7 @@ static irqreturn_t pxafb_handle_irq(int irq, void *dev_id)
 	if (lcsr & LCSR_LDD) {
 		lccr0 = lcd_readl(fbi, LCCR0);
 		lcd_writel(fbi, LCCR0, lccr0 | LCCR0_LDM);
-		wake_up(&fbi->ctrlr_wait);
+		complete(&fbi->disable_done);
 	}

 	lcd_writel(fbi, LCSR, lcsr);
@@ -1181,6 +1176,7 @@ static struct pxafb_info * __init
pxafb_init_fbinfo(struct device *dev)
 	init_waitqueue_head(&fbi->ctrlr_wait);
 	INIT_WORK(&fbi->task, pxafb_task);
 	init_MUTEX(&fbi->ctrlr_sem);
+	init_completion(&fbi->disable_done);

 	return fbi;
 }
diff --git a/drivers/video/pxafb.h b/drivers/video/pxafb.h
index b777641..f47f139 100644
--- a/drivers/video/pxafb.h
+++ b/drivers/video/pxafb.h
@@ -114,6 +114,8 @@ struct pxafb_info {
 	wait_queue_head_t	ctrlr_wait;
 	struct work_struct	task;

+	struct completion	disable_done;
+
 #ifdef CONFIG_CPU_FREQ
 	struct notifier_block	freq_transition;
 	struct notifier_block	freq_policy;
-- 
1.5.4.3



-- 
Cheers
- eric
