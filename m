Return-Path: <linux-kernel-owner+w=401wt.eu-S1758961AbYE0RCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbYE0RCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 13:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757143AbYE0RCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 13:02:48 -0400
Received: from mailout02.t-online.de ([194.25.134.17]:41509 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716AbYE0RCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 13:02:46 -0400
X-Greylist: delayed 1556 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 May 2008 13:02:45 EDT
Message-ID: <483C3874.9010004@t-online.de>
Date: Tue, 27 May 2008 18:36:04 +0200
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080506)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: David Howells <dhowells@redhat.com>, Greg Ungerer <gerg@snapgear.com>,
       David McCullough <davidm@snapgear.com>,
       Paul Mundt <lethal@linux-sh.org>, Matt Mackall <mpm@selenic.com>,
       "Wu, Bryan" <Bryan.Wu@analog.com>,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: [PATCH, RFD] Unbreaking nommu mmap, v2
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------000103010505050906080206"
X-ID: bKP4YgZT8h3cHMVjuVQAYtoVVUQDCpoYKsKXEvBHpuBg-8hP5FchUet6+I+enJrgke
X-TOI-MSGID: 2a9aae72-d453-4dd8-8bc1-90c8e83f2202
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000103010505050906080206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

A while ago (*) I sent out a patch to change mmap behaviour on nommu 
targets.  Currently, the kernel requires a munmap call for every mmap, 
with the exact same address range; this is inconsistent with behaviour 
on mmu systems, and complicates the malloc implementation in uClibc. 
uClibc's malloc requires that the UCLIBC_UCLINUX_BROKEN_MUNMAP config 
option is used, which introduces additional overhead, and isn't thread 
safe in the upstream version of uClibc.

To summarize the comments I got last time:
  - Better interface: MAP_SPLIT_PAGES has been renamed MAP_TRIM_EXCESS
  - Several people complained about a few Blackfin-specific items which
    I've hopefully eliminated.  MAP_TRIM_EXCESS was added to all
    architectures which can be compiled as nommu.
  - Matt Mackall was worried about increased overhead for programs using
    simplemalloc; however, simplemalloc (which does a mmap system call
    for every call to malloc) has incredible time and space overhead
    anyway, and it is to be hoped that either no one is using it, or they
    can switch to a sane malloc implementation.
  - David Howells worried that the kernel might get confused when
    unmapping a shared mmap of a file which has been mapped multiple
    times in the same process.  The intent seems to be to share the
    memory for these multiple maps, but this fails in practice even on
    an unpatched kernel: when I ran a test program to map the same file
    twice, I triggered this BUG_ON in add_nommu_vma:
                /* mappings are at the same address - this can only
                 * happen for shared-mem chardevs and shared file
                 * mappings backed by ramfs/tmpfs */
                BUG_ON(!(pvma->vm_flags & VM_SHARED));
    Also, even without this patch, I'm not sure how unmapping could be
    handled sanely in this case.

Apart from these comments, most people seemed to be ok with the basic 
approach.

I'd like to submit this for inclusion.  Any acks or objections?


Bernd

(*) http://lkml.org/lkml/2007/6/8/239
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif


--------------000103010505050906080206
Content-Type: text/x-patch;
 name="nommu-mmap3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nommu-mmap3.diff"

Make nommu mmap more consistent with mmu mmap behaviour.

This changes nommu mmap/munmap in the following ways:
1. munmap can now unmap subparts of previously allocated blocks.  This
   makes behaviour more consistent with mmu Linux, and allows us to
   simplify and speed up the uClibc malloc implementation.
2. It is no longer possible to get blocks smaller than a page through
   mmap.  This behaviour was used by simplemalloc, which is an insane
   way of implementing malloc on nommu systems and hopefully not used
   by anyone anymore.
3. mmap can now be asked not to round up the allocation to the next
   power of 2 page size.  Excess pages will be freed if MAP_TRIM_EXCESS
   is passed to mmap.
   If this flag is used, more memory is kept available, but fragmentation
   appears to be higher.

