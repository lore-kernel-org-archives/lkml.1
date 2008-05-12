Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbYELQlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbYELQlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 12:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYELQlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 12:41:00 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:30067 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753468AbYELQk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 12:40:59 -0400
Message-Id: <20080512163532.476789403@mvista.com>
User-Agent: quilt/0.46-1
Date: Mon, 12 May 2008 09:35:32 -0700
From: Daniel Walker <dwalker@mvista.com>
To: paulus@samba.org
Cc: benh@kernel.crashing.org, mingo@elte.hu, matthew@wil.cx,
       Matthias Kaehlcke <matthias@kaehlcke.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] macintosh: media bay: semaphore to mutex
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/macintosh/mediabay.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

Index: linux-2.6.24/drivers/macintosh/mediabay.c
===================================================================
--- linux-2.6.24.orig/drivers/macintosh/mediabay.c
+++ linux-2.6.24/drivers/macintosh/mediabay.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/ide.h>
 #include <linux/kthread.h>
+#include <linux/mutex.h>
 #include <asm/prom.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
@@ -77,7 +78,7 @@ struct media_bay_info {
 	int				index;
 	int				cached_gpio;
 	int				sleeping;
-	struct semaphore		lock;
+	struct mutex			lock;
 #ifdef CONFIG_BLK_DEV_IDE_PMAC
 	ide_hwif_t			*cd_port;
 	void __iomem			*cd_base;
@@ -459,27 +460,27 @@ int media_bay_set_ide_infos(struct devic
 		if (bay->mdev && which_bay == bay->mdev->ofdev.node) {
 			int timeout = 5000, index = hwif->index;
 			
-			down(&bay->lock);
+			mutex_lock(&bay->lock);
 
 			bay->cd_port	= hwif;
  			bay->cd_base	= (void __iomem *) base;
 			bay->cd_irq	= irq;
 
 			if ((MB_CD != bay->content_id) || bay->state != mb_up) {
-				up(&bay->lock);
+				mutex_unlock(&bay->lock);
 				return 0;
 			}
 			printk(KERN_DEBUG "Registered ide%d for media bay %d\n", index, i);
 			do {
 				if (MB_IDE_READY(i)) {
 					bay->cd_index	= index;
-					up(&bay->lock);
+					mutex_unlock(&bay->lock);
 					return 0;
 				}
 				mdelay(1);
 			} while(--timeout);
 			printk(KERN_DEBUG "Timeount waiting IDE in bay %d\n", i);
-			up(&bay->lock);
+			mutex_unlock(&bay->lock);
 			return -ENODEV;
 		}
 	}
@@ -616,10 +617,10 @@ static int media_bay_task(void *x)
 
 	while (!kthread_should_stop()) {
 		for (i = 0; i < media_bay_count; ++i) {
-			down(&media_bays[i].lock);
+			mutex_lock(&media_bays[i].lock);
 			if (!media_bays[i].sleeping)
 				media_bay_step(i);
-			up(&media_bays[i].lock);
+			mutex_unlock(&media_bays[i].lock);
 		}
 
 		msleep_interruptible(MB_POLL_DELAY);
@@ -659,7 +660,7 @@ static int __devinit media_bay_attach(st
 	bay->index = i;
 	bay->ops = match->data;
 	bay->sleeping = 0;
-	init_MUTEX(&bay->lock);
+	mutex_init(&bay->lock);
 
 	/* Init HW probing */
 	if (bay->ops->init)
@@ -697,10 +698,10 @@ static int media_bay_suspend(struct maci
 
 	if (state.event != mdev->ofdev.dev.power.power_state.event
 	    && (state.event & PM_EVENT_SLEEP)) {
-		down(&bay->lock);
+		mutex_lock(&bay->lock);
 		bay->sleeping = 1;
 		set_mb_power(bay, 0);
-		up(&bay->lock);
+		mutex_unlock(&bay->lock);
 		msleep(MB_POLL_DELAY);
 		mdev->ofdev.dev.power.power_state = state;
 	}
@@ -719,12 +720,12 @@ static int media_bay_resume(struct macio
 	       	   they seem to help the 3400 get it right.
 	       	 */
 	       	/* Force MB power to 0 */
-		down(&bay->lock);
+		mutex_lock(&bay->lock);
 	       	set_mb_power(bay, 0);
 		msleep(MB_POWER_DELAY);
 	       	if (bay->ops->content(bay) != bay->content_id) {
 			printk("mediabay%d: content changed during sleep...\n", bay->index);
-			up(&bay->lock);
+			mutex_unlock(&bay->lock);
 	       		return 0;
 		}
 	       	set_mb_power(bay, 1);
@@ -740,7 +741,7 @@ static int media_bay_resume(struct macio
 	       	} while((bay->state != mb_empty) &&
 	       		(bay->state != mb_up));
 		bay->sleeping = 0;
-		up(&bay->lock);
+		mutex_unlock(&bay->lock);
 	}
 	return 0;
 }
-- 

-- 
