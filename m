Return-Path: <linux-kernel-owner+w=401wt.eu-S1758966AbXGZLkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbXGZLkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 07:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbXGZLkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 07:40:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbXGZLkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 07:40:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] ELF core dump options
In-Reply-To: Andrew Morton's message of  Thursday, 26 July 2007 03:06:05 -0700 <20070726030605.a0163ec2.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
X-Shopping-List: (1) Luminescent consolation robbers
   (2) Obsolescent hootenanny animals
   (3) Belligerent flotation doodads
   (4) Icelandic Promotions
Message-Id: <20070726113924.6017C4D058D@magilla.localdomain>
Date: Thu, 26 Jul 2007 04:39:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It's a bit disappointing to route around the newly-added
> /proc/pid/coredump_filter.  It's inherited across fork so where's the
> problem?  Just set init's mask appropriately at boot if that's what you
> want.

I think it's actually a bit of a pain to manage to do something early
enough to get it inherited by absolutely everybody.  But I take your point.
I had this code kicking around for quite a while before I was sure it was
useful enough to submit.  I hadn't noticed the MMF_DUMP_* code before it
went in, and then just merged without thinking much about the new code.

The dump_whole_segments option is a rarity and just duplicates
MMF_DUMP_MAPPED_SHARED exactly, so there is no real need for that I guess.
(When I wrote it, it was the only way to turn that behavior on.)

The dump_elf_headers option is specific to binfmt_elf, unlike the existing
generic MMF_DUMP_* options.  But that is probably not a kind of separation
that anyone cares about.

Bottom line, I don't care all that much about the configuration mechanism.
I just want the dump_elf_headers feature available.  (I'm going to make it
the default in the Fedora 8 kernel anyway.)

I guess init scripts can just do:

for f in /proc/*/coredump_filter; do echo $[0x10 | $(cat $f)] > $f; done

to be sure they get everybody, assuming it's before anyone is busily
forking children in parallel you might miss between reading the list of
PIDs and diddling the parent.

> hm, I'm now wondering whether testing i_nlink was the best (or official)
> way of determining whether a MAP_SHARED vma is anonymous or file-backed.
> Hugh will know.

Well, it doesn't exactly test that it's not "file-backed".  (Technically
anything shared is file-backed, even if by a shmem virtual file.)  It tests
whether the backing file will probably ever be found on disk later.  That
gets shmem regions as well as originally-regular files that were deleted
while mapped.  I think we asked around when this test was put it and it was
deemed proper at the time.  (It doesn't really need to be a formal "what
does the vm situation mean" guarantee, just a practical "you probably
wanted that" test.)

> > +		    test_bit(MMF_DUMP_ANON_SHARED, &mm_flags) :
> > +		    test_bit(MMF_DUMP_MAPPED_SHARED, &mm_flags))
> 
> It was peculiar of us to use bitops against a local variable - normally
> we'd use open-coded &'s here.  Maybe it's OK - test_bit() is pretty cheap
> (on x86, at least), but one wonders whether gcc could do better if it knew
> what was going on.

I agree, it looked odd to me.  But I did not review (or notice) the
MMF_DUMP_* code before it went in, and this issue was unrelated to my
feature patch.

> The above makes elf_core_dump_sysctls[] inaccessible from here on.  It will
> warn, surely?

No, it was accessed the only place it will ever be needed, in the
initializer of binfmt_elf_sysctl_32bit_dir.


Thanks,
Roland


---
[PATCH] Add MMF_DUMP_ELF_HEADERS

This adds the MMF_DUMP_ELF_HEADERS option to /proc/pid/coredump_filter.
This dumps the first page (only) of a private file mapping if it appears
to be a mapping of an ELF file.  Including these pages in the core dump
may give sufficient identifying information to associate the original
DSO and executable file images and their debugging information with a
core file in a generic way just from its contents (e.g. when those
binaries were built with ld --build-id).  I expect this to become the
default behavior eventually.  Existing versions of gdb can be confused
by the core dumps it creates, so it won't enabled by default for some
time to come.  Soon many people will have systems with a gdb that handle
these dumps, so they can arrange to set the bit at boot and have it
inherited system-wide.

This also cleans up the checking of the MMF_DUMP_* flag bits, which did not
need to be using atomic macros.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 fs/binfmt_elf.c       |   78 +++++++++++++++++++++++++++++++++---------------
 include/linux/sched.h |    3 +-
 2 files changed, 55 insertions(+), 26 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 4482a06..3fb5a75 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1193,35 +1193,68 @@ static int dump_seek(struct file *file, loff_t off)
 }
 
 /*
- * Decide whether a segment is worth dumping; default is yes to be
- * sure (missing info is worse than too much; etc).
- * Personally I'd include everything, and use the coredump limit...
- *
- * I think we should skip something. But I am not sure how. H.J.
+ * Decide what to dump of a segment, part, all or none.
  */
