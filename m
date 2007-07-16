Return-Path: <linux-kernel-owner+w=401wt.eu-S1766000AbXGPODn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766000AbXGPODn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932276AbXGPOBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:01:43 -0400
Received: from qb-out-0506.google.com ([72.14.204.225]:15344 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbXGPOBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:01:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Oq+SHeJHf+itKzUk4Ha+O7MwmhY2f2k+mk6+X4Pjzbn9TjYz2qsvvaEia2ssUqOm/yjGHzJCFZA5vq72vSb06OviUKbeAiWGagMkrQM4Xh5qKSNI4AW63cVQ6j/U9qrO3pijbxdDbEqggcMjNL0ScxdN/Tj8sYmkS9ZBNs9ITWg=
Date: Mon, 16 Jul 2007 22:51:38 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/10] sysdev: add error check in sysdev_register()
Message-ID: <20070716135138.GB2040@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
References: <20070716134855.GA1858@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716134855.GA1858@APFDCB5C>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables to catch the errors returned by add() procedure of
sysdev driver in sysdev_register.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 drivers/base/sys.c |   48 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 10 deletions(-)

Index: 2.6-mm/drivers/base/sys.c
===================================================================
--- 2.6-mm.orig/drivers/base/sys.c
+++ 2.6-mm/drivers/base/sys.c
@@ -220,10 +220,13 @@ EXPORT_SYMBOL_GPL(sysdev_driver_unregist
  *	@sysdev:	device in question
  *
  */
-int sysdev_register(struct sys_device * sysdev)
+int sysdev_register(struct sys_device *sysdev)
 {
 	int error;
-	struct sysdev_class * cls = sysdev->cls;
+	struct sysdev_class *cls = sysdev->cls;
+	struct sysdev_driver *drv;
+	int added_sysdev = 0;
+	int added_cls = 0;
 
 	if (!cls)
 		return -EINVAL;
@@ -244,8 +247,6 @@ int sysdev_register(struct sys_device * 
 	error = kobject_register(&sysdev->kobj);
 
 	if (!error) {
-		struct sysdev_driver * drv;
-
 		mutex_lock(&sysdev_drivers_lock);
 		/* Generic notification is implicit, because it's that
 		 * code that should have called us.
@@ -253,23 +254,50 @@ int sysdev_register(struct sys_device * 
 
 		/* Notify global drivers */
 		list_for_each_entry(drv, &sysdev_drivers, entry) {
-			if (drv->add)
-				drv->add(sysdev);
+			if (drv->add) {
+				error = drv->add(sysdev);
+				if (error)
+					goto error_sysdev;
+			}
+			added_sysdev++;
 		}
 
 		/* Notify class auxillary drivers */
 		list_for_each_entry(drv, &cls->drivers, entry) {
-			if (drv->add)
-				drv->add(sysdev);
+			if (drv->add) {
+				error = drv->add(sysdev);
+				if (error)
+					goto error_cls;
+			}
+			added_cls++;
 		}
 		mutex_unlock(&sysdev_drivers_lock);
 	}
 	return error;
+
+error_cls:
+	list_for_each_entry(drv, &cls->drivers, entry) {
+		if (added_sysdev--)
+			break;
+		if (drv->add && drv->remove)
+			drv->remove(sysdev);
+	}
+error_sysdev:
+	list_for_each_entry(drv, &sysdev_drivers, entry) {
+		if (added_cls--)
+			break;
+		if (drv->add && drv->remove)
+			drv->remove(sysdev);
+	}
+	mutex_unlock(&sysdev_drivers_lock);
+	kobject_unregister(&sysdev->kobj);
+
+	return error;
 }
 
-void sysdev_unregister(struct sys_device * sysdev)
+void sysdev_unregister(struct sys_device *sysdev)
 {
-	struct sysdev_driver * drv;
+	struct sysdev_driver *drv;
 
 	mutex_lock(&sysdev_drivers_lock);
 	list_for_each_entry(drv, &sysdev_drivers, entry) {
