Return-Path: <linux-kernel-owner+w=401wt.eu-S1759858AbYAUPJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858AbYAUPJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 10:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYAUPJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 10:09:50 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:9207 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbYAUPJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 10:09:49 -0500
Date: Mon, 21 Jan 2008 16:09:44 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Greg KH" <greg@kroah.com>
Cc: "Dave Young" <hidave.darkstar@gmail.com>,
       "Gabor Gombas" <gombasg@sztaki.hu>, "Tejun Heo" <htejun@gmail.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, kay.sievers@vrfy.org,
       "Marcel Holtmann" <marcel@holtmann.org>, davem@davemloft.net
Subject: [Patch] Driver core: Cleanup get_device_parent() in device_add()
 and device_move().
Message-ID: <20080121160944.1170bc12@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <a8e1da0801201915m5608ec7bnda31bd1db898f7e4@mail.gmail.com>
References: <20080108133215.GA15814@boogie.lpds.sztaki.hu>
	<20080116230646.GB6715@boogie.lpds.sztaki.hu>
	<a8e1da0801162324r2cd82684iede3fc8c2f8c391c@mail.gmail.com>
	<20080117081504.GA3123@darkstar.te-china.tietoenator.com>
	<20080117124259.19a88129@gondolin.boeblingen.de.ibm.com>
	<a8e1da0801171937r92a1c32l116315a76f334776@mail.gmail.com>
	<20080118101933.258bfae9@gondolin.boeblingen.de.ibm.com>
	<20080118112337.0b457c49@gondolin.boeblingen.de.ibm.com>
	<a8e1da0801180234k4b48fd1axaba6d7d334219430@mail.gmail.com>
	<20080118122625.370e2fba@gondolin.boeblingen.de.ibm.com>
	<a8e1da0801201915m5608ec7bnda31bd1db898f7e4@mail.gmail.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make setup_parent() void as get_device_parent() will always return
either a valid kobject or NULL.
Introduce cleanup_glue_dir() to drop reference grabbed on "glue"
directory by get_device_parent(). Use it for cleanup in device_move()
and device_add() on errors.

This should fix the refcounting problem reported in
http://marc.info/?l=linux-kernel&m=120052487909200&w=2

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/base/core.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -553,6 +553,8 @@ static struct kobject *get_device_parent
 }
 
 static inline void cleanup_device_parent(struct device *dev) {}
+static inline void cleanup_glue_dir(struct device *dev,
+				    struct kobject *glue_dir) {}
 #else
 static struct kobject *virtual_device_parent(struct device *dev)
 {
@@ -617,27 +619,27 @@ static struct kobject *get_device_parent
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
@@ -785,9 +787,7 @@ int device_add(struct device *dev)
 	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
 
 	parent = get_device(dev->parent);
-	error = setup_parent(dev, parent);
-	if (error)
-		goto Error;
+	setup_parent(dev, parent);
 
 	/* first, register with generic layer. */
 	error = kobject_add(&dev->kobj, dev->kobj.parent, "%s", dev->bus_id);
@@ -865,6 +865,7 @@ int device_add(struct device *dev)
 	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
 	kobject_del(&dev->kobj);
  Error:
+	cleanup_device_parent(dev);
 	if (parent)
 		put_device(parent);
 	goto Done;
@@ -1345,15 +1346,12 @@ int device_move(struct device *dev, stru
 
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
@@ -1376,6 +1374,7 @@ int device_move(struct device *dev, stru
 				klist_add_tail(&dev->knode_parent,
 					       &old_parent->klist_children);
 		}
+		cleanup_glue_dir(dev, new_parent_kobj);
 		put_device(new_parent);
 		goto out;
 	}
