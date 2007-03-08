Return-Path: <linux-kernel-owner+w=401wt.eu-S932873AbXCHSh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873AbXCHSh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 13:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932954AbXCHSh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 13:37:28 -0500
Received: from mga07.intel.com ([143.182.124.22]:48703 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932873AbXCHSh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 13:37:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,264,1170662400"; 
   d="scan'208,223"; a="192577918:sNHT21171759"
Message-ID: <45F057E1.60107@linux.intel.com>
Date: Thu, 08 Mar 2007 21:37:21 +0300
From: Leonid Ananiev <leonid.i.ananiev@linux.intel.com>
Reply-To: leonid.i.ananiev@intel.com
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org
Subject: [PATCH 2/3] aio: fix oops because of extra IO control block freeing.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 From Leonid Ananiev

This patch finishes moving from using errno EIOCBRETRY to using flag in 
IO control block for aio retrying. After this change the process will be 
kicked for direct aio as it was for sync aio.

Signed-off-by: Leonid Ananiev <leonid.i.ananiev@intel.com>

The patch is applied to 2.6.20 or 2.6.21-rc2
diff -uprN -X linux-2.6.20-aio21/Documentation/dontdiff 
linux-2.6.20-aio21/drivers/usb/gadget/inode.c 
linux-2.6.20-aio22/drivers/usb/gadget/inode.c
--- linux-2.6.20-aio21/drivers/usb/gadget/inode.c    2007-03-04 
21:45:52.000000000 +0300
+++ linux-2.6.20-aio22/drivers/usb/gadget/inode.c    2007-03-05 
18:19:35.000000000 +0300
@@ -692,7 +692,10 @@ fail:
          kfree(priv);
          put_ep(epdata);
      } else
-        value = (iv ? -EIOCBRETRY : -EIOCBQUEUED);
+        if (iv)
+            kiocbSetPgBusy(iocb);
+        else
+            value = -EIOCBQUEUED;
      return value;
  }

diff -uprN -X linux-2.6.20-aio21/Documentation/dontdiff 
linux-2.6.20-aio21/fs/ocfs2/dlmglue.c linux-2.6.20-aio22/fs/ocfs2/dlmglue.c
--- linux-2.6.20-aio21/fs/ocfs2/dlmglue.c    2007-03-04 
21:45:52.000000000 +0300
+++ linux-2.6.20-aio22/fs/ocfs2/dlmglue.c    2007-03-04 
22:57:50.000000000 +0300
@@ -1639,7 +1639,7 @@ int ocfs2_meta_lock_full(struct inode *i

      status = ocfs2_cluster_lock(osb, lockres, level, dlm_flags, 
arg_flags);
      if (status < 0) {
-        if (status != -EAGAIN && status != -EIOCBRETRY)
+        if (status != -EAGAIN)
              mlog_errno(status);
          goto bail;
      }
diff -uprN -X linux-2.6.20-aio21/Documentation/dontdiff 
linux-2.6.20-aio21/include/linux/aio.h 
linux-2.6.20-aio22/include/linux/aio.h
--- linux-2.6.20-aio21/include/linux/aio.h    2007-03-04 
21:46:45.000000000 +0300
+++ linux-2.6.20-aio22/include/linux/aio.h    2007-03-04 
22:57:50.000000000 +0300
@@ -79,15 +79,6 @@ struct kioctx;
   * not ask the method again -- ki_retry must ensure forward progress.
   * aio_complete() must be called once and only once in the future, 
multiple
   * calls may result in undefined behaviour.
- *
- * If ki_retry returns -EIOCBRETRY it has made a promise that kick_iocb()
- * will be called on the kiocb pointer in the future.  This may happen
- * through generic helpers that associate kiocb->ki_wait with a wait
- * queue head that ki_retry uses via current->io_wait.  It can also happen
- * with custom tracking and manual calls to kick_iocb(), though that is
- * discouraged.  In either case, kick_iocb() must be called once and only
- * once.  ki_retry must ensure forward progress, the AIO core will wait
- * indefinitely for kick_iocb() to be called.
   */
  struct kiocb {
      struct list_head    ki_run_list;
diff -uprN -X linux-2.6.20-aio21/Documentation/dontdiff 
linux-2.6.20-aio21/include/linux/errno.h 
linux-2.6.20-aio22/include/linux/errno.h
--- linux-2.6.20-aio21/include/linux/errno.h    2007-03-04 
21:45:51.000000000 +0300
+++ linux-2.6.20-aio22/include/linux/errno.h    2007-03-04 
22:57:50.000000000 +0300
@@ -22,7 +22,6 @@
  #define EBADTYPE    527    /* Type not supported by server */
  #define EJUKEBOX    528    /* Request initiated, but will not complete 
before timeout */
  #define EIOCBQUEUED    529    /* iocb queued, will get completion event */
-#define EIOCBRETRY    530    /* iocb queued, will trigger a retry */

  #endif
