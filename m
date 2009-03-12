Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbZCLFox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbZCLFox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 01:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZCLFoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 01:44:44 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:47658 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbZCLFon convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 01:44:43 -0400
Message-ID: <49B8A0B9.2060602@cosmosbay.com>
Date: Thu, 12 Mar 2009 06:42:17 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeff Moyer <jmoyer@redhat.com>, Avi Kivity <avi@redhat.com>,
       linux-aio <linux-aio@kvack.org>, zach.brown@oracle.com, bcrl@kvack.org,
       linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH] aio: fput() can be called from interrupt context
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>	<49B54143.1010607@redhat.com> <x49sklmd1fo.fsf@segfault.boston.devel.redhat.com> <49B57CB0.5020300@cosmosbay.com> <49B875F7.3030305@cosmosbay.com> <49B87CFE.4000701@cosmosbay.com> <49B89B22.7080303@cosmosbay.com>
In-Reply-To: <49B89B22.7080303@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 12 Mar 2009 06:42:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
>> Path could be :
>>
>> 1) fput() changes so that calling it from interrupt context is possible
>>    (Using a working queue to make sure __fput() is called from process context)
>>
>> 2) Changes aio to use fput() as is (and zap its internal work_queue and aio_fput_routine() stuff)
>>
>> 3) Once atomic_long_dec_and_test(&filp->f_count) only performed in fput(),
>>    SLAB_DESTROY_BY_RCU for "struct file" get back :)
>>

Here is the second patch

Thank you

[PATCH] aio: cleanup, since fput() is IRQ safe

Once fput() is IRQ safe, we can cleanup aio code and delete its work_queue.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 fs/aio.c |   52 ++--------------------------------------------------
 1 files changed, 2 insertions(+), 50 deletions(-)


diff --git a/fs/aio.c b/fs/aio.c
index 8fa77e2..b0351a1 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -53,13 +53,6 @@ static struct kmem_cache	*kioctx_cachep;
 
 static struct workqueue_struct *aio_wq;
 
-/* Used for rare fput completion. */
-static void aio_fput_routine(struct work_struct *);
-static DECLARE_WORK(fput_work, aio_fput_routine);
-
-static DEFINE_SPINLOCK(fput_lock);
-static LIST_HEAD(fput_head);
-
 static void aio_kick_handler(struct work_struct *);
 static void aio_queue_work(struct kioctx *);
 
@@ -469,15 +462,7 @@ static struct kiocb *__aio_get_req(struct kioctx *ctx)
 static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 {
 	struct kiocb *req;
-	/* Handle a potential starvation case -- should be exceedingly rare as 
-	 * requests will be stuck on fput_head only if the aio_fput_routine is 
-	 * delayed and the requests were the last user of the struct file.
-	 */
 	req = __aio_get_req(ctx);
-	if (unlikely(NULL == req)) {
-		aio_fput_routine(NULL);
-		req = __aio_get_req(ctx);
-	}
 	return req;
 }
 
@@ -498,30 +483,6 @@ static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
 		wake_up(&ctx->wait);
 }
 
-static void aio_fput_routine(struct work_struct *data)
-{
-	spin_lock_irq(&fput_lock);
-	while (likely(!list_empty(&fput_head))) {
-		struct kiocb *req = list_kiocb(fput_head.next);
-		struct kioctx *ctx = req->ki_ctx;
-
-		list_del(&req->ki_list);
-		spin_unlock_irq(&fput_lock);
-
-		/* Complete the fput */
-		__fput(req->ki_filp);
-
-		/* Link the iocb into the context's free list */
-		spin_lock_irq(&ctx->ctx_lock);
-		really_put_req(ctx, req);
-		spin_unlock_irq(&ctx->ctx_lock);
-
-		put_ioctx(ctx);
-		spin_lock_irq(&fput_lock);
-	}
-	spin_unlock_irq(&fput_lock);
-}
-
 /* __aio_put_req
  *	Returns true if this put was the last user of the request.
  */
@@ -540,17 +501,8 @@ static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 	req->ki_cancel = NULL;
 	req->ki_retry = NULL;
 
-	/* Must be done under the lock to serialise against cancellation.
-	 * Call this aio_fput as it duplicates fput via the fput_work.
-	 */
-	if (unlikely(atomic_long_dec_and_test(&req->ki_filp->f_count))) {
-		get_ioctx(ctx);
-		spin_lock(&fput_lock);
-		list_add(&req->ki_list, &fput_head);
-		spin_unlock(&fput_lock);
-		queue_work(aio_wq, &fput_work);
-	} else
-		really_put_req(ctx, req);
+	fput(req->ki_filp);
+	really_put_req(ctx, req);
 	return 1;
 }
 

