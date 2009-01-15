Return-Path: <linux-kernel-owner+w=401wt.eu-S933008AbZAOUe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008AbZAOUe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932103AbZAOUCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:02:07 -0500
Received: from kroah.org ([198.145.64.141]:49356 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765993AbZAOUCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:02:05 -0500
Date: Thu, 15 Jan 2009 11:59:17 -0800
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
       alan@lxorguk.ukuu.org.uk, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 51/94] [PATCH 20/44] [CVE-2009-0029] System call wrappers
	part 10
Message-ID: <20090115195917.GY14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0020--CVE-2009-0029-System-call-wrappers-part-10.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit bdc480e3bef6eb0e7071770834cbdda7e30a5436 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/buffer.c    |    2 +-
 fs/namespace.c |    9 ++++-----
 fs/open.c      |   12 +++++-------
 fs/stat.c      |    2 +-
 4 files changed, 11 insertions(+), 14 deletions(-)

--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3177,7 +3177,7 @@ void block_sync_page(struct page *page)
  * Use of bdflush() is deprecated and will be removed in a future kernel.
  * The `pdflush' kernel threads fully replace bdflush daemons and this call.
  */
-asmlinkage long sys_bdflush(int func, long data)
+SYSCALL_DEFINE2(bdflush, int, func, long, data)
 {
 	static int msg_count;
 
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1128,7 +1128,7 @@ static int do_umount(struct vfsmount *mn
  * unixes. Our API is identical to OSF/1 to avoid making a mess of AMD
  */
 
-asmlinkage long sys_umount(char __user * name, int flags)
+SYSCALL_DEFINE2(umount, char __user *, name, int, flags)
 {
 	struct path path;
 	int retval;
@@ -1160,7 +1160,7 @@ out:
 /*
  *	The 2.0 compatible umount. No flags.
  */
-asmlinkage long sys_oldumount(char __user * name)
+SYSCALL_DEFINE1(oldumount, char __user *, name)
 {
 	return sys_umount(name, 0);
 }
@@ -2045,9 +2045,8 @@ struct mnt_namespace *copy_mnt_ns(unsign
 	return new_ns;
 }
 
-asmlinkage long sys_mount(char __user * dev_name, char __user * dir_name,
-			  char __user * type, unsigned long flags,
-			  void __user * data)
+SYSCALL_DEFINE5(mount, char __user *, dev_name, char __user *, dir_name,
+		char __user *, type, unsigned long, flags, void __user *, data)
 {
 	int retval;
 	unsigned long data_page;
--- a/fs/open.c
+++ b/fs/open.c
@@ -122,7 +122,7 @@ static int vfs_statfs64(struct dentry *d
 	return 0;
 }
 
-asmlinkage long sys_statfs(const char __user *pathname, struct statfs __user * buf)
+SYSCALL_DEFINE2(statfs, const char __user *, pathname, struct statfs __user *, buf)
 {
 	struct path path;
 	int error;
@@ -138,8 +138,7 @@ asmlinkage long sys_statfs(const char __
 	return error;
 }
 
-
-asmlinkage long sys_statfs64(const char __user *pathname, size_t sz, struct statfs64 __user *buf)
+SYSCALL_DEFINE3(statfs64, const char __user *, pathname, size_t, sz, struct statfs64 __user *, buf)
 {
 	struct path path;
 	long error;
@@ -157,8 +156,7 @@ asmlinkage long sys_statfs64(const char 
 	return error;
 }
 
-
-asmlinkage long sys_fstatfs(unsigned int fd, struct statfs __user * buf)
+SYSCALL_DEFINE2(fstatfs, unsigned int, fd, struct statfs __user *, buf)
 {
 	struct file * file;
 	struct statfs tmp;
@@ -287,7 +285,7 @@ out:
 	return error;
 }
 
-asmlinkage long sys_truncate(const char __user * path, unsigned long length)
+SYSCALL_DEFINE2(truncate, const char __user *, path, unsigned long, length)
 {
 	/* on 32-bit boxen it will cut the range 2^31--2^32-1 off */
 	return do_sys_truncate(path, (long)length);
@@ -336,7 +334,7 @@ out:
 	return error;
 }
 
-asmlinkage long sys_ftruncate(unsigned int fd, unsigned long length)
+SYSCALL_DEFINE2(ftruncate, unsigned int, fd, unsigned long, length)
 {
 	long ret = do_sys_ftruncate(fd, length, 1);
 	/* avoid REGPARM breakage on x86: */
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -152,7 +152,7 @@ static int cp_old_stat(struct kstat *sta
 	return copy_to_user(statbuf,&tmp,sizeof(tmp)) ? -EFAULT : 0;
 }
 
-asmlinkage long sys_stat(char __user * filename, struct __old_kernel_stat __user * statbuf)
+SYSCALL_DEFINE2(stat, char __user *, filename, struct __old_kernel_stat __user *, statbuf)
 {
 	struct kstat stat;
 	int error = vfs_stat_fd(AT_FDCWD, filename, &stat);

