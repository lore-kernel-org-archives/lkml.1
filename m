Return-Path: <linux-kernel-owner+w=401wt.eu-S1751366AbXDEO2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbXDEO2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbXDEO2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:28:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:15430 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbXDEO2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:28:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=eqbimMybfSEYNcwjUkXtStY6RvSFZPQGk5ujcwJbuDdwrdx7D49ge7Nok+9/Lm3quCYyBaLn6JggvRWcpekbN6kw1K+3x3tPKd3Uwcvmhcnw9qeoD57KJclCNzhsFV8xF2qb3vlCO1kwiX6Dlru4RtKD1b7V1JLigWM3WnbDbP4=
Date: Thu, 5 Apr 2007 19:59:55 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: [KJ][PATCH]ROUND_UP macro cleanup in fs/(select|compat|readdir).c
Message-ID: <20070405142955.GA10638@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ROUND_UP macro cleanup use,ALIGN or DIV_ROUND_UP where ever appropriate.

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

---
 compat.c  |   20 ++++++++------------
 readdir.c |    8 +++-----
 select.c  |    8 ++++----
 3 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 040a8be..0e7559a 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -15,6 +15,7 @@
  *  published by the Free Software Foundation.
  */
 
+#include <linux/kernel.h>
 #include <linux/linkage.h>
 #include <linux/compat.h>
 #include <linux/errno.h>
@@ -901,8 +902,6 @@ asmlinkage long compat_sys_mount(char __user * dev_name, char __user * dir_name,
 }
 
 #define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
-#define COMPAT_ROUND_UP(x) (((x)+sizeof(compat_long_t)-1) & \
-				~(sizeof(compat_long_t)-1))
 
 struct compat_old_linux_dirent {
 	compat_ulong_t	d_ino;
@@ -990,7 +989,7 @@ static int compat_filldir(void *__buf, const char *name, int namlen,
 	struct compat_linux_dirent __user * dirent;
 	struct compat_getdents_callback *buf = __buf;
 	compat_ulong_t d_ino;
-	int reclen = COMPAT_ROUND_UP(NAME_OFFSET(dirent) + namlen + 2);
+	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 2, sizeof(compat_long_t));
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
@@ -1065,7 +1064,6 @@ out:
 }
 
 #ifndef __ARCH_OMIT_COMPAT_SYS_GETDENTS64
