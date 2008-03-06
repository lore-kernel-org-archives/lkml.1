Return-Path: <linux-kernel-owner+w=401wt.eu-S1762541AbYCFH1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762541AbYCFH1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 02:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbYCFH1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 02:27:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34421 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984AbYCFH1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 02:27:38 -0500
Date: Thu, 6 Mar 2008 08:27:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.25-rc3-git3: Reported regressions from 2.6.24
Message-ID: <20080306072704.GA28518@elte.hu>
References: <200803030316.07165.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803030316.07165.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10123
> Subject		: No power-off / reboot with 2.6.25-rcX (up to -rc3) kernels
> Submitter	: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Date		: 2008-02-27 08:15

Guennadi bisected this down to:

  commit fd7d1ced29e5beb88c9068801da7a362606d8273
  PCI: make pci_bus a struct device

and it's suspected that Andrew's poweroff problems might be related as 
well. Guennadi, Andrew, find below a manual revert of this change - does 
it make any difference?

	Ingo

---------------->
Subject: revert "PCI: make pci_bus a struct device"
From: Ingo Molnar <mingo@elte.hu>
Date: Thu Mar 06 08:12:56 CET 2008

revert:

  commit fd7d1ced29e5beb88c9068801da7a362606d8273
  PCI: make pci_bus a struct device

patch for testing purposes.
---
 drivers/pci/bus.c       |   19 +++-----------
 drivers/pci/pci-sysfs.c |    6 ++--
 drivers/pci/pci.h       |    2 -
 drivers/pci/probe.c     |   64 +++++++++++++++++++++++++++++-------------------
 drivers/pci/remove.c    |    6 +++-
 include/linux/pci.h     |    4 +--
 6 files changed, 53 insertions(+), 48 deletions(-)

Index: linux/drivers/pci/bus.c
===================================================================
--- linux.orig/drivers/pci/bus.c
+++ linux/drivers/pci/bus.c
@@ -108,7 +108,6 @@ int pci_bus_add_device(struct pci_dev *d
 void pci_bus_add_devices(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
-	struct pci_bus *child_bus;
 	int retval;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
@@ -139,21 +138,11 @@ void pci_bus_add_devices(struct pci_bus 
 			       up_write(&pci_bus_sem);
 			}
 			pci_bus_add_devices(dev->subordinate);
-
-			/* register the bus with sysfs as the parent is now
-			 * properly registered. */
-			child_bus = dev->subordinate;
-			child_bus->dev.parent = child_bus->bridge;
-			retval = device_register(&child_bus->dev);
-			if (retval)
-				dev_err(&dev->dev, "Error registering pci_bus,"
-					" continuing...\n");
-			else
-				retval = device_create_file(&child_bus->dev,
-							&dev_attr_cpuaffinity);
+			retval = sysfs_create_link(&dev->subordinate->class_dev.kobj,
+						   &dev->dev.kobj, "bridge");
 			if (retval)
-				dev_err(&dev->dev, "Error creating cpuaffinity"
-					" file, continuing...\n");
+				dev_err(&dev->dev, "Error creating sysfs "
+					"bridge symlink, continuing...\n");
 		}
 	}
 }
