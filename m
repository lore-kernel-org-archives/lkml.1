Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbXGVPkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbXGVPkj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 11:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbXGVPk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 11:40:28 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3530 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbXGVPk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 11:40:26 -0400
Date: Sun, 22 Jul 2007 11:39:47 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, wwoods@redhat.com
Cc: nhorman@tuxdriver.com
Subject: [PATCH]: allow individual core dump methods to be unlimited when sending to a pipe
Message-ID: <20070722153947.GA11941@hmsreliant.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey-
	This is a follow on to the patch entitled:
update-coredump-path-in-kernel-to-not-check-coredump-rlim-if-core_pattern-is-a-pipe.patch
It allows individual core dump methods to have the core dump size limit passed
into them.  Its more efficient than each method having to retrieve it on their
own, and it allows for do_coredump to specify a infinite limit in the event that
a pipe is configured in /proc/sys/kernel/core_pattern, in which case ulimit -c
should not apply.

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 arch/mips/kernel/irixelf.c          |    5 ++---
 arch/sparc64/kernel/binfmt_aout32.c |    8 +++-----
 arch/x86_64/ia32/ia32_aout.c        |   10 ++++------
 fs/binfmt_aout.c                    |   16 ++++++----------
 fs/binfmt_elf.c                     |    5 ++---
 fs/binfmt_elf_fdpic.c               |    5 ++---
 fs/binfmt_flat.c                    |    4 ++--
 fs/binfmt_som.c                     |    2 +-
 fs/exec.c                           |    6 ++++--
 include/linux/binfmts.h             |    2 +-
 10 files changed, 27 insertions(+), 36 deletions(-)


diff --git a/arch/mips/kernel/irixelf.c b/arch/mips/kernel/irixelf.c
index 403d96f..5f11d6e 100644
--- a/arch/mips/kernel/irixelf.c
+++ b/arch/mips/kernel/irixelf.c
@@ -44,7 +44,7 @@
 static int load_irix_binary(struct linux_binprm * bprm, struct pt_regs * regs);
 static int load_irix_library(struct file *);
 static int irix_core_dump(long signr, struct pt_regs * regs,
-                          struct file *file);
+                          struct file *file, int limit);
 
 static struct linux_binfmt irix_format = {
 	NULL, THIS_MODULE, load_irix_binary, load_irix_library,
@@ -1088,7 +1088,7 @@ end_coredump:
  * and then they are actually written out.  If we run out of core limit
  * we just truncate.
  */
-static int irix_core_dump(long signr, struct pt_regs * regs, struct file *file)
+static int irix_core_dump(long signr, struct pt_regs * regs, struct file *file, int limit)
 {
 	int has_dumped = 0;
 	mm_segment_t fs;
@@ -1098,7 +1098,6 @@ static int irix_core_dump(long signr, struct pt_regs * regs, struct file *file)
 	struct vm_area_struct *vma;
 	struct elfhdr elf;
 	off_t offset = 0, dataoff;
-	int limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
 	int numnote = 3;
 	struct memelfnote notes[3];
 	struct elf_prstatus prstatus;	/* NT_PRSTATUS */
diff --git a/arch/sparc64/kernel/binfmt_aout32.c b/arch/sparc64/kernel/binfmt_aout32.c
index f205fc7..d71691f 100644
--- a/arch/sparc64/kernel/binfmt_aout32.c
+++ b/arch/sparc64/kernel/binfmt_aout32.c
@@ -83,7 +83,7 @@ if (file->f_op->llseek) { \
  * dumping of the process results in another error..
  */
 
-static int aout32_core_dump(long signr, struct pt_regs *regs, struct file *file)
+static int aout32_core_dump(long signr, struct pt_regs *regs, struct file *file, u32 limit)
 {
 	mm_segment_t fs;
 	int has_dumped = 0;
@@ -102,13 +102,11 @@ static int aout32_core_dump(long signr, struct pt_regs *regs, struct file *file)
 
 /* If the size of the dump file exceeds the rlimit, then see what would happen
    if we wrote the stack, but not the data area.  */
-	if ((dump.u_dsize+dump.u_ssize) >
-	    current->signal->rlim[RLIMIT_CORE].rlim_cur)
+	if ((dump.u_dsize+dump.u_ssize) > limit)
 		dump.u_dsize = 0;
 
 /* Make sure we have enough room to write the stack and data areas. */
-	if ((dump.u_ssize) >
-	    current->signal->rlim[RLIMIT_CORE].rlim_cur)
+	if ((dump.u_ssize) > limit)
 		dump.u_ssize = 0;
 
 /* make sure we actually have a data and stack area to dump */
diff --git a/arch/x86_64/ia32/ia32_aout.c b/arch/x86_64/ia32/ia32_aout.c
index 0878137..5967cc5 100644
--- a/arch/x86_64/ia32/ia32_aout.c
+++ b/arch/x86_64/ia32/ia32_aout.c
@@ -40,7 +40,7 @@ static int load_aout_binary(struct linux_binprm *, struct pt_regs * regs);
 static int load_aout_library(struct file*);
 
 #ifdef CORE_DUMP
-static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file);
+static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, u32 limit);
 
 /*
  * fill in the user structure for a core dump..
@@ -148,7 +148,7 @@ if (file->f_op->llseek) { \
  * dumping of the process results in another error..
  */
 
-static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file)
+static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, u32 limit)
 {
 	mm_segment_t fs;
 	int has_dumped = 0;
@@ -168,13 +168,11 @@ static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file)
 
 /* If the size of the dump file exceeds the rlimit, then see what would happen
    if we wrote the stack, but not the data area.  */