Every VMA can be in two states: either it manages a power-of-2 sized compound
page, or (if VM_SPLIT_PAGES) is set, a set of single pages exactly covering
the area between vm_start and vm_end.

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index ddd35d8..6f66644 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -167,9 +167,6 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 	struct elf_fdpic_params exec_params, interp_params;
 	struct elf_phdr *phdr;
 	unsigned long stack_size, entryaddr;
-#ifndef CONFIG_MMU
-	unsigned long fullsize;
-#endif
 #ifdef ELF_FDPIC_PLAT_INIT
 	unsigned long dynaddr;
 #endif
@@ -389,11 +386,6 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 		goto error_kill;
 	}
 
-	/* expand the stack mapping to use up the entire allocation granule */
-	fullsize = ksize((char *) current->mm->start_brk);
-	if (!IS_ERR_VALUE(do_mremap(current->mm->start_brk, stack_size,
-				    fullsize, 0, 0)))
-		stack_size = fullsize;
 	up_write(&current->mm->mmap_sem);
 
 	current->mm->brk = current->mm->start_brk;
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 3b40d45..ce50000 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -417,8 +417,8 @@ static int load_flat_file(struct linux_binprm * bprm,
 	unsigned long textpos = 0, datapos = 0, result;
 	unsigned long realdatastart = 0;
 	unsigned long text_len, data_len, bss_len, stack_len, flags;
-	unsigned long len, reallen, memp = 0;
-	unsigned long extra, rlim;
+	unsigned long len, memp = 0;
+	unsigned long memp_size, extra, rlim;
 	unsigned long *reloc = 0, *rp;
 	struct inode *inode;
 	int i, rev, relocs = 0;
@@ -543,17 +543,11 @@ static int load_flat_file(struct linux_binprm * bprm,
 		}
 
 		len = data_len + extra + MAX_SHARED_LIBS * sizeof(unsigned long);
+		len = PAGE_ALIGN(len);
 		down_write(&current->mm->mmap_sem);
 		realdatastart = do_mmap(0, 0, len,
-			PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE, 0);
-		/* Remap to use all availabe slack region space */
-		if (realdatastart && (realdatastart < (unsigned long)-4096)) {
-			reallen = ksize((void *)realdatastart);
-			if (reallen > len) {
-				realdatastart = do_mremap(realdatastart, len,
-					reallen, MREMAP_FIXED, realdatastart);
-			}
-		}
+							PROT_READ|PROT_WRITE|PROT_EXEC,
+							MAP_PRIVATE, 0);
 		up_write(&current->mm->mmap_sem);
 
 		if (realdatastart == 0 || realdatastart >= (unsigned long)-4096) {
@@ -592,20 +586,15 @@ static int load_flat_file(struct linux_binprm * bprm,
 		reloc = (unsigned long *) (datapos+(ntohl(hdr->reloc_start)-text_len));
 		memp = realdatastart;
 
+		memp_size = len;
 	} else {
 
 		len = text_len + data_len + extra + MAX_SHARED_LIBS * sizeof(unsigned long);
+		len = PAGE_ALIGN(len);
 		down_write(&current->mm->mmap_sem);
 		textpos = do_mmap(0, 0, len,
-			PROT_READ | PROT_EXEC | PROT_WRITE, MAP_PRIVATE, 0);
-		/* Remap to use all availabe slack region space */
-		if (textpos && (textpos < (unsigned long) -4096)) {
-			reallen = ksize((void *)textpos);
-			if (reallen > len) {
-				textpos = do_mremap(textpos, len, reallen,
-					MREMAP_FIXED, textpos);
-			}
-		}
+						PROT_READ | PROT_EXEC | PROT_WRITE,
+						MAP_PRIVATE, 0);
 		up_write(&current->mm->mmap_sem);
 
 		if (!textpos  || textpos >= (unsigned long) -4096) {
@@ -622,7 +611,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 		reloc = (unsigned long *) (textpos + ntohl(hdr->reloc_start) +
 				MAX_SHARED_LIBS * sizeof(unsigned long));
 		memp = textpos;
-
+		memp_size = len;
 #ifdef CONFIG_BINFMT_ZFLAT
 		/*
 		 * load it all in and treat it like a RAM load from now on
@@ -680,10 +669,12 @@ static int load_flat_file(struct linux_binprm * bprm,
 		 * set up the brk stuff, uses any slack left in data/bss/stack
 		 * allocation.  We put the brk after the bss (between the bss
 		 * and stack) like other platforms.
+		 * Userspace code relies on the stack pointer starting out at
+		 * an address right at the end of a page.
 		 */
 		current->mm->start_brk = datapos + data_len + bss_len;
 		current->mm->brk = (current->mm->start_brk + 3) & ~3;
-		current->mm->context.end_brk = memp + ksize((void *) memp) - stack_len;
+		current->mm->context.end_brk = memp + memp_size - stack_len;
 	}
 
 	if (flags & FLAT_FLAG_KTRACE)
@@ -790,7 +781,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 
 	/* zero the BSS,  BRK and stack areas */
 	memset((void*)(datapos + data_len), 0, bss_len + 
-			(memp + ksize((void *) memp) - stack_len -	/* end brk */
+			(memp + memp_size - stack_len -			/* end brk */
 			libinfo->lib_list[id].start_brk) +		/* start brk */
 			stack_len);
 
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 4b4f9cc..987bc69 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -20,20 +20,26 @@ void task_mem(struct seq_file *m, struct mm_struct *mm)
         
 	down_read(&mm->mmap_sem);
 	for (vml = mm->context.vmlist; vml; vml = vml->next) {
+		unsigned long size, len;
+
 		if (!vml->vma)
 			continue;
 
 		bytes += kobjsize(vml);
+		len = vml->vma->vm_end - vml->vma->vm_start;
+		if (!(vml->vma->vm_flags & VM_SPLIT_PAGES))
+			size = PAGE_SIZE << get_order(len);
+		else
+			size = len;
 		if (atomic_read(&mm->mm_count) > 1 ||
 		    atomic_read(&vml->vma->vm_usage) > 1
 		    ) {
-			sbytes += kobjsize((void *) vml->vma->vm_start);
+			sbytes += size;
 			sbytes += kobjsize(vml->vma);
 		} else {
-			bytes += kobjsize((void *) vml->vma->vm_start);
+			bytes += size;
 			bytes += kobjsize(vml->vma);
-			slack += kobjsize((void *) vml->vma->vm_start) -
-				(vml->vma->vm_end - vml->vma->vm_start);
+			slack += size - len;
 		}
 	}
 
@@ -76,7 +82,7 @@ unsigned long task_vsize(struct mm_struct *mm)
 	down_read(&mm->mmap_sem);
 	for (tbp = mm->context.vmlist; tbp; tbp = tbp->next) {
 		if (tbp->vma)
-			vsize += kobjsize((void *) tbp->vma->vm_start);
+			vsize += tbp->vma->vm_end - tbp->vma->vm_start;
 	}
 	up_read(&mm->mmap_sem);
 	return vsize;
@@ -93,7 +99,7 @@ int task_statm(struct mm_struct *mm, int *shared, int *text,
 		size += kobjsize(tbp);
 		if (tbp->vma) {
 			size += kobjsize(tbp->vma);
-			size += kobjsize((void *) tbp->vma->vm_start);
+			size += tbp->vma->vm_end - tbp->vma->vm_start;
 		}
 	}
 
diff --git a/include/asm-arm/mman.h b/include/asm-arm/mman.h
index 54570d2..ca30d1f 100644
--- a/include/asm-arm/mman.h
+++ b/include/asm-arm/mman.h
@@ -10,6 +10,7 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) page tables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_TRIM_EXCESS	0x20000		/* Conserve memory (nommu only). */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/include/asm-blackfin/mman.h b/include/asm-blackfin/mman.h
index b58f5ad..5f52b7b 100644
--- a/include/asm-blackfin/mman.h
+++ b/include/asm-blackfin/mman.h
@@ -22,6 +22,7 @@
 #define MAP_NORESERVE	0x4000	/* don't check for reservations */
 #define MAP_POPULATE	0x8000	/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000	/* do not block on IO */
+#define MAP_TRIM_EXCESS	0x20000	/* Conserve memory (nommu only). */
 
 #define MS_ASYNC	1	/* sync memory asynchronously */
 #define MS_INVALIDATE	2	/* invalidate the caches */
diff --git a/include/asm-frv/mman.h b/include/asm-frv/mman.h
index b4371e9..b692b61 100644
--- a/include/asm-frv/mman.h
+++ b/include/asm-frv/mman.h
@@ -10,6 +10,7 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_TRIM_EXCESS	0x20000		/* Conserve memory (nommu only). */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/include/asm-generic/mman.h b/include/asm-generic/mman.h
index 5e3dde2..b23d433 100644
--- a/include/asm-generic/mman.h
+++ b/include/asm-generic/mman.h
@@ -19,6 +19,7 @@
 #define MAP_TYPE	0x0f		/* Mask for type of mapping */
 #define MAP_FIXED	0x10		/* Interpret addr exactly */
 #define MAP_ANONYMOUS	0x20		/* don't use a file */
+#define MAP_TRIM_EXCESS	0x40		/* Conserve memory (nommu only). */
 
 #define MS_ASYNC	1		/* sync memory asynchronously */
 #define MS_INVALIDATE	2		/* invalidate the caches */
diff --git a/include/asm-h8300/mman.h b/include/asm-h8300/mman.h
index b9f104f..3a23bd1 100644
--- a/include/asm-h8300/mman.h
+++ b/include/asm-h8300/mman.h
@@ -10,6 +10,7 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_TRIM_EXCESS	0x20000		/* Conserve memory (nommu only). */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/include/asm-m32r/mman.h b/include/asm-m32r/mman.h
index 516a897..2ac7fd2 100644
--- a/include/asm-m32r/mman.h
+++ b/include/asm-m32r/mman.h
@@ -10,6 +10,7 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_TRIM_EXCESS	0x20000		/* Conserve memory (nommu only). */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/include/asm-m68k/mman.h b/include/asm-m68k/mman.h
index 1626d37..6353ac9 100644
--- a/include/asm-m68k/mman.h
+++ b/include/asm-m68k/mman.h
@@ -10,6 +10,7 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_TRIM_EXCESS	0x20000		/* Conserve memory (nommu only). */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/include/asm-sh/mman.h b/include/asm-sh/mman.h
index 156eb02..d4bb8df 100644
--- a/include/asm-sh/mman.h
+++ b/include/asm-sh/mman.h
@@ -10,6 +10,7 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) page tables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_TRIM_EXCESS	0x20000		/* Conserve memory (nommu only). */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/include/asm-v850/mman.h b/include/asm-v850/mman.h
index edbf6ed..ac49743 100644
--- a/include/asm-v850/mman.h
+++ b/include/asm-v850/mman.h
@@ -8,6 +8,7 @@
 #define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
 #define MAP_LOCKED	0x2000		/* pages are locked */
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
+#define MAP_TRIM_EXCESS	0x20000		/* Conserve memory (nommu only). */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index c31a9cd..3a73a55 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -108,6 +108,7 @@ extern unsigned int kobjsize(const void *objp);
 
 #define VM_CAN_NONLINEAR 0x08000000	/* Has ->fault & does nonlinear pages */
 #define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
