Return-Path: <linux-kernel-owner+w=401wt.eu-S933397AbZAOU0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397AbZAOU0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765996AbZAOUBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:01:25 -0500
Received: from kroah.org ([198.145.64.141]:49215 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932087AbZAOUBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:01:05 -0500
Date: Thu, 15 Jan 2009 11:58:46 -0800
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
Subject: [patch 41/94] [PATCH 10/44] [CVE-2009-0029] System call wrapper
	special cases
Message-ID: <20090115195846.GO14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0010--CVE-2009-0029-System-call-wrapper-special-cases.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 6673e0c3fbeaed2cd08e2fd4a4aa97382d6fedb0 upstream.

System calls with an unsigned long long argument can't be converted with
the standard wrappers since that would include a cast to long, which in
turn means that we would lose the upper 32 bit on 32 bit architectures.
Also semctl can't use the standard wrapper since it has a 'union'
parameter.

So we handle them as special case and add some extra wrappers instead.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/dcookies.c   |   10 ++++++++--
 fs/open.c       |   27 ++++++++++++++++++++++++---
 fs/read_write.c |   24 ++++++++++++++++++++----
 fs/sync.c       |   26 ++++++++++++++++++++++----
 ipc/sem.c       |    9 ++++++++-
 mm/fadvise.c    |   18 ++++++++++++++++--
 mm/filemap.c    |    9 ++++++++-
 7 files changed, 106 insertions(+), 17 deletions(-)

--- a/fs/dcookies.c
+++ b/fs/dcookies.c
@@ -140,7 +140,7 @@ out:
 /* And here is where the userspace process can look up the cookie value
  * to retrieve the path.
  */
-asmlinkage long sys_lookup_dcookie(u64 cookie64, char __user * buf, size_t len)
+SYSCALL_DEFINE(lookup_dcookie)(u64 cookie64, char __user * buf, size_t len)
 {
 	unsigned long cookie = (unsigned long)cookie64;
 	int err = -EINVAL;
@@ -193,7 +193,13 @@ out:
 	mutex_unlock(&dcookie_mutex);
 	return err;
 }
-
+#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
+asmlinkage long SyS_lookup_dcookie(u64 cookie64, long buf, long len)
+{
+	return SYSC_lookup_dcookie(cookie64, (char __user *) buf, (size_t) len);
+}
+SYSCALL_ALIAS(sys_lookup_dcookie, SyS_lookup_dcookie);
+#endif
 
 static int dcookie_init(void)
 {
--- a/fs/open.c
+++ b/fs/open.c
@@ -346,21 +346,35 @@ asmlinkage long sys_ftruncate(unsigned i
 
 /* LFS versions of truncate are only needed on 32 bit machines */
 #if BITS_PER_LONG == 32
-asmlinkage long sys_truncate64(const char __user * path, loff_t length)
+SYSCALL_DEFINE(truncate64)(const char __user * path, loff_t length)
 {
 	return do_sys_truncate(path, length);
 }
+#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
+asmlinkage long SyS_truncate64(long path, loff_t length)
+{
+	return SYSC_truncate64((const char __user *) path, length);
+}
+SYSCALL_ALIAS(sys_truncate64, SyS_truncate64);
+#endif
 
-asmlinkage long sys_ftruncate64(unsigned int fd, loff_t length)
+SYSCALL_DEFINE(ftruncate64)(unsigned int fd, loff_t length)
 {
 	long ret = do_sys_ftruncate(fd, length, 0);
 	/* avoid REGPARM breakage on x86: */
 	asmlinkage_protect(2, ret, fd, length);
 	return ret;
 }
+#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
+asmlinkage long SyS_ftruncate64(long fd, loff_t length)
+{
+	return SYSC_ftruncate64((unsigned int) fd, length);
+}
+SYSCALL_ALIAS(sys_ftruncate64, SyS_ftruncate64);
 #endif
+#endif /* BITS_PER_LONG == 32 */
 
-asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
+SYSCALL_DEFINE(fallocate)(int fd, int mode, loff_t offset, loff_t len)
 {
 	struct file *file;
 	struct inode *inode;
@@ -417,6 +431,13 @@ out_fput:
 out:
 	return ret;
 }
+#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
+asmlinkage long SyS_fallocate(long fd, long mode, loff_t offset, loff_t len)
+{
+	return SYSC_fallocate((int)fd, (int)mode, offset, len);
+}
+SYSCALL_ALIAS(sys_fallocate, SyS_fallocate);
+#endif
 
 /*
  * access() needs to use the real uid/gid, not the effective uid/gid.
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -390,8 +390,8 @@ asmlinkage long sys_write(unsigned int f
 	return ret;
 }
 
-asmlinkage long sys_pread64(unsigned int fd, char __user *buf,
-			     size_t count, loff_t pos)
+SYSCALL_DEFINE(pread64)(unsigned int fd, char __user *buf,
+			size_t count, loff_t pos)
 {
 	struct file *file;
 	ssize_t ret = -EBADF;
@@ -410,9 +410,17 @@ asmlinkage long sys_pread64(unsigned int
 
 	return ret;
 }
+#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
+asmlinkage long SyS_pread64(long fd, long buf, long count, loff_t pos)
+{
+	return SYSC_pread64((unsigned int) fd, (char __user *) buf,
+			    (size_t) count, pos);
+}
+SYSCALL_ALIAS(sys_pread64, SyS_pread64);
+#endif
 
-asmlinkage long sys_pwrite64(unsigned int fd, const char __user *buf,
-			      size_t count, loff_t pos)
+SYSCALL_DEFINE(pwrite64)(unsigned int fd, const char __user *buf,
+			 size_t count, loff_t pos)
 {
 	struct file *file;
 	ssize_t ret = -EBADF;
@@ -431,6 +439,14 @@ asmlinkage long sys_pwrite64(unsigned in
 
 	return ret;
 }
+#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
+asmlinkage long SyS_pwrite64(long fd, long buf, long count, loff_t pos)
+{
+	return SYSC_pwrite64((unsigned int) fd, (const char __user *) buf,
+			     (size_t) count, pos);
+}
+SYSCALL_ALIAS(sys_pwrite64, SyS_pwrite64);
+#endif
 
 /*
  * Reduce an iovec's length in-place.  Return the resulting number of segments
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -175,8 +175,8 @@ asmlinkage long sys_fdatasync(unsigned i
  * already-instantiated disk blocks, there are no guarantees here that the data
  * will be available after a crash.
  */
-asmlinkage long sys_sync_file_range(int fd, loff_t offset, loff_t nbytes,
-					unsigned int flags)
+SYSCALL_DEFINE(sync_file_range)(int fd, loff_t offset, loff_t nbytes,
+				unsigned int flags)
 {
 	int ret;
 	struct file *file;
@@ -236,14 +236,32 @@ out_put:
 out:
 	return ret;
 }
+#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
+asmlinkage long SyS_sync_file_range(long fd, loff_t offset, loff_t nbytes,
+				    long flags)
+{
+	return SYSC_sync_file_range((int) fd, offset, nbytes,
+				    (unsigned int) flags);
+}
+SYSCALL_ALIAS(sys_sync_file_range, SyS_sync_file_range);
+#endif
 
 /* It would be nice if people remember that not all the world's an i386
    when they introduce new system calls */
-asmlinkage long sys_sync_file_range2(int fd, unsigned int flags,
-				     loff_t offset, loff_t nbytes)
+SYSCALL_DEFINE(sync_file_range2)(int fd, unsigned int flags,
+				 loff_t offset, loff_t nbytes)
 {
 	return sys_sync_file_range(fd, offset, nbytes, flags);
 }
+#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
+asmlinkage long SyS_sync_file_range2(long fd, long flags,
+				     loff_t offset, loff_t nbytes)
+{
+	return SYSC_sync_file_range2((int) fd, (unsigned int) flags,
+				     offset, nbytes);
+}
+SYSCALL_ALIAS(sys_sync_file_range2, SyS_sync_file_range2);
+#endif
 
 /*
  * `endbyte' is inclusive
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -887,7 +887,7 @@ out_up:
 	return err;
 }
 
-asmlinkage long sys_semctl (int semid, int semnum, int cmd, union semun arg)
+SYSCALL_DEFINE(semctl)(int semid, int semnum, int cmd, union semun arg)
 {
 	int err = -EINVAL;
 	int version;
@@ -923,6 +923,13 @@ asmlinkage long sys_semctl (int semid, i
 		return -EINVAL;
 	}
 }
+#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
+asmlinkage long SyS_semctl(int semid, int semnum, int cmd, union semun arg)
+{
+	return SYSC_semctl((int) semid, (int) semnum, (int) cmd, arg);
+}
+SYSCALL_ALIAS(sys_semctl, SyS_semctl);
+#endif
 
 /* If the task doesn't already have a undo_list, then allocate one
  * here.  We guarantee there is only one thread using this undo list,
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -24,7 +24,7 @@
  * POSIX_FADV_WILLNEED could set PG_Referenced, and POSIX_FADV_NOREUSE could
  * deactivate the pages and clear PG_Referenced.
  */
-asmlinkage long sys_fadvise64_64(int fd, loff_t offset, loff_t len, int advice)
+SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
 {
 	struct file *file = fget(fd);
 	struct address_space *mapping;
@@ -126,12 +126,26 @@ out:
 	fput(file);
 	return ret;
 }
+#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
+asmlinkage long SyS_fadvise64_64(long fd, loff_t offset, loff_t len, long advice)
+{
+	return SYSC_fadvise64_64((int) fd, offset, len, (int) advice);
+}
+SYSCALL_ALIAS(sys_fadvise64_64, SyS_fadvise64_64);
+#endif
 
 #ifdef __ARCH_WANT_SYS_FADVISE64
 
-asmlinkage long sys_fadvise64(int fd, loff_t offset, size_t len, int advice)
+SYSCALL_DEFINE(fadvise64)(int fd, loff_t offset, size_t len, int advice)
 {
 	return sys_fadvise64_64(fd, offset, len, advice);
 }
+#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
+asmlinkage long SyS_fadvise64(long fd, loff_t offset, long len, long advice)
+{
+	return SYSC_fadvise64((int) fd, offset, (size_t)len, (int)advice);
+}
+SYSCALL_ALIAS(sys_fadvise64, SyS_fadvise64);
+#endif
 
 #endif
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1366,7 +1366,7 @@ do_readahead(struct address_space *mappi
 	return 0;
 }
 
-asmlinkage long sys_readahead(int fd, loff_t offset, size_t count)
+SYSCALL_DEFINE(readahead)(int fd, loff_t offset, size_t count)
 {
 	ssize_t ret;
 	struct file *file;
@@ -1385,6 +1385,13 @@ asmlinkage long sys_readahead(int fd, lo
 	}
 	return ret;
 }
+#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
+asmlinkage long SyS_readahead(long fd, loff_t offset, long count)
+{
+	return SYSC_readahead((int) fd, offset, (size_t) count);
+}
+SYSCALL_ALIAS(sys_readahead, SyS_readahead);
+#endif
 
 #ifdef CONFIG_MMU
 /**

