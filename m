Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbYKRIzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbYKRIzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYKRIyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:54:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57614 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbYKRIyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:54:35 -0500
Message-ID: <4922820D.4000802@cn.fujitsu.com>
Date: Tue, 18 Nov 2008 16:51:25 +0800
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
Subject: [PATCH V2 4/4] sysipc: use kvmalloc()/kvfree_atomic()
References: <492162E4.9080902@cn.fujitsu.com> <20081117131440.GB29931@cmpxchg.org>
In-Reply-To: <20081117131440.GB29931@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


RCU callback here use vfree()
use kvmalloc()/kvfree_atomic() make it simple


Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 util.c |  116 ++++++++++-------------------------------------------------------
 1 file changed, 19 insertions(+), 97 deletions(-)
diff --git a/ipc/util.c b/ipc/util.c
index 49b3ea6..3ecf04d 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -468,51 +468,16 @@ void ipc_free(void* ptr, int size)
 		kfree(ptr);
 }
 
-/*
- * rcu allocations:
- * There are three headers that are prepended to the actual allocation:
- * - during use: ipc_rcu_hdr.
- * - during the rcu grace period: ipc_rcu_grace.
- * - [only if vmalloc]: ipc_rcu_sched.
- * Their lifetime doesn't overlap, thus the headers share the same memory.
- * Unlike a normal union, they are right-aligned, thus some container_of
- * forward/backward casting is necessary:
- */
 struct ipc_rcu_hdr
 {
-	int refcount;
-	int is_vmalloc;
-	void *data[0];
-};
-
-
-struct ipc_rcu_grace
-{
-	struct rcu_head rcu;
+	union {
+		int refcount;
+		struct rcu_head rcu;
+	};
 	/* "void *" makes sure alignment of following data is sane. */
 	void *data[0];
 };
 
-struct ipc_rcu_sched
-{
-	struct work_struct work;
-	/* "void *" makes sure alignment of following data is sane. */
-	void *data[0];
-};
-
-#define HDRLEN_KMALLOC		(sizeof(struct ipc_rcu_grace) > sizeof(struct ipc_rcu_hdr) ? \
-					sizeof(struct ipc_rcu_grace) : sizeof(struct ipc_rcu_hdr))
-#define HDRLEN_VMALLOC		(sizeof(struct ipc_rcu_sched) > HDRLEN_KMALLOC ? \
-					sizeof(struct ipc_rcu_sched) : HDRLEN_KMALLOC)
-
-static inline int rcu_use_vmalloc(int size)
-{
-	/* Too big for a single page? */
-	if (HDRLEN_KMALLOC + size > PAGE_SIZE)
-		return 1;
-	return 0;
-}
-
 /**
  *	ipc_rcu_alloc	-	allocate ipc and rcu space 
  *	@size: size desired
@@ -522,30 +487,18 @@ static inline int rcu_use_vmalloc(int size)
  *	NULL is returned if the allocation fails. 
  */
  
-void* ipc_rcu_alloc(int size)
+void *ipc_rcu_alloc(int size)
 {
-	void* out;
 	/* 
-	 * We prepend the allocation with the rcu struct, and
-	 * workqueue if necessary (for vmalloc). 
+	 * We prepend the allocation with the ipc_rcu_hdr
 	 */
-	if (rcu_use_vmalloc(size)) {
-		out = vmalloc(HDRLEN_VMALLOC + size);
-		if (out) {
-			out += HDRLEN_VMALLOC;
-			container_of(out, struct ipc_rcu_hdr, data)->is_vmalloc = 1;
-			container_of(out, struct ipc_rcu_hdr, data)->refcount = 1;
-		}
-	} else {
-		out = kmalloc(HDRLEN_KMALLOC + size, GFP_KERNEL);
-		if (out) {
-			out += HDRLEN_KMALLOC;
-			container_of(out, struct ipc_rcu_hdr, data)->is_vmalloc = 0;
-			container_of(out, struct ipc_rcu_hdr, data)->refcount = 1;
-		}
-	}
+	struct ipc_rcu_hdr *hdr = kvmalloc(sizeof(struct ipc_rcu_hdr) + size,
+			GFP_KERNEL);
+	if (!hdr)
+		return NULL;
 
-	return out;
+	hdr->refcount = 1;
+	return hdr->data;
 }
 
 void ipc_rcu_getref(void *ptr)
@@ -553,56 +506,25 @@ void ipc_rcu_getref(void *ptr)
 	container_of(ptr, struct ipc_rcu_hdr, data)->refcount++;
 }
 
-static void ipc_do_vfree(struct work_struct *work)
-{
-	vfree(container_of(work, struct ipc_rcu_sched, work));
-}
-
 /**
- * ipc_schedule_free - free ipc + rcu space
+ * ipc_free_rcu - free ipc + ipc_rcu_hdr
  * @head: RCU callback structure for queued work
  * 
  * Since RCU callback function is called in bh,
- * we need to defer the vfree to schedule_work().
- */
-static void ipc_schedule_free(struct rcu_head *head)
-{
-	struct ipc_rcu_grace *grace;
-	struct ipc_rcu_sched *sched;
-
-	grace = container_of(head, struct ipc_rcu_grace, rcu);
-	sched = container_of(&(grace->data[0]), struct ipc_rcu_sched,
-				data[0]);
-
-	INIT_WORK(&sched->work, ipc_do_vfree);
-	schedule_work(&sched->work);
-}
-
-/**
- * ipc_immediate_free - free ipc + rcu space
- * @head: RCU callback structure that contains pointer to be freed
- *
- * Free from the RCU callback context.
+ * we need to use kvfree_atomic().
  */
-static void ipc_immediate_free(struct rcu_head *head)
+static void ipc_free_rcu(struct rcu_head *head)
 {
-	struct ipc_rcu_grace *free =
-		container_of(head, struct ipc_rcu_grace, rcu);
-	kfree(free);
+	kvfree_atomic(container_of(head, struct ipc_rcu_hdr, rcu));
 }
 
 void ipc_rcu_putref(void *ptr)
 {
-	if (--container_of(ptr, struct ipc_rcu_hdr, data)->refcount > 0)
+	struct ipc_rcu_hdr *hdr = container_of(ptr, struct ipc_rcu_hdr, data);
+	if (--hdr->refcount > 0)
 		return;
 
-	if (container_of(ptr, struct ipc_rcu_hdr, data)->is_vmalloc) {
-		call_rcu(&container_of(ptr, struct ipc_rcu_grace, data)->rcu,
-				ipc_schedule_free);
-	} else {
-		call_rcu(&container_of(ptr, struct ipc_rcu_grace, data)->rcu,
-				ipc_immediate_free);
-	}
+	call_rcu(&hdr->rcu, ipc_free_rcu);
 }
 
 /**


