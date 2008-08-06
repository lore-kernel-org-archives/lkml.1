Return-Path: <linux-kernel-owner+w=401wt.eu-S1760671AbYHFPnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671AbYHFPnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759364AbYHFPjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:39:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759498AbYHFPjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:39:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 17/24] CRED: Inaugurate COW credentials [ver #7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:38:42 +0100
Message-ID: <20080806153841.14351.90557.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inaugurate copy-on-write credentials management.  This uses RCU to manage the
credentials pointer in the task_struct with respect to accesses by other tasks.
A process may only modify its own credentials, and so does not need locking to
access or modify its own credentials.

A mutex (cred_replace_mutex) is added to the task_struct to control the effect
of PTRACE_ATTACHED on credential calculations, particularly with respect to
execve().

With this patch, the contents of an active credentials struct may not be
changed directly; rather a new set of credentials must be prepared, modified
and committed using something like the following sequence of events:

	struct cred *new = prepare_creds();
	int ret = blah(new);
	if (ret < 0) {
		abort_creds(new);
		return ret;
	}
	return commit_creds(new);

There are some exceptions to this rule: the keyrings pointed to by the active
credentials may be instantiated - keyrings violate the COW rule as managing
COW keyrings is tricky, given that it is possible for a task to directly alter
the keys in a keyring in use by another task.

This patch and the preceding patches have been tested with the LTP SELinux
testsuite.


This patch makes several logical sets of alteration:

 (1) execve().

     This now prepares and commits credentials in various places in the
     security code rather than altering the current creds directly.

 (2) Temporary credential overrides.

     do_coredump() and sys_faccessat() now prepare their own credentials and
     temporarily override the ones currently on the acting thread, whilst
     preventing interference from other threads by holding cred_replace_mutex
     on the thread being dumped.

     This will be replaced in a future patch by something that hands down the
     credentials directly to the functions being called, rather than altering
     the task's objective credentials.

 (3) LSM interface.

     A number of functions have been changed, added or removed:

     (*) security_capset_check(), ->capset_check()
     (*) security_capset_set(), ->capset_set()

     	 Removed in favour of security_capset().

     (*) security_capset(), ->capset()

     	 New.  This is passed a pointer to the new creds, a pointer to the old
     	 creds and the proposed capability sets.  It should fill in the new
     	 creds or return an error.  All pointers, barring the pointer to the
     	 new creds, are now const.

     (*) security_bprm_apply_creds(), ->bprm_apply_creds()

     	 Changed; now returns a value, which will cause the process to be
     	 killed if it's an error.

     (*) security_task_alloc(), ->task_alloc_security()

     	 Removed in favour of security_prepare_creds().

     (*) security_cred_free(), ->cred_free()

     	 New.  Free security data attached to cred->security.

     (*) security_prepare_creds(), ->cred_prepare()

     	 New. Duplicate any security data attached to cred->security.

     (*) security_commit_creds(), ->cred_commit()

     	 New. Apply any security effects for the upcoming installation of new
     	 security by commit_creds().

     (*) security_task_post_setuid(), ->task_post_setuid()

     	 Removed in favour of security_task_fix_setuid().

     (*) security_task_fix_setuid(), ->task_fix_setuid()

     	 Fix up the proposed new credentials for setuid().  This is used by
     	 cap_set_fix_setuid() to implicitly adjust capabilities in line with
     	 setuid() changes.  Changes are made to the new credentials, rather
     	 than the task itself as in security_task_post_setuid().

     (*) security_task_reparent_to_init(), ->task_reparent_to_init()

     	 Removed.  Instead the task being reparented to init is referred
     	 directly to init's credentials.

	 NOTE!  This results in the loss of some state: SELinux's osid no
	 longer records the sid of the thread that forked it.

     (*) security_key_alloc(), ->key_alloc()
     (*) security_key_permission(), ->key_permission()

     	 Changed.  These now take cred pointers rather than task pointers to
     	 refer to the security context.

 (4) sys_capset().

     This has been simplified and uses less locking.  The LSM functions it
     calls have been merged.

 (5) reparent_to_kthreadd().

     This gives the current thread the same credentials as init by simply using
     commit_thread() to point that way.

 (6) __sigqueue_alloc() and switch_uid()

     __sigqueue_alloc() can't stop the target task from changing its creds
     beneath it, so this function gets a reference to the currently applicable
     user_struct which it then passes into the sigqueue struct it returns if
     successful.

     switch_uid() is now called from commit_creds(), and possibly should be
     folded into that.  commit_creds() should take care of protecting
     __sigqueue_alloc().

 (7) [sg]et[ug]id() and co and [sg]et_current_groups.

     The set functions now all use prepare_creds(), commit_creds() and
     abort_creds() to build and check a new set of credentials before applying
     it.

     security_task_set[ug]id() is called inside the prepared section.  This
     guarantees that nothing else will affect the creds until we've finished.

     The calling of set_dumpable() has been moved into commit_creds().

     Much of the functionality of set_user() has been moved into
     commit_creds().

     The get functions all simply access the data directly.

 (8) security_task_prctl() and cap_task_prctl().

     security_task_prctl() has been modified to return -ENOSYS if it doesn't
     want to handle a function, or otherwise return the return value directly
     rather than through an argument.

     Additionally, cap_task_prctl() now prepares a new set of credentials, even
     if it doesn't end up using it.

 (9) Keyrings.

     A number of changes have been made to the keyrings code:

     (a) switch_uid_keyring(), copy_keys(), exit_keys() and suid_keys() have
     	 all been dropped and built in to the credentials functions directly.
     	 They may want separating out again later.

     (b) key_alloc() and search_process_keyrings() now take a cred pointer
     	 rather than a task pointer to specify the security context.

     (c) copy_creds() gives a new thread within the same thread group a new
     	 thread keyring if its parent had one, otherwise it discards the thread
     	 keyring.

     (d) The authorisation key now points directly to the credentials to extend
     	 the search into rather pointing to the task that carries them.

     (e) Installing thread, process or session keyrings causes a new set of
     	 credentials to be created, even though it's not strictly necessary for
     	 process or session keyrings (they're shared).

(10) Usermode helper.

     The usermode helper code now carries a cred struct pointer in its
     subprocess_info struct instead of a new session keyring pointer.  This set
     of credentials is derived from init_cred and installed on the new process
     after it has been cloned.

     call_usermodehelper_setup() allocates the new credentials and
     call_usermodehelper_freeinfo() discards them if they haven't been used.  A
     special cred function (prepare_usermodeinfo_creds()) is provided
     specifically for call_usermodehelper_setup() to call.

     call_usermodehelper_setkeys() adjusts the credentials to sport the
     supplied keyring as the new session keyring.

(11) SELinux.

     SELinux has a number of changes, in addition to those to support the LSM
     interface changes mentioned above:

     (a) selinux_setprocattr() no longer does its check for whether the
     	 current ptracer can access processes with the new SID inside the lock
     	 that covers getting the ptracer's SID.  Whilst this lock ensures that
     	 the check is done with the ptracer pinned, the result is only valid
     	 until the lock is released, so there's no point doing it inside the
     	 lock.

(12) is_single_threaded().

     This function has been extracted from selinux_setprocattr() and put into
     a file of its own in the lib/ directory as join_session_keyring() now
     wants to use it too.

     The code in SELinux just checked to see whether a task shared mm_structs
     with other tasks (CLONE_VM), but that isn't good enough.  We really want
     to know if they're part of the same thread group (CLONE_THREAD).

(13) nfsd.

     The NFS server daemon now has to use the COW credentials to set the
     credentials it is going to use.  It really needs to pass the credentials
     down to the functions it calls, but it can't do that until other patches
     in this series have been applied.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: James Morris <jmorris@namei.org>
---

 fs/exec.c                        |   31 ++-
 fs/nfsd/auth.c                   |   92 ++++----
 fs/nfsd/nfs4recover.c            |   68 ++++--
 fs/nfsd/nfsfh.c                  |   11 +
 fs/open.c                        |   31 +--
 include/linux/capability.h       |    2 
 include/linux/cred.h             |   44 +++-
 include/linux/init_task.h        |    2 
 include/linux/key.h              |   24 +-
 include/linux/sched.h            |    6 -
 include/linux/security.h         |  178 +++++++--------
 init/main.c                      |    1 
 kernel/capability.c              |   63 ++---
 kernel/cred-internals.h          |   26 ++
 kernel/cred.c                    |  328 +++++++++++++++++++++++++---
 kernel/exit.c                    |    9 -
 kernel/fork.c                    |    7 -
 kernel/kmod.c                    |   30 ++-
 kernel/ptrace.c                  |    9 +
 kernel/signal.c                  |   10 +
 kernel/sys.c                     |  452 +++++++++++++++++++++-----------------
 kernel/user.c                    |   37 ---
 kernel/user_namespace.c          |   12 +
 lib/Makefile                     |    2 
 lib/is_single_threaded.c         |   45 ++++
 net/rxrpc/ar-key.c               |    6 -
 security/capability.c            |   21 +-
 security/commoncap.c             |  256 ++++++++++------------
 security/keys/internal.h         |   17 +
 security/keys/key.c              |   25 +-
 security/keys/keyctl.c           |   95 ++++++--
 security/keys/keyring.c          |   14 +
 security/keys/permission.c       |   24 +-
 security/keys/proc.c             |    8 +
 security/keys/process_keys.c     |  333 ++++++++++++++--------------
 security/keys/request_key.c      |   29 ++
 security/keys/request_key_auth.c |   41 ++-
 security/security.c              |   58 ++---
 security/selinux/hooks.c         |  274 ++++++++++++-----------
 security/smack/smack_lsm.c       |   82 ++++---
 40 files changed, 1617 insertions(+), 1186 deletions(-)
 create mode 100644 kernel/cred-internals.h
 create mode 100644 lib/is_single_threaded.c


diff --git a/fs/exec.c b/fs/exec.c
index 4867ee1..fb7ace1 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1012,13 +1012,12 @@ int flush_old_exec(struct linux_binprm * bprm)
 	 */
 	current->mm->task_size = TASK_SIZE;
 
-	if (bprm->e_uid != current_euid() || bprm->e_gid != current_egid()) {
-		suid_keys(current);
+	if (bprm->e_uid != current_euid() ||
+	    bprm->e_gid != current_egid()) {
 		set_dumpable(current->mm, suid_dumpable);
 		current->pdeath_signal = 0;
 	} else if (file_permission(bprm->file, MAY_READ) ||
 			(bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP)) {
-		suid_keys(current);
 		set_dumpable(current->mm, suid_dumpable);
 	}
 
@@ -1101,10 +1100,8 @@ void compute_creds(struct linux_binprm *bprm)
 {
 	int unsafe;
 
-	if (bprm->e_uid != current_uid()) {
-		suid_keys(current);
+	if (bprm->e_uid != current_uid())
 		current->pdeath_signal = 0;
-	}
 	exec_keys(current);
 
 	task_lock(current);
@@ -1715,8 +1712,9 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	struct linux_binfmt * binfmt;
 	struct inode * inode;
 	struct file * file;
+	const struct cred *old_cred;
+	struct cred *cred;
 	int retval = 0;
-	int fsuid = current_fsuid();
 	int flag = 0;
 	int ispipe = 0;
 	unsigned long core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
@@ -1729,12 +1727,20 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	binfmt = current->binfmt;
 	if (!binfmt || !binfmt->core_dump)
 		goto fail;
+
+	cred = prepare_creds();
+	if (!cred) {
+		retval = -ENOMEM;
+		goto fail;
+	}
+
 	down_write(&mm->mmap_sem);
 	/*
 	 * If another thread got here first, or we are not dumpable, bail out.
 	 */
 	if (mm->core_state || !get_dumpable(mm)) {
 		up_write(&mm->mmap_sem);
+		put_cred(cred);
 		goto fail;
 	}
 
@@ -1745,12 +1751,16 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	 */
 	if (get_dumpable(mm) == 2) {	/* Setuid core dump mode */
 		flag = O_EXCL;		/* Stop rewrite attacks */
-		current->cred->fsuid = 0;	/* Dump root private */
+		cred->fsuid = 0;	/* Dump root private */
 	}
 
 	retval = coredump_wait(exit_code, &core_state);
-	if (retval < 0)
+	if (retval < 0) {
+		put_cred(cred);
 		goto fail;
+	}
+
+	old_cred = override_creds(cred);
 
 	/*
 	 * Clear any false indication of pending signals that might
@@ -1841,7 +1851,8 @@ fail_unlock:
 	if (helper_argv)
 		argv_free(helper_argv);
 
-	current->cred->fsuid = fsuid;
+	revert_creds(old_cred);
+	put_cred(cred);
 	coredump_finish(mm);
 fail:
 	return retval;
diff --git a/fs/nfsd/auth.c b/fs/nfsd/auth.c
index 808fc03..836ffa1 100644
--- a/fs/nfsd/auth.c
+++ b/fs/nfsd/auth.c
@@ -27,55 +27,67 @@ int nfsexp_flags(struct svc_rqst *rqstp, struct svc_export *exp)
 
 int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 {
-	struct cred *act_as = current->cred ;
-	struct svc_cred	cred = rqstp->rq_cred;
+	struct group_info *rqgi;
+	struct group_info *gi;
+	struct cred *new;
 	int i;
 	int flags = nfsexp_flags(rqstp, exp);
 	int ret;
 
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
+	new->fsuid = rqstp->rq_cred.cr_uid;
+	new->fsgid = rqstp->rq_cred.cr_gid;
+
+	rqgi = rqstp->rq_cred.cr_group_info;
+
 	if (flags & NFSEXP_ALLSQUASH) {
-		cred.cr_uid = exp->ex_anon_uid;
-		cred.cr_gid = exp->ex_anon_gid;
-		cred.cr_group_info = groups_alloc(0);
+		new->fsuid = exp->ex_anon_uid;
+		new->fsgid = exp->ex_anon_gid;
+		gi = groups_alloc(0);
 	} else if (flags & NFSEXP_ROOTSQUASH) {
-		struct group_info *gi;
-		if (!cred.cr_uid)
-			cred.cr_uid = exp->ex_anon_uid;
-		if (!cred.cr_gid)
-			cred.cr_gid = exp->ex_anon_gid;
-		gi = groups_alloc(cred.cr_group_info->ngroups);
-		if (gi)
-			for (i = 0; i < cred.cr_group_info->ngroups; i++) {
-				if (!GROUP_AT(cred.cr_group_info, i))
-					GROUP_AT(gi, i) = exp->ex_anon_gid;
-				else
-					GROUP_AT(gi, i) = GROUP_AT(cred.cr_group_info, i);
-			}
-		cred.cr_group_info = gi;
-	} else
-		get_group_info(cred.cr_group_info);
-
-	if (cred.cr_uid != (uid_t) -1)
-		act_as->fsuid = cred.cr_uid;
-	else
-		act_as->fsuid = exp->ex_anon_uid;
-	if (cred.cr_gid != (gid_t) -1)
-		act_as->fsgid = cred.cr_gid;
-	else
-		act_as->fsgid = exp->ex_anon_gid;
+		if (!new->fsuid)
+			new->fsuid = exp->ex_anon_uid;
+		if (!new->fsgid)
+			new->fsgid = exp->ex_anon_gid;
 
-	if (!cred.cr_group_info)
-		return -ENOMEM;
-	ret = set_groups(act_as, cred.cr_group_info);
-	put_group_info(cred.cr_group_info);
-	if ((cred.cr_uid)) {
-		act_as->cap_effective =
-			cap_drop_nfsd_set(act_as->cap_effective);
+		gi = groups_alloc(rqgi->ngroups);
+		if (!gi)
+			goto oom;
+
+		for (i = 0; i < rqgi->ngroups; i++) {
+			if (!GROUP_AT(rqgi, i))
+				GROUP_AT(gi, i) = exp->ex_anon_gid;
+			else
+				GROUP_AT(gi, i) = GROUP_AT(rqgi, i);
+		}
 	} else {
-		act_as->cap_effective =
-			cap_raise_nfsd_set(act_as->cap_effective,
-					   act_as->cap_permitted);
+		gi = get_group_info(rqgi);
 	}
+
+	if (new->fsuid == (uid_t) -1)
+		new->fsuid = exp->ex_anon_uid;
+	if (new->fsgid == (gid_t) -1)
+		new->fsgid = exp->ex_anon_gid;
+
+	ret = set_groups(new, gi);
+	put_group_info(gi);
+	if (!ret)
+		goto error;
+
+	if (new->uid)
+		new->cap_effective = cap_drop_nfsd_set(new->cap_effective);
+	else
+		new->cap_effective = cap_raise_nfsd_set(new->cap_effective,
+							new->cap_permitted);
+	return commit_creds(new);
+
+oom:
+	ret = -ENOMEM;
+error:
+	abort_creds(new);
 	return ret;
 }
 
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 7092d37..f3a7f35 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -54,20 +54,26 @@
 static struct nameidata rec_dir;
 static int rec_dir_init = 0;
 
-static void
-nfs4_save_user(uid_t *saveuid, gid_t *savegid)
+static int
+nfs4_save_creds(const struct cred **original_creds)
 {
-	*saveuid = current->cred->fsuid;
-	*savegid = current->cred->fsgid;
-	current->cred->fsuid = 0;
-	current->cred->fsgid = 0;
+	struct cred *new;
+
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
+	new->fsuid = 0;
+	new->fsgid = 0;
+	*original_creds = override_creds(new);
+	put_cred(new);
+	return 0;
 }
 
 static void
-nfs4_reset_user(uid_t saveuid, gid_t savegid)
+nfs4_reset_creds(const struct cred *original)
 {
-	current->cred->fsuid = saveuid;
-	current->cred->fsgid = savegid;
+	revert_creds(original);
 }
 
 static void
@@ -129,10 +135,9 @@ nfsd4_sync_rec_dir(void)
 int
 nfsd4_create_clid_dir(struct nfs4_client *clp)
 {
+	const struct cred *original_cred;
 	char *dname = clp->cl_recdir;
 	struct dentry *dentry;
-	uid_t uid;
-	gid_t gid;
 	int status;
 
 	dprintk("NFSD: nfsd4_create_clid_dir for \"%s\"\n", dname);
@@ -140,7 +145,9 @@ nfsd4_create_clid_dir(struct nfs4_client *clp)
 	if (!rec_dir_init || clp->cl_firststate)
 		return 0;
 
-	nfs4_save_user(&uid, &gid);
+	status = nfs4_save_creds(&original_cred);
+	if (status < 0)
+		return status;
 
 	/* lock the parent */
 	mutex_lock(&rec_dir.path.dentry->d_inode->i_mutex);
@@ -168,7 +175,7 @@ out_unlock:
 		clp->cl_firststate = 1;
 		nfsd4_sync_rec_dir();
 	}
-	nfs4_reset_user(uid, gid);
+	nfs4_reset_creds(original_cred);
 	dprintk("NFSD: nfsd4_create_clid_dir returns %d\n", status);
 	return status;
 }
@@ -211,20 +218,21 @@ nfsd4_build_dentrylist(void *arg, const char *name, int namlen,
 static int
 nfsd4_list_rec_dir(struct dentry *dir, recdir_func *f)
 {
+	const struct cred *original_cred;
 	struct file *filp;
 	struct dentry_list_arg dla = {
 		.parent = dir,
 	};
 	struct list_head *dentries = &dla.dentries;
 	struct dentry_list *child;
-	uid_t uid;
-	gid_t gid;
 	int status;
 
 	if (!rec_dir_init)
 		return 0;
 
-	nfs4_save_user(&uid, &gid);
+	status = nfs4_save_creds(&original_cred);
+	if (status < 0)
+		return status;
 
 	filp = dentry_open(dget(dir), mntget(rec_dir.path.mnt), O_RDONLY,
 			   current_cred());
@@ -250,7 +258,7 @@ out:
 		dput(child->dentry);
 		kfree(child);
 	}
-	nfs4_reset_user(uid, gid);
+	nfs4_reset_creds(original_cred);
 	return status;
 }
 
@@ -312,8 +320,7 @@ out:
 void
 nfsd4_remove_clid_dir(struct nfs4_client *clp)
 {
-	uid_t uid;
-	gid_t gid;
+	const struct cred *original_cred;
 	int status;
 
 	if (!rec_dir_init || !clp->cl_firststate)
@@ -323,9 +330,13 @@ nfsd4_remove_clid_dir(struct nfs4_client *clp)
 	if (status)
 		goto out;
 	clp->cl_firststate = 0;
-	nfs4_save_user(&uid, &gid);
+
+	status = nfs4_save_creds(&original_cred);
+	if (status < 0)
+		goto out;
+
 	status = nfsd4_unlink_clid_dir(clp->cl_recdir, HEXDIR_LEN-1);
-	nfs4_reset_user(uid, gid);
+	nfs4_reset_creds(original_cred);
 	if (status == 0)
 		nfsd4_sync_rec_dir();
 	mnt_drop_write(rec_dir.path.mnt);
@@ -402,16 +413,21 @@ nfsd4_recdir_load(void) {
 void
 nfsd4_init_recdir(char *rec_dirname)
 {
-	uid_t			uid = 0;
-	gid_t			gid = 0;
-	int 			status;
+	const struct cred *original_cred;
+	int status;
 
 	printk("NFSD: Using %s as the NFSv4 state recovery directory\n",
 			rec_dirname);
 
 	BUG_ON(rec_dir_init);
 
-	nfs4_save_user(&uid, &gid);
+	status = nfs4_save_creds(&original_cred);
+	if (status < 0) {
+		printk("NFSD: Unable to change credentials to find recovery"
+		       " directory: error %d\n",
+		       status);
+		return;
+	}
 
 	status = path_lookup(rec_dirname, LOOKUP_FOLLOW | LOOKUP_DIRECTORY,
 			&rec_dir);
@@ -421,7 +437,7 @@ nfsd4_init_recdir(char *rec_dirname)
 
 	if (!status)
 		rec_dir_init = 1;
-	nfs4_reset_user(uid, gid);
+	nfs4_reset_creds(original_cred);
 }
 
 void
diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index 54be127..8824453 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -186,9 +186,14 @@ static __be32 nfsd_set_fh_dentry(struct svc_rqst *rqstp, struct svc_fh *fhp)
 		 * access control settings being in effect, we cannot
 		 * fix that case easily.
 		 */
-		current->cred->cap_effective =
-			cap_raise_nfsd_set(current->cred->cap_effective,
-					   current->cred->cap_permitted);
+		struct cred *new = prepare_creds();
+		if (!new)
+			return nfserrno(-ENOMEM);
+		new->cap_effective =
+			cap_raise_nfsd_set(new->cap_effective,
+					   new->cap_permitted);
+		put_cred(override_creds(new));
+		put_cred(new);
 	} else {
 		error = nfsd_setuser_and_check_port(rqstp, exp);
 		if (error)
diff --git a/fs/open.c b/fs/open.c
index 4d0afbe..67d0b6e 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -425,30 +425,33 @@ out:
  */
 asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 {
-	struct cred *cred = current->cred;
+	const struct cred *old_cred;
+	struct cred *override_cred;
 	struct path path;
 	struct inode *inode;
-	int old_fsuid, old_fsgid;
-	kernel_cap_t uninitialized_var(old_cap);  /* !SECURE_NO_SETUID_FIXUP */
 	int res;
 
 	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
 		return -EINVAL;
 
-	old_fsuid = cred->fsuid;
-	old_fsgid = cred->fsgid;
+	override_cred = prepare_creds();
+	if (!override_cred)
+		return -ENOMEM;
 
-	cred->fsuid = cred->uid;
-	cred->fsgid = cred->gid;
+	override_cred->fsuid = override_cred->uid;
+	override_cred->fsgid = override_cred->gid;
 
 	if (!issecure(SECURE_NO_SETUID_FIXUP)) {
 		/* Clear the capabilities if we switch to a non-root user */
-		if (current->cred->uid)
-			old_cap = cap_set_effective(__cap_empty_set);
+		if (override_cred->uid)
+			cap_clear(override_cred->cap_effective);
 		else
-			old_cap = cap_set_effective(cred->cap_permitted);
+			override_cred->cap_effective =
+				override_cred->cap_permitted;
 	}
 
+	old_cred = override_creds(override_cred);
+
 	res = user_path_at(dfd, filename, LOOKUP_FOLLOW, &path);
 	if (res)
 		goto out;
@@ -485,12 +488,8 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 out_path_release:
 	path_put(&path);
 out:
-	cred->fsuid = old_fsuid;
-	cred->fsgid = old_fsgid;
-
-	if (!issecure(SECURE_NO_SETUID_FIXUP))
-		cap_set_effective(old_cap);
-
+	revert_creds(old_cred);
+	put_cred(override_cred);
 	return res;
 }
 
diff --git a/include/linux/capability.h b/include/linux/capability.h
index 9d1fe30..a7fe01c 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -501,8 +501,6 @@ extern const kernel_cap_t __cap_empty_set;
 extern const kernel_cap_t __cap_full_set;
 extern const kernel_cap_t __cap_init_eff_set;
 
-kernel_cap_t cap_set_effective(const kernel_cap_t pE_new);
-
 /**
  * has_capability - Determine if a task has a superior capability available
  * @t: The task in question
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 28e1d0e..202a82c 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -84,6 +84,8 @@ struct thread_group_cred {
 	struct key	*process_keyring;	/* keyring private to this process */
 	struct rcu_head	rcu;			/* RCU deletion hook */
 };
+
+extern void put_tgcred(struct thread_group_cred *tgcred);
 #endif
 
 /*
@@ -137,11 +139,30 @@ struct cred {
 	struct user_struct *user;	/* real user ID subscription */
 	struct group_info *group_info;	/* supplementary groups for euid/fsgid */
 	struct rcu_head	rcu;		/* RCU deletion hook */
-	spinlock_t	lock;		/* lock for pointer changes */
 };
 
 extern void __put_cred(struct cred *);
 extern int copy_creds(struct task_struct *, unsigned long);
+extern struct cred *prepare_creds(void);
+extern struct cred *prepare_usermodehelper_creds(void);
+extern int commit_creds(struct cred *);
+extern void abort_creds(struct cred *);
+extern const struct cred *override_creds(const struct cred *) __deprecated;
+extern void revert_creds(const struct cred *) __deprecated;
+extern void __init cred_init(void);
+
+/**
+ * get_new_cred - Get a reference on a new set of credentials
+ * @cred: The new credentials to reference
+ *
+ * Get a reference on the specified set of new credentials.  The caller must
+ * release the reference.
+ */
+static inline struct cred *get_new_cred(struct cred *cred)
+{
+	atomic_inc(&cred->usage);
+	return cred;
+}
 
 /**
  * get_cred - Get a reference on a set of credentials
@@ -150,10 +171,9 @@ extern int copy_creds(struct task_struct *, unsigned long);
  * Get a reference on the specified set of credentials.  The caller must
  * release the reference.
  */
-static inline struct cred *get_cred(struct cred *cred)
+static inline const struct cred *get_cred(const struct cred *cred)
 {
-	atomic_inc(&cred->usage);
-	return cred;
+	return get_new_cred((struct cred *) cred);
 }
 
 /**
@@ -166,6 +186,8 @@ static inline struct cred *get_cred(struct cred *cred)
 static inline void put_cred(const struct cred *_cred)
 {
 	struct cred *cred = (struct cred *) _cred;
+
+	BUG_ON(atomic_read(&(cred)->usage) <= 0);
 	if (atomic_dec_and_test(&(cred)->usage))
 		__put_cred(cred);
 }
@@ -250,13 +272,13 @@ static inline void put_cred(const struct cred *_cred)
 	__groups;					\
 })
 
-#define task_cred_xxx(task, xxx)		\
-({						\
-	__typeof__(task->cred->xxx) ___val;	\
-	rcu_read_lock();			\
-	___val = __task_cred((task))->xxx;	\
-	rcu_read_unlock();			\
-	___val;					\
+#define task_cred_xxx(task, xxx)			\
+({							\
+	__typeof__(((struct cred *)NULL)->xxx) ___val;	\
+	rcu_read_lock();				\
+	___val = __task_cred((task))->xxx;		\
+	rcu_read_unlock();				\
+	___val;						\
 })
 
 #define task_uid(task)		(task_cred_xxx((task), uid))
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 234c24a..e0cc816 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -150,6 +150,8 @@ extern struct cred init_cred;
 	.sibling	= LIST_HEAD_INIT(tsk.sibling),			\
 	.group_leader	= &tsk,						\
 	.cred		= &init_cred,					\
+	.cred_exec_mutex =						\
+		 __MUTEX_INITIALIZER(tsk.cred_exec_mutex),		\
 	.comm		= "swapper",					\
 	.thread		= INIT_THREAD,					\
 	.fs		= &init_fs,					\
diff --git a/include/linux/key.h b/include/linux/key.h
index 1a18ae9..acd4b13 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -73,6 +73,7 @@ struct key;
 struct seq_file;
 struct user_struct;
 struct signal_struct;
+struct cred;
 
 struct key_type;
 struct key_owner;
@@ -181,7 +182,7 @@ struct key {
 extern struct key *key_alloc(struct key_type *type,
 			     const char *desc,
 			     uid_t uid, gid_t gid,
-			     struct task_struct *ctx,
+			     const struct cred *cred,
 			     key_perm_t perm,
 			     unsigned long flags);
 
@@ -249,7 +250,7 @@ extern int key_unlink(struct key *keyring,
 		      struct key *key);
 
 extern struct key *keyring_alloc(const char *description, uid_t uid, gid_t gid,
-				 struct task_struct *ctx,
+				 const struct cred *cred,
 				 unsigned long flags,
 				 struct key *dest);
 
@@ -276,22 +277,12 @@ extern ctl_table key_sysctls[];
 /*
  * the userspace interface
  */
-extern void switch_uid_keyring(struct user_struct *new_user);
-extern int copy_keys(unsigned long clone_flags, struct task_struct *tsk);
-extern void exit_keys(struct task_struct *tsk);
-extern int suid_keys(struct task_struct *tsk);
+extern int install_thread_keyring_to_cred(struct cred *cred);
 extern int exec_keys(struct task_struct *tsk);
 extern void key_fsuid_changed(struct task_struct *tsk);
 extern void key_fsgid_changed(struct task_struct *tsk);
 extern void key_init(void);
 
-#define __install_session_keyring(keyring)				\
-({									\
-	struct key *old_session = current->cred->tgcred->session_keyring; \
-	current->cred->tgcred->session_keyring = keyring;		\
-	old_session;							\
-})
-
 #else /* CONFIG_KEYS */
 
 #define key_validate(k)			0
@@ -302,11 +293,8 @@ extern void key_init(void);
 #define make_key_ref(k, p)		NULL
 #define key_ref_to_ptr(k)		NULL
 #define is_key_possessed(k)		0
-#define switch_uid_keyring(u)		do { } while(0)
-#define __install_session_keyring(k)	NULL
-#define copy_keys(f,t)			0
-#define exit_keys(t)			do { } while(0)
-#define suid_keys(t)			do { } while(0)
+#define install_session_keyring(k)	NULL
+#define install_thread_keyring_to_cred(c) NULL
 #define exec_keys(t)			do { } while(0)
 #define key_fsuid_changed(t)		do { } while(0)
 #define key_fsgid_changed(t)		do { } while(0)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7916519..fd1126a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1103,7 +1103,8 @@ struct task_struct {
 	struct list_head cpu_timers[3];
 
 /* process credentials */
-	struct cred *cred;	/* actual/objective task credentials */
+	const struct cred *cred;	/* actual/objective task credentials (COW) */
+	struct mutex cred_exec_mutex;	/* execve vs ptrace cred calculation mutex */
 
 	char comm[TASK_COMM_LEN]; /* executable name excluding path
 				     - access with [gs]et_task_comm (which lock
@@ -1689,7 +1690,6 @@ static inline struct user_struct *get_uid(struct user_struct *u)
 	return u;
 }
 extern void free_uid(struct user_struct *);
-extern void switch_uid(struct user_struct *);
 extern void release_uids(struct user_namespace *ns);
 
 #include <asm/current.h>
@@ -1839,6 +1839,8 @@ static inline unsigned long wait_task_inactive(struct task_struct *p,
 #define for_each_process(p) \
 	for (p = &init_task ; (p = next_task(p)) != &init_task ; )
 
+extern bool is_single_threaded(struct task_struct *);
+
 /*
  * Careful: do_each_thread/while_each_thread is a double loop so
  *          'break' will not work as expected - use goto instead.
diff --git a/include/linux/security.h b/include/linux/security.h
index 27c0fbf..fd66260 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -49,24 +49,21 @@ extern int cap_settime(struct timespec *ts, struct timezone *tz);
 extern int cap_ptrace_may_access(struct task_struct *child, unsigned int mode);
 extern int cap_ptrace_traceme(struct task_struct *parent);
 extern int cap_capget(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
-extern int cap_capset_check(const kernel_cap_t *effective,
-			    const kernel_cap_t *inheritable,
-			    const kernel_cap_t *permitted);
-extern void cap_capset_set(const kernel_cap_t *effective,
-			   const kernel_cap_t *inheritable,
-			   const kernel_cap_t *permitted);
+extern int cap_capset(struct cred *new, const struct cred *old,
+		      const kernel_cap_t *effective,
+		      const kernel_cap_t *inheritable,
+		      const kernel_cap_t *permitted);
 extern int cap_bprm_set_security(struct linux_binprm *bprm);
-extern void cap_bprm_apply_creds(struct linux_binprm *bprm, int unsafe);
+extern int cap_bprm_apply_creds(struct linux_binprm *bprm, int unsafe);
 extern int cap_bprm_secureexec(struct linux_binprm *bprm);
 extern int cap_inode_setxattr(struct dentry *dentry, const char *name,
 			      const void *value, size_t size, int flags);
 extern int cap_inode_removexattr(struct dentry *dentry, const char *name);
 extern int cap_inode_need_killpriv(struct dentry *dentry);
 extern int cap_inode_killpriv(struct dentry *dentry);
-extern int cap_task_post_setuid(uid_t old_ruid, uid_t old_euid, uid_t old_suid, int flags);
-extern void cap_task_reparent_to_init(struct task_struct *p);
+extern int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags);
 extern int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
-			  unsigned long arg4, unsigned long arg5, long *rc_p);
+			  unsigned long arg4, unsigned long arg5);
 extern int cap_task_setscheduler(struct task_struct *p, int policy, struct sched_param *lp);
 extern int cap_task_setioprio(struct task_struct *p, int ioprio);
 extern int cap_task_setnice(struct task_struct *p, int nice);
@@ -166,8 +163,8 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	Compute and set the security attributes of a process being transformed
  *	by an execve operation based on the old attributes (current->security)
  *	and the information saved in @bprm->security by the set_security hook.
- *	Since this hook function (and its caller) are void, this hook can not
- *	return an error.  However, it can leave the security attributes of the
+ *	Since this function may return an error, in which case the process will
+ *      be killed.  However, it can leave the security attributes of the
  *	process unchanged if an access failure occurs at this point.
  *	bprm_apply_creds is called under task_lock.  @unsafe indicates various
  *	reasons why it may be unsafe to change security state.
@@ -589,15 +586,18 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	manual page for definitions of the @clone_flags.
  *	@clone_flags contains the flags indicating what should be shared.
  *	Return 0 if permission is granted.
- * @cred_alloc_security:
- *	@cred contains the cred struct for child process.
- *	Allocate and attach a security structure to the cred->security field.
- *	The security field is initialized to NULL when the task structure is
- *	allocated.
- *	Return 0 if operation was successful.
  * @cred_free:
  *	@cred points to the credentials.
  *	Deallocate and clear the cred->security field in a set of credentials.
+ * @cred_prepare:
+ *	@new points to the new credentials.
+ *	@old points to the original credentials.
+ *	@gfp indicates the atomicity of any memory allocations.
+ *	Prepare a new set of credentials by copying the data from the old set.
+ * @cred_commit:
+ *	@new points to the new credentials.
+ *	@old points to the original credentials.
+ *	Install a new set of credentials.
  * @task_setuid:
  *	Check permission before setting one or more of the user identity
  *	attributes of the current process.  The @flags parameter indicates
@@ -610,15 +610,13 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@id2 contains a uid.
  *	@flags contains one of the LSM_SETID_* values.
  *	Return 0 if permission is granted.
- * @task_post_setuid:
+ * @task_fix_setuid:
  *	Update the module's state after setting one or more of the user
  *	identity attributes of the current process.  The @flags parameter
  *	indicates which of the set*uid system calls invoked this hook.  If
- *	@flags is LSM_SETID_FS, then @old_ruid is the old fs uid and the other
- *	parameters are not used.
- *	@old_ruid contains the old real uid (or fs uid if LSM_SETID_FS).
- *	@old_euid contains the old effective uid (or -1 if LSM_SETID_FS).
- *	@old_suid contains the old saved uid (or -1 if LSM_SETID_FS).
+ *	@new is the set of credentials that will be installed.  Modifications
+ *	should be made to this rather than to @current->cred.
+ *	@old is the set of credentials that are being replaces
  *	@flags contains one of the LSM_SETID_* values.
  *	Return 0 on success.
  * @task_setgid:
@@ -721,13 +719,8 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@arg3 contains a argument.
  *	@arg4 contains a argument.
  *	@arg5 contains a argument.
- *      @rc_p contains a pointer to communicate back the forced return code
- *	Return 0 if permission is granted, and non-zero if the security module
- *      has taken responsibility (setting *rc_p) for the prctl call.
- * @task_reparent_to_init:
- *	Set the security attributes in @p->security for a kernel thread that
- *	is being reparented to the init task.
- *	@p contains the task_struct for the kernel thread.
+ *	Return -ENOSYS if no-one wanted to handle this op, any other value to
+ *	cause prctl() to return immediately with that value.
  * @task_to_inode:
  *	Set the security attributes for an inode based on an associated task's
  *	security attributes, e.g. for /proc/pid inodes.
@@ -1004,7 +997,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	See whether a specific operational right is granted to a process on a
  *	key.
  *	@key_ref refers to the key (key pointer + possession attribute bit).
- *	@context points to the process to provide the context against which to
+ *	@cred points to the credentials to provide the context against which to
  *	evaluate the security data on the key.
  *	@perm describes the combination of permissions required of this key.
  *	Return 1 if permission granted, 0 if permission denied and -ve it the
@@ -1166,6 +1159,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@child process.
  *	Security modules may also want to perform a process tracing check
  *	during an execve in the set_security or apply_creds hooks of
+ *	tracing check during an execve in the bprm_set_creds hook of
  *	binprm_security_ops if the process is being traced and its security
  *	attributes would be changed by the execve.
  *	@child contains the task_struct structure for the target process.
@@ -1189,19 +1183,15 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@inheritable contains the inheritable capability set.
  *	@permitted contains the permitted capability set.
  *	Return 0 if the capability sets were successfully obtained.
- * @capset_check:
- *	Check permission before setting the @effective, @inheritable, and
- *	@permitted capability sets for the current process.
- *	@effective contains the effective capability set.
- *	@inheritable contains the inheritable capability set.
- *	@permitted contains the permitted capability set.
- *	Return 0 if permission is granted.
- * @capset_set:
+ * @capset:
  *	Set the @effective, @inheritable, and @permitted capability sets for
  *	the current process.
+ *	@new contains the new credentials structure for target process.
+ *	@old contains the current credentials structure for target process.
  *	@effective contains the effective capability set.
  *	@inheritable contains the inheritable capability set.
  *	@permitted contains the permitted capability set.
+ *	Return 0 and update @new if permission is granted.
  * @capable:
  *	Check whether the @tsk process has the @cap capability.
  *	@tsk contains the task_struct for the process.
@@ -1293,12 +1283,11 @@ struct security_operations {
 	int (*capget) (struct task_struct *target,
 		       kernel_cap_t *effective,
 		       kernel_cap_t *inheritable, kernel_cap_t *permitted);
-	int (*capset_check) (const kernel_cap_t *effective,
-			     const kernel_cap_t *inheritable,
-			     const kernel_cap_t *permitted);
-	void (*capset_set) (const kernel_cap_t *effective,
-			    const kernel_cap_t *inheritable,
-			    const kernel_cap_t *permitted);
+	int (*capset) (struct cred *new,
+		       const struct cred *old,
+		       const kernel_cap_t *effective,
+		       const kernel_cap_t *inheritable,
+		       const kernel_cap_t *permitted);
 	int (*capable) (struct task_struct *tsk, int cap);
 	int (*acct) (struct file *file);
 	int (*sysctl) (struct ctl_table *table, int op);
@@ -1310,7 +1299,7 @@ struct security_operations {
 
 	int (*bprm_alloc_security) (struct linux_binprm *bprm);
 	void (*bprm_free_security) (struct linux_binprm *bprm);
-	void (*bprm_apply_creds) (struct linux_binprm *bprm, int unsafe);
+	int (*bprm_apply_creds) (struct linux_binprm *bprm, int unsafe);
 	void (*bprm_post_apply_creds) (struct linux_binprm *bprm);
 	int (*bprm_set_security) (struct linux_binprm *bprm);
 	int (*bprm_check_security) (struct linux_binprm *bprm);
@@ -1401,11 +1390,13 @@ struct security_operations {
 	int (*dentry_open) (struct file *file, const struct cred *cred);
 
 	int (*task_create) (unsigned long clone_flags);
-	int (*cred_alloc_security) (struct cred *cred);
 	void (*cred_free) (struct cred *cred);
+	int (*cred_prepare)(struct cred *new, const struct cred *old,
+			    gfp_t gfp);
+	void (*cred_commit)(struct cred *new, const struct cred *old);
 	int (*task_setuid) (uid_t id0, uid_t id1, uid_t id2, int flags);
-	int (*task_post_setuid) (uid_t old_ruid /* or fsuid */ ,
-				 uid_t old_euid, uid_t old_suid, int flags);
+	int (*task_fix_setuid) (struct cred *new, const struct cred *old,
+				int flags);
 	int (*task_setgid) (gid_t id0, gid_t id1, gid_t id2, int flags);
 	int (*task_setpgid) (struct task_struct *p, pid_t pgid);
 	int (*task_getpgid) (struct task_struct *p);
@@ -1425,8 +1416,7 @@ struct security_operations {
 	int (*task_wait) (struct task_struct *p);
 	int (*task_prctl) (int option, unsigned long arg2,
 			   unsigned long arg3, unsigned long arg4,
-			   unsigned long arg5, long *rc_p);
-	void (*task_reparent_to_init) (struct task_struct *p);
+			   unsigned long arg5);
 	void (*task_to_inode) (struct task_struct *p, struct inode *inode);
 
 	int (*ipc_permission) (struct kern_ipc_perm *ipcp, short flag);
@@ -1531,10 +1521,10 @@ struct security_operations {
 
 	/* key management security hooks */
 #ifdef CONFIG_KEYS
-	int (*key_alloc) (struct key *key, struct task_struct *tsk, unsigned long flags);
+	int (*key_alloc) (struct key *key, const struct cred *cred, unsigned long flags);
 	void (*key_free) (struct key *key);
 	int (*key_permission) (key_ref_t key_ref,
-			       struct task_struct *context,
+			       const struct cred *cred,
 			       key_perm_t perm);
 	int (*key_getsecurity)(struct key *key, char **_buffer);
 #endif	/* CONFIG_KEYS */
@@ -1565,12 +1555,10 @@ int security_capget(struct task_struct *target,
 		    kernel_cap_t *effective,
 		    kernel_cap_t *inheritable,
 		    kernel_cap_t *permitted);
-int security_capset_check(const kernel_cap_t *effective,
-			  const kernel_cap_t *inheritable,
-			  const kernel_cap_t *permitted);
-void security_capset_set(const kernel_cap_t *effective,
-			 const kernel_cap_t *inheritable,
-			 const kernel_cap_t *permitted);
+int security_capset(struct cred *new, const struct cred *old,
+		    const kernel_cap_t *effective,
+		    const kernel_cap_t *inheritable,
+		    const kernel_cap_t *permitted);
 int security_capable(struct task_struct *tsk, int cap);
 int security_acct(struct file *file);
 int security_sysctl(struct ctl_table *table, int op);
@@ -1582,7 +1570,7 @@ int security_vm_enough_memory(long pages);
 int security_vm_enough_memory_mm(struct mm_struct *mm, long pages);
 int security_bprm_alloc(struct linux_binprm *bprm);
 void security_bprm_free(struct linux_binprm *bprm);
-void security_bprm_apply_creds(struct linux_binprm *bprm, int unsafe);
+int security_bprm_apply_creds(struct linux_binprm *bprm, int unsafe);
 void security_bprm_post_apply_creds(struct linux_binprm *bprm);
 int security_bprm_set(struct linux_binprm *bprm);
 int security_bprm_check(struct linux_binprm *bprm);
@@ -1659,11 +1647,12 @@ int security_file_send_sigiotask(struct task_struct *tsk,
 int security_file_receive(struct file *file);
 int security_dentry_open(struct file *file, const struct cred *cred);
 int security_task_create(unsigned long clone_flags);
-int security_cred_alloc(struct cred *cred);
 void security_cred_free(struct cred *cred);
+int security_prepare_creds(struct cred *new, const struct cred *old, gfp_t gfp);
+void security_commit_creds(struct cred *new, const struct cred *old);
 int security_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags);
-int security_task_post_setuid(uid_t old_ruid, uid_t old_euid,
-			      uid_t old_suid, int flags);
+int security_task_fix_setuid(struct cred *new, const struct cred *old,
+			     int flags);
 int security_task_setgid(gid_t id0, gid_t id1, gid_t id2, int flags);
 int security_task_setpgid(struct task_struct *p, pid_t pgid);
 int security_task_getpgid(struct task_struct *p);
@@ -1682,8 +1671,7 @@ int security_task_kill(struct task_struct *p, struct siginfo *info,
 			int sig, u32 secid);
 int security_task_wait(struct task_struct *p);
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
-			 unsigned long arg4, unsigned long arg5, long *rc_p);
-void security_task_reparent_to_init(struct task_struct *p);
+			unsigned long arg4, unsigned long arg5);
 void security_task_to_inode(struct task_struct *p, struct inode *inode);
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag);
 void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid);
