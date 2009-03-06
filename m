Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbZCFP4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbZCFP4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756363AbZCFPzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:55:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:35726 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756337AbZCFPzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:55:48 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, npiggin@suse.de,
       akpm@linux-foundation.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] percpu: move fully free chunk reclamation into a work
Date: Sat,  7 Mar 2009 00:54:42 +0900
Message-Id: <1236354883-25063-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236354883-25063-1-git-send-email-tj@kernel.org>
References: <1236354883-25063-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 15:54:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: code reorganization for later changes

Do fully free chunk reclamation using a work.  This change is to
prepare for locking changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu.c |   48 ++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 7d9bc35..4c8a419 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -63,6 +63,7 @@
 #include <linux/rbtree.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/workqueue.h>
 
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
@@ -118,6 +119,10 @@ static DEFINE_MUTEX(pcpu_mutex);
 static struct list_head *pcpu_slot __read_mostly; /* chunk list slots */
 static struct rb_root pcpu_addr_root = RB_ROOT;	/* chunks by address */
 
+/* reclaim work to release fully free chunks, scheduled from free path */
+static void pcpu_reclaim(struct work_struct *work);
+static DECLARE_WORK(pcpu_reclaim_work, pcpu_reclaim);
+
 static int __pcpu_size_to_slot(int size)
 {
 	int highbit = fls(size);	/* size is in bytes */
@@ -846,13 +851,37 @@ void *__alloc_reserved_percpu(size_t size, size_t align)
 	return pcpu_alloc(size, align, true);
 }
 
-static void pcpu_kill_chunk(struct pcpu_chunk *chunk)
+/**
+ * pcpu_reclaim - reclaim fully free chunks, workqueue function
+ * @work: unused
+ *
+ * Reclaim all fully free chunks except for the first one.
+ */
+static void pcpu_reclaim(struct work_struct *work)
 {
-	WARN_ON(chunk->immutable);
-	pcpu_depopulate_chunk(chunk, 0, pcpu_unit_size, false);
-	list_del(&chunk->list);
-	rb_erase(&chunk->rb_node, &pcpu_addr_root);
-	free_pcpu_chunk(chunk);
+	LIST_HEAD(todo);
+	struct list_head *head = &pcpu_slot[pcpu_nr_slots - 1];
+	struct pcpu_chunk *chunk, *next;
+
+	mutex_lock(&pcpu_mutex);
+
+	list_for_each_entry_safe(chunk, next, head, list) {
+		WARN_ON(chunk->immutable);
+
+		/* spare the first one */
+		if (chunk == list_first_entry(head, struct pcpu_chunk, list))
+			continue;
+
+		rb_erase(&chunk->rb_node, &pcpu_addr_root);
+		list_move(&chunk->list, &todo);
+	}
+
+	mutex_unlock(&pcpu_mutex);
+
+	list_for_each_entry_safe(chunk, next, &todo, list) {
+		pcpu_depopulate_chunk(chunk, 0, pcpu_unit_size, false);
+		free_pcpu_chunk(chunk);
+	}
 }
 
 /**
@@ -877,14 +906,13 @@ void free_percpu(void *ptr)
 
 	pcpu_free_area(chunk, off);
 
-	/* the chunk became fully free, kill one if there are other free ones */
+	/* if there are more than one fully free chunks, wake up grim reaper */
 	if (chunk->free_size == pcpu_unit_size) {
 		struct pcpu_chunk *pos;
 
-		list_for_each_entry(pos,
-				    &pcpu_slot[pcpu_chunk_slot(chunk)], list)
+		list_for_each_entry(pos, &pcpu_slot[pcpu_nr_slots - 1], list)
 			if (pos != chunk) {
-				pcpu_kill_chunk(pos);
+				schedule_work(&pcpu_reclaim_work);
 				break;
 			}
 	}
-- 
1.6.0.2

