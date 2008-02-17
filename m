Return-Path: <linux-kernel-owner+w=401wt.eu-S1758561AbYBQITl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561AbYBQITl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757526AbYBQIRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:17:53 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59609 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146AbYBQIRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:17:51 -0500
Date: Sun, 17 Feb 2008 10:17:25 +0200
From: Adrian Bunk <bunk@kernel.org>
To: bcrl@kvack.org
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/aio.c: make 3 functions static
Message-ID: <20080217081725.GG3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- __put_ioctx()
- lookup_ioctx()
- io_submit_one()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/aio.c            |   67 +++++++++++++++++++++++++-------------------
 include/linux/aio.h |   19 ------------
 2 files changed, 39 insertions(+), 47 deletions(-)

22e146f657e1ec7b223c1415e343f0880441e624 diff --git a/fs/aio.c b/fs/aio.c
index b74c567..777e27a 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -191,6 +191,43 @@ static int aio_setup_ring(struct kioctx *ctx)
 	kunmap_atomic((void *)((unsigned long)__event & PAGE_MASK), km); \
 } while(0)
 
+
+/* __put_ioctx
+ *	Called when the last user of an aio context has gone away,
+ *	and the struct needs to be freed.
+ */
+static void __put_ioctx(struct kioctx *ctx)
+{
+	unsigned nr_events = ctx->max_reqs;
+
+	BUG_ON(ctx->reqs_active);
+
+	cancel_delayed_work(&ctx->wq);
+	cancel_work_sync(&ctx->wq.work);
+	aio_free_ring(ctx);
+	mmdrop(ctx->mm);
+	ctx->mm = NULL;
+	pr_debug("__put_ioctx: freeing %p\n", ctx);
+	kmem_cache_free(kioctx_cachep, ctx);
+
+	if (nr_events) {
+		spin_lock(&aio_nr_lock);
+		BUG_ON(aio_nr - nr_events > aio_nr);
+		aio_nr -= nr_events;
+		spin_unlock(&aio_nr_lock);
+	}
+}
+
+#define get_ioctx(kioctx) do {						\
+	BUG_ON(atomic_read(&(kioctx)->users) <= 0);			\
+	atomic_inc(&(kioctx)->users);					\
+} while (0)
+#define put_ioctx(kioctx) do {						\
+	BUG_ON(atomic_read(&(kioctx)->users) <= 0);			\
+	if (unlikely(atomic_dec_and_test(&(kioctx)->users))) 		\
+		__put_ioctx(kioctx);					\
+} while (0)
+
 /* ioctx_alloc
  *	Allocates and initializes an ioctx.  Returns an ERR_PTR if it failed.
  */
@@ -361,32 +398,6 @@ void exit_aio(struct mm_struct *mm)
 	}
 }
 
-/* __put_ioctx
- *	Called when the last user of an aio context has gone away,
- *	and the struct needs to be freed.
- */
-void __put_ioctx(struct kioctx *ctx)
-{
-	unsigned nr_events = ctx->max_reqs;
-
-	BUG_ON(ctx->reqs_active);
-
-	cancel_delayed_work(&ctx->wq);
-	cancel_work_sync(&ctx->wq.work);
-	aio_free_ring(ctx);
-	mmdrop(ctx->mm);
-	ctx->mm = NULL;
-	pr_debug("__put_ioctx: freeing %p\n", ctx);
-	kmem_cache_free(kioctx_cachep, ctx);
-
-	if (nr_events) {
-		spin_lock(&aio_nr_lock);
-		BUG_ON(aio_nr - nr_events > aio_nr);
-		aio_nr -= nr_events;
-		spin_unlock(&aio_nr_lock);
-	}
-}
-
 /* aio_get_req
  *	Allocate a slot for an aio request.  Increments the users count
  * of the kioctx so that the kioctx stays around until all requests are
@@ -545,7 +556,7 @@ int aio_put_req(struct kiocb *req)
 /*	Lookup an ioctx id.  ioctx_list is lockless for reads.
  *	FIXME: this is O(n) and is only suitable for development.
  */
-struct kioctx *lookup_ioctx(unsigned long ctx_id)
+static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 {
 	struct kioctx *ioctx;
 	struct mm_struct *mm;
@@ -1533,7 +1544,7 @@ static int aio_wake_function(wait_queue_t *wait, unsigned mode,
 	return 1;
 }
 
-int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
+static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 			 struct iocb *iocb)
 {
 	struct kiocb *req;
diff --git a/include/linux/aio.h b/include/linux/aio.h
index a9931e2..cf0f82b 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -210,27 +210,8 @@ extern ssize_t wait_on_sync_kiocb(struct kiocb *iocb);
 extern int aio_put_req(struct kiocb *iocb);
 extern void kick_iocb(struct kiocb *iocb);
 extern int aio_complete(struct kiocb *iocb, long res, long res2);
-extern void __put_ioctx(struct kioctx *ctx);
 struct mm_struct;
 extern void exit_aio(struct mm_struct *mm);
-extern struct kioctx *lookup_ioctx(unsigned long ctx_id);
-extern int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
-			 struct iocb *iocb);
-
-/* semi private, but used by the 32bit emulations: */
-struct kioctx *lookup_ioctx(unsigned long ctx_id);
-int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
-		  struct iocb *iocb);
-
-#define get_ioctx(kioctx) do {						\
-	BUG_ON(atomic_read(&(kioctx)->users) <= 0);			\
-	atomic_inc(&(kioctx)->users);					\
-} while (0)
-#define put_ioctx(kioctx) do {						\
-	BUG_ON(atomic_read(&(kioctx)->users) <= 0);			\
-	if (unlikely(atomic_dec_and_test(&(kioctx)->users))) 		\
-		__put_ioctx(kioctx);					\
-} while (0)
 
 #define io_wait_to_kiocb(wait) container_of(wait, struct kiocb, ki_wait)
 

