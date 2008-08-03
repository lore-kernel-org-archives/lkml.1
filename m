Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbYHCONR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbYHCONR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 10:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbYHCONA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 10:13:00 -0400
Received: from calf.ext.ti.com ([198.47.26.144]:47664 "EHLO calf.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424AbYHCOM7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 10:12:59 -0400
From: "Dasgupta, Romit" <romit@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: David Engraf <david.engraf@netcom.eu>, Greg KH <greg@kroah.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 3 Aug 2008 19:42:45 +0530
Subject: [PATCH] [PM] Fixes missing PM entries in sysfs without
 CONFIG_PM_SLEEP
Thread-Topic: [PATCH] [PM] Fixes missing PM entries in sysfs without
 CONFIG_PM_SLEEP
Thread-Index: Acj0+fqPPF3uXLmbS4Gff3qvTw7L+QAdJ6FQ
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593013C91EF11@dbde02.ent.ti.com>
References: <B85A65D85D7EB246BE421B3FB0FBB593013C91EE00@dbde02.ent.ti.com>
 <Pine.LNX.4.44L0.0808021944110.18555-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808021944110.18555-100000@netrider.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,
         Here is a patch for you. Tested with

1) CONFIG_SUSPEND, CONFIG_HIBERNATION i.e. with CONFIG_PM_SLEEP
2) without CONFIG_PM_SLEEP but with CONFIG_PM
3) without CONFIG_PM

Thanks,
-Romit


Description: Fixes missing PM entries in sysfs without CONFIG_PM_SLEEP.
Signed-off-by: Romit Dasgupta <romit@ti.com>
diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
index a3252c0..ad8112d 100644
--- a/drivers/base/power/power.h
+++ b/drivers/base/power/power.h
@@ -1,3 +1,25 @@
+#ifdef CONFIG_PM
+
+/*
+ * sysfs.c
+ */
+
+extern int dpm_sysfs_add(struct device *);
+extern void dpm_sysfs_remove(struct device *);
+
+#else /* CONFIG_PM */
+
+static inline int dpm_sysfs_add(struct device *dev)
+{
+       return 0;
+}
+
+static inline void dpm_sysfs_remove(struct device *dev)
+{
+}
+
+#endif
+
 #ifdef CONFIG_PM_SLEEP

 /*
@@ -16,29 +38,13 @@ extern void device_pm_remove(struct device *);

 #else /* CONFIG_PM_SLEEP */

-static inline int device_pm_add(struct device *dev) { return 0; }
-static inline void device_pm_remove(struct device *dev) {}
-
-#endif
-
-#ifdef CONFIG_PM
-
-/*
- * sysfs.c
- */
-
-extern int dpm_sysfs_add(struct device *);
-extern void dpm_sysfs_remove(struct device *);
-
-#else /* CONFIG_PM */
-
-static inline int dpm_sysfs_add(struct device *dev)
+static inline int device_pm_add(struct device *dev)
 {
-       return 0;
+       return dpm_sysfs_add(dev);
 }
-
-static inline void dpm_sysfs_remove(struct device *dev)
+static inline void device_pm_remove(struct device *dev)
 {
+       dpm_sysfs_remove(dev);
 }

 #endif

>-----Original Message-----
>From: Alan Stern [mailto:stern@rowland.harvard.edu]
>Sent: Sunday, August 03, 2008 5:16 AM
>To: Dasgupta, Romit
>Cc: David Engraf; Greg KH; linux-usb@vger.kernel.org
>Subject: RE: usb_create_sysfs_dev_files in hub.c:1586 fails on system boot
>
>On Fri, 1 Aug 2008, Dasgupta, Romit wrote:
>
>> CONFIG_PM_SLEEP needs to be enabled for power to be added as a sysfs and
>that is dependent on CONFIG_SUSPEND (Suspend to RAM and standby).
>
>You're right.  I thought we had fixed that some time ago, but it's
>still wrong.  In particular, the inline definition of device_pm_add()
>in drivers/base/power/power.h is wrong; it needs to call
>dpm_sysfs_add().
>
>I can't make up a patch now; I'll do it on Monday if nobody beats me to
>it.
>
>Alan Stern

