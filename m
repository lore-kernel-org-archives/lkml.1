Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbYJFVqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbYJFVqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 17:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbYJFVqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 17:46:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:48128 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbYJFVqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 17:46:32 -0400
Date: Mon, 6 Oct 2008 14:46:29 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, mingo@elte.hu
Subject: [PATCH] resource: ensure MMIO exclusivity for device drivers
Message-ID: <20081006144629.25091ac0@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

updated version; many updates based on Alan's feedback

I also have a second patch that transforms basically drivers/video to 
the non-exclusive API, but I'll wait with that until this one gets more backed

From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 5 Oct 2008 18:00:15 -0700
Subject: [PATCH] resource: ensure MMIO exclusivity for device drivers

Device drivers that use pci_request_regions() (and similar APIs) have a
reasonable expectation that they are the only ones accessing their device.
As part of the e1000e hunt, we were afraid that some userland (X or some
bootsplash stuff) was mapping the MMIO region that the driver thought it
had exclusively via /dev/mem or via various sysfs resource mappings.

This patch adds the reserved regions to the "banned from /dev/mem use" list,
so now both kernel memory and device-exclusive MMIO regions are banned.
NOTE: This is only active when CONFIG_STRICT_DEVMEM is set.

The introduced iomem_is_reserved() function is also planned to be used
for other patches in 2.6.28 (pci_ioremap) so is exported here as part
of being introduced.

In addition to the config option, a kernel parameter iomem=relaxed is
provided for the cases where developers want to diagnose, in the field,
drivers issues from userspace.

Signed-of-by: Arjan van de Ven <arjan@linux.intel.com>
---
 Documentation/kernel-parameters.txt |    4 ++
 arch/x86/mm/init_32.c               |    2 +
 arch/x86/mm/init_64.c               |    2 +
 drivers/pci/pci-sysfs.c             |    3 ++
 drivers/pci/pci.c                   |   50 +++++++++++++++++++++++++++-
 include/linux/ioport.h              |    9 +++--
 include/linux/pci.h                 |    1 +
 kernel/resource.c                   |   61 +++++++++++++++++++++++++++++++++--
 8 files changed, 124 insertions(+), 8 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4b9ee9b..e0b0a6b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -882,6 +882,10 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	inttest=	[IA64]
 
+	iomem=		Disable strict checking of access to MMIO memory
+		strict	regions from userspace.
+		relaxed
+
 	iommu=		[x86]
 		off
 		force
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index b646e5b..213f686 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -329,6 +329,8 @@ int devmem_is_allowed(unsigned long pagenr)
 {
 	if (pagenr <= 256)
 		return 1;
+	if (iomem_is_reserved(pagenr << PAGE_SHIFT))
+		return 0;
 	if (!page_is_ram(pagenr))
 		return 1;
 	return 0;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index a624017..1ab8893 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -892,6 +892,8 @@ int devmem_is_allowed(unsigned long pagenr)
 {
 	if (pagenr <= 256)
 		return 1;
+	if (iomem_is_reserved(pagenr << PAGE_SHIFT))
+		return 0;
 	if (!page_is_ram(pagenr))
 		return 1;
 	return 0;
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 77baff0..b28a6d2 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -537,6 +537,9 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 	vma->vm_pgoff += start >> PAGE_SHIFT;
 	mmap_type = res->flags & IORESOURCE_MEM ? pci_mmap_mem : pci_mmap_io;
 
+	if (res->flags & IORESOURCE_MEM && iomem_is_reserved(start))
+		return -EINVAL;
+
 	return pci_mmap_page_range(pdev, vma, mmap_type, write_combine);
 }
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index a9301a2..d61e756 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1333,7 +1333,8 @@ void pci_release_region(struct pci_dev *pdev, int bar)
  *	Returns 0 on success, or %EBUSY on error.  A warning
  *	message is also printed on failure.
  */
-int pci_request_region(struct pci_dev *pdev, int bar, const char *res_name)
+static int __pci_request_region(struct pci_dev *pdev, int bar, const char *res_name, 
+									int relaxed)
 {
 	struct pci_devres *dr;
 
@@ -1346,9 +1347,13 @@ int pci_request_region(struct pci_dev *pdev, int bar, const char *res_name)
 			goto err_out;
 	}
 	else if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM) {
-		if (!request_mem_region(pci_resource_start(pdev, bar),
+		if (!relaxed && !request_mem_region(pci_resource_start(pdev, bar),
 				        pci_resource_len(pdev, bar), res_name))
 			goto err_out;
+		if (relaxed && !request_mem_region_relaxed(
+				pci_resource_start(pdev, bar),
+				pci_resource_len(pdev, bar), res_name))
+			goto err_out;
 	}
 
 	dr = find_pci_dr(pdev);
@@ -1367,6 +1372,47 @@ err_out:
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
+ *	pci_request_region_relaxed - Reserved PCI I/O and memory resource
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
+ *	The key difference that _relaxed makes is that userspace is
+ *	explicitly allowed to map the resource via /dev/mem or
+ * 	sysfs.
+ */
+int pci_request_region_relaxed(struct pci_dev *pdev, int bar, const char *res_name)
+{
+	return __pci_request_region(pdev, bar, res_name, 1);
+}
+/**
  * pci_release_selected_regions - Release selected PCI I/O and memory resources
  * @pdev: PCI device whose resources were previously reserved
  * @bars: Bitmask of BARs to be released
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index e38b6aa..13c8828 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -48,6 +48,7 @@ struct resource_list {
 #define IORESOURCE_SIZEALIGN	0x00020000	/* size indicates alignment */
 #define IORESOURCE_STARTALIGN	0x00040000	/* start field is alignment */
 
+#define IORESOURCE_RELAXED	0x08000000	/* Driver allows userland to map the resource */
 #define IORESOURCE_DISABLED	0x10000000
 #define IORESOURCE_UNSET	0x20000000
 #define IORESOURCE_AUTO		0x40000000
@@ -128,13 +129,14 @@ static inline resource_size_t resource_size(struct resource *res)
 }
 
 /* Convenience shorthand with allocation */
-#define request_region(start,n,name)	__request_region(&ioport_resource, (start), (n), (name))
-#define request_mem_region(start,n,name) __request_region(&iomem_resource, (start), (n), (name))
+#define request_region(start,n,name)	__request_region(&ioport_resource, (start), (n), (name), 0)
+#define request_mem_region(start,n,name) __request_region(&iomem_resource, (start), (n), (name), 0)
+#define request_mem_region_relaxed(start,n,name) __request_region(&iomem_resource, (start), (n), (name), 1)
 #define rename_region(region, newname) do { (region)->name = (newname); } while (0)
 
 extern struct resource * __request_region(struct resource *,
 					resource_size_t start,
-					resource_size_t n, const char *name);
+					resource_size_t n, const char *name, int relaxed);
 
 /* Compatibility cruft */
 #define release_region(start,n)	__release_region(&ioport_resource, (start), (n))
