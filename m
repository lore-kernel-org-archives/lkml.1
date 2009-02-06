Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbZBFLqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbZBFLqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 06:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbZBFLq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 06:46:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35272 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbZBFLq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 06:46:27 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CRED: Fix SUID exec regression
To: jmorris@namei.org, dsmith@redhat.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, roland@redhat.com,
       fche@redhat.com, oleg@redhat.com, linux-security-module@vger.kernel.org
Date: Fri, 06 Feb 2009 11:45:46 +0000
Message-ID: <20090206114546.4255.74054.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch:

	commit a6f76f23d297f70e2a6b3ec607f7aeeea9e37e8d
	CRED: Make execve() take advantage of copy-on-write credentials

moved the place in which the 'safeness' of a SUID/SGID exec was performed to
before de_thread() was called.  This means that LSM_UNSAFE_SHARE is now
calculated incorrectly.  This flag is set if any of the usage counts for
fs_struct, files_struct and sighand_struct are greater than 1 at the time the
determination is made.  All of which are true for threads created by the
pthread library.

However, since we wish to make the security calculation before irrevocably
damaging the process so that we can return it an error code in the case where
we decide we want to reject the exec request on this basis, we have to make the
determination before calling de_thread().

So, instead, we count up the number of threads (CLONE_THREAD) that are sharing
our fs_struct (CLONE_FS), files_struct (CLONE_FILES) and sighand_structs
(CLONE_SIGHAND/CLONE_THREAD) with us.  These will be killed by de_thread() and
so can be discounted by check_unsafe_exec().

We do have to be careful because CLONE_THREAD does not imply FS or FILES.

We _assume_ that there will be no extra references to these structs held by the
threads we're going to kill.

This can be tested with the attached pair of programs.  Build the two programs
using the Makefile supplied, and run ./test1 as a non-root user.  If
successful, you should see something like:

	[dhowells@andromeda tmp]$ ./test1
	--TEST1--
	uid=4043, euid=4043 suid=4043
	exec ./test2
	--TEST2--
	uid=4043, euid=0 suid=0
	SUCCESS - Correct effective user ID

and if unsuccessful, something like:

	[dhowells@andromeda tmp]$ ./test1
	--TEST1--
	uid=4043, euid=4043 suid=4043
	exec ./test2
	--TEST2--
	uid=4043, euid=4043 suid=4043
	ERROR - Incorrect effective user ID!

The non-root user ID you see will depend on the user you run as.


[test1.c]
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>

static void *thread_func(void *arg)
{
	while (1) {}
}

int main(int argc, char **argv)
{
	pthread_t tid;
	uid_t uid, euid, suid;

	printf("--TEST1--\n");
	getresuid(&uid, &euid, &suid);
	printf("uid=%d, euid=%d suid=%d\n", uid, euid, suid);

	if (pthread_create(&tid, NULL, thread_func, NULL) < 0) {
		perror("pthread_create");
		exit(1);
	}

	printf("exec ./test2\n");
	execlp("./test2", "test2", NULL);
	perror("./test2");
	_exit(1);
}

[test2.c]
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char **argv)
{
	uid_t uid, euid, suid;

	getresuid(&uid, &euid, &suid);
	printf("--TEST2--\n");
	printf("uid=%d, euid=%d suid=%d\n", uid, euid, suid);

	if (euid != 0) {
		fprintf(stderr, "ERROR - Incorrect effective user ID!\n");
		exit(1);
	}
	printf("SUCCESS - Correct effective user ID\n");
	exit(0);
}

[Makefile]
CFLAGS = -D_GNU_SOURCE -Wall -Werror -Wunused
all: test1 test2

test1: test1.c
	gcc $(CFLAGS) -o test1 test1.c -lpthread

test2: test2.c
	gcc $(CFLAGS) -o test2 test2.c
	sudo chown root.root test2
	sudo chmod +s test2


Reported-by: David Smith <dsmith@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/compat.c   |    2 +-
 fs/exec.c     |   28 ++++++++++++++++++++++------
 fs/internal.h |    2 +-
 3 files changed, 24 insertions(+), 8 deletions(-)


diff --git a/fs/compat.c b/fs/compat.c
index 65a070e..d0145ca 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1407,7 +1407,7 @@ int compat_do_execve(char * filename,
 	bprm->cred = prepare_exec_creds();
 	if (!bprm->cred)
 		goto out_unlock;
-	check_unsafe_exec(bprm);
+	check_unsafe_exec(bprm, current->files);
 
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
diff --git a/fs/exec.c b/fs/exec.c
index 0dd60a0..929b580 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1049,16 +1049,32 @@ EXPORT_SYMBOL(install_exec_creds);
  * - the caller must hold current->cred_exec_mutex to protect against
  *   PTRACE_ATTACH
  */
-void check_unsafe_exec(struct linux_binprm *bprm)
+void check_unsafe_exec(struct linux_binprm *bprm, struct files_struct *files)
 {
-	struct task_struct *p = current;
+	struct task_struct *p = current, *t;
+	unsigned long flags;
+	unsigned n_fs, n_files, n_sighand;
 
 	bprm->unsafe = tracehook_unsafe_exec(p);
 
-	if (atomic_read(&p->fs->count) > 1 ||
-	    atomic_read(&p->files->count) > 1 ||
-	    atomic_read(&p->sighand->count) > 1)
+	n_fs = 1;
+	n_files = 1;
+	n_sighand = 1;
+	lock_task_sighand(p, &flags);
+	for (t = next_thread(p); t != p; t = next_thread(t)) {
+		if (t->fs == p->fs)
+			n_fs++;
+		if (t->files == files)
+			n_files++;
+		n_sighand++;
+	}
+
+	if (atomic_read(&p->fs->count) > n_fs ||
+	    atomic_read(&p->files->count) > n_files ||
+	    atomic_read(&p->sighand->count) > n_sighand)
 		bprm->unsafe |= LSM_UNSAFE_SHARE;
+
+	unlock_task_sighand(p, &flags);
 }
 
 /* 
@@ -1273,7 +1289,7 @@ int do_execve(char * filename,
 	bprm->cred = prepare_exec_creds();
 	if (!bprm->cred)
 		goto out_unlock;
-	check_unsafe_exec(bprm);
+	check_unsafe_exec(bprm, displaced);
 
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
diff --git a/fs/internal.h b/fs/internal.h
index 53af885..0d8ac49 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -43,7 +43,7 @@ extern void __init chrdev_init(void);
 /*
  * exec.c
  */
-extern void check_unsafe_exec(struct linux_binprm *);
+extern void check_unsafe_exec(struct linux_binprm *, struct files_struct *);
 
 /*
  * namespace.c

