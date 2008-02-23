Return-Path: <linux-kernel-owner+w=401wt.eu-S933648AbYBWK3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933648AbYBWK3t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 05:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbYBWK3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 05:29:40 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57034 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752846AbYBWK3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 05:29:39 -0500
Date: Sat, 23 Feb 2008 11:30:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: power_state: remove from input & rfkill
Message-ID: <20080223103001.GA3837@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


power_state is being removed from kernel, this time in input.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 2763394..3816e44 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -895,13 +895,8 @@ #ifdef CONFIG_PM
 
 static int i8042_suspend(struct platform_device *dev, pm_message_t state)
 {
-	if (dev->dev.power.power_state.event != state.event) {
-		if (state.event == PM_EVENT_SUSPEND)
-			i8042_controller_reset();
-
-		dev->dev.power.power_state = state;
-	}
-
+	if (state.event == PM_EVENT_SUSPEND)
+		i8042_controller_reset();
 	return 0;
 }
 
@@ -914,12 +909,6 @@ static int i8042_resume(struct platform_
 {
 	int error;
 
-/*
- * Do not bother with restoring state if we haven't suspened yet
- */
-	if (dev->dev.power.power_state.event == PM_EVENT_ON)
-		return 0;
-
 	error = i8042_controller_check();
 	if (error)
 		return error;
@@ -954,9 +943,6 @@ static int i8042_resume(struct platform_
 		i8042_enable_kbd_port();
 
 	i8042_interrupt(0, NULL);
-
-	dev->dev.power.power_state = PMSG_ON;
-
 	return 0;
 }
 #endif /* CONFIG_PM */
diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index 7f52938..0673f3a 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -912,13 +912,8 @@ #endif /* CONFIG_HOTPLUG */
 #ifdef CONFIG_PM
 static int serio_suspend(struct device *dev, pm_message_t state)
 {
-	if (dev->power.power_state.event != state.event) {
-		if (state.event == PM_EVENT_SUSPEND)
-			serio_cleanup(to_serio_port(dev));
-
-		dev->power.power_state = state;
-	}
-
+	if (state.event == PM_EVENT_SUSPEND)
+		serio_cleanup(to_serio_port(dev));
 	return 0;
 }
 
@@ -926,8 +921,7 @@ static int serio_resume(struct device *d
 {
 	struct serio *serio = to_serio_port(dev);
 
-	if (dev->power.power_state.event != PM_EVENT_ON &&
-	    serio_reconnect_driver(serio)) {
+	if (serio_reconnect_driver(serio)) {
 		/*
 		 * Driver re-probing can take a while, so better let kseriod
 		 * deal with it.
@@ -935,8 +929,6 @@ static int serio_resume(struct device *d
 		serio_rescan(serio);
 	}
 
-	dev->power.power_state = PMSG_ON;
-
 	return 0;
 }
 #endif /* CONFIG_PM */
diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 1a47f5d..81d7f5f 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -231,18 +231,14 @@ static int rfkill_suspend(struct device 
 {
 	struct rfkill *rfkill = to_rfkill(dev);
 
-	if (dev->power.power_state.event != state.event) {
-		if (state.event == PM_EVENT_SUSPEND) {
-			mutex_lock(&rfkill->mutex);
-
-			if (rfkill->state == RFKILL_STATE_ON)
-				rfkill->toggle_radio(rfkill->data,
-						     RFKILL_STATE_OFF);
+	if (state.event == PM_EVENT_SUSPEND) {
+		mutex_lock(&rfkill->mutex);
 
-			mutex_unlock(&rfkill->mutex);
-		}
+		if (rfkill->state == RFKILL_STATE_ON)
+			rfkill->toggle_radio(rfkill->data,
+					     RFKILL_STATE_OFF);
 
-		dev->power.power_state = state;
+		mutex_unlock(&rfkill->mutex);
 	}
 
 	return 0;
@@ -252,16 +248,12 @@ static int rfkill_resume(struct device *
 {
 	struct rfkill *rfkill = to_rfkill(dev);
 
-	if (dev->power.power_state.event != PM_EVENT_ON) {
-		mutex_lock(&rfkill->mutex);
+	mutex_lock(&rfkill->mutex);
 
-		if (rfkill->state == RFKILL_STATE_ON)
-			rfkill->toggle_radio(rfkill->data, RFKILL_STATE_ON);
+	if (rfkill->state == RFKILL_STATE_ON)
+		rfkill->toggle_radio(rfkill->data, RFKILL_STATE_ON);
 
-		mutex_unlock(&rfkill->mutex);
-	}
-
-	dev->power.power_state = PMSG_ON;
+	mutex_unlock(&rfkill->mutex);
 	return 0;
 }
 #else



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
