Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbZJUUBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbZJUUBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 16:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbZJUUBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 16:01:35 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:55225 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZJUUBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 16:01:34 -0400
From: Thomas Schlichter <thomas.schlichter@web.de>
To: Ingo Molnar <mingo@elte.hu>, Jan Beulich <JBeulich@novell.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not available
Date: Wed, 21 Oct 2009 22:01:36 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.28.10-bigboss; KDE/4.3.2; i686; ; )
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Robert Hancock <hancockrwd@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Tejun Heo <tj@kernel.org>, x86@kernel.org,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       dri-devel@lists.sourceforge.net, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       Thomas Hellstrom <thellstrom@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <1394846127@web.de> <4ADF32A0020000780001B20A@vpn.id2.novell.com> <20091021173514.GA32227@elte.hu>
In-Reply-To: <20091021173514.GA32227@elte.hu>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_gi23KkNb/H9fV0U"
Message-Id: <200910212201.36578.thomas.schlichter@web.de>
X-Provags-ID: V01U2FsdGVkX1+gsAiO358mFbPyTh0x+yBbNYTZKGfgTAWAB7zI
	iP0EOLXvc5yS+iVhJ924PlUQBDqn6i+jaoXOz/uLYeIRWHONnk
	Mjswoxjj8XuwfOwSUJeg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_gi23KkNb/H9fV0U
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Ingo Molnar wrote:
> * Jan Beulich <JBeulich@novell.com> wrote:
> > I'm perfectly fine with just handling the aligned case, as long as the
> > code checks that the alignment constraints are met.
> 
> It could even emit a debug warning if they are not met - that way we'll
> see how important the unaligned case is.

OK, so I think the attached patches should do it. Hopefully I have addressed 
all your comments.

This series works for my test machine, without it, or without X running, I 
have these MTRR entries:
reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg01: base=0x06ff00000 ( 1791MB), size=    1MB, count=1: uncachable
reg02: base=0x070000000 ( 1792MB), size=  256MB, count=1: uncachable

With the patches applied and X running I get these:
reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg01: base=0x06ff00000 ( 1791MB), size=    1MB, count=1: uncachable
reg02: base=0x070000000 ( 1792MB), size=  256MB, count=1: uncachable
reg03: base=0x0d0000000 ( 3328MB), size=  256MB, count=1: write-combining

Best regards,
  Thomas

--Boundary-00=_gi23KkNb/H9fV0U
Content-Type: text/x-patch;
  charset="iso-8859-1";
  name="0001-Make-num_var_ranges-accessible-outside-MTRR-code.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="0001-Make-num_var_ranges-accessible-outside-MTRR-code.patch"

>From e946206915e3b023eb331499d73014105429200c Mon Sep 17 00:00:00 2001
From: Thomas Schlichter <thomas.schlichter@web.de>
Date: Sat, 17 Oct 2009 12:36:05 +0200
Subject: [PATCH 1/3] Make num_var_ranges accessible outside MTRR code

Code outside MTRR will have to remember which MTRR entries are used for a
given purpose. Therefore it has to access num_var_ranges which holds the
value of the maximum count of MTRR entries available. So we make this value
accessible from outside the core MTRR code.

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
---
 arch/x86/include/asm/mtrr.h     |    2 ++
 arch/x86/kernel/cpu/mtrr/mtrr.h |    1 -
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
index 4365ffd..1e7a824 100644
--- a/arch/x86/include/asm/mtrr.h
+++ b/arch/x86/include/asm/mtrr.h
@@ -72,6 +72,8 @@ typedef __u8 mtrr_type;
 #define MTRR_NUM_FIXED_RANGES 88
 #define MTRR_MAX_VAR_RANGES 256
 
