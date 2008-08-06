Return-Path: <linux-kernel-owner+w=401wt.eu-S1761284AbYHFPnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761284AbYHFPnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964803AbYHFPjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:39:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759542AbYHFPjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:39:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 18/24] CRED: Make execve() take advantage of copy-on-write
	credentials [ver #7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:38:47 +0100
Message-ID: <20080806153847.14351.68243.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make execve() take advantage of copy-on-write credentials, allowing it to set
up the credentials in advance, and then commit the whole lot after the point
of no return.

This patch and the preceding patches have been tested with the LTP SELinux
testsuite.

This patch makes several logical sets of alteration:

 (1) execve().

     The credential bits from struct linux_binprm are, for the most part,
     replaced with a single credentials pointer (bprm->cred).  This means that
     all the creds can be calculated in advance and then applied at the point
     of no return with no possibility of failure.

     I would like to replace bprm->cap_effective with:

	cap_isclear(bprm->cap_effective)

     but this seems impossible due to special behaviour for processes of pid 1
     (they always retain their parent's capability masks where normally they'd
     be changed - see cap_bprm_set_creds()).

     The following sequence of events now happens:

     (a) At the start of do_execve, the current task's cred_exec_mutex is
     	 locked to prevent PTRACE_ATTACH from obsoleting the calculation of
     	 creds that we make.

     (a) prepare_exec_creds() is then called to make a copy of the current
     	 task's credentials and prepare it.  This copy is then assigned to
     	 bprm->cred.

  	 This renders security_bprm_alloc() and security_bprm_free()
     	 unnecessary, and so they've been removed.

     (b) The determination of unsafe execution is now performed immediately
     	 after (a) rather than later on in the code.  The result is stored in
     	 bprm->unsafe for future reference.

     (c) prepare_binprm() is called, possibly multiple times.

     	 (i) This applies the result of set[ug]id binaries to the new creds
     	     attached to bprm->cred.  Personality bit clearance is recorded,
     	     but now deferred on the basis that the exec procedure may yet
     	     fail.

         (ii) This then calls the new security_bprm_set_creds().  This should
	     calculate the new LSM and capability credentials into *bprm->cred.

	     This folds together security_bprm_set() and parts of
	     security_bprm_apply_creds() (these two have been removed).
	     Anything that might fail must be done at this point.

         (iii) bprm->cred_prepared is set to 1.

	     bprm->cred_prepared is 0 on the first pass of the security
	     calculations, and 1 on all subsequent passes.  This allows SELinux
	     in (ii) to base its calculations only on the initial script and
	     not on the interpreter.

     (d) flush_old_exec() is called to commit the task to execution.  This
     	 performs the following steps with regard to credentials:

	 (i) Clear pdeath_signal and set dumpable on certain circumstances that
	     may not be covered by commit_creds().

         (ii) Clear any bits in current->personality that were deferred from
             (c.i).

     (e) install_exec_creds() [compute_creds() as was] is called to install the
     	 new credentials.  This performs the following steps with regard to
     	 credentials:

         (i) Calls security_bprm_committing_creds() to apply any security
             requirements, such as flushing unauthorised files in SELinux, that
             must be done before the credentials are changed.

	     This is made up of bits of security_bprm_apply_creds() and
	     security_bprm_post_apply_creds(), both of which have been removed.
	     This function is not allowed to fail; anything that might fail
	     must have been done in (c.ii).

         (ii) Calls commit_creds() to apply the new credentials in a single
             assignment (more or less).  Possibly pdeath_signal and dumpable
             should be part of struct creds.

	 (iii) Unlocks the task's cred_replace_mutex, thus allowing
	     PTRACE_ATTACH to take place.

         (iv) Clears The bprm->cred pointer as the credentials it was holding
             are now immutable.

         (v) Calls security_bprm_committed_creds() to apply any security
             alterations that must be done after the creds have been changed.
             SELinux uses this to flush signals and signal handlers.

     (f) If an error occurs before (d.i), bprm_free() will call abort_creds()
     	 to destroy the proposed new credentials and will then unlock
     	 cred_replace_mutex.  No changes to the credentials will have been
     	 made.

 (2) LSM interface.

     A number of functions have been changed, added or removed:

     (*) security_bprm_alloc(), ->bprm_alloc_security()
     (*) security_bprm_free(), ->bprm_free_security()

     	 Removed in favour of preparing new credentials and modifying those.

     (*) security_bprm_apply_creds(), ->bprm_apply_creds()
     (*) security_bprm_post_apply_creds(), ->bprm_post_apply_creds()

     	 Removed; split between security_bprm_set_creds(),
     	 security_bprm_committing_creds() and security_bprm_committed_creds().

     (*) security_bprm_set(), ->bprm_set_security()

     	 Removed; folded into security_bprm_set_creds().

     (*) security_bprm_set_creds(), ->bprm_set_creds()

     	 New.  The new credentials in bprm->creds should be checked and set up
     	 as appropriate.  bprm->cred_prepared is 0 on the first call, 1 on the
     	 second and subsequent calls.

     (*) security_bprm_committing_creds(), ->bprm_committing_creds()
     (*) security_bprm_committed_creds(), ->bprm_committed_creds()

     	 New.  Apply the security effects of the new credentials.  This
     	 includes closing unauthorised files in SELinux.  This function may not
     	 fail.  When the former is called, the creds haven't yet been applied
     	 to the process; when the latter is called, they have.

 	 The former may access bprm->cred, the latter may not.

 (3) SELinux.

     SELinux has a number of changes, in addition to those to support the LSM
     interface changes mentioned above:

     (a) The bprm_security_struct struct has been removed in favour of using
     	 the credentials-under-construction approach.

     (c) flush_unauthorized_files() now takes a cred pointer and passes it on
     	 to inode_has_perm(), file_has_perm() and dentry_open().

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---

 arch/x86/ia32/ia32_aout.c         |    2 
 fs/binfmt_aout.c                  |    2 
 fs/binfmt_elf.c                   |    2 
 fs/binfmt_elf_fdpic.c             |    2 
 fs/binfmt_flat.c                  |    2 
 fs/binfmt_som.c                   |    2 
 fs/compat.c                       |   20 +--
 fs/exec.c                         |  124 +++++++++-------
 fs/internal.h                     |    6 +
 include/linux/binfmts.h           |   16 +-
 include/linux/cred.h              |    3 
 include/linux/key.h               |    2 
 include/linux/security.h          |  103 +++++--------
 kernel/cred.c                     |   44 ++++++
 security/capability.c             |   19 +-
 security/commoncap.c              |  133 ++++++++---------
 security/keys/process_keys.c      |   42 -----
 security/root_plug.c              |   13 +-
 security/security.c               |   26 +--
 security/selinux/hooks.c          |  290 ++++++++++++++++---------------------
 security/selinux/include/objsec.h |   11 -
 security/smack/smack_lsm.c        |    3 
 22 files changed, 390 insertions(+), 477 deletions(-)


diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index a0e1dbe..57b2ade 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -325,7 +325,7 @@ static int load_aout_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	current->mm->cached_hole_size = 0;
 
 	current->mm->mmap = NULL;
-	compute_creds(bprm);
+	install_exec_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
 
 	if (N_MAGIC(ex) == OMAGIC) {
diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index 204cfd1..f1f3f41 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -320,7 +320,7 @@ static int load_aout_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 	current->mm->free_area_cache = current->mm->mmap_base;
 	current->mm->cached_hole_size = 0;
 
-	compute_creds(bprm);
+	install_exec_creds(bprm);
  	current->flags &= ~PF_FORKNOEXEC;
 #ifdef __sparc__
 	if (N_MAGIC(ex) == NMAGIC) {
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 8761e97..fc98651 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -956,7 +956,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	}
 #endif /* ARCH_HAS_SETUP_ADDITIONAL_PAGES */
 
-	compute_creds(bprm);
+	install_exec_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
 	retval = create_elf_tables(bprm, &loc->elf_ex,
 			  load_addr, interp_load_addr);
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 5625b23..83a55ef 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -403,7 +403,7 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 	current->mm->start_stack = current->mm->start_brk + stack_size;
 #endif
 
-	compute_creds(bprm);
+	install_exec_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
 	if (create_elf_fdpic_tables(bprm, current->mm,
 				    &exec_params, &interp_params) < 0)
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 56372ec..ae8554d 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -880,7 +880,7 @@ static int load_flat_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 					(libinfo.lib_list[j].loaded)?
 						libinfo.lib_list[j].start_data:UNLOADED_LIB;
 
-	compute_creds(bprm);
+	install_exec_creds(bprm);
  	current->flags &= ~PF_FORKNOEXEC;
 
 	set_binfmt(&flat_format);
diff --git a/fs/binfmt_som.c b/fs/binfmt_som.c
index 68be580..bd87ae3 100644
--- a/fs/binfmt_som.c
+++ b/fs/binfmt_som.c
@@ -255,7 +255,7 @@ load_som_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 	kfree(hpuxhdr);
 
 	set_binfmt(&som_format);
-	compute_creds(bprm);
+	install_exec_creds(bprm);
 	setup_arg_pages(bprm, STACK_TOP, EXSTACK_DEFAULT);
 
 	create_som_tables(bprm);
diff --git a/fs/compat.c b/fs/compat.c
index c9d1472..b8069c3 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1356,10 +1356,15 @@ int compat_do_execve(char * filename,
 	if (!bprm)
 		goto out_ret;
 
+	bprm->cred = prepare_exec_creds();
+	if (!bprm->cred)
+		goto out_free;
+	check_unsafe_exec(bprm);
+
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
 	if (IS_ERR(file))
-		goto out_kfree;
+		goto out_free;
 
 	sched_exec();
 
@@ -1373,14 +1378,10 @@ int compat_do_execve(char * filename,
 
 	bprm->argc = compat_count(argv, MAX_ARG_STRINGS);
 	if ((retval = bprm->argc) < 0)
-		goto out_mm;
+		goto out;
 
 	bprm->envc = compat_count(envp, MAX_ARG_STRINGS);
 	if ((retval = bprm->envc) < 0)
-		goto out_mm;
-
-	retval = security_bprm_alloc(bprm);
-	if (retval)
 		goto out;
 
 	retval = prepare_binprm(bprm);
@@ -1403,17 +1404,12 @@ int compat_do_execve(char * filename,
 	retval = search_binary_handler(bprm, regs);
 	if (retval >= 0) {
 		/* execve success */
-		security_bprm_free(bprm);
 		acct_update_integrals(current);
 		free_bprm(bprm);
 		return retval;
 	}
 
 out:
-	if (bprm->security)
-		security_bprm_free(bprm);
-
-out_mm:
 	if (bprm->mm)
 		mmput(bprm->mm);
 
@@ -1423,7 +1419,7 @@ out_file:
 		fput(bprm->file);
 	}
 
-out_kfree:
+out_free:
 	free_bprm(bprm);
 
 out_ret:
diff --git a/fs/exec.c b/fs/exec.c
index fb7ace1..a7633e5 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -54,6 +54,7 @@
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/tlb.h>
+#include "internal.h"
 
 #ifdef CONFIG_KMOD
 #include <linux/kmod.h>
@@ -1012,15 +1013,17 @@ int flush_old_exec(struct linux_binprm * bprm)
 	 */
 	current->mm->task_size = TASK_SIZE;
 
-	if (bprm->e_uid != current_euid() ||
-	    bprm->e_gid != current_egid()) {
-		set_dumpable(current->mm, suid_dumpable);
+	/* install the new credentials */
+	if (bprm->cred->uid != current_euid() ||
+	    bprm->cred->gid != current_egid()) {
 		current->pdeath_signal = 0;
 	} else if (file_permission(bprm->file, MAY_READ) ||
-			(bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP)) {
+		   bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP) {
 		set_dumpable(current->mm, suid_dumpable);
 	}
 
+	current->personality &= ~bprm->per_clear;
+
 	/* An exec changes our domain. We are no longer part of the thread
 	   group */
 
@@ -1037,13 +1040,49 @@ out:
 
 EXPORT_SYMBOL(flush_old_exec);
 
+/*
+ * install the new credentials for this executable
+ */
+void install_exec_creds(struct linux_binprm *bprm)
+{
+	security_bprm_committing_creds(bprm);
+
+	/* we hold cred_exec_mutex this far to prevent ptrace_attach() from
+	 * altering our determination of the task's credentials */
+	commit_creds(bprm->cred);
+	bprm->cred = NULL;
+	mutex_unlock(&current->cred_exec_mutex);
+
+	security_bprm_committed_creds(bprm);
+}
+EXPORT_SYMBOL(install_exec_creds);
+
+/*
+ * determine how safe it is to execute the proposed program
+ * - the caller must hold current->cred_exec_mutex to protect against
+ *   PTRACE_ATTACH
+ */
+void check_unsafe_exec(struct linux_binprm *bprm)
+{
+	struct task_struct *p = current;
+
+	bprm->unsafe = tracehook_unsafe_exec(p);
+
+	if (atomic_read(&p->fs->count) > 1 ||
+	    atomic_read(&p->files->count) > 1 ||
+	    atomic_read(&p->sighand->count) > 1)
+		bprm->unsafe |= LSM_UNSAFE_SHARE;
+}
+
 /* 
  * Fill the binprm structure from the inode. 
  * Check permissions, then read the first 128 (BINPRM_BUF_SIZE) bytes
+ *
+ * This may be called multiple times for binary chains (scripts for example).
  */
 int prepare_binprm(struct linux_binprm *bprm)
 {
-	int mode;
+	umode_t mode;
 	struct inode * inode = bprm->file->f_path.dentry->d_inode;
 	int retval;
 
@@ -1051,14 +1090,15 @@ int prepare_binprm(struct linux_binprm *bprm)
 	if (bprm->file->f_op == NULL)
 		return -EACCES;
 
-	bprm->e_uid = current_euid();
-	bprm->e_gid = current_egid();
+	/* clear any previous set[ug]id data from a previous binary */
+	bprm->cred->euid = current_euid();
+	bprm->cred->egid = current_egid();
 
-	if(!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)) {
+	if (!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)) {
 		/* Set-uid? */
 		if (mode & S_ISUID) {
-			current->personality &= ~PER_CLEAR_ON_SETID;
-			bprm->e_uid = inode->i_uid;
+			bprm->per_clear |= PER_CLEAR_ON_SETID;
+			bprm->cred->euid = inode->i_uid;
 		}
 
 		/* Set-gid? */
@@ -1068,50 +1108,23 @@ int prepare_binprm(struct linux_binprm *bprm)
 		 * executable.
 		 */
 		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
-			current->personality &= ~PER_CLEAR_ON_SETID;
-			bprm->e_gid = inode->i_gid;
+			bprm->per_clear |= PER_CLEAR_ON_SETID;
+			bprm->cred->egid = inode->i_gid;
 		}
 	}
 
 	/* fill in binprm security blob */
-	retval = security_bprm_set(bprm);
+	retval = security_bprm_set_creds(bprm);
 	if (retval)
 		return retval;
+	bprm->cred_prepared = 1;
 
-	memset(bprm->buf,0,BINPRM_BUF_SIZE);
-	return kernel_read(bprm->file,0,bprm->buf,BINPRM_BUF_SIZE);
+	memset(bprm->buf, 0, BINPRM_BUF_SIZE);
+	return kernel_read(bprm->file, 0, bprm->buf, BINPRM_BUF_SIZE);
 }
 
 EXPORT_SYMBOL(prepare_binprm);
 
-static int unsafe_exec(struct task_struct *p)
-{
-	int unsafe = tracehook_unsafe_exec(p);
-
-	if (atomic_read(&p->fs->count) > 1 ||
-	    atomic_read(&p->files->count) > 1 ||
-	    atomic_read(&p->sighand->count) > 1)
-		unsafe |= LSM_UNSAFE_SHARE;
-
-	return unsafe;
-}
-
-void compute_creds(struct linux_binprm *bprm)
-{
-	int unsafe;
-
-	if (bprm->e_uid != current_uid())
-		current->pdeath_signal = 0;
-	exec_keys(current);
-
-	task_lock(current);
-	unsafe = unsafe_exec(current);
-	security_bprm_apply_creds(bprm, unsafe);
-	task_unlock(current);
-	security_bprm_post_apply_creds(bprm);
-}
-EXPORT_SYMBOL(compute_creds);
-
 /*
  * Arguments are '\0' separated strings found at the location bprm->p
  * points to; chop off the first by relocating brpm->p to right after
@@ -1264,6 +1277,10 @@ EXPORT_SYMBOL(search_binary_handler);
 void free_bprm(struct linux_binprm *bprm)
 {
 	free_arg_pages(bprm);
+	if (bprm->cred) {
+		mutex_unlock(&current->cred_exec_mutex);
+		abort_creds(bprm->cred);
+	}
 	kfree(bprm);
 }
 
@@ -1289,6 +1306,16 @@ int do_execve(char * filename,
 	if (!bprm)
 		goto out_files;
 
+	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
+	if (retval < 0)
+		goto out_kfree;
+
+	retval = -ENOMEM;
+	bprm->cred = prepare_exec_creds();
+	if (!bprm->cred)
+		goto out_kfree;
+	check_unsafe_exec(bprm);
+
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
 	if (IS_ERR(file))
@@ -1306,14 +1333,10 @@ int do_execve(char * filename,
 
 	bprm->argc = count(argv, MAX_ARG_STRINGS);
 	if ((retval = bprm->argc) < 0)
-		goto out_mm;
+		goto out;
 
 	bprm->envc = count(envp, MAX_ARG_STRINGS);
 	if ((retval = bprm->envc) < 0)
-		goto out_mm;
-
-	retval = security_bprm_alloc(bprm);
-	if (retval)
 		goto out;
 
 	retval = prepare_binprm(bprm);
@@ -1337,7 +1360,6 @@ int do_execve(char * filename,
 	retval = search_binary_handler(bprm,regs);
 	if (retval >= 0) {
 		/* execve success */
-		security_bprm_free(bprm);
 		acct_update_integrals(current);
 		free_bprm(bprm);
 		if (displaced)
@@ -1346,10 +1368,6 @@ int do_execve(char * filename,
 	}
 
 out:
-	if (bprm->security)
-		security_bprm_free(bprm);
-
-out_mm:
 	if (bprm->mm)
 		mmput (bprm->mm);
 
diff --git a/fs/internal.h b/fs/internal.h
index 80aa9a0..53af885 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -10,6 +10,7 @@
  */
 
 struct super_block;
+struct linux_binprm;
 
 /*
  * block_dev.c
@@ -40,6 +41,11 @@ static inline int sb_is_blkdev_sb(struct super_block *sb)
 extern void __init chrdev_init(void);
 
 /*
+ * exec.c
+ */
+extern void check_unsafe_exec(struct linux_binprm *);
+
+/*
  * namespace.c
  */
 extern int copy_mount_options(const void __user *, unsigned long *);
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 826f623..26f9c1b 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -35,12 +35,16 @@ struct linux_binprm{
 	struct mm_struct *mm;
 	unsigned long p; /* current top of mem */
 	unsigned int sh_bang:1,
-		     misc_bang:1;
+		misc_bang:1,
+		cred_prepared:1,/* true if creds already prepared (multiple
+				 * preps happen for interpreters) */
+		cap_effective:1;/* true if has elevated effective capabilities,
+				 * false if not; except for init which inherits
+				 * its parent's caps anyway */
 	struct file * file;
-	int e_uid, e_gid;
-	kernel_cap_t cap_post_exec_permitted;
-	bool cap_effective;
-	void *security;
+	struct cred *cred;	/* new credentials */
+	int unsafe;		/* how unsafe this exec is (mask of LSM_UNSAFE_*) */
+	unsigned int per_clear;	/* bits to clear in current->personality */
 	int argc, envc;
 	char * filename;	/* Name of binary as seen by procps */
 	char * interp;		/* Name of the binary really executed. Most
@@ -96,7 +100,7 @@ extern int setup_arg_pages(struct linux_binprm * bprm,
 			   int executable_stack);
 extern int bprm_mm_init(struct linux_binprm *bprm);
 extern int copy_strings_kernel(int argc,char ** argv,struct linux_binprm *bprm);
-extern void compute_creds(struct linux_binprm *binprm);
+extern void install_exec_creds(struct linux_binprm *bprm);
 extern int do_coredump(long signr, int exit_code, struct pt_regs * regs);
 extern int set_binfmt(struct linux_binfmt *new);
 extern void free_bprm(struct linux_binprm *);
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 202a82c..c508f4d 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -84,8 +84,6 @@ struct thread_group_cred {
 	struct key	*process_keyring;	/* keyring private to this process */
 	struct rcu_head	rcu;			/* RCU deletion hook */
 };
-
-extern void put_tgcred(struct thread_group_cred *tgcred);
 #endif
 
 /*
@@ -144,6 +142,7 @@ struct cred {
 extern void __put_cred(struct cred *);
 extern int copy_creds(struct task_struct *, unsigned long);
 extern struct cred *prepare_creds(void);
+extern struct cred *prepare_exec_creds(void);
 extern struct cred *prepare_usermodehelper_creds(void);
 extern int commit_creds(struct cred *);
 extern void abort_creds(struct cred *);
diff --git a/include/linux/key.h b/include/linux/key.h
index acd4b13..e3f026c 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -278,7 +278,6 @@ extern ctl_table key_sysctls[];
  * the userspace interface
  */
 extern int install_thread_keyring_to_cred(struct cred *cred);
-extern int exec_keys(struct task_struct *tsk);
 extern void key_fsuid_changed(struct task_struct *tsk);
 extern void key_fsgid_changed(struct task_struct *tsk);
 extern void key_init(void);
@@ -295,7 +294,6 @@ extern void key_init(void);
 #define is_key_possessed(k)		0
 #define install_session_keyring(k)	NULL
 #define install_thread_keyring_to_cred(c) NULL
-#define exec_keys(t)			do { } while(0)
 #define key_fsuid_changed(t)		do { } while(0)
 #define key_fsgid_changed(t)		do { } while(0)
 #define key_init()			do { } while(0)
diff --git a/include/linux/security.h b/include/linux/security.h
index fd66260..29a6a32 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -53,8 +53,7 @@ extern int cap_capset(struct cred *new, const struct cred *old,
 		      const kernel_cap_t *effective,
 		      const kernel_cap_t *inheritable,
 		      const kernel_cap_t *permitted);
-extern int cap_bprm_set_security(struct linux_binprm *bprm);
-extern int cap_bprm_apply_creds(struct linux_binprm *bprm, int unsafe);
+extern int cap_bprm_set_creds(struct linux_binprm *bprm);
 extern int cap_bprm_secureexec(struct linux_binprm *bprm);
 extern int cap_inode_setxattr(struct dentry *dentry, const char *name,
 			      const void *value, size_t size, int flags);
@@ -106,7 +105,7 @@ extern unsigned long mmap_min_addr;
 struct sched_param;
 struct request_sock;
 
-/* bprm_apply_creds unsafe reasons */
+/* bprm->unsafe reasons */
 #define LSM_UNSAFE_SHARE	1
 #define LSM_UNSAFE_PTRACE	2
 #define LSM_UNSAFE_PTRACE_CAP	4
@@ -150,36 +149,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *
  * Security hooks for program execution operations.
  *
- * @bprm_alloc_security:
- *	Allocate and attach a security structure to the @bprm->security field.
- *	The security field is initialized to NULL when the bprm structure is
- *	allocated.
- *	@bprm contains the linux_binprm structure to be modified.
- *	Return 0 if operation was successful.
- * @bprm_free_security:
- *	@bprm contains the linux_binprm structure to be modified.
- *	Deallocate and clear the @bprm->security field.
- * @bprm_apply_creds:
- *	Compute and set the security attributes of a process being transformed
- *	by an execve operation based on the old attributes (current->security)
- *	and the information saved in @bprm->security by the set_security hook.
- *	Since this function may return an error, in which case the process will
- *      be killed.  However, it can leave the security attributes of the
- *	process unchanged if an access failure occurs at this point.
- *	bprm_apply_creds is called under task_lock.  @unsafe indicates various
- *	reasons why it may be unsafe to change security state.
- *	@bprm contains the linux_binprm structure.
- * @bprm_post_apply_creds:
- *	Runs after bprm_apply_creds with the task_lock dropped, so that
- *	functions which cannot be called safely under the task_lock can
- *	be used.  This hook is a good place to perform state changes on
- *	the process such as closing open file descriptors to which access
- *	is no longer granted if the attributes were changed.
- *	Note that a security module might need to save state between
- *	bprm_apply_creds and bprm_post_apply_creds to store the decision
- *	on whether the process may proceed.
- *	@bprm contains the linux_binprm structure.
- * @bprm_set_security:
+ * @bprm_set_creds:
  *	Save security information in the bprm->security field, typically based
  *	on information about the bprm->file, for later use by the apply_creds
  *	hook.  This hook may also optionally check permissions (e.g. for
@@ -192,15 +162,30 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@bprm contains the linux_binprm structure.
  *	Return 0 if the hook is successful and permission is granted.
  * @bprm_check_security:
- *	This hook mediates the point when a search for a binary handler	will
- *	begin.  It allows a check the @bprm->security value which is set in
- *	the preceding set_security call.  The primary difference from
- *	set_security is that the argv list and envp list are reliably
- *	available in @bprm.  This hook may be called multiple times
- *	during a single execve; and in each pass set_security is called
- *	first.
+ *	This hook mediates the point when a search for a binary handler will
+ *	begin.  It allows a check the @bprm->security value which is set in the
+ *	preceding set_creds call.  The primary difference from set_creds is
+ *	that the argv list and envp list are reliably available in @bprm.  This
+ *	hook may be called multiple times during a single execve; and in each
+ *	pass set_creds is called first.
  *	@bprm contains the linux_binprm structure.
  *	Return 0 if the hook is successful and permission is granted.
+ * @bprm_committing_creds:
+ *	Prepare to install the new security attributes of a process being
+ *	transformed by an execve operation, based on the old credentials
+ *	pointed to by @current->cred and the information set in @bprm->cred by
+ *	the bprm_set_creds hook.  @bprm points to the linux_binprm structure.
+ *	This hook is a good place to perform state changes on the process such
+ *	as closing open file descriptors to which access will no longer be
+ *	granted when the attributes are changed.  This is called immediately
+ *	before commit_creds().
+ * @bprm_committed_creds:
+ *	Tidy up after the installation of the new security attributes of a
+ *	process being transformed by an execve operation.  The new credentials
+ *	have, by this point, been set to @current->cred.  @bprm points to the
+ *	linux_binprm structure.  This hook is a good place to perform state
+ *	changes on the process such as clearing out non-inheritable signal
+ *	state.  This is called immediately after commit_creds().
  * @bprm_secureexec:
  *	Return a boolean value (0 or 1) indicating whether a "secure exec"
  *	is required.  The flag is passed in the auxiliary table
@@ -1297,13 +1282,11 @@ struct security_operations {
 	int (*settime) (struct timespec *ts, struct timezone *tz);
 	int (*vm_enough_memory) (struct mm_struct *mm, long pages);
 
-	int (*bprm_alloc_security) (struct linux_binprm *bprm);
-	void (*bprm_free_security) (struct linux_binprm *bprm);
-	int (*bprm_apply_creds) (struct linux_binprm *bprm, int unsafe);
-	void (*bprm_post_apply_creds) (struct linux_binprm *bprm);
-	int (*bprm_set_security) (struct linux_binprm *bprm);
+	int (*bprm_set_creds) (struct linux_binprm *bprm);
 	int (*bprm_check_security) (struct linux_binprm *bprm);
 	int (*bprm_secureexec) (struct linux_binprm *bprm);
+	void (*bprm_committing_creds) (struct linux_binprm *bprm);
+	void (*bprm_committed_creds) (struct linux_binprm *bprm);
 
 	int (*sb_alloc_security) (struct super_block *sb);
 	void (*sb_free_security) (struct super_block *sb);
@@ -1568,12 +1551,10 @@ int security_syslog(int type);
 int security_settime(struct timespec *ts, struct timezone *tz);
 int security_vm_enough_memory(long pages);
 int security_vm_enough_memory_mm(struct mm_struct *mm, long pages);
-int security_bprm_alloc(struct linux_binprm *bprm);
-void security_bprm_free(struct linux_binprm *bprm);
-int security_bprm_apply_creds(struct linux_binprm *bprm, int unsafe);
-void security_bprm_post_apply_creds(struct linux_binprm *bprm);
-int security_bprm_set(struct linux_binprm *bprm);
+int security_bprm_set_creds(struct linux_binprm *bprm);
 int security_bprm_check(struct linux_binprm *bprm);
+void security_bprm_committing_creds(struct linux_binprm *bprm);
+void security_bprm_committed_creds(struct linux_binprm *bprm);
 int security_bprm_secureexec(struct linux_binprm *bprm);
 int security_sb_alloc(struct super_block *sb);
 void security_sb_free(struct super_block *sb);
@@ -1801,32 +1782,22 @@ static inline int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
 	return cap_vm_enough_memory(mm, pages);
 }
 
-static inline int security_bprm_alloc(struct linux_binprm *bprm)
-{
-	return 0;
-}
-
-static inline void security_bprm_free(struct linux_binprm *bprm)
-{ }
-
-static inline int security_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
+static inline int security_bprm_set_creds(struct linux_binprm *bprm)
 {
-	return cap_bprm_apply_creds(bprm, unsafe);
+	return cap_bprm_set_creds(bprm);
 }
 
-static inline void security_bprm_post_apply_creds(struct linux_binprm *bprm)
+static inline int security_bprm_check(struct linux_binprm *bprm)
 {
-	return;
+	return 0;
 }
 
-static inline int security_bprm_set(struct linux_binprm *bprm)
+static inline void security_bprm_committing_creds(struct linux_binprm *bprm)
 {
-	return cap_bprm_set_security(bprm);
 }
 
-static inline int security_bprm_check(struct linux_binprm *bprm)
+static inline void security_bprm_committed_creds(struct linux_binprm *bprm)
 {
-	return 0;
 }
 
 static inline int security_bprm_secureexec(struct linux_binprm *bprm)
diff --git a/kernel/cred.c b/kernel/cred.c
index 7a4d311..319614d 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -177,6 +177,50 @@ error:
 EXPORT_SYMBOL(prepare_creds);
 
 /*
+ * Prepare credentials for current to perform an execve()
+ * - The caller must hold current->cred_exec_mutex
+ */
+struct cred *prepare_exec_creds(void)
+{
+	struct thread_group_cred *tgcred = NULL;
+	struct cred *new;
+
+#ifdef CONFIG_KEYS
+	tgcred = kmalloc(sizeof(*tgcred), GFP_KERNEL);
+	if (!tgcred)
+		return NULL;
+#endif
+
+	new = prepare_creds();
+	if (!new) {
+		kfree(tgcred);
+		return new;
+	}
+
+#ifdef CONFIG_KEYS
+	/* newly exec'd tasks don't get a thread keyring */
+	key_put(new->thread_keyring);
+	new->thread_keyring = NULL;
+
+	/* create a new per-thread-group creds for all this set of threads to
+	 * share */
+	memcpy(tgcred, new->tgcred, sizeof(struct thread_group_cred));
+
+	atomic_set(&tgcred->usage, 1);
+	spin_lock_init(&tgcred->lock);
+
+	/* inherit the session keyring; new process keyring */
+	key_get(tgcred->session_keyring);
+	tgcred->process_keyring = NULL;
+
+	put_tgcred(new->tgcred);
+	new->tgcred = tgcred;
+#endif
+
+	return new;
+}
+
+/*
  * prepare new credentials for the usermode helper dispatcher
  */
 struct cred *prepare_usermodehelper_creds(void)
diff --git a/security/capability.c b/security/capability.c
index efeb6d9..185804f 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -32,24 +32,19 @@ static int cap_quota_on(struct dentry *dentry)
 	return 0;
 }
 
-static int cap_bprm_alloc_security(struct linux_binprm *bprm)
+static int cap_bprm_check_security (struct linux_binprm *bprm)
 {
 	return 0;
 }
 
-static void cap_bprm_free_security(struct linux_binprm *bprm)
+static void cap_bprm_committing_creds(struct linux_binprm *bprm)
 {
 }
 
-static void cap_bprm_post_apply_creds(struct linux_binprm *bprm)
+static void cap_bprm_committed_creds(struct linux_binprm *bprm)
 {
 }
 
-static int cap_bprm_check_security(struct linux_binprm *bprm)
-{
-	return 0;
-}
-
 static int cap_sb_alloc_security(struct super_block *sb)
 {
 	return 0;
@@ -827,11 +822,9 @@ void security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, syslog);
 	set_to_cap_if_null(ops, settime);
 	set_to_cap_if_null(ops, vm_enough_memory);
-	set_to_cap_if_null(ops, bprm_alloc_security);
-	set_to_cap_if_null(ops, bprm_free_security);
-	set_to_cap_if_null(ops, bprm_apply_creds);
-	set_to_cap_if_null(ops, bprm_post_apply_creds);
-	set_to_cap_if_null(ops, bprm_set_security);
+	set_to_cap_if_null(ops, bprm_set_creds);
+	set_to_cap_if_null(ops, bprm_committing_creds);
+	set_to_cap_if_null(ops, bprm_committed_creds);
 	set_to_cap_if_null(ops, bprm_check_security);
 	set_to_cap_if_null(ops, bprm_secureexec);
 	set_to_cap_if_null(ops, sb_alloc_security);
diff --git a/security/commoncap.c b/security/commoncap.c
index 1ae99fa..3da0ada 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -166,7 +166,7 @@ int cap_capset(struct cred *new,
 
 static inline void bprm_clear_caps(struct linux_binprm *bprm)
 {
-	cap_clear(bprm->cap_post_exec_permitted);
+	cap_clear(bprm->cred->cap_permitted);
 	bprm->cap_effective = false;
 }
 
@@ -197,8 +197,10 @@ int cap_inode_killpriv(struct dentry *dentry)
 }
 
 static inline int cap_from_disk(struct vfs_cap_data *caps,
-				struct linux_binprm *bprm, unsigned size)
+				struct linux_binprm *bprm, unsigned size,
+				bool *effective)
 {
+	struct cred *new = bprm->cred;
 	__u32 magic_etc;
 	unsigned tocopy, i;
 	int ret;
@@ -208,7 +210,7 @@ static inline int cap_from_disk(struct vfs_cap_data *caps,
 
 	magic_etc = le32_to_cpu(caps->magic_etc);
 
-	switch ((magic_etc & VFS_CAP_REVISION_MASK)) {
+	switch (magic_etc & VFS_CAP_REVISION_MASK) {
 	case VFS_CAP_REVISION_1:
 		if (size != XATTR_CAPS_SZ_1)
 			return -EINVAL;
@@ -223,11 +225,8 @@ static inline int cap_from_disk(struct vfs_cap_data *caps,
 		return -EINVAL;
 	}
 
-	if (magic_etc & VFS_CAP_FLAGS_EFFECTIVE) {
-		bprm->cap_effective = true;
-	} else {
-		bprm->cap_effective = false;
-	}
+	if (magic_etc & VFS_CAP_FLAGS_EFFECTIVE)
+		*effective = true;
 
 	ret = 0;
 
@@ -238,18 +237,18 @@ static inline int cap_from_disk(struct vfs_cap_data *caps,
 			/*
 			 * Legacy capability sets have no upper bits
 			 */
-			bprm->cap_post_exec_permitted.cap[i] = 0;
+			new->cap_permitted.cap[i] = 0;
 			continue;
 		}
 		/*
 		 * pP' = (X & fP) | (pI & fI)
 		 */
 		value_cpu = le32_to_cpu(caps->data[i].permitted);
-		bprm->cap_post_exec_permitted.cap[i] =
-			(current->cred->cap_bset.cap[i] & value_cpu) |
-			(current->cred->cap_inheritable.cap[i] &
-				le32_to_cpu(caps->data[i].inheritable));
-		if (value_cpu & ~bprm->cap_post_exec_permitted.cap[i]) {
+		new->cap_permitted.cap[i] =
+			(new->cap_bset.cap[i] & value_cpu) |
+			(new->cap_inheritable.cap[i] &
+			 le32_to_cpu(caps->data[i].inheritable));
+		if (value_cpu & ~new->cap_permitted.cap[i]) {
 			/*
 			 * insufficient to execute correctly
 			 */
@@ -262,11 +261,11 @@ static inline int cap_from_disk(struct vfs_cap_data *caps,
 	 * do not have enough capabilities, we return an error if they are
 	 * missing some "forced" (aka file-permitted) capabilities.
 	 */
-	return bprm->cap_effective ? ret : 0;
+	return *effective ? ret : 0;
 }
 
 /* Locate any VFS capabilities: */
-static int get_file_caps(struct linux_binprm *bprm)
+static int get_file_caps(struct linux_binprm *bprm, bool *effective)
 {
 	struct dentry *dentry;
 	int rc = 0;
@@ -293,7 +292,7 @@ static int get_file_caps(struct linux_binprm *bprm)
 	if (rc < 0)
 		goto out;
 
-	rc = cap_from_disk(&vcaps, bprm, rc);
+	rc = cap_from_disk(&vcaps, bprm, rc, effective);
 	if (rc == -EINVAL)
 		printk(KERN_NOTICE "%s: cap_from_disk returned %d for %s\n",
 		       __func__, rc, bprm->filename);
@@ -317,18 +316,27 @@ int cap_inode_killpriv(struct dentry *dentry)
 	return 0;
 }
 
-static inline int get_file_caps(struct linux_binprm *bprm)
+static inline int get_file_caps(struct linux_binprm *bprm, bool *effective)
 {
 	bprm_clear_caps(bprm);
 	return 0;
 }
 #endif
 
-int cap_bprm_set_security (struct linux_binprm *bprm)
+/*
+ * set up the new credentials for an exec'd task
+ */
+int cap_bprm_set_creds(struct linux_binprm *bprm)
 {
+	const struct cred *old = current_cred();
+	struct cred *new = bprm->cred;
+	bool effective;
 	int ret;
 
-	ret = get_file_caps(bprm);
+	effective = false;
+	ret = get_file_caps(bprm, &effective);
+	if (ret < 0)
+		return ret;
 
 	if (!issecure(SECURE_NOROOT)) {
 		/*
@@ -336,78 +344,67 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
 		 * executables under compatibility mode, we override the
 		 * capability sets for the file.
 		 *
-		 * If only the real uid is 0, we do not set the effective
-		 * bit.
+		 * If only the real uid is 0, we do not set the effective bit.
 		 */
-		if (bprm->e_uid == 0 || current_uid() == 0) {
+		if (new->euid == 0 || new->uid == 0) {
 			/* pP' = (cap_bset & ~0) | (pI & ~0) */
-			bprm->cap_post_exec_permitted = cap_combine(
-				current->cred->cap_bset,
-				current->cred->cap_inheritable);
-			bprm->cap_effective = (bprm->e_uid == 0);
-			ret = 0;
+			new->cap_permitted = cap_combine(old->cap_bset,
+							 old->cap_inheritable);
 		}
+		if (new->euid == 0)
+			effective = true;
 	}
 
-	return ret;
-}
-
-int cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
-{
-	const struct cred *old = current_cred();
-	struct cred *new;
-
-	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
-
-	if (bprm->e_uid != old->uid || bprm->e_gid != old->gid ||
-	    !cap_issubset(bprm->cap_post_exec_permitted,
-			  old->cap_permitted)) {
-		set_dumpable(current->mm, suid_dumpable);
-		current->pdeath_signal = 0;
-
-		if (unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
-			if (!capable(CAP_SETUID)) {
-				bprm->e_uid = old->uid;
-				bprm->e_gid = old->gid;
-			}
-			if (cap_limit_ptraced_target()) {
-				bprm->cap_post_exec_permitted = cap_intersect(
-					bprm->cap_post_exec_permitted,
-					new->cap_permitted);
-			}
+	/* Don't let someone trace a set[ug]id/setpcap binary with the revised
+	 * credentials unless they have the appropriate permit
+	 */
+	if ((new->euid != old->uid ||
+	     new->egid != old->gid ||
+	     !cap_issubset(new->cap_permitted, old->cap_permitted)) &&
+	    bprm->unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
+		/* downgrade; they get no more than they had, and maybe less */
+		if (!capable(CAP_SETUID)) {
+			new->euid = new->uid;
+			new->egid = new->gid;
 		}
+		if (cap_limit_ptraced_target())
+			new->cap_permitted = cap_intersect(new->cap_permitted,
+							   old->cap_permitted);
 	}
 
-	new->suid = new->euid = new->fsuid = bprm->e_uid;
-	new->sgid = new->egid = new->fsgid = bprm->e_gid;
+	new->suid = new->fsuid = new->euid;
+	new->sgid = new->fsgid = new->egid;
 
-	/* For init, we want to retain the capabilities set
-	 * in the init_task struct. Thus we skip the usual
-	 * capability rules */
+	/* For init, we want to retain the capabilities set in the initial
+	 * task.  Thus we skip the usual capability rules
+	 */
 	if (!is_global_init(current)) {
-		new->cap_permitted = bprm->cap_post_exec_permitted;
-		if (bprm->cap_effective)
-			new->cap_effective = bprm->cap_post_exec_permitted;
+		if (effective)
+			new->cap_effective = new->cap_permitted;
 		else
 			cap_clear(new->cap_effective);
 	}
+	bprm->cap_effective = effective;
 
-	/* AUD: Audit candidate if cred->cap_effective is set */
+	/* AUD: Audit candidate if new->cap_effective is set */
 
 	new->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
-	return commit_creds(new);
+	return 0;
 }
 
-int cap_bprm_secureexec (struct linux_binprm *bprm)
+/*
+ * determine whether a secure execution is required
+ * - the creds have been committed at this point, and are no longer available
+ *   through bprm
+ */
+int cap_bprm_secureexec(struct linux_binprm *bprm)
 {
 	const struct cred *cred = current_cred();
 
 	if (cred->uid != 0) {
 		if (bprm->cap_effective)
 			return 1;
-		if (!cap_isclear(bprm->cap_post_exec_permitted))
+		if (!cap_isclear(cred->cap_permitted))
 			return 1;
 	}
 
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index c8d8f3c..717c4f4 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -276,48 +276,6 @@ static int install_session_keyring(struct key *keyring)
 
 /*****************************************************************************/
 /*
- * deal with execve()
- */
-int exec_keys(struct task_struct *tsk)
-{
-	struct thread_group_cred *tgcred = NULL;
-	struct cred *new;
-
-#ifdef CONFIG_KEYS
-	tgcred = kmalloc(sizeof(*tgcred), GFP_KERNEL);
-	if (!tgcred)
-		return -ENOMEM;
-#endif
-
-	new = prepare_creds();
-	if (new < 0)
-		return -ENOMEM;
-
-	/* newly exec'd tasks don't get a thread keyring */
-	key_put(new->thread_keyring);
-	new->thread_keyring = NULL;
-
-	/* create a new per-thread-group creds for all this set of threads to
-	 * share */
-	memcpy(tgcred, new->tgcred, sizeof(struct thread_group_cred));
-
-	atomic_set(&tgcred->usage, 1);
-	spin_lock_init(&tgcred->lock);
-
-	/* inherit the session keyring; new process keyring */
-	key_get(tgcred->session_keyring);
-	tgcred->process_keyring = NULL;
-
-	put_tgcred(new->tgcred);
-	new->tgcred = tgcred;
-
-	commit_creds(new);
-	return 0;
-
-} /* end exec_keys() */
-
-/*****************************************************************************/
-/*
  * the filesystem user ID changed
  */
 void key_fsuid_changed(struct task_struct *tsk)
diff --git a/security/root_plug.c b/security/root_plug.c
index c3f68b5..40fb4f1 100644
--- a/security/root_plug.c
+++ b/security/root_plug.c
@@ -55,9 +55,9 @@ static int rootplug_bprm_check_security (struct linux_binprm *bprm)
 	struct usb_device *dev;
 
 	root_dbg("file %s, e_uid = %d, e_gid = %d\n",
-		 bprm->filename, bprm->e_uid, bprm->e_gid);
+		 bprm->filename, bprm->cred->euid, bprm->cred->egid);
 
-	if (bprm->e_gid == 0) {
+	if (bprm->cred->egid == 0) {
 		dev = usb_find_device(vendor_id, product_id);
 		if (!dev) {
 			root_dbg("e_gid = 0, and device not found, "
@@ -75,15 +75,12 @@ static struct security_operations rootplug_security_ops = {
 	.ptrace_may_access =		cap_ptrace_may_access,
 	.ptrace_traceme =		cap_ptrace_traceme,
 	.capget =			cap_capget,
-	.capset_check =			cap_capset_check,
-	.capset_set =			cap_capset_set,
+	.capset =			cap_capset,
 	.capable =			cap_capable,
 
-	.bprm_apply_creds =		cap_bprm_apply_creds,
-	.bprm_set_security =		cap_bprm_set_security,
+	.bprm_set_creds =		cap_bprm_set_creds,
 
-	.task_post_setuid =		cap_task_post_setuid,
-	.task_reparent_to_init =	cap_task_reparent_to_init,
+	.task_fix_setuid =		cap_task_fix_setuid,
 	.task_prctl =			cap_task_prctl,
 
 	.bprm_check_security =		rootplug_bprm_check_security,
diff --git a/security/security.c b/security/security.c
index c60c334..3da7856 100644
--- a/security/security.c
+++ b/security/security.c
@@ -199,34 +199,24 @@ int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
 	return security_ops->vm_enough_memory(mm, pages);
 }
 
-int security_bprm_alloc(struct linux_binprm *bprm)
+int security_bprm_set_creds(struct linux_binprm *bprm)
 {
-	return security_ops->bprm_alloc_security(bprm);
+	return security_ops->bprm_set_creds(bprm);
 }
 
-void security_bprm_free(struct linux_binprm *bprm)
-{
-	security_ops->bprm_free_security(bprm);
-}
-
-int security_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
-{
-	return security_ops->bprm_apply_creds(bprm, unsafe);
-}
-
-void security_bprm_post_apply_creds(struct linux_binprm *bprm)
+int security_bprm_check(struct linux_binprm *bprm)
 {
-	security_ops->bprm_post_apply_creds(bprm);
+	return security_ops->bprm_check_security(bprm);
 }
 
-int security_bprm_set(struct linux_binprm *bprm)
+void security_bprm_committing_creds(struct linux_binprm *bprm)
 {
-	return security_ops->bprm_set_security(bprm);
+	return security_ops->bprm_committing_creds(bprm);
 }
 
-int security_bprm_check(struct linux_binprm *bprm)
+void security_bprm_committed_creds(struct linux_binprm *bprm)
 {
-	return security_ops->bprm_check_security(bprm);
+	return security_ops->bprm_committed_creds(bprm);
 }
 
 int security_bprm_secureexec(struct linux_binprm *bprm)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 27441e7..f934830 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2028,59 +2028,45 @@ static int selinux_vm_enough_memory(struct mm_struct *mm, long pages)
 
 /* binprm security operations */
 
-static int selinux_bprm_alloc_security(struct linux_binprm *bprm)
+static int selinux_bprm_set_creds(struct linux_binprm *bprm)
 {
-	struct bprm_security_struct *bsec;
-
-	bsec = kzalloc(sizeof(struct bprm_security_struct), GFP_KERNEL);
-	if (!bsec)
-		return -ENOMEM;
-
-	bsec->sid = SECINITSID_UNLABELED;
-	bsec->set = 0;
-
-	bprm->security = bsec;
-	return 0;
-}
-
-static int selinux_bprm_set_security(struct linux_binprm *bprm)
-{
-	struct task_security_struct *tsec;
-	struct inode *inode = bprm->file->f_path.dentry->d_inode;
+	const struct task_security_struct *old_tsec;
+	struct task_security_struct *new_tsec;
 	struct inode_security_struct *isec;
-	struct bprm_security_struct *bsec;
-	u32 newsid;
 	struct avc_audit_data ad;
+	struct inode *inode = bprm->file->f_path.dentry->d_inode;
 	int rc;
 
-	rc = secondary_ops->bprm_set_security(bprm);
+	rc = secondary_ops->bprm_set_creds(bprm);
 	if (rc)
 		return rc;
 
-	bsec = bprm->security;
-
-	if (bsec->set)
+	/* SELinux context only depends on initial program or script and not
+	 * the script interpreter */
+	if (bprm->cred_prepared)
 		return 0;
 
-	tsec = current_security();
+	old_tsec = current_security();
+	new_tsec = bprm->cred->security;
 	isec = inode->i_security;
 
 	/* Default to the current task SID. */
-	bsec->sid = tsec->sid;
+	new_tsec->sid = old_tsec->sid;
+	new_tsec->osid = old_tsec->sid;
 
 	/* Reset fs, key, and sock SIDs on execve. */
-	tsec->create_sid = 0;
-	tsec->keycreate_sid = 0;
-	tsec->sockcreate_sid = 0;
+	new_tsec->create_sid = 0;
+	new_tsec->keycreate_sid = 0;
+	new_tsec->sockcreate_sid = 0;
 
-	if (tsec->exec_sid) {
-		newsid = tsec->exec_sid;
+	if (old_tsec->exec_sid) {
+		new_tsec->sid = old_tsec->exec_sid;
 		/* Reset exec SID on execve. */
-		tsec->exec_sid = 0;
+		new_tsec->exec_sid = 0;
 	} else {
 		/* Check for a default transition on this program. */
-		rc = security_transition_sid(tsec->sid, isec->sid,
-					     SECCLASS_PROCESS, &newsid);
+		rc = security_transition_sid(old_tsec->sid, isec->sid,
+					     SECCLASS_PROCESS, &new_tsec->sid);
 		if (rc)
 			return rc;
 	}
@@ -2089,33 +2075,63 @@ static int selinux_bprm_set_security(struct linux_binprm *bprm)
 	ad.u.fs.path = bprm->file->f_path;
 
 	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
-		newsid = tsec->sid;
+		new_tsec->sid = old_tsec->sid;
 
-	if (tsec->sid == newsid) {
-		rc = avc_has_perm(tsec->sid, isec->sid,
+	if (new_tsec->sid == old_tsec->sid) {
+		rc = avc_has_perm(old_tsec->sid, isec->sid,
 				  SECCLASS_FILE, FILE__EXECUTE_NO_TRANS, &ad);
 		if (rc)
 			return rc;
 	} else {
 		/* Check permissions for the transition. */
-		rc = avc_has_perm(tsec->sid, newsid,
+		rc = avc_has_perm(old_tsec->sid, new_tsec->sid,
 				  SECCLASS_PROCESS, PROCESS__TRANSITION, &ad);
 		if (rc)
 			return rc;
 
-		rc = avc_has_perm(newsid, isec->sid,
+		rc = avc_has_perm(new_tsec->sid, isec->sid,
 				  SECCLASS_FILE, FILE__ENTRYPOINT, &ad);
 		if (rc)
 			return rc;
 
-		/* Clear any possibly unsafe personality bits on exec: */
-		current->personality &= ~PER_CLEAR_ON_SETID;
+		/* Check for shared state */
+		if (bprm->unsafe & LSM_UNSAFE_SHARE) {
+			rc = avc_has_perm(old_tsec->sid, new_tsec->sid,
+					  SECCLASS_PROCESS, PROCESS__SHARE,
+					  NULL);
+			if (rc)
+				return -EPERM;
+		}
+
+		/* Make sure that anyone attempting to ptrace over a task that
+		 * changes its SID has the appropriate permit */
+		if (bprm->unsafe &
+		    (LSM_UNSAFE_PTRACE | LSM_UNSAFE_PTRACE_CAP)) {
+			struct task_struct *tracer;
+			struct task_security_struct *sec;
+			u32 ptsid = 0;
+
+			rcu_read_lock();
+			tracer = tracehook_tracer_task(current);
+			if (likely(tracer != NULL)) {
+				sec = __task_cred(tracer)->security;
+				ptsid = sec->sid;
+			}
+			rcu_read_unlock();
 
-		/* Set the security field to the new SID. */
-		bsec->sid = newsid;
+			if (ptsid != 0) {
+				rc = avc_has_perm(ptsid, new_tsec->sid,
+						  SECCLASS_PROCESS,
+						  PROCESS__PTRACE, NULL);
+				if (rc)
+					return -EPERM;
+			}
+		}
+
+		/* Clear any possibly unsafe personality bits on exec: */
+		bprm->per_clear |= PER_CLEAR_ON_SETID;
 	}
 
-	bsec->set = 1;
 	return 0;
 }
 
@@ -2124,7 +2140,6 @@ static int selinux_bprm_check_security(struct linux_binprm *bprm)
 	return secondary_ops->bprm_check_security(bprm);
 }
 
-
 static int selinux_bprm_secureexec(struct linux_binprm *bprm)
 {
 	const struct cred *cred = current_cred();
@@ -2140,19 +2155,13 @@ static int selinux_bprm_secureexec(struct linux_binprm *bprm)
 		   the noatsecure permission is granted between
 		   the two SIDs, i.e. ahp returns 0. */
 		atsecure = avc_has_perm(osid, sid,
-					 SECCLASS_PROCESS,
-					 PROCESS__NOATSECURE, NULL);
+					SECCLASS_PROCESS,
+					PROCESS__NOATSECURE, NULL);
 	}
 
 	return (atsecure || secondary_ops->bprm_secureexec(bprm));
 }
 
-static void selinux_bprm_free_security(struct linux_binprm *bprm)
-{
-	kfree(bprm->security);
-	bprm->security = NULL;
-}
-
 extern struct vfsmount *selinuxfs_mount;
 extern struct dentry *selinux_null;
 
@@ -2250,106 +2259,83 @@ static inline void flush_unauthorized_files(const struct cred *cred,
 	spin_unlock(&files->file_lock);
 }
 
-static int selinux_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
+/*
+ * Prepare a process for imminent new credential changes due to exec
+ */
+static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
 {
-	struct task_security_struct *tsec;
-	struct bprm_security_struct *bsec;
-	struct cred *new;
-	u32 sid;
-	int rc;
-
-	rc = secondary_ops->bprm_apply_creds(bprm, unsafe);
-	if (rc < 0)
-		return rc;
+	struct task_security_struct *new_tsec;
+	struct rlimit *rlim, *initrlim;
+	int rc, i;
 
-	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
+	secondary_ops->bprm_committing_creds(bprm);
 
-	tsec = new->security;
+	new_tsec = bprm->cred->security;
+	if (new_tsec->sid == new_tsec->osid)
+		return;
 
-	bsec = bprm->security;
-	sid = bsec->sid;
-
-	tsec->osid = tsec->sid;
-	bsec->unsafe = 0;
-	if (tsec->sid != sid) {
-		/* Check for shared state.  If not ok, leave SID
-		   unchanged and kill. */
-		if (unsafe & LSM_UNSAFE_SHARE) {
-			rc = avc_has_perm(tsec->sid, sid, SECCLASS_PROCESS,
-					PROCESS__SHARE, NULL);
-			if (rc) {
-				bsec->unsafe = 1;
-				goto out;
-			}
-		}
+	/* Close files for which the new task SID is not authorized. */
+	flush_unauthorized_files(bprm->cred, current->files);
 
-		/* Check for ptracing, and update the task SID if ok.
-		   Otherwise, leave SID unchanged and kill. */
-		if (unsafe & (LSM_UNSAFE_PTRACE | LSM_UNSAFE_PTRACE_CAP)) {
-			struct task_struct *tracer;
-			struct task_security_struct *sec;
-			u32 ptsid = 0;
+	/* Always clear parent death signal on SID transitions. */
+	current->pdeath_signal = 0;
 
-			rcu_read_lock();
-			tracer = tracehook_tracer_task(current);
-			if (likely(tracer != NULL)) {
-				sec = __task_cred(tracer)->security;
-				ptsid = sec->sid;
-			}
-			rcu_read_unlock();
+	/* Check whether the new SID can inherit resource limits from the old
+	 * SID.  If not, reset all soft limits to the lower of the current
+	 * task's hard limit and the init task's soft limit.
+	 *
+	 * Note that the setting of hard limits (even to lower them) can be
+	 * controlled by the setrlimit check.  The inclusion of the init task's
+	 * soft limit into the computation is to avoid resetting soft limits
+	 * higher than the default soft limit for cases where the default is
+	 * lower than the hard limit, e.g. RLIMIT_CORE or RLIMIT_STACK.
+	 */
+	rc = avc_has_perm(new_tsec->osid, new_tsec->sid, SECCLASS_PROCESS,
+			  PROCESS__RLIMITINH, NULL);
+	if (rc) {
+		for (i = 0; i < RLIM_NLIMITS; i++) {
+			rlim = current->signal->rlim + i;
+			initrlim = init_task.signal->rlim+i;
+			rlim->rlim_cur = min(rlim->rlim_max, initrlim->rlim_cur);
+		}
 
-			if (ptsid != 0) {
-				rc = avc_has_perm(ptsid, sid, SECCLASS_PROCESS,
-						  PROCESS__PTRACE, NULL);
-				if (rc) {
-					bsec->unsafe = 1;
-					goto out;
-				}
-			}
+		if (current->signal->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
+			/*
+			 * This will cause RLIMIT_CPU calculations to be
+			 * refigured.
+			 */
+			current->it_prof_expires = jiffies_to_cputime(1);
 		}
-		tsec->sid = sid;
 	}
-
-out:
-	commit_creds(new);
-	return 0;
 }
 
 /*
- * called after apply_creds without the task lock held
+ * Clean up the process immediately after the installation of new credentials
+ * due to exec
  */
-static void selinux_bprm_post_apply_creds(struct linux_binprm *bprm)
+static void selinux_bprm_committed_creds(struct linux_binprm *bprm)
 {
-	const struct cred *cred = current_cred();
-	struct task_security_struct *tsec;
-	struct rlimit *rlim, *initrlim;
+	const struct task_security_struct *tsec = current_security();
 	struct itimerval itimer;
-	struct bprm_security_struct *bsec;
+	u32 osid, sid;
 	int rc, i;
 
-	tsec = current_security();
-	bsec = bprm->security;
+	secondary_ops->bprm_committed_creds(bprm);
 
-	if (bsec->unsafe) {
-		force_sig_specific(SIGKILL, current);
-		return;
-	}
-	if (tsec->osid == tsec->sid)
+	osid = tsec->osid;
+	sid = tsec->sid;
+
+	if (sid == osid)
 		return;
 
-	/* Close files for which the new task SID is not authorized. */
-	flush_unauthorized_files(cred, current->files);
-
-	/* Check whether the new SID can inherit signal state
-	   from the old SID.  If not, clear itimers to avoid
-	   subsequent signal generation and flush and unblock
-	   signals. This must occur _after_ the task SID has
-	  been updated so that any kill done after the flush
-	  will be checked against the new SID. */
-	rc = avc_has_perm(tsec->osid, tsec->sid, SECCLASS_PROCESS,
-			  PROCESS__SIGINH, NULL);
+	/* Check whether the new SID can inherit signal state from the old SID.
+	 * If not, clear itimers to avoid subsequent signal generation and
+	 * flush and unblock signals.
+	 *
+	 * This must occur _after_ the task SID has been updated so that any
+	 * kill done after the flush will be checked against the new SID.
+	 */
+	rc = avc_has_perm(osid, sid, SECCLASS_PROCESS, PROCESS__SIGINH, NULL);
 	if (rc) {
 		memset(&itimer, 0, sizeof itimer);
 		for (i = 0; i < 3; i++)
@@ -2362,36 +2348,6 @@ static void selinux_bprm_post_apply_creds(struct linux_binprm *bprm)
 		spin_unlock_irq(&current->sighand->siglock);
 	}
 
-	/* Always clear parent death signal on SID transitions. */
-	current->pdeath_signal = 0;
-
-	/* Check whether the new SID can inherit resource limits
-	   from the old SID.  If not, reset all soft limits to
-	   the lower of the current task's hard limit and the init
-	   task's soft limit.  Note that the setting of hard limits
-	   (even to lower them) can be controlled by the setrlimit
-	   check. The inclusion of the init task's soft limit into
-	   the computation is to avoid resetting soft limits higher
-	   than the default soft limit for cases where the default
-	   is lower than the hard limit, e.g. RLIMIT_CORE or
-	   RLIMIT_STACK.*/
-	rc = avc_has_perm(tsec->osid, tsec->sid, SECCLASS_PROCESS,
-			  PROCESS__RLIMITINH, NULL);
-	if (rc) {
-		for (i = 0; i < RLIM_NLIMITS; i++) {
-			rlim = current->signal->rlim + i;
-			initrlim = init_task.signal->rlim+i;
-			rlim->rlim_cur = min(rlim->rlim_max, initrlim->rlim_cur);
-		}
-		if (current->signal->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
-			/*
-			 * This will cause RLIMIT_CPU calculations
-			 * to be refigured.
-			 */
-			current->it_prof_expires = jiffies_to_cputime(1);
-		}
-	}
-
 	/* Wake up the parent if it is waiting so that it can
 	   recheck wait permission to the new task SID. */
 	wake_up_interruptible(&current->parent->signal->wait_chldexit);
@@ -5456,12 +5412,10 @@ static struct security_operations selinux_ops = {
 	.netlink_send =			selinux_netlink_send,
 	.netlink_recv =			selinux_netlink_recv,
 
-	.bprm_alloc_security =		selinux_bprm_alloc_security,
-	.bprm_free_security =		selinux_bprm_free_security,
-	.bprm_apply_creds =		selinux_bprm_apply_creds,
-	.bprm_post_apply_creds =	selinux_bprm_post_apply_creds,
-	.bprm_set_security =		selinux_bprm_set_security,
+	.bprm_set_creds =		selinux_bprm_set_creds,
 	.bprm_check_security =		selinux_bprm_check_security,
+	.bprm_committing_creds =	selinux_bprm_committing_creds,
+	.bprm_committed_creds =		selinux_bprm_committed_creds,
 	.bprm_secureexec =		selinux_bprm_secureexec,
 
 	.sb_alloc_security =		selinux_sb_alloc_security,
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index 91070ab..b831e17 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -77,17 +77,6 @@ struct ipc_security_struct {
 	u32 sid;	/* SID of IPC resource */
 };
 
-struct bprm_security_struct {
-	u32 sid;		/* SID for transformed process */
-	unsigned char set;
-
-	/*
-	 * unsafe is used to share failure information from bprm_apply_creds()
-	 * to bprm_post_apply_creds().
-	 */
-	char unsafe;
-};
-
 struct netif_security_struct {
 	int ifindex;			/* device index */
 	u32 sid;			/* SID for this interface */
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 22e5271..3cf91f5 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2593,8 +2593,7 @@ struct security_operations smack_ops = {
 	.settime = 			cap_settime,
 	.vm_enough_memory = 		cap_vm_enough_memory,
 
-	.bprm_apply_creds = 		cap_bprm_apply_creds,
-	.bprm_set_security = 		cap_bprm_set_security,
+	.bprm_set_creds = 		cap_bprm_set_creds,
 	.bprm_secureexec = 		cap_bprm_secureexec,
 
 	.sb_alloc_security = 		smack_sb_alloc_security,

