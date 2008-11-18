Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbYKRIyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbYKRIyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYKRIyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:54:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52710 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbYKRIyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:54:21 -0500
Message-ID: <492281F7.3000107@cn.fujitsu.com>
Date: Tue, 18 Nov 2008 16:51:03 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, David Miller <davem@davemloft.net>,
       Dave Airlie <airlied@gmail.com>, Paul Menage <menage@google.com>,
       kamezawa.hiroyu@jp.fujitsu.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, Jan Kara <jack@suse.cz>,
       Jes Sorensen <jes@sgi.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, dada1@cosmosbay.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <npiggin@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH V2 1/4] vmalloc: introduce vfree_atomic()
References: <492162E4.9080902@cn.fujitsu.com> <20081117131440.GB29931@cmpxchg.org>
In-Reply-To: <20081117131440.GB29931@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fdtable and sysipc use vfree() in RCU callback. this patch
introduce vfree_atomic() for them.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 307b885..195379a 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -60,6 +60,7 @@ extern void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot);
 extern void *__vmalloc_area(struct vm_struct *area, gfp_t gfp_mask,
 				pgprot_t prot);
 extern void vfree(const void *addr);
+extern void vfree_atomic(void *addr);
 
 extern void *vmap(struct page **pages, unsigned int count,
 			unsigned long flags, pgprot_t prot);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ba6b0f5..39c164e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -23,6 +23,7 @@
 #include <linux/rbtree.h>
 #include <linux/radix-tree.h>
 #include <linux/rcupdate.h>
+#include <linux/workqueue.h>
 
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
@@ -1177,6 +1178,21 @@ void vfree(const void *addr)
 }
 EXPORT_SYMBOL(vfree);
 
+static void vfree_defer(struct work_struct *work)
+{
+	vfree(work);
+}
+
+void vfree_atomic(void *ptr)
+{
+	if (ptr) {
+		struct work_struct *work = ptr;
+		INIT_WORK(work, vfree_defer);
+		schedule_work(work);
+	}
+}
+EXPORT_SYMBOL_GPL(vfree_atomic);
+
 /**
  *	vunmap  -  release virtual mapping obtained by vmap()
  *	@addr:		memory base address

