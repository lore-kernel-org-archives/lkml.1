Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbZG1MSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbZG1MSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 08:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZG1MSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 08:18:22 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:33795 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbZG1MSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 08:18:21 -0400
Date: Tue, 28 Jul 2009 21:18:20 +0900 (JST)
Message-Id: <20090728.211820.71102079.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: [PATCH 3/7] blkio-cgroup-v10: Refactoring io-context initialization
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090728.211754.226789461.ryov@valinux.co.jp>
References: <20090728.210934.193696111.ryov@valinux.co.jp>
	<20090728.211754.226789461.ryov@valinux.co.jp>
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

Index: linux-2.6.31-rc3-mm1/block/blk-ioc.c
===================================================================
--- linux-2.6.31-rc3-mm1.orig/block/blk-ioc.c
+++ linux-2.6.31-rc3-mm1/block/blk-ioc.c
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
Index: linux-2.6.31-rc3-mm1/include/linux/iocontext.h
===================================================================
--- linux-2.6.31-rc3-mm1.orig/include/linux/iocontext.h
+++ linux-2.6.31-rc3-mm1/include/linux/iocontext.h
@@ -104,6 +104,7 @@ int put_io_context(struct io_context *io
 void exit_io_context(void);
 struct io_context *get_io_context(gfp_t gfp_flags, int node);
 struct io_context *alloc_io_context(gfp_t gfp_flags, int node);
+void init_io_context(struct io_context *ioc);
 void copy_io_context(struct io_context **pdst, struct io_context **psrc);
 #else
 static inline void exit_io_context(void)
