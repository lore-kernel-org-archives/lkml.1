Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbYFNUYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbYFNUYV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 16:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbYFNUYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 16:24:05 -0400
Received: from outbound-mail-103.bluehost.com ([69.89.22.13]:53470 "HELO
	outbound-mail-103.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754114AbYFNUYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 16:24:03 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [git pull] PCI fixes
Date: Sat, 14 Jun 2008 13:23:45 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_RjCVIziPe7Cdr/2"
Message-Id: <200806141323.45935.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 70.41.218.21 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_RjCVIziPe7Cdr/2
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Please pull the final (I hope!) fixes for 2.6.26:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

It's mainly a set of fixes I got from Ingo which have been soaking for
awhile, including the resourceN_wc API, which should have been pushed
upstream before now, but which has seen a lot of exposure in Ingo's
tree.  Shortlog, diffstat & diff below.

Note that to take advantage of the new resourceN_wc file in X you'll need
something like the patch I just posted to xorg@lists.freedesktop.org.

Also, since I pulled the changes from Ingo, there are two duplicates (Bertram
& Tony's patches) and a merge commit; hopefully they won't cause trouble.

Thanks,
Jesse

Bertram Felgenhauer (1):
      pci, x86: add workaround for bug in ASUS A7V600 BIOS (rev 1005)

Jesse Barnes (2):
      Merge branch 'pci-for-jesse' of git://git.kernel.org/.../x86/linux-2.6-tip into for-linus
      PCI: fixup write combine comment in pci_mmap_resource

Miquel van Smoorenburg (2):
      x86: pci-dma.c: use __GFP_NO_OOM instead of __GFP_NORETRY
      x86, pci-dma.c: don't always add __GFP_NORETRY to gfp

Pavel Machek (1):
      suspend-vs-iommu: prevent suspend if we could not resume

Tony Camuso (1):
      PCI: Correct last two HP entries in the bfsort whitelist

Yinghai Lu (1):
      PCI: use dev_to_node in pci_call_probe

venkatesh.pallipadi@intel.com (1):
      x86: PAT export resource_wc in pci sysfs

 Documentation/filesystems/sysfs-pci.txt |    1 
 arch/x86/kernel/pci-dma.c               |   14 +++--
 arch/x86/pci/common.c                   |    8 +--
 drivers/pci/pci-driver.c                |    2 
 drivers/pci/pci-sysfs.c                 |   85 +++++++++++++++++++++++---------
 include/linux/pci.h                     |    1 
 6 files changed, 79 insertions(+), 32 deletions(-)


--Boundary-00=_RjCVIziPe7Cdr/2
Content-Type: text/plain;
  charset="us-ascii";
  name="diff.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="diff.txt"

diff --git a/Documentation/filesystems/sysfs-pci.txt b/Documentation/filesystems/sysfs-pci.txt
index 5daa2aa..68ef488 100644
--- a/Documentation/filesystems/sysfs-pci.txt
+++ b/Documentation/filesystems/sysfs-pci.txt
@@ -36,6 +36,7 @@ files, each with their own function.
        local_cpus	   nearby CPU mask (cpumask, ro)
        resource		   PCI resource host addresses (ascii, ro)
        resource0..N	   PCI resource N, if present (binary, mmap)
+       resource0_wc..N_wc  PCI WC map resource N, if prefetchable (binary, mmap)
        rom		   PCI ROM resource, if present (binary, ro)
        subsystem_device	   PCI subsystem device (ascii, ro)
        subsystem_vendor	   PCI subsystem vendor (ascii, ro)
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index c5ef1af..dc00a13 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -378,6 +378,7 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	struct page *page;
 	unsigned long dma_mask = 0;
 	dma_addr_t bus;
+	int noretry = 0;
 
 	/* ignore region specifiers */
 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
@@ -397,20 +398,25 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	if (dev->dma_mask == NULL)
 		return NULL;
 
-	/* Don't invoke OOM killer */
-	gfp |= __GFP_NORETRY;
+	/* Don't invoke OOM killer or retry in lower 16MB DMA zone */
+	if (gfp & __GFP_DMA)
+		noretry = 1;
 
 #ifdef CONFIG_X86_64
 	/* Why <=? Even when the mask is smaller than 4GB it is often
 	   larger than 16MB and in this case we have a chance of
 	   finding fitting memory in the next higher zone first. If
 	   not retry with true GFP_DMA. -AK */
-	if (dma_mask <= DMA_32BIT_MASK && !(gfp & GFP_DMA))
+	if (dma_mask <= DMA_32BIT_MASK && !(gfp & GFP_DMA)) {
 		gfp |= GFP_DMA32;
+		if (dma_mask < DMA_32BIT_MASK)
+			noretry = 1;
+	}
 #endif
 
  again:
-	page = dma_alloc_pages(dev, gfp, get_order(size));
+	page = dma_alloc_pages(dev,
+		noretry ? gfp | __GFP_NORETRY : gfp, get_order(size));
 	if (page == NULL)
 		return NULL;
 
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 6e64aaf..940185e 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -328,18 +328,18 @@ static struct dmi_system_id __devinitdata pciprobe_dmi_table[] = {
 #endif
 	{
 		.callback = set_bf_sort,
-		.ident = "HP ProLiant DL385 G2",
+		.ident = "HP ProLiant DL360",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL385 G2"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL360"),
 		},
 	},
 	{
 		.callback = set_bf_sort,
-		.ident = "HP ProLiant DL585 G2",
+		.ident = "HP ProLiant DL380",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL585 G2"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL380"),
 		},
 	},
 	{}
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 72cf61e..e1637bd 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -181,7 +181,7 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
 	   any need to change it. */
 	struct mempolicy *oldpol;
 	cpumask_t oldmask = current->cpus_allowed;
