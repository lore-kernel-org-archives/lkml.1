Return-Path: <linux-kernel-owner+w=401wt.eu-S934940AbXLNAGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934940AbXLNAGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933630AbXLNAEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:04:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:58012 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932298AbXLNAEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:04:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,163,1196668800"; 
   d="scan'208";a="340710598"
Message-Id: <20071213235712.813201000@intel.com>
References: <20071213235543.568682000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 13 Dec 2007 15:55:51 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [RFC PATCH 08/12] PAT 64b: coherent mmap and sysfs bin ioctl
Content-Disposition: inline; filename=sysfs-bin-ioctl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forward port of coherent-mmap.patch and sysfs-bin-ioctl.patch to x86 tree.

TBD: Do we need the ioctl interface to sysfs or get the type attribute
through a different sysfs file. And then actually specify the attribute
while doing pci_mmap_page_range ;-)

And when this interface is in place, X server has to use this interface for WC
mapping.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: linux-2.6.24-rc4/fs/sysfs/bin.c
===================================================================
--- linux-2.6.24-rc4.orig/fs/sysfs/bin.c	2007-12-11 16:23:26.000000000 -0800
+++ linux-2.6.24-rc4/fs/sysfs/bin.c	2007-12-11 16:32:01.000000000 -0800
@@ -221,6 +221,19 @@
 	return 0;
 }
 
+static int ioctl(struct inode *i, struct file *f, unsigned cmd,
+		 unsigned long arg)
+{
+	struct sysfs_dirent *attr_sd = f->f_path.dentry->d_fsdata;
+	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
+
+	if (!attr->ioctl)
+		return -EINVAL;
+
+	return attr->ioctl(kobj, attr, cmd, arg);
+}
+
 const struct file_operations bin_fops = {
 	.read		= read,
 	.write		= write,
@@ -228,6 +241,7 @@
 	.llseek		= generic_file_llseek,
 	.open		= open,
 	.release	= release,
+	.ioctl		= ioctl,
 };
 
 /**
Index: linux-2.6.24-rc4/include/linux/sysfs.h
===================================================================
--- linux-2.6.24-rc4.orig/include/linux/sysfs.h	2007-12-11 16:23:26.000000000 -0800
+++ linux-2.6.24-rc4/include/linux/sysfs.h	2007-12-11 16:29:07.000000000 -0800
@@ -69,6 +69,8 @@
 			 char *, loff_t, size_t);
 	int (*mmap)(struct kobject *, struct bin_attribute *attr,
 		    struct vm_area_struct *vma);
+	int (*ioctl)(struct kobject *, struct bin_attribute *attr,
+			unsigned cmd, unsigned long arg);
 };
 
 struct sysfs_ops {
Index: linux-2.6.24-rc4/drivers/pci/pci-sysfs.c
===================================================================
--- linux-2.6.24-rc4.orig/drivers/pci/pci-sysfs.c	2007-12-11 16:03:55.000000000 -0800
+++ linux-2.6.24-rc4/drivers/pci/pci-sysfs.c	2007-12-11 16:29:07.000000000 -0800
@@ -473,8 +473,56 @@
 			kfree(res_attr);
 		}
 	}
+
+#ifdef HAVE_PCI_COHERENT_MMAP
+	sysfs_remove_bin_file(&pdev->dev.kobj, pdev->coherent_attr);
+	kfree(pdev->coherent_attr);
+#endif
+}
+
+#ifdef HAVE_PCI_COHERENT_MMAP
+
+struct coh_mmap_data {
+	void *map;
+	struct device *dev;
+	dma_addr_t busadr;
+};
+
+void pci_coherent_mmap_close(struct vm_area_struct *vma)
+{
+	struct coh_mmap_data *cm = vma->vm_private_data;
+	dma_free_coherent(cm->dev, vma->vm_end - vma->vm_start, cm->map,
+			  cm->busadr);
 }
 
+static struct vm_operations_struct pci_coherent_vmops = {
+	.close = pci_coherent_mmap_close,
+};
+
+static int
+pci_mmap_coherent_mem(struct kobject *kobj, struct bin_attribute *attr,
+		  struct vm_area_struct *vma)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct coh_mmap_data *cm = kmalloc(sizeof(struct coh_mmap_data),
+					   GFP_KERNEL);
+	if (!cm)
+		return -ENOMEM;
+	cm->map = dma_alloc_coherent(dev, vma->vm_end - vma->vm_start,
+				     &cm->busadr, GFP_KERNEL);
+	cm->dev = dev;
+	if (!cm->map) {
+		kfree(cm->map);
+		return -ENOMEM;
+	}
+	vma->vm_private_data = cm;
+	vma->vm_pgoff = cm->busadr >> PAGE_SHIFT;
+	vma->vm_ops = &pci_coherent_vmops;
+	return pci_mmap_page_range(pdev, vma, pci_mmap_coherent, 0);
+}
+#endif
+
 /**
  * pci_create_resource_files - create resource files in sysfs for @dev
  * @dev: dev in question
@@ -692,6 +740,22 @@
 			kfree(pdev->rom_attr);
 		}
 	}
+#ifdef HAVE_PCI_COHERENT_MMAP
+	{
+		struct bin_attribute *a = kzalloc(sizeof(struct bin_attribute),
+						  GFP_KERNEL);
+		if (!a)
+			return;
+		pdev->coherent_attr = a;
+		a->attr.name = "coherent_mem";
+		a->attr.mode = S_IRUSR | S_IWUSR;
+		a->attr.owner = THIS_MODULE;
+		a->size = *(pdev->dev.dma_mask);
+		a->mmap = pci_mmap_coherent_mem;
+		a->private = NULL;
+		sysfs_create_bin_file(&pdev->dev.kobj, a);
+	}
+#endif
 }
 
 static int __init pci_sysfs_init(void)
Index: linux-2.6.24-rc4/include/asm-x86/pci.h
===================================================================
--- linux-2.6.24-rc4.orig/include/asm-x86/pci.h	2007-12-11 16:03:55.000000000 -0800
+++ linux-2.6.24-rc4/include/asm-x86/pci.h	2007-12-11 16:29:07.000000000 -0800
@@ -61,6 +61,7 @@
 
 
 #define HAVE_PCI_MMAP
+#define HAVE_PCI_COHERENT_MMAP
 extern int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 			       enum pci_mmap_state mmap_state, int write_combine);
 
Index: linux-2.6.24-rc4/include/linux/pci.h
===================================================================
--- linux-2.6.24-rc4.orig/include/linux/pci.h	2007-12-11 16:03:55.000000000 -0800
+++ linux-2.6.24-rc4/include/linux/pci.h	2007-12-11 16:29:07.000000000 -0800
@@ -57,7 +57,8 @@
 /* File state for mmap()s on /proc/bus/pci/X/Y */
 enum pci_mmap_state {
 	pci_mmap_io,
-	pci_mmap_mem
+	pci_mmap_mem,
+	pci_mmap_coherent
 };
 
 /* This defines the direction arg to the DMA mapping routines. */
@@ -201,6 +202,7 @@
 	struct bin_attribute *rom_attr; /* attribute descriptor for sysfs ROM entry */
 	int rom_attr_enabled;		/* has display of the rom attribute been enabled? */
 	struct bin_attribute *res_attr[DEVICE_COUNT_RESOURCE]; /* sysfs file for resources */
+	struct bin_attribute *coherent_attr;
 #ifdef CONFIG_PCI_MSI
 	struct list_head msi_list;
 #endif

-- 
