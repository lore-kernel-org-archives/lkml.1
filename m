Return-Path: <linux-kernel-owner+w=401wt.eu-S935949AbZAOW34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935949AbZAOW34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933847AbZAOWCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:02:54 -0500
Received: from kroah.org ([198.145.64.141]:38585 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933716AbZAOWCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:02:41 -0500
Date: Thu, 15 Jan 2009 14:00:33 -0800
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
Subject: [patch 49/85] [PATCH 29/44] [CVE-2009-0029] System call wrappers
	part 19
Message-ID: <20090115220033.GX17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0029--CVE-2009-0029-System-call-wrappers-part-19.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 003d7ab479168132a2b2c6700fe682b08f08ab0c upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/read_write.c |    8 ++++----
 fs/utimes.c     |    5 +++--
 kernel/uid16.c  |   12 ++++++------
 3 files changed, 13 insertions(+), 12 deletions(-)

--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -112,7 +112,7 @@ loff_t vfs_llseek(struct file *file, lof
 }
 EXPORT_SYMBOL(vfs_llseek);
 
-asmlinkage long sys_lseek(unsigned int fd, off_t offset, unsigned int origin)
+SYSCALL_DEFINE3(lseek, unsigned int, fd, off_t, offset, unsigned int, origin)
 {
 	off_t retval;
 	struct file * file;
@@ -136,9 +136,9 @@ bad:
 }
 
 #ifdef __ARCH_WANT_SYS_LLSEEK
-asmlinkage long sys_llseek(unsigned int fd, unsigned long offset_high,
-			   unsigned long offset_low, loff_t __user * result,
-			   unsigned int origin)
+SYSCALL_DEFINE5(llseek, unsigned int, fd, unsigned long, offset_high,
+		unsigned long, offset_low, loff_t __user *, result,
+		unsigned int, origin)
 {
 	int retval;
 	struct file * file;
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -24,7 +24,7 @@
  * must be owner or have write permission.
  * Else, update from *times, must be owner or super user.
  */
-asmlinkage long sys_utime(char __user *filename, struct utimbuf __user *times)
+SYSCALL_DEFINE2(utime, char __user *, filename, struct utimbuf __user *, times)
 {
 	struct timespec tv[2];
 
@@ -214,7 +214,8 @@ asmlinkage long sys_futimesat(int dfd, c
 	return do_utimes(dfd, filename, utimes ? tstimes : NULL, 0);
 }
 
-asmlinkage long sys_utimes(char __user *filename, struct timeval __user *utimes)
+SYSCALL_DEFINE2(utimes, char __user *, filename,
+		struct timeval __user *, utimes)
 {
 	return sys_futimesat(AT_FDCWD, filename, utimes);
 }
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -160,7 +160,7 @@ static int groups16_from_user(struct gro
 	return 0;
 }
 
-asmlinkage long sys_getgroups16(int gidsetsize, old_gid_t __user *grouplist)
+SYSCALL_DEFINE2(getgroups16, int, gidsetsize, old_gid_t __user *, grouplist)
 {
 	int i = 0;
 
@@ -184,7 +184,7 @@ out:
 	return i;
 }
 
-asmlinkage long sys_setgroups16(int gidsetsize, old_gid_t __user *grouplist)
+SYSCALL_DEFINE2(setgroups16, int, gidsetsize, old_gid_t __user *, grouplist)
 {
 	struct group_info *group_info;
 	int retval;
@@ -209,22 +209,22 @@ asmlinkage long sys_setgroups16(int gids
 	return retval;
 }
 
-asmlinkage long sys_getuid16(void)
+SYSCALL_DEFINE0(getuid16)
 {
 	return high2lowuid(current->uid);
 }
 
-asmlinkage long sys_geteuid16(void)
+SYSCALL_DEFINE0(geteuid16)
 {
 	return high2lowuid(current->euid);
 }
 
-asmlinkage long sys_getgid16(void)
+SYSCALL_DEFINE0(getgid16)
 {
 	return high2lowgid(current->gid);
 }
 
-asmlinkage long sys_getegid16(void)
+SYSCALL_DEFINE0(getegid16)
 {
 	return high2lowgid(current->egid);
 }