+#define VM_SPLIT_PAGES	0x20000000	/* T if split_page was used (nommu mmap) */
 
 #ifndef VM_STACK_DEFAULT_FLAGS		/* arch can override this */
 #define VM_STACK_DEFAULT_FLAGS VM_DATA_DEFAULT_FLAGS
@@ -307,6 +308,7 @@ void put_page(struct page *page);
 void put_pages_list(struct list_head *pages);
 
 void split_page(struct page *page, unsigned int order);
+void split_compound_page(struct page *page, unsigned int order);
 
 /*
  * Compound pages have a destructor function.  Provide a
diff --git a/mm/nommu.c b/mm/nommu.c
index ef8c62c..7adc24d 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -38,7 +38,6 @@ void *high_memory;
 struct page *mem_map;
 unsigned long max_mapnr;
 unsigned long num_physpages;
-unsigned long askedalloc, realalloc;
 atomic_t vm_committed_space = ATOMIC_INIT(0);
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50; /* default is 50% */
@@ -371,6 +370,25 @@ static void show_process_blocks(void)
 #endif /* DEBUG */
 
 /*
+ * Free the memory allocated for a VMA.
+ */
+static void free_vma_pages(struct vm_area_struct *vma)
+{
+	unsigned long len = vma->vm_end - vma->vm_start;
+
+	if (vma->vm_flags & VM_SPLIT_PAGES)
+		while (len) {
+			free_pages(vma->vm_start, 0);
+			vma->vm_start += PAGE_SIZE;
+			len -= PAGE_SIZE;
+		}
+	else {
+		struct page *p = virt_to_page(vma->vm_start);
+		free_pages(vma->vm_start, (unsigned long)p[1].lru.prev);
+	}
+}
+
+/*
  * add a VMA into a process's mm_struct in the appropriate place in the list
  * - should be called with mm->mmap_sem held writelocked
  */
