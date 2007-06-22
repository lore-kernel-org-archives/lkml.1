Return-Path: <linux-kernel-owner+w=401wt.eu-S1758401AbXFVO3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbXFVO3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 10:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756445AbXFVO3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 10:29:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756113AbXFVO3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 10:29:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NOMMU: Unbreak no-mmu mmap
To: bernds_cb1@t-online.de, Bryan.Wu@analog.com
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 22 Jun 2007 15:29:28 +0100
Message-ID: <20070622142928.18638.46209.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <46695F6D.5050600@t-online.de>
References: <46695F6D.5050600@t-online.de>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernd Schmidt <bernds_cb1@t-online.de>

Here's a patch to move nommu mmap/munmap ever so slightly closer to mmu
behaviour.  The motivation for this is to be able to deselect uClibc's
UCLIBC_UCLINUX_BROKEN_MUNMAP config option, which speeds up malloc a
fair bit.  I'm interested in comments whether this is a good direction
to go.  The patch is against Linus' tree as of a few minutes ago.

This changes nommu mmap/munmap in the following ways:
1. munmap can now unmap subparts of previously allocated blocks.  This
   makes behaviour more consistent with mmu Linux, and allows us to
   simplify and speed up the uClibc malloc implementation.
2. It is no longer possible to get blocks smaller than a page through
   mmap.  This behaviour was used by simplemalloc, which is an insane
   way of implementing malloc on nommu systems and hopefully not used
   by anyone anymore.
3. mmap can now be asked not to round up the allocation to the next
   power of 2 page size.  Excess pages will be freed if MAP_SPLIT_PAGES
   is passed to mmap.
   The latter is done for binfmt_flat and binfmt_elf_fdpic to save
   memory when loading executables.
   If this flag is used, more memory is kept available, but fragmentation
   may (or may not) be higher.

Every VMA can be in two states: either it manages a power-of-2 sized compound
page, or (if VM_SPLIT_PAGES) is set, a set of single pages exactly covering
the area between vm_start and vm_end.

Signed-off-by: Bernd Schmidt <bernds_cb1@t-online.de>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/binfmt_elf_fdpic.c       |   17 +-
 fs/binfmt_flat.c            |   40 ++----
 fs/proc/task_nommu.c        |   14 +-
 include/asm-blackfin/mman.h |    1 
 include/asm-frv/mman.h      |    3 
 include/linux/mm.h          |    2 
 mm/nommu.c                  |  294 ++++++++++++++++++++++++++++++++-----------
 mm/page_alloc.c             |   10 +
 8 files changed, 266 insertions(+), 115 deletions(-)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 9d62fba..bea3be0 100644
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
@@ -373,8 +370,8 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 	down_write(&current->mm->mmap_sem);
 	current->mm->start_brk = do_mmap(NULL, 0, stack_size,
 					 PROT_READ | PROT_WRITE | PROT_EXEC,
-					 MAP_PRIVATE | MAP_ANONYMOUS | MAP_GROWSDOWN,
-					 0);
+					 MAP_PRIVATE | MAP_ANONYMOUS |
+					 MAP_GROWSDOWN | MAP_SPLIT_PAGES, 0);
 
 	if (IS_ERR_VALUE(current->mm->start_brk)) {
 		up_write(&current->mm->mmap_sem);
@@ -383,11 +380,6 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 		goto error_kill;
 	}
 
-	/* expand the stack mapping to use up the entire allocation granule */
-	fullsize = ksize((char *) current->mm->start_brk);
-	if (!IS_ERR_VALUE(do_mremap(current->mm->start_brk, stack_size,
-				    fullsize, 0, 0)))
-		stack_size = fullsize;
 	up_write(&current->mm->mmap_sem);
 
 	current->mm->brk = current->mm->start_brk;
@@ -906,7 +898,8 @@ static int elf_fdpic_map_file_constdisp_on_uclinux(
 
 	down_write(&mm->mmap_sem);
 	maddr = do_mmap(NULL, load_addr, top - base,
-			PROT_READ | PROT_WRITE | PROT_EXEC, mflags, 0);
+			PROT_READ | PROT_WRITE | PROT_EXEC,
+			mflags | MAP_SPLIT_PAGES, 0);
 	up_write(&mm->mmap_sem);
 	if (IS_ERR_VALUE(maddr))
 		return (int) maddr;
