Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbYFRSK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbYFRSK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 14:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbYFRSKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 14:10:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbYFRSKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 14:10:47 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: akpm@linux-foundation.org
Cc: zach.brown@oracle.com, linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch] aio: invalidate async directio writes
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 18 Jun 2008 14:09:51 -0400
Message-ID: <x49ej6uy5qo.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew,

This is a follow-up to:

commit bdb76ef5a4bc8676a81034a443f1eda450b4babb
Author: Zach Brown <zach.brown@oracle.com>
Date:   Tue Oct 30 11:45:46 2007 -0700

    dio: fix cache invalidation after sync writes
    
    Commit commit 65b8291c4000e5f38fc94fb2ca0cb7e8683c8a1b ("dio: invalidate
    clean pages before dio write") introduced a bug which stopped dio from
    ever invalidating the page cache after writes.  It still invalidated it
    before writes so most users were fine.
    
    Karl Schendel reported ( http://lkml.org/lkml/2007/10/26/481 ) hitting
    this bug when he had a buffered reader immediately reading file data
    after an O_DIRECT [writer] had written the data.  The kernel issued
    read-ahead beyond the position of the reader which overlapped with the
    O_DIRECT writer.  The failure to invalidate after writes caused the
    reader to see stale data from the read-ahead.
    
    The following patch is originally from Karl.  The following commentary
    is his:
    
        The below 3rd try takes on your suggestion of just invalidating
        no matter what the retval from the direct_IO call.  I ran it
        thru the test-case several times and it has worked every time.
        The post-invalidate is probably still too early for async-directio,
        but I don't have a testcase for that;  just sync.  And, this
        won't be any worse in the async case.
    
    I added a test to the aio-dio-regress repository which mimics Karl's IO
    pattern.  It verifed the bad behaviour and that the patch fixed it.  I
    agree with Karl, this still doesn't help the case where a buffered
    reader follows an AIO O_DIRECT writer.  That will require a bit more
    work.
    
    This gives up on the idea of returning EIO to indicate to userspace that
    stale data remains if the invalidation failed.

Note the second-to-last paragraph, where it mentions that this does not fix
the AIO case.  I updated the regression test to also perform asynchronous
I/O and verified that the problem does exist.

To fix the problem, we need to invalidate the pages that were under write
I/O after the I/O completes.  Because the I/O completion handler can be called
in interrupt context (and invalidate_inode_pages2 cannot be called in interrupt
context), this patch opts to defer the completion to a workqueue.  That
workqueue is responsible for invalidating the page cache pages and completing
the I/O.

I verified that the test case passes with the following patch applied.
Since this affects the code path for all async writers, I had our
performance group run a patched kernel through an OLTP workload.  I'm
told that the noise level for this test is in the 5% range.  The results
showed a 2.9% degradation in performance at 80 users, and 80 users was
the peak performance for the test.  For other user counts, the patched
kernel varied from a percent better to a couple of percent worse.  So,
overall I think the patch is worth taking, given that it fixes a
potential data corrupter.  (Sorry I can't report the actual numbers,
since the tests were run on unreleased hardware.)

Comments, as always, are encouraged.

Cheers,

Jeff

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 9e81add..90fa9e2 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -131,6 +131,8 @@ struct dio {
 	int is_async;			/* is IO async ? */
 	int io_error;			/* IO error in completion path */
 	ssize_t result;                 /* IO result */
+	struct list_head done_list;	/* AIO DIO writes to be completed
+					 * in process context */
 };
 
 /*
@@ -260,6 +262,40 @@ static int dio_complete(struct dio *dio, loff_t offset, int ret)
 	return ret;
 }
 
+static void aio_complete_fn(void *data);
+static DECLARE_WORK(aio_complete_work, aio_complete_fn, NULL);
+static DEFINE_SPINLOCK(iocb_completion_list_lock);
+static LIST_HEAD(iocb_completion_list);
+
+static void aio_complete_fn(void *data)
+{
+	unsigned long flags;
+	LIST_HEAD(private);
+	struct dio *dio, *tmp;
+
+	spin_lock_irqsave(&iocb_completion_list_lock, flags);
+	list_splice_init(&iocb_completion_list, &private);
+	spin_unlock_irqrestore(&iocb_completion_list_lock, flags);
+
+	list_for_each_entry_safe(dio, tmp, &private, done_list) {
+		struct kiocb *iocb = dio->iocb;
+		loff_t offset = iocb->ki_pos;
+		struct file *file = iocb->ki_filp;
+		struct address_space *mapping = file->f_mapping;
+		int ret;
+                pgoff_t end = (offset + dio->size - 1) >> PAGE_CACHE_SHIFT;
+
+		/* and now invalidate the page cache */
+		ret = dio_complete(dio, offset, 0);
+		if (mapping->nrpages)
+			invalidate_inode_pages2_range(mapping,
+						offset >> PAGE_CACHE_SHIFT, end);
+		aio_complete(dio->iocb, ret, 0);
+		list_del(&dio->done_list);
+		kfree(dio);
+	}
+}
+
 static int dio_bio_complete(struct dio *dio, struct bio *bio);
 /*
  * Asynchronous IO callback. 
@@ -280,9 +316,22 @@ static void dio_bio_end_aio(struct bio *bio, int error)
 	spin_unlock_irqrestore(&dio->bio_lock, flags);
 
 	if (remaining == 0) {
-		int ret = dio_complete(dio, dio->iocb->ki_pos, 0);
-		aio_complete(dio->iocb, ret, 0);
-		kfree(dio);
+		/* For async O_DIRECT writes, we need to invalidate the 
+		 * page cache after the write completes.  Kick off a
+		 * workqueue to do this and issue the completion in process
+		 * context.
+		 */
+		if (dio->rw == READ) {
+			int ret = dio_complete(dio, dio->iocb->ki_pos, 0);
+			aio_complete(dio->iocb, ret, 0);
+			kfree(dio);
+		} else {
+			unsigned long flags;
+			spin_lock_irqsave(&iocb_completion_list_lock, flags);
+			list_add(&dio->done_list, &iocb_completion_list);
+			spin_unlock_irqrestore(&iocb_completion_list_lock, flags);
+			schedule_work(&aio_complete_work);
+		}
 	}
 }
 
