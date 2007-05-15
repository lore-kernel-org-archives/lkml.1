Return-Path: <linux-kernel-owner+w=401wt.eu-S933766AbXEOJPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766AbXEOJPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 05:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759181AbXEOJPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 05:15:09 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:42831 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758668AbXEOJPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 05:15:07 -0400
Date: Tue, 15 May 2007 11:15:04 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de, akpm@osdl.org
Subject: Re: __must_check (stir the pot :-))
Message-ID: <20070515111504.64beb6c0@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070515085016.GB3838@localhost.localdomain>
References: <20070515173146.505952d1.sfr@canb.auug.org.au>
	<20070515085016.GB3838@localhost.localdomain>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 16:50:16 +0800,
WANG Cong <xiyou.wangcong@gmail.com> wrote:

> On Tue, May 15, 2007 at 05:31:46PM +1000, Stephen Rothwell wrote:
> >So I am looking at "fixing" some of the warning produced by __must_check
> >but then I see (things like):
> >
> >drivers/base/core.c: In function 'device_add':
> >drivers/base/core.c:714: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
> >drivers/base/core.c:719: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
> >drivers/base/core.c:722: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
> >drivers/base/core.c:728: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
> >drivers/base/core.c: In function 'device_rename':
> >drivers/base/core.c:1187: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
> >drivers/base/core.c:1197: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result

I did a patch to fix this sometime last year, but it was dropped again
since it broke some driver (and unfortunately I was offline at that
time, so I couldn't try to fix it); I'll put in a respun patch at the
end of this mail (and hopefully we can sort out the fallout this
time...) (There was at least one other attempt to fix it, IIRC, but
this seems to have gone by largely unnoticed.)

> >
> >and things like this in drivers/base/sys.c:
> >
> >int sysdev_create_file(struct sys_device * s, struct sysdev_attribute * a)
> >{
> >        return sysfs_create_file(&s->kobj, &a->attr);
> >}
> >
> >where sysfs_create_file() is marked __must_check and sysdev_create_file()
> >isn't.

A __must_check on sysfs_create_file() should imply a __must_check on
sysdev_create_file() as well, I guess. OTOH, drivers may not really
care if the file was created, especially since sysfs_remove_file() is
save for not-created attributes.

> >
> >So the questions come to mind:  Do we really care if our core
> >infrastructure doesn't?  Can we care if the core infrastructure doesn't
> >propogate the error returns?

Well, people have tried to fix these warnings :)

Some __must_check annotations may be misplaced, though, and some error
codes may be suppressed that shouldn't. Can you point to examples?

> >
> >Flame away, I am prepared to ignore all opinions :-)
> 
> 
> Hi!
> 
> I had noticed these warnings yet and had tried to fix them. But these ones are not relatively easy to fix, since they are nested in some complex contexts.
> 
> Can we leave this job to Greg? (Add some CCs below.)

Greg usually accepts patches, but sometimes you need to be persistent :)

Patch to fix the symlink warnings below. If anything breaks, please
holler, so we can hopefully sort it out this time.

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Check for return value of sysfs_create_link() in device_add() and
device_rename(). Add helper functions device_add_class_symlinks() and
device_remove_class_symlinks() to make the code easier to read.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/base/core.c |  140 ++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 99 insertions(+), 41 deletions(-)

--- linux.orig/drivers/base/core.c
+++ linux/drivers/base/core.c
@@ -635,6 +635,77 @@ static int setup_parent(struct device *d
 	return 0;
 }
 