@@ -170,6 +172,7 @@ extern struct resource * __devm_request_region(struct device *dev,
 extern void __devm_release_region(struct device *dev, struct resource *parent,
 				  resource_size_t start, resource_size_t n);
 extern int iomem_map_sanity_check(resource_size_t addr, unsigned long size);
+extern int iomem_is_reserved(u64 addr);
 
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 709b8d4..82c36f5 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -670,6 +670,7 @@ void pci_fixup_irqs(u8 (*)(struct pci_dev *, u8 *),
 int __must_check pci_request_regions(struct pci_dev *, const char *);
 void pci_release_regions(struct pci_dev *);
 int __must_check pci_request_region(struct pci_dev *, int, const char *);
+int __must_check pci_request_region_relaxed(struct pci_dev *, int, const char *);
 void pci_release_region(struct pci_dev *, int);
 int pci_request_selected_regions(struct pci_dev *, int, const char *);
 void pci_release_selected_regions(struct pci_dev *, int);
diff --git a/kernel/resource.c b/kernel/resource.c
index 7797dae..d08fa31 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -622,7 +622,7 @@ resource_size_t resource_alignment(struct resource *res)
  */
 struct resource * __request_region(struct resource *parent,
 				   resource_size_t start, resource_size_t n,
-				   const char *name)
+				   const char *name, int relaxed)
 {
 	struct resource *res = kzalloc(sizeof(*res), GFP_KERNEL);
 
@@ -631,6 +631,8 @@ struct resource * __request_region(struct resource *parent,
 		res->start = start;
 		res->end = start + n - 1;
 		res->flags = IORESOURCE_BUSY;
+		if (relaxed)
+			res->flags |= IORESOURCE_RELAXED;
 
 		write_lock(&resource_lock);
 
@@ -677,7 +679,7 @@ int __check_region(struct resource *parent, resource_size_t start,
 {
 	struct resource * res;
 
-	res = __request_region(parent, start, n, "check-region");
+	res = __request_region(parent, start, n, "check-region", 0);
 	if (!res)
 		return -EBUSY;
 
@@ -774,7 +776,7 @@ struct resource * __devm_request_region(struct device *dev,
 	dr->start = start;
 	dr->n = n;
 
-	res = __request_region(parent, start, n, name);
+	res = __request_region(parent, start, n, name, 0);
 	if (res)
 		devres_add(dev, dr);
 	else
@@ -864,3 +866,56 @@ int iomem_map_sanity_check(resource_size_t addr, unsigned long size)
 
 	return err;
 }
+
+#ifdef CONFIG_STRICT_DEVMEM
+static int strict_iomem_checks = 1;
+#else
+static int strict_iomem_checks = 0;
+#endif
+
+/*
+ * check if an address is reserved in the iomem resource tree
+ * returns 1 if reserved, 0 if not reserved.
+ */
+int iomem_is_reserved(u64 addr)
+{
+	struct resource *p = &iomem_resource;
+	int err = 0;
+	loff_t l;
+	int size= PAGE_SIZE;
+
+	if (!strict_iomem_checks)
+		return 0;
+
+	read_lock(&resource_lock);
+	for (p = p->child; p ; p = r_next(NULL, p, &l)) {
+		/*
+		 * We can probably skip the resources without
+		 * IORESOURCE_IO attribute?
+		 */
+		if (p->start >= addr + size)
+			continue;
+		if (p->end < addr)
+			continue;
+		if (p->flags & IORESOURCE_BUSY &&
+		    !(p->flags & IORESOURCE_RELAXED)) {
+			err = 1;
+			break;
+		}
+	}
+	read_unlock(&resource_lock);
+
+	return err;
+}
+EXPORT_SYMBOL(iomem_is_reserved);
+
+static int __init strict_iomem(char *str)
+{
+	if (strstr(str, "relaxed"))
+		strict_iomem_checks = 0;
+	if (strstr(str, "strict"))
+		strict_iomem_checks = 0;
+	return 1;
+}
+
+__setup("iomem=", strict_iomem);
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
