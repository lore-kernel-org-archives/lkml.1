Return-Path: <linux-kernel-owner+w=401wt.eu-S1763895AbYDPUTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763895AbYDPUTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 16:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbYDPUSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 16:18:53 -0400
Received: from outbound-mail-138.bluehost.com ([67.222.39.28]:53875 "HELO
	outbound-mail-138.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755204AbYDPUSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 16:18:53 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-kernel@vger.kernel.org
Subject: [RFC] PCI resource mapping: don't disable cache & set WT on prefetchable regions
Date: Wed, 16 Apr 2008 13:18:49 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804161318.49150.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 216.239.45.19 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X is using the sysfs PCI resource files by default now, but doesn't have a way 
of specifying that a given resource should be write combined aside from using 
the MTRRs.  Unfortunately, pci_mmap_page_range will always set the WT and CD 
bits in the PTEs constructed for the mapping, so unless X mprotects the 
region, the WC setting it put in the MTRRs will be ignored (the fact that 
mprotect drops these bits is probably a bug).

This patch changes the behavior of pci_mmap_page_range by making it *not* set 
the CD & WT bits if the PCI region in question is prefetchable.

IIRC there was some discussion about this in the past but I don't remember the 
outcome, thus this RFC...

Thanks,
Jesse

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 103b9df..6ce4f5c 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -312,7 +312,7 @@ int pci_mmap_page_range(struct pci_dev *dev, struct 
vm_area_struct *vma,
 	 * address on this platform.
 	 */
 	prot = pgprot_val(vma->vm_page_prot);
-	if (boot_cpu_data.x86 > 3)
+	if (boot_cpu_data.x86 > 3 && !write_combine)
 		prot |= _PAGE_PCD | _PAGE_PWT;
 	vma->vm_page_prot = __pgprot(prot);
 
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 8dcf145..2ba40a9 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -433,7 +433,7 @@ pci_mmap_resource(struct kobject *kobj, struct 
bin_attribute *attr,
 	struct resource *res = (struct resource *)attr->private;
 	enum pci_mmap_state mmap_type;
 	resource_size_t start, end;
-	int i;
+	int i, wc = 0;
 
 	for (i = 0; i < PCI_ROM_RESOURCE; i++)
 		if (res == &pdev->resource[i])
@@ -449,7 +449,14 @@ pci_mmap_resource(struct kobject *kobj, struct 
bin_attribute *attr,
 	vma->vm_pgoff += start >> PAGE_SHIFT;
 	mmap_type = res->flags & IORESOURCE_MEM ? pci_mmap_mem : pci_mmap_io;
 
-	return pci_mmap_page_range(pdev, vma, mmap_type, 0);
+	/*
+	 * Write combine the range if the region is prefetchable (this is
+	 * just a hack, userspace should be using a write combine interface
+	 * explicitly).
+	 */
+	wc = res->flags & IORESOURCE_PREFETCH ? 1 : 0;
+
+	return pci_mmap_page_range(pdev, vma, mmap_type, wc);
 }
 
 /**
