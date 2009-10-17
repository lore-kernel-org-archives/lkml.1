Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbZJQTsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbZJQTsh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 15:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbZJQTsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 15:48:37 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:35914 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbZJQTsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 15:48:36 -0400
From: Thomas Schlichter <thomas.schlichter@web.de>
To: "Jan Beulich" <JBeulich@novell.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not available
Date: Sat, 17 Oct 2009 21:48:36 +0200
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
References: <4AD449A702000078000197EE@vpn.id2.novell.com> <200910142114.12433.thomas.schlichter@web.de> <4AD6EFD7020000780001A067@vpn.id2.novell.com>
In-Reply-To: <4AD6EFD7020000780001A067@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_U+h2K2gddSw6RDO"
Message-Id: <200910172148.36267.thomas.schlichter@web.de>
X-Provags-ID: V01U2FsdGVkX19Mn3+MDtW/MyPGRigk6rly3TdagR+nHOIu2d3y
	gZTsg0ziWUHY0FYshHoqh09YS2EWI8eE+EFI/l8eUdb3I5qBow
	Y30DhmmsJx/0Tijy7VMQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_U+h2K2gddSw6RDO
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Jan Beulich wrote:
> >>> Thomas Schlichter <thomas.schlichter@web.de> 14.10.09 21:14 >>>
> >
> >I added a function mtrr_add_unaligned() that tries to create as many MTRR
> >entries as necessary, beginning with the biggest regions. It does not
> > check the return values of each mtrr_add(), nor does it return the
> > indexes of the created MTRR entries. So it seems to be only useful with
> > increment=false. Or do you have a better idea?
> 
> I don't have immediate thoughts on how to address this, but nevertheless
> I continue to think that the issue must be solved in some way, even more
> that now you may be leaking multiple MTRRs.

OK, it required some changes on different edges, but now I have it...

Patches 0001-0003 introduce functionality/changes to the MTRR and sysfs 
subsystems. Patch 0004 is the main patch which sets up the MTRR entries when 
pci memory regions are mmapped. The Patches 0005-0006 also change ioremap() 
and set_mempry_wc() to set up MTRR entries. These two are completely optional, 
especially and there is currently no way to automatically remove MTRR entries 
set up with them.

What do you think about these patches?

Kind regards,
  Thomas

--Boundary-00=_U+h2K2gddSw6RDO
Content-Type: text/x-patch;
  charset="iso-8859-1";
  name="0005-Use-MTRR-for-write-combining-ioremap.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="0005-Use-MTRR-for-write-combining-ioremap.patch"

>From 4f000ec18079924b1191118dccf468bba50c402d Mon Sep 17 00:00:00 2001
From: Thomas Schlichter <thomas.schlichter@web.de>
Date: Sat, 17 Oct 2009 21:29:43 +0200
Subject: [PATCH 5/6] Use MTRR for write combining ioremap

If PAT is not enabled, set up write combining MTRR entries in ioremap().

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
---
 arch/x86/mm/ioremap.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 334e63c..abe40fa 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -21,6 +21,7 @@
 #include <asm/tlbflush.h>
 #include <asm/pgalloc.h>
 #include <asm/pat.h>
+#include <asm/mtrr.h>
 
 #include "physaddr.h"
 
