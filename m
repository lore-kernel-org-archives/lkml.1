Return-Path: <linux-kernel-owner+w=401wt.eu-S932450AbYAYI1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450AbYAYI1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761735AbYAYIBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:12 -0500
Received: from ns2.suse.de ([195.135.220.15]:53703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763772AbYAYH75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:57 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Dave Young <hidave.darkstar@gmail.com>,
       Gabor Gombas <gombasg@sztaki.hu>, Tejun Heo <htejun@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>,
       David Miller <davem@davemloft.net>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 186/196] Driver core: Cleanup get_device_parent() in device_add() and device_move()
Date: Thu, 24 Jan 2008 23:33:35 -0800
Message-Id: <1201246425-5058-107-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Make setup_parent() void as get_device_parent() will always return
either a valid kobject or NULL.
Introduce cleanup_glue_dir() to drop reference grabbed on "glue"
directory by get_device_parent(). Use it for cleanup in device_move()
and device_add() on errors.

This should fix the refcounting problem reported in
http://marc.info/?l=linux-kernel&m=120052487909200&w=2

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Gabor Gombas <gombasg@sztaki.hu>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: David Miller <davem@davemloft.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index d5d542d..f09dde3 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -552,6 +552,8 @@ static struct kobject *get_device_parent(struct device *dev,
 }
 
 static inline void cleanup_device_parent(struct device *dev) {}
+static inline void cleanup_glue_dir(struct device *dev,
+				    struct kobject *glue_dir) {}
 #else
 static struct kobject *virtual_device_parent(struct device *dev)
 {
@@ -616,27 +618,27 @@ static struct kobject *get_device_parent(struct device *dev,
 	return NULL;
 }
 
-static void cleanup_device_parent(struct device *dev)
+static void cleanup_glue_dir(struct device *dev, struct kobject *glue_dir)
 {
-	struct kobject *glue_dir = dev->kobj.parent;
-
 	/* see if we live in a "glue" directory */
 	if (!dev->class || glue_dir->kset != &dev->class->class_dirs)
 		return;
 
 	kobject_put(glue_dir);
 }
+
+static void cleanup_device_parent(struct device *dev)
+{
+	cleanup_glue_dir(dev, dev->kobj.parent);
+}
 #endif
 
-static int setup_parent(struct device *dev, struct device *parent)
+static void setup_parent(struct device *dev, struct device *parent)
 {
 	struct kobject *kobj;
 	kobj = get_device_parent(dev, parent);
-	if (IS_ERR(kobj))
-		return PTR_ERR(kobj);
 	if (kobj)
 		dev->kobj.parent = kobj;
-	return 0;
 }
 
 static int device_add_class_symlinks(struct device *dev)
@@ -784,9 +786,7 @@ int device_add(struct device *dev)
 	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
 
 	parent = get_device(dev->parent);
-	error = setup_parent(dev, parent);
-	if (error)
-		goto Error;
+	setup_parent(dev, parent);
 
 	/* first, register with generic layer. */
 	error = kobject_add(&dev->kobj, dev->kobj.parent, "%s", dev->bus_id);
@@ -864,6 +864,7 @@ int device_add(struct device *dev)
 	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
 	kobject_del(&dev->kobj);
  Error:
+	cleanup_device_parent(dev);
 	if (parent)
 		put_device(parent);
 	goto Done;
@@ -1344,15 +1345,12 @@ int device_move(struct device *dev, struct device *new_parent)
 
 	new_parent = get_device(new_parent);
 	new_parent_kobj = get_device_parent (dev, new_parent);
-	if (IS_ERR(new_parent_kobj)) {
-		error = PTR_ERR(new_parent_kobj);
-		put_device(new_parent);
-		goto out;
-	}
+
 	pr_debug("device: '%s': %s: moving to '%s'\n", dev->bus_id,
 		 __FUNCTION__, new_parent ? new_parent->bus_id : "<NULL>");
 	error = kobject_move(&dev->kobj, new_parent_kobj);
 	if (error) {
+		cleanup_glue_dir(dev, new_parent_kobj);
 		put_device(new_parent);
 		goto out;
 	}
@@ -1375,6 +1373,7 @@ int device_move(struct device *dev, struct device *new_parent)
 				klist_add_tail(&dev->knode_parent,
 					       &old_parent->klist_children);
 		}
+		cleanup_glue_dir(dev, new_parent_kobj);
 		put_device(new_parent);
 		goto out;
 	}
-- 
1.5.3.8

