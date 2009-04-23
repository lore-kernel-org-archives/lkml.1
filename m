Return-Path: <linux-kernel-owner+w=401wt.eu-S1760494AbZDWXI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760494AbZDWXI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 19:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756281AbZDWXIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 19:08:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50424 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbZDWXIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 19:08:15 -0400
Date: Fri, 24 Apr 2009 01:01:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: [PATCH 1/2] do_execve() must not clear fs->in_exec if it was set
	by another thread
Message-ID: <20090423230156.GA31302@redhat.com>
References: <Pine.LNX.4.64.0904010106310.16500@blonde.anvils> <20090401023849.GW28946@ZenIV.linux.org.uk> <20090401030339.GX28946@ZenIV.linux.org.uk> <20090406153127.GA21220@redhat.com> <Pine.LNX.4.64.0904191710320.9099@blonde.anvils> <20090421161006.GC5402@redhat.com> <alpine.LFD.2.00.0904210924270.2199@localhost.localdomain> <20090421171530.GA12014@redhat.com> <alpine.LFD.2.00.0904211032191.2199@localhost.localdomain> <Pine.LNX.4.64.0904212031120.10256@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904212031120.10256@blonde.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If do_execve() fails after check_unsafe_exec(), it clears fs->in_exec
unconditionally. This is wrong if we race with our sub-thread which
also does do_execve:

	Two threads T1 and T2 and another process P, all share the same
	->fs.

	T1 starts do_execve(BAD_FILE). It calls check_unsafe_exec(), since
	->fs is shared, we set LSM_UNSAFE but not ->in_exec.

	P exits and decrements fs->users.

	T2 starts do_execve(), calls check_unsafe_exec(), now ->fs is not
	shared, we set fs->in_exec.

	T1 continues, open_exec(BAD_FILE) fails, we clear ->in_exec and
	return to the user-space.

	T1 does clone(CLONE_FS /* without CLONE_THREAD */).

	T2 continues without LSM_UNSAFE_SHARE while ->fs is shared with
	another process.

Change check_unsafe_exec() to return res = 1 if we set ->in_exec, and change
do_execve() to clear ->in_exec depending on res.

When do_execve() suceeds, it is safe to clear ->in_exec unconditionally.
It can be set only if we don't share ->fs with another process, and since
we already killed all sub-threads either ->in_exec == 0 or we are the
only user of this ->fs.

Also, we do not need fs->lock to clear fs->in_exec.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

 fs/exec.c   |   19 ++++++++++---------
 fs/compat.c |   11 +++++------
 2 files changed, 15 insertions(+), 15 deletions(-)

--- PTRACE/fs/exec.c~1_IN_EXEC	2009-04-06 00:03:41.000000000 +0200
+++ PTRACE/fs/exec.c	2009-04-24 00:01:53.000000000 +0200
@@ -1077,9 +1077,11 @@ int check_unsafe_exec(struct linux_binpr
 	if (p->fs->users > n_fs) {
 		bprm->unsafe |= LSM_UNSAFE_SHARE;
 	} else {
-		if (p->fs->in_exec)
-			res = -EAGAIN;
-		p->fs->in_exec = 1;
+		res = -EAGAIN;
+		if (!p->fs->in_exec) {
+			p->fs->in_exec = 1;
+			res = 1;
+		}
 	}
 
 	unlock_task_sighand(p, &flags);
@@ -1284,6 +1286,7 @@ int do_execve(char * filename,
 	struct linux_binprm *bprm;
 	struct file *file;
 	struct files_struct *displaced;
+	bool clear_in_exec;
 	int retval;
 
 	retval = unshare_files(&displaced);
@@ -1306,8 +1309,9 @@ int do_execve(char * filename,
 		goto out_unlock;
 
 	retval = check_unsafe_exec(bprm);
-	if (retval)
+	if (retval < 0)
 		goto out_unlock;
+	clear_in_exec = retval;
 
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
@@ -1355,9 +1359,7 @@ int do_execve(char * filename,
 		goto out;
 
 	/* execve succeeded */
-	write_lock(&current->fs->lock);
 	current->fs->in_exec = 0;
-	write_unlock(&current->fs->lock);
 	current->in_execve = 0;
 	mutex_unlock(&current->cred_exec_mutex);
 	acct_update_integrals(current);
@@ -1377,9 +1379,8 @@ out_file:
 	}
 
 out_unmark:
-	write_lock(&current->fs->lock);
-	current->fs->in_exec = 0;
-	write_unlock(&current->fs->lock);
+	if (clear_in_exec)
+		current->fs->in_exec = 0;
 
 out_unlock:
 	current->in_execve = 0;
--- PTRACE/fs/compat.c~1_IN_EXEC	2009-04-22 20:49:07.000000000 +0200
+++ PTRACE/fs/compat.c	2009-04-24 00:09:36.000000000 +0200
@@ -1476,6 +1476,7 @@ int compat_do_execve(char * filename,
 	struct linux_binprm *bprm;
 	struct file *file;
 	struct files_struct *displaced;
+	bool clear_in_exec;
 	int retval;
 
 	retval = unshare_files(&displaced);
@@ -1498,8 +1499,9 @@ int compat_do_execve(char * filename,
 		goto out_unlock;
 
 	retval = check_unsafe_exec(bprm);
-	if (retval)
+	if (retval < 0)
 		goto out_unlock;
+	clear_in_exec = retval;
 
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
@@ -1546,9 +1548,7 @@ int compat_do_execve(char * filename,
 		goto out;
 
 	/* execve succeeded */
-	write_lock(&current->fs->lock);
 	current->fs->in_exec = 0;
-	write_unlock(&current->fs->lock);
 	current->in_execve = 0;
 	mutex_unlock(&current->cred_exec_mutex);
 	acct_update_integrals(current);
@@ -1568,9 +1568,8 @@ out_file:
 	}
 
 out_unmark:
-	write_lock(&current->fs->lock);
-	current->fs->in_exec = 0;
-	write_unlock(&current->fs->lock);
+	if (clear_in_exec)
+		current->fs->in_exec = 0;
 
 out_unlock:
 	current->in_execve = 0;