@@ -1758,18 +1746,13 @@ static inline int security_capget(struct task_struct *target,
 	return cap_capget(target, effective, inheritable, permitted);
 }
 
-static inline int security_capset_check(const kernel_cap_t *effective,
-					const kernel_cap_t *inheritable,
-					const kernel_cap_t *permitted)
+static inline int security_capset(struct cred *new,
+				   const struct cred *old,
+				   const kernel_cap_t *effective,
+				   const kernel_cap_t *inheritable,
+				   const kernel_cap_t *permitted)
 {
-	return cap_capset_check(effective, inheritable, permitted);
-}
-
-static inline void security_capset_set(const kernel_cap_t *effective,
-				       const kernel_cap_t *inheritable,
-				       const kernel_cap_t *permitted)
-{
-	cap_capset_set(effective, inheritable, permitted);
+	return cap_capset(new, old, effective, inheritable, permitted);
 }
 
 static inline int security_capable(struct task_struct *tsk, int cap)
@@ -1826,9 +1809,9 @@ static inline int security_bprm_alloc(struct linux_binprm *bprm)
 static inline void security_bprm_free(struct linux_binprm *bprm)
 { }
 
-static inline void security_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
+static inline int security_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
 {
-	cap_bprm_apply_creds(bprm, unsafe);
+	return cap_bprm_apply_creds(bprm, unsafe);
 }
 
 static inline void security_bprm_post_apply_creds(struct linux_binprm *bprm)
@@ -2171,13 +2154,20 @@ static inline int security_task_create(unsigned long clone_flags)
 	return 0;
 }
 
-static inline int security_cred_alloc(struct cred *cred)
+static inline void security_cred_free(struct cred *cred)
+{ }
+
+static inline int security_prepare_creds(struct cred *new,
+					 const struct cred *old,
+					 gfp_t gfp)
 {
 	return 0;
 }
 
-static inline void security_cred_free(struct cred *cred)
-{ }
+static inline void security_commit_creds(struct cred *new,
+					 const struct cred *old)
+{
+}
 
 static inline int security_task_setuid(uid_t id0, uid_t id1, uid_t id2,
 				       int flags)
@@ -2185,10 +2175,11 @@ static inline int security_task_setuid(uid_t id0, uid_t id1, uid_t id2,
 	return 0;
 }
 
