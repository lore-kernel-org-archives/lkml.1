Return-Path: <linux-kernel-owner+w=401wt.eu-S932574AbXBTRd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbXBTRd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932585AbXBTRd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:33:56 -0500
Received: from mga03.intel.com ([143.182.124.21]:41463 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932574AbXBTRdz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:33:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,197,1170662400"; 
   d="scan'208"; a="184758627:sNHT1036279055"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to completion event
Date: Tue, 20 Feb 2007 20:33:15 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC871DA3@mssmsx411>
In-Reply-To: <20070219213835.4032.87439.sendpatchset@tetsuo.zabbo.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to completion event
Thread-Index: AcdUblIBxDuLmWvSRQOVMIVRQ5shdQAoubWg
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: "Zach Brown" <zach.brown@oracle.com>, <linux-aio@kvack.org>,
       <linux-kernel@vger.kernel.org>
Cc: "Benjamin LaHaise" <bcrl@kvack.org>,
       "Suparna bhattacharya" <suparna@in.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 20 Feb 2007 17:33:18.0720 (UTC) FILETIME=[35B6E000:01C75515]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is change in the patch which is uncommented in preface.
Now aio_ring_insert_entry() is not called if req->ki_users>=1.
Before was called.
Could you comment it?

Leonid
-----Original Message-----
From: Zach Brown [mailto:zach.brown@oracle.com] 
Sent: Tuesday, February 20, 2007 12:39 AM
To: linux-aio@kvack.org; linux-kernel@vger.kernel.org
Cc: Benjamin LaHaise; Suparna bhattacharya; Andrew Morton; Ananiev,
Leonid I
Subject: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to
completion event

aio: propogate post-EIOCBQUEUED errors to completion event

This addresses an oops reported by Leonid Ananiev
<leonid.i.ananiev@intel.com>
as archived at http://lkml.org/lkml/2007/2/8/337.

O_DIRECT kicks off bios and returns -EIOCBQUEUED to indicate its
intention to
call aio_complete() once the bios complete.   As we return from
submission we
must preserve the -EIOCBQUEUED return code so that fs/aio.c knows to let
the
bio completion call aio_complete().  This stops us from returning errors
after
O_DIRECT submission.

But we have a few places that are very interested in generating errors
after
bio submission.

The most critical of these is invalidating the page cache after a write.
This
avoids exposing stale data to buffered operations that are performed
after the
O_DIRECT write succeeds.  We must do this after submission because the
user
buffer might have been an mmap()ed buffer of the region being written
to.  The
get_user_pages() in the O_DIRECT completion path could have faulted in
stale
data.

So this patch introduces a helper, aio_propogate_error(), which queues
post-submission errors in the iocb so that they are given to the user
completion event when aio_complete() is finally called.

To get this working we change the aio_complete() path so that the ring
insertion is performed as the final iocb reference is dropped.  This
gives the
submission path time to queue its pending error before it drops its
reference.
This increases the space in the iocb as it has to record the two result
codes
from aio_complete() and the pending error from the submission path.

This was tested by running O_DIRECT aio-stress concurrently with
buffered reads
while triggering EIO in invalidate_inode_pages2_range() with the help of
a
debugfs bool hack.  Previously the kernel would oops as fs/aio.c and bio
completion both called aio_complete().  With this patch aio-stress sees
-EIO.

Signed-off-by: Zach Brown <zach.brown@oracle.com>
---

 fs/aio.c            |   49 +++++++++++++++++++++---------------------
 include/linux/aio.h |   30 +++++++++++++++++++++++++
 mm/filemap.c        |    4 +--
 3 files changed, 57 insertions(+), 26 deletions(-)

--- a/fs/aio.c	Mon Feb 19 13:12:20 2007 -0800
+++ b/fs/aio.c	Mon Feb 19 13:16:00 2007 -0800
@@ -193,8 +193,7 @@ static int aio_setup_ring(struct kioctx 
 	kunmap_atomic((void *)((unsigned long)__event & PAGE_MASK), km);
\
 } while(0)
 
-static void aio_ring_insert_entry(struct kioctx *ctx, struct kiocb
*iocb,
-				  long res, long res2)
+static void aio_ring_insert_entry(struct kioctx *ctx, struct kiocb
*iocb)
 {
 	struct aio_ring_info	*info;
 	struct aio_ring		*ring;
@@ -213,12 +212,12 @@ static void aio_ring_insert_entry(struct
 
 	event->obj = (u64)(unsigned long)iocb->ki_obj.user;
 	event->data = iocb->ki_user_data;
-	event->res = res;
-	event->res2 = res2;
-
-	dprintk("aio_complete: %p[%lu]: %p: %p %Lx %lx %lx\n",
+	event->res = iocb->ki_pending_err ? iocb->ki_pending_err :
iocb->ki_res;
+	event->res2 = iocb->ki_res2;
+
+	dprintk("aio_complete: %p[%lu]: %p: %p %Lx %d %lx %lx\n",
 		ctx, tail, iocb, iocb->ki_obj.user, iocb->ki_user_data,
-		res, res2);
+		iocb->ki_pending_err, iocb->ki_res, iocb->ki_res2);
 
 	/* after flagging the request as done, we
 	 * must never even look at it again
@@ -459,6 +458,7 @@ static struct kiocb fastcall *__aio_get_
 	req->ki_cancel = NULL;
 	req->ki_retry = NULL;
 	req->ki_dtor = NULL;
+	req->ki_pending_err = 0;
 	req->private = NULL;
 	req->ki_iovec = NULL;
 	INIT_LIST_HEAD(&req->ki_run_list);
@@ -548,10 +548,14 @@ static int __aio_put_req(struct kioctx *
 
 	assert_spin_locked(&ctx->ctx_lock);
 
-	req->ki_users --;
+	req->ki_users--;
 	BUG_ON(req->ki_users < 0);
 	if (likely(req->ki_users))
 		return 0;
+
+	if (kiocbIsInserted(req))
+		aio_ring_insert_entry(ctx, req);
+
 	list_del(&req->ki_list);		/* remove from
active_reqs */
 	req->ki_cancel = NULL;
 	req->ki_retry = NULL;
@@ -983,27 +987,24 @@ int fastcall aio_complete(struct kiocb *
 		return 1;
 	}
 
-	/* add a completion event to the ring buffer.
-	 * must be done holding ctx->ctx_lock to prevent
-	 * other code from messing with the tail
-	 * pointer since we might be called from irq
-	 * context.
-	 */
+	/*
+	 * We queue up the completion codes into the iocb.  They are
combined
+	 * with a potential error from the submission path and inserted
into
+	 * the ring once the last reference to the iocb is dropped.
Cancelled
+	 * iocbs don't insert events on completion because userland was
given
+	 * an event directly as part of the cancelation interface.
+ 	 */
 	spin_lock_irqsave(&ctx->ctx_lock, flags);
 
 	if (iocb->ki_run_list.prev && !list_empty(&iocb->ki_run_list))
 		list_del_init(&iocb->ki_run_list);
 
-	/*
-	 * cancelled requests don't get events, userland was given one
-	 * when the event got cancelled.
-	 */
-	if (kiocbIsCancelled(iocb))
-		goto put_rq;
-
-	aio_ring_insert_entry(ctx, iocb, res, res2);
-
-put_rq:
+	if (!kiocbIsCancelled(iocb)) {
+		iocb->ki_res = res;
+		iocb->ki_res2 = res2;
+		kiocbSetInserted(iocb);
+	}
+
 	/* everything turned out well, dispose of the aiocb. */
 	ret = __aio_put_req(ctx, iocb);
 
diff -r 8a740eb579d4 include/linux/aio.h
--- a/include/linux/aio.h	Mon Feb 19 13:12:20 2007 -0800
+++ b/include/linux/aio.h	Mon Feb 19 13:16:00 2007 -0800
@@ -34,6 +34,7 @@ struct kioctx;
 /* #define KIF_LOCKED		0 */
 #define KIF_KICKED		1
 #define KIF_CANCELLED		2
+#define KIF_INSERTED		4
 
 #define kiocbTryLock(iocb)	test_and_set_bit(KIF_LOCKED,
&(iocb)->ki_flags)
 #define kiocbTryKick(iocb)	test_and_set_bit(KIF_KICKED,
&(iocb)->ki_flags)
@@ -41,6 +42,7 @@ struct kioctx;
 #define kiocbSetLocked(iocb)	set_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbSetKicked(iocb)	set_bit(KIF_KICKED, &(iocb)->ki_flags)
 #define kiocbSetCancelled(iocb)	set_bit(KIF_CANCELLED,
&(iocb)->ki_flags)
+#define kiocbSetInserted(iocb)	set_bit(KIF_INSERTED, &(iocb)->ki_flags)
 
 #define kiocbClearLocked(iocb)	clear_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbClearKicked(iocb)	clear_bit(KIF_KICKED, &(iocb)->ki_flags)
