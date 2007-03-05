Return-Path: <linux-kernel-owner+w=401wt.eu-S933479AbXCEOXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479AbXCEOXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 09:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933483AbXCEOXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 09:23:39 -0500
Received: from mga07.intel.com ([143.182.124.22]:3108 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933479AbXCEOXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 09:23:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,250,1170662400"; 
   d="scan'208,223"; a="190249698:sNHT21391965"
Message-ID: <45EC27E5.20006@linux.intel.com>
Date: Mon, 05 Mar 2007 17:23:33 +0300
From: Leonid Ananiev <leonid.i.ananiev@linux.intel.com>
Reply-To: leonid.i.ananiev@intel.com
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] aio: fix oops because of extra IO control block freeing.
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 From Leonid Ananiev

The patch fixes oops because of extra IO control block freeing.
IO is retried if page could not be invalidated.

Signed-off-by: Leonid Ananiev <leonid.i.ananiev@intel.com>

The patch fixes oops "Kernel BUG at fs/aio.c:509" archived at 
http://lkml.org/lkml/2007/2/8/337
The number of IO control block (iocb)users < 0.
If page could not be invalidated by invalidate_inode_pages2_range()
than EIO is returned. It happens if journal_try_to_free_buffers() fails 
to drop_buffers().
This EIO is not differing from real IO competition with EIO and 
aio_complete() is called.
Later aio_complete() is called from dio_bio_end_aio() and frees iocb 
once more.

After patch generic_file_direct_IO() sets PgBusy flag in iocb
if page could not be invalidated. iocb is retried after IO competition.
The process is waked up if IO is SYNC else iocb is kicked.
The lines “if (ret != -EIOCBRETRY)” is deleted because
nothing set to EIOCBRETRY.

