Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbYDXW4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbYDXW4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 18:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYDXW4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 18:56:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43356 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbYDXW4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 18:56:40 -0400
Date: Fri, 25 Apr 2008 00:56:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] x86 PAT changes
Message-ID: <20080424225625.GB8717@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Linus, please pull the x86-pat git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-pat.git for-linus

this adds the second (and final) phase of the x86 PAT changes. Due to 
generic impact (the drivers/char/mem.c and include/asm-generic/iomap.h 
changes) this is offered as a separate tree.

The new CONFIG_NONPROMISC_DEVMEM defaults to disabled so PAT will be 
disabled, to stay compatible and to be a bit cautious/gradual.

Thanks,

	Ingo

------------------>
Arjan van de Ven (1):
      x86: introduce /dev/mem restrictions with a config option

Ingo Molnar (2):
      pat: cleanups
      /dev/mem: make promisc the default

Venki Pallipadi (1):
      devmem: add range_is_allowed() check to mmap of /dev/mem

venkatesh.pallipadi@intel.com (4):
      x86: PAT avoid aliasing in /dev/mem read/write
      x86: PAT phys_mem_access_prot_allowed for dev/mem mmap
      x86: PAT use reserve free memtype in mmap of /dev/mem
      generic: add ioremap_wc() interface wrapper

 arch/x86/Kconfig.debug      |   11 +++
 arch/x86/mm/init_32.c       |   19 +++++
 arch/x86/mm/init_64.c       |   20 +++++
 arch/x86/mm/ioremap.c       |   29 +++++++
 arch/x86/mm/pat.c           |  175 +++++++++++++++++++++++++++++++++++++++----
 drivers/char/mem.c          |  133 +++++++++++++++++++++++++--------
 include/asm-generic/iomap.h |    4 +
 include/asm-x86/io.h        |    8 ++
 include/asm-x86/io_32.h     |    6 --
 include/asm-x86/io_64.h     |    6 --
 include/asm-x86/page.h      |    1 +
 include/asm-x86/pgtable.h   |    9 ++
 12 files changed, 363 insertions(+), 58 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 610aaec..239fd9f 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -5,6 +5,17 @@ config TRACE_IRQFLAGS_SUPPORT
 
 source "lib/Kconfig.debug"
 
+config NONPROMISC_DEVMEM
+	bool "Disable promiscuous /dev/mem"
+	help
+	  The /dev/mem file by default only allows userspace access to PCI
+	  space and the BIOS code and data regions. This is sufficient for
+	  dosemu and X and all common users of /dev/mem. With this config
+	  option, you allow userspace access to all of memory, including
+	  kernel and userspace memory. Accidental access to this is
+	  obviously disasterous, but specific access can be used by people
+	  debugging the kernel.
+
 config EARLY_PRINTK
 	bool "Early printk" if EMBEDDED
 	default y
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 9ec62da..39852d5 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -227,6 +227,25 @@ static inline int page_kills_ppro(unsigned long pagenr)
 	return 0;
 }
 
+/*
+ * devmem_is_allowed() checks to see if /dev/mem access to a certain address
+ * is valid. The argument is a physical page number.
+ *
+ *
+ * On x86, access has to be given to the first megabyte of ram because that area
+ * contains bios code and data regions used by X and dosemu and similar apps.
+ * Access has to be given to non-kernel-ram areas as well, these contain the PCI
+ * mmio resources as well as potential bios/acpi data regions.
+ */
+int devmem_is_allowed(unsigned long pagenr)
+{
+	if (pagenr <= 256)
+		return 1;
+	if (!page_is_ram(pagenr))
+		return 1;
+	return 0;
+}
+
 #ifdef CONFIG_HIGHMEM
 pte_t *kmap_pte;
 pgprot_t kmap_prot;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 1ff7906..49c274e 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -664,6 +664,26 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
 
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
+/*
+ * devmem_is_allowed() checks to see if /dev/mem access to a certain address
+ * is valid. The argument is a physical page number.
+ *
+ *
+ * On x86, access has to be given to the first megabyte of ram because that area
+ * contains bios code and data regions used by X and dosemu and similar apps.
+ * Access has to be given to non-kernel-ram areas as well, these contain the PCI
+ * mmio resources as well as potential bios/acpi data regions.
+ */
+int devmem_is_allowed(unsigned long pagenr)
+{
+	if (pagenr <= 256)
+		return 1;
+	if (!page_is_ram(pagenr))
+		return 1;
+	return 0;
+}
+
+
 static struct kcore_list kcore_mem, kcore_vmalloc, kcore_kernel,
 			 kcore_modules, kcore_vsyscall;
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 3a4baf9..caac7d5 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -336,6 +336,35 @@ void iounmap(volatile void __iomem *addr)
 }
 EXPORT_SYMBOL(iounmap);
 
