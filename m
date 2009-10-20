Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbZJTTzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbZJTTzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 15:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZJTTzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 15:55:49 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:43794 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbZJTTzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 15:55:48 -0400
From: Thomas Schlichter <thomas.schlichter@web.de>
To: "Jan Beulich" <JBeulich@novell.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not  available
Date: Tue, 20 Oct 2009 21:54:20 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.28.10-bigboss; KDE/4.3.2; i686; ; )
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
       "Robert Hancock" <hancockrwd@gmail.com>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Tejun Heo" <tj@kernel.org>, x86@kernel.org,
       "Yinghai Lu" <yinghai@kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       dri-devel@lists.sourceforge.net, "Ingo Molnar" <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       "Thomas Hellstrom" <thellstrom@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <1392884759@web.de>
In-Reply-To: <1392884759@web.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_sVh3KtzLMtBveK/"
Message-Id: <200910202154.20195.thomas.schlichter@web.de>
X-Provags-ID: V01U2FsdGVkX18i6uVvv8ZIY5nJrBJNCUCds3vQYowugpLVky0y
	jJz7eob3QKUl9NanM+ExWQg/9CIoVOAMS2wTIJK18CjD0J3dC7
	0Wi3QcsW7v+LKIcMXqDg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_sVh3KtzLMtBveK/
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit

Jan Beulich wrote:
> Functionality-wise this looks fine to me; whether the core sysfs changes
> are acceptable I can't judge, though.

OK, I think I should have addressed your comments. Unfortunately I had to use 
a little "hack" to make pci_mmap_page_range() work for sysfs and proc. I 
placed a "private" pointer in the beginning of both per-file private 
structures. So this pointer can be accessed independent from the caller. I 
hope this is acceptable.

I dropped the ioremap() and set_memory_wc() patches, I could not implement 
reference counting for them and it may interact too much with existing GPU 
drivers.

Again, this series should not change the current behavior if either MTRR is 
disabled or PAT is enabled. But it helps in the case that MTRR is enabled and 
PAT is not available.

What should be done now to get this series on the right "track"?

Kind regards,
  Thomas

--Boundary-00=_sVh3KtzLMtBveK/
Content-Type: text/x-patch;
  charset="iso-8859-15";
  name="0004-Use-MTRR-for-pci_mmap_resource_wc-if-PAT-is-not-avai.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="0004-Use-MTRR-for-pci_mmap_resource_wc-if-PAT-is-not-avai.patch"