Next patches 2/3 and 3/3 do cleanup only.
The patch is applied and tested with aio-stress on 2.6.20 and 2.6.21-rc2
diff -uprNX linux-2.6.21-rc2/Documentation/dontdiff 
linux-2.6.21-rc2/fs/aio.c linux-2.6.21-rc2-aio31/fs/aio.c
--- linux-2.6.21-rc2/fs/aio.c	2007-03-05 00:29:58.000000000 -0800
+++ linux-2.6.21-rc2-aio31/fs/aio.c	2007-03-05 00:38:11.000000000 -0800
@@ -723,37 +723,12 @@ static ssize_t aio_run_iocb(struct kiocb
  	ret = retry(iocb);
  	current->io_wait = NULL;

-	if (ret != -EIOCBRETRY && ret != -EIOCBQUEUED) {
+	if (!kiocbIsPgBusy(iocb) && ret != -EIOCBQUEUED) {
  		BUG_ON(!list_empty(&iocb->ki_wait.task_list));
  		aio_complete(iocb, ret, 0);
  	}
  out:
  	spin_lock_irq(&ctx->ctx_lock);
-
-	if (-EIOCBRETRY == ret) {
-		/*
-		 * OK, now that we are done with this iteration
-		 * and know that there is more left to go,
-		 * this is where we let go so that a subsequent
-		 * "kick" can start the next iteration
-		 */
-
-		/* will make __queue_kicked_iocb succeed from here on */
-		INIT_LIST_HEAD(&iocb->ki_run_list);
-		/* we must queue the next iteration ourselves, if it
-		 * has already been kicked */
-		if (kiocbIsKicked(iocb)) {
-			__queue_kicked_iocb(iocb);
-
-			/*
-			 * __queue_kicked_iocb will always return 1 here, because
-			 * iocb->ki_run_list is empty at this point so it should
-			 * be safe to unconditionally queue the context into the
-			 * work queue.
-			 */
-			aio_queue_work(ctx);
-		}
-	}
  	return ret;
  }

@@ -945,6 +920,10 @@ int fastcall aio_complete(struct kiocb *
  		wake_up_process(iocb->ki_obj.tsk);
  		return 1;
  	}
+	if (TestClearPgBusy(iocb)) { // page could not be invalidated
+		kick_iocb(iocb);
+		return 1;
+	}

  	info = &ctx->ring_info;

diff -uprNX linux-2.6.21-rc2/Documentation/dontdiff 
linux-2.6.21-rc2/fs/read_write.c linux-2.6.21-rc2-aio31/fs/read_write.c
--- linux-2.6.21-rc2/fs/read_write.c	2007-03-05 00:29:58.000000000 -0800
+++ linux-2.6.21-rc2-aio31/fs/read_write.c	2007-03-05 04:44:44.000000000 
-0800
@@ -239,7 +239,7 @@ ssize_t do_sync_read(struct file *filp,

  	for (;;) {
  		ret = filp->f_op->aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
-		if (ret != -EIOCBRETRY)
+		if (!TestClearPgBusy(&kiocb))
  			break;
  		wait_on_retry_sync_kiocb(&kiocb);
  	}
@@ -297,7 +297,7 @@ ssize_t do_sync_write(struct file *filp,

  	for (;;) {
  		ret = filp->f_op->aio_write(&kiocb, &iov, 1, kiocb.ki_pos);
-		if (ret != -EIOCBRETRY)
+		if (!TestClearPgBusy(&kiocb))
  			break;
  		wait_on_retry_sync_kiocb(&kiocb);
  	}
@@ -463,7 +463,7 @@ ssize_t do_sync_readv_writev(struct file

  	for (;;) {
  		ret = fn(&kiocb, iov, nr_segs, kiocb.ki_pos);
-		if (ret != -EIOCBRETRY)
+		if (!TestClearPgBusy(&kiocb))
  			break;
  		wait_on_retry_sync_kiocb(&kiocb);
  	}
diff -uprNX linux-2.6.21-rc2/Documentation/dontdiff 
linux-2.6.21-rc2/include/linux/aio.h 
linux-2.6.21-rc2-aio31/include/linux/aio.h
--- linux-2.6.21-rc2/include/linux/aio.h	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.21-rc2-aio31/include/linux/aio.h	2007-03-05 
00:38:11.000000000 -0800
@@ -34,21 +34,26 @@ struct kioctx;
  /* #define KIF_LOCKED		0 */
  #define KIF_KICKED		1
  #define KIF_CANCELLED		2
+#define KIF_PG_BUSY		3

  #define kiocbTryLock(iocb)	test_and_set_bit(KIF_LOCKED, &(iocb)->ki_flags)
  #define kiocbTryKick(iocb)	test_and_set_bit(KIF_KICKED, &(iocb)->ki_flags)
+#define TestClearPgBusy(iocb)	test_and_clear_bit(KIF_PG_BUSY, 
&(iocb)->ki_flags)

  #define kiocbSetLocked(iocb)	set_bit(KIF_LOCKED, &(iocb)->ki_flags)
  #define kiocbSetKicked(iocb)	set_bit(KIF_KICKED, &(iocb)->ki_flags)
  #define kiocbSetCancelled(iocb)	set_bit(KIF_CANCELLED, &(iocb)->ki_flags)
+#define kiocbSetPgBusy(iocb)	set_bit(KIF_PG_BUSY, &(iocb)->ki_flags)

  #define kiocbClearLocked(iocb)	clear_bit(KIF_LOCKED, &(iocb)->ki_flags)
  #define kiocbClearKicked(iocb)	clear_bit(KIF_KICKED, &(iocb)->ki_flags)
  #define kiocbClearCancelled(iocb)	clear_bit(KIF_CANCELLED, 
&(iocb)->ki_flags)
+#define kiocbClearPgBusy(iocb)	clear_bit(KIF_PG_BUSY, &(iocb)->ki_flags)

  #define kiocbIsLocked(iocb)	test_bit(KIF_LOCKED, &(iocb)->ki_flags)
  #define kiocbIsKicked(iocb)	test_bit(KIF_KICKED, &(iocb)->ki_flags)
  #define kiocbIsCancelled(iocb)	test_bit(KIF_CANCELLED, &(iocb)->ki_flags)
+#define kiocbIsPgBusy(iocb)	test_bit(KIF_PG_BUSY, &(iocb)->ki_flags)

  /* is there a better place to document function pointer methods? */
  /**
diff -upr linux-2.6.20/mm/filemap.c linux-2.6.20-aio2/mm/filemap.c
--- linux-2.6.20/mm/filemap.c	2007-02-04 21:44:54.000000000 +0300
+++ linux-2.6.20-aio2/mm/filemap.c	2007-03-04 21:46:10.000000000 +0300
@@ -2413,10 +2413,9 @@ generic_file_direct_IO(int rw, struct ki
  		if (rw == WRITE && mapping->nrpages) {
  			pgoff_t end = (offset + write_len - 1)
  						>> PAGE_CACHE_SHIFT;
-			int err = invalidate_inode_pages2_range(mapping,
-					offset >> PAGE_CACHE_SHIFT, end);
-			if (err)
-				retval = err;
+			if (invalidate_inode_pages2_range(mapping,
+					offset >> PAGE_CACHE_SHIFT, end))
+				kiocbSetPgBusy(iocb);
  		}
  	}
  	return retval;
