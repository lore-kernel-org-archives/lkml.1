Return-Path: <linux-kernel-owner+w=401wt.eu-S965437AbXCOFdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965437AbXCOFdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 01:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965430AbXCOFdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:33:00 -0400
Received: from s-utl01-sjpop.stsn.net ([72.254.0.201]:59000 "HELO
	s-utl01-sjpop.stsn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965437AbXCOFc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:32:59 -0400
Date: Wed, 14 Mar 2007 22:27:24 -0700
From: Greg KH <greg@kroah.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: kref refcounting breakage in mainline
Message-ID: <20070315052724.GA12576@kroah.com>
References: <20070302005833.949be737.akpm@linux-foundation.org> <20070306002521.GA12164@kroah.com> <1173159802.6955.6.camel@Homer.simpson.net> <20070306210445.GB29164@kroah.com> <1173245937.6613.26.camel@Homer.simpson.net> <1173541446.6561.32.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173541446.6561.32.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 04:44:06PM +0100, Mike Galbraith wrote:
> On Wed, 2007-03-07 at 06:39 +0100, Mike Galbraith wrote:
> > On Tue, 2007-03-06 at 13:04 -0800, Greg KH wrote:
> > > On Tue, Mar 06, 2007 at 06:43:22AM +0100, Mike Galbraith wrote:
> > > > On Mon, 2007-03-05 at 16:25 -0800, Greg KH wrote:
> > > > 
> > > > > Mike, I've reverted this patch, and I don't see any references leaking.
> > > > > And, as your patch released the reference on the driver, and the
> > > > > module_add_driver() call would not grab a reference to the driver, only
> > > > > the module kobject, I don't see what you were trying to fix with this
> > > > > patch.
> > > > > 
> > > > > Do you have a test case that this fixes?
> > > > 
> > > > What it fixed for me was the hard hang reported below.
> > > > 
> > > > http://lkml.org/lkml/2007/2/16/96
> > > 
> > > What specific module are you trying to unload that causes the hang?  I
> > > think it might just be a problem with that module, and not with all
> > > others.
> > 
> > It's ipmi_si that's hanging, waits for completion that never comes.
> > 
> > > So, I'm going to revert your patch and work to try to find the real
> > > cause of this problem.
> > 
> > Yeah, my stab at it seems busted.  I'll take another poke at it to see
> > if I can find out why (post 725522b5453dd680412f2b6463a988e4fd148757)
> > I'm left with a reference.
> 
> Ok, stab #2.
> 
> My reference count woes stem from module_remove_driver() not removing
> the link created in module_add_driver().  With the below, my box boots
> fine.  Since I obviously know spit about driver layer glue, I'll just
> call this one a diagnostic, and head for the hills :)

Does ipmi_si not have a "owner"?  Ah, that makes sense, not all modules
do...

> --- linux-2.6.20-rc3/kernel/module.c.org	2007-03-10 15:16:47.000000000 +0100
> +++ linux-2.6.20-rc3/kernel/module.c	2007-03-10 15:43:09.000000000 +0100
> @@ -2411,14 +2411,28 @@ void module_remove_driver(struct device_
>  		return;
>  
>  	sysfs_remove_link(&drv->kobj, "module");
> -	if (drv->owner && drv->owner->mkobj.drivers_dir) {
> -		driver_name = make_driver_name(drv);
> -		if (driver_name) {
> -			sysfs_remove_link(drv->owner->mkobj.drivers_dir,
> +	driver_name = make_driver_name(drv);
> +	if (!driver_name)
> +		return;
> +	if (drv->owner && drv->owner->mkobj.drivers_dir)
> +		sysfs_remove_link(drv->owner->mkobj.drivers_dir,
>  					  driver_name);
> -			kfree(driver_name);
> -		}
> +	else if (drv->mod_name) {
> +		struct module_kobject *mk;
> +		struct kobject *mkobj;
> +
> +		/* Lookup built-in module entry in /sys/modules */
> +		mkobj = kset_find_obj(&module_subsys.kset, drv->mod_name);
> +		if (!mkobj)
> +			goto out_free;
> +		mk = container_of(mkobj, struct module_kobject, kobj);
> +		module_create_drivers_dir(mk);
> +		sysfs_remove_link(mk->drivers_dir, driver_name);
> +		/* Release reference taken via lookup */
> +		kobject_put(mkobj);
>  	}
> +out_free:
> +	kfree(driver_name);
>  }
>  EXPORT_SYMBOL(module_remove_driver);
>  #endif

That's pretty good for not knowing much about the subject matter here.
But can you try this version instead?  It should work a bit better than
yours.

thanks for your patience,

greg k-h

Subject: modules: fix reference counting logic for drivers without module pointers.

We weren't dropping the sysfs link for the module driver name if we
didn't happen to have the "owner" pointer in the driver.

Based on a patch from Mike Galbraith <efault@gmx.de>

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/module.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2405,20 +2405,30 @@ EXPORT_SYMBOL(module_add_driver);
 
 void module_remove_driver(struct device_driver *drv)
 {
+	struct module_kobject *mk = NULL;
+	struct kobject *mkobj = NULL;
 	char *driver_name;
 
 	if (!drv)
 		return;
 
 	sysfs_remove_link(&drv->kobj, "module");
-	if (drv->owner && drv->owner->mkobj.drivers_dir) {
-		driver_name = make_driver_name(drv);
-		if (driver_name) {
-			sysfs_remove_link(drv->owner->mkobj.drivers_dir,
-					  driver_name);
-			kfree(driver_name);
-		}
+	driver_name = make_driver_name(drv);
+	if (!driver_name)
+		return;
+
+	if (drv->owner && drv->owner->mkobj.drivers_dir)
+		mk = &drv->owner->mkobj;
+	else {
+		/* Lookup built-in module entry in /sys/modules */
+		mkobj = kset_find_obj(&module_subsys.kset, drv->mod_name);
+		if (!mkobj)
+			return;
+		mk = container_of(mkobj, struct module_kobject, kobj);
 	}
+	sysfs_remove_link(mk->drivers_dir, driver_name);
+	kobject_put(mkobj);
+	kfree(driver_name);
 }
 EXPORT_SYMBOL(module_remove_driver);
 #endif

