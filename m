Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbZJMDS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbZJMDS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 23:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbZJMDS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 23:18:28 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:59954 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZJMDS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 23:18:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hEEXCP7dDHZklFZIV/G21GCCva6lUv9GVgFgS+elXmMrRg5rssK7hh+3U3bYKQzh9T
         ifMNwxg5kaJZvrgeesj9L6fzAlqHDGmmD8RpOFbiBVaA+TvBC+0mvFyGjVVRTtD2P7ry
         kiYpocDkPQDi2OBtyGN3e3Kn3VokED1NLsL00=
Date: Mon, 12 Oct 2009 20:17:41 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not work
	anymore
Message-ID: <20091013031741.GB2887@core.coreip.homeip.net>
References: <4AD120F2.3020606@tremplin-utc.net> <20091011030029.GA6526@suse.de> <200910112135.29384.dmitry.torokhov@gmail.com> <4AD31709.4000103@tremplin-utc.net> <20091012154846.GB7996@core.coreip.homeip.net> <20091012173551.GC10557@suse.de> <20091012183313.GC8345@core.coreip.homeip.net> <20091012185417.GA30342@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012185417.GA30342@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 11:54:17AM -0700, Greg KH wrote:
> On Mon, Oct 12, 2009 at 11:33:13AM -0700, Dmitry Torokhov wrote:
> > On Mon, Oct 12, 2009 at 10:35:51AM -0700, Greg KH wrote:
> > > On Mon, Oct 12, 2009 at 08:48:46AM -0700, Dmitry Torokhov wrote:
> > > > > So at least, unbind should fail as well as bind.
> > > > >
> > > > 
> > > > That would be Greg's domain s it is driver core decision whether to
> > > > allow unbinding platform devices registered with
> > > > platform_driver_probe().
> > > 
> > > No, I do not see why that should not be allowed.
> > > 
> > 
> > Because once you did unbind the device you are stuck (unless the driver
> > is compiled as a module, but then you could just unload the module
> > instead of unbinding). Disallowing unbind would allow discarding not
> > only __devinit but __devexit sections when driver is built in which
> > would make ebedded people happy[^Hier].
> 
> Yeah, good point.
> 
> Does anyone do bind/unbind with platform devices today?
> 
> If not, a patch changing this would be welcome.
> 

How about this one?

-- 
Dmitry


Driver core: allow certain drivers prohibit bind/unbind via sysfs

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Platform drivers registered via platform_driver_probe() can be bound
to devices only once, upon registration, because discard their probe()
routines to save memory. Unbinding the driver through sysfs 'unbind'
leaves the device stranded and confuses users so let's not create
bind and unbind attributes for such drivers.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/base/bus.c      |   17 +++++++++++------
 drivers/base/platform.c |    6 +++++-
 include/linux/device.h  |    4 +++-
 3 files changed, 19 insertions(+), 8 deletions(-)


diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 973bf2a..63c143e 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -689,15 +689,19 @@ int bus_add_driver(struct device_driver *drv)
 		printk(KERN_ERR "%s: driver_add_attrs(%s) failed\n",
 			__func__, drv->name);
 	}
-	error = add_bind_files(drv);
-	if (error) {
-		/* Ditto */
-		printk(KERN_ERR "%s: add_bind_files(%s) failed\n",
-			__func__, drv->name);
+
+	if (!drv->suppress_bind_attrs) {
+		error = add_bind_files(drv);
+		if (error) {
+			/* Ditto */
+			printk(KERN_ERR "%s: add_bind_files(%s) failed\n",
+				__func__, drv->name);
+		}
 	}
 
 	kobject_uevent(&priv->kobj, KOBJ_ADD);
 	return 0;
+
 out_unregister:
 	kfree(drv->p);
 	drv->p = NULL;
@@ -720,7 +724,8 @@ void bus_remove_driver(struct device_driver *drv)
 	if (!drv->bus)
 		return;
 
-	remove_bind_files(drv);
+	if (!drv->suppress_bind_attrs)
+		remove_bind_files(drv);
 	driver_remove_attrs(drv->bus, drv);
 	driver_remove_file(drv, &driver_attr_uevent);
 	klist_remove(&drv->p->knode_bus);
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index ed156a1..4fa954b 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -521,11 +521,15 @@ int __init_or_module platform_driver_probe(struct platform_driver *drv,
 {
 	int retval, code;
 
+	/* make sure driver won't have bind/unbind attributes */
+	drv->driver.suppress_bind_attrs = true;
+
 	/* temporary section violation during probe() */
 	drv->probe = probe;
 	retval = code = platform_driver_register(drv);
 
-	/* Fixup that section violation, being paranoid about code scanning
+	/*
+	 * Fixup that section violation, being paranoid about code scanning
 	 * the list of drivers in order to probe new devices.  Check to see
 	 * if the probe was successful, and make sure any forced probes of
 	 * new devices fail.
diff --git a/include/linux/device.h b/include/linux/device.h
index aca31bf..2ea3e49 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -124,7 +124,9 @@ struct device_driver {
 	struct bus_type		*bus;
 
 	struct module		*owner;
-	const char 		*mod_name;	/* used for built-in modules */
+	const char		*mod_name;	/* used for built-in modules */
+
+	bool suppress_bind_attrs;	/* disables bind/unbind via sysfs */
 
 	int (*probe) (struct device *dev);
 	int (*remove) (struct device *dev);
