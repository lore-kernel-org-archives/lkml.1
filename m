Return-Path: <linux-kernel-owner+w=401wt.eu-S1757508AbYAaJj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbYAaJj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 04:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbYAaJjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 04:39:47 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:59422 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbYAaJjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 04:39:45 -0500
Date: Thu, 31 Jan 2008 10:39:38 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Dave Young" <hidave.darkstar@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver-core : get_device before create/remove sysfs
 files
Message-ID: <20080131103938.5c074871@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <a8e1da0801301717v1ca21bd7y6ecf16065fe34f7d@mail.gmail.com>
References: <20080130015625.GA3058@darkstar.te-china.tietoenator.com>
	<20080130113257.53555fee@gondolin.boeblingen.de.ibm.com>
	<a8e1da0801301717v1ca21bd7y6ecf16065fe34f7d@mail.gmail.com>
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

On Thu, 31 Jan 2008 09:17:18 +0800,
"Dave Young" <hidave.darkstar@gmail.com> wrote:

> On Jan 30, 2008 6:32 PM, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> > On Wed, 30 Jan 2008 09:56:25 +0800,
> > Dave Young <hidave.darkstar@gmail.com> wrote:
> >
> > > get dev reference before create/remove sysfiles, errno fixes as well.
> > >
> > > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> > >
> > > ---
> > > drivers/base/core.c |   12 ++++++++----
> > > 1 file changed, 8 insertions(+), 4 deletions(-)
> > >
> > > diff -upr a/drivers/base/core.c b/drivers/base/core.c
> > > --- a/drivers/base/core.c     2008-01-30 09:49:56.000000000 +0800
> > > +++ b/drivers/base/core.c     2008-01-30 09:49:56.000000000 +0800
> > > @@ -414,7 +414,7 @@ struct kset *devices_kset;
> > >   */
> > >  int device_create_file(struct device *dev, struct device_attribute *attr)
> > >  {
> > > -     int error = 0;
> > > +     int error = -ENODEV;
> >
> > Uhm... why?
> 
> In this function :
>         if (get_device(dev)) {
>                 do create issue
>         }
>         return error
> 
> So IMO the initial error should be -ENODEV

If everybody can agree on returning this error in case of dev == NULL,
OK. But please don't mix changing the function's semantics with the
other changes.

> 
> >
> > >       if (get_device(dev)) {
> > >               error = sysfs_create_file(&dev->kobj, &attr->attr);
> > >               put_device(dev);
> > > @@ -442,9 +442,11 @@ void device_remove_file(struct device *d
> > >   */
> > >  int device_create_bin_file(struct device *dev, struct bin_attribute *attr)
> > >  {
> > > -     int error = -EINVAL;
> > > -     if (dev)
> > > +     int error = -ENODEV;
> > > +     if (get_device(dev)) {
> > >               error = sysfs_create_bin_file(&dev->kobj, attr);
> > > +             put_device(dev);
> > > +     }
> >
> > Why do we need to grab a reference here? If the calling site doesn't
> > hold unto a reference already, something is seriously broken.
> 
> First, we should keep consistent with previous function "device_create_file";

I'd rather think that device_create_file() should be changed (see patch
below).

> Second, AFAIK this function mostly are called after something like device_add
> and the dev reference are not hold.

That code holds the reference acquired through device_initialize().

I think we should just get rid of those get/put games:


Driver core: Remove unneeded get_{device,driver}() calls.

Code trying to add/remove attributes must hold a reference to
the device resp. driver anyway, so let's remove those reference
count games.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/base/core.c   |    8 ++------
 drivers/base/driver.c |    9 +++------
 2 files changed, 5 insertions(+), 12 deletions(-)

--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -423,10 +423,8 @@ struct kset *devices_kset;
 int device_create_file(struct device *dev, struct device_attribute *attr)
 {
 	int error = 0;
-	if (get_device(dev)) {
+	if (dev)
 		error = sysfs_create_file(&dev->kobj, &attr->attr);
-		put_device(dev);
-	}
 	return error;
 }
 
@@ -437,10 +435,8 @@ int device_create_file(struct device *de
  */
 void device_remove_file(struct device *dev, struct device_attribute *attr)
 {
-	if (get_device(dev)) {
+	if (dev)
 		sysfs_remove_file(&dev->kobj, &attr->attr);
-		put_device(dev);
-	}
 }
 
 /**
--- linux-2.6.orig/drivers/base/driver.c
+++ linux-2.6/drivers/base/driver.c
@@ -97,10 +97,9 @@ int driver_create_file(struct device_dri
 		       struct driver_attribute *attr)
 {
 	int error;
-	if (get_driver(drv)) {
+	if (drv)
 		error = sysfs_create_file(&drv->p->kobj, &attr->attr);
-		put_driver(drv);
-	} else
+	else
 		error = -EINVAL;
 	return error;
 }
@@ -114,10 +113,8 @@ EXPORT_SYMBOL_GPL(driver_create_file);
 void driver_remove_file(struct device_driver *drv,
 			struct driver_attribute *attr)
 {
-	if (get_driver(drv)) {
+	if (drv)
 		sysfs_remove_file(&drv->p->kobj, &attr->attr);
-		put_driver(drv);
-	}
 }
 EXPORT_SYMBOL_GPL(driver_remove_file);
 
