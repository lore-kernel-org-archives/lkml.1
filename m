Return-Path: <linux-kernel-owner+w=401wt.eu-S932710AbXDFJiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710AbXDFJiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 05:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932664AbXDFJiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 05:38:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:32456 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932658AbXDFJiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 05:38:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,381,1170662400"; 
   d="scan'208"; a="225765970:sNHT31167766"
Subject: Re: [patch 2.6.21-rc5-git] make /proc/acpi/wakeup more useful
From: Zhang Rui <rui.zhang@intel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger" <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, lenb@kernel.org
In-Reply-To: <200704050358.43689.david-b@pacbell.net>
References: <200704031741.42273.david-b@pacbell.net>
	 <1175759995.23121.18.camel@localhost.localdomain>
	 <200704050358.43689.david-b@pacbell.net>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 17:36:53 +0800
Message-Id: <1175852213.2650.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 03:58 -0700, David Brownell wrote: 
> On Thursday 05 April 2007 12:59 am, Zhang Rui wrote:
> > On Wed, 2007-04-04 at 08:41 +0800, David Brownell wrote:
> > > In that example, two devices don't actually exist (USB3, S139), one can't
> > > issue wakeup events (PCI0), and two seem harmlessly (?) confused (MDM and
> > > AUD are the same PCI device, but it's the _modem_ that does wake-on-ring). 
> > > 
> > Well, ACPI can't find the sysfs node for all the wakeup-enabled devices.
> 
> The only example of that type in the example I provided is SLPB, where the
> sysfs node is ACPI-internal; I'm not sure how one can detect such cases.
> 
> 
> > In fact, only pci and pnp devices can be found now.
> 
> Well, PNP courtesy of a previous patch from me, but remember that I was
> using that as an example of a ** BOGUS ACPI TABLE ** as summarized above.
Then it's OK. :)
> 
> > ACPI needs the ability to distinguish all the physical devices, i.e. map
> > ACPI device to physical device nodes in sysfs, which I mentioned before.
> 
> For wakeup devices, the main issue I've seen is with button devices.
> In my limited set of test sytems, everything else is either PCI, PNP,
> or a bug (listing a non-existent device).
There may be other wakeup-enabled devices like legacy serial,
PS2 devices described in ACPI name space. 
> If this patch starts to get deployed, I expect other people will find
> a few other curiousities ... and likely some things to be fixed.

> The /sys/devices/acpi_system:00/ tree is kind of new.  I suspect one
> way it could be more informative is to set up cross-links in sysfs
> between the ACPI devices and the "real" device nodes ... e.g. on the
> system I'm using right now .../device:00/PNP0A03:00/device:15/PNP0B00:00
> could have a link pointing to /sys/devices/pnp0/00:06 ... and that PNP
> node in turn could have an "acpi" link pointing back to the ACPI thing.
> 
> Such cross-links would let people see those relationships, and observe
> which links are missing or otherwise strange.  Fixing the bugs would
> seem unlikely until those things become visible.
Sounds nice.
The patch below should make sense.

Add cross-links between ACPI device and "real" devices in sysfs.

Signed-off-by: Zhang Rui <rui.zhang@intel.com> 
---
 drivers/acpi/glue.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+)

Index: linux-2.6.21-rc5/drivers/acpi/glue.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/acpi/glue.c	2007-04-06 16:06:04.000000000 +0800
+++ linux-2.6.21-rc5/drivers/acpi/glue.c	2007-04-06 17:32:40.000000000 +0800
@@ -147,6 +147,7 @@ EXPORT_SYMBOL(acpi_get_physical_device);
 static int acpi_bind_one(struct device *dev, acpi_handle handle)
 {
 	acpi_status status;
+	struct acpi_device *acpi_dev;
 
 	if (dev->archdata.acpi_handle) {
 		printk(KERN_WARNING PREFIX
@@ -161,16 +162,29 @@ static int acpi_bind_one(struct device *
 	}
 	dev->archdata.acpi_handle = handle;
 
+	if (!acpi_bus_get_device(handle, &acpi_dev)) {
+		sysfs_create_link(&dev->kobj, &acpi_dev->dev.kobj, "ACPI_node");
+		sysfs_create_link(&acpi_dev->dev.kobj, &dev->kobj, "physical_node");
+	}
+
 	return 0;
 }
 
 static int acpi_unbind_one(struct device *dev)
 {
+	struct acpi_device *acpi_dev;
+
 	if (!dev->archdata.acpi_handle)
 		return 0;
 	if (dev == acpi_get_physical_device(dev->archdata.acpi_handle)) {
 		/* acpi_get_physical_device increase refcnt by one */
 		put_device(dev);
+
+		if (!acpi_bus_get_device(dev->archdata.acpi_handle, &acpi_dev)) {
+			sysfs_remove_link(&dev->kobj, "ACPI_node");
+			sysfs_remove_link(&acpi_dev->dev.kobj, "physical_node");
+		}
+
 		acpi_detach_data(dev->archdata.acpi_handle,
 				 acpi_glue_data_handler);
 		dev->archdata.acpi_handle = NULL;

