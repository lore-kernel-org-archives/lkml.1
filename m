Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbZDDVXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbZDDVXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 17:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbZDDVXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 17:23:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38393 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbZDDVX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 17:23:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [RFC][PATCH] PM: Warn if interrupts are enabled during suspend-resume of sysdevs
Date: Sat, 4 Apr 2009 23:23:19 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904042323.19866.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Sysdev have to be suspended and resumed with interrupts disabled and
things usually break in a way that's difficult to debug if one of
sysdev drivers enables interrupts by mistake during suspend or
resume.  Add extra checks that will generate warnings in such cases.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/sys.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

Index: linux-2.6/drivers/base/sys.c
===================================================================
--- linux-2.6.orig/drivers/base/sys.c
+++ linux-2.6/drivers/base/sys.c
@@ -343,11 +343,15 @@ static void __sysdev_resume(struct sys_d
 	/* First, call the class-specific one */
 	if (cls->resume)
 		cls->resume(dev);
+	WARN_ONCE(!irqs_disabled(),
+		"Interrupts enabled after %pF\n", cls->resume);
 
 	/* Call auxillary drivers next. */
 	list_for_each_entry(drv, &cls->drivers, entry) {
 		if (drv->resume)
 			drv->resume(dev);
+		WARN_ONCE(!irqs_disabled(),
+			"Interrupts enabled after %pF\n", drv->resume);
 	}
 }
 
@@ -377,6 +381,9 @@ int sysdev_suspend(pm_message_t state)
 	if (ret)
 		return ret;
 
+	WARN_ONCE(!irqs_disabled(),
+		"Interrupts enabled while suspending system devices");
+
 	pr_debug("Suspending System Devices\n");
 
 	list_for_each_entry_reverse(cls, &system_kset->list, kset.kobj.entry) {
@@ -393,6 +400,9 @@ int sysdev_suspend(pm_message_t state)
 					if (ret)
 						goto aux_driver;
 				}
+				WARN_ONCE(!irqs_disabled(),
+					"Interrupts enabled after %pF\n",
+					drv->suspend);
 			}
 
 			/* Now call the generic one */
@@ -400,6 +410,9 @@ int sysdev_suspend(pm_message_t state)
 				ret = cls->suspend(sysdev, state);
 				if (ret)
 					goto cls_driver;
+				WARN_ONCE(!irqs_disabled(),
+					"Interrupts enabled after %pF\n",
+					cls->suspend);
 			}
 		}
 	}
@@ -452,6 +465,9 @@ int sysdev_resume(void)
 {
 	struct sysdev_class *cls;
 
+	WARN_ONCE(!irqs_disabled(),
+		"Interrupts enabled while resuming system devices");
+
 	pr_debug("Resuming System Devices\n");
 
 	list_for_each_entry(cls, &system_kset->list, kset.kobj.entry) {
