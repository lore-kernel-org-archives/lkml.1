Return-Path: <linux-kernel-owner+w=401wt.eu-S934861AbZAOW1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934861AbZAOW1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932869AbZAOWCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:02:50 -0500
Received: from kroah.org ([198.145.64.141]:38585 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932071AbZAOWCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:02:38 -0500
Date: Thu, 15 Jan 2009 14:00:25 -0800
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
Subject: [patch 45/85] [PATCH 25/44] [CVE-2009-0029] System call wrappers
	part 15
Message-ID: <20090115220025.GT17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0025--CVE-2009-0029-System-call-wrappers-part-15.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit a26eab2400f0477bfac0255600552394855016f7 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/fcntl.c |   11 ++++++-----
 fs/ioctl.c |    2 +-
 fs/namei.c |    2 +-
 fs/open.c  |    4 ++--
 4 files changed, 10 insertions(+), 9 deletions(-)

--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -50,7 +50,7 @@ static int get_close_on_exec(unsigned in
 	return res;
 }
 
-asmlinkage long sys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
+SYSCALL_DEFINE3(dup3, unsigned int, oldfd, unsigned int, newfd, int, flags)
 {
 	int err = -EBADF;
 	struct file * file, *tofree;
@@ -113,7 +113,7 @@ out_unlock:
 	return err;
 }
 
-asmlinkage long sys_dup2(unsigned int oldfd, unsigned int newfd)
+SYSCALL_DEFINE2(dup2, unsigned int, oldfd, unsigned int, newfd)
 {
 	if (unlikely(newfd == oldfd)) { /* corner case */
 		struct files_struct *files = current->files;
@@ -126,7 +126,7 @@ asmlinkage long sys_dup2(unsigned int ol
 	return sys_dup3(oldfd, newfd, 0);
 }
 
-asmlinkage long sys_dup(unsigned int fildes)
+SYSCALL_DEFINE1(dup, unsigned int, fildes)
 {
 	int ret = -EBADF;
 	struct file *file = fget(fildes);
@@ -334,7 +334,7 @@ static long do_fcntl(int fd, unsigned in
 	return err;
 }
 
-asmlinkage long sys_fcntl(unsigned int fd, unsigned int cmd, unsigned long arg)
+SYSCALL_DEFINE3(fcntl, unsigned int, fd, unsigned int, cmd, unsigned long, arg)
 {	
 	struct file *filp;
 	long err = -EBADF;
@@ -357,7 +357,8 @@ out:
 }
 
 #if BITS_PER_LONG == 32
-asmlinkage long sys_fcntl64(unsigned int fd, unsigned int cmd, unsigned long arg)
+SYSCALL_DEFINE3(fcntl64, unsigned int, fd, unsigned int, cmd,
+		unsigned long, arg)
 {	
 	struct file * filp;
 	long err;
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -195,7 +195,7 @@ int do_vfs_ioctl(struct file *filp, unsi
 	return error;
 }
 
-asmlinkage long sys_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg)
+SYSCALL_DEFINE3(ioctl, unsigned int, fd, unsigned int, cmd, unsigned long, arg)
 {
 	struct file *filp;
 	int error = -EBADF;
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2707,7 +2707,7 @@ exit:
 	return error;
 }
 
-asmlinkage long sys_rename(const char __user *oldname, const char __user *newname)
+SYSCALL_DEFINE2(rename, const char __user *, oldname, const char __user *, newname)
 {
 	return sys_renameat(AT_FDCWD, oldname, AT_FDCWD, newname);
 }
--- a/fs/open.c
+++ b/fs/open.c
@@ -599,7 +599,7 @@ out:
 	return error;
 }
 
-asmlinkage long sys_fchmod(unsigned int fd, mode_t mode)
+SYSCALL_DEFINE2(fchmod, unsigned int, fd, mode_t, mode)
 {
 	struct inode * inode;
 	struct dentry * dentry;
@@ -663,7 +663,7 @@ out:
 	return error;
 }
 
-asmlinkage long sys_chmod(const char __user *filename, mode_t mode)
+SYSCALL_DEFINE2(chmod, const char __user *, filename, mode_t, mode)
 {
 	return sys_fchmodat(AT_FDCWD, filename, mode);
 }

