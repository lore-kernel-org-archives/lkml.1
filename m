Return-Path: <linux-kernel-owner+w=401wt.eu-S932341AbZKMT5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbZKMT5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932328AbZKMT5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:57:03 -0500
Received: from nox.protox.org ([88.191.38.29]:50974 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932268AbZKMT46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:56:58 -0500
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH 2/2] drm: mm always protect change to unused_nodes with unused_lock spinlock
Date: Fri, 13 Nov 2009 20:56:58 +0100
Message-Id: <1258142218-2070-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unused_nodes modification needs to be protected by unused_lock spinlock.
Here is an example of an usage where there is no such protection without
this patch.

  Process 1: 1-drm_mm_pre_get(this function modify unused_nodes list)
             2-spin_lock(spinlock protecting mm struct)
             3-drm_mm_put_block(this function might modify unused_nodes
               list but doesn't protect modification with unused_lock)
             4-spin_unlock(spinlock protecting mm struct)
  Process2:  1-drm_mm_pre_get(this function modify unused_nodes list)
At this point Process1 & Process2 might both be doing modification to
unused_nodes list. This patch add unused_lock protection into
drm_mm_put_block to avoid such issue.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/drm_mm.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_mm.c b/drivers/gpu/drm/drm_mm.c
index c861d80..97dc5a4 100644
--- a/drivers/gpu/drm/drm_mm.c
+++ b/drivers/gpu/drm/drm_mm.c
@@ -103,6 +103,11 @@ static struct drm_mm_node *drm_mm_kmalloc(struct drm_mm *mm, int atomic)
 	return child;
 }
 
+/* drm_mm_pre_get() - pre allocate drm_mm_node structure
+ * drm_mm:	memory manager struct we are pre-allocating for
+ *
+ * Returns 0 on success or -ENOMEM if allocation fails.
+ */
 int drm_mm_pre_get(struct drm_mm *mm)
 {
 	struct drm_mm_node *node;
@@ -253,12 +258,14 @@ void drm_mm_put_block(struct drm_mm_node *cur)
 				prev_node->size += next_node->size;
 				list_del(&next_node->ml_entry);
 				list_del(&next_node->fl_entry);
+				spin_lock(&mm->unused_lock);
 				if (mm->num_unused < MM_UNUSED_TARGET) {
 					list_add(&next_node->fl_entry,
 						 &mm->unused_nodes);
 					++mm->num_unused;
 				} else
 					kfree(next_node);
+				spin_unlock(&mm->unused_lock);
 			} else {
 				next_node->size += cur->size;
 				next_node->start = cur->start;
@@ -271,11 +278,13 @@ void drm_mm_put_block(struct drm_mm_node *cur)
 		list_add(&cur->fl_entry, &mm->fl_entry);
 	} else {
 		list_del(&cur->ml_entry);
+		spin_lock(&mm->unused_lock);
 		if (mm->num_unused < MM_UNUSED_TARGET) {
 			list_add(&cur->fl_entry, &mm->unused_nodes);
 			++mm->num_unused;
 		} else
 			kfree(cur);
+		spin_unlock(&mm->unused_lock);
 	}
 }
 
-- 
1.6.5.2

