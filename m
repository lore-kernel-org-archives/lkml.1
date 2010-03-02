Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab0CBX7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:59:37 -0500
Received: from kroah.org ([198.145.64.141]:38510 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124Ab0CBX3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:14 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/62] sysfs: Add attribute array to sysdev classes
Date: Tue,  2 Mar 2010 15:28:08 -0800
Message-Id: <1267572541-410-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

Add a attribute array that is automatically registered and unregistered
to struct sysdev_class. This is similar to what struct class has.

A lot of drivers add list of attributes, so it's better to do
this easily in the common sysdev layer.

This adds a new field to struct sysdev_class. I audited the
whole tree and there are no dynamically allocated sysdev classes,
so this is fully compatible.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/sys.c     |    9 ++++++++-
 include/linux/sysdev.h |    2 ++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index a38445c..747c99e 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -145,13 +145,20 @@ int sysdev_class_register(struct sysdev_class *cls)
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
 
diff --git a/include/linux/sysdev.h b/include/linux/sysdev.h
index c2458fa..b6244f9 100644
--- a/include/linux/sysdev.h
+++ b/include/linux/sysdev.h
@@ -27,10 +27,12 @@
 
 
 struct sys_device;
+struct sysdev_class_attribute;
 
 struct sysdev_class {
 	const char *name;
 	struct list_head	drivers;
+	struct sysdev_class_attribute **attrs;
 
 	/* Default operations for these types of devices */
 	int	(*shutdown)(struct sys_device *);
-- 
1.7.0.1

