Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbXIBCst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbXIBCst (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 22:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbXIBCrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 22:47:03 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:46212 "EHLO
	mail-01.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbXIBCq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 22:46:58 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: akpm@osdl.org, torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 5/5] Make wait_on_retry_sync_kiocb killable
Date: Sat,  1 Sep 2007 22:46:54 -0400
Message-Id: <11887012143804-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <20070902024348.GJ14130@parisc-linux.org>
References: <20070902024348.GJ14130@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use TASK_KILLABLE to allow wait_on_retry_sync_kiocb to return -EINTR.
All callers then check the return value and break out of their loops.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 fs/read_write.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 507ddff..b1a52d5 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -218,14 +218,15 @@ Einval:
 	return -EINVAL;
 }
 
-static void wait_on_retry_sync_kiocb(struct kiocb *iocb)
+static int wait_on_retry_sync_kiocb(struct kiocb *iocb)
 {
-	set_current_state(TASK_UNINTERRUPTIBLE);
+	set_current_state(TASK_KILLABLE);
 	if (!kiocbIsKicked(iocb))
 		schedule();
 	else
 		kiocbClearKicked(iocb);
 	__set_current_state(TASK_RUNNING);
+	return fatal_signal_pending(current) ? -EINTR : 0;
 }
 
 ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos)
@@ -242,7 +243,9 @@ ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *pp
 		ret = filp->f_op->aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
 		if (ret != -EIOCBRETRY)
 			break;
-		wait_on_retry_sync_kiocb(&kiocb);
+		ret = wait_on_retry_sync_kiocb(&kiocb);
+		if (ret)
+			break;
 	}
 
 	if (-EIOCBQUEUED == ret)
@@ -300,7 +303,9 @@ ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, lof
 		ret = filp->f_op->aio_write(&kiocb, &iov, 1, kiocb.ki_pos);
 		if (ret != -EIOCBRETRY)
 			break;
-		wait_on_retry_sync_kiocb(&kiocb);
+		ret = wait_on_retry_sync_kiocb(&kiocb);
+		if (ret)
+			break;
 	}
 
 	if (-EIOCBQUEUED == ret)
@@ -466,7 +471,9 @@ ssize_t do_sync_readv_writev(struct file *filp, const struct iovec *iov,
 		ret = fn(&kiocb, iov, nr_segs, kiocb.ki_pos);
 		if (ret != -EIOCBRETRY)
 			break;
-		wait_on_retry_sync_kiocb(&kiocb);
+		ret = wait_on_retry_sync_kiocb(&kiocb);
+		if (ret)
+			break;
 	}
 
 	if (ret == -EIOCBQUEUED)
-- 
1.4.4.2

