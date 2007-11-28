Return-Path: <linux-kernel-owner+w=401wt.eu-S1761265AbXK1Of5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761265AbXK1Of5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 09:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759503AbXK1OfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 09:35:25 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:62241 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756902AbXK1OfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 09:35:22 -0500
Message-Id: <20071128143438.407055000@pademelon.sonytel.be>
References: <20071128143142.580732000@pademelon.sonytel.be>
User-Agent: quilt/0.46-1
Date: Wed, 28 Nov 2007 15:31:46 +0100
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linux/PPC Development <linuxppc-dev@ozlabs.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 4/7] ps3: Add repository polling loop to work around hypervisor bug
Content-Disposition: inline; filename=ps3-wip/ps3-storage-fw190-workaround.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3: Add repository polling loop to work around hypervisor bug

On some firmware versions (e.g. 1.90), the storage device may not show up
in the repository immediately after receiving the notification message.
Add a small polling loop to make sure we don't miss it.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 arch/powerpc/platforms/ps3/device-init.c |   47 ++++++++++++++++++++++---------
 1 files changed, 34 insertions(+), 13 deletions(-)

--- a/arch/powerpc/platforms/ps3/device-init.c
+++ b/arch/powerpc/platforms/ps3/device-init.c
@@ -581,6 +581,39 @@ static int ps3_notification_read_write(s
 	return 0;
 }
 
+static void ps3_find_and_add_device(u64 bus_id, u64 dev_id)
+{
+	struct ps3_repository_device repo;
+	int res;
+	unsigned int retries;
+	unsigned long rem;
+
+	/*
+	 * On some firmware versions (e.g. 1.90), the device may not show up
+	 * in the repository immediately
+	 */
+	for (retries = 0; retries < 10; retries++) {
+		res = ps3_repository_find_device_by_id(&repo, bus_id, dev_id);
+		if (!res)
+			goto found;
+
+		rem = msleep_interruptible(100);
+		if (rem)
+			break;
+	}
+	pr_warning("%s:%u: device %lu:%lu not found\n", __func__, __LINE__,
+		   bus_id, dev_id);
+	return;
+
+found:
+	if (retries)
+		pr_debug("%s:%u: device %lu:%lu found after %u retries\n",
+			 __func__, __LINE__, bus_id, dev_id, retries);
+
+	ps3_register_repository_device(&repo);
+	return;
+}
+
 
 /**
  * ps3_probe_thread - Background repository probing at system startup.
@@ -595,7 +628,6 @@ static int ps3_notification_read_write(s
 static int ps3_probe_thread(void *data)
 {
 	struct ps3_notification_device dev;
-	struct ps3_repository_device repo;
 	int res;
 	unsigned int irq;
 	u64 lpar;
@@ -677,18 +709,7 @@ static int ps3_probe_thread(void *data)
 			continue;
 		}
 
-		res = ps3_repository_find_device_by_id(&repo, dev.sbd.bus_id,
-						       notify_event->dev_id);
-		if (res) {
-			pr_warning("%s:%u: device %lu:%lu not found\n",
-				   __func__, __LINE__, dev.sbd.bus_id,
-				   notify_event->dev_id);
-			continue;
-		}
-
-		pr_debug("%s:%u: device %lu:%lu found\n", __func__, __LINE__,
-			 dev.sbd.bus_id, notify_event->dev_id);
-		ps3_register_repository_device(&repo);
+		ps3_find_and_add_device(dev.sbd.bus_id, notify_event->dev_id);
 
 	} while (!kthread_should_stop());
 

-- 
With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619

