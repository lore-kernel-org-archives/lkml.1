Return-Path: <linux-kernel-owner+w=401wt.eu-S1752068AbZKLHwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbZKLHwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 02:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbZKLHwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 02:52:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:23532 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbZKLHwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 02:52:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,726,1249282800"; 
   d="scan'208";a="513059238"
Date: Thu, 12 Nov 2009 15:52:47 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, bcrl@kvack.org
Subject: [PATCH]aio: remove unused field
Message-ID: <20091112075247.GA17960@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't know the reason, but it appears ki_wait field of iocb never gets used.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/fs/aio.c b/fs/aio.c
index 02a2c93..5ec1e70 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -697,10 +697,8 @@ static ssize_t aio_run_iocb(struct kiocb *iocb)
 	 */
 	ret = retry(iocb);
 
-	if (ret != -EIOCBRETRY && ret != -EIOCBQUEUED) {
-		BUG_ON(!list_empty(&iocb->ki_wait.task_list));
+	if (ret != -EIOCBRETRY && ret != -EIOCBQUEUED)
 		aio_complete(iocb, ret, 0);
-	}
 out:
 	spin_lock_irq(&ctx->ctx_lock);
 
@@ -852,13 +850,6 @@ static void try_queue_kicked_iocb(struct kiocb *iocb)
 	unsigned long flags;
 	int run = 0;
 
-	/* We're supposed to be the only path putting the iocb back on the run
-	 * list.  If we find that the iocb is *back* on a wait queue already
-	 * than retry has happened before we could queue the iocb.  This also
-	 * means that the retry could have completed and freed our iocb, no
-	 * good. */
-	BUG_ON((!list_empty(&iocb->ki_wait.task_list)));
-
 	spin_lock_irqsave(&ctx->ctx_lock, flags);
 	/* set this inside the lock so that we can't race with aio_run_iocb()
 	 * testing it and putting the iocb on the run list under the lock */
@@ -1506,31 +1497,6 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb)
 	return 0;
 }
 
-/*
- * aio_wake_function:
- * 	wait queue callback function for aio notification,
- * 	Simply triggers a retry of the operation via kick_iocb.
- *
- * 	This callback is specified in the wait queue entry in
- *	a kiocb.
- *
- * Note:
- * This routine is executed with the wait queue lock held.
- * Since kick_iocb acquires iocb->ctx->ctx_lock, it nests
- * the ioctx lock inside the wait queue lock. This is safe
- * because this callback isn't used for wait queues which
- * are nested inside ioctx lock (i.e. ctx->wait)
- */
-static int aio_wake_function(wait_queue_t *wait, unsigned mode,
-			     int sync, void *key)
-{
-	struct kiocb *iocb = container_of(wait, struct kiocb, ki_wait);
-
-	list_del_init(&wait->task_list);
-	kick_iocb(iocb);
-	return 1;
-}
-
 static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 			 struct iocb *iocb)
 {
@@ -1592,8 +1558,6 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	req->ki_buf = (char __user *)(unsigned long)iocb->aio_buf;
 	req->ki_left = req->ki_nbytes = iocb->aio_nbytes;
 	req->ki_opcode = iocb->aio_lio_opcode;
-	init_waitqueue_func_entry(&req->ki_wait, aio_wake_function);
-	INIT_LIST_HEAD(&req->ki_wait.task_list);
 
 	ret = aio_setup_iocb(req);
 
diff --git a/include/linux/aio.h b/include/linux/aio.h
index aea219d..811dbb3 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -102,7 +102,6 @@ struct kiocb {
 	} ki_obj;
 
 	__u64			ki_user_data;	/* user's data for completion */
-	wait_queue_t		ki_wait;
 	loff_t			ki_pos;
 
 	void			*private;
@@ -140,7 +139,6 @@ struct kiocb {
 		(x)->ki_dtor = NULL;			\
 		(x)->ki_obj.tsk = tsk;			\
 		(x)->ki_user_data = 0;                  \
-		init_wait((&(x)->ki_wait));             \
 	} while (0)
 
 #define AIO_RING_MAGIC			0xa10a10a1
@@ -223,8 +221,6 @@ struct mm_struct;
 static inline void exit_aio(struct mm_struct *mm) { }
 #endif /* CONFIG_AIO */
 
-#define io_wait_to_kiocb(wait) container_of(wait, struct kiocb, ki_wait)
-
 static inline struct kiocb *list_kiocb(struct list_head *h)
 {
 	return list_entry(h, struct kiocb, ki_list);
