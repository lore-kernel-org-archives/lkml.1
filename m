Return-Path: <linux-kernel-owner+w=401wt.eu-S932437AbZKMWxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbZKMWxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 17:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932332AbZKMWxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 17:53:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932331AbZKMWxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 17:53:31 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 1/3] Pass mm->flags to binfmt core_dump for bitflag
	consistency
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Date: Fri, 13 Nov 2009 17:52:27 -0500
Message-ID: <20091113225226.15079.90813.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass mm->flags to binfmt core_dump for bitflag consistency.
Since mm->flags bit flags is not protected by locks, it will be
changed while dumping core. This patch copies mm->flags to a
mm_flags local variable at the beginning of do_coredump() and
use it while dumping. mm_flags also includes dump_filter which
filters elf sections from core file in elf_core_dump().
So, this patch also passes mm_flags to each binfmt->core_dump().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---

 fs/binfmt_aout.c        |    4 ++--
 fs/binfmt_elf.c         |   12 ++----------
 fs/binfmt_elf_fdpic.c   |   13 +++----------
 fs/binfmt_flat.c        |    4 ++--
 fs/binfmt_som.c         |    2 +-
 fs/exec.c               |   14 ++++++++++----
 include/linux/binfmts.h |    2 +-
 7 files changed, 21 insertions(+), 30 deletions(-)

diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index b639dcf..ef1d4aa 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -32,7 +32,7 @@
 
 static int load_aout_binary(struct linux_binprm *, struct pt_regs * regs);
 static int load_aout_library(struct file*);