-	int node = pcibus_to_node(dev->bus);
+	int node = dev_to_node(&dev->dev);
 
 	if (node >= 0) {
 		node_to_cpumask_ptr(nodecpumask, node);
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 271d41c..6f3c744 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -489,13 +489,13 @@ pci_mmap_legacy_mem(struct kobject *kobj, struct bin_attribute *attr,
  * @kobj: kobject for mapping
  * @attr: struct bin_attribute for the file being mapped
  * @vma: struct vm_area_struct passed into the mmap
+ * @write_combine: 1 for write_combine mapping
  *
  * Use the regular PCI mapping routines to map a PCI resource into userspace.
- * FIXME: write combining?  maybe automatic for prefetchable regions?
  */
 static int
 pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
-		  struct vm_area_struct *vma)
+		  struct vm_area_struct *vma, int write_combine)
 {
 	struct pci_dev *pdev = to_pci_dev(container_of(kobj,
 						       struct device, kobj));
@@ -518,7 +518,21 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 	vma->vm_pgoff += start >> PAGE_SHIFT;
 	mmap_type = res->flags & IORESOURCE_MEM ? pci_mmap_mem : pci_mmap_io;
 
-	return pci_mmap_page_range(pdev, vma, mmap_type, 0);
+	return pci_mmap_page_range(pdev, vma, mmap_type, write_combine);
+}
+
+static int
+pci_mmap_resource_uc(struct kobject *kobj, struct bin_attribute *attr,
+		     struct vm_area_struct *vma)
+{
+	return pci_mmap_resource(kobj, attr, vma, 0);
+}
+
+static int
+pci_mmap_resource_wc(struct kobject *kobj, struct bin_attribute *attr,
+		     struct vm_area_struct *vma)
+{
+	return pci_mmap_resource(kobj, attr, vma, 1);
 }
 
 /**
@@ -541,9 +555,46 @@ pci_remove_resource_files(struct pci_dev *pdev)
 			sysfs_remove_bin_file(&pdev->dev.kobj, res_attr);
 			kfree(res_attr);
 		}
+
+		res_attr = pdev->res_attr_wc[i];
+		if (res_attr) {
+			sysfs_remove_bin_file(&pdev->dev.kobj, res_attr);
+			kfree(res_attr);
+		}
 	}
 }
 
+static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
+{
+	/* allocate attribute structure, piggyback attribute name */
+	int name_len = write_combine ? 13 : 10;
+	struct bin_attribute *res_attr;
+	int retval;
+
+	res_attr = kzalloc(sizeof(*res_attr) + name_len, GFP_ATOMIC);
+	if (res_attr) {
+		char *res_attr_name = (char *)(res_attr + 1);
+
+		if (write_combine) {
+			pdev->res_attr_wc[num] = res_attr;
+			sprintf(res_attr_name, "resource%d_wc", num);
+			res_attr->mmap = pci_mmap_resource_wc;
+		} else {
+			pdev->res_attr[num] = res_attr;
+			sprintf(res_attr_name, "resource%d", num);
+			res_attr->mmap = pci_mmap_resource_uc;
+		}
+		res_attr->attr.name = res_attr_name;
+		res_attr->attr.mode = S_IRUSR | S_IWUSR;
+		res_attr->size = pci_resource_len(pdev, num);
+		res_attr->private = &pdev->resource[num];
+		retval = sysfs_create_bin_file(&pdev->dev.kobj, res_attr);
+	} else
+		retval = -ENOMEM;
+
+	return retval;
+}
+
 /**
  * pci_create_resource_files - create resource files in sysfs for @dev
  * @dev: dev in question
@@ -557,31 +608,19 @@ static int pci_create_resource_files(struct pci_dev *pdev)
 
 	/* Expose the PCI resources from this device as files */
 	for (i = 0; i < PCI_ROM_RESOURCE; i++) {
-		struct bin_attribute *res_attr;
 
 		/* skip empty resources */
 		if (!pci_resource_len(pdev, i))
 			continue;
 
-		/* allocate attribute structure, piggyback attribute name */
-		res_attr = kzalloc(sizeof(*res_attr) + 10, GFP_ATOMIC);
-		if (res_attr) {
-			char *res_attr_name = (char *)(res_attr + 1);
-
-			pdev->res_attr[i] = res_attr;
-			sprintf(res_attr_name, "resource%d", i);
-			res_attr->attr.name = res_attr_name;
-			res_attr->attr.mode = S_IRUSR | S_IWUSR;
-			res_attr->size = pci_resource_len(pdev, i);
-			res_attr->mmap = pci_mmap_resource;
-			res_attr->private = &pdev->resource[i];
-			retval = sysfs_create_bin_file(&pdev->dev.kobj, res_attr);
-			if (retval) {
-				pci_remove_resource_files(pdev);
-				return retval;
-			}
-		} else {
-			return -ENOMEM;
+		retval = pci_create_attr(pdev, i, 0);
+		/* for prefetchable resources, create a WC mappable file */
+		if (!retval && pdev->resource[i].flags & IORESOURCE_PREFETCH)
+			retval = pci_create_attr(pdev, i, 1);
+
+		if (retval) {
+			pci_remove_resource_files(pdev);
+			return retval;
 		}
 	}
 	return 0;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 509159b..d18b1dd 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -206,6 +206,7 @@ struct pci_dev {
 	struct bin_attribute *rom_attr; /* attribute descriptor for sysfs ROM entry */
 	int rom_attr_enabled;		/* has display of the rom attribute been enabled? */
 	struct bin_attribute *res_attr[DEVICE_COUNT_RESOURCE]; /* sysfs file for resources */
+	struct bin_attribute *res_attr_wc[DEVICE_COUNT_RESOURCE]; /* sysfs file for WC mapping of resources */
 #ifdef CONFIG_PCI_MSI
 	struct list_head msi_list;
 #endif

--Boundary-00=_RjCVIziPe7Cdr/2--
