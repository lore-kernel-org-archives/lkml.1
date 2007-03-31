Return-Path: <linux-kernel-owner+w=401wt.eu-S933379AbXCaCcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379AbXCaCcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 22:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933404AbXCaCcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 22:32:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:57041 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933379AbXCaCcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 22:32:17 -0400
Subject: Re: [bug] hung bootup in various drivers, was: "2.6.21-rc5: known
	regressions"
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070330193258.GA7403@suse.de>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
	 <20070327015929.GY16477@stusta.de> <20070330120416.GA19373@elte.hu>
	 <20070330141639.GA10387@suse.de> <20070330174619.GA12589@elte.hu>
	 <20070330193258.GA7403@suse.de>
Content-Type: multipart/mixed; boundary="=-VE/yIw50IOX18HXasReR"
Date: Sat, 31 Mar 2007 04:32:20 +0200
Message-Id: <1175308340.4686.2.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
X-Provags-ID: V01U2FsdGVkX185nKyg9kVCr0ISSZL64YFnR32h/m8cGzKCVWJ
 yfYQdfFipmr9RxEJK1llfVM0Uv9FDghMaHhSdE4E8Z/sfQGfbi
 wtJJdKt8KVIz5Ga35+gaAna2j8e1/yM
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VE/yIw50IOX18HXasReR
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2007-03-30 at 12:32 -0700, Greg KH wrote:
> On Fri, Mar 30, 2007 at 07:46:19PM +0200, Ingo Molnar wrote:
> > 
> > * Greg KH <gregkh@suse.de> wrote:
> > 
> > > >  BUG: at drivers/base/driver.c:187 driver_unregister()
> > > >   [<c0105ff9>] show_trace_log_lvl+0x19/0x2e
> > > >   [<c01063e2>] show_trace+0x12/0x14
> > > >   [<c01063f8>] dump_stack+0x14/0x16
> > > >   [<c063f7e6>] driver_unregister+0x3d/0x43
> > > >   [<c0488048>] pci_unregister_driver+0x10/0x5f
> > > >   [<c1b5f7c7>] slgt_init+0x9b/0x1ca
> > > >   [<c1b31a2d>] init+0x15d/0x2bd
> > > >   [<c0105bc3>] kernel_thread_helper+0x7/0x10
> > 
> > > Yes, we should allow the ability to call unregister_driver from within 
> > > the module_init function.
> > > 
> > > But I don't understand what is causing you to see this problem.  Who 
> > > is holding the reference on the struct device at this point in time?  
> > > Is it the fact that userspace has some files open and it hasn't 
> > > released them yet?
> > 
> > at least in the slgt_init() case the affected codepath is trivial:
> > 
> >         if ((rc = pci_register_driver(&pci_driver)) < 0) {
> >                 printk("%s pci_register_driver error=%d\n", driver_name, rc);
> >                 return rc;
> >         }
> >         pci_registered = 1;
> > 
> >         if (!slgt_device_list) {
> >                 printk("%s no devices found\n",driver_name);
> >                 pci_unregister_driver(&pci_driver);
> >                 return -ENODEV;
> > 
> > slgt_device_list is NULL because no matching PCI ID is on my system (i 
> > dont have this hardware), so the ->probe() function did not get called 
> > at all.
> 
> Sorry, no, I realize how this could happen in the driver, I just don't
> see what in the driver core would be keeping this driver from having
> it's release function called at the unregister() time.
> 
> Something has grabbed a reference to the driver...
> 
> Oh wait, is this code a module or built into the kernel?
> 
> If it's built in, there's still a reference counting bug in the
> module/driver hookup logic as we really don't have a "module" yet we are
> still thinking we do as we represent it in /sys/module and create the
> linkages.
> 
> I created some horrible patches to try to track this down, as it was
> reported on lkml (look for "Subject: kref refcounting breakage in mainline" )
> but never got it working correctly.
> 
> I bet if you build that code as a module, it will work just fine, can
> you try it?
> 
> Kay, did you ever get a chance to look into this reference counting
> issue?

Does the attached work for you?

Thanks,
Kay

--=-VE/yIw50IOX18HXasReR
Content-Disposition: inline; filename=built-in-driver-links-fix.patch
Content-Type: text/x-patch; name=built-in-driver-links-fix.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/include/linux/device.h b/include/linux/device.h
index caad9bb..5cf30e9 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -128,6 +128,7 @@ struct device_driver {
 
 	struct module		* owner;
 	const char 		* mod_name;	/* used for built-in modules */
+	struct module_kobject	* mkobj;
 
 	int	(*probe)	(struct device * dev);
 	int	(*remove)	(struct device * dev);
diff --git a/kernel/module.c b/kernel/module.c
index fbc51de..dcdb32b 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2384,8 +2384,13 @@ void module_add_driver(struct module *mo
 
 		/* Lookup built-in module entry in /sys/modules */
 		mkobj = kset_find_obj(&module_subsys.kset, drv->mod_name);
-		if (mkobj)
+		if (mkobj) {
 			mk = container_of(mkobj, struct module_kobject, kobj);
+			/* remember our module structure */
+			drv->mkobj = mk;
+			/* kset_find_obj took a reference */
+			kobject_put(mkobj);
+		}
 	}
 
 	if (!mk)
@@ -2405,17 +2410,22 @@ EXPORT_SYMBOL(module_add_driver);
 
 void module_remove_driver(struct device_driver *drv)
 {
+	struct module_kobject *mk = NULL;
 	char *driver_name;
 
 	if (!drv)
 		return;
 
 	sysfs_remove_link(&drv->kobj, "module");
-	if (drv->owner && drv->owner->mkobj.drivers_dir) {
+
+	if (drv->owner)
+		mk = &drv->owner->mkobj;
+	else if (drv->mkobj)
+		mk = drv->mkobj;
+	if (mk && mk->drivers_dir) {
 		driver_name = make_driver_name(drv);
 		if (driver_name) {
-			sysfs_remove_link(drv->owner->mkobj.drivers_dir,
-					  driver_name);
+			sysfs_remove_link(mk->drivers_dir, driver_name);
 			kfree(driver_name);
 		}
 	}

--=-VE/yIw50IOX18HXasReR--

