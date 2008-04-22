Return-Path: <linux-kernel-owner+w=401wt.eu-S933475AbYDVNyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475AbYDVNyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763089AbYDVNyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:54:35 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:38904 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764502AbYDVNye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:54:34 -0400
Date: Tue, 22 Apr 2008 22:54:33 +0900 (JST)
Message-Id: <20080422.225433.113622843.taka@valinux.co.jp>
To: jens.axboe@oracle.com, agk@sourceware.org
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 4/10] I/O context inheritance
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <20080422.224935.00673711.taka@valinux.co.jp>
References: <20080422.224935.00673711.taka@valinux.co.jp>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make the aio kernel thread work on the iocontext of the process
which request an I/O.


Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>


--- linux-2.6.25.bio0/include/linux/aio.h	2008-04-22 15:48:36.000000000 +0900
+++ linux-2.6.25/include/linux/aio.h	2008-04-22 15:52:07.000000000 +0900
@@ -181,6 +181,7 @@ struct kioctx {
 	atomic_t		users;
 	int			dead;
 	struct mm_struct	*mm;
+	struct io_context	*io_context;
 
 	/* This needs improving */
 	unsigned long		user_id;
--- linux-2.6.25.bio0/fs/aio.c	2008-04-22 15:48:31.000000000 +0900
+++ linux-2.6.25/fs/aio.c	2008-04-22 15:52:07.000000000 +0900
@@ -31,6 +31,7 @@
 #include <linux/workqueue.h>
 #include <linux/security.h>
 #include <linux/eventfd.h>
+#include <linux/blkdev.h>
 
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
@@ -217,6 +218,10 @@ static struct kioctx *ioctx_alloc(unsign
 	mm = ctx->mm = current->mm;
 	atomic_inc(&mm->mm_count);
 
+	ctx->io_context = get_io_context(GFP_KERNEL, -1);
+	if (!ctx->io_context)
+		goto out_freectx2;
+
 	atomic_set(&ctx->users, 1);
 	spin_lock_init(&ctx->ctx_lock);
 	spin_lock_init(&ctx->ring_info.ring_lock);
@@ -255,6 +260,8 @@ out_cleanup:
 	return ERR_PTR(-EAGAIN);
 
 out_freectx:
+	put_io_context(ctx->io_context);
+out_freectx2:
 	mmdrop(mm);
 	kmem_cache_free(kioctx_cachep, ctx);
 	ctx = ERR_PTR(-ENOMEM);
@@ -376,6 +383,7 @@ void __put_ioctx(struct kioctx *ctx)
 	aio_free_ring(ctx);
 	mmdrop(ctx->mm);
 	ctx->mm = NULL;
+	put_io_context(ctx->io_context);
 	pr_debug("__put_ioctx: freeing %p\n", ctx);
 	kmem_cache_free(kioctx_cachep, ctx);
 
@@ -841,6 +849,7 @@ static void aio_kick_handler(struct work
 	struct mm_struct *mm;
 	int requeue;
 
+	current->io_context = ctx->io_context;
 	set_fs(USER_DS);
 	use_mm(ctx->mm);
 	spin_lock_irq(&ctx->ctx_lock);
@@ -849,6 +858,7 @@ static void aio_kick_handler(struct work
 	spin_unlock_irq(&ctx->ctx_lock);
  	unuse_mm(mm);
 	set_fs(oldfs);
+	current->io_context = NULL;
 	/*
 	 * we're in a worker thread already, don't use queue_delayed_work,
 	 */
