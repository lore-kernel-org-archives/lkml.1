Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbZJBL50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbZJBL50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 07:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbZJBL5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 07:57:24 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:37850 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbZJBL5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 07:57:22 -0400
Date: Fri, 02 Oct 2009 20:57:25 +0900 (JST)
Message-Id: <20091002.205725.104059507.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: [PATCH 4/9] blkio-cgroup-v13: Refactoring io-context initialization
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20091002.205701.71114259.ryov@valinux.co.jp>
References: <20091002.205607.193712402.ryov@valinux.co.jp>
	<20091002.205635.226776464.ryov@valinux.co.jp>
	<20091002.205701.71114259.ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch refactors io_context initialization.

Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>

---
 block/blk-ioc.c           |   30 +++++++++++++++++-------------
 include/linux/iocontext.h |    1 +
 2 files changed, 18 insertions(+), 13 deletions(-)

Index: linux-2.6.32-rc1/block/blk-ioc.c
===================================================================
--- linux-2.6.32-rc1.orig/block/blk-ioc.c
+++ linux-2.6.32-rc1/block/blk-ioc.c
@@ -84,24 +84,28 @@ void exit_io_context(void)
 	}
 }
 
+void init_io_context(struct io_context *ioc)
+{
+	atomic_long_set(&ioc->refcount, 1);
+	atomic_set(&ioc->nr_tasks, 1);
+	spin_lock_init(&ioc->lock);
+	ioc->ioprio_changed = 0;
+	ioc->ioprio = 0;
+	ioc->last_waited = jiffies; /* doesn't matter... */
+	ioc->nr_batch_requests = 0; /* because this is 0 */
+	ioc->aic = NULL;
+	INIT_RADIX_TREE(&ioc->radix_root, GFP_ATOMIC | __GFP_HIGH);
+	INIT_HLIST_HEAD(&ioc->cic_list);
+	ioc->ioc_data = NULL;
+}
+
 struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
 {
 	struct io_context *ret;
 
 	ret = kmem_cache_alloc_node(iocontext_cachep, gfp_flags, node);
-	if (ret) {
-		atomic_long_set(&ret->refcount, 1);
-		atomic_set(&ret->nr_tasks, 1);
-		spin_lock_init(&ret->lock);
-		ret->ioprio_changed = 0;
-		ret->ioprio = 0;
-		ret->last_waited = jiffies; /* doesn't matter... */
-		ret->nr_batch_requests = 0; /* because this is 0 */
-		ret->aic = NULL;
-		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC | __GFP_HIGH);
-		INIT_HLIST_HEAD(&ret->cic_list);
-		ret->ioc_data = NULL;
-	}
+	if (ret)
+		init_io_context(ret);
 
 	return ret;
 }
Index: linux-2.6.32-rc1/include/linux/iocontext.h
===================================================================
--- linux-2.6.32-rc1.orig/include/linux/iocontext.h
+++ linux-2.6.32-rc1/include/linux/iocontext.h
@@ -104,6 +104,7 @@ int put_io_context(struct io_context *io
 void exit_io_context(void);
 struct io_context *get_io_context(gfp_t gfp_flags, int node);
 struct io_context *alloc_io_context(gfp_t gfp_flags, int node);
+void init_io_context(struct io_context *ioc);
 void copy_io_context(struct io_context **pdst, struct io_context **psrc);
 #else
 static inline void exit_io_context(void)
