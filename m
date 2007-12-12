Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbXLLVW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbXLLVW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbXLLVWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:22:18 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:23859 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbXLLVWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:22:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GG48n93ZI1XJPWVEWIFN2jGYTf2D9M03vpXIm3s8pQvb9zGDLZ3wYPSaQ8M6NOo+CFiEFduO7jq+9NupWVmgLjFFTpCRzNmF0YyPaq1Jr0baoLBKHf96YkrwVwMWCNBuAxCq/egi4xw1nEwwOBu6nqbSff0rxiGqKwv7Ae7nJFY=
Subject: [PATCH] fs: remove fastcall, it is always empty
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 13:22:16 -0800
Message-Id: <1197494536.21291.26.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, I assume these are more appropriate to go through your tree.  Let
me know if you'd rather it go through someone else.

 fs/aio.c        |   17 ++++++++---------
 fs/buffer.c     |    6 +++---
 fs/fcntl.c      |    2 +-
 fs/file_table.c |    8 ++++----
 fs/namei.c      |   16 ++++++++--------
 fs/open.c       |    4 ++--
 6 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 8a37dbb..8a48ab0 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -317,7 +317,7 @@ out:
 /* wait_on_sync_kiocb:
  *	Waits on the given sync kiocb to complete.
  */
-ssize_t fastcall wait_on_sync_kiocb(struct kiocb *iocb)
+ssize_t wait_on_sync_kiocb(struct kiocb *iocb)
 {
 	while (iocb->ki_users) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
@@ -336,7 +336,7 @@ ssize_t fastcall wait_on_sync_kiocb(struct kiocb *iocb)
  * go away, they will call put_ioctx and release any pinned memory
  * associated with the request (held via struct page * references).
  */
-void fastcall exit_aio(struct mm_struct *mm)
+void exit_aio(struct mm_struct *mm)
 {
 	struct kioctx *ctx = mm->ioctx_list;
 	mm->ioctx_list = NULL;
@@ -365,7 +365,7 @@ void fastcall exit_aio(struct mm_struct *mm)
  *	Called when the last user of an aio context has gone away,
  *	and the struct needs to be freed.
  */
-void fastcall __put_ioctx(struct kioctx *ctx)
+void __put_ioctx(struct kioctx *ctx)
 {
 	unsigned nr_events = ctx->max_reqs;
 
@@ -397,8 +397,7 @@ void fastcall __put_ioctx(struct kioctx *ctx)
  * This prevents races between the aio code path referencing the
  * req (after submitting it) and aio_complete() freeing the req.
  */
-static struct kiocb *__aio_get_req(struct kioctx *ctx);
-static struct kiocb fastcall *__aio_get_req(struct kioctx *ctx)
+static struct kiocb *__aio_get_req(struct kioctx *ctx)
 {
 	struct kiocb *req = NULL;
 	struct aio_ring *ring;
@@ -533,7 +532,7 @@ static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
  *	Returns true if this put was the last user of the kiocb,
  *	false if the request is still in use.
  */
-int fastcall aio_put_req(struct kiocb *req)
+int aio_put_req(struct kiocb *req)
 {
 	struct kioctx *ctx = req->ki_ctx;
 	int ret;
@@ -893,7 +892,7 @@ static void try_queue_kicked_iocb(struct kiocb *iocb)
  *      The retry is usually executed by aio workqueue
  *      threads (See aio_kick_handler).
  */
-void fastcall kick_iocb(struct kiocb *iocb)
+void kick_iocb(struct kiocb *iocb)
 {
 	/* sync iocbs are easy: they can only ever be executing from a 
 	 * single context. */
@@ -912,7 +911,7 @@ EXPORT_SYMBOL(kick_iocb);
  *	Returns true if this is the last user of the request.  The 
  *	only other user of the request can be the cancellation code.
  */
-int fastcall aio_complete(struct kiocb *iocb, long res, long res2)
+int aio_complete(struct kiocb *iocb, long res, long res2)
 {
 	struct kioctx	*ctx = iocb->ki_ctx;
 	struct aio_ring_info	*info;
@@ -1523,7 +1522,7 @@ static int aio_wake_function(wait_queue_t *wait, unsigned mode,
 	return 1;
 }
 
-int fastcall io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
+int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 			 struct iocb *iocb)
 {
 	struct kiocb *req;
diff --git a/fs/buffer.c b/fs/buffer.c
index 7249e01..0fc1d51 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -67,14 +67,14 @@ static int sync_buffer(void *word)
 	return 0;
 }
 
-void fastcall __lock_buffer(struct buffer_head *bh)
+void __lock_buffer(struct buffer_head *bh)
 {
 	wait_on_bit_lock(&bh->b_state, BH_Lock, sync_buffer,
 							TASK_UNINTERRUPTIBLE);
 }
 EXPORT_SYMBOL(__lock_buffer);
 
-void fastcall unlock_buffer(struct buffer_head *bh)
+void unlock_buffer(struct buffer_head *bh)
 {
 	smp_mb__before_clear_bit();
 	clear_buffer_locked(bh);
@@ -1164,7 +1164,7 @@ __getblk_slow(struct block_device *bdev, sector_t block, int size)
  * mark_buffer_dirty() is atomic.  It takes bh->b_page->mapping->private_lock,
  * mapping->tree_lock and the global inode_lock.
  */
-void fastcall mark_buffer_dirty(struct buffer_head *bh)
+void mark_buffer_dirty(struct buffer_head *bh)
 {
 	WARN_ON_ONCE(!buffer_uptodate(bh));
 	if (!buffer_dirty(bh) && !test_set_buffer_dirty(bh))
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 8685263..603732a 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -24,7 +24,7 @@
 #include <asm/siginfo.h>
 #include <asm/uaccess.h>
 
-void fastcall set_close_on_exec(unsigned int fd, int flag)
+void set_close_on_exec(unsigned int fd, int flag)
 {
 	struct files_struct *files = current->files;
 	struct fdtable *fdt;
diff --git a/fs/file_table.c b/fs/file_table.c
index 664e3f2..6d27bef 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -197,7 +197,7 @@ int init_file(struct file *file, struct vfsmount *mnt, struct dentry *dentry,
 }
 EXPORT_SYMBOL(init_file);
 
-void fastcall fput(struct file *file)
+void fput(struct file *file)
 {
 	if (atomic_dec_and_test(&file->f_count))
 		__fput(file);
@@ -208,7 +208,7 @@ EXPORT_SYMBOL(fput);
 /* __fput is called from task context when aio completion releases the last
  * last use of a struct file *.  Do not use otherwise.
  */
-void fastcall __fput(struct file *file)
+void __fput(struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct vfsmount *mnt = file->f_path.mnt;
@@ -241,7 +241,7 @@ void fastcall __fput(struct file *file)
 	mntput(mnt);
 }
 
-struct file fastcall *fget(unsigned int fd)
+struct file *fget(unsigned int fd)
 {
 	struct file *file;
 	struct files_struct *files = current->files;
@@ -269,7 +269,7 @@ EXPORT_SYMBOL(fget);
  * and a flag is returned to be passed to the corresponding fput_light().
  * There must not be a cloning between an fget_light/fput_light pair.
  */
-struct file fastcall *fget_light(unsigned int fd, int *fput_needed)
+struct file *fget_light(unsigned int fd, int *fput_needed)
 {
 	struct file *file;
 	struct files_struct *files = current->files;
diff --git a/fs/namei.c b/fs/namei.c
index 3b993db..08b7997 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -106,7 +106,7 @@
  * any extra contention...
  */
 
-static int fastcall link_path_walk(const char *name, struct nameidata *nd);
+static int link_path_walk(const char *name, struct nameidata *nd);
 
 /* In order to reduce some races, while at the same time doing additional
  * checking and hopefully speeding things up, we copy filenames to the
@@ -823,7 +823,7 @@ fail:
  * Returns 0 and nd will have valid dentry and mnt on success.
  * Returns error and drops reference to input namei data on failure.
  */
-static fastcall int __link_path_walk(const char * name, struct nameidata *nd)
+static int __link_path_walk(const char * name, struct nameidata *nd)
 {
 	struct path next;
 	struct inode *inode;
@@ -1015,7 +1015,7 @@ return_err:
  * Retry the whole path once, forcing real lookup requests
  * instead of relying on the dcache.
  */
-static int fastcall link_path_walk(const char *name, struct nameidata *nd)
+static int link_path_walk(const char *name, struct nameidata *nd)
 {
 	struct nameidata save = *nd;
 	int result;
@@ -1039,7 +1039,7 @@ static int fastcall link_path_walk(const char *name, struct nameidata *nd)
 	return result;
 }
 
-static int fastcall path_walk(const char * name, struct nameidata *nd)
+static int path_walk(const char * name, struct nameidata *nd)
 {
 	current->total_link_count = 0;
 	return link_path_walk(name, nd);
@@ -1116,7 +1116,7 @@ set_it:
 }
 
 /* Returns 0 and nd will be valid on success; Retuns error, otherwise. */
-static int fastcall do_path_lookup(int dfd, const char *name,
+static int do_path_lookup(int dfd, const char *name,
 				unsigned int flags, struct nameidata *nd)
 {
 	int retval = 0;
@@ -1183,7 +1183,7 @@ fput_fail:
 	goto out_fail;
 }
 
-int fastcall path_lookup(const char *name, unsigned int flags,
+int path_lookup(const char *name, unsigned int flags,
 			struct nameidata *nd)
 {
 	return do_path_lookup(AT_FDCWD, name, flags, nd);
@@ -1409,7 +1409,7 @@ struct dentry *lookup_one_noperm(const char *name, struct dentry *base)
 	return __lookup_hash(&this, base, NULL);
 }
 
-int fastcall __user_walk_fd(int dfd, const char __user *name, unsigned flags,
+int __user_walk_fd(int dfd, const char __user *name, unsigned flags,
 			    struct nameidata *nd)
 {
 	char *tmp = getname(name);
@@ -1422,7 +1422,7 @@ int fastcall __user_walk_fd(int dfd, const char __user *name, unsigned flags,
 	return err;
 }
 
-int fastcall __user_walk(const char __user *name, unsigned flags, struct nameidata *nd)
+int __user_walk(const char __user *name, unsigned flags, struct nameidata *nd)
 {
 	return __user_walk_fd(AT_FDCWD, name, flags, nd);
 }
diff --git a/fs/open.c b/fs/open.c
index 4932b4d..b9d207f 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -991,7 +991,7 @@ static void __put_unused_fd(struct files_struct *files, unsigned int fd)
 		files->next_fd = fd;
 }
 
-void fastcall put_unused_fd(unsigned int fd)
+void put_unused_fd(unsigned int fd)
 {
 	struct files_struct *files = current->files;
 	spin_lock(&files->file_lock);
@@ -1014,7 +1014,7 @@ EXPORT_SYMBOL(put_unused_fd);
  * will follow.
  */
 
-void fastcall fd_install(unsigned int fd, struct file * file)
+void fd_install(unsigned int fd, struct file * file)
 {
 	struct files_struct *files = current->files;
 	struct fdtable *fdt;
-- 
1.5.3.7.2212.gd092