+/*
+ * Convert a physical pointer to a virtual kernel pointer for /dev/mem
+ * access
+ */
+void *xlate_dev_mem_ptr(unsigned long phys)
+{
+	void *addr;
+	unsigned long start = phys & PAGE_MASK;
+
+	/* If page is RAM, we can use __va. Otherwise ioremap and unmap. */
+	if (page_is_ram(start >> PAGE_SHIFT))
+		return __va(phys);
+
+	addr = (void *)ioremap(start, PAGE_SIZE);
+	if (addr)
+		addr = (void *)((unsigned long)addr | (phys & ~PAGE_MASK));
+
+	return addr;
+}
+
+void unxlate_dev_mem_ptr(unsigned long phys, void *addr)
+{
+	if (page_is_ram(phys >> PAGE_SHIFT))
+		return;
+
+	iounmap((void __iomem *)((unsigned long)addr & PAGE_MASK));
+	return;
+}
+
 #ifdef CONFIG_X86_32
 
 int __initdata early_ioremap_debug;
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 72c0f60..ef8b64b 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/gfp.h>
 #include <linux/fs.h>
+#include <linux/bootmem.h>
 
 #include <asm/msr.h>
 #include <asm/tlbflush.h>
@@ -21,6 +22,7 @@
 #include <asm/cacheflush.h>
 #include <asm/fcntl.h>
 #include <asm/mtrr.h>
+#include <asm/io.h>
 
 int pat_wc_enabled = 1;
 
@@ -190,6 +192,21 @@ static int pat_x_mtrr_type(u64 start, u64 end, unsigned long prot,
 	return 0;
 }
 
+/*
+ * req_type typically has one of the:
+ * - _PAGE_CACHE_WB
+ * - _PAGE_CACHE_WC
+ * - _PAGE_CACHE_UC_MINUS
+ * - _PAGE_CACHE_UC
+ *
+ * req_type will have a special case value '-1', when requester want to inherit
+ * the memory type from mtrr (if WB), existing PAT, defaulting to UC_MINUS.
+ *
+ * If ret_type is NULL, function will return an error if it cannot reserve the
+ * region with req_type. If ret_type is non-null, function will return
+ * available type in ret_type in case of no error. In case of any error
+ * it will return a negative return value.
+ */
 int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 			unsigned long *ret_type)
 {
@@ -200,9 +217,14 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 
 	/* Only track when pat_wc_enabled */
 	if (!pat_wc_enabled) {
-		if (ret_type)
-			*ret_type = req_type;
-
+		/* This is identical to page table setting without PAT */
+		if (ret_type) {
+			if (req_type == -1) {
+				*ret_type = _PAGE_CACHE_WB;
+			} else {
+				*ret_type = req_type;
+			}
+		}
 		return 0;
 	}
 
@@ -214,8 +236,29 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 		return 0;
 	}
 