-	if ((dump.u_dsize+dump.u_ssize+1) * PAGE_SIZE >
-	    current->signal->rlim[RLIMIT_CORE].rlim_cur)
+	if ((dump.u_dsize+dump.u_ssize+1) * PAGE_SIZE > limit)
 		dump.u_dsize = 0;
 
 /* Make sure we have enough room to write the stack and data areas. */
-	if ((dump.u_ssize+1) * PAGE_SIZE >
-	    current->signal->rlim[RLIMIT_CORE].rlim_cur)
+	if ((dump.u_ssize+1) * PAGE_SIZE > limit)
 		dump.u_ssize = 0;
 
 /* make sure we actually have a data and stack area to dump */
diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index 813a887..e247d80 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -31,7 +31,7 @@
 
 static int load_aout_binary(struct linux_binprm *, struct pt_regs * regs);
 static int load_aout_library(struct file*);
-static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file);
+static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, u32 limit);
 
 static struct linux_binfmt aout_format = {
 	.module		= THIS_MODULE,
@@ -88,7 +88,7 @@ if (file->f_op->llseek) { \
  * dumping of the process results in another error..
  */
 
-static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file)
+static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, u32 limit)
 {
 	mm_segment_t fs;
 	int has_dumped = 0;
@@ -123,23 +123,19 @@ static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file)
 /* If the size of the dump file exceeds the rlimit, then see what would happen
    if we wrote the stack, but not the data area.  */
 #ifdef __sparc__
-	if ((dump.u_dsize+dump.u_ssize) >
-	    current->signal->rlim[RLIMIT_CORE].rlim_cur)
+	if ((dump.u_dsize+dump.u_ssize) > limit)
 		dump.u_dsize = 0;
 #else
-	if ((dump.u_dsize+dump.u_ssize+1) * PAGE_SIZE >
-	    current->signal->rlim[RLIMIT_CORE].rlim_cur)
+	if ((dump.u_dsize+dump.u_ssize+1) * PAGE_SIZE > limit)
 		dump.u_dsize = 0;
 #endif
 
 /* Make sure we have enough room to write the stack and data areas. */
 #ifdef __sparc__
-	if ((dump.u_ssize) >
-	    current->signal->rlim[RLIMIT_CORE].rlim_cur)
+	if ((dump.u_ssize) > limit)
 		dump.u_ssize = 0;
 #else
-	if ((dump.u_ssize+1) * PAGE_SIZE >
-	    current->signal->rlim[RLIMIT_CORE].rlim_cur)
+	if ((dump.u_ssize+1) * PAGE_SIZE > limit)
 		dump.u_ssize = 0;
 #endif
 
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index ba24cb2..b1c70cb 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -52,7 +52,7 @@ static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, i
  * don't even try.
  */
 #if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
-static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file);
+static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, u32 limit);
 #else
 #define elf_core_dump	NULL
 #endif
@@ -1551,7 +1551,7 @@ static struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
  * and then they are actually written out.  If we run out of core limit
  * we just truncate.
  */
-static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file)
+static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, u32 limit)
 {
 #define	NUM_NOTES	6
 	int has_dumped = 0;
@@ -1562,7 +1562,6 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file)
 	struct vm_area_struct *vma, *gate_vma;
 	struct elfhdr *elf = NULL;
 	loff_t offset = 0, dataoff, foffset;
