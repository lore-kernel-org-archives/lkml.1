Return-Path: <linux-kernel-owner+w=401wt.eu-S1752919AbZGUIEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbZGUIEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 04:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbZGUIEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 04:04:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:9933 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbZGUIEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 04:04:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=XiQ6F4Ne3a8vxBMbbM+no8UPpNusjznHxsEIujApJdI6vmPpXwqOg/6BVxuqgr5t8q
         0E/YfwW6PbAKHMiOT8waouKS3UJo3USugENTyhSOkvwIHqtIVWAyy8OyFURAG18ftbx2
         /u3T3vI23ZlGtoCTacpaQ5P8Oon4xjinZbqvI=
Date: Tue, 21 Jul 2009 01:04:42 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC/RFT] Input: i8042 - switch to using dev_pm_ops
Message-ID: <20090721080442.GB10168@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is an attempt to switch i8042 to the new PM infrastructure,
please give it a spin.

Thanks!

-- 
Dmitry

Input: i8042 - switch to using dev_pm_ops

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/serio/i8042.c |   46 +++++++++++++++++++------------------------
 1 files changed, 20 insertions(+), 26 deletions(-)


diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 582245c..8afe0b3 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -923,41 +923,27 @@ static void i8042_dritek_enable(void)
 
 #ifdef CONFIG_PM
 
-static bool i8042_suspended;
-
 /*
- * Here we try to restore the original BIOS settings. We only want to
- * do that once, when we really suspend, not when we taking memory
- * snapshot for swsusp (in this case we'll perform required cleanup
- * as part of shutdown process).
+ * Here we try to restore the original BIOS settings to avoid
+ * upsetting it.
  */
 
-static int i8042_suspend(struct platform_device *dev, pm_message_t state)
+static int i8042_pm_reset(struct device *dev)
 {
-	if (!i8042_suspended && state.event == PM_EVENT_SUSPEND)
-		i8042_controller_reset();
-
-	i8042_suspended = state.event == PM_EVENT_SUSPEND ||
-			  state.event == PM_EVENT_FREEZE;
+	i8042_controller_reset();
 
 	return 0;
 }
 
-
 /*
- * Here we try to reset everything back to a state in which suspended
+ * Here we try to reset everything back to a state we had
+ * before suspending.
  */
 
-static int i8042_resume(struct platform_device *dev)
+static int i8042_pm_restore(struct device *dev)
 {
 	int error;
 
-/*
- * Do not bother with restoring state if we haven't suspened yet
- */
-	if (!i8042_suspended)
-		return 0;
-
 	error = i8042_controller_check();
 	if (error)
 		return error;
@@ -1001,13 +987,24 @@ static int i8042_resume(struct platform_device *dev)
 	if (i8042_ports[I8042_KBD_PORT_NO].serio)
 		i8042_enable_kbd_port();
 
-	i8042_suspended = false;
 	i8042_interrupt(0, NULL);
 
 	return 0;
 }
+#else
+
+#define i8042_pm_reset		NULL
+#define i8042_pm_restore	NULL
+
 #endif /* CONFIG_PM */
 
+static const struct dev_pm_ops i8042_pm_ops = {
+	.suspend	= i8042_pm_reset,
+	.resume		= i8042_pm_restore,
+	.poweroff	= i8042_pm_reset,
+	.thaw		= i8042_pm_restore,
+};
+
 /*
  * We need to reset the 8042 back to original mode on system shutdown,
  * because otherwise BIOSes will be confused.
@@ -1251,14 +1248,11 @@ static struct platform_driver i8042_driver = {
 	.driver		= {
 		.name	= "i8042",
 		.owner	= THIS_MODULE,
+		.pm	= &i8042_pm_ops,
 	},
 	.probe		= i8042_probe,
 	.remove		= __devexit_p(i8042_remove),
 	.shutdown	= i8042_shutdown,
-#ifdef CONFIG_PM
-	.suspend	= i8042_suspend,
-	.resume		= i8042_resume,
-#endif
 };
 
 static int __init i8042_init(void)