+static int device_add_class_symlinks(struct device *dev)
+{
+	int error;
+	char *class_name;
+
+	if (!dev->class)
+		return 0;
+	error = sysfs_create_link(&dev->kobj, &dev->class->subsys.kobj,
+				  "subsystem");
+	if (error)
+		goto out;
+	/*
+	 * If this is not a "fake" compatible device, then create the
+	 * symlink from the class to the device.
+	 */
+	if (dev->kobj.parent == &dev->class->subsys.kobj)
+		return 0;
+	error = sysfs_create_link(&dev->class->subsys.kobj, &dev->kobj,
+				  dev->bus_id);
+	if (error)
+		goto out_subsys;
+	if (dev->parent) {
+		error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
+					  "device");
+		if (error)
+			goto out_busid;
+#ifdef CONFIG_SYSFS_DEPRECATED
+		class_name = make_class_name(dev->class->name, &dev->kobj);
+		if (class_name)
+			error = sysfs_create_link(&dev->parent->kobj,
+						  &dev->kobj, class_name);
+		kfree(class_name);
+		if (error)
+			goto out_device;
+#endif
+	}
+	return 0;
+
+#ifdef CONFIG_SYSFS_DEPRECATED
+out_device:
+	if (dev->parent)
+		sysfs_remove_link(&dev->kobj, "device");
+#endif
+out_busid:
+	sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
+out_subsys:
+	sysfs_remove_link(&dev->kobj, "subsystem");
+out:
+	return error;
+}
+
+static void device_remove_class_symlinks(struct device *dev)
+{
+	char *class_name;
+
+	if (!dev->class)
+		return;
+	if (dev->parent) {
+#ifdef CONFIG_SYSFS_DEPRECATED
+		class_name = make_class_name(dev->class->name, &dev->kobj);
+		if (class_name) {
+			sysfs_remove_link(&dev->parent->kobj, class_name);
+			kfree(class_name);
+		}
+#endif
+		sysfs_remove_link(&dev->kobj, "device");
+	}
+	sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
+	sysfs_remove_link(&dev->kobj, "subsystem");
+}
+
 /**
  *	device_add - add device to device hierarchy.
  *	@dev:	device.
@@ -649,7 +720,6 @@ static int setup_parent(struct device *d
 int device_add(struct device *dev)
 {
 	struct device *parent = NULL;
-	char *class_name = NULL;
 	struct class_interface *class_intf;
 	int error = -EINVAL;
 
@@ -709,28 +779,8 @@ int device_add(struct device *dev)
 
 		dev->devt_attr = attr;
 	}
-
-	if (dev->class) {
-		sysfs_create_link(&dev->kobj, &dev->class->subsys.kobj,
-				  "subsystem");
-		/* If this is not a "fake" compatible device, then create the
-		 * symlink from the class to the device. */
-		if (dev->kobj.parent != &dev->class->subsys.kobj)
-			sysfs_create_link(&dev->class->subsys.kobj,
-					  &dev->kobj, dev->bus_id);
-		if (parent) {
-			sysfs_create_link(&dev->kobj, &dev->parent->kobj,
-							"device");
-#ifdef CONFIG_SYSFS_DEPRECATED
-			class_name = make_class_name(dev->class->name,
-							&dev->kobj);
-			if (class_name)
-				sysfs_create_link(&dev->parent->kobj,
-						  &dev->kobj, class_name);
-#endif
-		}
-	}
-
+	if ((error = device_add_class_symlinks(dev)))
+		goto SymlinkError;
 	if ((error = device_add_attrs(dev)))
 		goto AttrsError;
 	if ((error = device_pm_add(dev)))
@@ -754,7 +804,6 @@ int device_add(struct device *dev)
 		up(&dev->class->sem);
 	}
  Done:
-	kfree(class_name);
 	put_device(dev);
 	return error;
  BusError:
@@ -765,6 +814,8 @@ int device_add(struct device *dev)
 					     BUS_NOTIFY_DEL_DEVICE, dev);
 	device_remove_attrs(dev);
  AttrsError:
+	device_remove_class_symlinks(dev);
+ SymlinkError:
 	if (dev->devt_attr) {
 		device_remove_file(dev, dev->devt_attr);
 		kfree(dev->devt_attr);
@@ -1153,7 +1204,7 @@ int device_rename(struct device *dev, ch
 {
 	char *old_class_name = NULL;
 	char *new_class_name = NULL;
-	char *old_symlink_name = NULL;
+	char *old_device_name = NULL;
 	int error;
 
 	dev = get_device(dev);
@@ -1167,42 +1218,49 @@ int device_rename(struct device *dev, ch
 		old_class_name = make_class_name(dev->class->name, &dev->kobj);
 #endif
 
-	if (dev->class) {
-		old_symlink_name = kmalloc(BUS_ID_SIZE, GFP_KERNEL);
-		if (!old_symlink_name) {
-			error = -ENOMEM;
-			goto out_free_old_class;
-		}
-		strlcpy(old_symlink_name, dev->bus_id, BUS_ID_SIZE);
+	old_device_name = kmalloc(BUS_ID_SIZE, GFP_KERNEL);
+	if (!old_device_name) {
+		error = -ENOMEM;
+		goto out;
 	}
-
+	strlcpy(old_device_name, dev->bus_id, BUS_ID_SIZE);
 	strlcpy(dev->bus_id, new_name, BUS_ID_SIZE);
 
 	error = kobject_rename(&dev->kobj, new_name);
+	if (error) {
+		strlcpy(dev->bus_id, old_device_name, BUS_ID_SIZE);
+		goto out;
+	}
 
 #ifdef CONFIG_SYSFS_DEPRECATED
 	if (old_class_name) {
 		new_class_name = make_class_name(dev->class->name, &dev->kobj);
 		if (new_class_name) {
-			sysfs_create_link(&dev->parent->kobj, &dev->kobj,
-					  new_class_name);
+			error = sysfs_create_link(&dev->parent->kobj,
+						  &dev->kobj, new_class_name);
+			if (error)
+				goto out;
 			sysfs_remove_link(&dev->parent->kobj, old_class_name);
 		}
 	}
 #endif
 
 	if (dev->class) {
-		sysfs_remove_link(&dev->class->subsys.kobj,
-				  old_symlink_name);
-		sysfs_create_link(&dev->class->subsys.kobj, &dev->kobj,
-				  dev->bus_id);
+		sysfs_remove_link(&dev->class->subsys.kobj, old_device_name);
+		error = sysfs_create_link(&dev->class->subsys.kobj, &dev->kobj,
+					  dev->bus_id);
+		if (error) {
+			/* Uh... how to unravel this if restoring can fail? */
+			dev_err(dev, "%s: sysfs_create_symlink failed (%d)\n",
+				__FUNCTION__, error);
+		}
 	}
+out:
 	put_device(dev);
 
 	kfree(new_class_name);
-	kfree(old_symlink_name);
- out_free_old_class:
 	kfree(old_class_name);
+	kfree(old_device_name);
 
 	return error;
 }
