Return-Path: <linux-kernel-owner+w=401wt.eu-S1761512AbYD2Kiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761512AbYD2Kiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756593AbYD2KiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:38:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40632 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322AbYD2KiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:38:04 -0400
Date: Tue, 29 Apr 2008 12:37:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Gabriel C <nix.or.die@googlemail.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Mika Fischer <mika.fischer@zoopnet.de>, balajirrao@gmail.com,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
Message-ID: <20080429103741.GL23198@elte.hu>
References: <200801192045.17291.yinghai.lu@sun.com> <48159ECF.9020004@googlemail.com> <20080428135351.GF3973@elte.hu> <200804280909.06561.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804280909.06561.jesse.barnes@intel.com>
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


* Jesse Barnes <jesse.barnes@intel.com> wrote:

> > i think we should still try to make this a non-default option 
> > because modern Xorg should not have any need to touch MTRRs. Perhaps 
> > a .config dependent on CONFIG_DANGEROUS ;-)
> 
> Well, not quite... we're still waiting on some way of getting WC 
> semantics for sysfs PCI files.  Suresh tells me something like that is 
> queued up, but until that hits the mainline X will still need to bang 
> the MTRRs to get decent performance.

yes, the patch below is queued up for an eventual v2.6.26 merge. If it 
looks fine to you, could you please ack it so that we can send it to 
Linus? I'd like to do this after some pending PAT fixes are upstream.

	Ingo

---------------->
Subject: x86, PAT: export resource_wc in pci sysfs
From: venkatesh.pallipadi@intel.com
Date: Tue, 18 Mar 2008 17:00:22 -0700

For the ranges with IORESOURCE_PREFETCH, export a new resource_wc interface in
pci /sysfs along with resource (which is uncached).

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/filesystems/sysfs-pci.txt |    1 
 drivers/pci/pci-sysfs.c                 |   82 +++++++++++++++++++++++---------
 include/linux/pci.h                     |    1 
 3 files changed, 63 insertions(+), 21 deletions(-)

Index: linux-x86.q/Documentation/filesystems/sysfs-pci.txt
===================================================================
--- linux-x86.q.orig/Documentation/filesystems/sysfs-pci.txt
+++ linux-x86.q/Documentation/filesystems/sysfs-pci.txt
@@ -36,6 +36,7 @@ files, each with their own function.
        local_cpus	   nearby CPU mask (cpumask, ro)
        resource		   PCI resource host addresses (ascii, ro)
        resource0..N	   PCI resource N, if present (binary, mmap)
+       resource0_wc..N_wc  PCI WC map resource N, if prefetchable (binary, mmap)
        rom		   PCI ROM resource, if present (binary, ro)
        subsystem_device	   PCI subsystem device (ascii, ro)
        subsystem_vendor	   PCI subsystem vendor (ascii, ro)
Index: linux-x86.q/drivers/pci/pci-sysfs.c
===================================================================
--- linux-x86.q.orig/drivers/pci/pci-sysfs.c
+++ linux-x86.q/drivers/pci/pci-sysfs.c
@@ -489,13 +489,14 @@ pci_mmap_legacy_mem(struct kobject *kobj
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
@@ -518,7 +519,21 @@ pci_mmap_resource(struct kobject *kobj, 
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
@@ -541,9 +556,46 @@ pci_remove_resource_files(struct pci_dev
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
@@ -557,31 +609,19 @@ static int pci_create_resource_files(str
 
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
+		retval = pci_create_attr(pdev, i, 0);
+		/* for prefetchable resources, create a WC mappable file */
+		if (!retval && pdev->resource[i].flags & IORESOURCE_PREFETCH)
+			retval = pci_create_attr(pdev, i, 1);
 
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
+		if (retval) {
+			pci_remove_resource_files(pdev);
+			return retval;
 		}
 	}
 	return 0;
Index: linux-x86.q/include/linux/pci.h
===================================================================
--- linux-x86.q.orig/include/linux/pci.h
+++ linux-x86.q/include/linux/pci.h
@@ -205,6 +205,7 @@ struct pci_dev {
 	struct bin_attribute *rom_attr; /* attribute descriptor for sysfs ROM entry */
 	int rom_attr_enabled;		/* has display of the rom attribute been enabled? */
 	struct bin_attribute *res_attr[DEVICE_COUNT_RESOURCE]; /* sysfs file for resources */
+	struct bin_attribute *res_attr_wc[DEVICE_COUNT_RESOURCE]; /* sysfs file for WC mapping of resources */
 #ifdef CONFIG_PCI_MSI
 	struct list_head msi_list;
 #endif
