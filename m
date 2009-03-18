Return-Path: <linux-kernel-owner+w=401wt.eu-S1758867AbZCRRZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbZCRRZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 13:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758528AbZCRRZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 13:25:46 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:36019 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984AbZCRRZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 13:25:44 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 18 Mar 2009 10:25:10 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Benjamin LaHaise <bcrl@kvack.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, linux-aio <linux-aio@kvack.org>,
       Jeff Moyer <jmoyer@redhat.com>, zach.brown@oracle.com
Subject: [patch] eventfd - remove fput() call from possible IRQ context (3rd
 rev)
In-Reply-To: <x49wsamhpvg.fsf@segfault.boston.devel.redhat.com>
Message-ID: <alpine.DEB.1.10.0903181018530.13607@makko.or.mcafeemobile.com>
References: <49B89B22.7080303@cosmosbay.com> <20090311224712.fb8db075.akpm@linux-foundation.org> <49B8A75E.6040409@cosmosbay.com> <20090311233903.f036027a.akpm@linux-foundation.org> <alpine.DEB.1.10.0903120625340.6040@makko.or.mcafeemobile.com>
 <1236986902.7265.73.camel@heimdal.trondhjem.org> <alpine.DEB.1.10.0903131732300.13254@makko.or.mcafeemobile.com> <1237003328.7265.98.camel@heimdal.trondhjem.org> <alpine.DEB.1.10.0903140729060.26556@makko.or.mcafeemobile.com>
 <alpine.DEB.1.10.0903141826120.3888@makko.or.mcafeemobile.com> <20090315174445.GD18305@kvack.org> <alpine.DEB.1.10.0903151303490.16762@makko.or.mcafeemobile.com> <x49wsamhpvg.fsf@segfault.boston.devel.redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-135962717-1237397115=:13607"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-135962717-1237397115=:13607
Content-Type: TEXT/PLAIN; charset=US-ASCII

The following patch remove a possible source of fput() call from inside 
IRQ context. Myself, like Eric, wasn't able to reproduce an fput() call 
from IRQ context, but Jeff said he was able to, with the attached test 
program. Independently from this, the bug is conceptually there, so we 
might be better off fixing it.
This patch adds an optimization similar to the one we already do on 
->ki_filp, on ->ki_eventfd. Playing with ->f_count directly is not pretty 
in general, but the alternative here would be to add a brand new delayed 
fput() infrastructure, that I'm not sure is worth it.


On Sun, 15 Mar 2009, Benjamin LaHaise wrote:

> This looks reasonably sane, the only concern I have with it is that I think 
> it logically makes more sense to use the same convention for fi_filp and 
> ki_eventfd, as the different in IS_ERR vs checking for NULL is a bit 
> confusing.  Aside from that, it looks like it should fix the problem 
> correctly.

Makes sense.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/aio.c |   37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