-static inline int security_task_post_setuid(uid_t old_ruid, uid_t old_euid,
-					    uid_t old_suid, int flags)
+static inline int security_task_fix_setuid(struct cred *new,
+					   const struct cred *old,
+					   int flags)
 {
-	return cap_task_post_setuid(old_ruid, old_euid, old_suid, flags);
+	return cap_task_fix_setuid(new, old, flags);
 }
 
 static inline int security_task_setgid(gid_t id0, gid_t id1, gid_t id2,
@@ -2275,14 +2266,9 @@ static inline int security_task_wait(struct task_struct *p)
 static inline int security_task_prctl(int option, unsigned long arg2,
 				      unsigned long arg3,
 				      unsigned long arg4,
-				      unsigned long arg5, long *rc_p)
-{
-	return cap_task_prctl(option, arg2, arg3, arg3, arg5, rc_p);
-}
-
-static inline void security_task_reparent_to_init(struct task_struct *p)
+				      unsigned long arg5)
 {
-	cap_task_reparent_to_init(p);
+	return cap_task_prctl(option, arg2, arg3, arg3, arg5);
 }
 
 static inline void security_task_to_inode(struct task_struct *p, struct inode *inode)
@@ -2727,16 +2713,16 @@ static inline void security_skb_classify_flow(struct sk_buff *skb, struct flowi
 #ifdef CONFIG_KEYS
 #ifdef CONFIG_SECURITY
 
-int security_key_alloc(struct key *key, struct task_struct *tsk, unsigned long flags);
+int security_key_alloc(struct key *key, const struct cred *cred, unsigned long flags);
 void security_key_free(struct key *key);
 int security_key_permission(key_ref_t key_ref,
-			    struct task_struct *context, key_perm_t perm);
+			    const struct cred *cred, key_perm_t perm);
 int security_key_getsecurity(struct key *key, char **_buffer);
 
 #else
 
 static inline int security_key_alloc(struct key *key,
-				     struct task_struct *tsk,
+				     const struct cred *cred,
 				     unsigned long flags)
 {
 	return 0;
@@ -2747,7 +2733,7 @@ static inline void security_key_free(struct key *key)
 }
 
 static inline int security_key_permission(key_ref_t key_ref,
-					  struct task_struct *context,
+					  const struct cred *cred,
 					  key_perm_t perm)
 {
 	return 0;
diff --git a/init/main.c b/init/main.c
index 9c3b68b..3f1eca7 100644
--- a/init/main.c
+++ b/init/main.c
@@ -665,6 +665,7 @@ asmlinkage void __init start_kernel(void)
 		efi_enter_virtual_mode();
 #endif
 	thread_info_cache_init();
+	cred_init();
 	fork_init(num_physpages);
 	proc_caches_init();
 	buffer_init();
diff --git a/kernel/capability.c b/kernel/capability.c
index 758bfe1..6465ab7 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -14,12 +14,7 @@
 #include <linux/syscalls.h>
 #include <linux/pid_namespace.h>
 #include <asm/uaccess.h>
-
-/*
- * This lock protects task->cap_* for all tasks including current.
- * Locking rule: acquire this prior to tasklist_lock.
- */
-static DEFINE_SPINLOCK(task_capability_lock);
+#include "cred-internals.h"
 
 /*
  * Leveraged for setting/resetting capabilities
@@ -116,12 +111,11 @@ static int cap_validate_magic(cap_user_header_t header, unsigned *tocopy)
 }
 
 /*
- * If we have configured with filesystem capability support, then the
- * only thing that can change the capabilities of the current process
- * is the current process. As such, we can't be in this code at the
- * same time as we are in the process of setting capabilities in this
- * process. The net result is that we can limit our use of locks to
- * when we are reading the caps of another process.
+ * The only thing that can change the capabilities of the current
+ * process is the current process. As such, we can't be in this code
+ * at the same time as we are in the process of setting capabilities
+ * in this process. The net result is that we can limit our use of
+ * locks to when we are reading the caps of another process.
  */
 static inline int cap_get_target_pid(pid_t pid, kernel_cap_t *pEp,
 				     kernel_cap_t *pIp, kernel_cap_t *pPp)
@@ -131,7 +125,6 @@ static inline int cap_get_target_pid(pid_t pid, kernel_cap_t *pEp,
 	if (pid && (pid != task_pid_vnr(current))) {
 		struct task_struct *target;
 
-		spin_lock(&task_capability_lock);
 		read_lock(&tasklist_lock);
 
 		target = find_task_by_vpid(pid);
@@ -141,34 +134,12 @@ static inline int cap_get_target_pid(pid_t pid, kernel_cap_t *pEp,
 			ret = security_capget(target, pEp, pIp, pPp);
 
 		read_unlock(&tasklist_lock);
-		spin_unlock(&task_capability_lock);
 	} else
 		ret = security_capget(current, pEp, pIp, pPp);
 
 	return ret;
 }
 
-/*
- * Atomically modify the effective capabilities returning the original
- * value. No permission check is performed here - it is assumed that the
- * caller is permitted to set the desired effective capabilities.
- */
-kernel_cap_t cap_set_effective(const kernel_cap_t pE_new)
-{
-	kernel_cap_t pE_old;
-
-	spin_lock(&task_capability_lock);
-
-	pE_old = current->cred->cap_effective;
-	current->cred->cap_effective = pE_new;
-
-	spin_unlock(&task_capability_lock);
-
-	return pE_old;
-}
-
-EXPORT_SYMBOL(cap_set_effective);
-
 /**
  * sys_capget - get the capabilities of a given process.
  * @header: pointer to struct that contains capability version and
@@ -196,7 +167,6 @@ asmlinkage long sys_capget(cap_user_header_t header, cap_user_data_t dataptr)
 		return -EINVAL;
 
 	ret = cap_get_target_pid(pid, &pE, &pI, &pP);
-
 	if (!ret) {
 		struct __user_cap_data_struct kdata[_KERNEL_CAPABILITY_U32S];
 		unsigned i;
@@ -258,6 +228,7 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
 	struct __user_cap_data_struct kdata[_KERNEL_CAPABILITY_U32S];
 	unsigned i, tocopy;
 	kernel_cap_t inheritable, permitted, effective;
+	struct cred *new;
 	int ret;
 	pid_t pid;
 
@@ -272,10 +243,9 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
 	if (pid != 0 && pid != task_pid_vnr(current))
 		return -EPERM;
 
-	if (copy_from_user(&kdata, data, tocopy
-			   * sizeof(struct __user_cap_data_struct))) {
+	if (copy_from_user(&kdata, data,
+			   tocopy * sizeof(struct __user_cap_data_struct)))
 		return -EFAULT;
-	}
 
 	for (i = 0; i < tocopy; i++) {
 		effective.cap[i] = kdata[i].effective;
@@ -289,13 +259,18 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
 		i++;
 	}
 
-	spin_lock(&task_capability_lock);
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
 
-	ret = security_capset_check(&effective, &inheritable, &permitted);
-	if (!ret)
-		security_capset_set(&effective, &inheritable, &permitted);
+	ret = security_capset(new, current_cred(),
+			      &effective, &inheritable, &permitted);
+	if (ret < 0)
+		goto error;
+	return commit_creds(new);
 
-	spin_unlock(&task_capability_lock);
+error:
+	abort_creds(new);
 	return ret;
 }
 
diff --git a/kernel/cred-internals.h b/kernel/cred-internals.h
new file mode 100644
index 0000000..f16312a
--- /dev/null
+++ b/kernel/cred-internals.h
@@ -0,0 +1,26 @@
+/* Internal credentials stuff
+ *
+ * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+/*
+ * cred.c
+ */
+extern struct cred *alloc_creds(const struct cred *, gfp_t);
+
+/*
+ * user.c
+ */
+static inline void sched_switch_user(struct task_struct *p)
+{
+#ifdef CONFIG_USER_SCHED
+	sched_move_task(p);
+#endif	/* CONFIG_USER_SCHED */
+}
+
diff --git a/kernel/cred.c b/kernel/cred.c
index 6090cb6..7a4d311 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -15,6 +15,10 @@
 #include <linux/keyctl.h>
 #include <linux/init_task.h>
 #include <linux/security.h>
+#include <linux/cn_proc.h>
+#include "cred-internals.h"
+
+static struct kmem_cache *cred_jar;
 
 /*
  * The common credentials for the initial task's thread group
@@ -64,7 +68,7 @@ static void put_tgcred_rcu(struct rcu_head *rcu)
 /*
  * Release a set of thread group credentials.
  */
-static void put_tgcred(struct thread_group_cred *tgcred)
+void put_tgcred(struct thread_group_cred *tgcred)
 {
 #ifdef CONFIG_KEYS
 	if (atomic_dec_and_test(&tgcred->usage))
@@ -79,77 +83,329 @@ static void put_cred_rcu(struct rcu_head *rcu)
 {
 	struct cred *cred = container_of(rcu, struct cred, rcu);
 
-	BUG_ON(atomic_read(&cred->usage) != 0);
+	if (atomic_read(&cred->usage) != 0)
+		panic("CRED: put_cred_rcu() sees %p with usage %d\n",
+		      cred, atomic_read(&cred->usage));
 
+	security_cred_free(cred);
 	key_put(cred->thread_keyring);
 	key_put(cred->request_key_auth);
 	put_tgcred(cred->tgcred);
 	put_group_info(cred->group_info);
 	free_uid(cred->user);
-	security_cred_free(cred);
-	kfree(cred);
+	kmem_cache_free(cred_jar, cred);
 }
 
 /**
  * __put_cred - Destroy a set of credentials
- * @sec: The record to release
+ * @cred: The record to release
  *
  * Destroy a set of credentials on which no references remain.
  */
 void __put_cred(struct cred *cred)
 {
+	BUG_ON(atomic_read(&cred->usage) != 0);
+
 	call_rcu(&cred->rcu, put_cred_rcu);
 }
 EXPORT_SYMBOL(__put_cred);
 
 /*
+ * Allocate new credentials
+ */
+struct cred *alloc_creds(const struct cred *old, gfp_t gfp)
+{
+	struct cred *new;
+
+	new = kmem_cache_alloc(cred_jar, GFP_KERNEL);
+	if (!new)
+		return NULL;
+	if (old)
+		memcpy(new, old, sizeof(struct cred));
+	return new;
+}
+
+/**
+ * prepare_creds - Prepare a new set of credentials for modification
+ *
+ * Prepare a new set of task credentials for modification.  A task's creds
+ * shouldn't generally be modified directly, therefore this function is used to
+ * prepare a new copy, which the caller then modifies and then commits by
+ * calling commit_creds().
+ *
+ * Returns a pointer to the new creds-to-be if successful, NULL otherwise.
+ *
+ * Call commit_creds() or abort_creds() to clean up.
+ */
+struct cred *prepare_creds(void)
+{
+	struct task_struct *task = current;
+	const struct cred *old;
+	struct cred *new;
+
+	BUG_ON(atomic_read(&task->cred->usage) < 1);
+
+	new = kmem_cache_alloc(cred_jar, GFP_KERNEL);
+	if (!new)
+		return NULL;
+
+	old = task->cred;
+	memcpy(new, old, sizeof(struct cred));
+
+	atomic_set(&new->usage, 1);
+	get_group_info(new->group_info);
+	get_uid(new->user);
+
+#ifdef CONFIG_KEYS
+	key_get(new->thread_keyring);
+	key_get(new->request_key_auth);
+	atomic_inc(&new->tgcred->usage);
+#endif
+
+#ifdef CONFIG_SECURITY
+	new->security = NULL;
+#endif
+
+	if (security_prepare_creds(new, old, GFP_KERNEL) < 0)
+		goto error;
+	return new;
+
+error:
+	abort_creds(new);
+	return NULL;
+}
+EXPORT_SYMBOL(prepare_creds);
+
+/*
+ * prepare new credentials for the usermode helper dispatcher
+ */
+struct cred *prepare_usermodehelper_creds(void)
+{
+#ifdef CONFIG_KEYS
+	struct thread_group_cred *tgcred = NULL;
+#endif
+	struct cred *new;
+
+#ifdef CONFIG_KEYS
+	tgcred = kzalloc(sizeof(*new->tgcred), GFP_ATOMIC);
+	if (!tgcred)
+		return NULL;
+#endif
+
+	new = kmem_cache_alloc(cred_jar, GFP_ATOMIC);
+	if (!new)
+		return NULL;
+
+	memcpy(new, &init_cred, sizeof(struct cred));
+
+	atomic_set(&new->usage, 1);
+	get_group_info(new->group_info);
+	get_uid(new->user);
+
+#ifdef CONFIG_KEYS
+	new->thread_keyring = NULL;
+	new->request_key_auth = NULL;
+	new->jit_keyring = KEY_REQKEY_DEFL_DEFAULT;
+
+	atomic_set(&tgcred->usage, 1);
+	spin_lock_init(&tgcred->lock);
+	new->tgcred = tgcred;
+#endif
+
+#ifdef CONFIG_SECURITY
+	new->security = NULL;
+#endif
+	if (security_prepare_creds(new, &init_cred, GFP_ATOMIC) < 0)
+		goto error;
+
+	BUG_ON(atomic_read(&new->usage) != 1);
+	return new;
+
+error:
+	put_cred(new);
+	return NULL;
+}
+
+/*
  * Copy credentials for the new process created by fork()
+ *
+ * We share if we can, but under some circumstances we have to generate a new
+ * set.
  */
 int copy_creds(struct task_struct *p, unsigned long clone_flags)
 {
-	struct cred *pcred;
-	int ret;
+	struct thread_group_cred *tgcred;
+	struct cred *new;
+
+	mutex_init(&p->cred_exec_mutex);
 
-	pcred = kmemdup(p->cred, sizeof(*p->cred), GFP_KERNEL);
-	if (!pcred)
+	if (!p->cred->thread_keyring && clone_flags & CLONE_THREAD) {
+		get_cred(p->cred);
+		return 0;
+	}
+
+	new = prepare_creds();
+	if (!new)
 		return -ENOMEM;
 
 #ifdef CONFIG_KEYS
-	if (clone_flags & CLONE_THREAD) {
-		atomic_inc(&pcred->tgcred->usage);
-	} else {
-		pcred->tgcred = kmalloc(sizeof(struct cred), GFP_KERNEL);
-		if (!pcred->tgcred) {
-			kfree(pcred);
+	/* new threads get their own thread keyrings if their parent already
+	 * had one */
+	if (new->thread_keyring) {
+		key_put(new->thread_keyring);
+		new->thread_keyring = NULL;
+		if (clone_flags & CLONE_THREAD)
+			install_thread_keyring_to_cred(new);
+	}
+
+	/* we share the process and session keyrings between all the threads in
+	 * a process - this is slightly icky as we violate COW credentials a
+	 * bit */
+	if (!(clone_flags & CLONE_THREAD)) {
+		tgcred = kmalloc(sizeof(*tgcred), GFP_KERNEL);
+		if (!tgcred) {
+			put_cred(new);
 			return -ENOMEM;
 		}
-		atomic_set(&pcred->tgcred->usage, 1);
-		spin_lock_init(&pcred->tgcred->lock);
-		pcred->tgcred->process_keyring = NULL;
-		pcred->tgcred->session_keyring =
-			key_get(p->cred->tgcred->session_keyring);
+		atomic_set(&tgcred->usage, 1);
+		spin_lock_init(&tgcred->lock);
+		tgcred->process_keyring = NULL;
+		tgcred->session_keyring = key_get(new->tgcred->session_keyring);
+
+		put_tgcred(new->tgcred);
+		new->tgcred = tgcred;
 	}
 #endif
 
-#ifdef CONFIG_SECURITY
-	pcred->security = NULL;
-#endif
+	atomic_inc(&new->user->processes);
+	p->cred = new;
+	return 0;
+}
 
-	ret = security_cred_alloc(pcred);
-	if (ret < 0) {
-		put_tgcred(pcred->tgcred);
-		kfree(pcred);
-		return ret;
+/**
+ * commit_creds - Install new credentials upon the current task
+ * @new: The credentials to be assigned
+ *
+ * Install a new set of credentials to the current task, using RCU to replace
+ * the old set.
+ *
+ * This function eats the caller's reference to the new credentials.
+ *
+ * Always returns 0 thus allowing this function to be tail-called at the end
+ * of, say, sys_setgid().
+ */
+int commit_creds(struct cred *new)
+{
+	struct task_struct *task = current;
+	const struct cred *old;
+
+	BUG_ON(atomic_read(&new->usage) < 1);
+	BUG_ON(atomic_read(&task->cred->usage) < 1);
+
+	old = task->cred;
+	security_commit_creds(new, old);
+
+	/* dumpability changes */
+	if (old->euid != new->euid ||
+	    old->egid != new->egid ||
+	    old->fsuid != new->fsuid ||
+	    old->fsgid != new->fsgid ||
+	    !cap_issubset(new->cap_permitted, old->cap_permitted)) {
+		set_dumpable(task->mm, suid_dumpable);
+		task->pdeath_signal = 0;
+		smp_wmb();
 	}
 
-	atomic_set(&pcred->usage, 1);
-	get_group_info(pcred->group_info);
-	get_uid(pcred->user);
-	key_get(pcred->thread_keyring);
-	key_get(pcred->request_key_auth);
+	/* alter the thread keyring */
+	if (new->fsuid != old->fsuid)
+		key_fsuid_changed(task);
+	if (new->fsgid != old->fsgid)
+		key_fsgid_changed(task);
+
+	/* do it
+	 * - What if a process setreuid()'s and this brings the
+	 *   new uid over his NPROC rlimit?  We can check this now
+	 *   cheaply with the new uid cache, so if it matters
+	 *   we should be checking for it.  -DaveM
+	 */
+	if (new->user != old->user)
+		atomic_inc(&new->user->processes);
+	rcu_assign_pointer(task->cred, new);
+	if (new->user != old->user)
+		atomic_dec(&old->user->processes);
+
+	sched_switch_user(task);
+
+	/* send notifications */
+	if (new->uid   != old->uid  ||
+	    new->euid  != old->euid ||
+	    new->suid  != old->suid ||
+	    new->fsuid != old->fsuid)
+		proc_id_connector(task, PROC_EVENT_UID);
+
+	if (new->gid   != old->gid  ||
+	    new->egid  != old->egid ||
+	    new->sgid  != old->sgid ||
+	    new->fsgid != old->fsgid)
+		proc_id_connector(task, PROC_EVENT_GID);
 
-	/* RCU assignment is unneeded here as no-one can have accessed this
-	 * pointer yet, barring us */
-	p->cred = pcred;
+	put_cred(old);
 	return 0;
 }
+EXPORT_SYMBOL(commit_creds);
+
+/**
+ * abort_creds - Discard a set of credentials and unlock the current task
+ * @new: The credentials that were going to be applied
+ *
+ * Discard a set of credentials that were under construction and unlock the
+ * current task.
+ */
+void abort_creds(struct cred *new)
+{
+	BUG_ON(atomic_read(&new->usage) < 1);
+	put_cred(new);
+}
+EXPORT_SYMBOL(abort_creds);
+
+/**
+ * override_creds - Temporarily override the current process's credentials
+ * @new: The credentials to be assigned
+ *
+ * Install a set of temporary override credentials on the current process,
+ * returning the old set for later reversion.
+ */
+const struct cred *override_creds(const struct cred *new)
+{
+	const struct cred *old = current->cred;
+
+	rcu_assign_pointer(current->cred, get_cred(new));
+	return old;
+}
+EXPORT_SYMBOL(override_creds);
+
+/**
+ * revert_creds - Revert a temporary credentials override
+ * @old: The credentials to be restored
+ *
+ * Revert a temporary set of override credentials to an old set, discarding the
+ * override set.
+ */
+extern void revert_creds(const struct cred *old)
+{
+	const struct cred *override = current->cred;
+
+	rcu_assign_pointer(current->cred, old);
+	put_cred(override);
+}
+EXPORT_SYMBOL(revert_creds);
+
+/*
+ * initialise the credentials stuff
+ */
+void __init cred_init(void)
+{
+	/* allocate a slab in which we can store credentials */
+	cred_jar = kmem_cache_create("cred_jar", sizeof(struct cred),
+				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+}
diff --git a/kernel/exit.c b/kernel/exit.c
index 9bce79b..62dc559 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -47,11 +47,13 @@
 #include <linux/blkdev.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/tracehook.h>
+#include <linux/init_task.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
+#include "cred-internals.h"
 
 static void exit_mm(struct task_struct * tsk);
 
@@ -337,12 +339,12 @@ static void reparent_to_kthreadd(void)
 	/* cpus_allowed? */
 	/* rt_priority? */
 	/* signals? */
-	security_task_reparent_to_init(current);
 	memcpy(current->signal->rlim, init_task.signal->rlim,
 	       sizeof(current->signal->rlim));
-	atomic_inc(&(INIT_USER->__count));
+
+	atomic_inc(&init_cred.usage);
+	commit_creds(&init_cred);
 	write_unlock_irq(&tasklist_lock);
-	switch_uid(INIT_USER);
 }
 
 void __set_special_pids(struct pid *pid)
@@ -1085,7 +1087,6 @@ NORET_TYPE void do_exit(long code)
 	check_stack_usage();
 	exit_thread();
 	cgroup_exit(tsk, 1);
-	exit_keys(tsk);
 
 	if (group_dead && tsk->signal->leader)
 		disassociate_ctty(1);
diff --git a/kernel/fork.c b/kernel/fork.c
index b3254d5..a7cf83a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1055,10 +1055,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto bad_fork_cleanup_sighand;
 	if ((retval = copy_mm(clone_flags, p)))
 		goto bad_fork_cleanup_signal;
-	if ((retval = copy_keys(clone_flags, p)))
-		goto bad_fork_cleanup_mm;
 	if ((retval = copy_namespaces(clone_flags, p)))
-		goto bad_fork_cleanup_keys;
+		goto bad_fork_cleanup_mm;
 	if ((retval = copy_io(clone_flags, p)))
 		goto bad_fork_cleanup_namespaces;
 	retval = copy_thread(0, clone_flags, stack_start, stack_size, p, regs);
@@ -1237,8 +1235,6 @@ bad_fork_cleanup_io:
 	put_io_context(p->io_context);
 bad_fork_cleanup_namespaces:
 	exit_task_namespaces(p);
-bad_fork_cleanup_keys:
-	exit_keys(p);
 bad_fork_cleanup_mm:
 	if (p->mm)
 		mmput(p->mm);
@@ -1266,6 +1262,7 @@ bad_fork_cleanup_cgroup:
 bad_fork_cleanup_put_domain:
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:
+	atomic_dec(&p->cred->user->processes);
 	put_cred(p->cred);
 bad_fork_free:
 	free_task(p);
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 27e02e6..873ba4e 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -118,10 +118,10 @@ EXPORT_SYMBOL(request_module);
 struct subprocess_info {
 	struct work_struct work;
 	struct completion *complete;
+	struct cred *cred;
 	char *path;
 	char **argv;
 	char **envp;
-	struct key *ring;
 	enum umh_wait wait;
 	int retval;
 	struct file *stdin;
@@ -134,19 +134,20 @@ struct subprocess_info {
 static int ____call_usermodehelper(void *data)
 {
 	struct subprocess_info *sub_info = data;
-	struct key *new_session, *old_session;
 	int retval;
 
-	/* Unblock all signals and set the session keyring. */
-	new_session = key_get(sub_info->ring);
+	BUG_ON(atomic_read(&sub_info->cred->usage) != 1);
+
+	/* Unblock all signals */
 	spin_lock_irq(&current->sighand->siglock);
-	old_session = __install_session_keyring(new_session);
 	flush_signal_handlers(current, 1);
 	sigemptyset(&current->blocked);
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
-	key_put(old_session);
+	/* Install the credentials */
+	commit_creds(sub_info->cred);
+	sub_info->cred = NULL;
 
 	/* Install input pipe when needed */
 	if (sub_info->stdin) {
@@ -185,6 +186,8 @@ void call_usermodehelper_freeinfo(struct subprocess_info *info)
 {
 	if (info->cleanup)
 		(*info->cleanup)(info->argv, info->envp);
+	if (info->cred)
+		put_cred(info->cred);
 	kfree(info);
 }
 EXPORT_SYMBOL(call_usermodehelper_freeinfo);
@@ -240,6 +243,8 @@ static void __call_usermodehelper(struct work_struct *work)
 	pid_t pid;
 	enum umh_wait wait = sub_info->wait;
 
+	BUG_ON(atomic_read(&sub_info->cred->usage) != 1);
+
 	/* CLONE_VFORK: wait until the usermode helper has execve'd
 	 * successfully We need the data structures to stay around
 	 * until that is done.  */
@@ -370,6 +375,9 @@ struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
 	sub_info->path = path;
 	sub_info->argv = argv;
 	sub_info->envp = envp;
+	sub_info->cred = prepare_usermodehelper_creds();
+	if (!sub_info->cred)
+		return NULL;
 
   out:
 	return sub_info;
@@ -384,7 +392,13 @@ EXPORT_SYMBOL(call_usermodehelper_setup);
 void call_usermodehelper_setkeys(struct subprocess_info *info,
 				 struct key *session_keyring)
 {
-	info->ring = session_keyring;
+#ifdef CONFIG_KEYS
+	struct thread_group_cred *tgcred = info->cred->tgcred;
+	key_put(tgcred->session_keyring);
+	tgcred->session_keyring = key_get(session_keyring);
+#else
+	BUG();
+#endif
 }
 EXPORT_SYMBOL(call_usermodehelper_setkeys);
 
@@ -452,6 +466,8 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info,
 	DECLARE_COMPLETION_ONSTACK(done);
 	int retval = 0;
 
+	BUG_ON(atomic_read(&sub_info->cred->usage) != 1);
+
 	helper_lock();
 	if (sub_info->path[0] == '\0')
 		goto out;
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index ed65d9f..893a099 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -171,6 +171,14 @@ int ptrace_attach(struct task_struct *task)
 	if (same_thread_group(task, current))
 		goto out;
 
+	/* Protect exec's credential calculations against our interference;
+	 * SUID, SGID and LSM creds get determined differently under ptrace.
+	 */
+	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
+	if (retval  < 0)
+		goto out;
+
+	retval = -EPERM;
 repeat:
 	/*
 	 * Nasty, nasty.
@@ -210,6 +218,7 @@ repeat:
 bad:
 	write_unlock_irqrestore(&tasklist_lock, flags);
 	task_unlock(task);
+	mutex_unlock(&current->cred_exec_mutex);
 out:
 	return retval;
 }
diff --git a/kernel/signal.c b/kernel/signal.c
index 2632d94..911dcd2 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -179,7 +179,7 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
 /*
  * allocate a new signal queue record
  * - this may be called without locks if and only if t == current, otherwise an
- *   appopriate lock must be held to protect t's user_struct
+ *   appopriate lock must be held to stop the target task from exiting
  */
 static struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
 					 int override_rlimit)
@@ -193,7 +193,7 @@ static struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
 	 * caller must be holding the RCU readlock (by way of a spinlock) and
 	 * we use RCU protection here
 	 */
-	user = __task_cred(t)->user;
+	user = get_uid(__task_cred(t)->user);
 	atomic_inc(&user->sigpending);
 	if (override_rlimit ||
 	    atomic_read(&user->sigpending) <=
@@ -201,12 +201,14 @@ static struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
 		q = kmem_cache_alloc(sigqueue_cachep, flags);
 	if (unlikely(q == NULL)) {
 		atomic_dec(&user->sigpending);
+		free_uid(user);
 	} else {
 		INIT_LIST_HEAD(&q->list);
 		q->flags = 0;
-		q->user = get_uid(user);
+		q->user = user;
 	}
-	return(q);
+
+	return q;
 }
 
 static void __sigqueue_free(struct sigqueue *q)
diff --git a/kernel/sys.c b/kernel/sys.c
index 4c4ac7a..becd67d 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -180,7 +180,7 @@ asmlinkage long sys_setpriority(int which, int who, int niceval)
 			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
-			user = cred->user;
+			user = (struct user_struct *) cred->user;
 			if (!who)
 				who = cred->uid;
 			else if ((who != cred->uid) &&
@@ -479,47 +479,48 @@ void ctrl_alt_del(void)
  */
 asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
 {
-	struct cred *cred = current->cred;
-	int old_rgid = cred->gid;
-	int old_egid = cred->egid;
-	int new_rgid = old_rgid;
-	int new_egid = old_egid;
+	const struct cred *old;
+	struct cred *new;
 	int retval;
 
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+	old = current_cred();
+
 	retval = security_task_setgid(rgid, egid, (gid_t)-1, LSM_SETID_RE);
 	if (retval)
-		return retval;
+		goto error;
 
+	retval = -EPERM;
 	if (rgid != (gid_t) -1) {
-		if ((old_rgid == rgid) ||
-		    (cred->egid == rgid) ||
+		if (old->gid == rgid ||
+		    old->egid == rgid ||
 		    capable(CAP_SETGID))
-			new_rgid = rgid;
+			new->gid = rgid;
 		else
-			return -EPERM;
+			goto error;
 	}
 	if (egid != (gid_t) -1) {
-		if ((old_rgid == egid) ||
-		    (cred->egid == egid) ||
-		    (cred->sgid == egid) ||
+		if (old->gid == egid ||
+		    old->egid == egid ||
+		    old->sgid == egid ||
 		    capable(CAP_SETGID))
-			new_egid = egid;
+			new->egid = egid;
 		else
-			return -EPERM;
-	}
-	if (new_egid != old_egid) {
-		set_dumpable(current->mm, suid_dumpable);
-		smp_wmb();
+			goto error;
 	}
+
 	if (rgid != (gid_t) -1 ||
-	    (egid != (gid_t) -1 && egid != old_rgid))
-		cred->sgid = new_egid;
-	cred->fsgid = new_egid;
-	cred->egid = new_egid;
-	cred->gid = new_rgid;
-	key_fsgid_changed(current);
-	proc_id_connector(current, PROC_EVENT_GID);
-	return 0;
+	    (egid != (gid_t) -1 && egid != old->gid))
+		new->sgid = new->egid;
+	new->fsgid = new->egid;
+
+	return commit_creds(new);
+
+error:
+	abort_creds(new);
+	return retval;
 }
 
 /*
@@ -529,40 +530,42 @@ asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
  */
 asmlinkage long sys_setgid(gid_t gid)
 {
-	struct cred *cred = current->cred;
-	int old_egid = cred->egid;
+	const struct cred *old;
+	struct cred *new;
 	int retval;
 
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+	old = current_cred();
+
 	retval = security_task_setgid(gid, (gid_t)-1, (gid_t)-1, LSM_SETID_ID);
 	if (retval)
-		return retval;
+		goto error;
 
-	if (capable(CAP_SETGID)) {
-		if (old_egid != gid) {
-			set_dumpable(current->mm, suid_dumpable);
-			smp_wmb();
-		}
-		cred->gid = cred->egid = cred->sgid = cred->fsgid = gid;
-	} else if ((gid == cred->gid) || (gid == cred->sgid)) {
-		if (old_egid != gid) {
-			set_dumpable(current->mm, suid_dumpable);
-			smp_wmb();
-		}
-		cred->egid = cred->fsgid = gid;
-	}
+	retval = -EPERM;
+	if (capable(CAP_SETGID))
+		new->gid = new->egid = new->sgid = new->fsgid = gid;
+	else if (gid == old->gid || gid == old->sgid)
+		new->egid = new->fsgid = gid;
 	else
-		return -EPERM;
+		goto error;
 
-	key_fsgid_changed(current);
-	proc_id_connector(current, PROC_EVENT_GID);
-	return 0;
+	return commit_creds(new);
+
+error:
+	abort_creds(new);
+	return retval;
 }
   
-static int set_user(uid_t new_ruid, int dumpclear)
+/*
+ * change the user struct in a credentials set to match the new UID
+ */
+static int set_user(struct cred *new)
 {
 	struct user_struct *new_user;
 
-	new_user = alloc_uid(current->nsproxy->user_ns, new_ruid);
+	new_user = alloc_uid(current->nsproxy->user_ns, new->uid);
 	if (!new_user)
 		return -EAGAIN;
 
@@ -573,13 +576,8 @@ static int set_user(uid_t new_ruid, int dumpclear)
 		return -EAGAIN;
 	}
 
-	switch_uid(new_user);
-
-	if (dumpclear) {
-		set_dumpable(current->mm, suid_dumpable);
-		smp_wmb();
-	}
-	current->cred->uid = new_ruid;
+	free_uid(new->user);
+	new->user = new_user;
 	return 0;
 }
 
@@ -600,55 +598,56 @@ static int set_user(uid_t new_ruid, int dumpclear)
  */
 asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
 {
-	struct cred *cred = current->cred;
-	int old_ruid, old_euid, old_suid, new_ruid, new_euid;
+	const struct cred *old;
+	struct cred *new;
 	int retval;
 
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+	old = current_cred();
+
 	retval = security_task_setuid(ruid, euid, (uid_t)-1, LSM_SETID_RE);
 	if (retval)
-		return retval;
-
-	new_ruid = old_ruid = cred->uid;
-	new_euid = old_euid = cred->euid;
-	old_suid = cred->suid;
+		goto error;
 
+	retval = -EPERM;
 	if (ruid != (uid_t) -1) {
-		new_ruid = ruid;
-		if ((old_ruid != ruid) &&
-		    (cred->euid != ruid) &&
+		new->uid = ruid;
+		if (old->uid != ruid &&
+		    old->euid != ruid &&
 		    !capable(CAP_SETUID))
-			return -EPERM;
+			goto error;
 	}
 
 	if (euid != (uid_t) -1) {
-		new_euid = euid;
-		if ((old_ruid != euid) &&
-		    (cred->euid != euid) &&
-		    (cred->suid != euid) &&
+		new->euid = euid;
+		if (old->uid != euid &&
+		    old->euid != euid &&
+		    old->suid != euid &&
 		    !capable(CAP_SETUID))
-			return -EPERM;
+			goto error;
 	}
 
-	if (new_ruid != old_ruid && set_user(new_ruid, new_euid != old_euid) < 0)
-		return -EAGAIN;
+	retval = -EAGAIN;
+	if (new->uid != old->uid && set_user(new) < 0)
+		goto error;
 
-	if (new_euid != old_euid) {
-		set_dumpable(current->mm, suid_dumpable);
-		smp_wmb();
-	}
-	cred->fsuid = cred->euid = new_euid;
 	if (ruid != (uid_t) -1 ||
-	    (euid != (uid_t) -1 && euid != old_ruid))
-		cred->suid = cred->euid;
-	cred->fsuid = cred->euid;
+	    (euid != (uid_t) -1 && euid != old->uid))
+		new->suid = new->euid;
+	new->fsuid = new->euid;
 
-	key_fsuid_changed(current);
-	proc_id_connector(current, PROC_EVENT_UID);
-
-	return security_task_post_setuid(old_ruid, old_euid, old_suid, LSM_SETID_RE);
-}
+	retval = security_task_fix_setuid(new, old, LSM_SETID_RE);
+	if (retval < 0)
+		goto error;
 
+	return commit_creds(new);
 
+error:
+	abort_creds(new);
+	return retval;
+}
 		
 /*
  * setuid() is implemented like SysV with SAVED_IDS 
@@ -663,37 +662,41 @@ asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
  */
 asmlinkage long sys_setuid(uid_t uid)
 {
-	struct cred *cred = current->cred;
-	int old_euid = cred->euid;
-	int old_ruid, old_suid, new_suid;
+	const struct cred *old;
+	struct cred *new;
 	int retval;
 
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+	old = current_cred();
+
 	retval = security_task_setuid(uid, (uid_t)-1, (uid_t)-1, LSM_SETID_ID);
 	if (retval)
-		return retval;
+		goto error;
 
-	old_ruid = cred->uid;
-	old_suid = cred->suid;
-	new_suid = old_suid;
-	
+	retval = -EPERM;
 	if (capable(CAP_SETUID)) {
-		if (uid != old_ruid && set_user(uid, old_euid != uid) < 0)
-			return -EAGAIN;
-		new_suid = uid;
-	} else if ((uid != cred->uid) && (uid != new_suid))
-		return -EPERM;
-
-	if (old_euid != uid) {
-		set_dumpable(current->mm, suid_dumpable);
-		smp_wmb();
+		new->suid = new->uid = uid;
+		if (uid != old->uid && set_user(new) < 0) {
+			retval = -EAGAIN;
+			goto error;
+		}
+	} else if (uid != old->uid && uid != new->suid) {
+		goto error;
 	}
-	cred->fsuid = cred->euid = uid;
-	cred->suid = new_suid;
 
-	key_fsuid_changed(current);
-	proc_id_connector(current, PROC_EVENT_UID);
+	new->fsuid = new->euid = uid;
+
+	retval = security_task_fix_setuid(new, old, LSM_SETID_ID);
+	if (retval < 0)
+		goto error;
 
-	return security_task_post_setuid(old_ruid, old_euid, old_suid, LSM_SETID_ID);
+	return commit_creds(new);
+
+error:
+	abort_creds(new);
+	return retval;
 }
 
 
@@ -703,47 +706,53 @@ asmlinkage long sys_setuid(uid_t uid)
  */
 asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 {
-	struct cred *cred = current->cred;
-	int old_ruid = cred->uid;
-	int old_euid = cred->euid;
-	int old_suid = cred->suid;
+	const struct cred *old;
+	struct cred *new;
 	int retval;
 
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
 	retval = security_task_setuid(ruid, euid, suid, LSM_SETID_RES);
 	if (retval)
-		return retval;
+		goto error;
+	old = current_cred();
 
+	retval = -EPERM;
 	if (!capable(CAP_SETUID)) {
-		if ((ruid != (uid_t) -1) && (ruid != cred->uid) &&
-		    (ruid != cred->euid) && (ruid != cred->suid))
-			return -EPERM;
-		if ((euid != (uid_t) -1) && (euid != cred->uid) &&
-		    (euid != cred->euid) && (euid != cred->suid))
-			return -EPERM;
-		if ((suid != (uid_t) -1) && (suid != cred->uid) &&
-		    (suid != cred->euid) && (suid != cred->suid))
-			return -EPERM;
+		if (ruid != (uid_t) -1 && ruid != old->uid &&
+		    ruid != old->euid  && ruid != old->suid)
+			goto error;
+		if (euid != (uid_t) -1 && euid != old->uid &&
+		    euid != old->euid  && euid != old->suid)
+			goto error;
+		if (suid != (uid_t) -1 && suid != old->uid &&
+		    suid != old->euid  && suid != old->suid)
+			goto error;
 	}
+
+	retval = -EAGAIN;
 	if (ruid != (uid_t) -1) {
-		if (ruid != cred->uid &&
-		    set_user(ruid, euid != cred->euid) < 0)
-			return -EAGAIN;
-	}
-	if (euid != (uid_t) -1) {
-		if (euid != cred->euid) {
-			set_dumpable(current->mm, suid_dumpable);
-			smp_wmb();
-		}
-		cred->euid = euid;
+		new->uid = ruid;
+		if (ruid != old->uid && set_user(new) < 0)
+			goto error;
 	}
-	cred->fsuid = cred->euid;
+	if (euid != (uid_t) -1)
+		new->euid = euid;
 	if (suid != (uid_t) -1)
-		cred->suid = suid;
+		new->suid = suid;
+	new->fsuid = new->euid;
+
+	retval = security_task_fix_setuid(new, old, LSM_SETID_RES);
+	if (retval < 0)
+		goto error;
 
-	key_fsuid_changed(current);
-	proc_id_connector(current, PROC_EVENT_UID);
+	return commit_creds(new);
 
-	return security_task_post_setuid(old_ruid, old_euid, old_suid, LSM_SETID_RES);
+error:
+	abort_creds(new);
+	return retval;
 }
 
 asmlinkage long sys_getresuid(uid_t __user *ruid, uid_t __user *euid, uid_t __user *suid)
@@ -763,40 +772,45 @@ asmlinkage long sys_getresuid(uid_t __user *ruid, uid_t __user *euid, uid_t __us
  */
 asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 {
-	struct cred *cred = current->cred;
+	const struct cred *old;
+	struct cred *new;
 	int retval;
 
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+	old = current_cred();
+
 	retval = security_task_setgid(rgid, egid, sgid, LSM_SETID_RES);
 	if (retval)
-		return retval;
+		goto error;
 
+	retval = -EPERM;
 	if (!capable(CAP_SETGID)) {
-		if ((rgid != (gid_t) -1) && (rgid != cred->gid) &&
-		    (rgid != cred->egid) && (rgid != cred->sgid))
-			return -EPERM;
-		if ((egid != (gid_t) -1) && (egid != cred->gid) &&
-		    (egid != cred->egid) && (egid != cred->sgid))
-			return -EPERM;
-		if ((sgid != (gid_t) -1) && (sgid != cred->gid) &&
-		    (sgid != cred->egid) && (sgid != cred->sgid))
-			return -EPERM;
-	}
-	if (egid != (gid_t) -1) {
-		if (egid != cred->egid) {
-			set_dumpable(current->mm, suid_dumpable);
-			smp_wmb();
-		}
-		cred->egid = egid;
+		if (rgid != (gid_t) -1 && rgid != old->gid &&
+		    rgid != old->egid  && rgid != old->sgid)
+			goto error;
+		if (egid != (gid_t) -1 && egid != old->gid &&
+		    egid != old->egid  && egid != old->sgid)
+			goto error;
+		if (sgid != (gid_t) -1 && sgid != old->gid &&
+		    sgid != old->egid  && sgid != old->sgid)
+			goto error;
 	}
-	cred->fsgid = cred->egid;
+
 	if (rgid != (gid_t) -1)
-		cred->gid = rgid;
+		new->gid = rgid;
+	if (egid != (gid_t) -1)
+		new->egid = egid;
 	if (sgid != (gid_t) -1)
-		cred->sgid = sgid;
+		new->sgid = sgid;
+	new->fsgid = new->egid;
 
-	key_fsgid_changed(current);
-	proc_id_connector(current, PROC_EVENT_GID);
-	return 0;
+	return commit_creds(new);
+
+error:
+	abort_creds(new);
+	return retval;
 }
 
 asmlinkage long sys_getresgid(gid_t __user *rgid, gid_t __user *egid, gid_t __user *sgid)
@@ -820,28 +834,35 @@ asmlinkage long sys_getresgid(gid_t __user *rgid, gid_t __user *egid, gid_t __us
  */
 asmlinkage long sys_setfsuid(uid_t uid)
 {
-	struct cred *cred = current->cred;
-	int old_fsuid;
+	const struct cred *old;
+	struct cred *new;
+	uid_t old_fsuid;
+
+	new = prepare_creds();
+	if (!new)
+		return current_fsuid();
+	old = current_cred();
+	old_fsuid = old->fsuid;
 
-	old_fsuid = cred->fsuid;
-	if (security_task_setuid(uid, (uid_t)-1, (uid_t)-1, LSM_SETID_FS))
-		return old_fsuid;
+	if (security_task_setuid(uid, (uid_t)-1, (uid_t)-1, LSM_SETID_FS) < 0)
+		goto error;
 
-	if (uid == cred->uid || uid == cred->euid ||
-	    uid == cred->suid || uid == cred->fsuid ||
+	if (uid == old->uid  || uid == old->euid  ||
+	    uid == old->suid || uid == old->fsuid ||
 	    capable(CAP_SETUID)) {
 		if (uid != old_fsuid) {
-			set_dumpable(current->mm, suid_dumpable);
-			smp_wmb();
+			new->fsuid = uid;
+			if (security_task_fix_setuid(new, old, LSM_SETID_FS) == 0)
+				goto change_okay;
 		}
-		cred->fsuid = uid;
 	}
 
-	key_fsuid_changed(current);
-	proc_id_connector(current, PROC_EVENT_UID);
-
-	security_task_post_setuid(old_fsuid, (uid_t)-1, (uid_t)-1, LSM_SETID_FS);
+error:
+	abort_creds(new);
+	return old_fsuid;
 
+change_okay:
+	commit_creds(new);
 	return old_fsuid;
 }
 
@@ -850,24 +871,34 @@ asmlinkage long sys_setfsuid(uid_t uid)
  */
 asmlinkage long sys_setfsgid(gid_t gid)
 {
-	struct cred *cred = current->cred;
-	int old_fsgid;
+	const struct cred *old;
+	struct cred *new;
+	gid_t old_fsgid;
+
+	new = prepare_creds();
+	if (!new)
+		return current_fsgid();
+	old = current_cred();
+	old_fsgid = old->fsgid;
 
-	old_fsgid = cred->fsgid;
 	if (security_task_setgid(gid, (gid_t)-1, (gid_t)-1, LSM_SETID_FS))
-		return old_fsgid;
+		goto error;
 
-	if (gid == cred->gid || gid == cred->egid ||
-	    gid == cred->sgid || gid == cred->fsgid ||
+	if (gid == old->gid  || gid == old->egid  ||
+	    gid == old->sgid || gid == old->fsgid ||
 	    capable(CAP_SETGID)) {
 		if (gid != old_fsgid) {
-			set_dumpable(current->mm, suid_dumpable);
-			smp_wmb();
+			new->fsgid = gid;
+			goto change_okay;
 		}
-		cred->fsgid = gid;
-		key_fsgid_changed(current);
-		proc_id_connector(current, PROC_EVENT_GID);
 	}
+
+error:
+	abort_creds(new);
+	return old_fsgid;
+
+change_okay:
+	commit_creds(new);
 	return old_fsgid;
 }
 
@@ -1148,7 +1179,7 @@ EXPORT_SYMBOL(groups_free);
 
 /* export the group_info to a user-space array */
 static int groups_to_user(gid_t __user *grouplist,
-    struct group_info *group_info)
+			  const struct group_info *group_info)
 {
 	int i;
 	unsigned int count = group_info->ngroups;
@@ -1239,31 +1270,25 @@ int groups_search(const struct group_info *group_info, gid_t grp)
 }
 
 /**
- * set_groups - Change a group subscription in a security record
- * @sec: The security record to alter
- * @group_info: The group list to impose
+ * set_groups - Change a group subscription in a set of credentials
+ * @new: The newly prepared set of credentials to alter
+ * @group_info: The group list to install
  *
- * Validate a group subscription and, if valid, impose it upon a task security
- * record.
+ * Validate a group subscription and, if valid, insert it into a set
+ * of credentials.
  */
-int set_groups(struct cred *cred, struct group_info *group_info)
+int set_groups(struct cred *new, struct group_info *group_info)
 {
 	int retval;
-	struct group_info *old_info;
 
 	retval = security_task_setgroups(group_info);
 	if (retval)
 		return retval;
 
+	put_group_info(new->group_info);
 	groups_sort(group_info);
 	get_group_info(group_info);
-
-	spin_lock(&cred->lock);
-	old_info = cred->group_info;
-	cred->group_info = group_info;
-	spin_unlock(&cred->lock);
-
-	put_group_info(old_info);
+	new->group_info = group_info;
 	return 0;
 }
 
@@ -1278,7 +1303,20 @@ EXPORT_SYMBOL(set_groups);
  */
 int set_current_groups(struct group_info *group_info)
 {
-	return set_groups(current->cred, group_info);
+	struct cred *new;
+	int ret;
+
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
+	ret = set_groups(new, group_info);
+	if (ret < 0) {
+		abort_creds(new);
+		return ret;
+	}
+
+	return commit_creds(new);
 }
 
 EXPORT_SYMBOL(set_current_groups);
@@ -1675,11 +1713,13 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 {
 	struct task_struct *me = current;
 	unsigned char comm[sizeof(me->comm)];
-	long uninitialized_var(error);
+	long error;
 
-	if (security_task_prctl(option, arg2, arg3, arg4, arg5, &error))
+	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
+	if (error != -ENOSYS)
 		return error;
 
+	error = 0;
 	switch (option) {
 		case PR_SET_PDEATHSIG:
 			if (!valid_signal(arg2)) {
diff --git a/kernel/user.c b/kernel/user.c
index 9c9e27b..ed4dc57 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -16,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/user_namespace.h>
+#include "cred-internals.h"
 
 struct user_namespace init_user_ns = {
 	.kref = {
@@ -104,16 +105,10 @@ static int sched_create_user(struct user_struct *up)
 	return rc;
 }
 
-static void sched_switch_user(struct task_struct *p)
-{
-	sched_move_task(p);
-}
-
 #else	/* CONFIG_USER_SCHED */
 
 static void sched_destroy_user(struct user_struct *up) { }
 static int sched_create_user(struct user_struct *up) { return 0; }
-static void sched_switch_user(struct task_struct *p) { }
 
 #endif	/* CONFIG_USER_SCHED */
 
@@ -448,36 +443,6 @@ out_unlock:
 	return NULL;
 }
 
-void switch_uid(struct user_struct *new_user)
-{
-	struct user_struct *old_user;
-
-	/* What if a process setreuid()'s and this brings the
-	 * new uid over his NPROC rlimit?  We can check this now
-	 * cheaply with the new uid cache, so if it matters
-	 * we should be checking for it.  -DaveM
-	 */
-	old_user = current->cred->user;
-	atomic_inc(&new_user->processes);
-	atomic_dec(&old_user->processes);
-	switch_uid_keyring(new_user);
-	current->cred->user = new_user;
-	sched_switch_user(current);
-
-	/*
-	 * We need to synchronize with __sigqueue_alloc()
-	 * doing a get_uid(p->user).. If that saw the old
-	 * user value, we need to wait until it has exited
-	 * its critical region before we can free the old
-	 * structure.
-	 */
-	smp_mb();
-	spin_unlock_wait(&current->sighand->siglock);
-
-	free_uid(old_user);
-	suid_keys(current);
-}
-
 #ifdef CONFIG_USER_NS
 void release_uids(struct user_namespace *ns)
 {
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index edbe9f1..6904f0b 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -20,6 +20,7 @@ static struct user_namespace *clone_user_ns(struct user_namespace *old_ns)
 {
 	struct user_namespace *ns;
 	struct user_struct *new_user;
+	struct cred *new;
 	int n;
 
 	ns = kmalloc(sizeof(struct user_namespace), GFP_KERNEL);
@@ -46,7 +47,16 @@ static struct user_namespace *clone_user_ns(struct user_namespace *old_ns)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	switch_uid(new_user);
+	/* Install the new user */
+	new = prepare_creds();
+	if (!new) {
+		free_uid(new_user);
+		free_uid(ns->root_user);
+		kfree(ns);
+	}
+	free_uid(new->user);
+	new->user = new_user;
+	commit_creds(new);
 	return ns;
 }
 
diff --git a/lib/Makefile b/lib/Makefile
index 3b1f94b..2cd51bc 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -11,7 +11,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
-	 proportions.o prio_heap.o ratelimit.o show_mem.o
+	 proportions.o prio_heap.o ratelimit.o show_mem.o is_single_threaded.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
diff --git a/lib/is_single_threaded.c b/lib/is_single_threaded.c
new file mode 100644
index 0000000..f1ed2fe
--- /dev/null
+++ b/lib/is_single_threaded.c
@@ -0,0 +1,45 @@
+/* Function to determine if a thread group is single threaded or not
+ *
+ * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ * - Derived from security/selinux/hooks.c
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/sched.h>
+
+/**
+ * is_single_threaded - Determine if a thread group is single-threaded or not
+ * @p: A task in the thread group in question
+ *
+ * This returns true if the thread group to which a task belongs is single
+ * threaded, false if it is not.
+ */
+bool is_single_threaded(struct task_struct *p)
+{
+	struct task_struct *g, *t;
+	struct mm_struct *mm = p->mm;
+
+	if (atomic_read(&p->signal->count) != 1)
+		goto no;
+
+	if (atomic_read(&p->mm->mm_users) != 1) {
+		read_lock(&tasklist_lock);
+		do_each_thread(g, t) {
+			if (t->mm == mm && t != p)
+				goto no_unlock;
+		} while_each_thread(g, t);
+		read_unlock(&tasklist_lock);
+	}
+
+	return true;
+
+no_unlock:
+	read_unlock(&tasklist_lock);
+no:
+	return false;
+}
diff --git a/net/rxrpc/ar-key.c b/net/rxrpc/ar-key.c
index 9a8ff68..ad8c7a7 100644
--- a/net/rxrpc/ar-key.c
+++ b/net/rxrpc/ar-key.c
@@ -287,6 +287,7 @@ int rxrpc_get_server_data_key(struct rxrpc_connection *conn,
 			      time_t expiry,
 			      u32 kvno)
 {
+	const struct cred *cred = current_cred();
 	struct key *key;
 	int ret;
 
@@ -297,7 +298,7 @@ int rxrpc_get_server_data_key(struct rxrpc_connection *conn,
 
 	_enter("");
 
-	key = key_alloc(&key_type_rxrpc, "x", 0, 0, current, 0,
+	key = key_alloc(&key_type_rxrpc, "x", 0, 0, cred, 0,
 			KEY_ALLOC_NOT_IN_QUOTA);
 	if (IS_ERR(key)) {
 		_leave(" = -ENOMEM [alloc %ld]", PTR_ERR(key));
@@ -340,10 +341,11 @@ EXPORT_SYMBOL(rxrpc_get_server_data_key);
  */
 struct key *rxrpc_get_null_key(const char *keyname)
 {
+	const struct cred *cred = current_cred();
 	struct key *key;
 	int ret;
 
-	key = key_alloc(&key_type_rxrpc, keyname, 0, 0, current,
+	key = key_alloc(&key_type_rxrpc, keyname, 0, 0, cred,
 			KEY_POS_SEARCH, KEY_ALLOC_NOT_IN_QUOTA);
 	if (IS_ERR(key))
 		return key;
diff --git a/security/capability.c b/security/capability.c
index fac2f61..efeb6d9 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -340,12 +340,16 @@ static int cap_task_create(unsigned long clone_flags)
 	return 0;
 }
 
-static int cap_cred_alloc_security(struct cred *cred)
+static void cap_cred_free(struct cred *cred)
+{
+}
+
+static int cap_cred_prepare(struct cred *new, const struct cred *old, gfp_t gfp)
 {
 	return 0;
 }
 
-static void cap_cred_free(struct cred *cred)
+static void cap_cred_commit(struct cred *new, const struct cred *old)
 {
 }
 
@@ -750,7 +754,7 @@ static void cap_release_secctx(char *secdata, u32 seclen)
 }
 
 #ifdef CONFIG_KEYS
-static int cap_key_alloc(struct key *key, struct task_struct *ctx,
+static int cap_key_alloc(struct key *key, const struct cred *cred,
 			 unsigned long flags)
 {
 	return 0;
@@ -760,7 +764,7 @@ static void cap_key_free(struct key *key)
 {
 }
 
-static int cap_key_permission(key_ref_t key_ref, struct task_struct *context,
+static int cap_key_permission(key_ref_t key_ref, const struct cred *cred,
 			      key_perm_t perm)
 {
 	return 0;
@@ -814,8 +818,7 @@ void security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, ptrace_may_access);
 	set_to_cap_if_null(ops, ptrace_traceme);
 	set_to_cap_if_null(ops, capget);
-	set_to_cap_if_null(ops, capset_check);
-	set_to_cap_if_null(ops, capset_set);
+	set_to_cap_if_null(ops, capset);
 	set_to_cap_if_null(ops, acct);
 	set_to_cap_if_null(ops, capable);
 	set_to_cap_if_null(ops, quotactl);
@@ -890,10 +893,11 @@ void security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, file_receive);
 	set_to_cap_if_null(ops, dentry_open);
 	set_to_cap_if_null(ops, task_create);
-	set_to_cap_if_null(ops, cred_alloc_security);
 	set_to_cap_if_null(ops, cred_free);
+	set_to_cap_if_null(ops, cred_prepare);
+	set_to_cap_if_null(ops, cred_commit);
 	set_to_cap_if_null(ops, task_setuid);
-	set_to_cap_if_null(ops, task_post_setuid);
+	set_to_cap_if_null(ops, task_fix_setuid);
 	set_to_cap_if_null(ops, task_setgid);
 	set_to_cap_if_null(ops, task_setpgid);
 	set_to_cap_if_null(ops, task_getpgid);
@@ -910,7 +914,6 @@ void security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, task_wait);
 	set_to_cap_if_null(ops, task_kill);
 	set_to_cap_if_null(ops, task_prctl);
-	set_to_cap_if_null(ops, task_reparent_to_init);
 	set_to_cap_if_null(ops, task_to_inode);
 	set_to_cap_if_null(ops, ipc_permission);
 	set_to_cap_if_null(ops, ipc_getsecid);
diff --git a/security/commoncap.c b/security/commoncap.c
index d6456b0..1ae99fa 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -71,8 +71,8 @@ int cap_ptrace_may_access(struct task_struct *child, unsigned int mode)
 	int ret = 0;
 
 	rcu_read_lock();
-	if (!cap_issubset(child->cred->cap_permitted,
-			  current->cred->cap_permitted) &&
+	if (!cap_issubset(__task_cred(child)->cap_permitted,
+			  current_cred()->cap_permitted) &&
 	    !capable(CAP_SYS_PTRACE))
 		ret = -EPERM;
 	rcu_read_unlock();
@@ -84,8 +84,8 @@ int cap_ptrace_traceme(struct task_struct *parent)
 	int ret = 0;
 
 	rcu_read_lock();
-	if (!cap_issubset(current->cred->cap_permitted,
-			 parent->cred->cap_permitted) &&
+	if (!cap_issubset(current_cred()->cap_permitted,
+			  __task_cred(parent)->cap_permitted) &&
 	    !has_capability(parent, CAP_SYS_PTRACE))
 		ret = -EPERM;
 	rcu_read_unlock();
@@ -116,7 +116,7 @@ static inline int cap_inh_is_capped(void)
 	 * to the old permitted set. That is, if the current task
 	 * does *not* possess the CAP_SETPCAP capability.
 	 */
-	return (cap_capable(current, CAP_SETPCAP) != 0);
+	return cap_capable(current, CAP_SETPCAP) != 0;
 }
 
 static inline int cap_limit_ptraced_target(void) { return 1; }
@@ -131,52 +131,39 @@ static inline int cap_limit_ptraced_target(void)
 
 #endif /* def CONFIG_SECURITY_FILE_CAPABILITIES */
 
-int cap_capset_check(const kernel_cap_t *effective,
-		     const kernel_cap_t *inheritable,
-		     const kernel_cap_t *permitted)
+int cap_capset(struct cred *new,
+	       const struct cred *old,
+	       const kernel_cap_t *effective,
+	       const kernel_cap_t *inheritable,
+	       const kernel_cap_t *permitted)
 {
-	const struct cred *cred = current->cred;
-
-	if (cap_inh_is_capped()
-	    && !cap_issubset(*inheritable,
-			     cap_combine(cred->cap_inheritable,
-					 cred->cap_permitted))) {
+	if (cap_inh_is_capped() &&
+	    !cap_issubset(*inheritable,
+			  cap_combine(old->cap_inheritable,
+				      old->cap_permitted)))
 		/* incapable of using this inheritable set */
 		return -EPERM;
-	}
+
 	if (!cap_issubset(*inheritable,
-			   cap_combine(cred->cap_inheritable,
-				       cred->cap_bset))) {
+			  cap_combine(old->cap_inheritable,
+				      old->cap_bset)))
 		/* no new pI capabilities outside bounding set */
 		return -EPERM;
-	}
 
 	/* verify restrictions on target's new Permitted set */
-	if (!cap_issubset (*permitted,
-			   cap_combine (cred->cap_permitted,
-					cred->cap_permitted))) {
+	if (!cap_issubset(*permitted, old->cap_permitted))
 		return -EPERM;
-	}
 
 	/* verify the _new_Effective_ is a subset of the _new_Permitted_ */
-	if (!cap_issubset (*effective, *permitted)) {
+	if (!cap_issubset(*effective, *permitted))
 		return -EPERM;
-	}
 
+	new->cap_effective   = *effective;
+	new->cap_inheritable = *inheritable;
+	new->cap_permitted   = *permitted;
 	return 0;
 }
 
-void cap_capset_set(const kernel_cap_t *effective,
-		    const kernel_cap_t *inheritable,
-		    const kernel_cap_t *permitted)
-{
-	struct cred *cred = current->cred;
-
-	cred->cap_effective   = *effective;
-	cred->cap_inheritable = *inheritable;
-	cred->cap_permitted   = *permitted;
-}
-
 static inline void bprm_clear_caps(struct linux_binprm *bprm)
 {
 	cap_clear(bprm->cap_post_exec_permitted);
@@ -365,46 +352,52 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
 	return ret;
 }
 
-void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
+int cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 {
-	struct cred *cred = current->cred;
+	const struct cred *old = current_cred();
+	struct cred *new;
+
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
 
-	if (bprm->e_uid != cred->uid || bprm->e_gid != cred->gid ||
+	if (bprm->e_uid != old->uid || bprm->e_gid != old->gid ||
 	    !cap_issubset(bprm->cap_post_exec_permitted,
-			  cred->cap_permitted)) {
+			  old->cap_permitted)) {
 		set_dumpable(current->mm, suid_dumpable);
 		current->pdeath_signal = 0;
 
 		if (unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
 			if (!capable(CAP_SETUID)) {
-				bprm->e_uid = cred->uid;
-				bprm->e_gid = cred->gid;
+				bprm->e_uid = old->uid;
+				bprm->e_gid = old->gid;
 			}
 			if (cap_limit_ptraced_target()) {
 				bprm->cap_post_exec_permitted = cap_intersect(
 					bprm->cap_post_exec_permitted,
-					cred->cap_permitted);
+					new->cap_permitted);
 			}
 		}
 	}
 
-	cred->suid = cred->euid = cred->fsuid = bprm->e_uid;
-	cred->sgid = cred->egid = cred->fsgid = bprm->e_gid;
+	new->suid = new->euid = new->fsuid = bprm->e_uid;
+	new->sgid = new->egid = new->fsgid = bprm->e_gid;
 
 	/* For init, we want to retain the capabilities set
 	 * in the init_task struct. Thus we skip the usual
 	 * capability rules */
 	if (!is_global_init(current)) {
-		cred->cap_permitted = bprm->cap_post_exec_permitted;
+		new->cap_permitted = bprm->cap_post_exec_permitted;
 		if (bprm->cap_effective)
-			cred->cap_effective = bprm->cap_post_exec_permitted;
+			new->cap_effective = bprm->cap_post_exec_permitted;
 		else
-			cap_clear(cred->cap_effective);
+			cap_clear(new->cap_effective);
 	}
 
 	/* AUD: Audit candidate if cred->cap_effective is set */
 
-	cred->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
+	new->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
+	return commit_creds(new);
 }
 
 int cap_bprm_secureexec (struct linux_binprm *bprm)
@@ -479,65 +472,49 @@ int cap_inode_removexattr(struct dentry *dentry, const char *name)
  * files..
  * Thanks to Olaf Kirch and Peter Benie for spotting this.
  */
-static inline void cap_emulate_setxuid (int old_ruid, int old_euid,
-					int old_suid)
+static inline void cap_emulate_setxuid(struct cred *new, const struct cred *old)
 {
-	struct cred *cred = current->cred;
-
-	if ((old_ruid == 0 || old_euid == 0 || old_suid == 0) &&
-	    (cred->uid != 0 && cred->euid != 0 && cred->suid != 0) &&
+	if ((old->uid == 0 || old->euid == 0 || old->suid == 0) &&
+	    (new->uid != 0 && new->euid != 0 && new->suid != 0) &&
 	    !issecure(SECURE_KEEP_CAPS)) {
-		cap_clear(cred->cap_permitted);
-		cap_clear(cred->cap_effective);
-	}
-	if (old_euid == 0 && cred->euid != 0) {
-		cap_clear(cred->cap_effective);
-	}
-	if (old_euid != 0 && cred->euid == 0) {
-		cred->cap_effective = cred->cap_permitted;
+		cap_clear(new->cap_permitted);
+		cap_clear(new->cap_effective);
 	}
+	if (old->euid == 0 && new->euid != 0)
+		cap_clear(new->cap_effective);
+	if (old->euid != 0 && new->euid == 0)
+		new->cap_effective = new->cap_permitted;
 }
 
-int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
-			  int flags)
+int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags)
 {
-	struct cred *cred = current->cred;
-
 	switch (flags) {
 	case LSM_SETID_RE:
 	case LSM_SETID_ID:
 	case LSM_SETID_RES:
 		/* Copied from kernel/sys.c:setreuid/setuid/setresuid. */
-		if (!issecure (SECURE_NO_SETUID_FIXUP)) {
-			cap_emulate_setxuid (old_ruid, old_euid, old_suid);
-		}
+		if (!issecure(SECURE_NO_SETUID_FIXUP))
+			cap_emulate_setxuid(new, old);
 		break;
 	case LSM_SETID_FS:
-		{
-			uid_t old_fsuid = old_ruid;
-
-			/* Copied from kernel/sys.c:setfsuid. */
+		/* Copied from kernel/sys.c:setfsuid. */
 
-			/*
-			 * FIXME - is fsuser used for all CAP_FS_MASK capabilities?
-			 *          if not, we might be a bit too harsh here.
-			 */
-
-			if (!issecure (SECURE_NO_SETUID_FIXUP)) {
-				if (old_fsuid == 0 && cred->fsuid != 0) {
-					cred->cap_effective =
-						cap_drop_fs_set(
-							cred->cap_effective);
-				}
-				if (old_fsuid != 0 && cred->fsuid == 0) {
-					cred->cap_effective =
-						cap_raise_fs_set(
-						    cred->cap_effective,
-						    cred->cap_permitted);
-				}
+		/*
+		 * FIXME - is fsuser used for all CAP_FS_MASK capabilities?
+		 *          if not, we might be a bit too harsh here.
+		 */
+		if (!issecure(SECURE_NO_SETUID_FIXUP)) {
+			if (old->fsuid == 0 && new->fsuid != 0) {
+				new->cap_effective =
+					cap_drop_fs_set(new->cap_effective);
+			}
+			if (old->fsuid != 0 && new->fsuid == 0) {
+				new->cap_effective =
+					cap_raise_fs_set(new->cap_effective,
+							 new->cap_permitted);
 			}
-			break;
 		}
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -593,13 +570,14 @@ int cap_task_setnice (struct task_struct *p, int nice)
  * this task could get inconsistent info.  There can be no
  * racing writer bc a task can only change its own caps.
  */
-static long cap_prctl_drop(unsigned long cap)
+static long cap_prctl_drop(struct cred *new, unsigned long cap)
 {
 	if (!capable(CAP_SETPCAP))
 		return -EPERM;
 	if (!cap_valid(cap))
 		return -EINVAL;
-	cap_lower(current->cred->cap_bset, cap);
+
+	cap_lower(new->cap_bset, cap);
 	return 0;
 }
 
@@ -620,22 +598,29 @@ int cap_task_setnice (struct task_struct *p, int nice)
 #endif
 
 int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
-		   unsigned long arg4, unsigned long arg5, long *rc_p)
+		   unsigned long arg4, unsigned long arg5)
 {
-	struct cred *cred = current_cred();
+	struct cred *new;
 	long error = 0;
 
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
 	switch (option) {
 	case PR_CAPBSET_READ:
+		error = -EINVAL;
 		if (!cap_valid(arg2))
-			error = -EINVAL;
-		else
-			error = !!cap_raised(cred->cap_bset, arg2);
-		break;
+			goto error;
+		error = !!cap_raised(new->cap_bset, arg2);
+		goto no_change;
+
 #ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 	case PR_CAPBSET_DROP:
-		error = cap_prctl_drop(arg2);
-		break;
+		error = cap_prctl_drop(new, arg2);
+		if (error < 0)
+			goto error;
+		goto changed;
 
 	/*
 	 * The next four prctl's remain to assist with transitioning a
@@ -657,12 +642,12 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 	 * capability-based-privilege environment.
 	 */
 	case PR_SET_SECUREBITS:
-		if ((((cred->securebits & SECURE_ALL_LOCKS) >> 1)
-		     & (cred->securebits ^ arg2))                  /*[1]*/
-		    || ((cred->securebits & SECURE_ALL_LOCKS
-			 & ~arg2))                                    /*[2]*/
-		    || (arg2 & ~(SECURE_ALL_LOCKS | SECURE_ALL_BITS)) /*[3]*/
-		    || (cap_capable(current, CAP_SETPCAP) != 0)) {    /*[4]*/
+		error = -EPERM;
+		if ((((new->securebits & SECURE_ALL_LOCKS) >> 1)
+		     & (new->securebits ^ arg2))			/*[1]*/
+		    || (new->securebits & SECURE_ALL_LOCKS & ~arg2)	/*[2]*/
+		    || (arg2 & ~(SECURE_ALL_LOCKS | SECURE_ALL_BITS))	/*[3]*/
+		    || (cap_capable(current, CAP_SETPCAP) != 0)		/*[4]*/
 			/*
 			 * [1] no changing of bits that are locked
 			 * [2] no unlocking of locks
@@ -670,50 +655,51 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			 * [4] doing anything requires privilege (go read about
 			 *     the "sendmail capabilities bug")
 			 */
-			error = -EPERM;  /* cannot change a locked bit */
-		} else {
-			cred->securebits = arg2;
-		}
-		break;
+		    )
+			/* cannot change a locked bit */
+			goto error;
+		new->securebits = arg2;
+		goto changed;
+
 	case PR_GET_SECUREBITS:
-		error = cred->securebits;
-		break;
+		error = new->securebits;
+		goto no_change;
 
 #endif /* def CONFIG_SECURITY_FILE_CAPABILITIES */
 
 	case PR_GET_KEEPCAPS:
 		if (issecure(SECURE_KEEP_CAPS))
 			error = 1;
-		break;
+		goto no_change;
+
 	case PR_SET_KEEPCAPS:
+		error = -EINVAL;
 		if (arg2 > 1) /* Note, we rely on arg2 being unsigned here */
-			error = -EINVAL;
-		else if (issecure(SECURE_KEEP_CAPS_LOCKED))
-			error = -EPERM;
-		else if (arg2)
-			cred->securebits |= issecure_mask(SECURE_KEEP_CAPS);
+			goto error;
+		error = -EPERM;
+		if (issecure(SECURE_KEEP_CAPS_LOCKED))
+			goto error;
+		if (arg2)
+			new->securebits |= issecure_mask(SECURE_KEEP_CAPS);
 		else
-			cred->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
-		break;
+			new->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
+		goto changed;
 
 	default:
 		/* No functionality available - continue with default */
-		return 0;
+		error = -ENOSYS;
+		goto error;
 	}
 
 	/* Functionality provided */
-	*rc_p = error;
-	return 1;
-}
-
-void cap_task_reparent_to_init (struct task_struct *p)
-{
-	struct cred *cred = p->cred;
-
-	cap_set_init_eff(cred->cap_effective);
-	cap_clear(cred->cap_inheritable);
-	cap_set_full(cred->cap_permitted);
-	p->cred->securebits = SECUREBITS_DEFAULT;
+changed:
+	return commit_creds(new);
+
+no_change:
+	error = 0;
+error:
+	abort_creds(new);
+	return error;
 }
 
 int cap_syslog (int type)
diff --git a/security/keys/internal.h b/security/keys/internal.h
index cb8c678..191f5e5 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -12,6 +12,7 @@
 #ifndef _INTERNAL_H
 #define _INTERNAL_H
 
+#include <linux/sched.h>
 #include <linux/key-type.h>
 
 static inline __attribute__((format(printf, 1, 2)))
@@ -25,7 +26,7 @@ void no_printk(const char *fmt, ...)
 #define kleave(FMT, ...) \
 	printk(KERN_DEBUG "<== %s()"FMT"\n", __func__, ##__VA_ARGS__)
 #define kdebug(FMT, ...) \
-	printk(KERN_DEBUG "xxx" FMT"yyy\n", ##__VA_ARGS__)
+	printk(KERN_DEBUG "   "FMT"\n", ##__VA_ARGS__)
 #else
 #define kenter(FMT, ...) \
 	no_printk(KERN_DEBUG "==> %s("FMT")\n", __func__, ##__VA_ARGS__)
@@ -97,7 +98,7 @@ extern struct key *keyring_search_instkey(struct key *keyring,
 typedef int (*key_match_func_t)(const struct key *, const void *);
 
 extern key_ref_t keyring_search_aux(key_ref_t keyring_ref,
-				    struct task_struct *tsk,
+				    const struct cred *cred,
 				    struct key_type *type,
 				    const void *description,
 				    key_match_func_t match);
@@ -105,12 +106,12 @@ extern key_ref_t keyring_search_aux(key_ref_t keyring_ref,
 extern key_ref_t search_process_keyrings(struct key_type *type,
 					 const void *description,
 					 key_match_func_t match,
-					 struct task_struct *tsk);
+					 const struct cred *cred);
 
 extern struct key *find_keyring_by_name(const char *name, bool skip_perm_check);
 
-extern int install_thread_keyring(void);
-extern int install_process_keyring(void);
+extern int install_thread_keyring_to_cred(struct cred *);
+extern int install_process_keyring_to_cred(struct cred *);
 
 extern struct key *request_key_and_link(struct key_type *type,
 					const char *description,
@@ -129,12 +130,12 @@ extern long join_session_keyring(const char *name);
  * check to see whether permission is granted to use a key in the desired way
  */
 extern int key_task_permission(const key_ref_t key_ref,
-			       struct task_struct *context,
+			       const struct cred *cred,
 			       key_perm_t perm);
 
 static inline int key_permission(const key_ref_t key_ref, key_perm_t perm)
 {
-	return key_task_permission(key_ref, current, perm);
+	return key_task_permission(key_ref, current_cred(), perm);
 }
 
 /* required permissions */
@@ -152,7 +153,7 @@ static inline int key_permission(const key_ref_t key_ref, key_perm_t perm)
 struct request_key_auth {
 	struct key		*target_key;
 	struct key		*dest_keyring;
-	struct task_struct	*context;
+	const struct cred	*cred;
 	void			*callout_info;
 	size_t			callout_len;
 	pid_t			pid;
diff --git a/security/keys/key.c b/security/keys/key.c
index a6ca39e..f76c8a5 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -218,7 +218,7 @@ serial_exists:
  *   instantiate the key or discard it before returning
  */
 struct key *key_alloc(struct key_type *type, const char *desc,
-		      uid_t uid, gid_t gid, struct task_struct *ctx,
+		      uid_t uid, gid_t gid, const struct cred *cred,
 		      key_perm_t perm, unsigned long flags)
 {
 	struct key_user *user = NULL;
@@ -294,7 +294,7 @@ struct key *key_alloc(struct key_type *type, const char *desc,
 #endif
 
 	/* let the security module know about the key */
-	ret = security_key_alloc(key, ctx, flags);
+	ret = security_key_alloc(key, cred, flags);
 	if (ret < 0)
 		goto security_error;
 
@@ -391,7 +391,7 @@ static int __key_instantiate_and_link(struct key *key,
 				      const void *data,
 				      size_t datalen,
 				      struct key *keyring,
-				      struct key *instkey)
+				      struct key *authkey)
 {
 	int ret, awaken;
 
@@ -421,8 +421,8 @@ static int __key_instantiate_and_link(struct key *key,
 				ret = __key_link(keyring, key);
 
 			/* disable the authorisation key */
-			if (instkey)
-				key_revoke(instkey);
+			if (authkey)
+				key_revoke(authkey);
 		}
 	}
 
@@ -444,14 +444,14 @@ int key_instantiate_and_link(struct key *key,
 			     const void *data,
 			     size_t datalen,
 			     struct key *keyring,
-			     struct key *instkey)
+			     struct key *authkey)
 {
 	int ret;
 
 	if (keyring)
 		down_write(&keyring->sem);
 
-	ret = __key_instantiate_and_link(key, data, datalen, keyring, instkey);
+	ret = __key_instantiate_and_link(key, data, datalen, keyring, authkey);
 
 	if (keyring)
 		up_write(&keyring->sem);
@@ -469,7 +469,7 @@ EXPORT_SYMBOL(key_instantiate_and_link);
 int key_negate_and_link(struct key *key,
 			unsigned timeout,
 			struct key *keyring,
-			struct key *instkey)
+			struct key *authkey)
 {
 	struct timespec now;
 	int ret, awaken;
@@ -504,8 +504,8 @@ int key_negate_and_link(struct key *key,
 			ret = __key_link(keyring, key);
 
 		/* disable the authorisation key */
-		if (instkey)
-			key_revoke(instkey);
+		if (authkey)
+			key_revoke(authkey);
 	}
 
 	mutex_unlock(&key_construction_mutex);
@@ -743,6 +743,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 			       key_perm_t perm,
 			       unsigned long flags)
 {
+	const struct cred *cred = current_cred();
 	struct key_type *ktype;
 	struct key *keyring, *key = NULL;
 	key_ref_t key_ref;
@@ -802,8 +803,8 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 	}
 
 	/* allocate a new key */
-	key = key_alloc(ktype, description, current_fsuid(), current_fsgid(),
-			current, perm, flags);
+	key = key_alloc(ktype, description, cred->fsuid, cred->fsgid, cred,
+			perm, flags);
 	if (IS_ERR(key)) {
 		key_ref = ERR_CAST(key);
 		goto error_3;
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 8833b44..7c72baa 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -866,6 +866,23 @@ static long get_instantiation_keyring(key_serial_t ringid,
 	return -ENOKEY;
 }
 
+/*
+ * change the request_key authorisation key on the current process
+ */
+static int keyctl_change_reqkey_auth(struct key *key)
+{
+	struct cred *new;
+
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
+	key_put(new->request_key_auth);
+	new->request_key_auth = key_get(key);
+
+	return commit_creds(new);
+}
+
 /*****************************************************************************/
 /*
  * instantiate the key with the specified payload, and, if one is given, link
@@ -876,12 +893,15 @@ long keyctl_instantiate_key(key_serial_t id,
 			    size_t plen,
 			    key_serial_t ringid)
 {
+	const struct cred *cred = current_cred();
 	struct request_key_auth *rka;
 	struct key *instkey, *dest_keyring;
 	void *payload;
 	long ret;
 	bool vm = false;
 
+	kenter("%d,,%zu,%d", id, plen, ringid);
+
 	ret = -EINVAL;
 	if (plen > 1024 * 1024 - 1)
 		goto error;
@@ -889,7 +909,7 @@ long keyctl_instantiate_key(key_serial_t id,
 	/* the appropriate instantiation authorisation key must have been
 	 * assumed before calling this */
 	ret = -EPERM;
-	instkey = current->cred->request_key_auth;
+	instkey = cred->request_key_auth;
 	if (!instkey)
 		goto error;
 
@@ -931,10 +951,8 @@ long keyctl_instantiate_key(key_serial_t id,
 
 	/* discard the assumed authority if it's just been disabled by
 	 * instantiation of the key */
-	if (ret == 0) {
-		key_put(current->cred->request_key_auth);
-		current->cred->request_key_auth = NULL;
-	}
+	if (ret == 0)
+		keyctl_change_reqkey_auth(NULL);
 
 error2:
 	if (!vm)
@@ -953,14 +971,17 @@ error:
  */
 long keyctl_negate_key(key_serial_t id, unsigned timeout, key_serial_t ringid)
 {
+	const struct cred *cred = current_cred();
 	struct request_key_auth *rka;
 	struct key *instkey, *dest_keyring;
 	long ret;
 
+	kenter("%d,%u,%d", id, timeout, ringid);
+
 	/* the appropriate instantiation authorisation key must have been
 	 * assumed before calling this */
 	ret = -EPERM;
-	instkey = current->cred->request_key_auth;
+	instkey = cred->request_key_auth;
 	if (!instkey)
 		goto error;
 
@@ -982,10 +1003,8 @@ long keyctl_negate_key(key_serial_t id, unsigned timeout, key_serial_t ringid)
 
 	/* discard the assumed authority if it's just been disabled by
 	 * instantiation of the key */
-	if (ret == 0) {
-		key_put(current->cred->request_key_auth);
-		current->cred->request_key_auth = NULL;
-	}
+	if (ret == 0)
+		keyctl_change_reqkey_auth(NULL);
 
 error:
 	return ret;
@@ -999,36 +1018,56 @@ error:
  */
 long keyctl_set_reqkey_keyring(int reqkey_defl)
 {
-	struct cred *cred = current->cred;
-	int ret;
+	struct cred *new;
+	int ret, old_setting;
+
+	old_setting = current_cred_xxx(jit_keyring);
+
+	if (reqkey_defl == KEY_REQKEY_DEFL_NO_CHANGE)
+		return old_setting;
+
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
 
 	switch (reqkey_defl) {
 	case KEY_REQKEY_DEFL_THREAD_KEYRING:
-		ret = install_thread_keyring();
+		ret = install_thread_keyring_to_cred(new);
 		if (ret < 0)
-			return ret;
+			goto error;
 		goto set;
 
 	case KEY_REQKEY_DEFL_PROCESS_KEYRING:
-		ret = install_process_keyring();
-		if (ret < 0)
-			return ret;
+		ret = install_process_keyring_to_cred(new);
+		if (ret < 0) {
+			if (ret != -EEXIST)
+				goto error;
+			ret = 0;
+		}
+		goto set;
 
 	case KEY_REQKEY_DEFL_DEFAULT:
 	case KEY_REQKEY_DEFL_SESSION_KEYRING:
 	case KEY_REQKEY_DEFL_USER_KEYRING:
 	case KEY_REQKEY_DEFL_USER_SESSION_KEYRING:
-	set:
-		cred->jit_keyring = reqkey_defl;
+	case KEY_REQKEY_DEFL_REQUESTOR_KEYRING:
+		goto set;
 
 	case KEY_REQKEY_DEFL_NO_CHANGE:
-		return cred->jit_keyring;
-
 	case KEY_REQKEY_DEFL_GROUP_KEYRING:
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+		goto error;
 	}
 
+set:
+	new->jit_keyring = reqkey_defl;
+	commit_creds(new);
+	return old_setting;
+error:
+	abort_creds(new);
+	return -EINVAL;
+
 } /* end keyctl_set_reqkey_keyring() */
 
 /*****************************************************************************/
@@ -1087,9 +1126,7 @@ long keyctl_assume_authority(key_serial_t id)
 
 	/* we divest ourselves of authority if given an ID of 0 */
 	if (id == 0) {
-		key_put(current->cred->request_key_auth);
-		current->cred->request_key_auth = NULL;
-		ret = 0;
+		ret = keyctl_change_reqkey_auth(NULL);
 		goto error;
 	}
 
@@ -1104,10 +1141,12 @@ long keyctl_assume_authority(key_serial_t id)
 		goto error;
 	}
 
-	key_put(current->cred->request_key_auth);
-	current->cred->request_key_auth = authkey;
-	ret = authkey->serial;
+	ret = keyctl_change_reqkey_auth(authkey);
+	if (ret < 0)
+		goto error;
+	key_put(authkey);
 
+	ret = authkey->serial;
 error:
 	return ret;
 
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index fdf75f9..ed85157 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -245,14 +245,14 @@ static long keyring_read(const struct key *keyring,
  * allocate a keyring and link into the destination keyring
  */
 struct key *keyring_alloc(const char *description, uid_t uid, gid_t gid,
-			  struct task_struct *ctx, unsigned long flags,
+			  const struct cred *cred, unsigned long flags,
 			  struct key *dest)
 {
 	struct key *keyring;
 	int ret;
 
 	keyring = key_alloc(&key_type_keyring, description,
-			    uid, gid, ctx,
+			    uid, gid, cred,
 			    (KEY_POS_ALL & ~KEY_POS_SETATTR) | KEY_USR_ALL,
 			    flags);
 
@@ -281,7 +281,7 @@ struct key *keyring_alloc(const char *description, uid_t uid, gid_t gid,
  * - we propagate the possession attribute from the keyring ref to the key ref
  */
 key_ref_t keyring_search_aux(key_ref_t keyring_ref,
-			     struct task_struct *context,
+			     const struct cred *cred,
 			     struct key_type *type,
 			     const void *description,
 			     key_match_func_t match)
@@ -304,7 +304,7 @@ key_ref_t keyring_search_aux(key_ref_t keyring_ref,
 	key_check(keyring);
 
 	/* top keyring must have search permission to begin the search */
-        err = key_task_permission(keyring_ref, context, KEY_SEARCH);
+        err = key_task_permission(keyring_ref, cred, KEY_SEARCH);
 	if (err < 0) {
 		key_ref = ERR_PTR(err);
 		goto error;
@@ -377,7 +377,7 @@ descend:
 
 		/* key must have search permissions */
 		if (key_task_permission(make_key_ref(key, possessed),
-					context, KEY_SEARCH) < 0)
+					cred, KEY_SEARCH) < 0)
 			continue;
 
 		/* we set a different error code if we pass a negative key */
@@ -404,7 +404,7 @@ ascend:
 			continue;
 
 		if (key_task_permission(make_key_ref(key, possessed),
-					context, KEY_SEARCH) < 0)
+					cred, KEY_SEARCH) < 0)
 			continue;
 
 		/* stack the current position */
@@ -459,7 +459,7 @@ key_ref_t keyring_search(key_ref_t keyring,
 	if (!type->match)
 		return ERR_PTR(-ENOKEY);
 
-	return keyring_search_aux(keyring, current,
+	return keyring_search_aux(keyring, current->cred,
 				  type, description, type->match);
 
 } /* end keyring_search() */
diff --git a/security/keys/permission.c b/security/keys/permission.c
index 13c3616..5d9fc7b 100644
--- a/security/keys/permission.c
+++ b/security/keys/permission.c
@@ -14,24 +14,27 @@
 #include "internal.h"
 
 /*****************************************************************************/
-/*
- * check to see whether permission is granted to use a key in the desired way,
- * but permit the security modules to override
+/**
+ * key_task_permission - Check a key can be used
+ * @key_ref: The key to check
+ * @cred: The credentials to use
+ * @perm: The permissions to check for
+ *
+ * Check to see whether permission is granted to use a key in the desired way,
+ * but permit the security modules to override.
+ *
+ * The caller must hold either a ref on cred or must hold the RCU readlock or a
+ * spinlock.
  */
-int key_task_permission(const key_ref_t key_ref,
-			struct task_struct *context,
+int key_task_permission(const key_ref_t key_ref, const struct cred *cred,
 			key_perm_t perm)
 {
-	const struct cred *cred;
 	struct key *key;
 	key_perm_t kperm;
 	int ret;
 
 	key = key_ref_to_ptr(key_ref);
 
-	rcu_read_lock();
-	cred = __task_cred(context);
-
 	/* use the second 8-bits of permissions for keys the caller owns */
 	if (key->uid == cred->fsuid) {
 		kperm = key->perm >> 16;
@@ -57,7 +60,6 @@ int key_task_permission(const key_ref_t key_ref,
 	kperm = key->perm;
 
 use_these_perms:
-	rcu_read_lock();
 
 	/* use the top 8-bits of permissions for keys the caller possesses
 	 * - possessor permissions are additive with other permissions
@@ -71,7 +73,7 @@ use_these_perms:
 		return -EACCES;
 
 	/* let LSM be the final arbiter */
-	return security_key_permission(key_ref, context, perm);
+	return security_key_permission(key_ref, cred, perm);
 
 } /* end key_task_permission() */
 
diff --git a/security/keys/proc.c b/security/keys/proc.c
index f619170..7f508de 100644
--- a/security/keys/proc.c
+++ b/security/keys/proc.c
@@ -136,8 +136,12 @@ static int proc_keys_show(struct seq_file *m, void *v)
 	int rc;
 
 	/* check whether the current task is allowed to view the key (assuming
-	 * non-possession) */
-	rc = key_task_permission(make_key_ref(key, 0), current, KEY_VIEW);
+	 * non-possession)
+	 * - the caller holds a spinlock, and thus the RCU read lock, making our
+	 *   access to __current_cred() safe
+	 */
+	rc = key_task_permission(make_key_ref(key, 0), current_cred(),
+				 KEY_VIEW);
 	if (rc < 0)
 		return 0;
 
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index b0a6060..c8d8f3c 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -42,11 +42,15 @@ struct key_user root_key_user = {
  */
 static int install_user_keyrings(void)
 {
-	struct user_struct *user = current_user();
+	struct user_struct *user;
+	const struct cred *cred;
 	struct key *uid_keyring, *session_keyring;
 	char buf[20];
 	int ret;
 
+	cred = current_cred();
+	user = cred->user;
+
 	kenter("%p{%u}", user, user->uid);
 
 	if (user->uid_keyring) {
@@ -67,7 +71,7 @@ static int install_user_keyrings(void)
 		uid_keyring = find_keyring_by_name(buf, true);
 		if (IS_ERR(uid_keyring)) {
 			uid_keyring = keyring_alloc(buf, user->uid, (gid_t) -1,
-						    current, KEY_ALLOC_IN_QUOTA,
+						    cred, KEY_ALLOC_IN_QUOTA,
 						    NULL);
 			if (IS_ERR(uid_keyring)) {
 				ret = PTR_ERR(uid_keyring);
@@ -83,8 +87,7 @@ static int install_user_keyrings(void)
 		if (IS_ERR(session_keyring)) {
 			session_keyring =
 				keyring_alloc(buf, user->uid, (gid_t) -1,
-					      current, KEY_ALLOC_IN_QUOTA,
-					      NULL);
+					      cred, KEY_ALLOC_IN_QUOTA, NULL);
 			if (IS_ERR(session_keyring)) {
 				ret = PTR_ERR(session_keyring);
 				goto error_release;
@@ -116,142 +119,128 @@ error:
 	return ret;
 }
 
-/*****************************************************************************/
 /*
- * deal with the UID changing
+ * install a fresh thread keyring directly to new credentials
  */
-void switch_uid_keyring(struct user_struct *new_user)
+int install_thread_keyring_to_cred(struct cred *new)
 {
-#if 0 /* do nothing for now */
-	struct key *old;
-
-	/* switch to the new user's session keyring if we were running under
-	 * root's default session keyring */
-	if (new_user->uid != 0 &&
-	    current->session_keyring == &root_session_keyring
-	    ) {
-		atomic_inc(&new_user->session_keyring->usage);
-
-		task_lock(current);
-		old = current->session_keyring;
-		current->session_keyring = new_user->session_keyring;
-		task_unlock(current);
+	struct key *keyring;
 
-		key_put(old);
-	}
-#endif
+	keyring = keyring_alloc("_tid", new->uid, new->gid, new,
+				KEY_ALLOC_QUOTA_OVERRUN, NULL);
+	if (IS_ERR(keyring))
+		return PTR_ERR(keyring);
 
-} /* end switch_uid_keyring() */
+	new->thread_keyring = keyring;
+	return 0;
+}
 
-/*****************************************************************************/
 /*
  * install a fresh thread keyring, discarding the old one
  */
-int install_thread_keyring(void)
+static int install_thread_keyring(void)
 {
-	struct task_struct *tsk = current;
-	struct key *keyring, *old;
-	char buf[20];
+	struct cred *new;
 	int ret;
 
-	sprintf(buf, "_tid.%u", tsk->pid);
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
 
-	keyring = keyring_alloc(buf, tsk->cred->uid, tsk->cred->gid, tsk,
-				KEY_ALLOC_QUOTA_OVERRUN, NULL);
-	if (IS_ERR(keyring)) {
-		ret = PTR_ERR(keyring);
-		goto error;
+	BUG_ON(new->thread_keyring);
+
+	ret = install_thread_keyring_to_cred(new);
+	if (ret < 0) {
+		abort_creds(new);
+		return ret;
 	}
 
-	task_lock(tsk);
-	old = tsk->cred->thread_keyring;
-	tsk->cred->thread_keyring = keyring;
-	task_unlock(tsk);
+	return commit_creds(new);
+}
 
-	ret = 0;
+/*
+ * install a process keyring directly to a credentials struct
+ * - returns -EEXIST if there was already a process keyring, 0 if one installed,
+ *   and other -ve on any other error
+ */
+int install_process_keyring_to_cred(struct cred *new)
+{
+	struct key *keyring;
+	int ret;
 
-	key_put(old);
-error:
+	if (new->tgcred->process_keyring)
+		return -EEXIST;
+
+	keyring = keyring_alloc("_pid", new->uid, new->gid,
+				new, KEY_ALLOC_QUOTA_OVERRUN, NULL);
+	if (IS_ERR(keyring))
+		return PTR_ERR(keyring);
+
+	spin_lock_irq(&new->tgcred->lock);
+	if (!new->tgcred->process_keyring) {
+		new->tgcred->process_keyring = keyring;
+		keyring = NULL;
+		ret = 0;
+	} else {
+		ret = -EEXIST;
+	}
+	spin_unlock_irq(&new->tgcred->lock);
+	key_put(keyring);
 	return ret;
+}
 
-} /* end install_thread_keyring() */
-
-/*****************************************************************************/
 /*
  * make sure a process keyring is installed
+ * - we 
  */
-int install_process_keyring(void)
+static int install_process_keyring(void)
 {
-	struct task_struct *tsk = current;
-	struct key *keyring;
-	char buf[20];
+	struct cred *new;
 	int ret;
 
-	might_sleep();
-
-	if (!tsk->cred->tgcred->process_keyring) {
-		sprintf(buf, "_pid.%u", tsk->tgid);
-
-		keyring = keyring_alloc(buf, tsk->cred->uid, tsk->cred->gid, tsk,
-					KEY_ALLOC_QUOTA_OVERRUN, NULL);
-		if (IS_ERR(keyring)) {
-			ret = PTR_ERR(keyring);
-			goto error;
-		}
-
-		/* attach keyring */
-		spin_lock_irq(&tsk->cred->tgcred->lock);
-		if (!tsk->cred->tgcred->process_keyring) {
-			tsk->cred->tgcred->process_keyring = keyring;
-			keyring = NULL;
-		}
-		spin_unlock_irq(&tsk->cred->tgcred->lock);
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
 
-		key_put(keyring);
+	ret = install_process_keyring_to_cred(new);
+	if (ret < 0) {
+		abort_creds(new);
+		return ret != -EEXIST ?: 0;
 	}
 
-	ret = 0;
-error:
-	return ret;
-
-} /* end install_process_keyring() */
+	return commit_creds(new);
+}
 
-/*****************************************************************************/
 /*
- * install a session keyring, discarding the old one
- * - if a keyring is not supplied, an empty one is invented
+ * install a session keyring directly to a credentials struct
  */
-static int install_session_keyring(struct key *keyring)
+static int install_session_keyring_to_cred(struct cred *cred,
+					   struct key *keyring)
 {
-	struct task_struct *tsk = current;
 	unsigned long flags;
 	struct key *old;
-	char buf[20];
 
 	might_sleep();
 
 	/* create an empty session keyring */
 	if (!keyring) {
-		sprintf(buf, "_ses.%u", tsk->tgid);
-
 		flags = KEY_ALLOC_QUOTA_OVERRUN;
-		if (tsk->cred->tgcred->session_keyring)
+		if (cred->tgcred->session_keyring)
 			flags = KEY_ALLOC_IN_QUOTA;
 
-		keyring = keyring_alloc(buf, tsk->cred->uid, tsk->cred->gid,
-					tsk, flags, NULL);
+		keyring = keyring_alloc("_ses", cred->uid, cred->gid,
+					cred, flags, NULL);
 		if (IS_ERR(keyring))
 			return PTR_ERR(keyring);
-	}
-	else {
+	} else {
 		atomic_inc(&keyring->usage);
 	}
 
 	/* install the keyring */
-	spin_lock_irq(&tsk->cred->tgcred->lock);
-	old = tsk->cred->tgcred->session_keyring;
-	rcu_assign_pointer(tsk->cred->tgcred->session_keyring, keyring);
-	spin_unlock_irq(&tsk->cred->tgcred->lock);
+	spin_lock_irq(&cred->tgcred->lock);
+	old = cred->tgcred->session_keyring;
+	rcu_assign_pointer(cred->tgcred->session_keyring, keyring);
+	spin_unlock_irq(&cred->tgcred->lock);
 
 	/* we're using RCU on the pointer, but there's no point synchronising
 	 * on it if it didn't previously point to anything */
@@ -261,38 +250,29 @@ static int install_session_keyring(struct key *keyring)
 	}
 
 	return 0;
+}
 
-} /* end install_session_keyring() */
-
-/*****************************************************************************/
 /*
- * copy the keys for fork
+ * install a session keyring, discarding the old one
+ * - if a keyring is not supplied, an empty one is invented
  */
-int copy_keys(unsigned long clone_flags, struct task_struct *tsk)
+static int install_session_keyring(struct key *keyring)
 {
-	key_check(tsk->cred->thread_keyring);
-	key_check(tsk->cred->request_key_auth);
-
-	/* no thread keyring yet */
-	tsk->cred->thread_keyring = NULL;
-
-	/* copy the request_key() authorisation for this thread */
-	key_get(tsk->cred->request_key_auth);
-
-	return 0;
+	struct cred *new;
+	int ret;
 
-} /* end copy_keys() */
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
 
-/*****************************************************************************/
-/*
- * dispose of per-thread keys upon thread exit
- */
-void exit_keys(struct task_struct *tsk)
-{
-	key_put(tsk->cred->thread_keyring);
-	key_put(tsk->cred->request_key_auth);
+	ret = install_session_keyring_to_cred(new, NULL);
+	if (ret < 0) {
+		abort_creds(new);
+		return ret;
+	}
 
-} /* end exit_keys() */
+	return commit_creds(new);
+}
 
 /*****************************************************************************/
 /*
@@ -300,38 +280,41 @@ void exit_keys(struct task_struct *tsk)
  */
 int exec_keys(struct task_struct *tsk)
 {
-	struct key *old;
+	struct thread_group_cred *tgcred = NULL;
+	struct cred *new;
 
-	/* newly exec'd tasks don't get a thread keyring */
-	task_lock(tsk);
-	old = tsk->cred->thread_keyring;
-	tsk->cred->thread_keyring = NULL;
-	task_unlock(tsk);
+#ifdef CONFIG_KEYS
+	tgcred = kmalloc(sizeof(*tgcred), GFP_KERNEL);
+	if (!tgcred)
+		return -ENOMEM;
+#endif
 
-	key_put(old);
+	new = prepare_creds();
+	if (new < 0)
+		return -ENOMEM;
 
-	/* discard the process keyring from a newly exec'd task */
-	spin_lock_irq(&tsk->cred->tgcred->lock);
-	old = tsk->cred->tgcred->process_keyring;
-	tsk->cred->tgcred->process_keyring = NULL;
-	spin_unlock_irq(&tsk->cred->tgcred->lock);
+	/* newly exec'd tasks don't get a thread keyring */
+	key_put(new->thread_keyring);
+	new->thread_keyring = NULL;
 
-	key_put(old);
+	/* create a new per-thread-group creds for all this set of threads to
+	 * share */
+	memcpy(tgcred, new->tgcred, sizeof(struct thread_group_cred));
 
-	return 0;
+	atomic_set(&tgcred->usage, 1);
+	spin_lock_init(&tgcred->lock);
 
-} /* end exec_keys() */
+	/* inherit the session keyring; new process keyring */
+	key_get(tgcred->session_keyring);
+	tgcred->process_keyring = NULL;
 
-/*****************************************************************************/
-/*
- * deal with SUID programs
- * - we might want to make this invent a new session keyring
- */
-int suid_keys(struct task_struct *tsk)
-{
+	put_tgcred(new->tgcred);
+	new->tgcred = tgcred;
+
+	commit_creds(new);
 	return 0;
 
-} /* end suid_keys() */
+} /* end exec_keys() */
 
 /*****************************************************************************/
 /*
@@ -376,16 +359,13 @@ void key_fsgid_changed(struct task_struct *tsk)
 key_ref_t search_process_keyrings(struct key_type *type,
 				  const void *description,
 				  key_match_func_t match,
-				  struct task_struct *context)
+				  const struct cred *cred)
 {
 	struct request_key_auth *rka;
-	struct cred *cred;
 	key_ref_t key_ref, ret, err;
 
 	might_sleep();
 
-	cred = get_task_cred(context);
-
 	/* we want to return -EAGAIN or -ENOKEY if any of the keyrings were
 	 * searchable, but we failed to find a key or we found a negative key;
 	 * otherwise we want to return a sample error (probably -EACCES) if
@@ -401,7 +381,7 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	if (cred->thread_keyring) {
 		key_ref = keyring_search_aux(
 			make_key_ref(cred->thread_keyring, 1),
-			context, type, description, match);
+			cred, type, description, match);
 		if (!IS_ERR(key_ref))
 			goto found;
 
@@ -422,7 +402,7 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	if (cred->tgcred->process_keyring) {
 		key_ref = keyring_search_aux(
 			make_key_ref(cred->tgcred->process_keyring, 1),
-			context, type, description, match);
+			cred, type, description, match);
 		if (!IS_ERR(key_ref))
 			goto found;
 
@@ -446,7 +426,7 @@ key_ref_t search_process_keyrings(struct key_type *type,
 			make_key_ref(rcu_dereference(
 					     cred->tgcred->session_keyring),
 				     1),
-			context, type, description, match);
+			cred, type, description, match);
 		rcu_read_unlock();
 
 		if (!IS_ERR(key_ref))
@@ -468,7 +448,7 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	else if (cred->user->session_keyring) {
 		key_ref = keyring_search_aux(
 			make_key_ref(cred->user->session_keyring, 1),
-			context, type, description, match);
+			cred, type, description, match);
 		if (!IS_ERR(key_ref))
 			goto found;
 
@@ -490,7 +470,7 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	 * - we don't permit access to request_key auth keys via this method
 	 */
 	if (cred->request_key_auth &&
-	    context == current &&
+	    cred == current_cred() &&
 	    type != &key_type_request_key_auth
 	    ) {
 		/* defend against the auth key being revoked */
@@ -500,7 +480,7 @@ key_ref_t search_process_keyrings(struct key_type *type,
 			rka = cred->request_key_auth->payload.data;
 
 			key_ref = search_process_keyrings(type, description,
-							  match, rka->context);
+							  match, rka->cred);
 
 			up_read(&cred->request_key_auth->sem);
 
@@ -527,7 +507,6 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	key_ref = ret ? ret : err;
 
 found:
-	put_cred(cred);
 	return key_ref;
 
 } /* end search_process_keyrings() */
@@ -552,8 +531,7 @@ key_ref_t lookup_user_key(key_serial_t id, int create, int partial,
 			  key_perm_t perm)
 {
 	struct request_key_auth *rka;
-	struct task_struct *t = current;
-	struct cred *cred;
+	const struct cred *cred;
 	struct key *key;
 	key_ref_t key_ref, skey_ref;
 	int ret;
@@ -608,6 +586,7 @@ try_again:
 				goto error;
 			ret = install_session_keyring(
 				cred->user->session_keyring);
+
 			if (ret < 0)
 				goto error;
 			goto reget_creds;
@@ -693,7 +672,7 @@ try_again:
 		/* check to see if we possess the key */
 		skey_ref = search_process_keyrings(key->type, key,
 						   lookup_user_key_possessed,
-						   current);
+						   cred);
 
 		if (!IS_ERR(skey_ref)) {
 			key_put(key);
@@ -725,7 +704,7 @@ try_again:
 		goto invalid_key;
 
 	/* check the permissions */
-	ret = key_task_permission(key_ref, t, perm);
+	ret = key_task_permission(key_ref, cred, perm);
 	if (ret < 0)
 		goto invalid_key;
 
@@ -754,21 +733,33 @@ reget_creds:
  */
 long join_session_keyring(const char *name)
 {
-	struct task_struct *tsk = current;
-	struct cred *cred = current->cred;
+	const struct cred *old;
+	struct cred *new;
 	struct key *keyring;
-	long ret;
+	long ret, serial;
+
+	/* only permit this if there's a single thread in the thread group -
+	 * this avoids us having to adjust the creds on all threads and risking
+	 * ENOMEM */
+	if (!is_single_threaded(current))
+		return -EMLINK;
+
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+	old = current_cred();
 
 	/* if no name is provided, install an anonymous keyring */
 	if (!name) {
-		ret = install_session_keyring(NULL);
+		ret = install_session_keyring_to_cred(new, NULL);
 		if (ret < 0)
 			goto error;
 
-		rcu_read_lock();
-		ret = rcu_dereference(cred->tgcred->session_keyring)->serial;
-		rcu_read_unlock();
-		goto error;
+		serial = new->tgcred->session_keyring->serial;
+		ret = commit_creds(new);
+		if (ret == 0)
+			ret = serial;
+		goto okay;
 	}
 
 	/* allow the user to join or create a named keyring */
@@ -778,29 +769,33 @@ long join_session_keyring(const char *name)
 	keyring = find_keyring_by_name(name, false);
 	if (PTR_ERR(keyring) == -ENOKEY) {
 		/* not found - try and create a new one */
-		keyring = keyring_alloc(name, cred->uid, cred->gid, tsk,
+		keyring = keyring_alloc(name, old->uid, old->gid, old,
 					KEY_ALLOC_IN_QUOTA, NULL);
 		if (IS_ERR(keyring)) {
 			ret = PTR_ERR(keyring);
 			goto error2;
 		}
-	}
-	else if (IS_ERR(keyring)) {
+	} else if (IS_ERR(keyring)) {
 		ret = PTR_ERR(keyring);
 		goto error2;
 	}
 
 	/* we've got a keyring - now to install it */
-	ret = install_session_keyring(keyring);
+	ret = install_session_keyring_to_cred(new, keyring);
 	if (ret < 0)
 		goto error2;
 
+	commit_creds(new);
+	mutex_unlock(&key_session_mutex);
+
 	ret = keyring->serial;
 	key_put(keyring);
+okay:
+	return ret;
 
 error2:
 	mutex_unlock(&key_session_mutex);
 error:
+	abort_creds(new);
 	return ret;
-
-} /* end join_session_keyring() */
+}
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index fe5d4fb..18f5d0e 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -79,8 +79,10 @@ static int call_sbin_request_key(struct key_construction *cons,
 	/* allocate a new session keyring */
 	sprintf(desc, "_req.%u", key->serial);
 
-	keyring = keyring_alloc(desc, current_fsuid(), current_fsgid(), current,
+	cred = get_current_cred();
+	keyring = keyring_alloc(desc, cred->fsuid, cred->fsgid, cred,
 				KEY_ALLOC_QUOTA_OVERRUN, NULL);
+	put_cred(cred);
 	if (IS_ERR(keyring)) {
 		ret = PTR_ERR(keyring);
 		goto error_alloc;
@@ -100,8 +102,7 @@ static int call_sbin_request_key(struct key_construction *cons,
 
 	/* we specify the process's default keyrings */
 	sprintf(keyring_str[0], "%d",
-		cred->thread_keyring ?
-		cred->thread_keyring->serial : 0);
+		cred->thread_keyring ? cred->thread_keyring->serial : 0);
 
 	prkey = 0;
 	if (cred->tgcred->process_keyring)
@@ -151,8 +152,8 @@ error_link:
 	key_put(keyring);
 
 error_alloc:
-	kleave(" = %d", ret);
 	complete_request_key(cons, ret);
+	kleave(" = %d", ret);
 	return ret;
 }
 
@@ -291,6 +292,7 @@ static int construct_alloc_key(struct key_type *type,
 			       struct key_user *user,
 			       struct key **_key)
 {
+	const struct cred *cred = current_cred();
 	struct key *key;
 	key_ref_t key_ref;
 
@@ -298,9 +300,8 @@ static int construct_alloc_key(struct key_type *type,
 
 	mutex_lock(&user->cons_lock);
 
-	key = key_alloc(type, description,
-			current_fsuid(), current_fsgid(), current, KEY_POS_ALL,
-			flags);
+	key = key_alloc(type, description, cred->fsuid, cred->fsgid, cred,
+			KEY_POS_ALL, flags);
 	if (IS_ERR(key))
 		goto alloc_failed;
 
@@ -313,8 +314,7 @@ static int construct_alloc_key(struct key_type *type,
 	 * waited for locks */
 	mutex_lock(&key_construction_mutex);
 
-	key_ref = search_process_keyrings(type, description, type->match,
-					  current);
+	key_ref = search_process_keyrings(type, description, type->match, cred);
 	if (!IS_ERR(key_ref))
 		goto key_already_present;
 
@@ -359,6 +359,8 @@ static struct key *construct_key_and_link(struct key_type *type,
 	struct key *key;
 	int ret;
 
+	kenter("");
+
 	user = key_user_lookup(current_fsuid());
 	if (!user)
 		return ERR_PTR(-ENOMEM);
@@ -372,17 +374,21 @@ static struct key *construct_key_and_link(struct key_type *type,
 	if (ret == 0) {
 		ret = construct_key(key, callout_info, callout_len, aux,
 				    dest_keyring);
-		if (ret < 0)
+		if (ret < 0) {
+			kdebug("cons failed");
 			goto construction_failed;
+		}
 	}
 
 	key_put(dest_keyring);
+	kleave(" = key %d", key_serial(key));
 	return key;
 
 construction_failed:
 	key_negate_and_link(key, key_negative_timeout, NULL, NULL);
 	key_put(key);
 	key_put(dest_keyring);
+	kleave(" = %d", ret);
 	return ERR_PTR(ret);
 }
 
@@ -401,6 +407,7 @@ struct key *request_key_and_link(struct key_type *type,
 				 struct key *dest_keyring,
 				 unsigned long flags)
 {
+	const struct cred *cred = current_cred();
 	struct key *key;
 	key_ref_t key_ref;
 
@@ -410,7 +417,7 @@ struct key *request_key_and_link(struct key_type *type,
 
 	/* search all the process keyrings for a key */
 	key_ref = search_process_keyrings(type, description, type->match,
-					  current);
+					  cred);
 
 	if (!IS_ERR(key_ref)) {
 		key = key_ref_to_ptr(key_ref);
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index 2125579..8674715 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -105,9 +105,9 @@ static void request_key_auth_revoke(struct key *key)
 
 	kenter("{%d}", key->serial);
 
-	if (rka->context) {
-		put_task_struct(rka->context);
-		rka->context = NULL;
+	if (rka->cred) {
+		put_cred(rka->cred);
+		rka->cred = NULL;
 	}
 
 } /* end request_key_auth_revoke() */
@@ -122,9 +122,9 @@ static void request_key_auth_destroy(struct key *key)
 
 	kenter("{%d}", key->serial);
 
-	if (rka->context) {
-		put_task_struct(rka->context);
-		rka->context = NULL;
+	if (rka->cred) {
+		put_cred(rka->cred);
+		rka->cred = NULL;
 	}
 
 	key_put(rka->target_key);
@@ -143,6 +143,7 @@ struct key *request_key_auth_new(struct key *target, const void *callout_info,
 				 size_t callout_len, struct key *dest_keyring)
 {
 	struct request_key_auth *rka, *irka;
+	const struct cred *cred = current->cred;
 	struct key *authkey = NULL;
 	char desc[20];
 	int ret;
@@ -164,28 +165,25 @@ struct key *request_key_auth_new(struct key *target, const void *callout_info,
 
 	/* see if the calling process is already servicing the key request of
 	 * another process */
-	if (current->cred->request_key_auth) {
+	if (cred->request_key_auth) {
 		/* it is - use that instantiation context here too */
-		down_read(&current->cred->request_key_auth->sem);
+		down_read(&cred->request_key_auth->sem);
 
 		/* if the auth key has been revoked, then the key we're
 		 * servicing is already instantiated */
-		if (test_bit(KEY_FLAG_REVOKED,
-			     &current->cred->request_key_auth->flags))
+		if (test_bit(KEY_FLAG_REVOKED, &cred->request_key_auth->flags))
 			goto auth_key_revoked;
 
-		irka = current->cred->request_key_auth->payload.data;
-		rka->context = irka->context;
+		irka = cred->request_key_auth->payload.data;
+		rka->cred = get_cred(irka->cred);
 		rka->pid = irka->pid;
-		get_task_struct(rka->context);
 
-		up_read(&current->cred->request_key_auth->sem);
+		up_read(&cred->request_key_auth->sem);
 	}
 	else {
 		/* it isn't - use this process as the context */
-		rka->context = current;
+		rka->cred = get_cred(cred);
 		rka->pid = current->pid;
-		get_task_struct(rka->context);
 	}
 
 	rka->target_key = key_get(target);
@@ -197,7 +195,7 @@ struct key *request_key_auth_new(struct key *target, const void *callout_info,
 	sprintf(desc, "%x", target->serial);
 
 	authkey = key_alloc(&key_type_request_key_auth, desc,
-			    current_fsuid(), current_fsgid(), current,
+			    cred->fsuid, cred->fsgid, cred,
 			    KEY_POS_VIEW | KEY_POS_READ | KEY_POS_SEARCH |
 			    KEY_USR_VIEW, KEY_ALLOC_NOT_IN_QUOTA);
 	if (IS_ERR(authkey)) {
@@ -205,16 +203,16 @@ struct key *request_key_auth_new(struct key *target, const void *callout_info,
 		goto error_alloc;
 	}
 
-	/* construct and attach to the keyring */
+	/* construct the auth key */
 	ret = key_instantiate_and_link(authkey, rka, 0, NULL, NULL);
 	if (ret < 0)
 		goto error_inst;
 
-	kleave(" = {%d}", authkey->serial);
+	kleave(" = {%d,%d}", authkey->serial, atomic_read(&authkey->usage));
 	return authkey;
 
 auth_key_revoked:
-	up_read(&current->cred->request_key_auth->sem);
+	up_read(&cred->request_key_auth->sem);
 	kfree(rka->callout_info);
 	kfree(rka);
 	kleave("= -EKEYREVOKED");
@@ -257,6 +255,7 @@ static int key_get_instantiation_authkey_match(const struct key *key,
  */
 struct key *key_get_instantiation_authkey(key_serial_t target_id)
 {
+	const struct cred *cred = current_cred();
 	struct key *authkey;
 	key_ref_t authkey_ref;
 
@@ -264,7 +263,7 @@ struct key *key_get_instantiation_authkey(key_serial_t target_id)
 		&key_type_request_key_auth,
 		(void *) (unsigned long) target_id,
 		key_get_instantiation_authkey_match,
-		current);
+		cred);
 
 	if (IS_ERR(authkey_ref)) {
 		authkey = ERR_CAST(authkey_ref);
diff --git a/security/security.c b/security/security.c
index 1a96ec9..c60c334 100644
--- a/security/security.c
+++ b/security/security.c
@@ -145,18 +145,13 @@ int security_capget(struct task_struct *target,
 	return security_ops->capget(target, effective, inheritable, permitted);
 }
 
-int security_capset_check(const kernel_cap_t *effective,
-			  const kernel_cap_t *inheritable,
-			  const kernel_cap_t *permitted)
+int security_capset(struct cred *new, const struct cred *old,
+		    const kernel_cap_t *effective,
+		    const kernel_cap_t *inheritable,
+		    const kernel_cap_t *permitted)
 {
-	return security_ops->capset_check(effective, inheritable, permitted);
-}
-
-void security_capset_set(const kernel_cap_t *effective,
-			 const kernel_cap_t *inheritable,
-			 const kernel_cap_t *permitted)
-{
-	security_ops->capset_set(effective, inheritable, permitted);
+	return security_ops->capset(new, old,
+				    effective, inheritable, permitted);
 }
 
 int security_capable(struct task_struct *tsk, int cap)
@@ -214,9 +209,9 @@ void security_bprm_free(struct linux_binprm *bprm)
 	security_ops->bprm_free_security(bprm);
 }
 
-void security_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
+int security_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
 {
-	security_ops->bprm_apply_creds(bprm, unsafe);
+	return security_ops->bprm_apply_creds(bprm, unsafe);
 }
 
 void security_bprm_post_apply_creds(struct linux_binprm *bprm)
@@ -602,14 +597,19 @@ int security_task_create(unsigned long clone_flags)
 	return security_ops->task_create(clone_flags);
 }
 
-int security_cred_alloc(struct cred *cred)
+void security_cred_free(struct cred *cred)
 {
-	return security_ops->cred_alloc_security(cred);
+	security_ops->cred_free(cred);
 }
 
-void security_cred_free(struct cred *cred)
+int security_prepare_creds(struct cred *new, const struct cred *old, gfp_t gfp)
 {
-	security_ops->cred_free(cred);
+	return security_ops->cred_prepare(new, old, gfp);
+}
+
+void security_commit_creds(struct cred *new, const struct cred *old)
+{
+	return security_ops->cred_commit(new, old);
 }
 
 int security_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags)
@@ -617,10 +617,10 @@ int security_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags)
 	return security_ops->task_setuid(id0, id1, id2, flags);
 }
 
-int security_task_post_setuid(uid_t old_ruid, uid_t old_euid,
-			       uid_t old_suid, int flags)
+int security_task_fix_setuid(struct cred *new, const struct cred *old,
+			     int flags)
 {
-	return security_ops->task_post_setuid(old_ruid, old_euid, old_suid, flags);
+	return security_ops->task_fix_setuid(new, old, flags);
 }
 
 int security_task_setgid(gid_t id0, gid_t id1, gid_t id2, int flags)
@@ -702,14 +702,9 @@ int security_task_wait(struct task_struct *p)
 }
 
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
-			 unsigned long arg4, unsigned long arg5, long *rc_p)
-{
-	return security_ops->task_prctl(option, arg2, arg3, arg4, arg5, rc_p);
-}
-
-void security_task_reparent_to_init(struct task_struct *p)
+			 unsigned long arg4, unsigned long arg5)
 {
-	security_ops->task_reparent_to_init(p);
+	return security_ops->task_prctl(option, arg2, arg3, arg4, arg5);
 }
 
 void security_task_to_inode(struct task_struct *p, struct inode *inode)
@@ -1109,9 +1104,10 @@ EXPORT_SYMBOL(security_skb_classify_flow);
 
 #ifdef CONFIG_KEYS
 
-int security_key_alloc(struct key *key, struct task_struct *tsk, unsigned long flags)
+int security_key_alloc(struct key *key, const struct cred *cred,
+		       unsigned long flags)
 {
-	return security_ops->key_alloc(key, tsk, flags);
+	return security_ops->key_alloc(key, cred, flags);
 }
 
 void security_key_free(struct key *key)
@@ -1120,9 +1116,9 @@ void security_key_free(struct key *key)
 }
 
 int security_key_permission(key_ref_t key_ref,
-			    struct task_struct *context, key_perm_t perm)
+			    const struct cred *cred, key_perm_t perm)
 {
-	return security_ops->key_permission(key_ref, context, perm);
+	return security_ops->key_permission(key_ref, cred, perm);
 }
 
 int security_key_getsecurity(struct key *key, char **_buffer)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index d0e399d..27441e7 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -155,20 +155,20 @@ static int selinux_secmark_enabled(void)
 	return (atomic_read(&selinux_secmark_refcount) > 0);
 }
 
-/* Allocate and free functions for each kind of security blob. */
-
-static int cred_alloc_security(struct cred *cred)
+/*
+ * initialise the security for the init task
+ */
+static void cred_init_security(void)
 {
+	struct cred *cred = (struct cred *) current->cred;
 	struct task_security_struct *tsec;
 
 	tsec = kzalloc(sizeof(struct task_security_struct), GFP_KERNEL);
 	if (!tsec)
-		return -ENOMEM;
+		panic("SELinux:  Failed to initialize initial task.\n");
 
-	tsec->osid = tsec->sid = SECINITSID_UNLABELED;
+	tsec->osid = tsec->sid = SECINITSID_KERNEL;
 	cred->security = tsec;
-
-	return 0;
 }
 
 /*
@@ -1377,6 +1377,19 @@ static inline u32 signal_to_av(int sig)
 }
 
 /*
+ * Check permission between a pair of credentials
+ * fork check, ptrace check, etc.
+ */
+static int cred_has_perm(const struct cred *actor,
+			 const struct cred *target,
+			 u32 perms)
+{
+	u32 asid = cred_sid(actor), tsid = cred_sid(target);
+
+	return avc_has_perm(asid, tsid, SECCLASS_PROCESS, perms, NULL);
+}
+
+/*
  * Check permission between a pair of tasks, e.g. signal checks,
  * fork check, ptrace check, etc.
  * tsk1 is the actor and tsk2 is the target
@@ -1811,24 +1824,19 @@ static int selinux_capget(struct task_struct *target, kernel_cap_t *effective,
 	return secondary_ops->capget(target, effective, inheritable, permitted);
 }
 
-static int selinux_capset_check(const kernel_cap_t *effective,
-				const kernel_cap_t *inheritable,
-				const kernel_cap_t *permitted)
+static int selinux_capset(struct cred *new, const struct cred *old,
+			  const kernel_cap_t *effective,
+			  const kernel_cap_t *inheritable,
+			  const kernel_cap_t *permitted)
 {
 	int error;
 
-	error = secondary_ops->capset_check(effective, inheritable, permitted);
+	error = secondary_ops->capset(new, old,
+				      effective, inheritable, permitted);
 	if (error)
 		return error;
 
-	return task_has_perm(current, current, PROCESS__SETCAP);
-}
-
-static void selinux_capset_set(const kernel_cap_t *effective,
-			       const kernel_cap_t *inheritable,
-			       const kernel_cap_t *permitted)
-{
-	secondary_ops->capset_set(effective, inheritable, permitted);
+	return cred_has_perm(old, new, PROCESS__SETCAP);
 }
 
 static int selinux_capable(struct task_struct *tsk, int cap)
@@ -2242,16 +2250,23 @@ static inline void flush_unauthorized_files(const struct cred *cred,
 	spin_unlock(&files->file_lock);
 }
 
-static void selinux_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
+static int selinux_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
 {
 	struct task_security_struct *tsec;
 	struct bprm_security_struct *bsec;
+	struct cred *new;
 	u32 sid;
 	int rc;
 
-	secondary_ops->bprm_apply_creds(bprm, unsafe);
+	rc = secondary_ops->bprm_apply_creds(bprm, unsafe);
+	if (rc < 0)
+		return rc;
 
-	tsec = current_security();
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
+	tsec = new->security;
 
 	bsec = bprm->security;
 	sid = bsec->sid;
@@ -2266,7 +2281,7 @@ static void selinux_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
 					PROCESS__SHARE, NULL);
 			if (rc) {
 				bsec->unsafe = 1;
-				return;
+				goto out;
 			}
 		}
 
@@ -2290,12 +2305,16 @@ static void selinux_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
 						  PROCESS__PTRACE, NULL);
 				if (rc) {
 					bsec->unsafe = 1;
-					return;
+					goto out;
 				}
 			}
 		}
 		tsec->sid = sid;
 	}
+
+out:
+	commit_creds(new);
+	return 0;
 }
 
 /*
@@ -2704,7 +2723,7 @@ static int selinux_inode_permission(struct inode *inode, int mask)
 	}
 
 	return inode_has_perm(cred, inode,
-			       open_file_mask_to_av(inode->i_mode, mask), NULL);
+			      open_file_mask_to_av(inode->i_mode, mask), NULL);
 }
 
 static int selinux_inode_setattr(struct dentry *dentry, struct iattr *iattr)
@@ -3025,6 +3044,7 @@ static int selinux_file_ioctl(struct file *file, unsigned int cmd,
 static int file_map_prot_check(struct file *file, unsigned long prot, int shared)
 {
 	const struct cred *cred = current_cred();
+	int rc = 0;
 
 #ifndef CONFIG_PPC32
 	if ((prot & PROT_EXEC) && (!file || (!shared && (prot & PROT_WRITE)))) {
@@ -3033,9 +3053,9 @@ static int file_map_prot_check(struct file *file, unsigned long prot, int shared
 		 * private file mapping that will also be writable.
 		 * This has an additional check.
 		 */
-		int rc = task_has_perm(current, current, PROCESS__EXECMEM);
+		rc = cred_has_perm(cred, cred, PROCESS__EXECMEM);
 		if (rc)
-			return rc;
+			goto error;
 	}
 #endif
 
@@ -3052,7 +3072,9 @@ static int file_map_prot_check(struct file *file, unsigned long prot, int shared
 
 		return file_has_perm(cred, file, av);
 	}
-	return 0;
+
+error:
+	return rc;
 }
 
 static int selinux_file_mmap(struct file *file, unsigned long reqprot,
@@ -3094,8 +3116,7 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 		rc = 0;
 		if (vma->vm_start >= vma->vm_mm->start_brk &&
 		    vma->vm_end <= vma->vm_mm->brk) {
-			rc = task_has_perm(current, current,
-					   PROCESS__EXECHEAP);
+			rc = cred_has_perm(cred, cred, PROCESS__EXECHEAP);
 		} else if (!vma->vm_file &&
 			   vma->vm_start <= vma->vm_mm->start_stack &&
 			   vma->vm_end >= vma->vm_mm->start_stack) {
@@ -3108,8 +3129,7 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 			 * modified content.  This typically should only
 			 * occur for text relocations.
 			 */
-			rc = file_has_perm(cred, vma->vm_file,
-					   FILE__EXECMOD);
+			rc = file_has_perm(cred, vma->vm_file, FILE__EXECMOD);
 		}
 		if (rc)
 			return rc;
@@ -3215,6 +3235,7 @@ static int selinux_dentry_open(struct file *file, const struct cred *cred)
 	struct file_security_struct *fsec;
 	struct inode *inode;
 	struct inode_security_struct *isec;
+
 	inode = file->f_path.dentry->d_inode;
 	fsec = file->f_security;
 	isec = inode->i_security;
@@ -3251,38 +3272,41 @@ static int selinux_task_create(unsigned long clone_flags)
 	return task_has_perm(current, current, PROCESS__FORK);
 }
 
-static int selinux_cred_alloc_security(struct cred *cred)
+/*
+ * detach and free the LSM part of a set of credentials
+ */
+static void selinux_cred_free(struct cred *cred)
 {
-	struct task_security_struct *tsec1, *tsec2;
-	int rc;
-
-	tsec1 = current_security();
+	struct task_security_struct *tsec = cred->security;
+	cred->security = NULL;
+	kfree(tsec);
+}
 
-	rc = cred_alloc_security(cred);
-	if (rc)
-		return rc;
-	tsec2 = cred->security;
+/*
+ * prepare a new set of credentials for modification
+ */
+static int selinux_cred_prepare(struct cred *new, const struct cred *old,
+				gfp_t gfp)
+{
+	const struct task_security_struct *old_tsec;
+	struct task_security_struct *tsec;
 
-	tsec2->osid = tsec1->osid;
-	tsec2->sid = tsec1->sid;
+	old_tsec = old->security;
 
-	/* Retain the exec, fs, key, and sock SIDs across fork */
-	tsec2->exec_sid = tsec1->exec_sid;
-	tsec2->create_sid = tsec1->create_sid;
-	tsec2->keycreate_sid = tsec1->keycreate_sid;
-	tsec2->sockcreate_sid = tsec1->sockcreate_sid;
+	tsec = kmemdup(old_tsec, sizeof(struct task_security_struct), gfp);
+	if (!tsec)
+		return -ENOMEM;
 
+	new->security = tsec;
 	return 0;
 }
 
 /*
- * detach and free the LSM part of a set of credentials
+ * commit new credentials
  */
-static void selinux_cred_free(struct cred *cred)
+static void selinux_cred_commit(struct cred *new, const struct cred *old)
 {
-	struct task_security_struct *tsec = cred->security;
-	cred->security = NULL;
-	kfree(tsec);
+	secondary_ops->cred_commit(new, old);
 }
 
 static int selinux_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags)
@@ -3296,9 +3320,10 @@ static int selinux_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags)
 	return 0;
 }
 
-static int selinux_task_post_setuid(uid_t id0, uid_t id1, uid_t id2, int flags)
+static int selinux_task_fix_setuid(struct cred *new, const struct cred *old,
+				   int flags)
 {
-	return secondary_ops->task_post_setuid(id0, id1, id2, flags);
+	return secondary_ops->task_fix_setuid(new, old, flags);
 }
 
 static int selinux_task_setgid(gid_t id0, gid_t id1, gid_t id2, int flags)
@@ -3372,7 +3397,7 @@ static int selinux_task_setrlimit(unsigned int resource, struct rlimit *new_rlim
 	/* Control the ability to change the hard limit (whether
 	   lowering or raising it), so that the hard limit can
 	   later be used as a safe reset point for the soft limit
-	   upon context transitions. See selinux_bprm_apply_creds. */
+	   upon context transitions.  See selinux_bprm_committing_creds. */
 	if (old_rlim->rlim_max != new_rlim->rlim_max)
 		return task_has_perm(current, current, PROCESS__SETRLIMIT);
 
@@ -3426,13 +3451,12 @@ static int selinux_task_prctl(int option,
 			      unsigned long arg2,
 			      unsigned long arg3,
 			      unsigned long arg4,
-			      unsigned long arg5,
-			      long *rc_p)
+			      unsigned long arg5)
 {
 	/* The current prctl operations do not appear to require
 	   any SELinux controls since they merely observe or modify
 	   the state of the current process. */
-	return secondary_ops->task_prctl(option, arg2, arg3, arg4, arg5, rc_p);
+	return secondary_ops->task_prctl(option, arg2, arg3, arg4, arg5);
 }
 
 static int selinux_task_wait(struct task_struct *p)
@@ -3440,18 +3464,6 @@ static int selinux_task_wait(struct task_struct *p)
 	return task_has_perm(p, current, PROCESS__SIGCHLD);
 }
 
-static void selinux_task_reparent_to_init(struct task_struct *p)
-{
-	struct task_security_struct *tsec;
-
-	secondary_ops->task_reparent_to_init(p);
-
-	tsec = p->cred->security;
-	tsec->osid = tsec->sid;
-	tsec->sid = SECINITSID_KERNEL;
-	return;
-}
-
 static void selinux_task_to_inode(struct task_struct *p,
 				  struct inode *inode)
 {
@@ -5228,7 +5240,8 @@ static int selinux_setprocattr(struct task_struct *p,
 {
 	struct task_security_struct *tsec;
 	struct task_struct *tracer;
-	u32 sid = 0;
+	struct cred *new;
+	u32 sid = 0, ptsid;
 	int error;
 	char *str = value;
 
@@ -5275,77 +5288,72 @@ static int selinux_setprocattr(struct task_struct *p,
 			return error;
 	}
 
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
 	/* Permission checking based on the specified context is
 	   performed during the actual operation (execve,
 	   open/mkdir/...), when we know the full context of the
-	   operation.  See selinux_bprm_set_security for the execve
+	   operation.  See selinux_bprm_set_creds for the execve
 	   checks and may_create for the file creation checks. The
 	   operation will then fail if the context is not permitted. */
-	tsec = p->cred->security;
-	if (!strcmp(name, "exec"))
+	tsec = new->security;
+	if (!strcmp(name, "exec")) {
 		tsec->exec_sid = sid;
-	else if (!strcmp(name, "fscreate"))
+	} else if (!strcmp(name, "fscreate")) {
 		tsec->create_sid = sid;
-	else if (!strcmp(name, "keycreate")) {
+	} else if (!strcmp(name, "keycreate")) {
 		error = may_create_key(sid, p);
 		if (error)
-			return error;
+			goto abort_change;
 		tsec->keycreate_sid = sid;
-	} else if (!strcmp(name, "sockcreate"))
+	} else if (!strcmp(name, "sockcreate")) {
 		tsec->sockcreate_sid = sid;
-	else if (!strcmp(name, "current")) {
-		struct av_decision avd;
-
+	} else if (!strcmp(name, "current")) {
+		error = -EINVAL;
 		if (sid == 0)
-			return -EINVAL;
+			goto abort_change;
 
 		/* Only allow single threaded processes to change context */
-		if (atomic_read(&p->mm->mm_users) != 1) {
-			struct task_struct *g, *t;
-			struct mm_struct *mm = p->mm;
-			read_lock(&tasklist_lock);
-			do_each_thread(g, t) {
-				if (t->mm == mm && t != p) {
-					read_unlock(&tasklist_lock);
-					return -EPERM;
-				}
-			} while_each_thread(g, t);
-			read_unlock(&tasklist_lock);
-		}
+		error = -EPERM;
+		if (!is_single_threaded(p))
+			goto abort_change;
 
 		/* Check permissions for the transition. */
 		error = avc_has_perm(tsec->sid, sid, SECCLASS_PROCESS,
 				     PROCESS__DYNTRANSITION, NULL);
 		if (error)
-			return error;
+			goto abort_change;
 
 		/* Check for ptracing, and update the task SID if ok.
 		   Otherwise, leave SID unchanged and fail. */
+		ptsid = 0;
 		task_lock(p);
-		rcu_read_lock();
 		tracer = tracehook_tracer_task(p);
-		if (tracer != NULL) {
-			u32 ptsid = task_sid(tracer);
-			rcu_read_unlock();
-			error = avc_has_perm_noaudit(ptsid, sid,
-						     SECCLASS_PROCESS,
-						     PROCESS__PTRACE, 0, &avd);
-			if (!error)
-				tsec->sid = sid;
-			task_unlock(p);
-			avc_audit(ptsid, sid, SECCLASS_PROCESS,
-				  PROCESS__PTRACE, &avd, error, NULL);
+		if (tracer)
+			ptsid = task_sid(tracer);
+		task_unlock(p);
+
+		if (tracer) {
+			error = avc_has_perm(ptsid, sid, SECCLASS_PROCESS,
+					     PROCESS__PTRACE, NULL);
 			if (error)
-				return error;
-		} else {
-			rcu_read_unlock();
-			tsec->sid = sid;
-			task_unlock(p);
+				goto abort_change;
 		}
-	} else
-		return -EINVAL;
 
+		tsec->sid = sid;
+	} else {
+		error = -EINVAL;
+		goto abort_change;
+	}
+
+	commit_creds(new);
 	return size;
+
+abort_change:
+	abort_creds(new);
+	return error;
 }
 
 static int selinux_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
@@ -5365,23 +5373,21 @@ static void selinux_release_secctx(char *secdata, u32 seclen)
 
 #ifdef CONFIG_KEYS
 
-static int selinux_key_alloc(struct key *k, struct task_struct *tsk,
+static int selinux_key_alloc(struct key *k, const struct cred *cred,
 			     unsigned long flags)
 {
-	const struct task_security_struct *__tsec;
+	const struct task_security_struct *tsec;
 	struct key_security_struct *ksec;
 
 	ksec = kzalloc(sizeof(struct key_security_struct), GFP_KERNEL);
 	if (!ksec)
 		return -ENOMEM;
 
-	rcu_read_lock();
-	__tsec = __task_cred(tsk)->security;
-	if (__tsec->keycreate_sid)
-		ksec->sid = __tsec->keycreate_sid;
+	tsec = cred->security;
+	if (tsec->keycreate_sid)
+		ksec->sid = tsec->keycreate_sid;
 	else
-		ksec->sid = __tsec->sid;
-	rcu_read_unlock();
+		ksec->sid = tsec->sid;
 
 	k->security = ksec;
 	return 0;
@@ -5396,8 +5402,8 @@ static void selinux_key_free(struct key *k)
 }
 
 static int selinux_key_permission(key_ref_t key_ref,
-			    struct task_struct *ctx,
-			    key_perm_t perm)
+				  const struct cred *cred,
+				  key_perm_t perm)
 {
 	struct key *key;
 	struct key_security_struct *ksec;
@@ -5409,7 +5415,7 @@ static int selinux_key_permission(key_ref_t key_ref,
 	if (perm == 0)
 		return 0;
 
-	sid = task_sid(ctx);
+	sid = cred_sid(cred);
 
 	key = key_ref_to_ptr(key_ref);
 	ksec = key->security;
@@ -5439,8 +5445,7 @@ static struct security_operations selinux_ops = {
 	.ptrace_may_access =		selinux_ptrace_may_access,
 	.ptrace_traceme =		selinux_ptrace_traceme,
 	.capget =			selinux_capget,
-	.capset_check =			selinux_capset_check,
-	.capset_set =			selinux_capset_set,
+	.capset =			selinux_capset,
 	.sysctl =			selinux_sysctl,
 	.capable =			selinux_capable,
 	.quotactl =			selinux_quotactl,
@@ -5515,10 +5520,11 @@ static struct security_operations selinux_ops = {
 	.dentry_open =			selinux_dentry_open,
 
 	.task_create =			selinux_task_create,
-	.cred_alloc_security =		selinux_cred_alloc_security,
 	.cred_free =			selinux_cred_free,
+	.cred_prepare =			selinux_cred_prepare,
+	.cred_commit =			selinux_cred_commit,
 	.task_setuid =			selinux_task_setuid,
-	.task_post_setuid =		selinux_task_post_setuid,
+	.task_fix_setuid =		selinux_task_fix_setuid,
 	.task_setgid =			selinux_task_setgid,
 	.task_setpgid =			selinux_task_setpgid,
 	.task_getpgid =			selinux_task_getpgid,
@@ -5535,7 +5541,6 @@ static struct security_operations selinux_ops = {
 	.task_kill =			selinux_task_kill,
 	.task_wait =			selinux_task_wait,
 	.task_prctl =			selinux_task_prctl,
-	.task_reparent_to_init =	selinux_task_reparent_to_init,
 	.task_to_inode =		selinux_task_to_inode,
 
 	.ipc_permission =		selinux_ipc_permission,
@@ -5631,8 +5636,6 @@ static struct security_operations selinux_ops = {
 
 static __init int selinux_init(void)
 {
-	struct task_security_struct *tsec;
-
 	if (!security_module_enable(&selinux_ops)) {
 		selinux_enabled = 0;
 		return 0;
@@ -5646,10 +5649,7 @@ static __init int selinux_init(void)
 	printk(KERN_INFO "SELinux:  Initializing.\n");
 
 	/* Set the security state for the initial task. */
-	if (cred_alloc_security(current->cred))
-		panic("SELinux:  Failed to initialize initial task.\n");
-	tsec = current->cred->security;
-	tsec->osid = tsec->sid = SECINITSID_KERNEL;
+	cred_init_security();
 
 	sel_inode_cache = kmem_cache_create("selinux_inode_security",
 					    sizeof(struct inode_security_struct),
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 3e3dcbf..22e5271 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -104,8 +104,7 @@ static int smack_ptrace_may_access(struct task_struct *ctp, unsigned int mode)
 	if (rc != 0)
 		return rc;
 
-	rc = smk_access(current->cred->security, ctp->cred->security,
-			MAY_READWRITE);
+	rc = smk_access(current_security(), task_security(ctp), MAY_READWRITE);
 	if (rc != 0 && capable(CAP_MAC_OVERRIDE))
 		return 0;
 	return rc;
@@ -127,8 +126,7 @@ static int smack_ptrace_traceme(struct task_struct *ptp)
 	if (rc != 0)
 		return rc;
 
-	rc = smk_access(ptp->cred->security, current->cred->security,
-			MAY_READWRITE);
+	rc = smk_access(task_security(ptp), current_security(), MAY_READWRITE);
 	if (rc != 0 && has_capability(ptp, CAP_MAC_OVERRIDE))
 		return 0;
 	return rc;
@@ -977,22 +975,6 @@ static int smack_file_receive(struct file *file)
  */
 
 /**
- * smack_cred_alloc_security - "allocate" a task cred blob
- * @cred: the task creds in need of a blob
- *
- * Smack isn't using copies of blobs. Everyone
- * points to an immutable list. No alloc required.
- * No data copy required.
- *
- * Always returns 0
- */
-static int smack_cred_alloc_security(struct cred *cred)
-{
-	cred->security = current_security();
-	return 0;
-}
-
-/**
  * smack_cred_free - "free" task-level security credentials
  * @cred: the credentials in question
  *
@@ -1006,6 +988,30 @@ static void smack_cred_free(struct cred *cred)
 }
 
 /**
+ * smack_cred_prepare - prepare new set of credentials for modification
+ * @new: the new credentials
+ * @old: the original credentials
+ * @gfp: the atomicity of any memory allocations
+ *
+ * Prepare a new set of credentials for modification.
+ */
+static int smack_cred_prepare(struct cred *new, const struct cred *old,
+			      gfp_t gfp)
+{
+	new->security = old->security;
+	return 0;
+}
+
+/*
+ * commit new credentials
+ * @new: the new credentials
+ * @old: the original credentials
+ */
+static void smack_cred_commit(struct cred *new, const struct cred *old)
+{
+}
+
+/**
  * smack_task_setpgid - Smack check on setting pgid
  * @p: the task object
  * @pgid: unused
@@ -2036,6 +2042,7 @@ static int smack_getprocattr(struct task_struct *p, char *name, char **value)
 static int smack_setprocattr(struct task_struct *p, char *name,
 			     void *value, size_t size)
 {
+	struct cred *new;
 	char *newsmack;
 
 	/*
@@ -2058,7 +2065,11 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 	if (newsmack == NULL)
 		return -EINVAL;
 
-	p->cred->security = newsmack;
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+	new->security = newsmack;
+	commit_creds(new);
 	return size;
 }
 
@@ -2351,17 +2362,17 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 /**
  * smack_key_alloc - Set the key security blob
  * @key: object
- * @tsk: the task associated with the key
+ * @cred: the credentials to use
  * @flags: unused
  *
  * No allocation required
  *
  * Returns 0
  */
-static int smack_key_alloc(struct key *key, struct task_struct *tsk,
+static int smack_key_alloc(struct key *key, const struct cred *cred,
 			   unsigned long flags)
 {
-	key->security = tsk->cred->security;
+	key->security = cred->security;
 	return 0;
 }
 
@@ -2379,14 +2390,14 @@ static void smack_key_free(struct key *key)
 /*
  * smack_key_permission - Smack access on a key
  * @key_ref: gets to the object
- * @context: task involved
+ * @cred: the credentials to use
  * @perm: unused
  *
  * Return 0 if the task has read and write to the object,
  * an error code otherwise
  */
 static int smack_key_permission(key_ref_t key_ref,
-				struct task_struct *context, key_perm_t perm)
+				const struct cred *cred, key_perm_t perm)
 {
 	struct key *keyp;
 
@@ -2402,11 +2413,10 @@ static int smack_key_permission(key_ref_t key_ref,
 	/*
 	 * This should not occur
 	 */
-	if (context->cred->security == NULL)
+	if (cred->security == NULL)
 		return -EACCES;
 
-	return smk_access(context->cred->security, keyp->security,
-			  MAY_READWRITE);
+	return smk_access(cred->security, keyp->security, MAY_READWRITE);
 }
 #endif /* CONFIG_KEYS */
 
@@ -2577,8 +2587,7 @@ struct security_operations smack_ops = {
 	.ptrace_may_access =		smack_ptrace_may_access,
 	.ptrace_traceme =		smack_ptrace_traceme,
 	.capget = 			cap_capget,
-	.capset_check = 		cap_capset_check,
-	.capset_set = 			cap_capset_set,
+	.capset = 			cap_capset,
 	.capable = 			cap_capable,
 	.syslog = 			smack_syslog,
 	.settime = 			cap_settime,
@@ -2627,9 +2636,10 @@ struct security_operations smack_ops = {
 	.file_send_sigiotask = 		smack_file_send_sigiotask,
 	.file_receive = 		smack_file_receive,
 
-	.cred_alloc_security = 		smack_cred_alloc_security,
 	.cred_free =			smack_cred_free,
-	.task_post_setuid =		cap_task_post_setuid,
+	.cred_prepare =			smack_cred_prepare,
+	.cred_commit =			smack_cred_commit,
+	.task_fix_setuid =		cap_task_fix_setuid,
 	.task_setpgid = 		smack_task_setpgid,
 	.task_getpgid = 		smack_task_getpgid,
 	.task_getsid = 			smack_task_getsid,
@@ -2642,7 +2652,6 @@ struct security_operations smack_ops = {
 	.task_movememory = 		smack_task_movememory,
 	.task_kill = 			smack_task_kill,
 	.task_wait = 			smack_task_wait,
-	.task_reparent_to_init =	cap_task_reparent_to_init,
 	.task_to_inode = 		smack_task_to_inode,
 	.task_prctl =			cap_task_prctl,
 
@@ -2718,6 +2727,8 @@ struct security_operations smack_ops = {
  */
 static __init int smack_init(void)
 {
+	struct cred *cred;
+
 	if (!security_module_enable(&smack_ops))
 		return 0;
 
@@ -2726,7 +2737,8 @@ static __init int smack_init(void)
 	/*
 	 * Set the security state for the initial task.
 	 */
-	current->cred->security = &smack_known_floor.smk_known;
+	cred = (struct cred *) current->cred;
+	cred->security = &smack_known_floor.smk_known;
 
 	/*
 	 * Initialize locks

