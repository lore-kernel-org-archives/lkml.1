Return-Path: <linux-kernel-owner+w=401wt.eu-S1752272AbYKWVCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbYKWVCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 16:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbYKWVCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 16:02:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:57542 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYKWVCI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 16:02:08 -0500
Date: Sun, 23 Nov 2008 13:03:02 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Subject: [PATCH] resource: allow MMIO exclusivity for device drivers
Message-ID: <20081123130302.22c197d5@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 18cafd344e3de33b5e4feddac5657c1f5fed2d56 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Wed, 22 Oct 2008 19:55:31 -0700
Subject: [PATCH] resource: allow MMIO exclusivity for device drivers

Device drivers that use pci_request_regions() (and similar APIs) have a
reasonable expectation that they are the only ones accessing their device.
As part of the e1000e hunt, we were afraid that some userland (X or some
bootsplash stuff) was mapping the MMIO region that the driver thought it
had exclusively via /dev/mem or via various sysfs resource mappings.

This patch adds the option for device drivers to cause their reserved
regions to the "banned from /dev/mem use" list, so now both kernel memory
and device-exclusive MMIO regions are banned.
NOTE: This is only active when CONFIG_STRICT_DEVMEM is set.

In addition to the config option, a kernel parameter iomem=relaxed is
provided for the cases where developers want to diagnose, in the field,
drivers issues from userspace.

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 Documentation/kernel-parameters.txt |    4 +
 arch/x86/mm/init_32.c               |    2 +
 arch/x86/mm/init_64.c               |    2 +
 drivers/net/e1000e/netdev.c         |    2 +-
 drivers/pci/pci-sysfs.c             |    3 +
 drivers/pci/pci.c                   |  107 +++++++++++++++++++++++++++++++----
 include/linux/ioport.h              |   11 +++-
 include/linux/pci.h                 |    3 +
 kernel/resource.c                   |   61 +++++++++++++++++++-
 9 files changed, 176 insertions(+), 19 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e0f346d..c5a3890 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -898,6 +898,10 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	inttest=	[IA64]
 
+	iomem=		Disable strict checking of access to MMIO memory
+		strict	regions from userspace.
+		relaxed
+
 	iommu=		[x86]
 		off
 		force
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index c483f42..0c59836 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -329,6 +329,8 @@ int devmem_is_allowed(unsigned long pagenr)
 {
 	if (pagenr <= 256)
 		return 1;
+	if (iomem_is_exclusive(pagenr << PAGE_SHIFT))
+		return 0;
 	if (!page_is_ram(pagenr))
 		return 1;
 	return 0;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 9db01db..67db04a 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -888,6 +888,8 @@ int devmem_is_allowed(unsigned long pagenr)
 {
 	if (pagenr <= 256)
 		return 1;
+	if (iomem_is_exclusive(pagenr << PAGE_SHIFT))
+		return 0;
 	if (!page_is_ram(pagenr))
 		return 1;
 	return 0;
diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index 91795f7..38106f2 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -4760,7 +4760,7 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 		}
 	}
 
-	err = pci_request_selected_regions(pdev,
+	err = pci_request_selected_regions_exclusive(pdev,
 	                                  pci_select_bars(pdev, IORESOURCE_MEM),
 	                                  e1000e_driver_name);
 	if (err)
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 5d72866..994e1ea 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -620,6 +620,9 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 	vma->vm_pgoff += start >> PAGE_SHIFT;
 	mmap_type = res->flags & IORESOURCE_MEM ? pci_mmap_mem : pci_mmap_io;
 
+	if (res->flags & IORESOURCE_MEM && iomem_is_exclusive(start))
+		return -EINVAL;
+
 	return pci_mmap_page_range(pdev, vma, mmap_type, write_combine);
 }
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 28af496..9f0e48b 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1395,7 +1395,8 @@ void pci_release_region(struct pci_dev *pdev, int bar)
  *	Returns 0 on success, or %EBUSY on error.  A warning
  *	message is also printed on failure.
  */
