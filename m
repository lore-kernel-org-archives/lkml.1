Return-Path: <linux-kernel-owner+w=401wt.eu-S1753649Ab0AVXUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab0AVXUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 18:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755535Ab0AVXT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 18:19:29 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:44844 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab0AVXTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 18:19:19 -0500
Message-Id: <8c1e6ca64ededd5e94e1d1aa1517898a66eb02e4.1264201406.git.jan.kiszka@web.de>
In-Reply-To: <cover.1264201406.git.jan.kiszka@web.de>
References: <cover.1264201406.git.jan.kiszka@web.de>
From: Jan Kiszka <jan.kiszka@web.de>
To: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>
Cc: linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org
Date: Wed, 6 Jan 2010 19:02:14 +0100
Subject: [PATCH 07/31] CAPI: Convert capi drivers rwlock into mutex
X-Provags-ID: V01U2FsdGVkX18rIHbvcsx2Q3sso9WfU4loDjQGJs9dVSFEFPZF
	r775uRrh4UgZG8rj4o+CLU4N/zO56Gq9+sSv8LTjvcPwBhoXFG
	eLaw7SY18=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn the lock protecting registered capi drivers into a mutex and apply
it consistently.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---
 drivers/isdn/capi/kcapi.c      |   49 ++++++++++++++++++----------------------
 drivers/isdn/capi/kcapi.h      |    2 +-
 drivers/isdn/capi/kcapi_proc.c |    8 +++---
 3 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/drivers/isdn/capi/kcapi.c b/drivers/isdn/capi/kcapi.c
index 402a16b..476239f 100644
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -61,7 +61,7 @@ static char capi_manufakturer[64] = "AVM Berlin";
 #define NCCI2CTRL(ncci)    (((ncci) >> 24) & 0x7f)
 
 LIST_HEAD(capi_drivers);
-DEFINE_RWLOCK(capi_drivers_list_lock);
+DEFINE_MUTEX(capi_drivers_lock);
 
 static DEFINE_RWLOCK(application_lock);
 static DEFINE_MUTEX(controller_mutex);
@@ -544,11 +544,9 @@ EXPORT_SYMBOL(detach_capi_ctr);
 
 void register_capi_driver(struct capi_driver *driver)
 {
-	unsigned long flags;
-
-	write_lock_irqsave(&capi_drivers_list_lock, flags);
+	mutex_lock(&capi_drivers_lock);
 	list_add_tail(&driver->list, &capi_drivers);
-	write_unlock_irqrestore(&capi_drivers_list_lock, flags);
+	mutex_unlock(&capi_drivers_lock);
 }
 
 EXPORT_SYMBOL(register_capi_driver);
@@ -562,11 +560,9 @@ EXPORT_SYMBOL(register_capi_driver);
 
 void unregister_capi_driver(struct capi_driver *driver)
 {
-	unsigned long flags;
-
-	write_lock_irqsave(&capi_drivers_list_lock, flags);
+	mutex_lock(&capi_drivers_lock);
 	list_del(&driver->list);
-	write_unlock_irqrestore(&capi_drivers_list_lock, flags);
+	mutex_unlock(&capi_drivers_lock);
 }
 
 EXPORT_SYMBOL(unregister_capi_driver);
@@ -903,7 +899,6 @@ static int old_capi_manufacturer(unsigned int cmd, void __user *data)
 	struct capi_driver *driver = NULL;
 	capiloaddata ldata;
 	struct list_head *l;
