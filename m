Return-Path: <linux-kernel-owner+w=401wt.eu-S933336AbYEVVW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336AbYEVVW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759426AbYEVVVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:21:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758429AbYEVVVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:21:43 -0400
Date: Thu, 22 May 2008 17:20:23 -0400
From: Jason Baron <jbaron@redhat.com>
To: akpm@linux-foundation.org, joe@perches.com, greg@kroah.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] debug printk infrastructure -convert aio dprintk -> pr_debug
Message-ID: <20080522212016.GH28070@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 fs/aio.c |   34 ++++++++++++++--------------------
 1 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 2283686..b6f3b33 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -36,12 +36,6 @@
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
 
-#if DEBUG > 1
-#define dprintk		printk
-#else
-#define dprintk(x...)	do { ; } while (0)
-#endif
-
 /*------ sysctl variables----*/
 static DEFINE_SPINLOCK(aio_nr_lock);
 unsigned long aio_nr;		/* current system wide number of aio requests */
@@ -128,7 +122,7 @@ static int aio_setup_ring(struct kioctx *ctx)
 	}
 
 	info->mmap_size = nr_pages * PAGE_SIZE;
-	dprintk("attempting mmap of %lu bytes\n", info->mmap_size);
+	pr_debug("attempting mmap of %lu bytes\n", info->mmap_size);
 	down_write(&ctx->mm->mmap_sem);
 	info->mmap_base = do_mmap(NULL, 0, info->mmap_size, 
 				  PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE,
@@ -140,7 +134,7 @@ static int aio_setup_ring(struct kioctx *ctx)
 		return -EAGAIN;
 	}
 
-	dprintk("mmap address: 0x%08lx\n", info->mmap_base);
+	pr_debug("mmap address: 0x%08lx\n", info->mmap_base);
 	info->nr_pages = get_user_pages(current, ctx->mm,
 					info->mmap_base, nr_pages, 
 					1, 0, info->ring_pages, NULL);
@@ -246,7 +240,7 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	mm->ioctx_list = ctx;
 	write_unlock(&mm->ioctx_list_lock);
 
-	dprintk("aio: allocated ioctx %p[%ld]: mm=%p mask=0x%x\n",
+	pr_debug("aio: allocated ioctx %p[%ld]: mm=%p mask=0x%x\n",
 		ctx, ctx->user_id, current->mm, ctx->ring_info.nr);
 	return ctx;
 
@@ -259,7 +253,7 @@ out_freectx:
 	kmem_cache_free(kioctx_cachep, ctx);
 	ctx = ERR_PTR(-ENOMEM);
 
-	dprintk("aio: error allocating ioctx %p\n", ctx);
+	pr_debug("aio: error allocating ioctx %p\n", ctx);
 	return ctx;
 }
 
@@ -501,7 +495,7 @@ static void aio_fput_routine(struct work_struct *data)
  */
 static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 {
-	dprintk(KERN_DEBUG "aio_put(%p): f_count=%d\n",
+	pr_debug(KERN_DEBUG "aio_put(%p): f_count=%d\n",
 		req, atomic_read(&req->ki_filp->f_count));
 
 	assert_spin_locked(&ctx->ctx_lock);
@@ -968,7 +962,7 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 	event->res = res;
 	event->res2 = res2;
 
-	dprintk("aio_complete: %p[%lu]: %p: %p %Lx %lx %lx\n",
+	pr_debug("aio_complete: %p[%lu]: %p: %p %Lx %lx %lx\n",
 		ctx, tail, iocb, iocb->ki_obj.user, iocb->ki_user_data,
 		res, res2);
 
@@ -1026,7 +1020,7 @@ static int aio_read_evt(struct kioctx *ioctx, struct io_event *ent)
 	int ret = 0;
 
 	ring = kmap_atomic(info->ring_pages[0], KM_USER0);
-	dprintk("in aio_read_evt h%lu t%lu m%lu\n",
+	pr_debug("in aio_read_evt h%lu t%lu m%lu\n",
 		 (unsigned long)ring->head, (unsigned long)ring->tail,
 		 (unsigned long)ring->nr);
 
@@ -1049,7 +1043,7 @@ static int aio_read_evt(struct kioctx *ioctx, struct io_event *ent)
 
 out:
 	kunmap_atomic(ring, KM_USER0);
-	dprintk("leaving aio_read_evt: %d  h%lu t%lu\n", ret,
+	pr_debug("leaving aio_read_evt: %d  h%lu t%lu\n", ret,
 		 (unsigned long)ring->head, (unsigned long)ring->tail);
 	return ret;
 }
@@ -1117,13 +1111,13 @@ retry:
 		if (unlikely(ret <= 0))
 			break;
 
-		dprintk("read event: %Lx %Lx %Lx %Lx\n",
+		pr_debug("read event: %Lx %Lx %Lx %Lx\n",
 			ent.data, ent.obj, ent.res, ent.res2);
 
 		/* Could we split the check in two? */
 		ret = -EFAULT;
 		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
-			dprintk("aio: lost an event due to EFAULT.\n");
+			pr_debug("aio: lost an event due to EFAULT.\n");
 			break;
 		}
 		ret = 0;
@@ -1190,7 +1184,7 @@ retry:
 
 		ret = -EFAULT;
 		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
-			dprintk("aio: lost an event due to EFAULT.\n");
+			pr_debug("aio: lost an event due to EFAULT.\n");
 			break;
 		}
 
@@ -1225,7 +1219,7 @@ static void io_destroy(struct kioctx *ioctx)
 		*tmp = ioctx->next;
 	write_unlock(&mm->ioctx_list_lock);
 
-	dprintk("aio_release(%p)\n", ioctx);
+	pr_debug("aio_release(%p)\n", ioctx);
 	if (likely(!was_dead))
 		put_ioctx(ioctx);	/* twice for the list */
 
@@ -1507,7 +1501,7 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb)
 			kiocb->ki_retry = aio_fsync;
 		break;
 	default:
-		dprintk("EINVAL: io_submit: no operation provided\n");
+		pr_debug("EINVAL: io_submit: no operation provided\n");
 		ret = -EINVAL;
 	}
 
@@ -1591,7 +1585,7 @@ int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 
 	ret = put_user(req->ki_key, &user_iocb->aio_key);
 	if (unlikely(ret)) {
-		dprintk("EFAULT: aio_key\n");
+		pr_debug("EFAULT: aio_key\n");
 		goto out_put_req;
 	}
 
-- 
1.5.4.5

