Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525Ab0AELsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab0AELsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 06:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494Ab0AELsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 06:48:11 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36329 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab0AELsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 06:48:06 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201001051247.104464547@firstfloor.org>
In-Reply-To: <201001051247.104464547@firstfloor.org>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [PATCH] [5/12] SYSFS: Add attribute array to sysdev classes
Message-Id: <20100105114802.8240CB17C2@basil.firstfloor.org>
Date: Tue,  5 Jan 2010 12:48:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add a attribute array that is automatically registered and unregistered
to struct sysdev_class. This is similar to what struct class has.

A lot of drivers add list of attributes, so it's better to do 
this easily in the common sysdev layer.

This adds a new field to struct sysdev_class. I audited the 
whole tree and there are no dynamically allocated sysdev classes,
so this is fully compatible. 

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/base/sys.c     |    9 ++++++++-
 include/linux/sysdev.h |    2 ++
 2 files changed, 10 insertions(+), 1 deletion(-)

Index: linux-2.6.33-rc2-ak/drivers/base/sys.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/base/sys.c
+++ linux-2.6.33-rc2-ak/drivers/base/sys.c
@@ -145,13 +145,20 @@ int sysdev_class_register(struct sysdev_
 	if (retval)
 		return retval;
 
-	return kset_register(&cls->kset);
+	retval = kset_register(&cls->kset);
+	if (!retval && cls->attrs)
+		retval = sysfs_create_files(&cls->kset.kobj,
+					    (const struct attribute **)cls->attrs);
+	return retval;
 }
 
 void sysdev_class_unregister(struct sysdev_class *cls)
 {
 	pr_debug("Unregistering sysdev class '%s'\n",
 		 kobject_name(&cls->kset.kobj));
+	if (cls->attrs)
+		sysfs_remove_files(&cls->kset.kobj,
+				   (const struct attribute **)cls->attrs);
 	kset_unregister(&cls->kset);
 }
 
Index: linux-2.6.33-rc2-ak/include/linux/sysdev.h
===================================================================
--- linux-2.6.33-rc2-ak.orig/include/linux/sysdev.h
+++ linux-2.6.33-rc2-ak/include/linux/sysdev.h
@@ -27,10 +27,12 @@
 
 
 struct sys_device;
+struct sysdev_class_attribute;
 
 struct sysdev_class {
 	const char *name;
 	struct list_head	drivers;
+	struct sysdev_class_attribute **attrs;
 
 	/* Default operations for these types of devices */
 	int	(*shutdown)(struct sys_device *);