Index: linux/drivers/pci/pci-sysfs.c
===================================================================
--- linux.orig/drivers/pci/pci-sysfs.c
+++ linux/drivers/pci/pci-sysfs.c
@@ -358,7 +358,7 @@ pci_read_legacy_io(struct kobject *kobj,
 		   char *buf, loff_t off, size_t count)
 {
         struct pci_bus *bus = to_pci_bus(container_of(kobj,
-                                                      struct device,
+                                                      struct class_device,
 						      kobj));
 
         /* Only support 1, 2 or 4 byte accesses */
@@ -383,7 +383,7 @@ pci_write_legacy_io(struct kobject *kobj
 		    char *buf, loff_t off, size_t count)
 {
         struct pci_bus *bus = to_pci_bus(container_of(kobj,
-						      struct device,
+						      struct class_device,
 						      kobj));
         /* Only support 1, 2 or 4 byte accesses */
         if (count != 1 && count != 2 && count != 4)
@@ -407,7 +407,7 @@ pci_mmap_legacy_mem(struct kobject *kobj
                     struct vm_area_struct *vma)
 {
         struct pci_bus *bus = to_pci_bus(container_of(kobj,
-                                                      struct device,
+                                                      struct class_device,
 						      kobj));
 
         return pci_mmap_legacy_page_range(bus, vma);
Index: linux/drivers/pci/pci.h
===================================================================
--- linux.orig/drivers/pci/pci.h
+++ linux/drivers/pci/pci.h
@@ -64,7 +64,7 @@ static inline int pci_no_d1d2(struct pci
 }
 extern int pcie_mch_quirk;
 extern struct device_attribute pci_dev_attrs[];
-extern struct device_attribute dev_attr_cpuaffinity;
+extern struct class_device_attribute class_device_attr_cpuaffinity;
 
 /**
  * pci_match_one_device - Tell if a PCI device structure has a matching
Index: linux/drivers/pci/probe.c
===================================================================
--- linux.orig/drivers/pci/probe.c
+++ linux/drivers/pci/probe.c
@@ -53,7 +53,7 @@ static void pci_create_legacy_files(stru
 		b->legacy_io->attr.mode = S_IRUSR | S_IWUSR;
 		b->legacy_io->read = pci_read_legacy_io;
 		b->legacy_io->write = pci_write_legacy_io;
-		device_create_bin_file(&b->dev, b->legacy_io);
+		class_device_create_bin_file(&b->class_dev, b->legacy_io);
 
 		/* Allocated above after the legacy_io struct */
 		b->legacy_mem = b->legacy_io + 1;
@@ -61,15 +61,15 @@ static void pci_create_legacy_files(stru
 		b->legacy_mem->size = 1024*1024;
 		b->legacy_mem->attr.mode = S_IRUSR | S_IWUSR;
 		b->legacy_mem->mmap = pci_mmap_legacy_mem;
-		device_create_bin_file(&b->dev, b->legacy_mem);
+		class_device_create_bin_file(&b->class_dev, b->legacy_mem);
 	}
 }
 
 void pci_remove_legacy_files(struct pci_bus *b)
 {
 	if (b->legacy_io) {
-		device_remove_bin_file(&b->dev, b->legacy_io);
-		device_remove_bin_file(&b->dev, b->legacy_mem);
+		class_device_remove_bin_file(&b->class_dev, b->legacy_io);
+		class_device_remove_bin_file(&b->class_dev, b->legacy_mem);
 		kfree(b->legacy_io); /* both are allocated here */
 	}
 }
@@ -81,27 +81,26 @@ void pci_remove_legacy_files(struct pci_
 /*
  * PCI Bus Class Devices
  */
-static ssize_t pci_bus_show_cpuaffinity(struct device *dev,
-					struct device_attribute *attr,
+static ssize_t pci_bus_show_cpuaffinity(struct class_device *class_dev,
 					char *buf)
 {
 	int ret;
 	cpumask_t cpumask;
 
-	cpumask = pcibus_to_cpumask(to_pci_bus(dev));
+	cpumask = pcibus_to_cpumask(to_pci_bus(class_dev));
 	ret = cpumask_scnprintf(buf, PAGE_SIZE, cpumask);
 	if (ret < PAGE_SIZE)
 		buf[ret++] = '\n';
 	return ret;
 }
-DEVICE_ATTR(cpuaffinity, S_IRUGO, pci_bus_show_cpuaffinity, NULL);
+CLASS_DEVICE_ATTR(cpuaffinity, S_IRUGO, pci_bus_show_cpuaffinity, NULL);
 
 /*
  * PCI Bus Class
  */
-static void release_pcibus_dev(struct device *dev)
+static void release_pcibus_dev(struct class_device *class_dev)
 {
-	struct pci_bus *pci_bus = to_pci_bus(dev);
+	struct pci_bus *pci_bus = to_pci_bus(class_dev);
 
 	if (pci_bus->bridge)
 		put_device(pci_bus->bridge);
@@ -110,7 +109,7 @@ static void release_pcibus_dev(struct de
 
 static struct class pcibus_class = {
 	.name		= "pci_bus",
-	.dev_release	= &release_pcibus_dev,
+	.release	= &release_pcibus_dev,
 };
 
 static int __init pcibus_class_init(void)
@@ -393,6 +392,7 @@ pci_alloc_child_bus(struct pci_bus *pare
 {
 	struct pci_bus *child;
 	int i;
+	int retval;
 
 	/*
 	 * Allocate a new bus, and inherit stuff from the parent..
@@ -408,12 +408,15 @@ pci_alloc_child_bus(struct pci_bus *pare
 	child->bus_flags = parent->bus_flags;
 	child->bridge = get_device(&bridge->dev);
 
-	/* initialize some portions of the bus device, but don't register it
-	 * now as the parent is not properly set up yet.  This device will get
-	 * registered later in pci_bus_add_devices()
-	 */
-	child->dev.class = &pcibus_class;
-	sprintf(child->dev.bus_id, "%04x:%02x", pci_domain_nr(child), busnr);
+	child->class_dev.class = &pcibus_class;
+	sprintf(child->class_dev.class_id, "%04x:%02x", pci_domain_nr(child), busnr);
+	retval = class_device_register(&child->class_dev);
+	if (retval)
+		goto error_register;
+	retval = class_device_create_file(&child->class_dev,
+					  &class_device_attr_cpuaffinity);
+	if (retval)
+		goto error_file_create;
 
 	/*
 	 * Set up the primary, secondary and subordinate
@@ -431,6 +434,12 @@ pci_alloc_child_bus(struct pci_bus *pare
 	bridge->subordinate = child;
 
 	return child;
+
+error_file_create:
+	class_device_unregister(&child->class_dev);
+error_register:
+	kfree(child);
+	return NULL;
 }
 
 struct pci_bus *__ref pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev, int busnr)
@@ -1083,27 +1092,32 @@ struct pci_bus * pci_create_bus(struct d
 		goto dev_reg_err;
 	b->bridge = get_device(dev);
 
-	b->dev.class = &pcibus_class;
-	b->dev.parent = b->bridge;
-	sprintf(b->dev.bus_id, "%04x:%02x", pci_domain_nr(b), bus);
-	error = device_register(&b->dev);
+	b->class_dev.class = &pcibus_class;
+	sprintf(b->class_dev.class_id, "%04x:%02x", pci_domain_nr(b), bus);
+	error = class_device_register(&b->class_dev);
 	if (error)
 		goto class_dev_reg_err;
-	error = device_create_file(&b->dev, &dev_attr_cpuaffinity);
+	error = class_device_create_file(&b->class_dev, &class_device_attr_cpuaffinity);
 	if (error)
-		goto dev_create_file_err;
+		goto class_dev_create_file_err;
 
 	/* Create legacy_io and legacy_mem files for this bus */
 	pci_create_legacy_files(b);
 
+	error = sysfs_create_link(&b->class_dev.kobj, &b->bridge->kobj, "bridge");
+	if (error)
+		goto sys_create_link_err;
+
 	b->number = b->secondary = bus;
 	b->resource[0] = &ioport_resource;
 	b->resource[1] = &iomem_resource;
 
 	return b;
 
-dev_create_file_err:
-	device_unregister(&b->dev);
+sys_create_link_err:
+	class_device_remove_file(&b->class_dev, &class_device_attr_cpuaffinity);
+class_dev_create_file_err:
+	class_device_unregister(&b->class_dev);
 class_dev_reg_err:
 	device_unregister(dev);
 dev_reg_err:
Index: linux/drivers/pci/remove.c
===================================================================
--- linux.orig/drivers/pci/remove.c
+++ linux/drivers/pci/remove.c
@@ -74,8 +74,10 @@ void pci_remove_bus(struct pci_bus *pci_
 	list_del(&pci_bus->node);
 	up_write(&pci_bus_sem);
 	pci_remove_legacy_files(pci_bus);
-	device_remove_file(&pci_bus->dev, &dev_attr_cpuaffinity);
-	device_unregister(&pci_bus->dev);
+	class_device_remove_file(&pci_bus->class_dev,
+		&class_device_attr_cpuaffinity);
+	sysfs_remove_link(&pci_bus->class_dev.kobj, "bridge");
+	class_device_unregister(&pci_bus->class_dev);
 }
 EXPORT_SYMBOL(pci_remove_bus);
 
Index: linux/include/linux/pci.h
===================================================================
--- linux.orig/include/linux/pci.h
+++ linux/include/linux/pci.h
@@ -275,13 +275,13 @@ struct pci_bus {
 	unsigned short  bridge_ctl;	/* manage NO_ISA/FBB/et al behaviors */
 	pci_bus_flags_t bus_flags;	/* Inherited by child busses */
 	struct device		*bridge;
-	struct device		dev;
+	struct class_device	class_dev;
 	struct bin_attribute	*legacy_io; /* legacy I/O for this bus */
 	struct bin_attribute	*legacy_mem; /* legacy mem */
 };
 
 #define pci_bus_b(n)	list_entry(n, struct pci_bus, node)
-#define to_pci_bus(n)	container_of(n, struct pci_bus, dev)
+#define to_pci_bus(n)	container_of(n, struct pci_bus, class_dev)
 
 /*
  * Error values that may be returned by PCI functions.