@@ -49,6 +51,7 @@ struct kioctx;
 #define kiocbIsLocked(iocb)	test_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbIsKicked(iocb)	test_bit(KIF_KICKED, &(iocb)->ki_flags)
 #define kiocbIsCancelled(iocb)	test_bit(KIF_CANCELLED,
&(iocb)->ki_flags)
+#define kiocbIsInserted(iocb)	test_bit(KIF_INSERTED,
&(iocb)->ki_flags)
 
 /* is there a better place to document function pointer methods? */
 /**
@@ -119,6 +122,10 @@ struct kiocb {
 
 	struct list_head	ki_list;	/* the aio core uses
this
 						 * for cancellation */
+	/* we store and combine return codes from submission and
completion */ 
+	int			ki_pending_err;
+	long			ki_res;
+	long			ki_res2;
 };
 
 #define is_sync_kiocb(iocb)	((iocb)->ki_key == KIOCB_SYNC_KEY)
@@ -246,6 +253,29 @@ static inline struct kiocb *list_kiocb(s
 	return list_entry(h, struct kiocb, ki_list);
 }
 
+/*
+ * This function is used to make sure that an error is communicated to
+ * userspace on iocb completion without stopping -EIOCBQUEUED from
bubbling up
+ * to fs/aio.c from the place where it originated.
+ *
+ * If we have an existing -EIOCBQUEUED it must be returned all the way
to
+ * fs/aio.c so that it doesn't double-complete the iocb along with
whoever
+ * returned -EIOCBQUEUED..  In that case we put the new error in the
iocb.  It
+ * will be returned to userspace *intead of* the first result code
given to
+ * aio_complete().  Use this only for errors which must overwrite
whatever the
+ * return code might have been.  The first non-zero new_err given to
this
+ * function for a given iocb will be returned to userspace.
+ */
+static inline int aio_propogate_error(struct kiocb *iocb, int
existing_err,
+				      int new_err)
+{
+	if (existing_err != -EIOCBQUEUED)
+		return new_err;
+	if (!iocb->ki_pending_err)
+		iocb->ki_pending_err = new_err;
+	return -EIOCBQUEUED;
+}
+
 /* for sysctl: */
 extern unsigned long aio_nr;
 extern unsigned long aio_max_nr;
diff -r 8a740eb579d4 mm/filemap.c
--- a/mm/filemap.c	Mon Feb 19 13:12:20 2007 -0800
+++ b/mm/filemap.c	Mon Feb 19 13:16:00 2007 -0800
@@ -2031,7 +2031,7 @@ generic_file_direct_write(struct kiocb *
 	    ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
 		int err = generic_osync_inode(inode, mapping,
OSYNC_METADATA);
 		if (err < 0)
-			written = err;
+			written = aio_propogate_error(iocb, written,
err);
 	}
 	return written;
 }
@@ -2396,7 +2396,7 @@ generic_file_direct_IO(int rw, struct ki
 			int err = invalidate_inode_pages2_range(mapping,
 					offset >> PAGE_CACHE_SHIFT,
end);
 			if (err)
-				retval = err;
+				retval = aio_propogate_error(iocb,
retval, err);
 		}
 	}
 	return retval;
