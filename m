Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417AbXCaQvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbXCaQvQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 12:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbXCaQvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 12:51:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54012 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbXCaQvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 12:51:15 -0400
Date: Sat, 31 Mar 2007 18:51:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch] driver core: fix built-in drivers sysfs links
Message-ID: <20070331165100.GA7566@elte.hu>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070327015929.GY16477@stusta.de> <20070330120416.GA19373@elte.hu> <20070330141639.GA10387@suse.de> <20070330174619.GA12589@elte.hu> <20070330193258.GA7403@suse.de> <1175308340.4686.2.camel@lov.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175308340.4686.2.camel@lov.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Kay Sievers <kay.sievers@vrfy.org> wrote:

> > I bet if you build that code as a module, it will work just fine, 
> > can you try it?
> > 
> > Kay, did you ever get a chance to look into this reference counting 
> > issue?
> 
> Does the attached work for you?

yeah, this fixed the hangs!

please push it to Andrew and Linus, we want this in v2.6.21. See the 
full patch below, with proper headers, etc.

	Ingo

--------------------->
From: Kay Sievers <kay.sievers@vrfy.org>
Subject: [patch] driver core: fix built-in drivers sysfs links

built-in drivers had broken sysfs links that caused bootup hangs for 
certain driver unregistry sequences.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/device.h |    1 +
 kernel/module.c        |   18 ++++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

Index: linux/include/linux/device.h
===================================================================
--- linux.orig/include/linux/device.h
+++ linux/include/linux/device.h
@@ -128,6 +128,7 @@ struct device_driver {
 
 	struct module		* owner;
 	const char 		* mod_name;	/* used for built-in modules */
+	struct module_kobject	* mkobj;
 
 	int	(*probe)	(struct device * dev);
 	int	(*remove)	(struct device * dev);
Index: linux/kernel/module.c
===================================================================
--- linux.orig/kernel/module.c
+++ linux/kernel/module.c
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
