Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbYKLQOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbYKLQOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbYKLQL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:11:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45393 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbYKLQLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:11:54 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH =-v3 11/21] fanotify: give a special access permission check
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Date: Wed, 12 Nov 2008 11:11:24 -0500
Message-ID: <20081112161124.25434.86250.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add a special FANOTIFY_ACCESS_EXEC_PERM check.  This will be applied any
place a process tries to access a file with execute permissions.  Mainly
sys_execve, sys_uselib, and mmap'ing a file for exec.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/aio.c                 |    4 ++--
 fs/exec.c                |   10 ++++++++++
 fs/read_write.c          |    2 +-
 include/linux/fanotify.h |    6 ++++--
 mm/mmap.c                |    7 +++++++
 mm/mprotect.c            |    6 ++++++
 mm/nommu.c               |    7 +++++++
 7 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 008de79..6395403 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1455,7 +1455,7 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb)
 		ret = security_file_permission(file, MAY_READ);
 		if (unlikely(ret))
 			break;
-		ret = fanotify(file, FAN_ACCESS_PERM);
+		ret = fanotify(file, FAN_ACCESS_NOEXEC_PERM);
 		if (unlikely(ret))
 			break;
 		ret = aio_setup_single_vector(kiocb);
@@ -1490,7 +1490,7 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb)
 		ret = security_file_permission(file, MAY_READ);
 		if (unlikely(ret))
 			break;
-		ret = fanotify(file, FAN_ACCESS_PERM);
+		ret = fanotify(file, FAN_ACCESS_NOEXEC_PERM);
 		if (unlikely(ret))
 			break;
 		ret = aio_setup_vectored_rw(READ, kiocb);
diff --git a/fs/exec.c b/fs/exec.c
index 8f56995..3d88fa3 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -137,6 +137,11 @@ asmlinkage long sys_uselib(const char __user * library)
 		goto out;
 
 	fsnotify_open_exec(file);
+	error = fanotify(file, FAN_ACCESS_EXEC_PERM);
+	if (error) {
+		fput(file);
+		goto out;
+	}
 
 	error = -ENOEXEC;
 	if(file->f_op) {
@@ -691,6 +696,11 @@ struct file *open_exec(const char *name)
 		return file;
 
 	fsnotify_open_exec(file);
+	err = fanotify(file, FAN_ACCESS_EXEC_PERM);
+	if (err) {
+		fput(file);
+		goto out;
+	}
 
 	err = deny_write_access(file);
 	if (err) {
diff --git a/fs/read_write.c b/fs/read_write.c
index 6f8cf69..5100cd2 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -225,7 +225,7 @@ int rw_verify_area(int read_write, struct file *file, loff_t *ppos, size_t count
 	if (retval)
 		return retval;
 	if (read_write == READ) {
-		retval = fanotify(file, FAN_ACCESS_PERM);
+		retval = fanotify(file, FAN_ACCESS_NOEXEC_PERM);
 		if (retval)
 			return retval;
 	}
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 83c3d5e..efc62e9 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -18,8 +18,9 @@
 #define FAN_OPEN_EXEC		0x00000020	/* File was opened with the intention of being exec'ed */
 
 /* userspace may also request blocking for permission checks for open and read */
-#define FAN_ACCESS_PERM		0x00000100
-#define FAN_OPEN_PERM		0x00000200
+#define FAN_ACCESS_NOEXEC_PERM	0x00000100
+#define FAN_ACCESS_EXEC_PERM	0x00000200
+#define FAN_OPEN_PERM		0x00000400
 
 /* FIXME currently Q's have no limit.... */
 #define FAN_Q_OVERFLOW		0x80000000	/* Event queued overflowed */
@@ -27,6 +28,7 @@
 /* helper events */
 #define FAN_CLOSE		(FAN_CLOSE_WRITE | FAN_CLOSE_NOWRITE) /* close */
 #define FAN_OPEN		(FAN_OPEN_NOEXEC | FAN_OPEN_EXEC) /* open */
+#define FAN_ACCESS_PERM		(FAN_ACCESS_NOEXEC_PERM | FAN_ACCESS_EXEC_PERM) /* access perm */
 
 /*
  * All of the events - we build the list by hand so that we can add flags in
diff --git a/mm/mmap.c b/mm/mmap.c
index de14ac2..8013252 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/fanotify.h>
 #include <linux/personality.h>
 #include <linux/security.h>
 #include <linux/hugetlb.h>
@@ -1027,6 +1028,12 @@ unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
 		default:
 			return -EINVAL;
 		}
+
+		if (prot & PROT_EXEC) {
+			error = fanotify(file, FAN_ACCESS_EXEC_PERM);
+			if (error)
+				return error;
+		}
 	} else {
 		switch (flags & MAP_TYPE) {
 		case MAP_SHARED:
diff --git a/mm/mprotect.c b/mm/mprotect.c
index fded06f..af1da2d 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -16,6 +16,7 @@
 #include <linux/fs.h>
 #include <linux/highmem.h>
 #include <linux/security.h>
+#include <linux/fanotify.h>
 #include <linux/mempolicy.h>
 #include <linux/personality.h>
 #include <linux/syscalls.h>
@@ -294,6 +295,11 @@ sys_mprotect(unsigned long start, size_t len, unsigned long prot)
 		if (error)
 			goto out;
 
+		if (vma->vm_file && (prot & PROT_EXEC))
+			error = fanotify(vma->vm_file, FAN_ACCESS_EXEC_PERM);
+		if (error)
+			goto out;
+
 		tmp = vma->vm_end;
 		if (tmp > end)
 			tmp = end;
diff --git a/mm/nommu.c b/mm/nommu.c
index 7695dc8..d376916 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -18,6 +18,7 @@
 #include <linux/mman.h>
 #include <linux/swap.h>
 #include <linux/file.h>
+#include <linux/fanotify.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
 #include <linux/slab.h>
@@ -731,6 +732,12 @@ static int validate_mmap_request(struct file *file,
 			/* backing file is not executable, try to copy */
 			capabilities &= ~BDI_CAP_MAP_DIRECT;
 		}
+
+		if (prot & PROT_EXEC) {
+			ret = fanotify(file, FAN_ACCESS_EXEC_PERM);
+			if (ret)
+				return ret;
+		}
 	}
 	else {
 		/* anonymous mappings are always memory backed and can be