-static int maydump(struct vm_area_struct *vma, unsigned long mm_flags)
+static unsigned long vma_dump_size(struct vm_area_struct *vma,
+				   unsigned long mm_flags)
 {
 	/* The vma can be set up to tell us the answer directly.  */
 	if (vma->vm_flags & VM_ALWAYSDUMP)
-		return 1;
+		goto whole;
 
 	/* Do not dump I/O mapped devices or special mappings */
 	if (vma->vm_flags & (VM_IO | VM_RESERVED))
 		return 0;
 
+#define FILTER(type)	(mm_flags & (1UL << MMF_DUMP_##type))
+
 	/* By default, dump shared memory if mapped from an anonymous file. */
 	if (vma->vm_flags & VM_SHARED) {
-		if (vma->vm_file->f_path.dentry->d_inode->i_nlink == 0)
-			return test_bit(MMF_DUMP_ANON_SHARED, &mm_flags);
-		else
-			return test_bit(MMF_DUMP_MAPPED_SHARED, &mm_flags);
+		if (vma->vm_file->f_path.dentry->d_inode->i_nlink == 0 ?
+		    FILTER(ANON_SHARED) : FILTER(MAPPED_SHARED))
+			goto whole;
+		return 0;
 	}
 
-	/* By default, if it hasn't been written to, don't write it out. */
-	if (!vma->anon_vma)
-		return test_bit(MMF_DUMP_MAPPED_PRIVATE, &mm_flags);
+	/* Dump segments that have been written to.  */
+	if (vma->anon_vma && FILTER(ANON_PRIVATE))
+		goto whole;
+	if (vma->vm_file == NULL)
+		return 0;
 
-	return test_bit(MMF_DUMP_ANON_PRIVATE, &mm_flags);
+	if (FILTER(MAPPED_PRIVATE))
+		goto whole;
+
+	/*
+	 * If this looks like the beginning of a DSO or executable mapping,
+	 * check for an ELF header.  If we find one, dump the first page to
+	 * aid in determining what was mapped here.
+	 */
+	if (FILTER(ELF_HEADERS) && vma->vm_file != NULL && vma->vm_pgoff == 0) {
+		u32 __user *header = (u32 __user *) vma->vm_start;
+		u32 word;
+		/*
+		 * Doing it this way gets the constant folded by GCC.
+		 */
+		union {
+			u32 cmp;
+			char elfmag[SELFMAG];
+		} magic;
+		BUILD_BUG_ON(SELFMAG != sizeof word);
+		magic.elfmag[EI_MAG0] = ELFMAG0;
+		magic.elfmag[EI_MAG1] = ELFMAG1;
+		magic.elfmag[EI_MAG2] = ELFMAG2;
+		magic.elfmag[EI_MAG3] = ELFMAG3;
+		if (get_user(word, header) == 0 && word == magic.cmp)
+			return PAGE_SIZE;
+	}
+
+#undef	FILTER
+
+	return 0;
+
+whole:
+	return vma->vm_end - vma->vm_start;
 }
 
 /* An ELF note in memory */
@@ -1668,16 +1701,13 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file)
 	for (vma = first_vma(current, gate_vma); vma != NULL;
 			vma = next_vma(vma, gate_vma)) {
 		struct elf_phdr phdr;
-		size_t sz;
-
-		sz = vma->vm_end - vma->vm_start;
 
 		phdr.p_type = PT_LOAD;
 		phdr.p_offset = offset;
 		phdr.p_vaddr = vma->vm_start;
 		phdr.p_paddr = 0;
-		phdr.p_filesz = maydump(vma, mm_flags) ? sz : 0;
-		phdr.p_memsz = sz;
+		phdr.p_filesz = vma_dump_size(vma, mm_flags);
+		phdr.p_memsz = vma->vm_end - vma->vm_start;
 		offset += phdr.p_filesz;
 		phdr.p_flags = vma->vm_flags & VM_READ ? PF_R : 0;
 		if (vma->vm_flags & VM_WRITE)
@@ -1719,13 +1749,11 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file)
 	for (vma = first_vma(current, gate_vma); vma != NULL;
 			vma = next_vma(vma, gate_vma)) {
 		unsigned long addr;
+		unsigned long end;
 
-		if (!maydump(vma, mm_flags))
-			continue;
+		end = vma->vm_start + vma_dump_size(vma, mm_flags);
 
-		for (addr = vma->vm_start;
-		     addr < vma->vm_end;
-		     addr += PAGE_SIZE) {
+		for (addr = vma->vm_start; addr < end; addr += PAGE_SIZE) {
 			struct page *page;
 			struct vm_area_struct *vma;
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 33b9b48..a41b9bd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -359,8 +359,9 @@ extern int get_dumpable(struct mm_struct *mm);
 #define MMF_DUMP_ANON_SHARED	3
 #define MMF_DUMP_MAPPED_PRIVATE	4
 #define MMF_DUMP_MAPPED_SHARED	5
+#define MMF_DUMP_ELF_HEADERS	6
 #define MMF_DUMP_FILTER_SHIFT	MMF_DUMPABLE_BITS
-#define MMF_DUMP_FILTER_BITS	4
+#define MMF_DUMP_FILTER_BITS	5
 #define MMF_DUMP_FILTER_MASK \
 	(((1 << MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
 #define MMF_DUMP_FILTER_DEFAULT \