>From 88d77b939afa1934eb2158f6d28db500eab0d345 Mon Sep 17 00:00:00 2001
From: Thomas Schlichter <thomas.schlichter@web.de>
Date: Sat, 17 Oct 2009 21:17:16 +0200
Subject: [PATCH 4/4] Use MTRR for pci_mmap_resource_wc if PAT is not available

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
 arch/x86/include/asm/pci.h |    2 ++
 arch/x86/pci/i386.c        |   38 ++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci-sysfs.c    |    8 ++++++++
 drivers/pci/pci.h          |    6 ++++++
 drivers/pci/proc.c         |    5 ++++-
 5 files changed, 58 insertions(+), 1 deletions(-)

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
index b22d13b..4cef0c1 100644
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
@@ -274,6 +276,7 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 			enum pci_mmap_state mmap_state, int write_combine)
 {
 	unsigned long prot;
+	int **p_mtrr_usage = (int **)vma->vm_file->private_data;
 
 	/* I/O space cannot be accessed via normal processor loads and
 	 * stores on this platform.
@@ -301,5 +304,40 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 
 	vma->vm_ops = &pci_mmap_ops;
 
+#ifdef CONFIG_MTRR
+	if (!pat_enabled && write_combine) {
+		if (*p_mtrr_usage == NULL)
+			*p_mtrr_usage = kzalloc(num_var_ranges * sizeof(int),
+						GFP_KERNEL);
+		mtrr_add_unaligned(vma->vm_pgoff << PAGE_SHIFT,
+				   vma->vm_end - vma->vm_start,
+				   MTRR_TYPE_WRCOMB, *p_mtrr_usage);
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


--Boundary-00=_sVh3KtzLMtBveK/
Content-Type: text/x-patch;
  charset="iso-8859-15";
  name="0001-Add-new-mtrr_add_unaligned-function.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="0001-Add-new-mtrr_add_unaligned-function.patch"

>From 7cd44581d15aaa3b2ef38a4d76ba19dd50e7cb7b Mon Sep 17 00:00:00 2001
From: Thomas Schlichter <thomas.schlichter@web.de>
Date: Wed, 14 Oct 2009 19:25:33 +0200
Subject: [PATCH 1/4] Add new mtrr_add_unaligned function

This function creates multiple MTRR entries for unaligned memory regions.

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
---
 arch/x86/include/asm/mtrr.h     |    6 ++++++
 arch/x86/kernel/cpu/mtrr/main.c |   30 ++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
index 4365ffd..9f447c4 100644
--- a/arch/x86/include/asm/mtrr.h
+++ b/arch/x86/include/asm/mtrr.h
@@ -116,6 +116,8 @@ extern int mtrr_add(unsigned long base, unsigned long size,
 		    unsigned int type, bool increment);
 extern int mtrr_add_page(unsigned long base, unsigned long size,
 			 unsigned int type, bool increment);
+extern void mtrr_add_unaligned(unsigned long base, unsigned long size,
+			       unsigned int type, int *mtrr_usage);
 extern int mtrr_del(int reg, unsigned long base, unsigned long size);
 extern int mtrr_del_page(int reg, unsigned long base, unsigned long size);
 extern void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi);
@@ -146,6 +148,10 @@ static inline int mtrr_add_page(unsigned long base, unsigned long size,
 {
     return -ENODEV;
 }
+static inline void mtrr_add_unaligned(unsigned long base, unsigned long size,
+				      unsigned int type, int *mtrr_usage)
+{
+}
 static inline int mtrr_del(int reg, unsigned long base, unsigned long size)
 {
     return -ENODEV;
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 84e83de..5654ef7 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -487,6 +487,36 @@ int mtrr_add(unsigned long base, unsigned long size, unsigned int type,
 }
 EXPORT_SYMBOL(mtrr_add);
 
+void mtrr_add_unaligned(unsigned long base, unsigned long size,
+			unsigned int type, int *mtrr_usage)
+{
+	int i;
+	unsigned long ptr1, ptr2, end = base + size;
+
+	// round down size to next power ot two
+	size = __rounddown_pow_of_two(size);
+
+	// accordingly align pointers
+	ptr1 = ptr2 = (base + size - 1) & ~(size - 1);
+
+	while (size >= PAGE_SIZE) {
+		if (ptr1 + size <= end) {
+			i = mtrr_add(ptr1, size, type, !!mtrr_usage);
+			if (i >= 0 && mtrr_usage)
+				++mtrr_usage[i];
+			ptr1 += size;
+		}
+		if (base + size <= ptr2) {
+			ptr2 -= size;
+			i = mtrr_add(ptr2, size, type, !!mtrr_usage);
+			if (i >= 0 && mtrr_usage)
+				++mtrr_usage[i];
+		}
+		size >>= 1;
+	}
+}
+EXPORT_SYMBOL(mtrr_add_unaligned);
+
 /**
  * mtrr_del_page - delete a memory type region
  * @reg: Register returned by mtrr_add
-- 
1.6.5.1


--Boundary-00=_sVh3KtzLMtBveK/
Content-Type: text/x-patch;
  charset="iso-8859-15";
  name="0002-Make-num_var_ranges-accessible-outside-MTRR-code.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="0002-Make-num_var_ranges-accessible-outside-MTRR-code.patch"

>From 4299569a5ed27b2a0bc2c0a04014edc4bb29bb7e Mon Sep 17 00:00:00 2001
From: Thomas Schlichter <thomas.schlichter@web.de>
Date: Sat, 17 Oct 2009 12:36:05 +0200
Subject: [PATCH 2/4] Make num_var_ranges accessible outside MTRR code

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
index 9f447c4..cc6f123 100644
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


--Boundary-00=_sVh3KtzLMtBveK/
Content-Type: text/x-patch;
  charset="iso-8859-15";
  name="0003-Provide-per-file-private-data-for-bin-sysfs-files.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="0003-Provide-per-file-private-data-for-bin-sysfs-files.patch"

>From 92735813dbd6ea3c9ee56a7e23d7a8d8483e9e7d Mon Sep 17 00:00:00 2001
From: Thomas Schlichter <thomas.schlichter@web.de>
Date: Sat, 17 Oct 2009 12:39:11 +0200
Subject: [PATCH 3/4] Provide per-file private data for bin sysfs files

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
index 60c702b..c0575a3 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -37,6 +37,7 @@
 static DEFINE_MUTEX(sysfs_bin_lock);
 
 struct bin_buffer {
+	void				*private;
 	struct mutex			mutex;
 	void				*buffer;
 	int				mmapped;
@@ -438,14 +439,21 @@ static int open(struct inode * inode, struct file * file)
 static int release(struct inode * inode, struct file * file)
 {
 	struct bin_buffer *bb = file->private_data;
+	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
+	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
+	int rc = 0;
 
+	if (attr->release)
+		rc = attr->release(kobj, attr, file);
+	
 	mutex_lock(&sysfs_bin_lock);
 	hlist_del(&bb->list);
 	mutex_unlock(&sysfs_bin_lock);
 
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


--Boundary-00=_sVh3KtzLMtBveK/--
