Return-Path: <linux-kernel-owner+w=401wt.eu-S1757610AbYFLUeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbYFLUeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 16:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbYFLUeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 16:34:07 -0400
Received: from outbound-mail-16.bluehost.com ([69.89.20.231]:39750 "HELO
	outbound-mail-16.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754096AbYFLUeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 16:34:05 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-pci@vger.kernel.org
Subject: [PATCH] final PCI patches for 2.6.26
Date: Thu, 12 Jun 2008 13:34:01 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806121334.01562.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of these may not have seen review on linux-pci, so I'm sending them out
for comment before I send Linus the pull request.

Any comments/objections?

The biggest patch by far is the resource_wc stuff; it should have been pushed
earlier, but for some reason I thought Ingo & co. were going to do that...

Thanks,
Jesse

commit a123c3d9643464c56417680536ed9515f15cffa1
Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
Date:   Mon May 12 21:21:05 2008 +0200

    PCI: use dev_to_node in pci_call_probe
    
    to make sure get one online node.
    
    Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

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

commit d99f75679d17ada3e90a04c50605f90a6a590e45
Author: Miquel van Smoorenburg <mikevs@xs4all.net>
Date:   Thu Jun 5 18:14:44 2008 +0200

    x86/PCI: pci-dma.c: don't always add __GFP_NORETRY to gfp
    
    Currently arch/x86/kernel/pci-dma.c always adds __GFP_NORETRY
    to the allocation flags, because it wants to be reasonably
    sure not to deadlock when calling alloc_pages().
    
    But really that should only be done in two cases:
    - when allocating memory in the lower 16 MB DMA zone.
      If there's no free memory there, waiting or OOM killing is of no use
    - when optimistically trying an allocation in the DMA32 zone
      when dma_mask < DMA_32BIT_MASK hoping that the allocation
      happens to fall within the limits of the dma_mask
    
    Also blindly adding __GFP_NORETRY to the the gfp variable might
    not be a good idea since we then also use it when calling
    dma_ops->alloc_coherent(). Clearing it might also not be a
    good idea, dma_alloc_coherent()'s caller might have set it
    on purpose. The gfp variable should not be clobbered.
    
    [ mingo@elte.hu: converted to delta patch ontop of previous version. ]
    
    Signed-off-by: Miquel van Smoorenburg <miquels@cistron.nl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 069e843..dc00a13 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -378,6 +378,7 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	struct page *page;
 	unsigned long dma_mask = 0;
 	dma_addr_t bus;
+	int noretry = 0;
 
 	/* ignore region specifiers */
 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
@@ -397,19 +398,25 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	if (dev->dma_mask == NULL)
 		return NULL;
 
+	/* Don't invoke OOM killer or retry in lower 16MB DMA zone */
+	if (gfp & __GFP_DMA)
+		noretry = 1;
+
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
-	/* Don't invoke OOM killer or retry in lower 16MB DMA zone */
 	page = dma_alloc_pages(dev,
-		(gfp & GFP_DMA) ? gfp | __GFP_NORETRY : gfp, get_order(size));
+		noretry ? gfp | __GFP_NORETRY : gfp, get_order(size));
 	if (page == NULL)
 		return NULL;
 

commit 7a7d16722262b50fb8433d1340153bceabf84af2
Author: Miquel van Smoorenburg <mikevs@xs4all.net>
Date:   Wed May 28 10:31:25 2008 +0200

    x86/PCI: pci-dma.c: use __GFP_NO_OOM instead of __GFP_NORETRY
    
    On Wed, 2008-05-28 at 04:47 +0200, Andi Kleen wrote:
    > > So...  why not just remove the setting of __GFP_NORETRY?  Why is it
    > > wrong to oom-kill things in this case?
    >
    > When the 16MB zone overflows (which can be common in some workloads)
    > calling the OOM killer is pretty useless because it has barely any
    > real user data [only exception would be the "only 16MB" case Alan
    > mentioned]. Killing random processes in this case is bad.
    >
    > I think for 16MB __GFP_NORETRY is ok because there should be
    > nothing freeable in there so looping is useless. Only exception would be the
    > "only 16MB total" case again but I'm not sure 2.6 supports that at all
    > on x86.
    >
    > On the other hand d_a_c() does more allocations than just 16MB, especially
    > on 64bit and the other zones need different strategies.
    
    Okay, so how about this then ?
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index c5ef1af..069e843 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -397,9 +397,6 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	if (dev->dma_mask == NULL)
 		return NULL;
 
-	/* Don't invoke OOM killer */
-	gfp |= __GFP_NORETRY;
-
 #ifdef CONFIG_X86_64
 	/* Why <=? Even when the mask is smaller than 4GB it is often
 	   larger than 16MB and in this case we have a chance of
@@ -410,7 +407,9 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 #endif
 
  again:
-	page = dma_alloc_pages(dev, gfp, get_order(size));
+	/* Don't invoke OOM killer or retry in lower 16MB DMA zone */
+	page = dma_alloc_pages(dev,
+		(gfp & GFP_DMA) ? gfp | __GFP_NORETRY : gfp, get_order(size));
 	if (page == NULL)
 		return NULL;
 

commit db80e22298e1c774d7d59ee7ba622abd6248f8a5
Author: Jesse Barnes <jbarnes@hobbes.lan>
Date:   Thu Jun 12 12:39:32 2008 -0700

    PCI: fixup write combine comment in pci_mmap_resource
    
    Now that we can actually do write combining properly, there's no need to have
    the FIXME.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 9ec7d39..6f3c744 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -492,7 +492,6 @@ pci_mmap_legacy_mem(struct kobject *kobj, struct bin_attribute *attr,
  * @write_combine: 1 for write_combine mapping
  *
  * Use the regular PCI mapping routines to map a PCI resource into userspace.
- * FIXME: write combining?  maybe automatic for prefetchable regions?
  */
 static int
 pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,

commit 3361cb322a7aee901b7cb478c3bec65b8f2e7695
Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
Date:   Tue Mar 18 17:00:22 2008 -0700

    x86: PAT export resource_wc in pci sysfs
    
    For the ranges with IORESOURCE_PREFETCH, export a new resource_wc interface in
    pci /sysfs along with resource (which is uncached).
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

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
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 271d41c..9ec7d39 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -489,13 +489,14 @@ pci_mmap_legacy_mem(struct kobject *kobj, struct bin_attribute *attr,
  * @kobj: kobject for mapping
  * @attr: struct bin_attribute for the file being mapped
  * @vma: struct vm_area_struct passed into the mmap
+ * @write_combine: 1 for write_combine mapping
  *
  * Use the regular PCI mapping routines to map a PCI resource into userspace.
  * FIXME: write combining?  maybe automatic for prefetchable regions?
  */
 static int
 pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
-		  struct vm_area_struct *vma)
+		  struct vm_area_struct *vma, int write_combine)
 {
 	struct pci_dev *pdev = to_pci_dev(container_of(kobj,
 						       struct device, kobj));
@@ -518,7 +519,21 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
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
@@ -541,9 +556,46 @@ pci_remove_resource_files(struct pci_dev *pdev)
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
@@ -557,31 +609,19 @@ static int pci_create_resource_files(struct pci_dev *pdev)
 
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
+	struct bin_attribute *res_attr_wc[DEVICE_COUNT_RESOURCE]; /* sysfs file for WC mapping of 
resources */
 #ifdef CONFIG_PCI_MSI
 	struct list_head msi_list;
 #endif
