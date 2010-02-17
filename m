Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab0BQUdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 15:33:23 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38854 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540Ab0BQUaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 15:30:07 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/18] radix-tree: disable RCU lockdep checking in radix tree
Date: Wed, 17 Feb 2010 12:29:36 -0800
Message-Id: <1266438584-29173-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100217202924.GA29007@linux.vnet.ibm.com>
References: <20100217202924.GA29007@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the radix tree is used with many different locking designs, we
cannot do any effective checking without changing the radix-tree APIs.
It might make sense to do this later, but only if the RCU lockdep checking
proves itself sufficiently valuable.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 lib/radix-tree.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 92cdd99..6b9670d 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -364,7 +364,7 @@ static void *radix_tree_lookup_element(struct radix_tree_root *root,
 	unsigned int height, shift;
 	struct radix_tree_node *node, **slot;
 
-	node = rcu_dereference(root->rnode);
+	node = rcu_dereference_raw(root->rnode);
 	if (node == NULL)
 		return NULL;
 
@@ -384,7 +384,7 @@ static void *radix_tree_lookup_element(struct radix_tree_root *root,
 	do {
 		slot = (struct radix_tree_node **)
 			(node->slots + ((index>>shift) & RADIX_TREE_MAP_MASK));
-		node = rcu_dereference(*slot);
+		node = rcu_dereference_raw(*slot);
 		if (node == NULL)
 			return NULL;
 
@@ -568,7 +568,7 @@ int radix_tree_tag_get(struct radix_tree_root *root,
 	if (!root_tag_get(root, tag))
 		return 0;
 
-	node = rcu_dereference(root->rnode);
+	node = rcu_dereference_raw(root->rnode);
 	if (node == NULL)
 		return 0;
 
@@ -602,7 +602,7 @@ int radix_tree_tag_get(struct radix_tree_root *root,
 			BUG_ON(ret && saw_unset_tag);
 			return !!ret;
 		}
-		node = rcu_dereference(node->slots[offset]);
+		node = rcu_dereference_raw(node->slots[offset]);
 		shift -= RADIX_TREE_MAP_SHIFT;
 		height--;
 	}
@@ -711,7 +711,7 @@ __lookup(struct radix_tree_node *slot, void ***results, unsigned long index,
 		}
 
 		shift -= RADIX_TREE_MAP_SHIFT;
-		slot = rcu_dereference(slot->slots[i]);
+		slot = rcu_dereference_raw(slot->slots[i]);
 		if (slot == NULL)
 			goto out;
 	}
@@ -758,7 +758,7 @@ radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
 	unsigned long cur_index = first_index;
 	unsigned int ret;
 
-	node = rcu_dereference(root->rnode);
+	node = rcu_dereference_raw(root->rnode);
 	if (!node)
 		return 0;
 
@@ -787,7 +787,7 @@ radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
 			slot = *(((void ***)results)[ret + i]);
 			if (!slot)
 				continue;
-			results[ret + nr_found] = rcu_dereference(slot);
+			results[ret + nr_found] = rcu_dereference_raw(slot);
 			nr_found++;
 		}
 		ret += nr_found;
@@ -826,7 +826,7 @@ radix_tree_gang_lookup_slot(struct radix_tree_root *root, void ***results,
 	unsigned long cur_index = first_index;
 	unsigned int ret;
 
-	node = rcu_dereference(root->rnode);
+	node = rcu_dereference_raw(root->rnode);
 	if (!node)
 		return 0;
 
@@ -915,7 +915,7 @@ __lookup_tag(struct radix_tree_node *slot, void ***results, unsigned long index,
 			}
 		}
 		shift -= RADIX_TREE_MAP_SHIFT;
-		slot = rcu_dereference(slot->slots[i]);
+		slot = rcu_dereference_raw(slot->slots[i]);
 		if (slot == NULL)
 			break;
 	}
@@ -951,7 +951,7 @@ radix_tree_gang_lookup_tag(struct radix_tree_root *root, void **results,
 	if (!root_tag_get(root, tag))
 		return 0;
 
-	node = rcu_dereference(root->rnode);
+	node = rcu_dereference_raw(root->rnode);
 	if (!node)
 		return 0;
 
@@ -980,7 +980,7 @@ radix_tree_gang_lookup_tag(struct radix_tree_root *root, void **results,
 			slot = *(((void ***)results)[ret + i]);
 			if (!slot)
 				continue;
-			results[ret + nr_found] = rcu_dereference(slot);
+			results[ret + nr_found] = rcu_dereference_raw(slot);
 			nr_found++;
 		}
 		ret += nr_found;
@@ -1020,7 +1020,7 @@ radix_tree_gang_lookup_tag_slot(struct radix_tree_root *root, void ***results,
 	if (!root_tag_get(root, tag))
 		return 0;
 
-	node = rcu_dereference(root->rnode);
+	node = rcu_dereference_raw(root->rnode);
 	if (!node)
 		return 0;
 
-- 
1.6.6