-	req_type &= _PAGE_CACHE_MASK;
-	err = pat_x_mtrr_type(start, end, req_type, &actual_type);
+	if (req_type == -1) {
+		/*
+		 * Special case where caller wants to inherit from mtrr or
+		 * existing pat mapping, defaulting to UC_MINUS in case of
+		 * no match.
+		 */
+		u8 mtrr_type = mtrr_type_lookup(start, end);
+		if (mtrr_type == 0xFE) { /* MTRR match error */
+			err = -1;
+		}
+
+		if (mtrr_type == MTRR_TYPE_WRBACK) {
+			req_type = _PAGE_CACHE_WB;
+			actual_type = _PAGE_CACHE_WB;
+		} else {
+			req_type = _PAGE_CACHE_UC_MINUS;
+			actual_type = _PAGE_CACHE_UC_MINUS;
+		}
+	} else {
+		req_type &= _PAGE_CACHE_MASK;
+		err = pat_x_mtrr_type(start, end, req_type, &actual_type);
+	}
+
 	if (err) {
 		if (ret_type)
 			*ret_type = actual_type;
@@ -241,7 +284,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 		struct memtype *saved_ptr;
 
 		if (parse->start >= end) {
-			printk("New Entry\n");
+			pr_debug("New Entry\n");
 			list_add(&new_entry->nd, parse->nd.prev);
 			new_entry = NULL;
 			break;
@@ -343,7 +386,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 				break;
 			}
 
-			printk("Overlap at 0x%Lx-0x%Lx\n",
+			printk(KERN_INFO "Overlap at 0x%Lx-0x%Lx\n",
 			       saved_ptr->start, saved_ptr->end);
 			/* No conflict. Go ahead and add this new entry */
 			list_add(&new_entry->nd, &saved_ptr->nd);
@@ -353,7 +396,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 	}
 
 	if (err) {
-		printk(
+		printk(KERN_INFO
 	"reserve_memtype failed 0x%Lx-0x%Lx, track %s, req %s\n",
 			start, end, cattr_name(new_entry->type),
 			cattr_name(req_type));
@@ -365,16 +408,16 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 	if (new_entry) {
 		/* No conflict. Not yet added to the list. Add to the tail */
 		list_add_tail(&new_entry->nd, &memtype_list);
-		printk("New Entry\n");
-  	}
+		pr_debug("New Entry\n");
+	}
 
 	if (ret_type) {
-		printk(
+		pr_debug(
 	"reserve_memtype added 0x%Lx-0x%Lx, track %s, req %s, ret %s\n",
 			start, end, cattr_name(actual_type),
 			cattr_name(req_type), cattr_name(*ret_type));
 	} else {
-		printk(
+		pr_debug(
 	"reserve_memtype added 0x%Lx-0x%Lx, track %s, req %s\n",
 			start, end, cattr_name(actual_type),
 			cattr_name(req_type));
@@ -411,11 +454,115 @@ int free_memtype(u64 start, u64 end)
 	spin_unlock(&memtype_lock);
 
 	if (err) {
-		printk(KERN_DEBUG "%s:%d freeing invalid memtype %Lx-%Lx\n",
+		printk(KERN_INFO "%s:%d freeing invalid memtype %Lx-%Lx\n",
 			current->comm, current->pid, start, end);
 	}
 
-	printk( "free_memtype request 0x%Lx-0x%Lx\n", start, end);
+	pr_debug("free_memtype request 0x%Lx-0x%Lx\n", start, end);
 	return err;
 }
 
+
+/*
+ * /dev/mem mmap interface. The memtype used for mapping varies:
+ * - Use UC for mappings with O_SYNC flag
+ * - Without O_SYNC flag, if there is any conflict in reserve_memtype,
+ *   inherit the memtype from existing mapping.
+ * - Else use UC_MINUS memtype (for backward compatibility with existing
+ *   X drivers.
+ */
+pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
+				unsigned long size, pgprot_t vma_prot)
+{
+	return vma_prot;
+}
+
+int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
+				unsigned long size, pgprot_t *vma_prot)
+{
+	u64 offset = ((u64) pfn) << PAGE_SHIFT;
+	unsigned long flags = _PAGE_CACHE_UC_MINUS;
+	unsigned long ret_flags;
+	int retval;
+
+	if (file->f_flags & O_SYNC) {
+		flags = _PAGE_CACHE_UC;
+	}
+
+#ifdef CONFIG_X86_32
+	/*
+	 * On the PPro and successors, the MTRRs are used to set
+	 * memory types for physical addresses outside main memory,
+	 * so blindly setting UC or PWT on those pages is wrong.
+	 * For Pentiums and earlier, the surround logic should disable
+	 * caching for the high addresses through the KEN pin, but
+	 * we maintain the tradition of paranoia in this code.
+	 */
+	if (!pat_wc_enabled &&
+	    ! ( test_bit(X86_FEATURE_MTRR, boot_cpu_data.x86_capability) ||
+		test_bit(X86_FEATURE_K6_MTRR, boot_cpu_data.x86_capability) ||
+		test_bit(X86_FEATURE_CYRIX_ARR, boot_cpu_data.x86_capability) ||
+		test_bit(X86_FEATURE_CENTAUR_MCR, boot_cpu_data.x86_capability)) &&
+	   (pfn << PAGE_SHIFT) >= __pa(high_memory)) {
+		flags = _PAGE_CACHE_UC;
+	}
+#endif
+
+	/*
+	 * With O_SYNC, we can only take UC mapping. Fail if we cannot.
+	 * Without O_SYNC, we want to get
+	 * - WB for WB-able memory and no other conflicting mappings
+	 * - UC_MINUS for non-WB-able memory with no other conflicting mappings
+	 * - Inherit from confliting mappings otherwise
+	 */
+	if (flags != _PAGE_CACHE_UC_MINUS) {
+		retval = reserve_memtype(offset, offset + size, flags, NULL);
+	} else {
+		retval = reserve_memtype(offset, offset + size, -1, &ret_flags);
+	}
+
+	if (retval < 0)
+		return 0;
+
+	flags = ret_flags;
+
+	if (pfn <= max_pfn_mapped &&
+            ioremap_change_attr((unsigned long)__va(offset), size, flags) < 0) {
+		free_memtype(offset, offset + size);
+		printk(KERN_INFO
+		"%s:%d /dev/mem ioremap_change_attr failed %s for %Lx-%Lx\n",
+			current->comm, current->pid,
+			cattr_name(flags),
+			offset, offset + size);
+		return 0;
+	}
+
+	*vma_prot = __pgprot((pgprot_val(*vma_prot) & ~_PAGE_CACHE_MASK) |
+			     flags);
+	return 1;
+}
+
+void map_devmem(unsigned long pfn, unsigned long size, pgprot_t vma_prot)
+{
+	u64 addr = (u64)pfn << PAGE_SHIFT;
+	unsigned long flags;
+	unsigned long want_flags = (pgprot_val(vma_prot) & _PAGE_CACHE_MASK);
+
+	reserve_memtype(addr, addr + size, want_flags, &flags);
+	if (flags != want_flags) {
+		printk(KERN_INFO
+		"%s:%d /dev/mem expected mapping type %s for %Lx-%Lx, got %s\n",
+			current->comm, current->pid,
+			cattr_name(want_flags),
+			addr, addr + size,
+			cattr_name(flags));
+	}
+}
+
+void unmap_devmem(unsigned long pfn, unsigned long size, pgprot_t vma_prot)
+{
+	u64 addr = (u64)pfn << PAGE_SHIFT;
+
+	free_memtype(addr, addr + size);
+}
+
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 20070b7..e83623e 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -41,36 +41,7 @@
  */
 static inline int uncached_access(struct file *file, unsigned long addr)
 {
-#if defined(__i386__) && !defined(__arch_um__)
-	/*
-	 * On the PPro and successors, the MTRRs are used to set
-	 * memory types for physical addresses outside main memory,
-	 * so blindly setting PCD or PWT on those pages is wrong.
-	 * For Pentiums and earlier, the surround logic should disable
-	 * caching for the high addresses through the KEN pin, but
-	 * we maintain the tradition of paranoia in this code.
-	 */
-	if (file->f_flags & O_SYNC)
-		return 1;
- 	return !( test_bit(X86_FEATURE_MTRR, boot_cpu_data.x86_capability) ||
-		  test_bit(X86_FEATURE_K6_MTRR, boot_cpu_data.x86_capability) ||
-		  test_bit(X86_FEATURE_CYRIX_ARR, boot_cpu_data.x86_capability) ||
-		  test_bit(X86_FEATURE_CENTAUR_MCR, boot_cpu_data.x86_capability) )
-	  && addr >= __pa(high_memory);
-#elif defined(__x86_64__) && !defined(__arch_um__)
-	/* 
-	 * This is broken because it can generate memory type aliases,
-	 * which can cause cache corruptions
-	 * But it is only available for root and we have to be bug-to-bug
-	 * compatible with i386.
-	 */
-	if (file->f_flags & O_SYNC)
-		return 1;
-	/* same behaviour as i386. PAT always set to cached and MTRRs control the
-	   caching behaviour. 
-	   Hopefully a full PAT implementation will fix that soon. */	   
-	return 0;
-#elif defined(CONFIG_IA64)
+#if defined(CONFIG_IA64)
 	/*
 	 * On ia64, we ignore O_SYNC because we cannot tolerate memory attribute aliases.
 	 */
@@ -108,6 +79,36 @@ static inline int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
 }
 #endif
 
+#ifdef CONFIG_NONPROMISC_DEVMEM
+static inline int range_is_allowed(unsigned long pfn, unsigned long size)
+{
+	u64 from = ((u64)pfn) << PAGE_SHIFT;
+	u64 to = from + size;
+	u64 cursor = from;
+
+	while (cursor < to) {
+		if (!devmem_is_allowed(pfn)) {
+			printk(KERN_INFO
+		"Program %s tried to access /dev/mem between %Lx->%Lx.\n",
+				current->comm, from, to);
+			return 0;
+		}
+		cursor += PAGE_SIZE;
+		pfn++;
+	}
+	return 1;
+}
+#else
+static inline int range_is_allowed(unsigned long pfn, unsigned long size)
+{
+	return 1;
+}
+#endif
+
+void __attribute__((weak)) unxlate_dev_mem_ptr(unsigned long phys, void *addr)
+{
+}
+
 /*
  * This funcion reads the *physical* memory. The f_pos points directly to the 
  * memory location. 
@@ -150,15 +151,25 @@ static ssize_t read_mem(struct file * file, char __user * buf,
 
 		sz = min_t(unsigned long, sz, count);
 
+		if (!range_is_allowed(p >> PAGE_SHIFT, count))
+			return -EPERM;
+
 		/*
 		 * On ia64 if a page has been mapped somewhere as
 		 * uncached, then it must also be accessed uncached
 		 * by the kernel or data corruption may occur
 		 */
 		ptr = xlate_dev_mem_ptr(p);
+		if (!ptr)
+			return -EFAULT;
 
-		if (copy_to_user(buf, ptr, sz))
+		if (copy_to_user(buf, ptr, sz)) {
+			unxlate_dev_mem_ptr(p, ptr);
 			return -EFAULT;
+		}
+
+		unxlate_dev_mem_ptr(p, ptr);
+
 		buf += sz;
 		p += sz;
 		count -= sz;
@@ -207,20 +218,32 @@ static ssize_t write_mem(struct file * file, const char __user * buf,
 
 		sz = min_t(unsigned long, sz, count);
 
+		if (!range_is_allowed(p >> PAGE_SHIFT, sz))
+			return -EPERM;
+
 		/*
 		 * On ia64 if a page has been mapped somewhere as
 		 * uncached, then it must also be accessed uncached
 		 * by the kernel or data corruption may occur
 		 */
 		ptr = xlate_dev_mem_ptr(p);
+		if (!ptr) {
+			if (written)
+				break;
+			return -EFAULT;
+		}
 
 		copied = copy_from_user(ptr, buf, sz);
 		if (copied) {
 			written += sz - copied;
+			unxlate_dev_mem_ptr(p, ptr);
 			if (written)
 				break;
 			return -EFAULT;
 		}
+
+		unxlate_dev_mem_ptr(p, ptr);
+
 		buf += sz;
 		p += sz;
 		count -= sz;
@@ -231,6 +254,12 @@ static ssize_t write_mem(struct file * file, const char __user * buf,
 	return written;
 }
 
+int __attribute__((weak)) phys_mem_access_prot_allowed(struct file *file,
+	unsigned long pfn, unsigned long size, pgprot_t *vma_prot)
+{
+	return 1;
+}
+
 #ifndef __HAVE_PHYS_MEM_ACCESS_PROT
 static pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 				     unsigned long size, pgprot_t vma_prot)
@@ -271,6 +300,35 @@ static inline int private_mapping_ok(struct vm_area_struct *vma)
 }
 #endif
 
+void __attribute__((weak))
+map_devmem(unsigned long pfn, unsigned long len, pgprot_t prot)
+{
+	/* nothing. architectures can override. */
+}
+
+void __attribute__((weak))
+unmap_devmem(unsigned long pfn, unsigned long len, pgprot_t prot)
+{
+	/* nothing. architectures can override. */
+}
+
+static void mmap_mem_open(struct vm_area_struct *vma)
+{
+	map_devmem(vma->vm_pgoff,  vma->vm_end - vma->vm_start,
+			vma->vm_page_prot);
+}
+
+static void mmap_mem_close(struct vm_area_struct *vma)
+{
+	unmap_devmem(vma->vm_pgoff,  vma->vm_end - vma->vm_start,
+			vma->vm_page_prot);
+}
+
+static struct vm_operations_struct mmap_mem_ops = {
+	.open  = mmap_mem_open,
+	.close = mmap_mem_close
+};
+
 static int mmap_mem(struct file * file, struct vm_area_struct * vma)
 {
 	size_t size = vma->vm_end - vma->vm_start;
@@ -281,17 +339,28 @@ static int mmap_mem(struct file * file, struct vm_area_struct * vma)
 	if (!private_mapping_ok(vma))
 		return -ENOSYS;
 
+	if (!range_is_allowed(vma->vm_pgoff, size))
+		return -EPERM;
+
+	if (!phys_mem_access_prot_allowed(file, vma->vm_pgoff, size,
+						&vma->vm_page_prot))
+		return -EINVAL;
+
 	vma->vm_page_prot = phys_mem_access_prot(file, vma->vm_pgoff,
 						 size,
 						 vma->vm_page_prot);
 
+	vma->vm_ops = &mmap_mem_ops;
+
 	/* Remap-pfn-range will mark the range VM_IO and VM_RESERVED */
 	if (remap_pfn_range(vma,
 			    vma->vm_start,
 			    vma->vm_pgoff,
 			    size,
-			    vma->vm_page_prot))
+			    vma->vm_page_prot)) {
+		unmap_devmem(vma->vm_pgoff, size, vma->vm_page_prot);
 		return -EAGAIN;
+	}
 	return 0;
 }
 
diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
index 67dc84c..76b0cc5 100644
--- a/include/asm-generic/iomap.h
+++ b/include/asm-generic/iomap.h
@@ -60,6 +60,10 @@ extern void iowrite32_rep(void __iomem *port, const void *buf, unsigned long cou
 extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
 extern void ioport_unmap(void __iomem *);
 
+#ifndef ARCH_HAS_IOREMAP_WC
+#define ioremap_wc ioremap_nocache
+#endif
+
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
 extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
diff --git a/include/asm-x86/io.h b/include/asm-x86/io.h
index 7b292d3..d5b11f6 100644
--- a/include/asm-x86/io.h
+++ b/include/asm-x86/io.h
@@ -1,3 +1,6 @@
+#ifndef _ASM_X86_IO_H
+#define _ASM_X86_IO_H
+
 #define ARCH_HAS_IOREMAP_WC
 
 #ifdef CONFIG_X86_32
@@ -5,7 +8,12 @@
 #else
 # include "io_64.h"
 #endif
+
+extern void *xlate_dev_mem_ptr(unsigned long phys);
+extern void unxlate_dev_mem_ptr(unsigned long phys, void *addr);
+
 extern int ioremap_change_attr(unsigned long vaddr, unsigned long size,
 				unsigned long prot_val);
 extern void __iomem *ioremap_wc(unsigned long offset, unsigned long size);
 
+#endif /* _ASM_X86_IO_H */
diff --git a/include/asm-x86/io_32.h b/include/asm-x86/io_32.h
index 509045f..6e73467 100644
--- a/include/asm-x86/io_32.h
+++ b/include/asm-x86/io_32.h
@@ -49,12 +49,6 @@
 #include <linux/vmalloc.h>
 
 /*
- * Convert a physical pointer to a virtual kernel pointer for /dev/mem
- * access
- */
-#define xlate_dev_mem_ptr(p)	__va(p)
-
-/*
  * Convert a virtual cached pointer to an uncached pointer
  */
 #define xlate_dev_kmem_ptr(p)	p
diff --git a/include/asm-x86/io_64.h b/include/asm-x86/io_64.h
index c2f5eef..0930bed 100644
--- a/include/asm-x86/io_64.h
+++ b/include/asm-x86/io_64.h
@@ -308,12 +308,6 @@ extern int iommu_bio_merge;
 #define BIO_VMERGE_BOUNDARY iommu_bio_merge
 
 /*
- * Convert a physical pointer to a virtual kernel pointer for /dev/mem
- * access
- */
-#define xlate_dev_mem_ptr(p)	__va(p)
-
-/*
  * Convert a virtual cached pointer to an uncached pointer
  */
 #define xlate_dev_kmem_ptr(p)	p
diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
index 6724a4b..b381f4a 100644
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -47,6 +47,7 @@
 #ifndef __ASSEMBLY__
 
 extern int page_is_ram(unsigned long pagenr);
+extern int devmem_is_allowed(unsigned long pagenr);
 
 extern unsigned long max_pfn_mapped;
 
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index f1d9f4a..1902f0a 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -289,6 +289,15 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 
 #define canon_pgprot(p) __pgprot(pgprot_val(p) & __supported_pte_mask)
 
+#ifndef __ASSEMBLY__
+#define __HAVE_PHYS_MEM_ACCESS_PROT
+struct file;
+pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
+                              unsigned long size, pgprot_t vma_prot);
+int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
+                              unsigned long size, pgprot_t *vma_prot);
+#endif
+
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else  /* !CONFIG_PARAVIRT */
