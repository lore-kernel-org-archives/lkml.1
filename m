Return-Path: <linux-kernel-owner+w=401wt.eu-S935656AbZAOW2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935656AbZAOW2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764203AbZAOWCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:02:52 -0500
Received: from kroah.org ([198.145.64.141]:38585 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933266AbZAOWCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:02:39 -0500
Date: Thu, 15 Jan 2009 14:00:29 -0800
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
Subject: [patch 47/85] [PATCH 27/44] [CVE-2009-0029] System call wrappers
	part 17
Message-ID: <20090115220029.GV17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0027--CVE-2009-0029-System-call-wrappers-part-17.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit ca013e945b1ba5828b151ee646946f1297b67a4c upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/open.c      |   16 +++++++---------
 kernel/uid16.c |    6 +++---
 2 files changed, 10 insertions(+), 12 deletions(-)

--- a/fs/open.c
+++ b/fs/open.c
@@ -522,7 +522,7 @@ out:
 	return res;
 }
 
-asmlinkage long sys_access(const char __user *filename, int mode)
+SYSCALL_DEFINE2(access, const char __user *, filename, int, mode)
 {
 	return sys_faccessat(AT_FDCWD, filename, mode);
 }
@@ -693,7 +693,7 @@ static int chown_common(struct dentry * 
 	return error;
 }
 
-asmlinkage long sys_chown(const char __user * filename, uid_t user, gid_t group)
+SYSCALL_DEFINE3(chown, const char __user *, filename, uid_t, user, gid_t, group)
 {
 	struct path path;
 	int error;
@@ -737,7 +737,7 @@ out:
 	return error;
 }
 
-asmlinkage long sys_lchown(const char __user * filename, uid_t user, gid_t group)
+SYSCALL_DEFINE3(lchown, const char __user *, filename, uid_t, user, gid_t, group)
 {
 	struct path path;
 	int error;
@@ -756,8 +756,7 @@ out:
 	return error;
 }
 
-
-asmlinkage long sys_fchown(unsigned int fd, uid_t user, gid_t group)
+SYSCALL_DEFINE3(fchown, unsigned int, fd, uid_t, user, gid_t, group)
 {
 	struct file * file;
 	int error = -EBADF;
@@ -1048,7 +1047,7 @@ long do_sys_open(int dfd, const char __u
 	return fd;
 }
 
-asmlinkage long sys_open(const char __user *filename, int flags, int mode)
+SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, int, mode)
 {
 	long ret;
 
@@ -1117,7 +1116,7 @@ EXPORT_SYMBOL(filp_close);
  * releasing the fd. This ensures that one clone task can't release
  * an fd while another clone is opening it.
  */
-asmlinkage long sys_close(unsigned int fd)
+SYSCALL_DEFINE1(close, unsigned int, fd)
 {
 	struct file * filp;
 	struct files_struct *files = current->files;
@@ -1150,14 +1149,13 @@ out_unlock:
 	spin_unlock(&files->file_lock);
 	return -EBADF;
 }
-
 EXPORT_SYMBOL(sys_close);
 
 /*
  * This routine simulates a hangup on the tty, to arrange that users
  * are given clean terminals at login time.
  */
-asmlinkage long sys_vhangup(void)
+SYSCALL_DEFINE0(vhangup)
 {
 	if (capable(CAP_SYS_TTY_CONFIG)) {
 		/* XXX: this needs locking */
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -17,7 +17,7 @@
 
 #include <asm/uaccess.h>
 
-asmlinkage long sys_chown16(const char __user * filename, old_uid_t user, old_gid_t group)
+SYSCALL_DEFINE3(chown16, const char __user *, filename, old_uid_t, user, old_gid_t, group)
 {
 	long ret = sys_chown(filename, low2highuid(user), low2highgid(group));
 	/* avoid REGPARM breakage on x86: */
@@ -25,7 +25,7 @@ asmlinkage long sys_chown16(const char _
 	return ret;
 }
 
-asmlinkage long sys_lchown16(const char __user * filename, old_uid_t user, old_gid_t group)
+SYSCALL_DEFINE3(lchown16, const char __user *, filename, old_uid_t, user, old_gid_t, group)
 {
 	long ret = sys_lchown(filename, low2highuid(user), low2highgid(group));
 	/* avoid REGPARM breakage on x86: */
@@ -33,7 +33,7 @@ asmlinkage long sys_lchown16(const char 
 	return ret;
 }
 
-asmlinkage long sys_fchown16(unsigned int fd, old_uid_t user, old_gid_t group)
+SYSCALL_DEFINE3(fchown16, unsigned int, fd, old_uid_t, user, old_gid_t, group)
 {
 	long ret = sys_fchown(fd, low2highuid(user), low2highgid(group));
 	/* avoid REGPARM breakage on x86: */

