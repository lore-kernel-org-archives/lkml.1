Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbYGJAH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbYGJAH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 20:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbYGJAGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 20:06:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49038 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037AbYGJAGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 20:06:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 4/8] serio: Speed-up resume
Date: Thu, 10 Jul 2008 02:01:55 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Shaohua Li <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <200807100152.17755.rjw@sisk.pl>
In-Reply-To: <200807100152.17755.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807100201.56232.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>
Subject: serio: Speed-up resume

serio_resume will call into psmouse_extensions(). In my test, the
routine is very slow, it blocks resume about 1 sec. Below patch (move
resume to kseriod, just like boot time probe) cures the issue in my
test, and seems no side effect. I'm no familiar with serio driver, so
please check. 

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Len Brown <lenb@kernel.org>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/input/serio/serio.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

Index: linux-next/drivers/input/serio/serio.c
===================================================================
--- linux-next.orig/drivers/input/serio/serio.c
+++ linux-next/drivers/input/serio/serio.c
@@ -163,6 +163,7 @@ enum serio_event_type {
 	SERIO_RECONNECT_PORT,
 	SERIO_REGISTER_PORT,
 	SERIO_ATTACH_DRIVER,
+	SERIO_RESUME_PORT,
 };
 
 struct serio_event {
@@ -287,6 +288,13 @@ static struct serio_event *serio_get_eve
 	return event;
 }
 
+#ifdef CONFIG_PM
+static void serio_resume_port(struct device *dev);
+#else
+static inline void serio_resume_port(struct device *dev)
+{
+}
+#endif /* CONFIG_PM */
 static void serio_handle_event(void)
 {
 	struct serio_event *event;
@@ -319,6 +327,10 @@ static void serio_handle_event(void)
 				serio_attach_driver(event->object);
 				break;
 
+			case SERIO_RESUME_PORT:
+				serio_resume_port(event->object);
+				break;
+
 			default:
 				break;
 		}
@@ -925,21 +937,26 @@ static int serio_suspend(struct device *
 	return 0;
 }
 
-static int serio_resume(struct device *dev)
+static void serio_resume_port(struct device *dev)
 {
 	struct serio *serio = to_serio_port(dev);
 
-	if (dev->power.power_state.event != PM_EVENT_ON &&
-	    serio_reconnect_driver(serio)) {
-		/*
-		 * Driver re-probing can take a while, so better let kseriod
-		 * deal with it.
-		 */
-		serio_rescan(serio);
+	if (serio_reconnect_driver(serio)) {
+		serio_disconnect_port(serio);
+		serio_find_driver(serio);
 	}
 
 	dev->power.power_state = PMSG_ON;
+}
 
+static int serio_resume(struct device *dev)
+{
+	/*
+	 * Driver reconnect can take a while, so better let kseriod
+	 * deal with it.
+	 */
+	if (dev->power.power_state.event != PM_EVENT_ON)
+		serio_queue_event(dev, NULL, SERIO_RESUME_PORT);
 	return 0;
 }
 #endif /* CONFIG_PM */

