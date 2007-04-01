Return-Path: <linux-kernel-owner+w=401wt.eu-S933543AbXDAQGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543AbXDAQGc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 12:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933593AbXDAQDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 12:03:52 -0400
Received: from haxent.com ([65.99.219.155]:2920 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933591AbXDAQDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 12:03:32 -0400
Message-Id: <20070401160312.014245000@haxent.com.br>
References: <20070401155810.277757000@haxent.com.br>
User-Agent: quilt/0.46-1
Date: Sun, 01 Apr 2007 12:58:19 -0300
From: davi@haxent.com.br
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 09/12] pollfs: check if a AIO event ring is empty
Content-Disposition: inline; filename=pollfs-aio-ring-empty.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The aio_ring_empty() function returns true if the AIO event ring has no
elements, false otherwise.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>
---

Index: linux-2.6/fs/aio.c
===================================================================
--- linux-2.6.orig/fs/aio.c
+++ linux-2.6/fs/aio.c
@@ -1004,6 +1004,23 @@ put_rq:
 	return ret;
 }
 
+int fastcall aio_ring_empty(struct kioctx *ioctx)
+{
+	struct aio_ring_info *info = &ioctx->ring_info;
+	struct aio_ring *ring;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&ioctx->ctx_lock, flags);
+	ring = kmap_atomic(info->ring_pages[0], KM_IRQ1);
+	if (ring->head == ring->tail)
+		ret = 1;
+	kunmap_atomic(ring, KM_IRQ1);
+	spin_unlock_irqrestore(&ioctx->ctx_lock, flags);
+
+	return ret;
+}
+
 /* aio_read_evt
  *	Pull an event off of the ioctx's event ring.  Returns the number of 
  *	events fetched (0 or 1 ;-)
Index: linux-2.6/include/linux/aio.h
===================================================================
--- linux-2.6.orig/include/linux/aio.h
+++ linux-2.6/include/linux/aio.h
@@ -202,6 +202,7 @@ extern unsigned aio_max_size;
 
 extern ssize_t FASTCALL(wait_on_sync_kiocb(struct kiocb *iocb));
 extern int FASTCALL(aio_put_req(struct kiocb *iocb));
+extern int FASTCALL(aio_ring_empty(struct kioctx *ioctx));
 extern void FASTCALL(kick_iocb(struct kiocb *iocb));
 extern int FASTCALL(aio_complete(struct kiocb *iocb, long res, long res2));
 extern void FASTCALL(__put_ioctx(struct kioctx *ctx));

-- 
