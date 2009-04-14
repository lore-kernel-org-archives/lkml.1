Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbZDNGUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbZDNGUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 02:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbZDNGU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 02:20:26 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43223 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZDNGUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 02:20:24 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, Zach Brown <zach.brown@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-api@vger.kernel.org
Subject: [RFC][PATCH v3 4/6] aio: Don't inherit aio ring memory at fork
Cc: kosaki.motohiro@jp.fujitsu.com, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrea Arcangeli <aarcange@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20090414151204.C647.A69D9226@jp.fujitsu.com>
References: <20090414151204.C647.A69D9226@jp.fujitsu.com>
Message-Id: <20090414151924.C653.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 14 Apr 2009 15:20:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AIO folks, Am I missing anything?

===============
Subject: [RFC][PATCH] aio: Don't inherit aio ring memory at fork

Currently, mm_struct::ioctx_list member isn't copyed at fork. IOW aio context don't inherit at fork.
but only ring memory inherited. that's strange.

This patch mark DONTFORK to ring-memory too.
In addition, This patch has good side effect. it also fix "get_user_pages() vs fork" problem.

I think "man fork" also sould be changed. it only say

       *  The child does not inherit outstanding asynchronous I/O operations from
          its parent (aio_read(3), aio_write(3)).

but aio_context_t (return value of io_setup(2)) also don't inherit in current implementaion.


Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org,
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/aio.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: b/fs/aio.c
===================================================================
--- a/fs/aio.c	2009-04-12 23:33:59.000000000 +0900
+++ b/fs/aio.c	2009-04-13 02:56:05.000000000 +0900
@@ -106,6 +106,7 @@ static int aio_setup_ring(struct kioctx 
 	unsigned nr_events = ctx->max_reqs;
 	unsigned long size;
 	int nr_pages;
+	int ret;
 
 	/* Compensate for the ring buffer's head/tail overlap entry */
 	nr_events += 2;	/* 1 is required, 2 for good luck */
@@ -140,6 +141,13 @@ static int aio_setup_ring(struct kioctx 
 		return -EAGAIN;
 	}
 
+	/*
+	 * aio context doesn't inherit while fork. (see mm_init())
+	 * Then, aio ring also mark DONTFORK.
+	 */
+	ret = sys_madvise(info->mmap_base, info->mmap_size, MADV_DONTFORK);
+	BUG_ON(ret);
+
 	dprintk("mmap address: 0x%08lx\n", info->mmap_base);
 	info->nr_pages = get_user_pages(current, ctx->mm,
 					info->mmap_base, nr_pages, 


