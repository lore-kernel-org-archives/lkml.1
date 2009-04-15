Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbZDOC7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbZDOC7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 22:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbZDOC67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 22:58:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60328 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbZDOC66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 22:58:58 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jeff Moyer <jmoyer@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v4] aio: Don't inherit aio ring memory at fork
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090415115440.AC2E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 15 Apr 2009 11:58:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ChangeLog
	since V3
	  - remvoe BUG_ON
	  - change comment properly (thanks Jeff!)

	V1, V2: not posted

--------------------------------
Subject: [PATCH] aio: Don't inherit aio ring memory at fork

Currently, mm_struct::ioctx_list member isn't copyed at fork. IOW aio 
context don't inherit at fork.
but only ring memory inherited. that's strange.

This patch mark DONTFORK to ring-memory too.


Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/aio.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

Index: b/fs/aio.c
===================================================================
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -106,6 +106,7 @@ static int aio_setup_ring(struct kioctx 
 	unsigned nr_events = ctx->max_reqs;
 	unsigned long size;
 	int nr_pages;
+	int ret;
 
 	/* Compensate for the ring buffer's head/tail overlap entry */
 	nr_events += 2;	/* 1 is required, 2 for good luck */
@@ -140,6 +141,18 @@ static int aio_setup_ring(struct kioctx 
 		return -EAGAIN;
 	}
 
+	/*
+	 * The io_context is not inherited by the child after fork()
+	 * (see mm_init).  Therefore, it makes little sense for the
+	 * completion ring to be inherited.
+	 */
+	ret = sys_madvise(info->mmap_base, info->mmap_size, MADV_DONTFORK);
+	if (ret < 0) {
+		up_write(&ctx->mm->mmap_sem);
+		aio_free_ring(ctx);
+		return -EAGAIN;
+	}
+
 	dprintk("mmap address: 0x%08lx\n", info->mmap_base);
 	info->nr_pages = get_user_pages(current, ctx->mm,
 					info->mmap_base, nr_pages, 


