Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbYCLVi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbYCLVi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 17:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbYCLVis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 17:38:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53995 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbYCLVir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 17:38:47 -0400
Date: Wed, 12 Mar 2008 14:38:26 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <len.brown@intel.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: pcibios_scanned needs to be set in ACPI?  (was Re: 2.6.25-rc5:
	Reported regressions from 2.6.24)
Message-ID: <20080312213826.GA17101@kroah.com>
References: <200803110014.52985.rjw@sisk.pl> <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org> <47D6D61F.4050805@garzik.org> <200803112341.42517.rjw@sisk.pl> <alpine.LFD.1.00.0803121300160.3557@woody.linux-foundation.org> <20080312203205.GB17187@kroah.com> <20080312212704.GA16836@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312212704.GA16836@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 02:27:04PM -0700, Greg KH wrote:
> On Wed, Mar 12, 2008 at 01:32:05PM -0700, Greg KH wrote:
> > On Wed, Mar 12, 2008 at 01:01:15PM -0700, Linus Torvalds wrote:
> > > 
> > > 
> > > On Tue, 11 Mar 2008, Rafael J. Wysocki wrote:
> > > 
> > > > 
> > > > In http://bugzilla.kernel.org/show_bug.cgi?id=10123 Guennadi says that
> > > > reverting
> > > > 
> > > > commit fd7d1ced29e5beb88c9068801da7a362606d8273
> > > > Author: Greg Kroah-Hartman <gregkh@suse.de>
> > > > Date:   Tue May 22 22:47:54 2007 -0400
> > > > 
> > > >     PCI: make pci_bus a struct device
> > > > 
> > > > fixes the problem for him (this seems to be yet another reboot/poweroff IOW).
> > > 
> > > Ahh, I thought this was done already, but nope, my PCI pull from Greg 
> > > didn't contain the revert.
> > > 
> > > Greg? I know you must be aware of the problem, because you replied to the 
> > > email at some point. Wazzup?
> > 
> > I'm still trying to figure out why his is the only machine having
> > problems with this.  I think it's an acpi "we walk the list of pci
> > devices twice" type thing, but don't know yet.
> 
> Ok, I think I got it.  And it looks like an ACPI bug, but one that we
> might have been ignoring for a long time...
> 
> 
> In looking at the log files at boot, we see that we are using ACPI to
> find the PCI devices:
> 
> 	ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> 
> Followed by a lot of kobjects for pci devices being added, including
> this root bus:
> 	kobject: '0000:01:00.0' (c7c978cc): kobject_add_internal: parent: '0000:00:01.0', set: 'devices'
> 	kobject: '0000:01:00.0' (c7c978cc): kobject_uevent_env
> 	kobject: '0000:01:00.0' (c7c978cc): fill_kobj_path: path = '/devices/pci0000:00/0000:00:01.0/0000:01:00.0'
> 	kobject: '0000:01' (c7c35900): kobject_add_internal: parent: 'pci_bus', set: 'devices'
> 	kobject: '0000:01' (c7c35900): kobject_uevent_env
> 	kobject: '0000:01' (c7c35900): fill_kobj_path: path = '/class/pci_bus/0000:01'
> 
> All is fine, until later on we decide to fallback to the "old" style of
> probing:
> 	PCI: Probing PCI hardware
> 	kobject (c7c35900): tried to init an initialized object, something is seriously wrong.
> 	Pid: 1, comm: swapper Not tainted 2.6.25-rc2-testpm #30
> 	 [<c01ea0e9>] kobject_init+0x89/0x90
> 	 [<c025094e>] device_initialize+0x1e/0x90
> 	 [<c025119b>] device_register+0xb/0x20
> 	 [<c01f3fd8>] pci_bus_add_devices+0x98/0x140
> 	 [<c030aff7>] ? pcibios_scan_root+0x27/0xa0
> 	 [<c03f69d0>] pci_legacy_init+0x50/0xf0
> 	 [<c03db5c2>] kernel_init+0x132/0x310
> 	 [<c010303a>] ? ret_from_fork+0x6/0x1c
> 	 [<c03db490>] ? kernel_init+0x0/0x310
> 	 [<c03db490>] ? kernel_init+0x0/0x310
> 	 [<c0103d3f>] kernel_thread_helper+0x7/0x18
> 	=======================
> 	kobject: '0000:01' (c7c35900): kobject_add_internal: parent: 'pci_bus', set: 'devices'
> 
> This shows that we are trying to register the exact same kobject that we
> had already previously registered.  Not nice...
> 
> Now we have a check in the pci bus code to not register anything that we
> had already registered in the past:
> 
>         list_for_each_entry(dev, &bus->devices, bus_list) {
>                 /*
>                  * Skip already-present devices (which are on the
>                  * global device list.)
>                  */
>                 if (!list_empty(&dev->global_list))
>                         continue;
>                 retval = pci_bus_add_device(dev);
> 
> But, in redoing the pci list logic (coming in .26 and in -mm and -next)
> I realized that this wasn't a real check, as this list is just a
> "shadow" list that some types of pci probing never set up.
> 
> So that explains why the warning we get when trying to register a device
> multiple times in the kobject core.
> 
> But why does this happen in the first place?
> 
> The code in arch/x86/pci/legacy.c::pci_legacy_init() checks the
> pcibios_scanned flag to determine if we had already scanned the PCI bus.
> Which we did in the ACPI code, right?
> 
> So, Len, shouldn't we be setting this flag in the ACPI core if we had
> already scanned the pci bus there?
> 
> I can fix this problem by putting the check in the pci core in
> pci_bus_add_devices() like we have done in -next, but I think that we
> also need to do something in ACPI as well.
> 
> Guennadi, could you test the -next kernel tree to see if the logic there
> solves this issue for you?

Actually, here's a simple patch from -next that should test this logic
for you.  Can you let me know if this solves the start up WARNING dump
for you?

thanks,

greg k-h

------------

Date: Thu, 14 Feb 2008 14:56:56 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: PCI: add is_added flag to struct pci_dev

This lets us check if the device is really added to the driver core or
not, which is what we need when walking some of the bus lists.  The flag
is there in anticipation of getting rid of the other PCI device list,
which is what we used to check in this situation.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/pseries/pci_dlpar.c |    7 ++-----
 drivers/pci/bus.c                          |   11 ++++-------
 drivers/pci/probe.c                        |    2 +-
 drivers/pci/remove.c                       |    6 ++----
 include/linux/pci.h                        |    1 +
 5 files changed, 10 insertions(+), 17 deletions(-)

--- a/arch/powerpc/platforms/pseries/pci_dlpar.c
+++ b/arch/powerpc/platforms/pseries/pci_dlpar.c
@@ -88,11 +88,8 @@ pcibios_fixup_new_pci_devices(struct pci
 	struct pci_dev *dev;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-		/*
-		 * Skip already-present devices (which are on the
-		 * global device list.)
-		 */
-		if (list_empty(&dev->global_list)) {
+		/* Skip already-added devices */
+		if (!dev->is_added) {
 			int i;
 
 			/* Fill device archdata and setup iommu table */
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -84,6 +84,7 @@ int pci_bus_add_device(struct pci_dev *d
 	if (retval)
 		return retval;
 
+	dev->is_added = 1;
 	down_write(&pci_bus_sem);
 	list_add_tail(&dev->global_list, &pci_devices);
 	up_write(&pci_bus_sem);
@@ -112,11 +113,8 @@ void pci_bus_add_devices(struct pci_bus 
 	int retval;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-		/*
-		 * Skip already-present devices (which are on the
-		 * global device list.)
-		 */
-		if (!list_empty(&dev->global_list))
+		/* Skip already-added devices */
+		if (dev->is_added)
 			continue;
 		retval = pci_bus_add_device(dev);
 		if (retval)
@@ -124,8 +122,7 @@ void pci_bus_add_devices(struct pci_bus 
 	}
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-
-		BUG_ON(list_empty(&dev->global_list));
+		BUG_ON(!dev->is_added);
 
 		/*
 		 * If there is an unattached subordinate bus, attach
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -984,7 +984,7 @@ EXPORT_SYMBOL(pci_scan_single_device);
  *
  * Scan a PCI slot on the specified PCI bus for devices, adding
  * discovered devices to the @bus->devices list.  New devices
- * will have an empty dev->global_list head.
+ * will not have is_added set.
  */
 int pci_scan_slot(struct pci_bus *bus, int devfn)
 {
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -18,13 +18,11 @@ static void pci_free_resources(struct pc
 
 static void pci_stop_dev(struct pci_dev *dev)
 {
-	if (!dev->global_list.next)
-		return;
-
-	if (!list_empty(&dev->global_list)) {
+	if (dev->is_added) {
 		pci_proc_detach_device(dev);
 		pci_remove_sysfs_dev_files(dev);
 		device_unregister(&dev->dev);
+		dev->is_added = 0;
 		down_write(&pci_bus_sem);
 		list_del(&dev->global_list);
 		dev->global_list.next = dev->global_list.prev = NULL;
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -181,6 +181,7 @@ struct pci_dev {
 	unsigned int	transparent:1;	/* Transparent PCI bridge */
 	unsigned int	multifunction:1;/* Part of multi-function device */
 	/* keep track of device state */
+	unsigned int	is_added:1;
 	unsigned int	is_busmaster:1; /* device is busmaster */
 	unsigned int	no_msi:1;	/* device may not use msi */
 	unsigned int	no_d1d2:1;   /* only allow d0 or d3 */
