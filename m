Return-Path: <linux-kernel-owner+w=401wt.eu-S1763218AbZCTX1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763218AbZCTX1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762932AbZCTXYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:21 -0400
Received: from kroah.org ([198.145.64.141]:48468 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762923AbZCTXYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:20 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:23 2009
Message-Id: <20090320222923.301362657@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:13 -0700
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
       alan@lxorguk.ukuu.org.uk, Davide Libenzi <davidel@xmailserver.org>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Eric Dumazet <dada1@cosmosbay.com>, Jeff Moyer <jmoyer@redhat.com>,
       Zach Brown <zach.brown@oracle.com>
Subject: [patch 03/43] eventfd: remove fput() call from possible IRQ context
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=eventfd-remove-fput-call-from-possible-irq-context.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Davide Libenzi <davidel@xmailserver.org>

commit 87c3a86e1c220121d0ced59d1a71e78ed9abc6dd upstream.

Remove a source of fput() call from inside IRQ context.  Myself, like Eric,
wasn't able to reproduce an fput() call from IRQ context, but Jeff said he was
able to, with the attached test program.  Independently from this, the bug is
conceptually there, so we might be better off fixing it.  This patch adds an
optimization similar to the one we already do on ->ki_filp, on ->ki_eventfd.
Playing with ->f_count directly is not pretty in general, but the alternative
here would be to add a brand new delayed fput() infrastructure, that I'm not
sure is worth it.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/aio.c |   37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -428,7 +428,7 @@ static struct kiocb *__aio_get_req(struc
 	req->private = NULL;
 	req->ki_iovec = NULL;
 	INIT_LIST_HEAD(&req->ki_run_list);
-	req->ki_eventfd = ERR_PTR(-EINVAL);
+	req->ki_eventfd = NULL;
 
 	/* Check if the completion queue has enough free space to
 	 * accept an event from this io.
@@ -470,8 +470,6 @@ static inline void really_put_req(struct
 {
 	assert_spin_locked(&ctx->ctx_lock);
 
-	if (!IS_ERR(req->ki_eventfd))
-		fput(req->ki_eventfd);
 	if (req->ki_dtor)
 		req->ki_dtor(req);
 	if (req->ki_iovec != &req->ki_inline_vec)
@@ -493,8 +491,11 @@ static void aio_fput_routine(struct work
 		list_del(&req->ki_list);
 		spin_unlock_irq(&fput_lock);
 
-		/* Complete the fput */
-		__fput(req->ki_filp);
+		/* Complete the fput(s) */
+		if (req->ki_filp != NULL)
+			__fput(req->ki_filp);
+		if (req->ki_eventfd != NULL)
+			__fput(req->ki_eventfd);
 
 		/* Link the iocb into the context's free list */
 		spin_lock_irq(&ctx->ctx_lock);
@@ -512,12 +513,14 @@ static void aio_fput_routine(struct work
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
@@ -525,10 +528,23 @@ static int __aio_put_req(struct kioctx *
 	req->ki_cancel = NULL;
 	req->ki_retry = NULL;
 
-	/* Must be done under the lock to serialise against cancellation.
-	 * Call this aio_fput as it duplicates fput via the fput_work.
+	/*
+	 * Try to optimize the aio and eventfd file* puts, by avoiding to
+	 * schedule work in case it is not __fput() time. In normal cases,
+	 * we would not be holding the last reference to the file*, so
+	 * this function will be executed w/out any aio kthread wakeup.
 	 */
-	if (unlikely(atomic_long_dec_and_test(&req->ki_filp->f_count))) {
+	if (unlikely(atomic_long_dec_and_test(&req->ki_filp->f_count)))
+		schedule_putreq++;
+	else
+		req->ki_filp = NULL;
+	if (req->ki_eventfd != NULL) {
+		if (unlikely(atomic_long_dec_and_test(&req->ki_eventfd->f_count)))
+			schedule_putreq++;
+		else
+			req->ki_eventfd = NULL;
+	}
+	if (unlikely(schedule_putreq)) {
 		get_ioctx(ctx);
 		spin_lock(&fput_lock);
 		list_add(&req->ki_list, &fput_head);
@@ -992,7 +1008,7 @@ int aio_complete(struct kiocb *iocb, lon
 	 * eventfd. The eventfd_signal() function is safe to be called
 	 * from IRQ context.
 	 */
-	if (!IS_ERR(iocb->ki_eventfd))
+	if (iocb->ki_eventfd != NULL)
 		eventfd_signal(iocb->ki_eventfd, 1);
 
 put_rq:
@@ -1596,6 +1612,7 @@ static int io_submit_one(struct kioctx *
 		req->ki_eventfd = eventfd_fget((int) iocb->aio_resfd);
 		if (IS_ERR(req->ki_eventfd)) {
 			ret = PTR_ERR(req->ki_eventfd);
+			req->ki_eventfd = NULL;
 			goto out_put_req;
 		}
 	}