@@ -268,11 +269,15 @@ EXPORT_SYMBOL(ioremap_nocache);
  */
 void __iomem *ioremap_wc(resource_size_t phys_addr, unsigned long size)
 {
-	if (pat_enabled)
-		return __ioremap_caller(phys_addr, size, _PAGE_CACHE_WC,
-					__builtin_return_address(0));
-	else
-		return ioremap_nocache(phys_addr, size);
+	if (!pat_enabled) {
+		void __iomem *ret = ioremap_nocache(phys_addr, size);
+		if (ret)
+			mtrr_add_unaligned(phys_addr, size,
+					   MTRR_TYPE_WRCOMB, false);
+		return ret;
+	}
+	return __ioremap_caller(phys_addr, size, _PAGE_CACHE_WC,
+				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(ioremap_wc);
 
-- 
1.6.5


--Boundary-00=_U+h2K2gddSw6RDO
Content-Type: text/x-patch;
  charset="iso-8859-1";
  name="0001-Add-new-mtrr_add_unaligned-function.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="0001-Add-new-mtrr_add_unaligned-function.patch"

>From 9ef568a835c5033efb8032f1a4415ac2a128d4fc Mon Sep 17 00:00:00 2001
From: Thomas Schlichter <thomas.schlichter@web.de>
Date: Wed, 14 Oct 2009 19:25:33 +0200
Subject: [PATCH 1/6] Add new mtrr_add_unaligned function

This function creates multiple MTRR entries for unaligned memory regions.

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
---
 arch/x86/include/asm/mtrr.h     |    8 ++++++++
 arch/x86/kernel/cpu/mtrr/main.c |   30 ++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
index 4365ffd..2e0d99d 100644
--- a/arch/x86/include/asm/mtrr.h
+++ b/arch/x86/include/asm/mtrr.h
@@ -116,6 +116,9 @@ extern int mtrr_add(unsigned long base, unsigned long size,
 		    unsigned int type, bool increment);
 extern int mtrr_add_page(unsigned long base, unsigned long size,
 			 unsigned int type, bool increment);
+extern void mtrr_add_unaligned(unsigned long base, unsigned long size,
+			       unsigned int type, bool increment,
+			       int *mtrr_usage);
 extern int mtrr_del(int reg, unsigned long base, unsigned long size);
 extern int mtrr_del_page(int reg, unsigned long base, unsigned long size);
 extern void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi);
@@ -146,6 +149,11 @@ static inline int mtrr_add_page(unsigned long base, unsigned long size,
 {
     return -ENODEV;
 }
+static inline void mtrr_add_unaligned(unsigned long base, unsigned long size,
+				      unsigned int type, bool increment,
+				      int *mtrr_usage)
+{
+}
 static inline int mtrr_del(int reg, unsigned long base, unsigned long size)
 {
     return -ENODEV;
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 84e83de..5bf769b 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -487,6 +487,36 @@ int mtrr_add(unsigned long base, unsigned long size, unsigned int type,
 }
 EXPORT_SYMBOL(mtrr_add);
 
+void mtrr_add_unaligned(unsigned long base, unsigned long size,
+			unsigned int type, bool increment, int *mtrr_usage)
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
+			i = mtrr_add(ptr1, size, type, increment);
+			if (i >= 0 && increment && mtrr_usage)
+				++mtrr_usage[i];
+			ptr1 += size;
+		}
+		if (base + size <= ptr2) {
+			ptr2 -= size;
+			i = mtrr_add(ptr2, size, type, increment);
+			if (i >= 0 && increment && mtrr_usage)
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
1.6.5


--Boundary-00=_U+h2K2gddSw6RDO
Content-Type: text/x-patch;
  charset="iso-8859-1";
  name="0002-Make-num_var_ranges-accessible-outside-MTRR-code.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="0002-Make-num_var_ranges-accessible-outside-MTRR-code.patch"

>From 513955a4697328d319739799b2bca650df895689 Mon Sep 17 00:00:00 2001
From: Thomas Schlichter <thomas.schlichter@web.de>
Date: Sat, 17 Oct 2009 12:36:05 +0200
Subject: [PATCH 2/6] Make num_var_ranges accessible outside MTRR code

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
index 2e0d99d..179a767 100644
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
1.6.5


--Boundary-00=_U+h2K2gddSw6RDO
Content-Type: text/x-patch;
  charset="iso-8859-1";
  name="0003-Provide-per-file-private-data-for-bin-sysfs-files.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="0003-Provide-per-file-private-data-for-bin-sysfs-files.patch"

>From 0d7525045927c8056ff28dd9465766862faba227 Mon Sep 17 00:00:00 2001
From: Thomas Schlichter <thomas.schlichter@web.de>
Date: Sat, 17 Oct 2009 12:39:11 +0200
Subject: [PATCH 3/6] Provide per-file private data for bin sysfs files

For binary sysfs files, provide a per-file private field in
struct bin_buffer. Therefore this modified struct is exported in the
<linux/sysfs.h> header file. Additionally add a release() callback
that can be used to free the private data on file release.

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
---
 fs/sysfs/bin.c        |   18 ++++++++----------
 include/linux/sysfs.h |   14 ++++++++++++++
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 60c702b..3647b7a 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -36,15 +36,6 @@
  */
 static DEFINE_MUTEX(sysfs_bin_lock);
 
-struct bin_buffer {
-	struct mutex			mutex;
-	void				*buffer;
-	int				mmapped;
-	const struct vm_operations_struct *vm_ops;
-	struct file			*file;
-	struct hlist_node		list;
-};
-
 static int
 fill_read(struct dentry *dentry, char *buffer, loff_t off, size_t count)
 {
@@ -438,14 +429,21 @@ static int open(struct inode * inode, struct file * file)
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
index 9d68fed..bcad8ad 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -15,6 +15,7 @@
 #include <linux/compiler.h>
 #include <linux/errno.h>
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <asm/atomic.h>
 
 struct kobject;
@@ -60,8 +61,19 @@ struct attribute_group {
 
 #define attr_name(_attr) (_attr).attr.name
 
+struct file;
 struct vm_area_struct;
 
+struct bin_buffer {
+	struct mutex			mutex;
+	void				*buffer;
+	void				*private;
+	int				mmapped;
+	const struct vm_operations_struct *vm_ops;
+	struct file			*file;
+	struct hlist_node		list;
+};
+
 struct bin_attribute {
 	struct attribute	attr;
 	size_t			size;
@@ -72,6 +84,8 @@ struct bin_attribute {
 			 char *, loff_t, size_t);
 	int (*mmap)(struct kobject *, struct bin_attribute *attr,
 		    struct vm_area_struct *vma);
+	int (*release)(struct kobject *, struct bin_attribute *attr,
+		      struct file *file);
 };
 
 struct sysfs_ops {
-- 
1.6.5


--Boundary-00=_U+h2K2gddSw6RDO
Content-Type: text/x-patch;
  charset="iso-8859-1";
  name="0004-Use-MTRR-for-pci_mmap_resource_wc-if-PAT-is-not-avai.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="0004-Use-MTRR-for-pci_mmap_resource_wc-if-PAT-is-not-avai.patch"

>From d7d9760bf7052ee53e50beb7e89fc14371e33cfa Mon Sep 17 00:00:00 2001
From: Thomas Schlichter <thomas.schlichter@web.de>
Date: Sat, 17 Oct 2009 21:17:16 +0200
Subject: [PATCH 4/6] Use MTRR for pci_mmap_resource_wc if PAT is not available

X.org uses libpciaccess which tries to mmap with write combining enabled via
/sys/bus/pci/devices/*/resource0_wc. Currently, when PAT is not enabled, we
fall back to uncached mmap. Then libpciaccess thinks it succeeded mapping
with write combining anabled and does not set up suited MTRR entries. ;-(

So when falling back to uncached mapping, we better try to set up MTRR
entries automatically. When the resource file is closed, we remove the MTRR
entries again.

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
---
 drivers/pci/pci-sysfs.c |   45 +++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 0f6382f..604a063 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -23,6 +23,11 @@
 #include <linux/mm.h>
 #include <linux/capability.h>
 #include <linux/pci-aspm.h>
+#include <linux/fs.h>
+#ifdef CONFIG_X86
+#  include <asm/mtrr.h>
+#  include <asm/pat.h>
+#endif
 #include "pci.h"
 
 static int sysfs_initialized;	/* = 0 */
@@ -692,9 +697,10 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 	struct pci_dev *pdev = to_pci_dev(container_of(kobj,
 						       struct device, kobj));
 	struct resource *res = (struct resource *)attr->private;
+	struct bin_buffer *bb = (struct bin_buffer *)vma->vm_file->private_data;
 	enum pci_mmap_state mmap_type;
 	resource_size_t start, end;
-	int i;
+	int rc, i;
 
 	for (i = 0; i < PCI_ROM_RESOURCE; i++)
 		if (res == &pdev->resource[i])
@@ -716,7 +722,18 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 	if (res->flags & IORESOURCE_MEM && iomem_is_exclusive(start))
 		return -EINVAL;
 
-	return pci_mmap_page_range(pdev, vma, mmap_type, write_combine);
+	rc = pci_mmap_page_range(pdev, vma, mmap_type, write_combine);
+#ifdef CONFIG_X86
+	if (!rc && !pat_enabled && write_combine) {
+		if (!bb->private)
+			bb->private = kzalloc(num_var_ranges * sizeof(int),
+					      GFP_KERNEL);
+		mtrr_add_unaligned(vma->vm_pgoff << PAGE_SHIFT,
+				   vma->vm_end - vma->vm_start,
+				   MTRR_TYPE_WRCOMB, true, bb->private);
+	}
+#endif // CONFIG_X86
+	return rc;
 }
 
 static int
@@ -733,6 +750,29 @@ pci_mmap_resource_wc(struct kobject *kobj, struct bin_attribute *attr,
 	return pci_mmap_resource(kobj, attr, vma, 1);
 }
 
+static int
+pci_release(struct kobject *kobj, struct bin_attribute *attr, struct file *file)
+{
+#ifdef CONFIG_X86
+	struct bin_buffer *bb = (struct bin_buffer *)file->private_data;
+	int i, *mtrr_usage = (int *)bb->private;
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
+	kfree(bb->private);
+	bb->private = NULL;
+#endif // CONFIG_X86
+	return 0;
+}
+
 /**
  * pci_remove_resource_files - cleanup resource files
  * @pdev: dev to cleanup
@@ -782,6 +822,7 @@ static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
 			sprintf(res_attr_name, "resource%d", num);
 			res_attr->mmap = pci_mmap_resource_uc;
 		}
+		res_attr->release = pci_release;
 		res_attr->attr.name = res_attr_name;
 		res_attr->attr.mode = S_IRUSR | S_IWUSR;
 		res_attr->size = pci_resource_len(pdev, num);
-- 
1.6.5


--Boundary-00=_U+h2K2gddSw6RDO
Content-Type: text/x-patch;
  charset="iso-8859-1";
  name="0006-Set-up-MTRR-entries-within-set_memory_wc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="0006-Set-up-MTRR-entries-within-set_memory_wc.patch"

>From 8eea502750fa642ff9f74e91466646e669eb5791 Mon Sep 17 00:00:00 2001
From: Thomas Schlichter <thomas.schlichter@web.de>
Date: Sat, 17 Oct 2009 21:36:37 +0200
Subject: [PATCH 6/6] Set up MTRR entries within set_memory_wc

If PAT is not enabled, set up write combining MTRR entries in set_memory_wc().

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
---
 arch/x86/mm/pageattr.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index dd38bfb..c25f697 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -23,6 +23,7 @@
 #include <asm/pgalloc.h>
 #include <asm/proto.h>
 #include <asm/pat.h>
+#include <asm/mtrr.h>
 
 /*
  * The current flushing context - we pass it instead of 5 arguments:
@@ -1010,8 +1011,13 @@ int set_memory_wc(unsigned long addr, int numpages)
 {
 	int ret;
 
-	if (!pat_enabled)
-		return set_memory_uc(addr, numpages);
+	if (!pat_enabled) {
+		ret = set_memory_uc(addr, numpages);
+		if (!ret)
+			mtrr_add_unaligned(__pa(addr), numpages * PAGE_SIZE,
+					   MTRR_TYPE_WRCOMB, false);
+		return ret;
+	}
 
 	ret = reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
 		_PAGE_CACHE_WC, NULL);
-- 
1.6.5


--Boundary-00=_U+h2K2gddSw6RDO--
