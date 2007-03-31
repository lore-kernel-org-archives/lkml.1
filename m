Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbXCaWMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbXCaWMM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 18:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbXCaWMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 18:12:12 -0400
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:39484 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752619AbXCaWMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 18:12:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rIQNQDUp72gpxF9GlUtKbc05rqVFV2DDRXOKC78f3RutJbmHmlP0Z/GpOJhOocW8Hejiam8XsSAZMmnzoWt4nJPBWGGKvWIqFCkSkCu8HSCqlBjOIsIGOGr/dzrh7+/q5FQThV8It+J0TUWpusZEgigzs/+P31u6Gzb91ietA8E=  ;
X-YMail-OSG: .6_0CFwVM1niy3N2wq3SdkabWA.ge3Uli5_ws1nT3GmaoGQ.OZ8Ecg6FIPc1uu3_gumQ03kyJA--
From: David Brownell <david-b@pacbell.net>
To: Greg KH <gregkh@suse.de>, Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.21-rc5-git 1/2] fix hotplug for legacy platform drivers
Date: Sat, 31 Mar 2007 14:55:38 -0700
User-Agent: KMail/1.7.1
Cc: Andres Salomon <dilinger@debian.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703311455.38490.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We've had various reports of some legacy "probe the hardware" style platform
drivers having nasty problems with hotplug support.

The core issue is that those legacy drivers don't fully conform to the driver
model.  They assume a role that should be the responsibility of infrastructure
code: creating device nodes.

The "modprobe" step in hotplugging relies on drivers to have split those
roles into different modules.  The lack of this split causes the problems.
When a driver creates nodes for devices that don't exist (sending a hotplug
event), then exits (aborting one modprobe) before the "modprobe $MODALIAS"
step completes (by failing, since it's in the middle of a modprobe), the
result can be an endless loop of modprobe invocations ... badness.

This fix uses the newish per-device flag controlling issuance of "add" events.
(A previous version of this patch used a per-device "driver can hotplug" flag,
which only scrubbed $MODALIAS from the environment rather than suppressing the
entire hotplug event.)  It also shrinks that flag to one bit, saving a word in
"struct device".

So the net of this patch is removing some nasty failures with legacy drivers,
while retaining hotplug capability for the majority of platform drivers.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>


--- g26.orig/include/linux/device.h	2007-03-30 16:44:04.000000000 -0700
+++ g26/include/linux/device.h	2007-03-31 14:39:35.000000000 -0700
@@ -395,12 +395,13 @@ struct device {
 	struct klist_node	knode_parent;		/* node in sibling list */
 	struct klist_node	knode_driver;
 	struct klist_node	knode_bus;
-	struct device 	* parent;
+	struct device		*parent;
 
 	struct kobject kobj;
 	char	bus_id[BUS_ID_SIZE];	/* position on parent bus */
 	struct device_type	*type;
 	unsigned		is_registered:1;
+	unsigned		uevent_suppress:1;
 	struct device_attribute uevent_attr;
 	struct device_attribute *devt_attr;
 
@@ -441,7 +442,6 @@ struct device {
 	struct class		*class;
 	dev_t			devt;		/* dev_t, creates the sysfs "dev" */
 	struct attribute_group	**groups;	/* optional groups */
-	int			uevent_suppress;
 
 	void	(*release)(struct device * dev);
 };
--- g26.orig/drivers/base/platform.c	2007-03-30 16:44:04.000000000 -0700
+++ g26/drivers/base/platform.c	2007-03-31 14:23:02.000000000 -0700
@@ -160,6 +160,11 @@ static void platform_device_release(stru
  *
  *	Create a platform device object which can have other objects attached
  *	to it, and which will have attached objects freed when it is released.
+ *
+ *	This device will be marked as not supporting hotpluggable drivers; in
+ *	the unusual case that the device isn't being dynamically allocated as
+ *	of a legacy "probe the hardware" driver, infrastructure code should
+ *	reverse this marking.
  */
 struct platform_device *platform_device_alloc(const char *name, unsigned int id)
 {
@@ -172,6 +177,12 @@ struct platform_device *platform_device_
 		pa->pdev.id = id;
 		device_initialize(&pa->pdev.dev);
 		pa->pdev.dev.release = platform_device_release;
+
+		/* prevent hotplug "modprobe $(MODALIAS)" from causing trouble in
+		 * legacy probe-the-hardware drivers, which don't properly split
+		 * out enumeration logic from drivers.
+		 */
+		pa->pdev.dev.uevent_suppress = 1;
 	}
 
 	return pa ? &pa->pdev : NULL;
@@ -349,6 +360,13 @@ EXPORT_SYMBOL_GPL(platform_device_unregi
  *	memory allocated for the device allows drivers using such devices
  *	to be unloaded iwithout waiting for the last reference to the device
  *	to be dropped.
+ *
+ *	This interface is primarily intended for use with legacy drivers
+ *	which probe hardware directly.  Because such drivers create device
+ *	nodes themselves, rather than letting system infrastructure handle
+ *	such device enumeration tasks, they don't fully conform to the Linux
+ *	driver model.  In particular, when such drivers are built as modules,
+ *	they can't be "hotplugged".
  */
 struct platform_device *platform_device_register_simple(char *name, unsigned int id,
 							struct resource *res, unsigned int num)
--- g26.orig/drivers/pcmcia/pxa2xx_sharpsl.c	2007-03-30 16:44:04.000000000 -0700
+++ g26/drivers/pcmcia/pxa2xx_sharpsl.c	2007-03-31 14:26:04.000000000 -0700
@@ -261,6 +261,8 @@ static int __init sharpsl_pcmcia_init(vo
 	if (!sharpsl_pcmcia_device)
 		return -ENOMEM;
 
+	/* REVISIT just statically allocate the device */
+	sharpsl_pcmcia_device->dev.uevent_suppress = 0;
 	sharpsl_pcmcia_device->dev.platform_data = &sharpsl_pcmcia_ops;
 	sharpsl_pcmcia_device->dev.parent = platform_scoop_config->devs[0].dev;
 
--- g26.orig/drivers/pcmcia/pxa2xx_mainstone.c	2007-03-30 16:44:04.000000000 -0700
+++ g26/drivers/pcmcia/pxa2xx_mainstone.c	2007-03-31 14:23:56.000000000 -0700
@@ -175,6 +175,8 @@ static int __init mst_pcmcia_init(void)
 	if (!mst_pcmcia_device)
 		return -ENOMEM;
 
+	/* REVISIT just statically allocate the device */
+	mst_pcmcia_device->dev.uevent_suppress = 0;
 	mst_pcmcia_device->dev.platform_data = &mst_pcmcia_ops;
 
 	ret = platform_device_add(mst_pcmcia_device);
