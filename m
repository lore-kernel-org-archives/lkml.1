Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbZGUIGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbZGUIGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 04:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZGUIGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 04:06:18 -0400
Received: from mail-px0-f193.google.com ([209.85.216.193]:35167 "EHLO
	mail-px0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbZGUIGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 04:06:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=KfO5OCJD/ZjPKlNAbe9YVVWOKBs40/fMJDAtsx4Xz65jgHP5fa+XPW67ew+5bBEv7c
         yOQCVgIbcYMQK2jzYFJf3WRZNJio+Nen9XUztlpFcUSSYkdvsqOyGQqHPXTInTq31YUl
         wEBKXQn5C6/2mzci/9DmfAwWatdiwwe8Co2oY=
Date: Tue, 21 Jul 2009 01:06:13 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC/RFT] serio - switch to using dev_pm_ops
Message-ID: <20090721080612.GC10168@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And here is the serio conversion to the new PM infrastructure.

-- 
Dmitry

Input: serio - switch to using dev_pm_ops

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/serio/serio.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)


diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index d66f494..4251a63 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -931,15 +931,11 @@ static int serio_uevent(struct device *dev, struct kobj_uevent_env *env)
 #endif /* CONFIG_HOTPLUG */
 
 #ifdef CONFIG_PM
-static int serio_suspend(struct device *dev, pm_message_t state)
+static int serio_suspend(struct device *dev)
 {
 	struct serio *serio = to_serio_port(dev);
 
-	if (!serio->suspended && state.event == PM_EVENT_SUSPEND)
-		serio_cleanup(serio);
-
-	serio->suspended = state.event == PM_EVENT_SUSPEND ||
-			   state.event == PM_EVENT_FREEZE;
+	serio_cleanup(serio);
 
 	return 0;
 }
@@ -952,15 +948,24 @@ static int serio_resume(struct device *dev)
 	 * Driver reconnect can take a while, so better let kseriod
 	 * deal with it.
 	 */
-	if (serio->suspended) {
-		serio->suspended = false;
-		serio_queue_event(serio, NULL, SERIO_RECONNECT_PORT);
-	}
+	serio_queue_event(serio, NULL, SERIO_RECONNECT_PORT);
 
 	return 0;
 }
+#else
+#define serio_suspend	NULL
+#define serio_resume	NULL
 #endif /* CONFIG_PM */
 
+static const struct dev_pm_ops serio_pm_ops = {
+	.suspend	= serio_suspend,
+	.resume		= serio_resume,
+	.poweroff	= serio_suspend,
+	.thaw		= serio_resume,
+};
+
+
+
 /* called from serio_driver->connect/disconnect methods under serio_mutex */
 int serio_open(struct serio *serio, struct serio_driver *drv)
 {
@@ -1014,10 +1019,7 @@ static struct bus_type serio_bus = {
 	.probe		= serio_driver_probe,
 	.remove		= serio_driver_remove,
 	.shutdown	= serio_shutdown,
-#ifdef CONFIG_PM
-	.suspend	= serio_suspend,
-	.resume		= serio_resume,
-#endif
+	.pm		= &serio_pm_ops,
 };
 
 static int __init serio_init(void)
