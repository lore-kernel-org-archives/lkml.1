Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbYA1S0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbYA1S0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbYA1S0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:26:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48175 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbYA1S0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:26:10 -0500
Date: Mon, 28 Jan 2008 10:24:23 -0800
From: Greg KH <greg@kroah.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: Jan-Bernd Themann <ossthema@de.ibm.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sam@ravnborg.org,
       Christoph Raisch <raisch@de.ibm.com>
Subject: Re: [2.6.24-rc6-mm1]Build failure in drivers/net/ehea/ehea_main.c
Message-ID: <20080128182423.GC28861@kroah.com>
References: <20080108163305.GB10026@in.ibm.com> <20080110173418.GA14728@kroah.com> <200801181016.49128.ossthema@de.ibm.com> <20080125191047.GM14201@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125191047.GM14201@localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 01:10:48PM -0600, Nathan Lynch wrote:
> Jan-Bernd Themann wrote:
> > Hi,
> > 
> > sorry for answering so late, I'm only tracking netdev and ppc mailing list.
> > 
> > On Thursday 10 January 2008 18:34, Greg KH wrote:
> > > > The structure device_driver(in device.h) has a member struct driver_private which
> > > > contains the member kobj (according to drivers/base/base.h).
> > > > But in device.h struct driver_private has been declared localy and 
> > > > neither defined nor included from base.h.
> > > > So my effort to use driver->driver_private->obj also does not work.
> > > > (I am surprised from where do you access the struct device_driver)
> > > 
> > > That is because a driver should not be accessing such a field.
> > > 
> > > And especially not in this manner, why would this driver be creating a
> > > symlink that has already been created by the driver core?  This whole
> > > thing can just be removed with no problems.  Can you try just removing
> > > the ehea_driver_sysfs_add and ehea_driver_sysfs_remove functions to
> > > verify this as I don't have the hardware present to test it out.
> > 
> > The eHEA driver tries to orginize its sys-entries as close as possible to
> > other ethernet drivers. Each eHEA NIC has multiple ports which is not that
> > common in PCI. This means that each port is represented by a subdirectory
> > which has not the "driver" sys-link, only the root directory has.
> > Some tools expect to have this driver link in each port directory.
> > That is the reason why this link is created manually.
> > 
> > Are there any other ways to create this link?
> 
> 
> This is now broken in mainline...
> 
> drivers/net/ehea/ehea_main.c: In function 'ehea_driver_sysfs_add':
> drivers/net/ehea/ehea_main.c:2812: error: 'struct device_driver' has
> no member named 'kobj'
> drivers/net/ehea/ehea_main.c:2815: error: 'struct device_driver' has
> no member named 'kobj'
> drivers/net/ehea/ehea_main.c:2818: error: 'struct device_driver' has
> no member named 'kobj'
> drivers/net/ehea/ehea_main.c: In function 'ehea_driver_sysfs_remove':
> drivers/net/ehea/ehea_main.c:2830: error: 'struct device_driver' has
> no member named 'kobj'

Does the patch below fix this?  That driver should not have been trying
to create symlinks that the driver core has already created for it.
Dumb, dumb, dumb...


thanks,

greg k-h

------------------

---
 drivers/net/ehea/ehea_main.c |   37 -------------------------------------
 1 file changed, 37 deletions(-)

--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -2804,34 +2804,6 @@ static void __devinit logical_port_relea
 	of_node_put(port->ofdev.node);
 }
 
-static int ehea_driver_sysfs_add(struct device *dev,
-				 struct device_driver *driver)
-{
-	int ret;
-
-	ret = sysfs_create_link(&driver->kobj, &dev->kobj,
-				kobject_name(&dev->kobj));
-	if (ret == 0) {
-		ret = sysfs_create_link(&dev->kobj, &driver->kobj,
-					"driver");
-		if (ret)
-			sysfs_remove_link(&driver->kobj,
-					  kobject_name(&dev->kobj));
-	}
-	return ret;
-}
-
-static void ehea_driver_sysfs_remove(struct device *dev,
-				     struct device_driver *driver)
-{
-	struct device_driver *drv = driver;
-
-	if (drv) {
-		sysfs_remove_link(&drv->kobj, kobject_name(&dev->kobj));
-		sysfs_remove_link(&dev->kobj, "driver");
-	}
-}
-
 static struct device *ehea_register_port(struct ehea_port *port,
 					 struct device_node *dn)
 {
@@ -2856,16 +2828,8 @@ static struct device *ehea_register_port
 		goto out_unreg_of_dev;
 	}
 
-	ret = ehea_driver_sysfs_add(&port->ofdev.dev, &ehea_driver.driver);
-	if (ret) {
-		ehea_error("failed to register sysfs driver link");
-		goto out_rem_dev_file;
-	}
-
 	return &port->ofdev.dev;
 
-out_rem_dev_file:
-	device_remove_file(&port->ofdev.dev, &dev_attr_log_port_id);
 out_unreg_of_dev:
 	of_device_unregister(&port->ofdev);
 out:
@@ -2874,7 +2838,6 @@ out:
 
 static void ehea_unregister_port(struct ehea_port *port)
 {
-	ehea_driver_sysfs_remove(&port->ofdev.dev, &ehea_driver.driver);
 	device_remove_file(&port->ofdev.dev, &dev_attr_log_port_id);
 	of_device_unregister(&port->ofdev);
 }