-#define COMPAT_ROUND_UP64(x) (((x)+sizeof(u64)-1) & ~(sizeof(u64)-1))
 
 struct compat_getdents_callback64 {
 	struct linux_dirent64 __user *current_dir;
@@ -1080,7 +1078,7 @@ static int compat_filldir64(void * __buf, const char * name, int namlen, loff_t
 	struct linux_dirent64 __user *dirent;
 	struct compat_getdents_callback64 *buf = __buf;
 	int jj = NAME_OFFSET(dirent);
-	int reclen = COMPAT_ROUND_UP64(jj + namlen + 1);
+	int reclen = ALIGN(jj + namlen + 1, sizeof(u64));
 	u64 off;
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
@@ -1593,8 +1591,6 @@ out_ret:
 
 #define __COMPAT_NFDBITS       (8 * sizeof(compat_ulong_t))
 
-#define ROUND_UP(x,y) (((x)+(y)-1)/(y))
-
 /*
  * Ooo, nasty.  We need here to frob 32-bit unsigned longs to
  * 64-bit unsigned longs.
@@ -1603,7 +1599,7 @@ static
 int compat_get_fd_set(unsigned long nr, compat_ulong_t __user *ufdset,
 			unsigned long *fdset)
 {
-	nr = ROUND_UP(nr, __COMPAT_NFDBITS);
+	nr = DIV_ROUND_UP(nr, __COMPAT_NFDBITS);
 	if (ufdset) {
 		unsigned long odd;
 
@@ -1637,7 +1633,7 @@ int compat_set_fd_set(unsigned long nr, compat_ulong_t __user *ufdset,
 		      unsigned long *fdset)
 {
 	unsigned long odd;
-	nr = ROUND_UP(nr, __COMPAT_NFDBITS);
+	nr = DIV_ROUND_UP(nr, __COMPAT_NFDBITS);
 
 	if (!ufdset)
 		return 0;
@@ -1759,7 +1755,7 @@ asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
 		if ((u64)tv.tv_sec >= (u64)MAX_INT64_SECONDS)
 			timeout = -1;	/* infinite */
 		else {
-			timeout = ROUND_UP(tv.tv_usec, 1000000/HZ);
+			timeout = DIV_ROUND_UP(tv.tv_usec, 1000000/HZ);
 			timeout += tv.tv_sec * HZ;
 		}
 	}
@@ -1827,7 +1823,7 @@ asmlinkage long compat_sys_pselect7(int n, compat_ulong_t __user *inp,
 	do {
 		if (tsp) {
 			if ((unsigned long)ts.tv_sec < MAX_SELECT_SECONDS) {
-				timeout = ROUND_UP(ts.tv_nsec, 1000000000/HZ);
+				timeout = DIV_ROUND_UP(ts.tv_nsec, 1000000000/HZ);
 				timeout += ts.tv_sec * (unsigned long)HZ;
 				ts.tv_sec = 0;
 				ts.tv_nsec = 0;
@@ -1923,7 +1919,7 @@ asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
 		/* We assume that ts.tv_sec is always lower than
 		   the number of seconds that can be expressed in
 		   an s64. Otherwise the compiler bitches at us */
-		timeout = ROUND_UP(ts.tv_nsec, 1000000000/HZ);
+		timeout = DIV_ROUND_UP(ts.tv_nsec, 1000000000/HZ);
 		timeout += ts.tv_sec * HZ;
 	}
 
diff --git a/fs/readdir.c b/fs/readdir.c
index f39f5b3..9e1cead 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -4,6 +4,7 @@
  *  Copyright (C) 1995  Linus Torvalds
  */
 
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/time.h>
 #include <linux/mm.h>
@@ -52,7 +53,6 @@ EXPORT_SYMBOL(vfs_readdir);
  * case (the low-level handlers don't need to care about this).
  */
 #define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
-#define ROUND_UP(x) (((x)+sizeof(long)-1) & ~(sizeof(long)-1))
 
 #ifdef __ARCH_WANT_OLD_READDIR
 
@@ -147,7 +147,7 @@ static int filldir(void * __buf, const char * name, int namlen, loff_t offset,
 	struct linux_dirent __user * dirent;
 	struct getdents_callback * buf = (struct getdents_callback *) __buf;
 	unsigned long d_ino;
-	int reclen = ROUND_UP(NAME_OFFSET(dirent) + namlen + 2);
+	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 2, sizeof(long));
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
@@ -220,8 +220,6 @@ out:
 	return error;
 }
 
-#define ROUND_UP64(x) (((x)+sizeof(u64)-1) & ~(sizeof(u64)-1))
-
 struct getdents_callback64 {
 	struct linux_dirent64 __user * current_dir;
 	struct linux_dirent64 __user * previous;
@@ -234,7 +232,7 @@ static int filldir64(void * __buf, const char * name, int namlen, loff_t offset,
 {
 	struct linux_dirent64 __user *dirent;
 	struct getdents_callback64 * buf = (struct getdents_callback64 *) __buf;
-	int reclen = ROUND_UP64(NAME_OFFSET(dirent) + namlen + 1);
+	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 1, sizeof(u64));
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
diff --git a/fs/select.c b/fs/select.c
index fe0893a..23e326a 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -14,6 +14,7 @@
  *     of fds to overcome nfds < 16390 descriptors limit (Tigran Aivazian).
  */
 
+#include <linux/kernel.h>
 #include <linux/syscalls.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -26,7 +27,6 @@
 
 #include <asm/uaccess.h>
 
-#define ROUND_UP(x,y) (((x)+(y)-1)/(y))
 #define DEFAULT_POLLMASK (POLLIN | POLLOUT | POLLRDNORM | POLLWRNORM)
 
 struct poll_table_page {
@@ -399,7 +399,7 @@ asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 		if ((u64)tv.tv_sec >= (u64)MAX_INT64_SECONDS)
 			timeout = -1;	/* infinite */
 		else {
-			timeout = ROUND_UP(tv.tv_usec, USEC_PER_SEC/HZ);
+			timeout = DIV_ROUND_UP(tv.tv_usec, USEC_PER_SEC/HZ);
 			timeout += tv.tv_sec * HZ;
 		}
 	}
@@ -454,7 +454,7 @@ asmlinkage long sys_pselect7(int n, fd_set __user *inp, fd_set __user *outp,
 		if ((u64)ts.tv_sec >= (u64)MAX_INT64_SECONDS)
 			timeout = -1;	/* infinite */
 		else {
-			timeout = ROUND_UP(ts.tv_nsec, NSEC_PER_SEC/HZ);
+			timeout = DIV_ROUND_UP(ts.tv_nsec, NSEC_PER_SEC/HZ);
 			timeout += ts.tv_sec * HZ;
 		}
 	}
@@ -776,7 +776,7 @@ asmlinkage long sys_ppoll(struct pollfd __user *ufds, unsigned int nfds,
 		if ((u64)ts.tv_sec >= (u64)MAX_INT64_SECONDS)
 			timeout = -1;	/* infinite */
 		else {
-			timeout = ROUND_UP(ts.tv_nsec, NSEC_PER_SEC/HZ);
+			timeout = DIV_ROUND_UP(ts.tv_nsec, NSEC_PER_SEC/HZ);
 			timeout += ts.tv_sec * HZ;
 		}
 	}
-- 
Milind Arun Choudhary
