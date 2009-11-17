Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbZKRETx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbZKRETx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 23:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbZKRETw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 23:19:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756398AbZKRETv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 23:19:51 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 2/2] Pass mm->flags as a coredump parameter for
	consistency
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>
Date: Tue, 17 Nov 2009 18:54:01 -0500
Message-ID: <20091117235401.30900.70697.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091117235305.30900.43344.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091117235305.30900.43344.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass mm->flags as a coredump parameter for consistency.

 ---
1787         if (mm->core_state || !get_dumpable(mm)) {  <- (1)
1788                 up_write(&mm->mmap_sem);
1789                 put_cred(cred);
1790                 goto fail;
1791         }
1792
[...]
1798         if (get_dumpable(mm) == 2) {    /* Setuid core dump mode */ <-(2)
1799                 flag = O_EXCL;          /* Stop rewrite attacks */
1800                 cred->fsuid = 0;        /* Dump root private */
1801         }
 ---

Since dumpable bits are not protected by lock, there is a
chance to change these bits between (1) and (2).

To solve this issue, this patch copies mm->flags to
coredump_params.mm_flags at the beginning of do_coredump()                      and uses it instead of get_dumpable() while dumping core.

This copy is also passed to binfmt->core_dump, since
elf*_core_dump() uses dump_filter bits in mm->flags.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 fs/binfmt_elf.c         |   12 ++----------
 fs/binfmt_elf_fdpic.c   |   12 ++----------
 fs/exec.c               |   20 ++++++++++++++++----
 include/linux/binfmts.h |    1 +
 4 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 5e27303..2f76489 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1911,7 +1911,6 @@ static int elf_core_dump(struct coredump_params *cprm)
 	struct vm_area_struct *vma, *gate_vma;
 	struct elfhdr *elf = NULL;
 	loff_t offset = 0, dataoff, foffset;
-	unsigned long mm_flags;
 	struct elf_note_info info;
 
 	/*
@@ -1982,13 +1981,6 @@ static int elf_core_dump(struct coredump_params *cprm)
 
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
-	/*
-	 * We must use the same mm->flags while dumping core to avoid
-	 * inconsistency between the program headers and bodies, otherwise an
-	 * unusable core file can be generated.
-	 */
-	mm_flags = current->mm->flags;
-
 	/* Write program headers for segments dump */
 	for (vma = first_vma(current, gate_vma); vma != NULL;
 			vma = next_vma(vma, gate_vma)) {
@@ -1998,7 +1990,7 @@ static int elf_core_dump(struct coredump_params *cprm)
 		phdr.p_offset = offset;
 		phdr.p_vaddr = vma->vm_start;
 		phdr.p_paddr = 0;
-		phdr.p_filesz = vma_dump_size(vma, mm_flags);
+		phdr.p_filesz = vma_dump_size(vma, cprm->mm_flags);
 		phdr.p_memsz = vma->vm_end - vma->vm_start;
 		offset += phdr.p_filesz;
 		phdr.p_flags = vma->vm_flags & VM_READ ? PF_R : 0;
@@ -2034,7 +2026,7 @@ static int elf_core_dump(struct coredump_params *cprm)
 		unsigned long addr;
 		unsigned long end;
 
-		end = vma->vm_start + vma_dump_size(vma, mm_flags);
+		end = vma->vm_start + vma_dump_size(vma, cprm->mm_flags);
 
 		for (addr = vma->vm_start; addr < end; addr += PAGE_SIZE) {
 			struct page *page;
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index e65ab9d..28af3e9 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1604,7 +1604,6 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 #endif
 	int thread_status_size = 0;
 	elf_addr_t *auxv;
-	unsigned long mm_flags;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1735,13 +1734,6 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 	/* Page-align dumped data */
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
-	/*
-	 * We must use the same mm->flags while dumping core to avoid
-	 * inconsistency between the program headers and bodies, otherwise an
-	 * unusable core file can be generated.
-	 */
-	mm_flags = current->mm->flags;
-
 	/* write program headers for segments dump */
 	for (vma = current->mm->mmap; vma; vma = vma->vm_next) {
 		struct elf_phdr phdr;
@@ -1753,7 +1745,7 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 		phdr.p_offset = offset;
 		phdr.p_vaddr = vma->vm_start;
 		phdr.p_paddr = 0;
-		phdr.p_filesz = maydump(vma, mm_flags) ? sz : 0;
+		phdr.p_filesz = maydump(vma, cprm->mm_flags) ? sz : 0;
 		phdr.p_memsz = sz;
 		offset += phdr.p_filesz;
 		phdr.p_flags = vma->vm_flags & VM_READ ? PF_R : 0;
@@ -1789,7 +1781,7 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 		goto end_coredump;
 
 	if (elf_fdpic_dump_segments(cprm->file, &size, &cprm->limit,
-				    mm_flags) < 0)
+				    cprm->mm_flags) < 0)
 		goto end_coredump;
 
 #ifdef ELF_CORE_WRITE_EXTRA_DATA
diff --git a/fs/exec.c b/fs/exec.c
index 5daf7d5..2ec6973 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1718,14 +1718,19 @@ void set_dumpable(struct mm_struct *mm, int value)
 	}
 }
 
-int get_dumpable(struct mm_struct *mm)
+static int __get_dumpable(unsigned long mm_flags)
 {
 	int ret;
 
-	ret = mm->flags & 0x3;
+	ret = mm_flags & MMF_DUMPABLE_MASK;
 	return (ret >= 2) ? 2 : ret;
 }
 
+int get_dumpable(struct mm_struct *mm)
+{
+	return __get_dumpable(mm->flags);
+}
+
 static void wait_for_dump_helpers(struct file *file)
 {
 	struct pipe_inode_info *pipe;
@@ -1769,6 +1774,12 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 		.signr = signr,
 		.regs = regs,
 		.limit = current->signal->rlim[RLIMIT_CORE].rlim_cur,
+		/*
+		 * We must use the same mm->flags while dumping core to avoid
+		 * inconsistency of bit flags, since this flag is not protected
+		 * by any locks.
+		 */
+		.mm_flags = mm->flags,
 	};
 
 	audit_core_dumps(signr);
@@ -1787,7 +1798,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	/*
 	 * If another thread got here first, or we are not dumpable, bail out.
 	 */
-	if (mm->core_state || !get_dumpable(mm)) {
+	if (mm->core_state || !__get_dumpable(cprm.mm_flags)) {
 		up_write(&mm->mmap_sem);
 		put_cred(cred);
 		goto fail;
@@ -1798,7 +1809,8 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	 *	process nor do we know its entire history. We only know it
 	 *	was tainted so we dump it as root in mode 2.
 	 */
-	if (get_dumpable(mm) == 2) {	/* Setuid core dump mode */
+	if (__get_dumpable(cprm.mm_flags) == 2) {
+		/* Setuid core dump mode */
 		flag = O_EXCL;		/* Stop rewrite attacks */
 		cred->fsuid = 0;	/* Dump root private */
 	}
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index cd4349b..99e529b 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -74,6 +74,7 @@ struct coredump_params {
 	struct pt_regs *regs;
 	struct file *file;
 	unsigned long limit;
+	unsigned long mm_flags;
 };
 
 /*


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
