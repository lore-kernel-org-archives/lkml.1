Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYJBXaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYJBXaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbYJBXaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:30:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753061AbYJBXa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:30:28 -0400
Date: Thu, 2 Oct 2008 16:30:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] check mapped ranges on sysfs resource files (for
 2.6.27)
In-Reply-To: <200810021534.38219.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LFD.2.00.0810021630100.3341@nehalem.linux-foundation.org>
References: <200810021534.38219.jbarnes@virtuousgeek.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 Oct 2008, Jesse Barnes wrote:
>
> +	unsigned long map_len = vma->vm_end - vma->vm_start;
> +	unsigned long map_offset = vma->vm_pgoff << PAGE_SHIFT;

This seems broken for big vm_pgoff values, where that shift will 
potentially overflow, no? 

Also, it strikes me that we don't seem to check that the resource start is 
page-aligned. We just do

	vma->vm_pgoff += start >> PAGE_SHIFT;

without checking if we just dropped low bits from 'start'.

Of course, if the length of the resource is bigger than a page, I guess 
the resource is guaranteed to be at least page-aligned, so maybe the 
length check - if it was correct - would be sufficient.

Anyway, it would be *much* better to do the length check in pages rather 
than in bytes, to avoid the overflow condition.

Can somebody test if something like this works? It also prints the actual 
name of the device, not just a random BAR number (but it will print 
everyting in PFN's, I hate potentially losing information).

			Linus

---
 drivers/pci/pci-sysfs.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 9c71858..77baff0 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -16,6 +16,7 @@
 
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/stat.h>
 #include <linux/topology.h>
@@ -484,6 +485,21 @@ pci_mmap_legacy_mem(struct kobject *kobj, struct bin_attribute *attr,
 #endif /* HAVE_PCI_LEGACY */
 
 #ifdef HAVE_PCI_MMAP
+
+static int pci_mmap_fits(struct pci_dev *pdev, int resno, struct vm_area_struct *vma)
+{
+	unsigned long nr, start, size;
+
+	nr = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+	start = vma->vm_pgoff;
+	size = pci_resource_len(pdev, resno) >> PAGE_SHIFT;
+	if (start < size && size - start >= nr)
+		return 1;
+	WARN(1, "process \"%s\" tried to map 0x%08lx-0x%08lx on %s BAR %d (size 0x%08lx)\n",
+		current->comm, start, start+nr, pci_name(pdev), resno, size);
+	return 0;
+}
+
 /**
  * pci_mmap_resource - map a PCI resource into user memory space
  * @kobj: kobject for mapping
@@ -510,6 +526,9 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 	if (i >= PCI_ROM_RESOURCE)
 		return -ENODEV;
 
+	if (!pci_mmap_fits(pdev, i, vma))
+		return -EINVAL;
+
 	/* pci_mmap_page_range() expects the same kind of entry as coming
 	 * from /proc/bus/pci/ which is a "user visible" value. If this is
 	 * different from the resource itself, arch will do necessary fixup.
