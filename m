Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbYDRHz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbYDRHz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 03:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbYDRHzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 03:55:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56615 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbYDRHzR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 03:55:17 -0400
Subject: Re: [PATCH mm] sysfs: add /sys/dev/usb to handle
	CONFIG_USB_DEVICE_CLASS=y
From: Kay Sievers <kay.sievers@vrfy.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
In-Reply-To: <e9c3a7c20804172159x16554078i6d5c9097eeadc91c@mail.gmail.com>
References: <1208484663.12570.5.camel@dwillia2-linux.ch.intel.com>
	 <20080418032146.GA8754@kroah.com>
	 <e9c3a7c20804172159x16554078i6d5c9097eeadc91c@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 18 Apr 2008 09:54:51 +0200
Message-Id: <1208505291.2514.9.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX19YAC51HWd2WJUgGfOmwqpPj85hWxQoPV7p7W6
 NF3bovHtVfQpi8YuKRQ6DHFh9GK1PeeR4GsIy7Vd4j2wKT0TN9
 ZeA1y4SjMmq0Vg37kO+WrzD1rklXX1v
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-17 at 21:59 -0700, Dan Williams wrote:
> On Thu, Apr 17, 2008 at 8:21 PM, Greg KH <greg@kroah.com> wrote:
> > On Thu, Apr 17, 2008 at 07:11:03PM -0700, Dan Williams wrote:
> >
> > > The deprecated config option CONFIG_USB_DEVICE_CLASS causes class devices
> >  > with duplicate major:minor numbers to be registered.  In effect they
> >  > represent a usb specific address space for major:minor numbers so add 'usb'
> >  > as a directory along side 'block' and 'char'.
> >
> >  Hm, no they do not, they are not a new address space, we are just
> >  reusing them as the other user wasn't using them, and the code is
> >  deprecated and will be removed eventually.  Neither of these char
> >  devices are really hooked up to anything within the kernel, so it
> >  doesn't matter yet.
> >
> >  I wonder how many other duplicates we have floating around...
> >
> 
> Hm, so how about making this an opt-in capability of the class?  At
> device_add() time the class is queried to see if a link should be
> created in /sys/dev/block or /sys/dev/char?

This could work, yes. We could just set a flag in the class, that
prevents the device entries in /sys/dev/.

> Although, this leads to
> inconsistent coverage.  But maybe that does not matter as many of
> these character devices do not have interesting attributes to be
> accessed?

The usual case is that one of the duplicated /sys devices is deprecated,
so it should be fine, to always point to the new one.

> Sigh, I am beginning to wonder if the character device side
> of this capability is a solution looking for a problem...

We will find a solution. :)

The following should work for the common case.

Best,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: sysfs: fix duplicated device number registration in /sys/dev/

If the parent device has the same dev_t, we skip the registration
for the device number at /sys/dev.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg KH <greg@kroah.com>
﻿Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---

 core.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index de925f8..afedadb 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -821,10 +821,13 @@ int device_add(struct device *dev)
 		if (error)
 			goto ueventattrError;
 
-		format_dev_t(devt_str, dev->devt);
-		error = sysfs_create_link(kobj, &dev->kobj, devt_str);
-		if (error)
-			goto devtattrError;
+		/* do not create /sys/dev/ entry if parent already did */
+		if (!(dev->parent && dev->parent->devt == dev->devt)) {
+			format_dev_t(devt_str, dev->devt);
+			error = sysfs_create_link(kobj, &dev->kobj, devt_str);
+			if (error)
+				goto devtattrError;
+		}
 	}
 
 	error = device_add_class_symlinks(dev);
@@ -950,8 +953,10 @@ void device_del(struct device *dev)
 	if (parent)
 		klist_del(&dev->knode_parent);
 	if (MAJOR(dev->devt)) {
-		format_dev_t(devt_str, dev->devt);
-		sysfs_remove_link(device_to_dev_kobj(dev), devt_str);
+		if (!(parent && parent->devt == dev->devt)) {
+			format_dev_t(devt_str, dev->devt);
+			sysfs_remove_link(device_to_dev_kobj(dev), devt_str);
+		}
 		device_remove_file(dev, &devt_attr);
 	}
 	if (dev->class) {


