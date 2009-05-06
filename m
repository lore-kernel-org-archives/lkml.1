Return-Path: <linux-kernel-owner+w=401wt.eu-S1763223AbZEFWMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763223AbZEFWMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761538AbZEFVzC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:55:02 -0400
Received: from kroah.org ([198.145.64.141]:57304 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761416AbZEFVy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:56 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:48:01 2009
Message-Id: <20090506214801.117768428@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:46:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>, Hugh Dickins <hugh@veritas.com>
Subject: [patch 42/58] do_execve() must not clear fs->in_exec if it was set by another thread
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=do_execve-must-not-clear-fs-in_exec-if-it-was-set-by-another-thread.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 8c652f96d3852b97a49c331cd0bb02d22f3cb31b upstream.

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
Acked-by: Roland McGrath <roland@redhat.com>
Acked-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/compat.c |   11 +++++------
 fs/exec.c   |   19 ++++++++++---------
 2 files changed, 15 insertions(+), 15 deletions(-)

--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1394,6 +1394,7 @@ int compat_do_execve(char * filename,
 	struct linux_binprm *bprm;
 	struct file *file;
 	struct files_struct *displaced;
+	bool clear_in_exec;
 	int retval;
 
 	retval = unshare_files(&displaced);
@@ -1415,8 +1416,9 @@ int compat_do_execve(char * filename,
 		goto out_unlock;
 
 	retval = check_unsafe_exec(bprm);
-	if (retval)
+	if (retval < 0)
 		goto out_unlock;
+	clear_in_exec = retval;
 
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
@@ -1463,9 +1465,7 @@ int compat_do_execve(char * filename,
 		goto out;
 
 	/* execve succeeded */
-	write_lock(&current->fs->lock);
 	current->fs->in_exec = 0;
-	write_unlock(&current->fs->lock);
 	mutex_unlock(&current->cred_exec_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
@@ -1484,9 +1484,8 @@ out_file:
 	}
 
 out_unmark:
-	write_lock(&current->fs->lock);
-	current->fs->in_exec = 0;
-	write_unlock(&current->fs->lock);
+	if (clear_in_exec)
+		current->fs->in_exec = 0;
 
 out_unlock:
 	mutex_unlock(&current->cred_exec_mutex);
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1069,9 +1069,11 @@ int check_unsafe_exec(struct linux_binpr
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
@@ -1273,6 +1275,7 @@ int do_execve(char * filename,
 	struct linux_binprm *bprm;
 	struct file *file;
 	struct files_struct *displaced;
+	bool clear_in_exec;
 	int retval;
 
 	retval = unshare_files(&displaced);
@@ -1294,8 +1297,9 @@ int do_execve(char * filename,
 		goto out_unlock;
 
 	retval = check_unsafe_exec(bprm);
-	if (retval)
+	if (retval < 0)
 		goto out_unlock;
+	clear_in_exec = retval;
 
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
@@ -1343,9 +1347,7 @@ int do_execve(char * filename,
 		goto out;
 
 	/* execve succeeded */
-	write_lock(&current->fs->lock);
 	current->fs->in_exec = 0;
-	write_unlock(&current->fs->lock);
 	mutex_unlock(&current->cred_exec_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
@@ -1364,9 +1366,8 @@ out_file:
 	}
 
 out_unmark:
-	write_lock(&current->fs->lock);
-	current->fs->in_exec = 0;
-	write_unlock(&current->fs->lock);
+	if (clear_in_exec)
+		current->fs->in_exec = 0;
 
 out_unlock:
 	mutex_unlock(&current->cred_exec_mutex);


