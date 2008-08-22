Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbYHVNFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbYHVNFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 09:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYHVNFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 09:05:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbYHVNFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 09:05:01 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <19f34abd0808210110s4dd2ec12r6d3044e45a21d67@mail.gmail.com>
References: <19f34abd0808210110s4dd2ec12r6d3044e45a21d67@mail.gmail.com> <6f31812b0808210004i63b3273ehf65ce9eb139256f0@mail.gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: dhowells@redhat.com, "jay kumar" <jaykumarks@gmail.com>,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: Bug: "bad unlock balance detected" 2.6.27-rc3-next-20080820
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Date: Fri, 22 Aug 2008 14:04:57 +0100
Message-ID: <24926.1219410297@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Vegard Nossum <vegard.nossum@gmail.com> wrote:

> I couldn't reproduce your original failure, but I've attempted to fix
> it by reordering the mutex unlock and bprm free and removing the
> extraneous unlock (see attached patch; it boots for me without
> errors).

Your patch ought to throw up its own lock failure.  You've added a
mutex_unlock() call to the execve success path, but you haven't removed one
from install_exec_creds().  Also, this patch is not sufficient as it doesn't
do anything for compat_do_execve().

Can you try the attached patches instead please?  You may find you have one or
more of them present already if you've pulled your tree recently.

David


--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment; filename=81-cred-compat-exec-mutex.diff

From: David Howells <dhowells@redhat.com>

CRED: Take cred_exec_mutex in compat_do_execve() and fix error handling in do_execve()

Take cred_exec_mutex in compat_do_execve().  This reflects what do_execve()
does.  The mutex protects credentials calculation against PTRACE_ATTACH needing
to alter it mid-exec.

Also fix the error handling in do_execve().  The mutex needs to be unlocked if
an error occurs after it is taken, but before the install_exec_creds()
released it.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/compat.c |   12 ++++++++++--
 fs/exec.c   |   12 ++++++++----
 2 files changed, 18 insertions(+), 6 deletions(-)


diff --git a/fs/compat.c b/fs/compat.c
index 2dde882..af24b8a 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1360,15 +1360,20 @@ int compat_do_execve(char * filename,
 	if (!bprm)
 		goto out_ret;
 
+	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
+	if (retval < 0)
+		goto out_free;
+
+	retval = -ENOMEM;
 	bprm->cred = prepare_exec_creds();
 	if (!bprm->cred)
-		goto out_free;
+		goto out_unlock;
 	check_unsafe_exec(bprm);
 
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
 	if (IS_ERR(file))
-		goto out_free;
+		goto out_unlock;
 
 	sched_exec();
 
@@ -1423,6 +1428,9 @@ out_file:
 		fput(bprm->file);
 	}
 
+out_unlock:
+	mutex_unlock(&current->cred_exec_mutex);
+
 out_free:
 	free_bprm(bprm);
 
diff --git a/fs/exec.c b/fs/exec.c
index a7633e5..4b31a72 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1308,18 +1308,18 @@ int do_execve(char * filename,
 
 	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
 	if (retval < 0)
-		goto out_kfree;
+		goto out_free;
 
 	retval = -ENOMEM;
 	bprm->cred = prepare_exec_creds();
 	if (!bprm->cred)
-		goto out_kfree;
+		goto out_unlock;
 	check_unsafe_exec(bprm);
 
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
 	if (IS_ERR(file))
-		goto out_kfree;
+		goto out_unlock;
 
 	sched_exec();
 
@@ -1376,7 +1376,11 @@ out_file:
 		allow_write_access(bprm->file);
 		fput(bprm->file);
 	}
-out_kfree:
+
+out_unlock:
+	mutex_unlock(&current->cred_exec_mutex);
+
+out_free:
 	free_bprm(bprm);
 
 out_files:

--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment; filename=82-cred-exec-mutex-error.diff

From: David Howells <dhowells@redhat.com>

CRED: Further fix execve error handling

Further fix [compat_]do_execve() error handling.  free_bprm() will release the
cred_exec_mutex, but only if bprm->cred is not NULL.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/compat.c |    3 ++-
 fs/exec.c   |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/compat.c b/fs/compat.c
index af24b8a..918f0f2 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1373,7 +1373,7 @@ int compat_do_execve(char * filename,
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
 	if (IS_ERR(file))
-		goto out_unlock;
+		goto out_free;
 
 	sched_exec();
 
@@ -1427,6 +1427,7 @@ out_file:
 		allow_write_access(bprm->file);
 		fput(bprm->file);
 	}
+	goto out_free;
 
 out_unlock:
 	mutex_unlock(&current->cred_exec_mutex);
diff --git a/fs/exec.c b/fs/exec.c
index 4b31a72..7b71679 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1319,7 +1319,7 @@ int do_execve(char * filename,
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
 	if (IS_ERR(file))
-		goto out_unlock;
+		goto out_free;
 
 	sched_exec();
 
@@ -1376,6 +1376,7 @@ out_file:
 		allow_write_access(bprm->file);
 		fput(bprm->file);
 	}
+	goto out_free;
 
 out_unlock:
 	mutex_unlock(&current->cred_exec_mutex);

--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment; filename=83-cred-move-exec-mutex.diff

From: David Howells <dhowells@redhat.com>

CRED: Move the exec mutex release out of bprm_free()

Move the exec mutex release out of free_bprm() and into the error handling
paths of do_execve() and compat_do_execve().  install_exec_creds() already
takes care of the success path.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/compat.c |    3 +--
 fs/exec.c   |    7 ++-----
 2 files changed, 3 insertions(+), 7 deletions(-)


diff --git a/fs/compat.c b/fs/compat.c
index 918f0f2..af24b8a 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1373,7 +1373,7 @@ int compat_do_execve(char * filename,
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
 	if (IS_ERR(file))
-		goto out_free;
+		goto out_unlock;
 
 	sched_exec();
 
@@ -1427,7 +1427,6 @@ out_file:
 		allow_write_access(bprm->file);
 		fput(bprm->file);
 	}
-	goto out_free;
 
 out_unlock:
 	mutex_unlock(&current->cred_exec_mutex);
diff --git a/fs/exec.c b/fs/exec.c
index 7b71679..9fa9a2d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1277,10 +1277,8 @@ EXPORT_SYMBOL(search_binary_handler);
 void free_bprm(struct linux_binprm *bprm)
 {
 	free_arg_pages(bprm);
-	if (bprm->cred) {
-		mutex_unlock(&current->cred_exec_mutex);
+	if (bprm->cred)
 		abort_creds(bprm->cred);
-	}
 	kfree(bprm);
 }
 
@@ -1319,7 +1317,7 @@ int do_execve(char * filename,
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
 	if (IS_ERR(file))
-		goto out_free;
+		goto out_unlock;
 
 	sched_exec();
 
@@ -1376,7 +1374,6 @@ out_file:
 		allow_write_access(bprm->file);
 		fput(bprm->file);
 	}
-	goto out_free;
 
 out_unlock:
 	mutex_unlock(&current->cred_exec_mutex);

--=-=-=--
