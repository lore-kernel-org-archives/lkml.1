Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab0BWFdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 00:33:04 -0500
Received: from mail.gmx.net ([213.165.64.20]:36757 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751124Ab0BWFdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 00:33:01 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+Sbw51JiaSFweeNzYD1p5fqI86p7nJqYfVfQGofd
	bMLr8a2m8iw1Pe
Subject: [patchlet] vfs: tell gcc to st[hHf]u wrt NAMEOFFSET
From: Mike Galbraith <efault@gmx.de>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 23 Feb 2010 06:32:57 +0100
Message-Id: <1266903177.6352.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc has become smart enough to not figure out the below, so take Al's advice.

http://lkml.indiana.edu/hypermail/linux/kernel/0603.1/0418.html

<quote>
It doesn't dereference it. d_name is an array, not a pointer. FWIW,
it should've been

#define NAME_OFFSET(de) offsetof(typeof(de), d_name)

or, better yet

#define NAME_OFFSET offsetof(struct linux_dirent, d_name)
#define NAME_OFFSET64 offsetof(struct linux_dirent64, d_name)
</quote>

vfs: tell gcc to st[hHf]u wrt NAMEOFFSET

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Al Viro <viro@ftp.linux.org.uk>
LKML-Reference: <new-submission>

diff --git a/fs/compat.c b/fs/compat.c
index 00d90c2..cf08df5 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -817,7 +817,8 @@ asmlinkage long compat_sys_mount(char __user * dev_name, char __user * dir_name,
 	return retval;
 }
 
-#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
+#define NAME_OFFSET_COMPAT offsetof(struct compat_linux_dirent, d_name)
+#define NAME_OFFSET64 offsetof(struct linux_dirent64, d_name)
 
 struct compat_old_linux_dirent {
 	compat_ulong_t	d_ino;
@@ -907,7 +908,7 @@ static int compat_filldir(void *__buf, const char *name, int namlen,
 	struct compat_linux_dirent __user * dirent;
 	struct compat_getdents_callback *buf = __buf;
 	compat_ulong_t d_ino;
-	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 2, sizeof(compat_long_t));
+	int reclen = ALIGN(NAME_OFFSET_COMPAT + namlen + 2, sizeof(compat_long_t));
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
@@ -994,7 +995,7 @@ static int compat_filldir64(void * __buf, const char * name, int namlen, loff_t
 {
 	struct linux_dirent64 __user *dirent;
 	struct compat_getdents_callback64 *buf = __buf;
-	int jj = NAME_OFFSET(dirent);
+	int jj = NAME_OFFSET64;
 	int reclen = ALIGN(jj + namlen + 1, sizeof(u64));
 	u64 off;
 
diff --git a/fs/readdir.c b/fs/readdir.c
index 7723401..9a1ddb6 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -54,7 +54,8 @@ EXPORT_SYMBOL(vfs_readdir);
  * anyway. Thus the special "fillonedir()" function for that
  * case (the low-level handlers don't need to care about this).
  */
-#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
+#define NAME_OFFSET offsetof(struct linux_dirent, d_name)
+#define NAME_OFFSET64 offsetof(struct linux_dirent64, d_name)
 
 #ifdef __ARCH_WANT_OLD_READDIR
 
@@ -152,7 +153,7 @@ static int filldir(void * __buf, const char * name, int namlen, loff_t offset,
 	struct linux_dirent __user * dirent;
 	struct getdents_callback * buf = (struct getdents_callback *) __buf;
 	unsigned long d_ino;
-	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 2, sizeof(long));
+	int reclen = ALIGN(NAME_OFFSET + namlen + 2, sizeof(long));
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
@@ -237,7 +238,7 @@ static int filldir64(void * __buf, const char * name, int namlen, loff_t offset,
 {
 	struct linux_dirent64 __user *dirent;
 	struct getdents_callback64 * buf = (struct getdents_callback64 *) __buf;
-	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 1, sizeof(u64));
+	int reclen = ALIGN(NAME_OFFSET64 + namlen + 1, sizeof(u64));
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)


