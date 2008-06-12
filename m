Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbYFLSAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbYFLSAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 14:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbYFLSAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 14:00:40 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:57950 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753433AbYFLSAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 14:00:39 -0400
Subject: sysdev: fix debugging statements in registration code.
Message-Id: <20080612180034.607582396@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben-linux@fluff.org>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: ben@fluff.org, Ben Dooks <ben-linux@fluff.org>
Content-Disposition: inline; filename=simtec/simtec-drivers-base-sys-fix-debug.patch
Date: Thu, 12 Jun 2008 19:00:34 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The systdev_class_register() and sysdev_register() functions have
pr_debug() statements which are enabled when the user selects the
driver core debug. Both of these routines do not produce the
correct output, as they make assumptions about data which has not
been initialised.

In sysdev_class_register() the code uses the kobject_name(&cls->kset.kobj)
at the start of the function, but this is not setup until later in the 
same call. Change this to use cls->name which is passed in from the caller.

The sysdev_register() function tries to get the name of the sysdev by 
kobject_name(&sysdev->kobj), but that isn't setup until later in the same
function so change this message to use the name of the sysdev's class and
add another message once the name is initialised.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

--- linux-2.6.26-rc5-quilt2.orig/drivers/base/sys.c	2008-06-12 17:09:23.000000000 +0100
+++ linux-2.6.26-rc5-quilt2/drivers/base/sys.c	2008-06-12 18:44:37.000000000 +0100
@@ -130,8 +130,8 @@ static struct kset *system_kset;
 
 int sysdev_class_register(struct sysdev_class * cls)
 {
-	pr_debug("Registering sysdev class '%s'\n",
-		 kobject_name(&cls->kset.kobj));
+	pr_debug("Registering sysdev class '%s'\n", cls->name);
+
 	INIT_LIST_HEAD(&cls->drivers);
 	memset(&cls->kset.kobj, 0x00, sizeof(struct kobject));
 	cls->kset.kobj.parent = &system_kset->kobj;
@@ -241,7 +241,8 @@ int sysdev_register(struct sys_device * 
 	if (!cls)
 		return -EINVAL;
 
-	pr_debug("Registering sys device '%s'\n", kobject_name(&sysdev->kobj));
+	pr_debug("Registering sys device of class '%s'\n",
+		 kobject_name(&cls->kset.kobj));
 
 	/* initialize the kobject to 0, in case it had previously been used */
 	memset(&sysdev->kobj, 0x00, sizeof(struct kobject));
@@ -257,6 +258,9 @@ int sysdev_register(struct sys_device * 
 	if (!error) {
 		struct sysdev_driver * drv;
 
+		pr_debug("Registering sys device '%s'\n",
+			 kobject_name(&sysdev->kobj));
+
 		mutex_lock(&sysdev_drivers_lock);
 		/* Generic notification is implicit, because it's that
 		 * code that should have called us.
@@ -269,6 +273,7 @@ int sysdev_register(struct sys_device * 
 		}
 		mutex_unlock(&sysdev_drivers_lock);
 	}
+
 	kobject_uevent(&sysdev->kobj, KOBJ_ADD);
 	return error;
 }

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
