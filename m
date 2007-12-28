Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbXL1XvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbXL1XvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 18:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbXL1XvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 18:51:14 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50529 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbXL1XvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 18:51:13 -0500
Date: Fri, 28 Dec 2007 23:50:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de
Cc: Bahadir Balban <bahadir.balban@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: 2.6.24-rc5 sysfs pci bridge duplicate symlink
Message-ID: <20071228235048.GB22935@flint.arm.linux.org.uk>
References: <7ac1e90c0712280511y3a0f454cmc84e8c17f173c8dc@mail.gmail.com> <20071228150322.71e5ca49.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071228150322.71e5ca49.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2007 at 03:03:22PM -0800, Andrew Morton wrote:
> On Fri, 28 Dec 2007 13:11:37 +0000 "Bahadir Balban" <bahadir.balban@gmail.com> wrote:
> 
> > Hi,
> > 
> > On ARM with PCI, I get this error since -rc2 (didn't try rc1):
> > 
> > sysfs: duplicate filename 'bridge' can not be created
> > WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> > [<c00287fc>] (dump_stack+0x0/0x14) from [<c00cbc64>] (sysfs_add_one+0x50/0xf4)
> > [<c00cbc14>] (sysfs_add_one+0x0/0xf4) from [<c00ccd30>]
> > (sysfs_create_link+0xec/0x184)
> >  r6:cfca8b48 r5:cfca96c8 r4:cfc2fec0
> > [<c00ccc44>] (sysfs_create_link+0x0/0x184) from [<c0160b44>]
> > (pci_bus_add_devices+0xf0/0x144)
> >  r7:cfc5a2d4 r6:cfc5a2d4 r5:cfc5a2c0 r4:cfcad800
> > [<c0160a54>] (pci_bus_add_devices+0x0/0x144) from [<c0160b30>]
> > (pci_bus_add_devices+0xdc/0x144)
> >  r7:cfc5a3d4 r6:cfc5a3d4 r5:cfc5a3c0 r4:cfcadc00
> > [<c0160a54>] (pci_bus_add_devices+0x0/0x144) from [<c0160b30>]
> > (pci_bus_add_devices+0xdc/0x144)
> >  r7:cfc5a4d4 r6:cfc5a4d4 r5:cfc5a4c0 r4:cfc5d400
> > [<c0160a54>] (pci_bus_add_devices+0x0/0x144) from [<c000a934>]
> > (pci_common_init+0x148/0x184)
> >  r7:c035fd58 r6:cfc3e760 r5:c001e030 r4:cfc5a4c0
> > 
> > 
> > Any idea why?
> > 
> 
> (suitable cc added)

Looks to me as if the code added to pci_bus_add_devices() is off it's
rocker.

In brief, pci_bus_add_devices() is supposed to be callable given *any*
state of the bus, and it will add any new devices found in the bus tree
from the bus that it's called for downwards.  (That's how I designed
that bit of PCI code - so it can cope with hotpluggable PCI bridges.)

It still does this.  However, some bright spark decided to add sysfs
links to it - and break it.  Now, whenever we descend into a subordinate
bus (and return to a higher level) we will try to create a sysfs symlink
even if the bus is one that we already registered.

So... that sysfs_create_link() call in there should not be unconditional.
It should _only_ ever do that call if list_empty(&dev->subordinate->node)
was true.  IOW, we only create symlinks for subordinate bus that we don't
already know about.

It looks like it was introduced by Greg's "PCI: fix __must_check warnings"
but why a patch advertised _solely_ as a fix is adding additional sysfs
attributes I've no idea.

Something like the following should fix it.  Bahadir - please test.

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 9e5ea07..132a91f 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -131,18 +131,21 @@ void pci_bus_add_devices(struct pci_bus *bus)
 		 * it and then scan for unattached PCI devices.
 		 */
 		if (dev->subordinate) {
-		       if (list_empty(&dev->subordinate->node)) {
+			int new_bus = list_empty(&dev->subordinate->node);
+			if (new_bus) {
 			       down_write(&pci_bus_sem);
 			       list_add_tail(&dev->subordinate->node,
 					       &dev->bus->children);
 			       up_write(&pci_bus_sem);
 			}
 			pci_bus_add_devices(dev->subordinate);
-			retval = sysfs_create_link(&dev->subordinate->class_dev.kobj,
-						   &dev->dev.kobj, "bridge");
-			if (retval)
-				dev_err(&dev->dev, "Error creating sysfs "
-					"bridge symlink, continuing...\n");
+			if (new_bus) {
+				retval = sysfs_create_link(&dev->subordinate->class_dev.kobj,
+							   &dev->dev.kobj, "bridge");
+				if (retval)
+					dev_err(&dev->dev, "Error creating sysfs "
+						"bridge symlink, continuing...\n");
+			}
 		}
 	}
 }

