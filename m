Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbZIONNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbZIONNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 09:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbZIONNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 09:13:48 -0400
Received: from verein.lst.de ([213.95.11.210]:58866 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588AbZIONNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 09:13:46 -0400
Date: Tue, 15 Sep 2009 15:12:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, drepper@redhat.com, viro@zeniv.linux.org.uk,
       kyle@mcmartin.ca, sct@redhat.com
Subject: [PATCH] implement posix O_SYNC and O_DSYNC semantics
Message-ID: <20090915131252.GA13754@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914165419.GD25549@duck.suse.cz>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While Linux provided an O_SYNC flag basically since day 1, it took until
Linux 2.4.0-test12pre2 to actually get it implemented for filesystems,
since that day we had generic_osync_around with only minor changes and the
great "For now, when the user asks for O_SYNC, we'll actually give O_DSYNC"
comment.  This patch intends to actually give us real O_SYNC semantics
in addition to the O_DSYNC semantics.  After Jan's O_SYNC patches which
are required before this patch it's actually surprisingly simple, we
just need to figure out when to set the datasync flag to vfs_fsync_range
and when not.

This patch renames the existing O_SYNC flag to O_DSYNC while keeping
it's numerical value to keep binary compatibility, and adds a new real
O_SYNC flag.  To guarantee backwards compatiblity it is defined as
expanding to both the O_DSYNC and the new additional binary flag
(__O_SYNC) to make sure we are backwards-compatible when compiled against
the new headers.

This also means that all places that don't care about the differences
can just check O_DSYNC and get the right behaviour for O_SYNC, too - only
places that actuall care need to check __O_SYNC in addition.  Drivers
and network filesystems have been updated in a fail safe way to always
do the full sync magic if O_DSYNC is set.  The few places setting O_SYNC
for lower layers are kept that way for now to stay failsafe.

We enforce that O_DSYNC is set when __O_SYNC is set early in the
open path to make sure we always get these sane options.

Note that parisc really fucked up their headers as they already define
a O_DSYNC that has always been a no-op.  We try to repair it by using it
for the new O_DSYNC and redefinining O_SYNC to send both the traditional
O_SYNC numerical value _and_ the O_DSYNC one.


Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>

Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c	2009-09-15 00:46:32.911256267 -0300
+++ linux-2.6/arch/x86/mm/pat.c	2009-09-15 09:41:27.301253948 -0300
@@ -541,7 +541,7 @@ int phys_mem_access_prot_allowed(struct 
 	if (!range_is_allowed(pfn, size))
 		return 0;
 
-	if (file->f_flags & O_SYNC) {
+	if (file->f_flags & O_DSYNC) {
 		flags = _PAGE_CACHE_UC_MINUS;
 	}
 
Index: linux-2.6/drivers/char/mem.c
===================================================================
--- linux-2.6.orig/drivers/char/mem.c	2009-09-15 00:46:33.096254330 -0300
+++ linux-2.6/drivers/char/mem.c	2009-09-15 09:41:27.302253936 -0300
@@ -44,7 +44,7 @@ static inline int uncached_access(struct
 {
 #if defined(CONFIG_IA64)
 	/*
-	 * On ia64, we ignore O_SYNC because we cannot tolerate memory attribute aliases.
+	 * On ia64, we ignore O_DSYNC because we cannot tolerate memory attribute aliases.
 	 */
 	return !(efi_mem_attributes(addr) & EFI_MEMORY_WB);
 #elif defined(CONFIG_MIPS)
@@ -57,9 +57,9 @@ static inline int uncached_access(struct
 #else
 	/*
 	 * Accessing memory above the top the kernel knows about or through a file pointer
-	 * that was marked O_SYNC will be done non-cached.
+	 * that was marked O_DSYNC will be done non-cached.
 	 */
-	if (file->f_flags & O_SYNC)
+	if (file->f_flags & O_DSYNC)
 		return 1;
 	return addr >= __pa(high_memory);
 #endif
Index: linux-2.6/drivers/staging/me4000/me4000.c
===================================================================
--- linux-2.6.orig/drivers/staging/me4000/me4000.c	2009-09-15 00:46:33.130254399 -0300
+++ linux-2.6/drivers/staging/me4000/me4000.c	2009-09-15 09:41:27.305253618 -0300
@@ -1985,8 +1985,8 @@ static ssize_t me4000_ao_write_cont(stru
 			spin_unlock_irqrestore(&ao_context->int_lock, flags);
 		}
 
-		/* Wait until the state machine is stopped if O_SYNC is set */
-		if (filep->f_flags & O_SYNC) {
+		/* Wait until the state machine is stopped if O_DSYNC is set */
+		if (filep->f_flags & O_DSYNC) {
 			while (inl(ao_context->status_reg) &
 			       ME4000_AO_STATUS_BIT_FSM) {
 				interruptible_sleep_on_timeout(&queue, 1);
Index: linux-2.6/drivers/usb/gadget/file_storage.c
===================================================================
--- linux-2.6.orig/drivers/usb/gadget/file_storage.c	2009-09-15 00:46:33.138253951 -0300
+++ linux-2.6/drivers/usb/gadget/file_storage.c	2009-09-15 09:41:27.311253752 -0300
@@ -1713,7 +1713,7 @@ static int do_write(struct fsg_dev *fsg)
 		}
 		if (fsg->cmnd[1] & 0x08) {	// FUA
 			spin_lock(&curlun->filp->f_lock);
-			curlun->filp->f_flags |= O_SYNC;
+			curlun->filp->f_flags |= O_DSYNC;
 			spin_unlock(&curlun->filp->f_lock);
 		}
 	}
Index: linux-2.6/fs/afs/write.c
===================================================================
--- linux-2.6.orig/fs/afs/write.c	2009-09-15 00:46:33.144254016 -0300
+++ linux-2.6/fs/afs/write.c	2009-09-15 09:41:27.316253550 -0300
@@ -692,8 +692,9 @@ ssize_t afs_file_write(struct kiocb *ioc
 	}
 
 	/* return error values for O_SYNC and IS_SYNC() */
-	if (IS_SYNC(&vnode->vfs_inode) || iocb->ki_filp->f_flags & O_SYNC) {
-		ret = afs_fsync(iocb->ki_filp, dentry, 1);
+	if (IS_SYNC(&vnode->vfs_inode) || iocb->ki_filp->f_flags & O_DSYNC) {
+		ret = afs_fsync(iocb->ki_filp, dentry,
+				(iocb->ki_filp->f_flags & __O_SYNC) ? 0 : 1);
 		if (ret < 0)
 			result = ret;
 	}
Index: linux-2.6/fs/btrfs/file.c
===================================================================
--- linux-2.6.orig/fs/btrfs/file.c	2009-09-15 00:46:33.151254279 -0300
+++ linux-2.6/fs/btrfs/file.c	2009-09-15 09:41:27.316253550 -0300
@@ -924,7 +924,7 @@ static ssize_t btrfs_file_write(struct f
 	unsigned long last_index;
 	int will_write;
 
-	will_write = ((file->f_flags & O_SYNC) || IS_SYNC(inode) ||
+	will_write = ((file->f_flags & O_DSYNC) || IS_SYNC(inode) ||
 		      (file->f_flags & O_DIRECT));
 
 	nrptrs = min((count + PAGE_CACHE_SIZE - 1) / PAGE_CACHE_SIZE,
@@ -1077,7 +1077,7 @@ out_nolock:
 		if (err)
 			num_written = err;
 
-		if ((file->f_flags & O_SYNC) || IS_SYNC(inode)) {
+		if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
 			trans = btrfs_start_transaction(root, 1);
 			ret = btrfs_log_dentry_safe(trans, root,
 						    file->f_dentry);
Index: linux-2.6/fs/cifs/dir.c
===================================================================
--- linux-2.6.orig/fs/cifs/dir.c	2009-09-15 00:46:33.156254147 -0300
+++ linux-2.6/fs/cifs/dir.c	2009-09-15 09:41:27.319254141 -0300
@@ -214,7 +214,8 @@ int cifs_posix_open(char *full_path, str
 		posix_flags |= SMB_O_TRUNC;
 	if (oflags & O_APPEND)
 		posix_flags |= SMB_O_APPEND;
-	if (oflags & O_SYNC)
+	/* be safe and imply O_SYNC for O_DSYNC */
+	if (oflags & O_DSYNC)
 		posix_flags |= SMB_O_SYNC;
 	if (oflags & O_DIRECTORY)
 		posix_flags |= SMB_O_DIRECTORY;
Index: linux-2.6/fs/cifs/file.c
===================================================================
--- linux-2.6.orig/fs/cifs/file.c	2009-09-15 00:46:33.162254422 -0300
+++ linux-2.6/fs/cifs/file.c	2009-09-15 09:41:27.323254719 -0300
@@ -96,8 +96,10 @@ static inline fmode_t cifs_posix_convert
 	   reopening a file.  They had their effect on the original open */
 	if (flags & O_APPEND)
 		posix_flags |= (fmode_t)O_APPEND;
-	if (flags & O_SYNC)
-		posix_flags |= (fmode_t)O_SYNC;
+	if (flags & O_DSYNC)
+		posix_flags |= (fmode_t)O_DSYNC;
+	if (flags & __O_SYNC)
+		posix_flags |= (fmode_t)__O_SYNC;
 	if (flags & O_DIRECTORY)
 		posix_flags |= (fmode_t)O_DIRECTORY;
 	if (flags & O_NOFOLLOW)
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2009-09-15 00:46:33.168253161 -0300
+++ linux-2.6/fs/namei.c	2009-09-15 09:45:26.694256679 -0300
@@ -1678,6 +1678,15 @@ struct file *do_filp_open(int dfd, const
 	int will_write;
 	int flag = open_to_namei_flags(open_flag);
 
+	/*
+	 * O_SYNC is implemented as __O_SYNC|O_DSYNC.  As many places only
+	 * check for O_DSYNC if the need any syncing at all we enforce it's
+	 * always set instead of having to deal with possibly weird behaviour
+	 * for malicious applications setting only __O_SYNC.
+	 */
+	if (open_flag & __O_SYNC)
+		open_flag |= O_DSYNC;
+
 	if (!acc_mode)
 		acc_mode = MAY_OPEN | ACC_MODE(flag);
 
Index: linux-2.6/fs/nfs/file.c
===================================================================
--- linux-2.6.orig/fs/nfs/file.c	2009-09-15 00:46:33.174254134 -0300
+++ linux-2.6/fs/nfs/file.c	2009-09-15 09:41:27.330253653 -0300
@@ -580,7 +580,7 @@ static int nfs_need_sync_write(struct fi
 {
 	struct nfs_open_context *ctx;
 
-	if (IS_SYNC(inode) || (filp->f_flags & O_SYNC))
+	if (IS_SYNC(inode) || (filp->f_flags & O_DSYNC))
 		return 1;
 	ctx = nfs_file_open_context(filp);
 	if (test_bit(NFS_CONTEXT_ERROR_WRITE, &ctx->flags))
@@ -621,7 +621,7 @@ static ssize_t nfs_file_write(struct kio
 
 	nfs_add_stats(inode, NFSIOS_NORMALWRITTENBYTES, count);
 	result = generic_file_aio_write(iocb, iov, nr_segs, pos);
-	/* Return error values for O_SYNC and IS_SYNC() */
+	/* Return error values for O_DSYNC and IS_SYNC() */
 	if (result >= 0 && nfs_need_sync_write(iocb->ki_filp, inode)) {
 		int err = nfs_do_fsync(nfs_file_open_context(iocb->ki_filp), inode);
 		if (err < 0)
Index: linux-2.6/fs/nfs/write.c
===================================================================
--- linux-2.6.orig/fs/nfs/write.c	2009-09-15 00:46:33.180254200 -0300
+++ linux-2.6/fs/nfs/write.c	2009-09-15 09:41:27.332254187 -0300
@@ -774,7 +774,7 @@ int nfs_updatepage(struct file *file, st
 	 */
 	if (nfs_write_pageuptodate(page, inode) &&
 			inode->i_flock == NULL &&
-			!(file->f_flags & O_SYNC)) {
+			!(file->f_flags & O_DSYNC)) {
 		count = max(count + offset, nfs_page_length(page));
 		offset = 0;
 	}
Index: linux-2.6/include/asm-generic/fcntl.h
===================================================================
--- linux-2.6.orig/include/asm-generic/fcntl.h	2009-09-15 00:46:33.211253817 -0300
+++ linux-2.6/include/asm-generic/fcntl.h	2009-09-15 09:41:27.335253940 -0300
@@ -3,8 +3,6 @@
 
 #include <linux/types.h>
 
-/* open/fcntl - O_SYNC is only implemented on blocks devices and on files
-   located on an ext2 file system */
 #define O_ACCMODE	00000003
 #define O_RDONLY	00000000
 #define O_WRONLY	00000001
@@ -27,8 +25,8 @@
 #ifndef O_NONBLOCK
 #define O_NONBLOCK	00004000
 #endif
-#ifndef O_SYNC
-#define O_SYNC		00010000
+#ifndef O_DSYNC
+#define O_DSYNC		00010000	/* used to be O_SYNC, see below */
 #endif
 #ifndef FASYNC
 #define FASYNC		00020000	/* fcntl, for BSD compatibility */
@@ -51,6 +49,25 @@
 #ifndef O_CLOEXEC
 #define O_CLOEXEC	02000000	/* set close_on_exec */
 #endif
+
+/*
+ * Before Linux 2.6.32 only O_DSYNC semantics were implemented, but using
+ * the O_SYNC flag.  We continue to use the existing numerical value
+ * for O_DSYNC semantics now, but using the correct symbolic name for it.
+ * This new value is used to request true Posix O_SYNC semantics.  It is
+ * defined in this strange way to make sure applications compiled against
+ * new headers get at least O_DSYNC semantics on older kernels.
+ *
+ * This has the nice side-effect that we can simply test for O_DSYNC
+ * wherever we do not care if O_DSYNC or O_SYNC is used.
+ *
+ * Note: __O_SYNC must never be used directly.
+ */
+#ifndef O_SYNC
+#define __O_SYNC	04000000
+#define O_SYNC		(__O_SYNC|O_DSYNC)
+#endif
+
 #ifndef O_NDELAY
 #define O_NDELAY	O_NONBLOCK
 #endif
Index: linux-2.6/fs/ocfs2/file.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/file.c	2009-09-15 00:46:33.186253776 -0300
+++ linux-2.6/fs/ocfs2/file.c	2009-09-15 09:41:27.338254042 -0300
@@ -1878,7 +1878,7 @@ out_dio:
 	/* buffered aio wouldn't have proper lock coverage today */
 	BUG_ON(ret == -EIOCBQUEUED && !(file->f_flags & O_DIRECT));
 
-	if ((file->f_flags & O_SYNC && !direct_io) || IS_SYNC(inode)) {
+	if ((file->f_flags & O_DSYNC && !direct_io) || IS_SYNC(inode)) {
 		ret = filemap_fdatawrite_range(file->f_mapping, pos,
 					       pos + count - 1);
 		if (ret < 0)
Index: linux-2.6/fs/ubifs/file.c
===================================================================
--- linux-2.6.orig/fs/ubifs/file.c	2009-09-15 00:46:33.192253912 -0300
+++ linux-2.6/fs/ubifs/file.c	2009-09-15 09:41:27.341254213 -0300
@@ -1403,7 +1403,7 @@ static ssize_t ubifs_aio_write(struct ki
 	if (ret < 0)
 		return ret;
 
-	if (ret > 0 && (IS_SYNC(inode) || iocb->ki_filp->f_flags & O_SYNC)) {
+	if (ret > 0 && (IS_SYNC(inode) || iocb->ki_filp->f_flags & O_DSYNC)) {
 		err = ubifs_sync_wbufs_by_inode(c, inode);
 		if (err)
 			return err;
Index: linux-2.6/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_lrw.c	2009-09-15 00:46:33.198253488 -0300
+++ linux-2.6/fs/xfs/linux-2.6/xfs_lrw.c	2009-09-15 09:41:27.344254176 -0300
@@ -811,7 +811,7 @@ write_retry:
 	XFS_STATS_ADD(xs_write_bytes, ret);
 
 	/* Handle various SYNC-type writes */
-	if ((file->f_flags & O_SYNC) || IS_SYNC(inode)) {
+	if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
 		int error2;
 
 		xfs_iunlock(xip, iolock);
Index: linux-2.6/sound/core/rawmidi.c
===================================================================
--- linux-2.6.orig/sound/core/rawmidi.c	2009-09-15 00:46:33.219253718 -0300
+++ linux-2.6/sound/core/rawmidi.c	2009-09-15 09:41:27.347253859 -0300
@@ -1258,7 +1258,7 @@ static ssize_t snd_rawmidi_write(struct 
 			break;
 		count -= count1;
 	}
-	if (file->f_flags & O_SYNC) {
+	if (file->f_flags & O_DSYNC) {
 		spin_lock_irq(&runtime->lock);
 		while (runtime->avail != runtime->buffer_size) {
 			wait_queue_t wait;
Index: linux-2.6/arch/alpha/include/asm/fcntl.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/fcntl.h	2009-09-15 00:46:32.945006724 -0300
+++ linux-2.6/arch/alpha/include/asm/fcntl.h	2009-09-15 09:41:27.348253497 -0300
@@ -1,8 +1,6 @@
 #ifndef _ALPHA_FCNTL_H
 #define _ALPHA_FCNTL_H
 
-/* open/fcntl - O_SYNC is only implemented on blocks devices and on files
-   located on an ext2 file system */
 #define O_CREAT		 01000	/* not fcntl */
 #define O_TRUNC		 02000	/* not fcntl */
 #define O_EXCL		 04000	/* not fcntl */
@@ -10,13 +8,28 @@
 
 #define O_NONBLOCK	 00004
 #define O_APPEND	 00010
-#define O_SYNC		040000
+#define O_DSYNC		040000	/* used to be O_SYNC, see below */
 #define O_DIRECTORY	0100000	/* must be a directory */
 #define O_NOFOLLOW	0200000 /* don't follow links */
 #define O_LARGEFILE	0400000 /* will be set by the kernel on every open */
 #define O_DIRECT	02000000 /* direct disk access - should check with OSF/1 */
 #define O_NOATIME	04000000
 #define O_CLOEXEC	010000000 /* set close_on_exec */
+/*
+ * Before Linux 2.6.32 only O_DSYNC semantics were implemented, but using
+ * the O_SYNC flag.  We continue to use the existing numerical value
+ * for O_DSYNC semantics now, but using the correct symbolic name for it.
+ * This new value is used to request true Posix O_SYNC semantics.  It is
+ * defined in this strange way to make sure applications compiled against
+ * new headers get at least O_DSYNC semantics on older kernels.
+ *
+ * This has the nice side-effect that we can simply test for O_DSYNC
+ * wherever we do not care if O_DSYNC or O_SYNC is used.
+ *
+ * Note: __O_SYNC must never be used directly.
+ */
+#define __O_SYNC	020000000
+#define O_SYNC		(__O_SYNC|O_DSYNC)
 
 #define F_GETLK		7
 #define F_SETLK		8
Index: linux-2.6/arch/blackfin/include/asm/fcntl.h
===================================================================
--- linux-2.6.orig/arch/blackfin/include/asm/fcntl.h	2009-09-15 00:46:32.978006455 -0300
+++ linux-2.6/arch/blackfin/include/asm/fcntl.h	2009-09-15 09:41:27.351254088 -0300
@@ -1,8 +1,6 @@
 #ifndef _BFIN_FCNTL_H
 #define _BFIN_FCNTL_H
 
-/* open/fcntl - O_SYNC is only implemented on blocks devices and on files
-   located on an ext2 file system */
 #define O_DIRECTORY	 040000	/* must be a directory */
 #define O_NOFOLLOW	0100000	/* don't follow links */
 #define O_DIRECT	0200000	/* direct disk access hint - currently ignored */
Index: linux-2.6/arch/mips/include/asm/fcntl.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/fcntl.h	2009-09-15 00:46:33.002006368 -0300
+++ linux-2.6/arch/mips/include/asm/fcntl.h	2009-09-15 09:41:27.354254050 -0300
@@ -10,7 +10,7 @@
 
 
 #define O_APPEND	0x0008
-#define O_SYNC		0x0010
+#define O_DSYNC		0x0010	/* used to be O_SYNC, see below */
 #define O_NONBLOCK	0x0080
 #define O_CREAT         0x0100	/* not fcntl */
 #define O_TRUNC		0x0200	/* not fcntl */
@@ -18,6 +18,21 @@
 #define O_NOCTTY	0x0800	/* not fcntl */
 #define FASYNC		0x1000	/* fcntl, for BSD compatibility */
 #define O_LARGEFILE	0x2000	/* allow large file opens */
+/*
+ * Before Linux 2.6.32 only O_DSYNC semantics were implemented, but using
+ * the O_SYNC flag.  We continue to use the existing numerical value
+ * for O_DSYNC semantics now, but using the correct symbolic name for it.
+ * This new value is used to request true Posix O_SYNC semantics.  It is
+ * defined in this strange way to make sure applications compiled against
+ * new headers get at least O_DSYNC semantics on older kernels.
+ *
+ * This has the nice side-effect that we can simply test for O_DSYNC
+ * wherever we do not care if O_DSYNC or O_SYNC is used.
+ *
+ * Note: __O_SYNC must never be used directly.
+ */
+#define __O_SYNC	0x4000
+#define O_SYNC		(__O_SYNC|O_DSYNC)
 #define O_DIRECT	0x8000	/* direct disk access hint */
 
 #define F_GETLK		14
Index: linux-2.6/arch/mips/kernel/kspd.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/kspd.c	2009-09-15 00:46:33.021004807 -0300
+++ linux-2.6/arch/mips/kernel/kspd.c	2009-09-15 09:41:27.357254082 -0300
@@ -82,6 +82,7 @@ static int sp_stopping = 0;
 #define MTSP_O_SHLOCK		0x0010
 #define MTSP_O_EXLOCK		0x0020
 #define MTSP_O_ASYNC		0x0040
+/* XXX: check which of these is actually O_SYNC vs O_DSYNC */
 #define MTSP_O_FSYNC		O_SYNC
 #define MTSP_O_NOFOLLOW		0x0100
 #define MTSP_O_SYNC		0x0080
Index: linux-2.6/arch/mips/lemote/lm2e/mem.c
===================================================================
--- linux-2.6.orig/arch/mips/lemote/lm2e/mem.c	2009-09-15 00:46:33.054254081 -0300
+++ linux-2.6/arch/mips/lemote/lm2e/mem.c	2009-09-15 09:41:27.357254082 -0300
@@ -11,7 +11,7 @@
 /* override of arch/mips/mm/cache.c: __uncached_access */
 int __uncached_access(struct file *file, unsigned long addr)
 {
-	if (file->f_flags & O_SYNC)
+	if (file->f_flags & O_DSYNC)
 		return 1;
 
 	/*
Index: linux-2.6/arch/mips/mm/cache.c
===================================================================
--- linux-2.6.orig/arch/mips/mm/cache.c	2009-09-15 00:46:33.074254183 -0300
+++ linux-2.6/arch/mips/mm/cache.c	2009-09-15 09:41:27.360254044 -0300
@@ -194,7 +194,7 @@ void __devinit cpu_cache_init(void)
 
 int __weak __uncached_access(struct file *file, unsigned long addr)
 {
-	if (file->f_flags & O_SYNC)
+	if (file->f_flags & O_DSYNC)
 		return 1;
 
 	return addr >= __pa(high_memory);
Index: linux-2.6/arch/parisc/include/asm/fcntl.h
===================================================================
--- linux-2.6.orig/arch/parisc/include/asm/fcntl.h	2009-09-15 00:46:33.082254364 -0300
+++ linux-2.6/arch/parisc/include/asm/fcntl.h	2009-09-15 09:41:27.363254007 -0300
@@ -1,14 +1,13 @@
 #ifndef _PARISC_FCNTL_H
 #define _PARISC_FCNTL_H
 
-/* open/fcntl - O_SYNC is only implemented on blocks devices and on files
-   located on an ext2 file system */
 #define O_APPEND	000000010
 #define O_BLKSEEK	000000100 /* HPUX only */
 #define O_CREAT		000000400 /* not fcntl */
 #define O_EXCL		000002000 /* not fcntl */
 #define O_LARGEFILE	000004000
-#define O_SYNC		000100000
+#define __O_SYNC	000100000
+#define O_SYNC		(__O_SYNC|O_DSYNC)
 #define O_NONBLOCK	000200004 /* HPUX has separate NDELAY & NONBLOCK */
 #define O_NOCTTY	000400000 /* not fcntl */
 #define O_DSYNC		001000000 /* HPUX only */
Index: linux-2.6/arch/sparc/include/asm/fcntl.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/fcntl.h	2009-09-15 00:46:33.090254335 -0300
+++ linux-2.6/arch/sparc/include/asm/fcntl.h	2009-09-15 09:41:27.367253956 -0300
@@ -1,14 +1,12 @@
 #ifndef _SPARC_FCNTL_H
 #define _SPARC_FCNTL_H
 
-/* open/fcntl - O_SYNC is only implemented on blocks devices and on files
-   located on an ext2 file system */
 #define O_APPEND	0x0008
 #define FASYNC		0x0040	/* fcntl, for BSD compatibility */
 #define O_CREAT		0x0200	/* not fcntl */
 #define O_TRUNC		0x0400	/* not fcntl */
 #define O_EXCL		0x0800	/* not fcntl */
-#define O_SYNC		0x2000
+#define O_DSYNC		0x2000	/* used to be O_SYNC, see below */
 #define O_NONBLOCK	0x4000
 #if defined(__sparc__) && defined(__arch64__)
 #define O_NDELAY	0x0004
@@ -20,6 +18,21 @@
 #define O_DIRECT        0x100000 /* direct disk access hint */
 #define O_NOATIME	0x200000
 #define O_CLOEXEC	0x400000
+/*
+ * Before Linux 2.6.32 only O_DSYNC semantics were implemented, but using
+ * the O_SYNC flag.  We continue to use the existing numerical value
+ * for O_DSYNC semantics now, but using the correct symbolic name for it.
+ * This new value is used to request true Posix O_SYNC semantics.  It is
+ * defined in this strange way to make sure applications compiled against
+ * new headers get at least O_DSYNC semantics on older kernels.
+ *
+ * This has the nice side-effect that we can simply test for O_DSYNC
+ * wherever we do not care if O_DSYNC or O_SYNC is used.
+ *
+ * Note: __O_SYNC must never be used directly.
+ */
+#define __O_SYNC	0x800000
+#define O_SYNC		(__O_SYNC|O_DSYNC)
 
 #define F_GETOWN	5	/*  for sockets. */
 #define F_SETOWN	6	/*  for sockets. */
Index: linux-2.6/fs/sync.c
===================================================================
--- linux-2.6.orig/fs/sync.c	2009-09-15 00:46:33.205253612 -0300
+++ linux-2.6/fs/sync.c	2009-09-15 09:41:27.370254058 -0300
@@ -287,10 +287,11 @@ SYSCALL_DEFINE1(fdatasync, unsigned int,
  */
 int generic_write_sync(struct file *file, loff_t pos, loff_t count)
 {
-	if (!(file->f_flags & O_SYNC) && !IS_SYNC(file->f_mapping->host))
+	if (!(file->f_flags & O_DSYNC) && !IS_SYNC(file->f_mapping->host))
 		return 0;
 	return vfs_fsync_range(file, file->f_path.dentry, pos,
-			       pos + count - 1, 1);
+			       pos + count - 1,
+			       (file->f_flags & __O_SYNC) ? 0 : 1);
 }
 EXPORT_SYMBOL(generic_write_sync);
 