Index: linux-2.6.mod/fs/aio.c
===================================================================
--- linux-2.6.mod.orig/fs/aio.c	2009-03-15 13:11:56.000000000 -0700
+++ linux-2.6.mod/fs/aio.c	2009-03-18 10:18:21.000000000 -0700
@@ -443,7 +443,7 @@ static struct kiocb *__aio_get_req(struc
 	req->private = NULL;
 	req->ki_iovec = NULL;
 	INIT_LIST_HEAD(&req->ki_run_list);
-	req->ki_eventfd = ERR_PTR(-EINVAL);
+	req->ki_eventfd = NULL;
 
 	/* Check if the completion queue has enough free space to
 	 * accept an event from this io.
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
+		if (req->ki_eventfd != NULL)
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
@@ -1009,7 +1025,7 @@ int aio_complete(struct kiocb *iocb, lon
 	 * eventfd. The eventfd_signal() function is safe to be called
 	 * from IRQ context.
 	 */
-	if (!IS_ERR(iocb->ki_eventfd))
+	if (iocb->ki_eventfd != NULL)
 		eventfd_signal(iocb->ki_eventfd, 1);
 
 put_rq:
@@ -1608,6 +1624,7 @@ static int io_submit_one(struct kioctx *
 		req->ki_eventfd = eventfd_fget((int) iocb->aio_resfd);
 		if (IS_ERR(req->ki_eventfd)) {
 			ret = PTR_ERR(req->ki_eventfd);
+			req->ki_eventfd = NULL;
 			goto out_put_req;
 		}
 	}
--8323329-135962717-1237397115=:13607
Content-Type: TEXT/x-csrc; name=eventfd-irqctx-trigger.c
Content-Transfer-Encoding: BASE64
Content-Description: 
Content-Disposition: attachment; filename=eventfd-irqctx-trigger.c

DQojZGVmaW5lIF9HTlVfU09VUkNFDQojaW5jbHVkZSA8c3RkaW8uaD4NCiNp
bmNsdWRlIDxzdGRsaWIuaD4NCiNpbmNsdWRlIDx1bmlzdGQuaD4NCiNpbmNs
dWRlIDxmY250bC5oPg0KI2luY2x1ZGUgPHN0cmluZy5oPg0KI2luY2x1ZGUg
PHN5cy90eXBlcy5oPg0KI2luY2x1ZGUgPGVycm5vLmg+DQojaW5jbHVkZSA8
YXNzZXJ0Lmg+DQojaW5jbHVkZSA8c3lzL2V2ZW50ZmQuaD4NCiNpbmNsdWRl
IDxsaWJhaW8uaD4NCg0KaW50DQptYWluKGludCBhcmdjLCBjaGFyICoqYXJn
dikNCnsNCiNkZWZpbmUgU0laRQkoMjU2KjEwMjQqMTAyNCkNCgljaGFyICpi
dWY7DQoJc3RydWN0IGlvX2V2ZW50IGlvX2V2ZW50Ow0KCXN0cnVjdCBpb2Ni
IGlvY2I7DQoJc3RydWN0IGlvY2IgKmlvY2JzW10gPSB7ICZpb2NiIH07DQoJ
aW50IHJ3ZmQsIGVmZDsNCglpbnQgcmVzOw0KCWlvX2NvbnRleHRfdAlpb19j
dHg7DQoNCgllZmQgPSBldmVudGZkKDAsIDApOw0KCWlmIChlZmQgPCAwKSB7
DQoJCXBlcnJvcigiZXZlbnRmZCIpOw0KCQlleGl0KDEpOw0KCX0NCg0KCXJ3
ZmQgPSBvcGVuKCJyd2ZpbGUiLCBPX1JEV1J8T19ESVJFQ1QpOwkJYXNzZXJ0
KHJ3ZmQgIT0gLTEpOw0KCWlmIChwb3NpeF9tZW1hbGlnbigodm9pZCAqKikm
YnVmLCBnZXRwYWdlc2l6ZSgpLCBTSVpFKSA8IDApIHsNCgkJcGVycm9yKCJw
b3NpeF9tZW1hbGlnbiIpOw0KCQlleGl0KDEpOw0KCX0NCgltZW1zZXQoYnVm
LCAweDQyLCBTSVpFKTsNCg0KCS8qIFdyaXRlIHRlc3QuICovDQoJcmVzID0g
aW9fcXVldWVfaW5pdCgxMDI0LCAmaW9fY3R4KTsJCWFzc2VydChyZXMgPT0g
MCk7DQoJaW9fcHJlcF9wd3JpdGUoJmlvY2IsIHJ3ZmQsIGJ1ZiwgU0laRSwg
MCk7DQoJaW9fc2V0X2V2ZW50ZmQoJmlvY2IsIGVmZCk7DQoJcmVzID0gaW9f
c3VibWl0KGlvX2N0eCwgMSwgaW9jYnMpOwkJYXNzZXJ0KHJlcyA9PSAxKTsN
Cg0KCS8qIE5vdyBjbG9zZSB0aGUgZXZlbnRmZCBzbyB0aGF0IEFJTyBoYXMg
dGhlIGxhc3QgcmVmZXJlbmNlICovDQoJY2xvc2UoZWZkKTsNCg0KCS8qIEtl
ZXAgdGhpcyBwcm9jZXNzIGFyb3VuZCBzbyB0aGF0IHRoZSBhaW8gc3Vic3lz
dGVtIGRvZXMgbm90IGhvbGQNCgkgKiB0aGUgbGFzdCByZWZlcmVuY2Ugb24g
dGhlIHJ3ZmQsIG90aGVyd2lzZSB0aGUgcmVhbGx5X3B1dF9yZXEgd2lsbA0K
CSAqIGJlIGNhbGxlZCBmcm9tIHByb2Nlc3MgY29udGV4dCAqLw0KCXJlcyA9
IGlvX2dldGV2ZW50cyhpb19jdHgsIDEsIDEsICZpb19ldmVudCwgTlVMTCk7
DQoJaWYgKHJlcyAhPSAxKSB7DQoJCWlmIChyZXMgPCAwKSB7DQoJCQllcnJu
byA9IC1yZXM7DQoJCQlwZXJyb3IoImlvX2dldGV2ZW50cyIpOw0KCQl9IGVs
c2UNCgkJCXByaW50ZigiaW9fZ2V0ZXZlbnRzIGRpZCBub3QgcmV0dXJuIDEg
ZXZlbnQgYWZ0ZXIgIg0KCQkJICAgICAgICJjbG9zaW5nIGV2ZW50ZmRcbiIp
Ow0KCQlleGl0KDEpOw0KCX0NCglhc3NlcnQoaW9fZXZlbnQucmVzID09IFNJ
WkUpOw0KCXByaW50ZigiZXZlbnRmZCB3cml0ZSB0ZXN0IFtTVUNDRVNTXVxu
Iik7DQoNCglyZXR1cm4gMDsNCn0NCg0K

--8323329-135962717-1237397115=:13607--