@@ -444,28 +462,6 @@ static inline struct vm_area_struct *find_vma_exact(struct mm_struct *mm,
 }
 
 /*
- * find a VMA in the global tree
- */
-static inline struct vm_area_struct *find_nommu_vma(unsigned long start)
-{
-	struct vm_area_struct *vma;
-	struct rb_node *n = nommu_vma_tree.rb_node;
-
-	while (n) {
-		vma = rb_entry(n, struct vm_area_struct, vm_rb);
-
-		if (start < vma->vm_start)
-			n = n->rb_left;
-		else if (start > vma->vm_start)
-			n = n->rb_right;
-		else
-			return vma;
-	}
-
-	return NULL;
-}
-
-/*
  * add a VMA in the global tree
  */
 static void add_nommu_vma(struct vm_area_struct *vma)
@@ -535,6 +531,89 @@ static void delete_nommu_vma(struct vm_area_struct *vma)
 }
 
 /*
+ * Split up a large order allocation for the vma into single pages and
+ * set the VM_SPLIT_PAGES flag.  Free any excess pages beyond the end of
+ * the vma.
+ */
+static void nommu_split_pages(struct vm_area_struct *vma)
+{
+	int order;
+	struct page *page;
+	unsigned long to_free, size;
+
+	if (vma->vm_flags & VM_SPLIT_PAGES)
+		return;
+
+	page = virt_to_page(vma->vm_start);
+	size = PAGE_ALIGN(vma->vm_end - vma->vm_start);
+	order = (unsigned long)page[1].lru.prev;
+
+	split_compound_page(page, order);
+	vma->vm_flags |= VM_SPLIT_PAGES;
+
+	to_free = (PAGE_SIZE << order) - size;
+	while (to_free) {
+		to_free -= PAGE_SIZE;
+		free_pages(vma->vm_end + to_free, 0);
+	}
+}
+
+
+/*
+ * Split a vma into two pieces at address 'addr', a new vma is allocated
+ * either for the first part or the the tail.
+ */
+static int split_nommu_vma(struct mm_struct * mm, struct vm_area_struct * vma,
+			   unsigned long addr, int new_below,
+			   struct vm_list_struct **insert_point)
+{
+	struct vm_area_struct *new;
+	struct vm_list_struct *vml = NULL;
+
+	if (vma->vm_flags & VM_SHARED)
+		return -EINVAL;
+	if (vma->vm_file)
+		return -EINVAL;
+	if (mm->map_count >= sysctl_max_map_count)
+		return -ENOMEM;
+
+	new = kmalloc(sizeof(struct vm_area_struct), GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+	vml = kzalloc(sizeof(struct vm_list_struct), GFP_KERNEL);
+	if (!vml) {
+		kfree(new);
+		return -ENOMEM;
+	}
+
+	nommu_split_pages(vma);
+	/* most fields are the same, copy all, and then fixup */
+	*new = *vma;
+
+	if (new_below) {
+		vma->vm_start = addr;
+		vma->vm_pgoff += (addr - new->vm_start) >> PAGE_SHIFT;
+
+		new->vm_end = addr;
+	} else {
+		new->vm_start = addr;
+		new->vm_pgoff += (addr - vma->vm_start) >> PAGE_SHIFT;
+
+		vma->vm_end = addr;
+	}
+
+	if (new->vm_ops && new->vm_ops->open)
+		new->vm_ops->open(new);
+
+	add_nommu_vma(new);
+	vml->vma = new;
+	vml->next = *insert_point;
+	*insert_point = vml;
+
+	return 0;
+}
+
+/*
  * determine whether a mapping should be permitted and, if so, what sort of
  * mapping we're capable of supporting
  */
@@ -765,10 +844,12 @@ static int do_mmap_shared_file(struct vm_area_struct *vma, unsigned long len)
 /*
  * set up a private mapping or an anonymous shared mapping
  */
-static int do_mmap_private(struct vm_area_struct *vma, unsigned long len)
+static int do_mmap_private(struct vm_area_struct *vma, unsigned long len,
+			   unsigned long flags)
 {
 	void *base;
-	int ret;
+	int ret, order;
+	unsigned long total_len = len;
 
 	/* invoke the file's mapping function so that it can keep track of
 	 * shared mappings on devices or memory
@@ -787,11 +868,16 @@ static int do_mmap_private(struct vm_area_struct *vma, unsigned long len)
 		 * make a private copy of the data and map that instead */
 	}
 
+	len = PAGE_ALIGN(len);
+
 	/* allocate some memory to hold the mapping
 	 * - note that this may not return a page-aligned address if the object
 	 *   we're allocating is smaller than a page
 	 */
-	base = kmalloc(len, GFP_KERNEL|__GFP_COMP);
+	order = get_order(len);
+	total_len = PAGE_SIZE << order;
+
+	base = (void *)__get_free_pages(GFP_KERNEL|__GFP_COMP, order);
 	if (!base)
 		goto enomem;
 
@@ -799,8 +885,17 @@ static int do_mmap_private(struct vm_area_struct *vma, unsigned long len)
 	vma->vm_end = vma->vm_start + len;
 	vma->vm_flags |= VM_MAPPED_COPY;
 
+	/*
+	 * Must always set the VM_SPLIT_PAGES flag for single-page allocations,
+	 * to avoid trying to get the order of the compound page later on.
+	 */
+	if (len == PAGE_SIZE)
+		vma->vm_flags |= VM_SPLIT_PAGES;
+	else if (flags & MAP_TRIM_EXCESS)
+		nommu_split_pages(vma);
+
 #ifdef WARN_ON_SLACK
-	if (len + WARN_ON_SLACK <= kobjsize(result))
+	if (len + WARN_ON_SLACK <= total_len)
 		printk("Allocation of %lu bytes from process %d has %lu bytes of slack\n",
 		       len, current->pid, kobjsize(result) - len);
 #endif
@@ -833,7 +928,7 @@ static int do_mmap_private(struct vm_area_struct *vma, unsigned long len)
 	return 0;
 
 error_free:
-	kfree(base);
+	free_vma_pages(vma);
 	vma->vm_start = 0;
 	return ret;
 
@@ -985,29 +1080,18 @@ unsigned long do_mmap_pgoff(struct file *file,
 	if (file && vma->vm_flags & VM_SHARED)
 		ret = do_mmap_shared_file(vma, len);
 	else
-		ret = do_mmap_private(vma, len);
+		ret = do_mmap_private(vma, len, flags);
 	if (ret < 0)
 		goto error;
 
 	/* okay... we have a mapping; now we have to register it */
 	result = (void *) vma->vm_start;
 
-	if (vma->vm_flags & VM_MAPPED_COPY) {
-		realalloc += kobjsize(result);
-		askedalloc += len;
-	}
-
-	realalloc += kobjsize(vma);
-	askedalloc += sizeof(*vma);
-
 	current->mm->total_vm += len >> PAGE_SHIFT;
 
 	add_nommu_vma(vma);
 
  shared:
-	realalloc += kobjsize(vml);
-	askedalloc += sizeof(*vml);
-
 	add_vma_to_mm(current->mm, vml);
 
 	up_write(&nommu_vma_sem);
@@ -1074,14 +1158,8 @@ static void put_vma(struct mm_struct *mm, struct vm_area_struct *vma)
 
 			/* IO memory and memory shared directly out of the pagecache from
 			 * ramfs/tmpfs mustn't be released here */
-			if (vma->vm_flags & VM_MAPPED_COPY) {
-				realalloc -= kobjsize((void *) vma->vm_start);
-				askedalloc -= vma->vm_end - vma->vm_start;
-				kfree((void *) vma->vm_start);
-			}
-
-			realalloc -= kobjsize(vma);
-			askedalloc -= sizeof(*vma);
+			if (vma->vm_flags & VM_MAPPED_COPY)
+				free_vma_pages(vma);
 
 			if (vma->vm_file) {
 				fput(vma->vm_file);
@@ -1095,45 +1173,86 @@ static void put_vma(struct mm_struct *mm, struct vm_area_struct *vma)
 	}
 }
 
+static void unmap_one_vma (struct mm_struct *mm, struct vm_area_struct *vma,
+			   struct vm_list_struct **parent)
+{
+	struct vm_list_struct *vml;
+	size_t len = vma->vm_end - vma->vm_start;
+	vml = *parent;
+
+	put_vma(mm, vml->vma);
+
+	*parent = vml->next;
+	kfree(vml);
+
+	update_hiwater_vm(mm);
+	mm->total_vm -= len >> PAGE_SHIFT;
+	mm->map_count--;
+}
 /*
  * release a mapping
- * - under NOMMU conditions the parameters must match exactly to the mapping to
- *   be removed
+ * Under NOMMU conditions the parameters must match exactly to the mapping to
+ * be removed.  However, we can relax this requirement for anonymous memory, to
+ * make malloc's job a little easier.
  */
 int do_munmap(struct mm_struct *mm, unsigned long addr, size_t len)
 {
-	struct vm_list_struct *vml, **parent;
-	unsigned long end = addr + len;
+	struct vm_list_struct **parent;
+	unsigned long end;
+	struct vm_area_struct *vma = 0;
 
 #ifdef DEBUG
 	printk("do_munmap:\n");
 #endif
 
-	for (parent = &mm->context.vmlist; *parent; parent = &(*parent)->next) {
-		if ((*parent)->vma->vm_start > addr)
+	if ((len = PAGE_ALIGN(len)) == 0)
+		return -EINVAL;
+	end = addr + len;
+	for (parent = &mm->context.vmlist; *parent;) {
+		int err;
+		vma = (*parent)->vma;
+
+		/* If no overlap, try next one.  */
+		if (vma->vm_end <= addr) {
+			parent = &(*parent)->next;
+			continue;
+		}
+		/* Trying to unmap before the start of the VMA?  */
+		if (vma->vm_start > addr)
 			break;
-		if ((*parent)->vma->vm_start == addr &&
-		    ((len == 0) || ((*parent)->vma->vm_end == end)))
-			goto found;
-	}
 
-	printk("munmap of non-mmaped memory by process %d (%s): %p\n",
-	       current->pid, current->comm, (void *) addr);
-	return -EINVAL;
+		/* We found something that covers the area to unmap.  */
+		if (vma->vm_start < addr) {
+			err = split_nommu_vma(mm, vma, addr, 1, parent);
+			parent = &(*parent)->next;
+			if (err == -EINVAL)
+				break;
+			if (err)
+				return err;
+		}
+		if (vma->vm_end > end) {
+			err = split_nommu_vma(mm, vma, end, 0, &(*parent)->next);
+			if (err == -EINVAL)
+				break;
+			if (err)
+				return err;
+		}
 
- found:
-	vml = *parent;
+		/* Set up another round for the remaining area to unmap.  */
+		addr = vma->vm_end;
+		len -= PAGE_ALIGN(vma->vm_end - vma->vm_start);
 
-	put_vma(mm, vml->vma);
+		unmap_one_vma(mm, vma, parent);
 
-	*parent = vml->next;
-	realalloc -= kobjsize(vml);
-	askedalloc -= sizeof(*vml);
-	kfree(vml);
+		if (!len)
+			goto done;
+	}
 
-	update_hiwater_vm(mm);
-	mm->total_vm -= len >> PAGE_SHIFT;
+	printk(KERN_NOTICE "munmap of non-mmaped memory [%p-%p] by process %d (%s)\n",
+	       (void *)addr, (void *)addr+len, current->pid, current->comm);
+	return -EINVAL;
 
+ done:
 #ifdef DEBUG
 	show_process_blocks();
 #endif
@@ -1171,8 +1290,6 @@ void exit_mmap(struct mm_struct * mm)
 			mm->context.vmlist = tmp->next;
 			put_vma(mm, tmp->vma);
 
-			realalloc -= kobjsize(tmp);
-			askedalloc -= sizeof(*tmp);
 			kfree(tmp);
 		}
 
@@ -1202,6 +1319,7 @@ unsigned long do_mremap(unsigned long addr,
 			unsigned long flags, unsigned long new_addr)
 {
 	struct vm_area_struct *vma;
+	unsigned long max_len;
 
 	/* insanity checks first */
 	if (new_len == 0)
@@ -1220,14 +1338,25 @@ unsigned long do_mremap(unsigned long addr,
 	if (vma->vm_flags & VM_MAYSHARE)
 		return (unsigned long) -EPERM;
 
-	if (new_len > kobjsize((void *) addr))
+	if (vma->vm_flags & VM_SPLIT_PAGES)
+		max_len = old_len;
+	else {
+		struct page *page = virt_to_page(vma->vm_start);
+		int order = (int)page[1].lru.prev;
+		max_len = PAGE_SIZE << order;
+	}
+
+	if (new_len > max_len)
 		return (unsigned long) -ENOMEM;
 
 	/* all checks complete - do it */
 	vma->vm_end = vma->vm_start + new_len;
 
-	askedalloc -= old_len;
-	askedalloc += new_len;
+	if (vma->vm_flags & VM_SPLIT_PAGES)
+		while (old_len > new_len) {
+			old_len -= PAGE_SIZE;
+			free_pages(vma->vm_start + old_len, 0);
+		}
 
 	return vma->vm_start;
 }
@@ -1239,6 +1368,15 @@ asmlinkage unsigned long sys_mremap(unsigned long addr,
 {
 	unsigned long ret;
 
+	if (addr & ~PAGE_MASK)
+		return -EINVAL;
+
+	old_len = PAGE_ALIGN(old_len);
+	new_len = PAGE_ALIGN(new_len);
+
+	if (new_len == 0 || old_len == 0)
+		return -EINVAL;
+
 	down_write(&current->mm->mmap_sem);
 	ret = do_mremap(addr, old_len, new_len, flags, new_addr);
 	up_write(&current->mm->mmap_sem);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6383557..d573739 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1052,6 +1052,16 @@ void split_page(struct page *page, unsigned int order)
 }
 
 /*
+ * Like split_page, but calls destroy_compound_page first
+ */
+void split_compound_page(struct page *page, unsigned int order)
+{
+	VM_BUG_ON(!PageCompound(page));
+	destroy_compound_page(page, order);
+	split_page(page, order);
+}
+
+/*
  * Really, prep_compound_page() should be called from __rmqueue_bulk().  But
  * we cheat by calling it from here, in the order > 0 path.  Saves a branch
  * or two.

--------------000103010505050906080206--