-	unsigned long flags;
 	int retval;
 
 	switch (cmd) {
@@ -923,7 +918,8 @@ static int old_capi_manufacturer(unsigned int cmd, void __user *data)
 		cparams.irq = cdef.irq;
 		cparams.cardnr = cdef.cardnr;
 
-		read_lock_irqsave(&capi_drivers_list_lock, flags);
+		mutex_lock(&capi_drivers_lock);
+
                 switch (cdef.cardtype) {
 			case AVM_CARDTYPE_B1:
 				list_for_each(l, &capi_drivers) {
@@ -944,18 +940,15 @@ static int old_capi_manufacturer(unsigned int cmd, void __user *data)
 				break;
 		}
 		if (!driver) {
-			read_unlock_irqrestore(&capi_drivers_list_lock, flags);
 			printk(KERN_ERR "kcapi: driver not loaded.n");
-			return -EIO;
-		}
-		if (!driver->add_card) {
-			read_unlock_irqrestore(&capi_drivers_list_lock, flags);
+			retval = -EIO;
+		} else if (!driver->add_card) {
 			printk(KERN_ERR "kcapi: driver has no add card function.n");
-			return -EIO;
-		}
+			retval = -EIO;
+		} else
+			retval = driver->add_card(driver, &cparams);
 
-		retval = driver->add_card(driver, &cparams);
-		read_unlock_irqrestore(&capi_drivers_list_lock, flags);
+		mutex_unlock(&capi_drivers_lock);
 		return retval;
 
 	case AVMB1_LOAD:
@@ -1111,6 +1104,8 @@ int capi20_manufacturer(unsigned int cmd, void __user *data)
 		cparams.cardtype = 0;
 		cdef.driver[sizeof(cdef.driver)-1] = 0;
 
+		mutex_lock(&capi_drivers_lock);
+
 		list_for_each(l, &capi_drivers) {
 			driver = list_entry(l, struct capi_driver, list);
 			if (strcmp(driver->name, cdef.driver) == 0)
@@ -1119,15 +1114,15 @@ int capi20_manufacturer(unsigned int cmd, void __user *data)
 		if (driver == NULL) {
 			printk(KERN_ERR "kcapi: driver "%s" not loaded.n",
 					cdef.driver);
-			return -ESRCH;
-		}
-
-		if (!driver->add_card) {
+			retval = -ESRCH;
+		} else if (!driver->add_card) {
 			printk(KERN_ERR "kcapi: driver "%s" has no add card function.n", cdef.driver);
-			return -EIO;
-		}
+			retval = -EIO;
+		} else
+			retval = driver->add_card(driver, &cparams);
 
-		return driver->add_card(driver, &cparams);
+		mutex_unlock(&capi_drivers_lock);
+		return retval;
 	}
 
 	default:
diff --git a/drivers/isdn/capi/kcapi.h b/drivers/isdn/capi/kcapi.h
index f62c53b..07c5850 100644
--- a/drivers/isdn/capi/kcapi.h
+++ b/drivers/isdn/capi/kcapi.h
@@ -30,7 +30,7 @@ enum {
 };
 
 extern struct list_head capi_drivers;
-extern rwlock_t capi_drivers_list_lock;
+extern struct mutex capi_drivers_lock;
 
 extern struct capi20_appl *capi_applications[CAPI_MAXAPPL];
 extern struct capi_ctr *capi_controller[CAPI_MAXCONTR];
diff --git a/drivers/isdn/capi/kcapi_proc.c b/drivers/isdn/capi/kcapi_proc.c
index 59fd16a..71b0761 100644
--- a/drivers/isdn/capi/kcapi_proc.c
+++ b/drivers/isdn/capi/kcapi_proc.c
@@ -238,9 +238,9 @@ static const struct file_operations proc_applstats_ops = {
 // ---------------------------------------------------------------------------
 
 static void *capi_driver_start(struct seq_file *seq, loff_t *pos)
-	__acquires(&capi_drivers_list_lock)
+	__acquires(&capi_drivers_lock)
 {
-	read_lock(&capi_drivers_list_lock);
+	mutex_lock(&capi_drivers_lock);
 	return seq_list_start(&capi_drivers, *pos);
 }
 
@@ -250,9 +250,9 @@ static void *capi_driver_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void capi_driver_stop(struct seq_file *seq, void *v)
-	__releases(&capi_drivers_list_lock)
+	__releases(&capi_drivers_lock)
 {
-	read_unlock(&capi_drivers_list_lock);
+	mutex_unlock(&capi_drivers_lock);
 }
 
 static int capi_driver_show(struct seq_file *seq, void *v)
-- 
1.6.0.2