-static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
+static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit, unsigned long mm_flags);
 
 static struct linux_binfmt aout_format = {
 	.module		= THIS_MODULE,
@@ -89,7 +89,7 @@ if (file->f_op->llseek) { \
  * dumping of the process results in another error..
  */
 
-static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit)
+static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit, unsigned long mm_flags)
 {
 	mm_segment_t fs;
 	int has_dumped = 0;
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index b9b3bb5..dd7256c 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -45,7 +45,7 @@ static unsigned long elf_map(struct file *, unsigned long, struct elf_phdr *,
  * don't even try.
  */
 #if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
-static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
+static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit, unsigned long mm_flags);
 #else
 #define elf_core_dump	NULL
 #endif
@@ -1906,7 +1906,7 @@ static struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
  * and then they are actually written out.  If we run out of core limit
  * we just truncate.
  */
-static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit)
+static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit, unsigned long mm_flags)
 {
 	int has_dumped = 0;
 	mm_segment_t fs;
@@ -1915,7 +1915,6 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 	struct vm_area_struct *vma, *gate_vma;
 	struct elfhdr *elf = NULL;
 	loff_t offset = 0, dataoff, foffset;
-	unsigned long mm_flags;
 	struct elf_note_info info;
 
 	/*
@@ -1980,13 +1979,6 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 
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
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 38502c6..8af3633 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -76,7 +76,7 @@ static int elf_fdpic_map_file_by_direct_mmap(struct elf_fdpic_params *,
 					     struct file *, struct mm_struct *);
 
 #if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
-static int elf_fdpic_core_dump(long, struct pt_regs *, struct file *, unsigned long limit);
+static int elf_fdpic_core_dump(long, struct pt_regs *, struct file *, unsigned long limit, unsigned long mm_flags);
 #endif
 
 static struct linux_binfmt elf_fdpic_format = {
@@ -1582,7 +1582,8 @@ static int elf_fdpic_dump_segments(struct file *file, size_t *size,
  * we just truncate.
  */
 static int elf_fdpic_core_dump(long signr, struct pt_regs *regs,
-			       struct file *file, unsigned long limit)
+			       struct file *file, unsigned long limit,
+			       unsigned long mm_flags)
 {
 #define	NUM_NOTES	6
 	int has_dumped = 0;
@@ -1605,7 +1606,6 @@ static int elf_fdpic_core_dump(long signr, struct pt_regs *regs,
 #endif
 	int thread_status_size = 0;
 	elf_addr_t *auxv;
-	unsigned long mm_flags;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1736,13 +1736,6 @@ static int elf_fdpic_core_dump(long signr, struct pt_regs *regs,
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
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index a279665..6477678 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -87,7 +87,7 @@ static int load_flat_shared_library(int id, struct lib_info *p);
 #endif
 
 static int load_flat_binary(struct linux_binprm *, struct pt_regs * regs);
-static int flat_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
+static int flat_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit, unsigned long mm_flags);
 
 static struct linux_binfmt flat_format = {
 	.module		= THIS_MODULE,
@@ -102,7 +102,7 @@ static struct linux_binfmt flat_format = {
  * Currently only a stub-function.
  */
 
-static int flat_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit)
+static int flat_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit, unsigned long mm_flags)
 {
 	printk("Process %s:%d received signr %d and should have core dumped\n",
 			current->comm, current->pid, (int) signr);
diff --git a/fs/binfmt_som.c b/fs/binfmt_som.c
index eff74b9..983c01d 100644
--- a/fs/binfmt_som.c
+++ b/fs/binfmt_som.c
@@ -43,7 +43,7 @@ static int load_som_library(struct file *);
  * don't even try.
  */
 #if 0
-static int som_core_dump(long signr, struct pt_regs *regs, unsigned long limit);
+static int som_core_dump(long signr, struct pt_regs *regs, unsigned long limit, unsigned long mm_flags);
 #else
 #define som_core_dump	NULL
 #endif
diff --git a/fs/exec.c b/fs/exec.c
index ba112bd..dc418e3 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1722,7 +1722,7 @@ int get_dumpable(struct mm_struct *mm)
 {
 	int ret;
 
-	ret = mm->flags & 0x3;
+	ret = mm->flags & MMF_DUMPABLE_MASK;
 	return (ret >= 2) ? 2 : ret;
 }
 
@@ -1754,6 +1754,12 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	struct core_state core_state;
 	char corename[CORENAME_MAX_SIZE + 1];
 	struct mm_struct *mm = current->mm;
+	/*
+	 * We must use the same mm->flags while dumping core to avoid
+	 * inconsistency of bit flags, since this flag is not protected
+	 * by any locks.
+	 */
+	unsigned long mm_flags = mm->flags;
 	struct linux_binfmt * binfmt;
 	struct inode * inode;
 	struct file * file;
@@ -1784,7 +1790,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	/*
 	 * If another thread got here first, or we are not dumpable, bail out.
 	 */
-	if (mm->core_state || !get_dumpable(mm)) {
+	if (mm->core_state || !(mm_flags & MMF_DUMPABLE_MASK)) {
 		up_write(&mm->mmap_sem);
 		put_cred(cred);
 		goto fail;
@@ -1795,7 +1801,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	 *	process nor do we know its entire history. We only know it
 	 *	was tainted so we dump it as root in mode 2.
 	 */
-	if (get_dumpable(mm) == 2) {	/* Setuid core dump mode */
+	if (mm_flags & (1 << MMF_DUMP_SECURELY)) { /* Setuid core dump mode */
 		flag = O_EXCL;		/* Stop rewrite attacks */
 		cred->fsuid = 0;	/* Dump root private */
 	}
@@ -1901,7 +1907,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	if (!ispipe && do_truncate(file->f_path.dentry, 0, 0, file) != 0)
 		goto close_fail;
 
-	retval = binfmt->core_dump(signr, regs, file, core_limit);
+	retval = binfmt->core_dump(signr, regs, file, core_limit, mm_flags);
 
 	if (retval)
 		current->signal->group_exit_code |= 0x80;
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index aece486..6e65c31 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -77,7 +77,7 @@ struct linux_binfmt {
 	struct module *module;
 	int (*load_binary)(struct linux_binprm *, struct  pt_regs * regs);
 	int (*load_shlib)(struct file *);
-	int (*core_dump)(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
+	int (*core_dump)(long signr, struct pt_regs *regs, struct file *file, unsigned long limit, unsigned long mm_flags);
 	unsigned long min_coredump;	/* minimal dump size */
 	int hasvdso;
 };


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
