Return-Path: <linux-kernel-owner+w=401wt.eu-S935751AbZAOW0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935751AbZAOW0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933634AbZAOWCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:02:48 -0500
Received: from kroah.org ([198.145.64.141]:38510 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763976AbZAOWCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:02:36 -0500
Date: Thu, 15 Jan 2009 14:00:21 -0800
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
Subject: [patch 43/85] [PATCH 23/44] [CVE-2009-0029] System call wrappers
	part 13
Message-ID: <20090115220021.GR17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0023--CVE-2009-0029-System-call-wrappers-part-13.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 6a6160a7b5c27b3c38651baef92a14fa7072b3c1 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xattr.c    |    7 +++----
 mm/fremap.c   |    4 ++--
 mm/mlock.c    |    4 ++--
 mm/mmap.c     |    4 ++--
 mm/mprotect.c |    4 ++--
 mm/mremap.c   |    6 +++---
 mm/msync.c    |    2 +-
 mm/nommu.c    |   10 +++++-----
 8 files changed, 20 insertions(+), 21 deletions(-)

--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -499,8 +499,8 @@ SYSCALL_DEFINE2(removexattr, const char 
 	return error;
 }
 
-asmlinkage long
-sys_lremovexattr(const char __user *pathname, const char __user *name)
+SYSCALL_DEFINE2(lremovexattr, const char __user *, pathname,
+		const char __user *, name)
 {
 	struct path path;
 	int error;
@@ -517,8 +517,7 @@ sys_lremovexattr(const char __user *path
 	return error;
 }
 
-asmlinkage long
-sys_fremovexattr(int fd, const char __user *name)
+SYSCALL_DEFINE2(fremovexattr, int, fd, const char __user *, name)
 {
 	struct file *f;
 	struct dentry *dentry;
--- a/mm/fremap.c
+++ b/mm/fremap.c
@@ -118,8 +118,8 @@ static int populate_range(struct mm_stru
  * and the vma's default protection is used. Arbitrary protections
  * might be implemented in the future.
  */
-asmlinkage long sys_remap_file_pages(unsigned long start, unsigned long size,
-	unsigned long prot, unsigned long pgoff, unsigned long flags)
+SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
+		unsigned long, prot, unsigned long, pgoff, unsigned long, flags)
 {
 	struct mm_struct *mm = current->mm;
 	struct address_space *mapping;
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -130,7 +130,7 @@ static int do_mlock(unsigned long start,
 	return error;
 }
 
-asmlinkage long sys_mlock(unsigned long start, size_t len)
+SYSCALL_DEFINE2(mlock, unsigned long, start, size_t, len)
 {
 	unsigned long locked;
 	unsigned long lock_limit;
@@ -156,7 +156,7 @@ asmlinkage long sys_mlock(unsigned long 
 	return error;
 }
 
-asmlinkage long sys_munlock(unsigned long start, size_t len)
+SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
 {
 	int ret;
 
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -244,7 +244,7 @@ static struct vm_area_struct *remove_vma
 	return next;
 }
 
-asmlinkage long sys_brk(unsigned long brk)
+SYSCALL_DEFINE1(brk, unsigned long, brk)
 {
 	unsigned long rlim, retval;
 	unsigned long newbrk, oldbrk;
@@ -1927,7 +1927,7 @@ int do_munmap(struct mm_struct *mm, unsi
 
 EXPORT_SYMBOL(do_munmap);
 
-asmlinkage long sys_munmap(unsigned long addr, size_t len)
+SYSCALL_DEFINE2(munmap, unsigned long, addr, size_t, len)
 {
 	int ret;
 	struct mm_struct *mm = current->mm;
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -219,8 +219,8 @@ fail:
 	return error;
 }
 
-asmlinkage long
-sys_mprotect(unsigned long start, size_t len, unsigned long prot)
+SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
+		unsigned long, prot)
 {
 	unsigned long vm_flags, nstart, end, tmp, reqprot;
 	struct vm_area_struct *vma, *prev;
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -418,9 +418,9 @@ out_nc:
 	return ret;
 }
 
-asmlinkage long sys_mremap(unsigned long addr,
-	unsigned long old_len, unsigned long new_len,
-	unsigned long flags, unsigned long new_addr)
+SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
+		unsigned long, new_len, unsigned long, flags,
+		unsigned long, new_addr)
 {
 	unsigned long ret;
 
--- a/mm/msync.c
+++ b/mm/msync.c
@@ -28,7 +28,7 @@
  * So by _not_ starting I/O in MS_ASYNC we provide complete flexibility to
  * applications.
  */
-asmlinkage long sys_msync(unsigned long start, size_t len, int flags)
+SYSCALL_DEFINE3(msync, unsigned long, start, size_t, len, int, flags)
 {
 	unsigned long end;
 	struct mm_struct *mm = current->mm;
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -355,7 +355,7 @@ EXPORT_SYMBOL(vm_insert_page);
  *  to a regular file.  in this case, the unmapping will need
  *  to invoke file system routines that need the global lock.
  */
-asmlinkage long sys_brk(unsigned long brk)
+SYSCALL_DEFINE1(brk, unsigned long, brk)
 {
 	struct mm_struct *mm = current->mm;
 
@@ -1170,7 +1170,7 @@ int do_munmap(struct mm_struct *mm, unsi
 }
 EXPORT_SYMBOL(do_munmap);
 
-asmlinkage long sys_munmap(unsigned long addr, size_t len)
+SYSCALL_DEFINE2(munmap, unsigned long, addr, size_t, len)
 {
 	int ret;
 	struct mm_struct *mm = current->mm;
@@ -1261,9 +1261,9 @@ unsigned long do_mremap(unsigned long ad
 }
 EXPORT_SYMBOL(do_mremap);
 
-asmlinkage unsigned long sys_mremap(unsigned long addr,
-	unsigned long old_len, unsigned long new_len,
-	unsigned long flags, unsigned long new_addr)
+SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
+		unsigned long, new_len, unsigned long, flags,
+		unsigned long, new_addr)
 {
 	unsigned long ret;
 