-int pci_request_region(struct pci_dev *pdev, int bar, const char *res_name)
+static int __pci_request_region(struct pci_dev *pdev, int bar, const char *res_name,
+									int exclusive)
 {
 	struct pci_devres *dr;
 
@@ -1408,8 +1409,9 @@ int pci_request_region(struct pci_dev *pdev, int bar, const char *res_name)
 			goto err_out;
 	}
 	else if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM) {
-		if (!request_mem_region(pci_resource_start(pdev, bar),
-				        pci_resource_len(pdev, bar), res_name))
+		if (!__request_mem_region(pci_resource_start(pdev, bar),
+					pci_resource_len(pdev, bar), res_name,
+					exclusive))
 			goto err_out;
 	}
 
@@ -1428,6 +1430,47 @@ err_out:
 }
 
 /**
+ *	pci_request_region - Reserved PCI I/O and memory resource
+ *	@pdev: PCI device whose resources are to be reserved
+ *	@bar: BAR to be reserved
+ *	@res_name: Name to be associated with resource.
+ *
+ *	Mark the PCI region associated with PCI device @pdev BR @bar as
+ *	being reserved by owner @res_name.  Do not access any
+ *	address inside the PCI regions unless this call returns
+ *	successfully.
+ *
+ *	Returns 0 on success, or %EBUSY on error.  A warning
+ *	message is also printed on failure.
+ */
+int pci_request_region(struct pci_dev *pdev, int bar, const char *res_name)
+{
+	return __pci_request_region(pdev, bar, res_name, 0);
+}
+
+/**
+ *	pci_request_region_exclusive - Reserved PCI I/O and memory resource
+ *	@pdev: PCI device whose resources are to be reserved
+ *	@bar: BAR to be reserved
+ *	@res_name: Name to be associated with resource.
+ *
+ *	Mark the PCI region associated with PCI device @pdev BR @bar as
+ *	being reserved by owner @res_name.  Do not access any
+ *	address inside the PCI regions unless this call returns
+ *	successfully.
+ *
+ *	Returns 0 on success, or %EBUSY on error.  A warning
+ *	message is also printed on failure.
+ *
+ *	The key difference that _exclusive makes it that userspace is
+ *	explicitly not allowed to map the resource via /dev/mem or
+ * 	sysfs.
+ */
+int pci_request_region_exclusive(struct pci_dev *pdev, int bar, const char *res_name)
+{
+	return __pci_request_region(pdev, bar, res_name, IORESOURCE_EXCLUSIVE);
+}
+/**
  * pci_release_selected_regions - Release selected PCI I/O and memory resources
  * @pdev: PCI device whose resources were previously reserved
  * @bars: Bitmask of BARs to be released
@@ -1444,20 +1487,14 @@ void pci_release_selected_regions(struct pci_dev *pdev, int bars)
 			pci_release_region(pdev, i);
 }
 
-/**
- * pci_request_selected_regions - Reserve selected PCI I/O and memory resources
- * @pdev: PCI device whose resources are to be reserved
- * @bars: Bitmask of BARs to be requested
- * @res_name: Name to be associated with resource
- */
-int pci_request_selected_regions(struct pci_dev *pdev, int bars,
-				 const char *res_name)
+int __pci_request_selected_regions(struct pci_dev *pdev, int bars,
+				 const char *res_name, int excl)
 {
 	int i;
 
 	for (i = 0; i < 6; i++)
 		if (bars & (1 << i))
-			if(pci_request_region(pdev, i, res_name))
+			if (__pci_request_region(pdev, i, res_name, excl))
 				goto err_out;
 	return 0;
 
@@ -1469,6 +1506,26 @@ err_out:
 	return -EBUSY;
 }
 
