Return-Path: <linux-kernel-owner+w=401wt.eu-S933470AbXCJPoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470AbXCJPoS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 10:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933472AbXCJPoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 10:44:18 -0500
Received: from mail.gmx.net ([213.165.64.20]:59128 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933470AbXCJPoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 10:44:17 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+31htJut23nrRKJNPrimYsMWv4PfcK96EaPcWY9G
	pElXNdKy1bIXLP
Subject: Re: kref refcounting breakage in mainline
From: Mike Galbraith <efault@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>
In-Reply-To: <1173245937.6613.26.camel@Homer.simpson.net>
References: <20070302005833.949be737.akpm@linux-foundation.org>
	 <20070306002521.GA12164@kroah.com>
	 <1173159802.6955.6.camel@Homer.simpson.net>
	 <20070306210445.GB29164@kroah.com>
	 <1173245937.6613.26.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Sat, 10 Mar 2007 16:44:06 +0100
Message-Id: <1173541446.6561.32.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 06:39 +0100, Mike Galbraith wrote:
> On Tue, 2007-03-06 at 13:04 -0800, Greg KH wrote:
> > On Tue, Mar 06, 2007 at 06:43:22AM +0100, Mike Galbraith wrote:
> > > On Mon, 2007-03-05 at 16:25 -0800, Greg KH wrote:
> > > 
> > > > Mike, I've reverted this patch, and I don't see any references leaking.
> > > > And, as your patch released the reference on the driver, and the
> > > > module_add_driver() call would not grab a reference to the driver, only
> > > > the module kobject, I don't see what you were trying to fix with this
> > > > patch.
> > > > 
> > > > Do you have a test case that this fixes?
> > > 
> > > What it fixed for me was the hard hang reported below.
> > > 
> > > http://lkml.org/lkml/2007/2/16/96
> > 
> > What specific module are you trying to unload that causes the hang?  I
> > think it might just be a problem with that module, and not with all
> > others.
> 
> It's ipmi_si that's hanging, waits for completion that never comes.
> 
> > So, I'm going to revert your patch and work to try to find the real
> > cause of this problem.
> 
> Yeah, my stab at it seems busted.  I'll take another poke at it to see
> if I can find out why (post 725522b5453dd680412f2b6463a988e4fd148757)
> I'm left with a reference.

Ok, stab #2.

My reference count woes stem from module_remove_driver() not removing
the link created in module_add_driver().  With the below, my box boots
fine.  Since I obviously know spit about driver layer glue, I'll just
call this one a diagnostic, and head for the hills :)

--- linux-2.6.20-rc3/kernel/module.c.org	2007-03-10 15:16:47.000000000 +0100
+++ linux-2.6.20-rc3/kernel/module.c	2007-03-10 15:43:09.000000000 +0100
@@ -2411,14 +2411,28 @@ void module_remove_driver(struct device_
 		return;
 
 	sysfs_remove_link(&drv->kobj, "module");
-	if (drv->owner && drv->owner->mkobj.drivers_dir) {
-		driver_name = make_driver_name(drv);
-		if (driver_name) {
-			sysfs_remove_link(drv->owner->mkobj.drivers_dir,
+	driver_name = make_driver_name(drv);
+	if (!driver_name)
+		return;
+	if (drv->owner && drv->owner->mkobj.drivers_dir)
+		sysfs_remove_link(drv->owner->mkobj.drivers_dir,
 					  driver_name);
-			kfree(driver_name);
-		}
+	else if (drv->mod_name) {
+		struct module_kobject *mk;
+		struct kobject *mkobj;
+
+		/* Lookup built-in module entry in /sys/modules */
+		mkobj = kset_find_obj(&module_subsys.kset, drv->mod_name);
+		if (!mkobj)
+			goto out_free;
+		mk = container_of(mkobj, struct module_kobject, kobj);
+		module_create_drivers_dir(mk);
+		sysfs_remove_link(mk->drivers_dir, driver_name);
+		/* Release reference taken via lookup */
+		kobject_put(mkobj);
 	}
+out_free:
+	kfree(driver_name);
 }
 EXPORT_SYMBOL(module_remove_driver);
 #endif