-	unsigned long limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
 	int numnote;
 	struct memelfnote *notes = NULL;
 	struct elf_prstatus *prstatus = NULL;	/* NT_PRSTATUS */
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 2f5d8db..fb4ad53 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -75,7 +75,7 @@ static int elf_fdpic_map_file_by_direct_mmap(struct elf_fdpic_params *,
 					     struct file *, struct mm_struct *);
 
 #if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
-static int elf_fdpic_core_dump(long, struct pt_regs *, struct file *);
+static int elf_fdpic_core_dump(long, struct pt_regs *, struct file *, u32 limit);
 #endif
 
 static struct linux_binfmt elf_fdpic_format = {
@@ -1552,7 +1552,7 @@ static int elf_fdpic_dump_segments(struct file *file, size_t *size,
  * we just truncate.
  */
 static int elf_fdpic_core_dump(long signr, struct pt_regs *regs,
-			       struct file *file)
+			       struct file *file, u32 limit)
 {
 #define	NUM_NOTES	6
 	int has_dumped = 0;
@@ -1563,7 +1563,6 @@ static int elf_fdpic_core_dump(long signr, struct pt_regs *regs,
 	struct vm_area_struct *vma;
 	struct elfhdr *elf = NULL;
 	loff_t offset = 0, dataoff;
-	unsigned long limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
 	int numnote;
 	struct memelfnote *notes = NULL;
 	struct elf_prstatus *prstatus = NULL;	/* NT_PRSTATUS */
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 861141b..1a17556 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -75,7 +75,7 @@ static int load_flat_shared_library(int id, struct lib_info *p);
 #endif
 
 static int load_flat_binary(struct linux_binprm *, struct pt_regs * regs);
-static int flat_core_dump(long signr, struct pt_regs * regs, struct file *file);
+static int flat_core_dump(long signr, struct pt_regs * regs, struct file *file, u32 limit);
 
 static struct linux_binfmt flat_format = {
 	.module		= THIS_MODULE,
@@ -90,7 +90,7 @@ static struct linux_binfmt flat_format = {
  * Currently only a stub-function.
  */
 
-static int flat_core_dump(long signr, struct pt_regs * regs, struct file *file)
+static int flat_core_dump(long signr, struct pt_regs * regs, struct file *file, u32 limit)
 {
 	printk("Process %s:%d received signr %d and should have core dumped\n",
 			current->comm, current->pid, (int) signr);
diff --git a/fs/binfmt_som.c b/fs/binfmt_som.c
index 5bcdaaf..0da1fae 100644
--- a/fs/binfmt_som.c
+++ b/fs/binfmt_som.c
@@ -44,7 +44,7 @@ static int load_som_library(struct file *);
  * don't even try.
  */
 #if 0
-static int som_core_dump(long signr, struct pt_regs * regs);
+static int som_core_dump(long signr, struct pt_regs * regs, u32 limit);
 #else
 #define som_core_dump	NULL
 #endif
diff --git a/fs/exec.c b/fs/exec.c
index e82a01d..3b2e1e7 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1726,6 +1726,7 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	int fsuid = current->fsuid;
 	int flag = 0;
 	int ispipe = 0;
+	u32 core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
 
 	audit_core_dumps(signr);
 
@@ -1775,10 +1776,11 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	 * as it does with any other process
 	 */
 	if ((!ispipe) &&
-	   (current->signal->rlim[RLIMIT_CORE].rlim_cur < binfmt->min_coredump))
+	   (core_limit < binfmt->min_coredump))
 		goto fail_unlock;
 
  	if (ispipe) {
+		core_limit = RLIM_INFINITY;
 		/* SIGPIPE can happen, but it's just never processed */
  		if(call_usermodehelper_pipe(corename+1, NULL, NULL, &file)) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
@@ -1808,7 +1810,7 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	if (!ispipe && do_truncate(file->f_path.dentry, 0, 0, file) != 0)
 		goto close_fail;
 
-	retval = binfmt->core_dump(signr, regs, file);
+	retval = binfmt->core_dump(signr, regs, file, core_limit);
 
 	if (retval)
 		current->signal->group_exit_code |= 0x80;
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 91c8c07..3188627 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -67,7 +67,7 @@ struct linux_binfmt {
 	struct module *module;
 	int (*load_binary)(struct linux_binprm *, struct  pt_regs * regs);
 	int (*load_shlib)(struct file *);
-	int (*core_dump)(long signr, struct pt_regs * regs, struct file * file);
+	int (*core_dump)(long signr, struct pt_regs * regs, struct file * file, u32 limit);
 	unsigned long min_coredump;	/* minimal dump size */
 	int hasvdso;
 };
-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
