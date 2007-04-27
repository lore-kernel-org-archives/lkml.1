Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbXD0IpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbXD0IpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 04:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbXD0IpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 04:45:22 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:38245
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755487AbXD0IpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 04:45:21 -0400
Date: Fri, 27 Apr 2007 10:48:12 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 3/5] sysdev: use mutex instead of semaphore
Message-ID: <20070427084812.GE4213@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	gregkh@suse.de, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070427083857.GB4213@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070427083857.GB4213@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the sysdev code use a semaphore as mutex. use the mutex API instead
of the (binary) semaphore

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--
diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 04e5db4..82c41d1 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -155,7 +155,7 @@ EXPORT_SYMBOL_GPL(sysdev_class_unregister);
 
 
 static LIST_HEAD(sysdev_drivers);
-static DECLARE_MUTEX(sysdev_drivers_lock);
+static DEFINE_MUTEX(sysdev_drivers_lock);
 
 /**
  *	sysdev_driver_register - Register auxillary driver
@@ -172,7 +172,7 @@ static DECLARE_MUTEX(sysdev_drivers_lock);
 int sysdev_driver_register(struct sysdev_class * cls,
 			   struct sysdev_driver * drv)
 {
-	down(&sysdev_drivers_lock);
+	mutex_lock(&sysdev_drivers_lock);
 	if (cls && kset_get(&cls->kset)) {
 		list_add_tail(&drv->entry, &cls->drivers);
 
@@ -184,7 +184,7 @@ int sysdev_driver_register(struct sysdev_class * cls,
 		}
 	} else
 		list_add_tail(&drv->entry, &sysdev_drivers);
-	up(&sysdev_drivers_lock);
+	mutex_unlock(&sysdev_drivers_lock);
 	return 0;
 }
 
@@ -197,7 +197,7 @@ int sysdev_driver_register(struct sysdev_class * cls,
 void sysdev_driver_unregister(struct sysdev_class * cls,
 			      struct sysdev_driver * drv)
 {
-	down(&sysdev_drivers_lock);
+	mutex_lock(&sysdev_drivers_lock);
 	list_del_init(&drv->entry);
 	if (cls) {
 		if (drv->remove) {
@@ -207,7 +207,7 @@ void sysdev_driver_unregister(struct sysdev_class * cls,
 		}
 		kset_put(&cls->kset);
 	}
-	up(&sysdev_drivers_lock);
+	mutex_unlock(&sysdev_drivers_lock);
 }
 
 EXPORT_SYMBOL_GPL(sysdev_driver_register);
@@ -246,7 +246,7 @@ int sysdev_register(struct sys_device * sysdev)
 	if (!error) {
 		struct sysdev_driver * drv;
 
-		down(&sysdev_drivers_lock);
+		mutex_lock(&sysdev_drivers_lock);
 		/* Generic notification is implicit, because it's that
 		 * code that should have called us.
 		 */
@@ -262,7 +262,7 @@ int sysdev_register(struct sys_device * sysdev)
 			if (drv->add)
 				drv->add(sysdev);
 		}
-		up(&sysdev_drivers_lock);
+		mutex_unlock(&sysdev_drivers_lock);
 	}
 	return error;
 }
@@ -271,7 +271,7 @@ void sysdev_unregister(struct sys_device * sysdev)
 {
 	struct sysdev_driver * drv;
 
-	down(&sysdev_drivers_lock);
+	mutex_lock(&sysdev_drivers_lock);
 	list_for_each_entry(drv, &sysdev_drivers, entry) {
 		if (drv->remove)
 			drv->remove(sysdev);
@@ -281,7 +281,7 @@ void sysdev_unregister(struct sys_device * sysdev)
 		if (drv->remove)
 			drv->remove(sysdev);
 	}
-	up(&sysdev_drivers_lock);
+	mutex_unlock(&sysdev_drivers_lock);
 
 	kobject_unregister(&sysdev->kobj);
 }
@@ -308,7 +308,7 @@ void sysdev_shutdown(void)
 
 	pr_debug("Shutting Down System Devices\n");
 
-	down(&sysdev_drivers_lock);
+	mutex_lock(&sysdev_drivers_lock);
 	list_for_each_entry_reverse(cls, &system_subsys.kset.list,
 				    kset.kobj.entry) {
 		struct sys_device * sysdev;
@@ -337,7 +337,7 @@ void sysdev_shutdown(void)
 				cls->shutdown(sysdev);
 		}
 	}
-	up(&sysdev_drivers_lock);
+	mutex_unlock(&sysdev_drivers_lock);
 }
 
 static void __sysdev_resume(struct sys_device *dev)

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

     La libertad es como la mañana. Hay quienes esperan dormidos a que
   llegue, pero hay quienes desvelan y caminan la noche para alcanzarla
                        (Subcomandante Marcos)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
