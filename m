Return-Path: <linux-kernel-owner+w=401wt.eu-S933006AbXCHSj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006AbXCHSj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 13:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbXCHSj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 13:39:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:22210 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933006AbXCHSj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 13:39:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,264,1170662400"; 
   d="scan'208,223"; a="55180328:sNHT17742807"
Message-ID: <45F05874.8040203@linux.intel.com>
Date: Thu, 08 Mar 2007 21:39:48 +0300
From: Leonid Ananiev <leonid.i.ananiev@linux.intel.com>
Reply-To: leonid.i.ananiev@intel.com
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org
Subject: [PATCH 3/3] aio: fix oops because of extra IO control block freeing.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 From Leonid Ananiev

Clean up unused return values in aio_complete() and aio_run_iocb().

Signed-off-by: Leonid Ananiev leonid.i.ananiev@intel.com

diff -uprN -X dontdiff linux-2.6.20-aio22/fs/aio.c 
linux-2.6.20-aio23/fs/aio.c
--- linux-2.6.20-aio22/fs/aio.c    2007-03-04 22:55:39.000000000 +0300
+++ linux-2.6.20-aio23/fs/aio.c    2007-03-05 08:46:26.000000000 +0300
@@ -660,7 +660,7 @@ static inline int __queue_kicked_iocb(st
   * simplifies the coding of individual aio operations as
   * it avoids various potential races.
   */
-static ssize_t aio_run_iocb(struct kiocb *iocb)
+static void aio_run_iocb(struct kiocb *iocb)
  {
      struct kioctx    *ctx = iocb->ki_ctx;
      ssize_t (*retry)(struct kiocb *);
@@ -668,7 +668,7 @@ static ssize_t aio_run_iocb(struct kiocb

      if (!(retry = iocb->ki_retry)) {
          printk("aio_run_iocb: iocb->ki_retry = NULL\n");
-        return 0;
+        return;
      }

      /*
@@ -730,7 +730,6 @@ static ssize_t aio_run_iocb(struct kiocb
      }
  out:
      spin_lock_irq(&ctx->ctx_lock);
-    return ret;
  }

  /*
@@ -897,7 +896,7 @@ EXPORT_SYMBOL(kick_iocb);
   *    Returns true if this is the last user of the request.  The
   *    only other user of the request can be the cancellation code.
   */
-int fastcall aio_complete(struct kiocb *iocb, long res, long res2)
+void fastcall aio_complete(struct kiocb *iocb, long res, long res2)
  {
      struct kioctx    *ctx = iocb->ki_ctx;
      struct aio_ring_info    *info;
diff -uprN -X dontdiff linux-2.6.20-aio22/include/linux/aio.h 
linux-2.6.20-aio23/include/linux/aio.h
--- linux-2.6.20-aio22/include/linux/aio.h    2007-03-04 
22:57:50.000000000 +0300
+++ linux-2.6.20-aio23/include/linux/aio.h    2007-03-05 
08:46:41.000000000 +0300
@@ -199,7 +199,7 @@ extern unsigned aio_max_size;
  extern ssize_t FASTCALL(wait_on_sync_kiocb(struct kiocb *iocb));
  extern int FASTCALL(aio_put_req(struct kiocb *iocb));
  extern void FASTCALL(kick_iocb(struct kiocb *iocb));
-extern int FASTCALL(aio_complete(struct kiocb *iocb, long res, long res2));
+extern void FASTCALL(aio_complete(struct kiocb *iocb, long res, long 
res2));
  extern void FASTCALL(__put_ioctx(struct kioctx *ctx));
  struct mm_struct;
  extern void FASTCALL(exit_aio(struct mm_struct *mm));
