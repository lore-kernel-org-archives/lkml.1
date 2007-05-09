Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbXEINbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbXEINbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 09:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbXEINa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 09:30:59 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:63630 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbXEINa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 09:30:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=FQCqG8+rBuYuFRkZGQmQ0EjomSVIdeMmJC69SBR+4ovpX/JJYqkCMxgiYgsJ9izW6BjV3JyQMbj7Zw+zrEGLlaK+yg80xzFW8OUQSEadmCqFBcHF3Aq0QhbUtEZIhpu2VIHiJsDfbWnKEHIHe6WaMRHKgp0GMBRBluLrJ/PzQxI=
Message-ID: <4641CD01.6010309@gmail.com>
Date: Wed, 09 May 2007 15:30:41 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>
Subject: Re: [linux-usb-devel] Bug creating USB endpoints in 2.6.20.x (kernel
 bug 8198)
References: <602729.80444.qm@web52910.mail.re2.yahoo.com>
In-Reply-To: <602729.80444.qm@web52910.mail.re2.yahoo.com>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------050706030009030901060608"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050706030009030901060608
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Chris Rankin wrote:
> --- Tejun Heo <htejun@gmail.com> wrote:
>> So, we can fix the problem Chris is seeing by breaking module unload (by
>> allowing it to unload too early).  It doesn't sound too hot but module
>> unloading race is much less likely than sysfs node deletion/open race.
> 
> Yikes! Just temporary breakage, I hope :-)!! The only modules I unload on a regular basis these
> days are things like "microcode", which the init scripts take care of as part of the boot-up
> process.

Okay, here's a half-assed fix.  With this patch applied, if you try to
unload a module while you're opening it's dev attribute, kernel will
oops later when the file is accessed or closed later but it should fix
the bug winecfg triggers.  I really dunno how to fix this the right way
in the stable kernel.  Better ideas?  Anyone?

-- 
tejun

--------------050706030009030901060608
Content-Type: text/x-patch;
 name="sysfs-race-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sysfs-race-fix.patch"

---
 drivers/base/core.c    |   33 ++++++++-------------------------
 include/linux/device.h |    1 -
 2 files changed, 8 insertions(+), 26 deletions(-)

Index: tree0/drivers/base/core.c
===================================================================
--- tree0.orig/drivers/base/core.c
+++ tree0/drivers/base/core.c
@@ -287,6 +287,8 @@ static ssize_t show_dev(struct device *d
 	return print_dev_t(buf, dev->devt);
 }
 
+static struct device_attribute devt_attr = __ATTR(dev, S_IRUGO, show_dev, NULL );
+
 /*
  *	devices_subsys - structure to be registered with kobject core.
  */
@@ -490,24 +492,9 @@ int device_add(struct device *dev)
 		goto attrError;
 
 	if (MAJOR(dev->devt)) {
-		struct device_attribute *attr;
-		attr = kzalloc(sizeof(*attr), GFP_KERNEL);
-		if (!attr) {
-			error = -ENOMEM;
-			goto ueventattrError;
-		}
-		attr->attr.name = "dev";
-		attr->attr.mode = S_IRUGO;
-		if (dev->driver)
-			attr->attr.owner = dev->driver->owner;
-		attr->show = show_dev;
-		error = device_create_file(dev, attr);
-		if (error) {
-			kfree(attr);
+		error = device_create_file(dev, &devt_attr);
+		if (error)
 			goto ueventattrError;
-		}
-
-		dev->devt_attr = attr;
 	}
 
 	if (dev->class) {
@@ -568,10 +555,8 @@ int device_add(struct device *dev)
  GroupError:
  	device_remove_attrs(dev);
  AttrsError:
-	if (dev->devt_attr) {
-		device_remove_file(dev, dev->devt_attr);
-		kfree(dev->devt_attr);
-	}
+	if (MAJOR(dev->devt))
+		device_remove_file(dev, &devt_attr);
  ueventattrError:
 	device_remove_file(dev, &dev->uevent_attr);
  attrError:
@@ -650,10 +635,8 @@ void device_del(struct device * dev)
 
 	if (parent)
 		klist_del(&dev->knode_parent);
-	if (dev->devt_attr) {
-		device_remove_file(dev, dev->devt_attr);
-		kfree(dev->devt_attr);
-	}
+	if (MAJOR(dev->devt))
+		device_remove_file(dev, &devt_attr);
 	if (dev->class) {
 		sysfs_remove_link(&dev->kobj, "subsystem");
 		/* If this is not a "fake" compatible device, remove the
Index: tree0/include/linux/device.h
===================================================================
--- tree0.orig/include/linux/device.h
+++ tree0/include/linux/device.h
@@ -357,7 +357,6 @@ struct device {
 	char	bus_id[BUS_ID_SIZE];	/* position on parent bus */
 	unsigned		is_registered:1;
 	struct device_attribute uevent_attr;
-	struct device_attribute *devt_attr;
 
 	struct semaphore	sem;	/* semaphore to synchronize calls to
 					 * its driver.

--------------050706030009030901060608--
