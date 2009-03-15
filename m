Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbZCOBiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbZCOBiQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 21:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZCOBh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 21:37:59 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:34580 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbZCOBh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 21:37:59 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 14 Mar 2009 18:36:34 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, linux-aio <linux-aio@kvack.org>,
       zach.brown@oracle.com, Benjamin LaHaise <bcrl@kvack.org>
Subject: [patch] eventfd - remove fput() call from possible IRQ context
In-Reply-To: <alpine.DEB.1.10.0903140729060.26556@makko.or.mcafeemobile.com>
Message-ID: <alpine.DEB.1.10.0903141826120.3888@makko.or.mcafeemobile.com>
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>  <49B54143.1010607@redhat.com>  <x49sklmd1fo.fsf@segfault.boston.devel.redhat.com>  <49B57CB0.5020300@cosmosbay.com> <49B875F7.3030305@cosmosbay.com>  <49B87CFE.4000701@cosmosbay.com>
 <49B89B22.7080303@cosmosbay.com>  <20090311224712.fb8db075.akpm@linux-foundation.org>  <49B8A75E.6040409@cosmosbay.com>  <20090311233903.f036027a.akpm@linux-foundation.org>  <alpine.DEB.1.10.0903120625340.6040@makko.or.mcafeemobile.com> 
 <1236986902.7265.73.camel@heimdal.trondhjem.org>  <alpine.DEB.1.10.0903131732300.13254@makko.or.mcafeemobile.com> <1237003328.7265.98.camel@heimdal.trondhjem.org> <alpine.DEB.1.10.0903140729060.26556@makko.or.mcafeemobile.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch remove a possible source of fput() call from inside 
IRQ context. Myself, like Eric, wasn't able to reproduce an fput() call 
from IRQ context, but conceptually the bug is there.
This patch adds an optimization similar to the one we already do on 
->ki_filp, on ->ki_eventfd. Playing with ->f_count directly is not pretty 
in general, but the alternative here would be to add a brand new delayed 
fput() infrastructure, that I'm not sure is worth it.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/aio.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

Index: linux-2.6.mod/fs/aio.c
===================================================================
--- linux-2.6.mod.orig/fs/aio.c	2009-03-13 18:19:34.000000000 -0700
+++ linux-2.6.mod/fs/aio.c	2009-03-13 18:32:25.000000000 -0700
@@ -485,8 +485,6 @@ static inline void really_put_req(struct
 {
 	assert_spin_locked(&ctx->ctx_lock);
 
-	if (!IS_ERR(req->ki_eventfd))
-		fput(req->ki_eventfd);
 	if (req->ki_dtor)
 		req->ki_dtor(req);
 	if (req->ki_iovec != &req->ki_inline_vec)
@@ -508,8 +506,11 @@ static void aio_fput_routine(struct work
 		list_del(&req->ki_list);
 		spin_unlock_irq(&fput_lock);
 
-		/* Complete the fput */
-		__fput(req->ki_filp);
+		/* Complete the fput(s) */
+		if (req->ki_filp != NULL)
+			__fput(req->ki_filp);
+		if (!IS_ERR(req->ki_eventfd))
+			__fput(req->ki_eventfd);
 
 		/* Link the iocb into the context's free list */
 		spin_lock_irq(&ctx->ctx_lock);
@@ -527,12 +528,14 @@ static void aio_fput_routine(struct work
  */
 static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 {
+	int schedule_putreq = 0;
+
 	dprintk(KERN_DEBUG "aio_put(%p): f_count=%ld\n",
 		req, atomic_long_read(&req->ki_filp->f_count));
 
 	assert_spin_locked(&ctx->ctx_lock);
 
-	req->ki_users --;
+	req->ki_users--;
 	BUG_ON(req->ki_users < 0);
 	if (likely(req->ki_users))
 		return 0;
@@ -540,10 +543,23 @@ static int __aio_put_req(struct kioctx *
 	req->ki_cancel = NULL;
 	req->ki_retry = NULL;
 
-	/* Must be done under the lock to serialise against cancellation.
-	 * Call this aio_fput as it duplicates fput via the fput_work.
+	/*
+	 * Try to optimize the aio and eventfd file* puts, by avoiding to
+	 * schedule work in case it is not __fput() time. In normal cases,
+	 * we wouldn not be holding the last reference to the file*, so
+	 * this function will be executed w/out any aio kthread wakeup.
 	 */
-	if (unlikely(atomic_long_dec_and_test(&req->ki_filp->f_count))) {
+	if (unlikely(atomic_long_dec_and_test(&req->ki_filp->f_count)))
+		schedule_putreq++;
+	else
+		req->ki_filp = NULL;
+	if (unlikely(!IS_ERR(req->ki_eventfd))) {
+		if (unlikely(atomic_long_dec_and_test(&req->ki_eventfd->f_count)))
+			schedule_putreq++;
+		else
+			req->ki_eventfd = ERR_PTR(-EINVAL);
+	}
+	if (unlikely(schedule_putreq)) {
 		get_ioctx(ctx);
 		spin_lock(&fput_lock);
 		list_add(&req->ki_list, &fput_head);
