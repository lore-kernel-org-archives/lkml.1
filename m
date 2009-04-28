Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbZD1Mpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbZD1Mpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 08:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbZD1Mpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 08:45:36 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:38335 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756406AbZD1Mpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 08:45:36 -0400
Date: Tue, 28 Apr 2009 21:45:35 +0900 (JST)
Message-Id: <20090428.214535.71090234.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: [PATCH 3/7] blkio-cgroup: Refactoring io-context initialization
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090428.214457.226801820.ryov@valinux.co.jp>
References: <20090428.214423.193684619.ryov@valinux.co.jp>
	<20090428.214457.226801820.ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch refactors io_context initialization.

Based on 2.6.30-rc3-git3
Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>

---
 block/blk-ioc.c           |   30 +++++++++++++++++-------------
 include/linux/iocontext.h |    1 +
 2 files changed, 18 insertions(+), 13 deletions(-)

Index: linux-2.6.30-rc3-git3/block/blk-ioc.c
===================================================================
--- linux-2.6.30-rc3-git3.orig/block/blk-ioc.c
+++ linux-2.6.30-rc3-git3/block/blk-ioc.c
@@ -84,24 +84,28 @@ void exit_io_context(void)
 	}
 }
 
+void init_io_context(struct io_context *ioc)
+{
+	atomic_set(&ioc->refcount, 1);
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
-		atomic_set(&ret->refcount, 1);
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
Index: linux-2.6.30-rc3-git3/include/linux/iocontext.h
===================================================================
--- linux-2.6.30-rc3-git3.orig/include/linux/iocontext.h
+++ linux-2.6.30-rc3-git3/include/linux/iocontext.h
@@ -104,6 +104,7 @@ int put_io_context(struct io_context *io
 void exit_io_context(void);
 struct io_context *get_io_context(gfp_t gfp_flags, int node);
 struct io_context *alloc_io_context(gfp_t gfp_flags, int node);
+void init_io_context(struct io_context *ioc);
 void copy_io_context(struct io_context **pdst, struct io_context **psrc);
 #else
 static inline void exit_io_context(void)
