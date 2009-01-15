Return-Path: <linux-kernel-owner+w=401wt.eu-S933116AbZAOUjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116AbZAOUjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932268AbZAOUCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:02:20 -0500
Received: from kroah.org ([198.145.64.141]:49487 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932108AbZAOUCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:02:15 -0500
Date: Thu, 15 Jan 2009 11:59:36 -0800
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
Subject: [patch 60/94] [PATCH 29/44] [CVE-2009-0029] System call wrappers
	part 19
Message-ID: <20090115195936.GH14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0029--CVE-2009-0029-System-call-wrappers-part-19.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

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
@@ -134,7 +134,7 @@ loff_t vfs_llseek(struct file *file, lof
 }
 EXPORT_SYMBOL(vfs_llseek);
 
-asmlinkage long sys_lseek(unsigned int fd, off_t offset, unsigned int origin)
+SYSCALL_DEFINE3(lseek, unsigned int, fd, off_t, offset, unsigned int, origin)
 {
 	off_t retval;
 	struct file * file;
@@ -158,9 +158,9 @@ bad:
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