+extern unsigned int num_var_ranges;
+
 struct mtrr_state_type {
 	struct mtrr_var_range var_ranges[MTRR_MAX_VAR_RANGES];
 	mtrr_type fixed_ranges[MTRR_NUM_FIXED_RANGES];
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index a501dee..ba6a8a5 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -61,7 +61,6 @@ extern struct mtrr_ops *mtrr_if;
 #define is_cpu(vnd)	(mtrr_if && mtrr_if->vendor == X86_VENDOR_##vnd)
 #define use_intel()	(mtrr_if && mtrr_if->use_intel_if == 1)
 
-extern unsigned int num_var_ranges;
 extern u64 mtrr_tom2;
 extern struct mtrr_state_type mtrr_state;
 
-- 
1.6.5.1


--Boundary-00=_gi23KkNb/H9fV0U
Content-Type: text/x-patch;
  charset="iso-8859-1";
  name="0002-Provide-per-file-private-data-for-bin-sysfs-files.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="0002-Provide-per-file-private-data-for-bin-sysfs-files.patch"

>From 7210888ded750f87f5509bdd5b95363a476ce307 Mon Sep 17 00:00:00 2001
From: Thomas Schlichter <thomas.schlichter@web.de>
Date: Sat, 17 Oct 2009 12:39:11 +0200
Subject: [PATCH 2/3] Provide per-file private data for bin sysfs files

For binary sysfs files, provide a per-file private field in struct bin_buffer.
To be easily accessible, it is located on head of the struct. Additionally add
a release() callback that may be used to e.g. free the private data on file
release.

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
---
 fs/sysfs/bin.c        |   10 +++++++++-
 include/linux/sysfs.h |    3 +++
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 60c702b..28c039a 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -37,6 +37,7 @@
 static DEFINE_MUTEX(sysfs_bin_lock);
 
 struct bin_buffer {
+	void				*private;
 	struct mutex			mutex;
 	void				*buffer;
 	int				mmapped;
@@ -438,6 +439,13 @@ static int open(struct inode * inode, struct file * file)
 static int release(struct inode * inode, struct file * file)
 {
 	struct bin_buffer *bb = file->private_data;
+	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
+	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
+	int rc = 0;
+
+	if (attr->release)
+		rc = attr->release(kobj, attr, file);
 
 	mutex_lock(&sysfs_bin_lock);
 	hlist_del(&bb->list);
@@ -445,7 +453,7 @@ static int release(struct inode * inode, struct file * file)
 
 	kfree(bb->buffer);
 	kfree(bb);
-	return 0;
+	return rc;
 }
 
 const struct file_operations bin_fops = {
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 9d68fed..751ea68 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -19,6 +19,7 @@
 
 struct kobject;
 struct module;
+struct file;
 
 /* FIXME
  * The *owner field is no longer used.
@@ -72,6 +73,8 @@ struct bin_attribute {
 			 char *, loff_t, size_t);
 	int (*mmap)(struct kobject *, struct bin_attribute *attr,
 		    struct vm_area_struct *vma);
+	int (*release)(struct kobject *, struct bin_attribute *attr,
+		      struct file *file);
 };
 
 struct sysfs_ops {
-- 
1.6.5.1


--Boundary-00=_gi23KkNb/H9fV0U
Content-Type: text/x-patch;
  charset="iso-8859-1";
  name="0003-Use-MTRR-for-pci_mmap_resource_wc-if-PAT-is-not-avai.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="0003-Use-MTRR-for-pci_mmap_resource_wc-if-PAT-is-not-avai.patch"

>From e3317e73726152380cd05f75c87c433b9185b291 Mon Sep 17 00:00:00 2001
From: Thomas Schlichter <thomas.schlichter@web.de>
Date: Sat, 17 Oct 2009 21:17:16 +0200
Subject: [PATCH 3/3] Use MTRR for pci_mmap_resource_wc if PAT is not available

X.org uses libpciaccess which tries to mmap with write combining enabled via
/sys/bus/pci/devices/*/resource0_wc. Currently, when PAT is not enabled, the
kernel does fall back to uncached mmap. Then libpciaccess thinks it succeeded
mapping with write combining enabled and does not set up suited MTRR entries.
;-(

So when falling back to uncached mapping, we better try to set up MTRR
entries automatically. When the resource file is closed, we remove the MTRR
entries again.

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
---
 arch/x86/include/asm/pci.h |    2 +
 arch/x86/pci/i386.c        |   60 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci-sysfs.c    |    8 ++++++
 drivers/pci/pci.h          |    6 ++++
 drivers/pci/proc.c         |    5 +++-
 5 files changed, 80 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index ada8c20..e94aeb1 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -64,6 +64,8 @@ struct irq_routing_table *pcibios_get_irq_routing_table(void);
 int pcibios_set_irq_routing(struct pci_dev *dev, int pin, int irq);
 
 
+#define HAVE_PCI_RELEASE_FILE
+
 #define HAVE_PCI_MMAP
 extern int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 			       enum pci_mmap_state mmap_state,
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index b22d13b..60b6fdc 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -31,7 +31,9 @@
 #include <linux/ioport.h>
 #include <linux/errno.h>
 #include <linux/bootmem.h>
+#include <linux/fs.h>
 
+#include <asm/mtrr.h>
 #include <asm/pat.h>
 #include <asm/e820.h>
 #include <asm/pci_x86.h>
@@ -301,5 +303,63 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 
 	vma->vm_ops = &pci_mmap_ops;
 
+#ifdef CONFIG_MTRR
+	if (!pat_enabled && write_combine) {
+		int i;
+		unsigned long base = vma->vm_pgoff << PAGE_SHIFT;
+		unsigned long size = vma->vm_end - vma->vm_start;
+
+		if ((size < PAGE_SIZE) || (size & (size - 1)) ||
+		    (base & (size - 1)))
+		{
+			printk(KERN_DEBUG
+				"Unaligned memory region passed to "
+				"pci_mmap_page_range().\n");
+			printk(KERN_DEBUG
+				"Thus no write combining MTRR entry "
+				"is created.\n");
+			printk(KERN_DEBUG
+				"   base = 0x%lx  size = 0x%lx\n", base, size);
+			return 0;
+		}
+
+		i = mtrr_add(base, size, MTRR_TYPE_WRCOMB, true);
+		if (i >= 0) {
+			int **p_mtrr_usage = (int **)vma->vm_file->private_data;
+
+			if (*p_mtrr_usage == NULL)
+				*p_mtrr_usage = kzalloc(num_var_ranges *
+							sizeof(int),
+							GFP_KERNEL);
+			if (*p_mtrr_usage != NULL)
+				(*p_mtrr_usage)[i]++;
+		}
+	}
+#endif // CONFIG_MTRR
+
+	return 0;
+}
+
+int pci_release_file(struct file *file)
+{
+#ifdef CONFIG_MTRR
+	int i;
+	int **p_mtrr_usage = (int **)file->private_data;
+	int *mtrr_usage = *p_mtrr_usage;
+
+	if (!mtrr_usage)
+		return 0;
+
+	for (i = 0; i < num_var_ranges; ++i) {
+		while (mtrr_usage[i] > 0) {
+			mtrr_del(i, 0, 0);
+			--mtrr_usage[i];
+		}
+	}
+
+	kfree(*p_mtrr_usage);
+	*p_mtrr_usage = NULL;
+#endif // CONFIG_MTRR
+
 	return 0;
 }
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 0f6382f..4f36835 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -733,6 +733,13 @@ pci_mmap_resource_wc(struct kobject *kobj, struct bin_attribute *attr,
 	return pci_mmap_resource(kobj, attr, vma, 1);
 }
 
+static int
+pci_release_resource(struct kobject *kobj, struct bin_attribute *attr,
+		     struct file *file)
+{
+	return pci_release_file(file);
+}
+
 /**
  * pci_remove_resource_files - cleanup resource files
  * @pdev: dev to cleanup
@@ -782,6 +789,7 @@ static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
 			sprintf(res_attr_name, "resource%d", num);
 			res_attr->mmap = pci_mmap_resource_uc;
 		}
+		res_attr->release = pci_release_resource;
 		res_attr->attr.name = res_attr_name;
 		res_attr->attr.mode = S_IRUSR | S_IWUSR;
 		res_attr->size = pci_resource_len(pdev, num);
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index d92d195..cff3b7d 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -84,6 +84,12 @@ static inline void pci_vpd_release(struct pci_dev *dev)
 		dev->vpd->ops->release(dev);
 }
 
+#ifdef HAVE_PCI_RELEASE_FILE
+extern int pci_release_file(struct file *file);
+#else
+static inline int pci_release_file(struct file *file) { return 0; }
+#endif
+
 /* PCI /proc functions */
 #ifdef CONFIG_PROC_FS
 extern int pci_proc_attach_device(struct pci_dev *dev);
diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index 593bb84..91c8a48 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -197,6 +197,7 @@ proc_bus_pci_write(struct file *file, const char __user *buf, size_t nbytes, lof
 }
 
 struct pci_filp_private {
+	void *private;
 	enum pci_mmap_state mmap_state;
 	int write_combine;
 };
@@ -277,7 +278,7 @@ static int proc_bus_pci_mmap(struct file *file, struct vm_area_struct *vma)
 
 static int proc_bus_pci_open(struct inode *inode, struct file *file)
 {
-	struct pci_filp_private *fpriv = kmalloc(sizeof(*fpriv), GFP_KERNEL);
+	struct pci_filp_private *fpriv = kzalloc(sizeof(*fpriv), GFP_KERNEL);
 
 	if (!fpriv)
 		return -ENOMEM;
@@ -292,6 +293,8 @@ static int proc_bus_pci_open(struct inode *inode, struct file *file)
 
 static int proc_bus_pci_release(struct inode *inode, struct file *file)
 {
+	pci_release_file(file);
+
 	kfree(file->private_data);
 	file->private_data = NULL;
 
-- 
1.6.5.1


--Boundary-00=_gi23KkNb/H9fV0U--
