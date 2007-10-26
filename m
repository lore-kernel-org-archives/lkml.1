Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbXJZJmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbXJZJmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757999AbXJZJk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:40:57 -0400
Received: from havoc.gtf.org ([69.61.125.42]:57334 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757555AbXJZJkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:40:55 -0400
To: LKML <linux-kernel@vger.kernel.org>
Message-Id: <da61b43a149fee24af8b8db3e6e7efe2629ad79e.1193390975.git.jeff@garzik.org>
In-Reply-To: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
References: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, mchehab@infradead.org
Subject: [PATCH] media/video/planb: fix obvious interrupt handling bugs
Date: Fri, 26 Oct 2007 05:40:27 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

irq handlers have returned a return value for years now... catch up with
the times.

Also, ditch unneeded prototype.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/media/video/planb.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/planb.c b/drivers/media/video/planb.c
index ce4b2f9..36047d4 100644
--- a/drivers/media/video/planb.c
+++ b/drivers/media/video/planb.c
@@ -91,7 +91,6 @@ static void planb_close(struct video_device *);
 static int planb_ioctl(struct video_device *, unsigned int, void *);
 static int planb_init_done(struct video_device *);
 static int planb_mmap(struct video_device *, const char *, unsigned long);
-static void planb_irq(int, void *);
 static void release_planb(void);
 int init_planbs(struct video_init *);
 
@@ -1315,7 +1314,7 @@ cmd_tab_data_end:
 	return c1;
 }
 
-static void planb_irq(int irq, void *dev_id)
+static irqreturn_t planb_irq(int irq, void *dev_id)
 {
 	unsigned int stat, astat;
 	struct planb *pb = (struct planb *)dev_id;
@@ -1358,13 +1357,14 @@ static void planb_irq(int irq, void *dev_id)
 		pb->frame_stat[fr] = GBUFFER_DONE;
 		pb->grabbing--;
 		wake_up_interruptible(&pb->capq);
-		return;
+		return IRQ_HANDLED;
 	}
 	/* incorrect interrupts? */
 	pb->intr_mask = PLANB_CLR_IRQ;
 	out_le32(&pb->planb_base->intr_stat, PLANB_CLR_IRQ);
 	printk(KERN_ERR "PlanB: IRQ lockup, cleared intrrupts"
 							" unconditionally\n");
+	return IRQ_HANDLED;
 }
 
 /*******************************
@@ -2090,7 +2090,7 @@ static int init_planb(struct planb *pb)
 	/* clear interrupt mask */
 	pb->intr_mask = PLANB_CLR_IRQ;
 
-	result = request_irq(pb->irq, planb_irq, 0, "PlanB", (void *)pb);
+	result = request_irq(pb->irq, planb_irq, 0, "PlanB", pb);
 	if (result < 0) {
 		if (result==-EINVAL)
 			printk(KERN_ERR "PlanB: Bad irq number (%d) "
-- 
1.5.2.4