+
+/**
+ * pci_request_selected_regions - Reserve selected PCI I/O and memory resources
+ * @pdev: PCI device whose resources are to be reserved
+ * @bars: Bitmask of BARs to be requested
+ * @res_name: Name to be associated with resource
+ */
+int pci_request_selected_regions(struct pci_dev *pdev, int bars,
+				 const char *res_name)
+{
+	return __pci_request_selected_regions(pdev, bars, res_name, 0);
+}
+
+int pci_request_selected_regions_exclusive(struct pci_dev *pdev,
+				 int bars, const char *res_name)
+{
+	return __pci_request_selected_regions(pdev, bars, res_name,
+			IORESOURCE_EXCLUSIVE);
+}
+
 /**
  *	pci_release_regions - Release reserved PCI I/O and memory resources
  *	@pdev: PCI device whose resources were previously reserved by pci_request_regions
@@ -1502,6 +1559,29 @@ int pci_request_regions(struct pci_dev *pdev, const char *res_name)
 }
 
 /**
+ *	pci_request_regions_exclusive - Reserved PCI I/O and memory resources
+ *	@pdev: PCI device whose resources are to be reserved
+ *	@res_name: Name to be associated with resource.
+ *
+ *	Mark all PCI regions associated with PCI device @pdev as
+ *	being reserved by owner @res_name.  Do not access any
+ *	address inside the PCI regions unless this call returns
+ *	successfully.
+ *
+ *	pci_request_regions_exclusive() will mark the region so that
+ * 	/dev/mem and the sysfs MMIO access will not be allowed.
+ *
+ *	Returns 0 on success, or %EBUSY on error.  A warning
+ *	message is also printed on failure.
+ */
+int pci_request_regions_exclusive(struct pci_dev *pdev, const char *res_name)
+{
+	return pci_request_selected_regions_exclusive(pdev,
+					((1 << 6) - 1), res_name);
+}
+
+
+/**
  * pci_set_master - enables bus-mastering for device dev
  * @dev: the PCI device to enable
  *
@@ -2083,10 +2163,13 @@ EXPORT_SYMBOL(pci_find_capability);
 EXPORT_SYMBOL(pci_bus_find_capability);
 EXPORT_SYMBOL(pci_release_regions);
 EXPORT_SYMBOL(pci_request_regions);
+EXPORT_SYMBOL(pci_request_regions_exclusive);
 EXPORT_SYMBOL(pci_release_region);
 EXPORT_SYMBOL(pci_request_region);
+EXPORT_SYMBOL(pci_request_region_exclusive);
 EXPORT_SYMBOL(pci_release_selected_regions);
 EXPORT_SYMBOL(pci_request_selected_regions);
+EXPORT_SYMBOL(pci_request_selected_regions_exclusive);
 EXPORT_SYMBOL(pci_set_master);
 EXPORT_SYMBOL(pci_set_mwi);
 EXPORT_SYMBOL(pci_try_set_mwi);
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 041e95a..f6bb2ca 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -49,6 +49,7 @@ struct resource_list {
 #define IORESOURCE_SIZEALIGN	0x00020000	/* size indicates alignment */
 #define IORESOURCE_STARTALIGN	0x00040000	/* start field is alignment */
 
+#define IORESOURCE_EXCLUSIVE	0x08000000	/* Userland may not map this resource */
 #define IORESOURCE_DISABLED	0x10000000
 #define IORESOURCE_UNSET	0x20000000
 #define IORESOURCE_AUTO		0x40000000
@@ -133,13 +134,16 @@ static inline unsigned long resource_type(struct resource *res)
 }
 
 /* Convenience shorthand with allocation */
-#define request_region(start,n,name)	__request_region(&ioport_resource, (start), (n), (name))
-#define request_mem_region(start,n,name) __request_region(&iomem_resource, (start), (n), (name))
+#define request_region(start,n,name)	__request_region(&ioport_resource, (start), (n), (name), 0)
+#define __request_mem_region(start,n,name, excl) __request_region(&iomem_resource, (start), (n), (name), excl)
+#define request_mem_region(start,n,name) __request_region(&iomem_resource, (start), (n), (name), 0)
+#define request_mem_region_exclusive(start,n,name) \
+	__request_region(&iomem_resource, (start), (n), (name), IORESOURCE_EXCLUSIVE)
 #define rename_region(region, newname) do { (region)->name = (newname); } while (0)
 
 extern struct resource * __request_region(struct resource *,
 					resource_size_t start,
-					resource_size_t n, const char *name);
+					resource_size_t n, const char *name, int relaxed);
 
 /* Compatibility cruft */
 #define release_region(start,n)	__release_region(&ioport_resource, (start), (n))