@@ -1006,7 +999,7 @@ static int elf_fdpic_map_file_by_direct_mmap(struct elf_fdpic_params *params,
 		if (phdr->p_flags & PF_W) prot |= PROT_WRITE;
 		if (phdr->p_flags & PF_X) prot |= PROT_EXEC;
 
-		flags = MAP_PRIVATE | MAP_DENYWRITE;
+		flags = MAP_PRIVATE | MAP_DENYWRITE | MAP_SPLIT_PAGES;
 		if (params->flags & ELF_FDPIC_FLAG_EXECUTABLE)
 			flags |= MAP_EXECUTABLE;
 
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 861141b..63da3fb 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -419,8 +419,8 @@ static int load_flat_file(struct linux_binprm * bprm,
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
@@ -530,7 +530,9 @@ static int load_flat_file(struct linux_binprm * bprm,
 		DBG_FLT("BINFMT_FLAT: ROM mapping of file (we hope)\n");
 
 		down_write(&current->mm->mmap_sem);
-		textpos = do_mmap(bprm->file, 0, text_len, PROT_READ|PROT_EXEC, MAP_PRIVATE, 0);
+		textpos = do_mmap(bprm->file, 0, text_len,
+				  PROT_READ | PROT_EXEC,
+				  MAP_PRIVATE|MAP_SPLIT_PAGES, 0);
 		up_write(&current->mm->mmap_sem);
 		if (!textpos  || textpos >= (unsigned long) -4096) {
 			if (!textpos)
@@ -543,15 +545,8 @@ static int load_flat_file(struct linux_binprm * bprm,
 		len = data_len + extra + MAX_SHARED_LIBS * sizeof(unsigned long);
 		down_write(&current->mm->mmap_sem);
 		realdatastart = do_mmap(0, 0, len,
-			PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE, 0);
-		/* Remap to use all availabe slack region space */
-		if (realdatastart && (realdatastart < (unsigned long)-4096)) {
-			reallen = ksize(realdatastart);
-			if (reallen > len) {
-				realdatastart = do_mremap(realdatastart, len,
-					reallen, MREMAP_FIXED, realdatastart);
-			}
-		}
+					PROT_READ|PROT_WRITE|PROT_EXEC,
+					MAP_PRIVATE|MAP_SPLIT_PAGES, 0);
 		up_write(&current->mm->mmap_sem);
 
 		if (realdatastart == 0 || realdatastart >= (unsigned long)-4096) {
@@ -589,21 +584,14 @@ static int load_flat_file(struct linux_binprm * bprm,
 
 		reloc = (unsigned long *) (datapos+(ntohl(hdr->reloc_start)-text_len));
 		memp = realdatastart;
-
+		memp_size = len;
 	} else {
 
 		len = text_len + data_len + extra + MAX_SHARED_LIBS * sizeof(unsigned long);
 		down_write(&current->mm->mmap_sem);
 		textpos = do_mmap(0, 0, len,
-			PROT_READ | PROT_EXEC | PROT_WRITE, MAP_PRIVATE, 0);
-		/* Remap to use all availabe slack region space */
-		if (textpos && (textpos < (unsigned long) -4096)) {
-			reallen = ksize(textpos);
-			if (reallen > len) {
-				textpos = do_mremap(textpos, len, reallen,
-					MREMAP_FIXED, textpos);
-			}
-		}
+				  PROT_READ | PROT_EXEC | PROT_WRITE,
+				  MAP_PRIVATE | MAP_SPLIT_PAGES, 0);
 		up_write(&current->mm->mmap_sem);
 
 		if (!textpos  || textpos >= (unsigned long) -4096) {
@@ -620,7 +608,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 		reloc = (unsigned long *) (textpos + ntohl(hdr->reloc_start) +
 				MAX_SHARED_LIBS * sizeof(unsigned long));
 		memp = textpos;
-
+		memp_size = len;
 #ifdef CONFIG_BINFMT_ZFLAT
 		/*
 		 * load it all in and treat it like a RAM load from now on
@@ -681,7 +669,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 		 */
 		current->mm->start_brk = datapos + data_len + bss_len;
 		current->mm->brk = (current->mm->start_brk + 3) & ~3;
-		current->mm->context.end_brk = memp + ksize((void *) memp) - stack_len;
+		current->mm->context.end_brk = memp + memp_size - stack_len;
 	}
 
 	if (flags & FLAT_FLAG_KTRACE)
@@ -784,8 +772,8 @@ static int load_flat_file(struct linux_binprm * bprm,
 
 	/* zero the BSS,  BRK and stack areas */
 	memset((void*)(datapos + data_len), 0, bss_len + 
-			(memp + ksize((void *) memp) - stack_len -	/* end brk */
-			libinfo->lib_list[id].start_brk) +		/* start brk */
+			(memp + memp_size - stack_len -		/* end brk */
+			libinfo->lib_list[id].start_brk) +	/* start brk */
 			stack_len);
 
 	return 0;
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index d8b8c71..4b465ce 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -19,20 +19,26 @@ char *task_mem(struct mm_struct *mm, char *buffer)
         
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
 
diff --git a/include/asm-blackfin/mman.h b/include/asm-blackfin/mman.h
index 4d504f9..07057b6 100644
--- a/include/asm-blackfin/mman.h
+++ b/include/asm-blackfin/mman.h
@@ -24,6 +24,7 @@
 #define MAP_NONBLOCK	0x10000	/* do not block on IO */
 #define MAP_UNINITIALIZE 0x4000000  /* For anonymous mmap, memory could
                                     be uninitialized. */
+#define MAP_SPLIT_PAGES  0x8000000  /* Conserve memory (nommu only). */
 
 #define MS_ASYNC	1	/* sync memory asynchronously */
 #define MS_INVALIDATE	2	/* invalidate the caches */
diff --git a/include/asm-frv/mman.h b/include/asm-frv/mman.h
index b4371e9..d5f4a2a 100644
--- a/include/asm-frv/mman.h
+++ b/include/asm-frv/mman.h
@@ -10,6 +10,9 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_UNINITIALIZE 0x4000000	/* For anonymous mmap, memory could
+					   be uninitialized. */
+#define MAP_SPLIT_PAGES	0x8000000	/* Conserve memory (nommu only). */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1c12074..80d946c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -169,6 +169,7 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_MAPPED_COPY	0x01000000	/* T if mapped copy of data (nommu mmap) */
 #define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
 #define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
+#define VM_SPLIT_PAGES	0x08000000	/* T if split_page was used (nommu mmap) */
 
 #ifndef VM_STACK_DEFAULT_FLAGS		/* arch can override this */
 #define VM_STACK_DEFAULT_FLAGS VM_DATA_DEFAULT_FLAGS
@@ -305,6 +306,7 @@ void put_page(struct page *page);
 void put_pages_list(struct list_head *pages);
 
 void split_page(struct page *page, unsigned int order);
+void split_compound_page(struct page *page, unsigned int order);
 
 /*
  * Compound pages have a destructor function.  Provide a
diff --git a/mm/nommu.c b/mm/nommu.c
index 2b16b00..7480a95 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -36,7 +36,6 @@ void *high_memory;
 struct page *mem_map;
 unsigned long max_mapnr;
 unsigned long num_physpages;
-unsigned long askedalloc, realalloc;
 atomic_t vm_committed_space = ATOMIC_INIT(0);
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50; /* default is 50% */
@@ -320,6 +319,25 @@ static void show_process_blocks(void)
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
@@ -388,28 +406,6 @@ static inline struct vm_area_struct *find_vma_exact(struct mm_struct *mm,
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
@@ -479,6 +475,89 @@ static void delete_nommu_vma(struct vm_area_struct *vma)
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
@@ -709,10 +788,12 @@ static int do_mmap_shared_file(struct vm_area_struct *vma, unsigned long len)
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
@@ -731,11 +812,16 @@ static int do_mmap_private(struct vm_area_struct *vma, unsigned long len)
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
 
@@ -743,8 +829,21 @@ static int do_mmap_private(struct vm_area_struct *vma, unsigned long len)
 	vma->vm_end = vma->vm_start + len;
 	vma->vm_flags |= VM_MAPPED_COPY;
 
+	/*
+	 * Must always set the VM_SPLIT_PAGES flag for single-page allocations,
+	 * to avoid trying to get the order of the compound page later on.
+	 */
+	if (len == PAGE_SIZE)
+		vma->vm_flags |= VM_SPLIT_PAGES;
+	else if (flags & MAP_SPLIT_PAGES
+#ifdef CONFIG_NP2
+	    || len < total_len
+#endif
+	    )
+		nommu_split_pages(vma);
+
 #ifdef WARN_ON_SLACK
-	if (len + WARN_ON_SLACK <= kobjsize(result))
+	if (len + WARN_ON_SLACK <= total_len)
 		printk("Allocation of %lu bytes from process %d has %lu bytes of slack\n",
 		       len, current->pid, kobjsize(result) - len);
 #endif
@@ -777,7 +876,7 @@ static int do_mmap_private(struct vm_area_struct *vma, unsigned long len)
 	return 0;
 
 error_free:
-	kfree(base);
+	free_vma_pages(vma);
 	vma->vm_start = 0;
 	return ret;
 
@@ -921,29 +1020,18 @@ unsigned long do_mmap_pgoff(struct file *file,
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
@@ -1007,14 +1095,9 @@ static void put_vma(struct vm_area_struct *vma)
 			/* IO memory and memory shared directly out of the pagecache from
 			 * ramfs/tmpfs mustn't be released here */
 			if (vma->vm_flags & VM_MAPPED_COPY) {
-				realalloc -= kobjsize((void *) vma->vm_start);
-				askedalloc -= vma->vm_end - vma->vm_start;
-				kfree((void *) vma->vm_start);
+				free_vma_pages(vma);
 			}
 
-			realalloc -= kobjsize(vma);
-			askedalloc -= sizeof(*vma);
-
 			if (vma->vm_file)
 				fput(vma->vm_file);
 			kfree(vma);
@@ -1024,45 +1107,90 @@ static void put_vma(struct vm_area_struct *vma)
 	}
 }
 
+static void unmap_one_vma (struct mm_struct *mm, struct vm_area_struct *vma,
+			   struct vm_list_struct **parent)
+{
+	struct vm_list_struct *vml;
+	size_t len = vma->vm_end - vma->vm_start;
+	vml = *parent;
+
+	put_vma(vml->vma);
+
+	*parent = vml->next;
+	kfree(vml);
+
+	update_hiwater_vm(mm);
+	mm->total_vm -= len >> PAGE_SHIFT;
+	mm->map_count--;
+}
+
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
+	len = PAGE_ALIGN(len);
+	if (len == 0)
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
 
- found:
-	vml = *parent;
+		if (vma->vm_start < addr) {
+			err = split_nommu_vma(mm, vma, addr, 1, parent);
+			parent = &(*parent)->next;
+			if (err == -EINVAL)
+				break;
+			if (err)
+				return err;
+		}
+		if (vma->vm_end > end) {
+			err = split_nommu_vma(mm, vma, end, 0,
+					      &(*parent)->next);
+			if (err == -EINVAL)
+				break;
+			if (err)
+				return err;
+		}
 
-	put_vma(vml->vma);
+		/* Set up another round for the remaining area to unmap.  */
+		addr = vma->vm_end;
+		len -= vma->vm_end - vma->vm_start;
 
-	*parent = vml->next;
-	realalloc -= kobjsize(vml);
-	askedalloc -= sizeof(*vml);
-	kfree(vml);
+		unmap_one_vma(mm, vma, parent);
 
-	update_hiwater_vm(mm);
-	mm->total_vm -= len >> PAGE_SHIFT;
+		if (!len)
+			goto done;
+	}
 
+	printk("munmap of non-mmaped memory by process %d (%s): %p\n",
+	       current->pid, current->comm, (void *) addr);
+	return -EINVAL;
+
+ done:
 #ifdef DEBUG
 	show_process_blocks();
 #endif
@@ -1099,8 +1227,6 @@ void exit_mmap(struct mm_struct * mm)
 			mm->context.vmlist = tmp->next;
 			put_vma(tmp->vma);
 
-			realalloc -= kobjsize(tmp);
-			askedalloc -= sizeof(*tmp);
 			kfree(tmp);
 		}
 
@@ -1130,6 +1256,7 @@ unsigned long do_mremap(unsigned long addr,
 			unsigned long flags, unsigned long new_addr)
 {
 	struct vm_area_struct *vma;
+	unsigned long max_len;
 
 	/* insanity checks first */
 	if (new_len == 0)
@@ -1148,14 +1275,26 @@ unsigned long do_mremap(unsigned long addr,
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
+
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
@@ -1166,6 +1305,15 @@ asmlinkage unsigned long sys_mremap(unsigned long addr,
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
index 05ace44..fcc8e88 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -833,6 +833,16 @@ void split_page(struct page *page, unsigned int order)
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

