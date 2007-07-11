Return-Path: <linux-kernel-owner+w=401wt.eu-S935414AbXGKXkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935414AbXGKXkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935049AbXGKXeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:34:08 -0400
Received: from mx1.suse.de ([195.135.220.2]:33755 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934984AbXGKXeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:34:06 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/61] PM: do not use saved_state from struct dev_pm_info on ARM
Date: Wed, 11 Jul 2007 16:31:36 -0700
Message-Id: <11841968231043-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184196818497-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
 <11841968032469-git-send-email-gregkh@suse.de>
 <11841968071826-git-send-email-gregkh@suse.de>
 <11841968111201-git-send-email-gregkh@suse.de>
 <11841968151257-git-send-email-gregkh@suse.de>
 <1184196818497-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The saved_state member of 'struct dev_pm_info' that's going to be removed
is used in arch/arm/common/locomo.c, arch/arm/common/sa1111.c and
arch/arm/mach-sa1100/neponset.c.  Change the code in there to use local
variables for saving the state of devices during suspend.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/arm/common/locomo.c        |   11 ++++++++---
 arch/arm/common/sa1111.c        |   13 ++++++++-----
 arch/arm/mach-sa1100/neponset.c |   15 ++++-----------
 3 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/arch/arm/common/locomo.c b/arch/arm/common/locomo.c
index cfe6f46..ae21755 100644
--- a/arch/arm/common/locomo.c
+++ b/arch/arm/common/locomo.c
@@ -60,6 +60,9 @@ struct locomo {
 	unsigned int irq;
 	spinlock_t lock;
 	void __iomem *base;
+#ifdef CONFIG_PM
+	void *saved_state;
+#endif
 };
 
 struct locomo_dev_info {
@@ -565,7 +568,7 @@ static int locomo_suspend(struct platform_device *dev, pm_message_t state)
 	if (!save)
 		return -ENOMEM;
 
-	dev->dev.power.saved_state = (void *) save;
+	lchip->saved_state = save;
 
 	spin_lock_irqsave(&lchip->lock, flags);
 
@@ -605,8 +608,8 @@ static int locomo_resume(struct platform_device *dev)
 	struct locomo_save_data *save;
 	unsigned long r;
 	unsigned long flags;
-	
-	save = (struct locomo_save_data *) dev->dev.power.saved_state;
+
+	save = lchip->saved_state;
 	if (!save)
 		return 0;
 
@@ -628,6 +631,8 @@ static int locomo_resume(struct platform_device *dev)
 	locomo_writel(0x1, lchip->base + LOCOMO_KEYBOARD + LOCOMO_KCMD);
 
 	spin_unlock_irqrestore(&lchip->lock, flags);
+
+	lchip->saved_state = NULL;
 	kfree(save);
 
 	return 0;
diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
index 798bbfc..eb06d0b 100644
--- a/arch/arm/common/sa1111.c
+++ b/arch/arm/common/sa1111.c
@@ -51,6 +51,9 @@ struct sa1111 {
 	int		irq;
 	spinlock_t	lock;
 	void __iomem	*base;
+#ifdef CONFIG_PM
+	void		*saved_state;
+#endif
 };
 
 /*
@@ -822,7 +825,7 @@ static int sa1111_suspend(struct platform_device *dev, pm_message_t state)
 	save = kmalloc(sizeof(struct sa1111_save_data), GFP_KERNEL);
 	if (!save)
 		return -ENOMEM;
-	dev->dev.power.saved_state = save;
+	sachip->saved_state = save;
 
 	spin_lock_irqsave(&sachip->lock, flags);
 
@@ -878,7 +881,7 @@ static int sa1111_resume(struct platform_device *dev)
 	unsigned long flags, id;
 	void __iomem *base;
 
-	save = (struct sa1111_save_data *)dev->dev.power.saved_state;
+	save = sachip->saved_state;
 	if (!save)
 		return 0;
 
@@ -923,7 +926,7 @@ static int sa1111_resume(struct platform_device *dev)
 
 	spin_unlock_irqrestore(&sachip->lock, flags);
 
-	dev->dev.power.saved_state = NULL;
+	sachip->saved_state = NULL;
 	kfree(save);
 
 	return 0;
@@ -958,8 +961,8 @@ static int sa1111_remove(struct platform_device *pdev)
 		platform_set_drvdata(pdev, NULL);
 
 #ifdef CONFIG_PM
-		kfree(pdev->dev.power.saved_state);
-		pdev->dev.power.saved_state = NULL;
+		kfree(sachip->saved_state);
+		sachip->saved_state = NULL;
 #endif
 	}
 
diff --git a/arch/arm/mach-sa1100/neponset.c b/arch/arm/mach-sa1100/neponset.c
index 4cbf946..3a0a1ee 100644
--- a/arch/arm/mach-sa1100/neponset.c
+++ b/arch/arm/mach-sa1100/neponset.c
@@ -185,28 +185,21 @@ static int __devinit neponset_probe(struct platform_device *dev)
 /*
  * LDM power management.
  */
+static unsigned int neponset_saved_state;
+
 static int neponset_suspend(struct platform_device *dev, pm_message_t state)
 {
 	/*
 	 * Save state.
 	 */
-	if (!dev->dev.power.saved_state)
-		dev->dev.power.saved_state = kmalloc(sizeof(unsigned int), GFP_KERNEL);
-	if (!dev->dev.power.saved_state)
-		return -ENOMEM;
-
-	*(unsigned int *)dev->dev.power.saved_state = NCR_0;
+	neponset_saved_state = NCR_0;
 
 	return 0;
 }
 
 static int neponset_resume(struct platform_device *dev)
 {
-	if (dev->dev.power.saved_state) {
-		NCR_0 = *(unsigned int *)dev->dev.power.saved_state;
-		kfree(dev->dev.power.saved_state);
-		dev->dev.power.saved_state = NULL;
-	}
+	NCR_0 = neponset_saved_state;
 
 	return 0;
 }
-- 
1.5.2.2