@@ -175,6 +179,7 @@ extern struct resource * __devm_request_region(struct device *dev,
 extern void __devm_release_region(struct device *dev, struct resource *parent,
 				  resource_size_t start, resource_size_t n);
 extern int iomem_map_sanity_check(resource_size_t addr, unsigned long size);
+extern int iomem_is_exclusive(u64 addr);
 
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index feb4657..a692b0c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -681,10 +681,13 @@ void pci_fixup_irqs(u8 (*)(struct pci_dev *, u8 *),
 		    int (*)(struct pci_dev *, u8, u8));
 #define HAVE_PCI_REQ_REGIONS	2
 int __must_check pci_request_regions(struct pci_dev *, const char *);
+int __must_check pci_request_regions_exclusive(struct pci_dev *, const char *);
 void pci_release_regions(struct pci_dev *);
 int __must_check pci_request_region(struct pci_dev *, int, const char *);
+int __must_check pci_request_region_exclusive(struct pci_dev *, int, const char *);
 void pci_release_region(struct pci_dev *, int);
 int pci_request_selected_regions(struct pci_dev *, int, const char *);
+int pci_request_selected_regions_exclusive(struct pci_dev *, int, const char *);
 void pci_release_selected_regions(struct pci_dev *, int);
 
 /* drivers/pci/bus.c */
diff --git a/kernel/resource.c b/kernel/resource.c
index 4337063..c251b0f 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -623,7 +623,7 @@ resource_size_t resource_alignment(struct resource *res)
  */
 struct resource * __request_region(struct resource *parent,
 				   resource_size_t start, resource_size_t n,
-				   const char *name)
+				   const char *name, int flags)
 {
 	struct resource *res = kzalloc(sizeof(*res), GFP_KERNEL);
 
@@ -634,6 +634,7 @@ struct resource * __request_region(struct resource *parent,
 	res->start = start;
 	res->end = start + n - 1;
 	res->flags = IORESOURCE_BUSY;
+	res->flags |= flags;
 
 	write_lock(&resource_lock);
 
@@ -679,7 +680,7 @@ int __check_region(struct resource *parent, resource_size_t start,
 {
 	struct resource * res;
 
-	res = __request_region(parent, start, n, "check-region");
+	res = __request_region(parent, start, n, "check-region", 0);
 	if (!res)
 		return -EBUSY;
 
@@ -776,7 +777,7 @@ struct resource * __devm_request_region(struct device *dev,
 	dr->start = start;
 	dr->n = n;
 
-	res = __request_region(parent, start, n, name);
+	res = __request_region(parent, start, n, name, 0);
 	if (res)
 		devres_add(dev, dr);
 	else
@@ -867,3 +868,57 @@ int iomem_map_sanity_check(resource_size_t addr, unsigned long size)
 
 	return err;
 }
+
+#ifdef CONFIG_STRICT_DEVMEM
+static int strict_iomem_checks = 1;
+#else
+static int strict_iomem_checks;
+#endif
+
+/*
+ * check if an address is reserved in the iomem resource tree
+ * returns 1 if reserved, 0 if not reserved.
+ */
+int iomem_is_exclusive(u64 addr)
+{
+	struct resource *p = &iomem_resource;
+	int err = 0;
+	loff_t l;
+	int size = PAGE_SIZE;
+
+	if (!strict_iomem_checks)
+		return 0;
+
+	addr = addr & PAGE_MASK;
+
+	read_lock(&resource_lock);
+	for (p = p->child; p ; p = r_next(NULL, p, &l)) {
+		/*
+		 * We can probably skip the resources without
+		 * IORESOURCE_IO attribute?
+		 */
+		if (p->start >= addr + size)
+			break;
+		if (p->end < addr)
+			continue;
+		if (p->flags & IORESOURCE_BUSY &&
+		     p->flags & IORESOURCE_EXCLUSIVE) {
+			err = 1;
+			break;
+		}
+	}
+	read_unlock(&resource_lock);
+
+	return err;
+}
+
+static int __init strict_iomem(char *str)
+{
+	if (strstr(str, "relaxed"))
+		strict_iomem_checks = 0;
+	if (strstr(str, "strict"))
+		strict_iomem_checks = 1;
+	return 1;
+}
+
+__setup("iomem=", strict_iomem);
-- 
1.6.0.3


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
