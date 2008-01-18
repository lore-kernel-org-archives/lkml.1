Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbYARL1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbYARL1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 06:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbYARL1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 06:27:40 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:59545 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbYARL1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 06:27:39 -0500
Date: Fri, 18 Jan 2008 12:26:25 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Dave Young" <hidave.darkstar@gmail.com>
Cc: "Gabor Gombas" <gombasg@sztaki.hu>, "Tejun Heo" <htejun@gmail.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, kay.sievers@vrfy.org,
       "Greg KH" <greg@kroah.com>, "Marcel Holtmann" <marcel@holtmann.org>,
       davem@davemloft.net
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Message-ID: <20080118122625.370e2fba@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <a8e1da0801180234k4b48fd1axaba6d7d334219430@mail.gmail.com>
References: <20080108133215.GA15814@boogie.lpds.sztaki.hu>
	<20080115015741.GB2780@darkstar.te-china.tietoenator.com>
	<20080116010205.GA2970@darkstar.te-china.tietoenator.com>
	<20080116230646.GB6715@boogie.lpds.sztaki.hu>
	<a8e1da0801162324r2cd82684iede3fc8c2f8c391c@mail.gmail.com>
	<20080117081504.GA3123@darkstar.te-china.tietoenator.com>
	<20080117124259.19a88129@gondolin.boeblingen.de.ibm.com>
	<a8e1da0801171937r92a1c32l116315a76f334776@mail.gmail.com>
	<20080118101933.258bfae9@gondolin.boeblingen.de.ibm.com>
	<20080118112337.0b457c49@gondolin.boeblingen.de.ibm.com>
	<a8e1da0801180234k4b48fd1axaba6d7d334219430@mail.gmail.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008 18:34:55 +0800,
"Dave Young" <hidave.darkstar@gmail.com> wrote:

> On Jan 18, 2008 6:23 PM, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> > On Fri, 18 Jan 2008 10:19:33 +0100,
> > Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> >
> > > >
> > > > 1314         if (IS_ERR(new_parent_kobj)) {
> > > > 1315                 error = PTR_ERR(new_parent_kobj);
> > > > 1316                 put_device(new_parent);
> > > > 1317                 goto out;
> > > > 1318         }
> > > > 1319         pr_debug("DEVICE: moving '%s' to '%s'\n", dev->bus_id,
> > > > 1320                  new_parent ? new_parent->bus_id : "<NULL>");
> > > > 1321         error = kobject_move(&dev->kobj, new_parent_kobj);
> > > > 1322         if (error) {
> > > > 1323                 put_device(new_parent);
> > > >
> > > > imagine new_parent is NULL, then the new_parent_kobj should be put
> > >
> > > No, we would need a put_device_parent() (crappy name) which puts the
> > > reference iff get_device_parent() grabbed it.
> >
> > And looking at Greg's patchset, it has cleanup_device_parent(), which
> > does just that. But it is only called in device_del(), not when
> > device_move() has errors.
> >
> > (get_device_parent() also always returns a pointer to a kobject or
> > NULL, so we can get rid of those IS_ERR() checks in setup_parent() and
> > device_move() as well.)
> >
> 
> Hmm, thanks.
> I will be offline during weekend,  but I will still check the
> device_move and other code if I have time.

Just hacked together the following against Greg's tree:

COMPLETELY UNTESTED DO NOT APPLY

---
 drivers/base/core.c |   33 ++++++++++++++++-----------------
 1 files changed, 16 insertions(+), 17 deletions(-)

--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -553,6 +553,8 @@ static struct kobject *get_device_parent
 }
 
 static inline void cleanup_device_parent(struct device *dev) {}
+static inline void cleanup_glue_dir(struct device *dev,
+				    struct kobject *kobj) {}
 #else
 static struct kobject *virtual_device_parent(struct device *dev)
 {
@@ -617,27 +619,27 @@ static struct kobject *get_device_parent
 	return NULL;
 }
 
-static void cleanup_device_parent(struct device *dev)
+static void cleanup_glue_dir(struct device *dev, struct kobject *kobj)
 {
-	struct kobject *glue_dir = dev->kobj.parent;
-
 	/* see if we live in a "glue" directory */
-	if (!dev->class || glue_dir->kset != &dev->class->class_dirs)
+	if (!dev->class || kobj->kset != &dev->class->class_dirs)
 		return;
 
-	kobject_put(glue_dir);
+	kobject_put(kobj);
+}
+
+static void cleanup_device_parent(struct device *dev)
+{
+	cleanup_glue_dir(dev, dev->kobj.parent);
 }
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
@@ -782,9 +784,7 @@ int device_add(struct device *dev)
 	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
 
 	parent = get_device(dev->parent);
-	error = setup_parent(dev, parent);
-	if (error)
-		goto Error;
+	setup_parent(dev, parent);
 
 	/* first, register with generic layer. */
 	error = kobject_add(&dev->kobj, dev->kobj.parent, "%s", dev->bus_id);
@@ -862,6 +862,7 @@ int device_add(struct device *dev)
 	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
 	kobject_del(&dev->kobj);
  Error:
+	cleanup_device_parent(dev);
 	if (parent)
 		put_device(parent);
 	goto Done;
@@ -1303,15 +1304,12 @@ int device_move(struct device *dev, stru
 
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
@@ -1334,6 +1332,7 @@ int device_move(struct device *dev, stru
 				klist_add_tail(&dev->knode_parent,
 					       &old_parent->klist_children);
 		}
+		cleanup_glue_dir(dev, new_parent_kobj);
 		put_device(new_parent);
 		goto out;
 	}
