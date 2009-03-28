Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbZC1XV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbZC1XV7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 19:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbZC1XVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 19:21:48 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:35561 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbZC1XVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 19:21:47 -0400
Date: Sat, 28 Mar 2009 23:20:19 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Al Viro <viro@zeniv.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] fix setuid sometimes doesn't
In-Reply-To: <Pine.LNX.4.64.0903282307050.14892@blonde.anvils>
Message-ID: <Pine.LNX.4.64.0903282319270.15432@blonde.anvils>
References: <Pine.LNX.4.64.0903282307050.14892@blonde.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Malicki reports that setuid sometimes doesn't: very rarely,
a setuid root program does not get root euid; and, by the way,
they have a health check running lsof every few minutes.

Right, check_unsafe_exec() notes whether the files_struct is being
shared by more threads than will get killed by the exec, and if so
sets LSM_UNSAFE_SHARE to make bprm_set_creds() careful about euid.
But /proc/<pid>/fd and /proc/<pid>/fdinfo lookups make transient
use of get_files_struct(), which also raises that sharing count.

There's a rather simple fix for this: exec's check on files->count
has been redundant ever since 2.6.1 made it unshare_files() (except
while compat_do_execve() omitted to do so) - just remove that check.

[Note to -stable: this patch will not apply before 2.6.29: earlier
releases should just remove the files->count line from unsafe_exec().]

Reported-by: Joe Malicki <jmalicki@metacarta.com>
Narrowed-down-by: Michael Itz <mitz@metacarta.com>
Tested-by: Joe Malicki <jmalicki@metacarta.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: stable@kernel.org
---

 fs/compat.c   |    2 +-
 fs/exec.c     |   10 +++-------
 fs/internal.h |    2 +-
 3 files changed, 5 insertions(+), 9 deletions(-)

--- 2.6.29/fs/compat.c	2009-03-23 23:12:14.000000000 +0000
+++ linux/fs/compat.c	2009-03-28 18:06:02.000000000 +0000
@@ -1412,7 +1412,7 @@ int compat_do_execve(char * filename,
 	bprm->cred = prepare_exec_creds();
 	if (!bprm->cred)
 		goto out_unlock;
-	check_unsafe_exec(bprm, current->files);
+	check_unsafe_exec(bprm);
 
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
--- 2.6.29/fs/exec.c	2009-03-23 23:12:14.000000000 +0000
+++ linux/fs/exec.c	2009-03-28 18:06:02.000000000 +0000
@@ -1049,28 +1049,24 @@ EXPORT_SYMBOL(install_exec_creds);
  * - the caller must hold current->cred_exec_mutex to protect against
  *   PTRACE_ATTACH
  */
-void check_unsafe_exec(struct linux_binprm *bprm, struct files_struct *files)
+void check_unsafe_exec(struct linux_binprm *bprm)
 {
 	struct task_struct *p = current, *t;
 	unsigned long flags;
-	unsigned n_fs, n_files, n_sighand;
+	unsigned n_fs, n_sighand;
 
 	bprm->unsafe = tracehook_unsafe_exec(p);
 
 	n_fs = 1;
-	n_files = 1;
 	n_sighand = 1;
 	lock_task_sighand(p, &flags);
 	for (t = next_thread(p); t != p; t = next_thread(t)) {
 		if (t->fs == p->fs)
 			n_fs++;
-		if (t->files == files)
-			n_files++;
 		n_sighand++;
 	}
 
 	if (atomic_read(&p->fs->count) > n_fs ||
-	    atomic_read(&p->files->count) > n_files ||
 	    atomic_read(&p->sighand->count) > n_sighand)
 		bprm->unsafe |= LSM_UNSAFE_SHARE;
 
@@ -1289,7 +1285,7 @@ int do_execve(char * filename,
 	bprm->cred = prepare_exec_creds();
 	if (!bprm->cred)
 		goto out_unlock;
-	check_unsafe_exec(bprm, displaced);
+	check_unsafe_exec(bprm);
 
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
--- 2.6.29/fs/internal.h	2009-03-23 23:12:14.000000000 +0000
+++ linux/fs/internal.h	2009-03-28 18:06:02.000000000 +0000
@@ -43,7 +43,7 @@ extern void __init chrdev_init(void);
 /*
  * exec.c
  */
-extern void check_unsafe_exec(struct linux_binprm *, struct files_struct *);
+extern void check_unsafe_exec(struct linux_binprm *);
 
 /*
  * namespace.c
