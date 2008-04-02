Return-Path: <linux-kernel-owner+w=401wt.eu-S1758429AbYDUNbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429AbYDUNbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759908AbYDUNTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:19:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:9129 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890AbYDUNTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:19:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=PaYTeimteEMSQPZyCgf6aezKMHzBPdzr7wTdgmYMDIcTQfqnOpirR2luynuy9tG5Rz0XaBto+SPo/5F30nc58PuMLou3nHF4AcFjUP3MbAijasDaFc24q9y4UriEFOZA/P0S0006aJBuaJUiE6e5lYcI7s79u2oyLQuBQ/coCLg=
Message-Id: <5550fbaeb3cc88fe2982e9b5351073173d733f30.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Wed, 2 Apr 2008 11:22:51 -0400
Subject: [PATCH 10/37] Input: tosakbd - fix suspend
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: Dmitry Baryshkov <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/keyboard/tosakbd.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/input/keyboard/tosakbd.c b/drivers/input/keyboard/tosakbd.c
index 3884d1e..a247006 100644
--- a/drivers/input/keyboard/tosakbd.c
+++ b/drivers/input/keyboard/tosakbd.c
@@ -52,7 +52,7 @@ KEY_X, KEY_F, KEY_SPACE, KEY_APOSTROPHE, TOSA_KEY_MAIL, KEY_LEFT, KEY_DOWN, KEY_
 struct tosakbd {
 	unsigned int keycode[ARRAY_SIZE(tosakbd_keycode)];
 	struct input_dev *input;
-
+	int suspended;
 	spinlock_t lock; /* protect kbd scanning */
 	struct timer_list timer;
 };
@@ -133,6 +133,9 @@ static void tosakbd_scankeyboard(struct platform_device *dev)
 
 	spin_lock_irqsave(&tosakbd->lock, flags);
 
+	if (tosakbd->suspended)
+		goto out;
+
 	for (col = 0; col < TOSA_KEY_STROBE_NUM; col++) {
 		/*
 		 * Discharge the output driver capacitatance
@@ -174,6 +177,7 @@ static void tosakbd_scankeyboard(struct platform_device *dev)
 	if (num_pressed)
 		mod_timer(&tosakbd->timer, jiffies + SCAN_INTERVAL);
 
+ out:
 	spin_unlock_irqrestore(&tosakbd->lock, flags);
 }
 
@@ -200,6 +204,7 @@ static irqreturn_t tosakbd_interrupt(int irq, void *__dev)
 static void tosakbd_timer_callback(unsigned long __dev)
 {
 	struct platform_device *dev = (struct platform_device *)__dev;
+
 	tosakbd_scankeyboard(dev);
 }
 
@@ -207,6 +212,13 @@ static void tosakbd_timer_callback(unsigned long __dev)
 static int tosakbd_suspend(struct platform_device *dev, pm_message_t state)
 {
 	struct tosakbd *tosakbd = platform_get_drvdata(dev);
+	unsigned long flags;
+
+	spin_lock_irqsave(&tosakbd->lock, flags);
+	PGSR1 = (PGSR1 & ~TOSA_GPIO_LOW_STROBE_BIT);
+	PGSR2 = (PGSR2 & ~TOSA_GPIO_HIGH_STROBE_BIT);
+	tosakbd->suspended = 1;
+	spin_unlock_irqrestore(&tosakbd->lock, flags);
 
 	del_timer_sync(&tosakbd->timer);
 
@@ -215,6 +227,9 @@ static int tosakbd_suspend(struct platform_device *dev, pm_message_t state)
 
 static int tosakbd_resume(struct platform_device *dev)
 {
+	struct tosakbd *tosakbd = platform_get_drvdata(dev);
+
+	tosakbd->suspended = 0;
 	tosakbd_scankeyboard(dev);
 
 	return 0;
@@ -365,8 +380,8 @@ fail:
 	return error;
 }
 
-static int __devexit tosakbd_remove(struct platform_device *dev) {
-
+static int __devexit tosakbd_remove(struct platform_device *dev)
+{
 	int i;
 	struct tosakbd *tosakbd = platform_get_drvdata(dev);
 
-- 
1.5.5.rc2.6.gf58d


