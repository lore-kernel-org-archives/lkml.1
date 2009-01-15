Return-Path: <linux-kernel-owner+w=401wt.eu-S935275AbZAOW1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935275AbZAOW1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933813AbZAOWCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:02:49 -0500
Received: from kroah.org ([198.145.64.141]:38510 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763825AbZAOWCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:02:37 -0500
Date: Thu, 15 Jan 2009 14:00:23 -0800
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
Subject: [patch 44/85] [PATCH 24/44] [CVE-2009-0029] System call wrappers
	part 14
Message-ID: <20090115220023.GS17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0024--CVE-2009-0029-System-call-wrappers-part-14.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 3480b25743cb7404928d57efeaa3d085708b04c2 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/namei.c     |    8 ++++----
 fs/namespace.c |    4 ++--
 fs/open.c      |    2 +-
 mm/madvise.c   |    2 +-
 mm/mincore.c   |    4 ++--
 mm/mlock.c     |    4 ++--
 6 files changed, 12 insertions(+), 12 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2041,7 +2041,7 @@ out_unlock:
 	return error;
 }
 
-asmlinkage long sys_mknod(const char __user *filename, int mode, unsigned dev)
+SYSCALL_DEFINE3(mknod, const char __user *, filename, int, mode, unsigned, dev)
 {
 	return sys_mknodat(AT_FDCWD, filename, mode, dev);
 }
@@ -2308,7 +2308,7 @@ asmlinkage long sys_unlinkat(int dfd, co
 	return do_unlinkat(dfd, pathname);
 }
 
-asmlinkage long sys_unlink(const char __user *pathname)
+SYSCALL_DEFINE1(unlink, const char __user *, pathname)
 {
 	return do_unlinkat(AT_FDCWD, pathname);
 }
@@ -2372,7 +2372,7 @@ out_putname:
 	return error;
 }
 
-asmlinkage long sys_symlink(const char __user *oldname, const char __user *newname)
+SYSCALL_DEFINE2(symlink, const char __user *, oldname, const char __user *, newname)
 {
 	return sys_symlinkat(oldname, AT_FDCWD, newname);
 }
@@ -2471,7 +2471,7 @@ out:
 	return error;
 }
 
-asmlinkage long sys_link(const char __user *oldname, const char __user *newname)
+SYSCALL_DEFINE2(link, const char __user *, oldname, const char __user *, newname)
 {
 	return sys_linkat(AT_FDCWD, oldname, AT_FDCWD, newname, 0);
 }
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2179,8 +2179,8 @@ static void chroot_fs_refs(struct path *
  *    though, so you may need to say mount --bind /nfs/my_root /nfs/my_root
  *    first.
  */
-asmlinkage long sys_pivot_root(const char __user * new_root,
-			       const char __user * put_old)
+SYSCALL_DEFINE2(pivot_root, const char __user *, new_root,
+		const char __user *, put_old)
 {
 	struct vfsmount *tmp;
 	struct path new, old, parent_path, root_parent, root;
--- a/fs/open.c
+++ b/fs/open.c
@@ -574,7 +574,7 @@ out:
 	return error;
 }
 
-asmlinkage long sys_chroot(const char __user * filename)
+SYSCALL_DEFINE1(chroot, const char __user *, filename)
 {
 	struct path path;
 	int error;
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -281,7 +281,7 @@ madvise_vma(struct vm_area_struct *vma, 
  *  -EBADF  - map exists, but area maps something that isn't a file.
  *  -EAGAIN - a kernel resource was temporarily unavailable.
  */
-asmlinkage long sys_madvise(unsigned long start, size_t len_in, int behavior)
+SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
 {
 	unsigned long end, tmp;
 	struct vm_area_struct * vma, *prev;
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -177,8 +177,8 @@ none_mapped:
  *		mapped
  *  -EAGAIN - A kernel resource was temporarily unavailable.
  */
-asmlinkage long sys_mincore(unsigned long start, size_t len,
-	unsigned char __user * vec)
+SYSCALL_DEFINE3(mincore, unsigned long, start, size_t, len,
+		unsigned char __user *, vec)
 {
 	long retval;
 	unsigned long pages;
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -193,7 +193,7 @@ out:
 	return 0;
 }
 
-asmlinkage long sys_mlockall(int flags)
+SYSCALL_DEFINE1(mlockall, int, flags)
 {
 	unsigned long lock_limit;
 	int ret = -EINVAL;
@@ -219,7 +219,7 @@ out:
 	return ret;
 }
 
-asmlinkage long sys_munlockall(void)
+SYSCALL_DEFINE0(munlockall)
 {
 	int ret;
 

