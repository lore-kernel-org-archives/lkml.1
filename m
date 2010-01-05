Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab0AECEY (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 4 Jan 2010 21:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030Ab0AECEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:04:21 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34965 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab0AECEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:04:15 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 7/8] radix-tree: disable RCU lockdep checking in radix tree
Date: Mon,  4 Jan 2010 18:04:10 -0800
Message-Id: <12626570512382-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20100105020345.GA32114@linux.vnet.ibm.com>
References: <20100105020345.GA32114@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Because the radix tree is used with many different locking designs, we
cannot do any effective checking without changing the radix-tree APIs.
It might make sense to do this later, but only if the RCU lockdep checking
proves itself sufficiently valuable.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 lib/radix-tree.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 23abbd9..46724e2 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -361,7 +361,7 @@ static void *radix_tree_lookup_element(struct radix_tree_root *root,
 	unsigned int height, shift;
 	struct radix_tree_node *node, **slot;
 
-	node = rcu_dereference(root->rnode);
+	node = rcu_dereference_raw(root->rnode);
 	if (node == NULL)
 		return NULL;
 
@@ -381,7 +381,7 @@ static void *radix_tree_lookup_element(struct radix_tree_root *root,
 	do {
 		slot = (struct radix_tree_node **)
 			(node->slots + ((index>>shift) & RADIX_TREE_MAP_MASK));
-		node = rcu_dereference(*slot);
+		node = rcu_dereference_raw(*slot);
 		if (node == NULL)
 			return NULL;
 
@@ -566,7 +566,7 @@ int radix_tree_tag_get(struct radix_tree_root *root,
 	if (!root_tag_get(root, tag))
 		return 0;
 
-	node = rcu_dereference(root->rnode);
+	node = rcu_dereference_raw(root->rnode);
 	if (node == NULL)
 		return 0;
 
@@ -600,7 +600,7 @@ int radix_tree_tag_get(struct radix_tree_root *root,
 			BUG_ON(ret && saw_unset_tag);
 			return !!ret;
 		}
-		node = rcu_dereference(node->slots[offset]);
+		node = rcu_dereference_raw(node->slots[offset]);
 		shift -= RADIX_TREE_MAP_SHIFT;
 		height--;
 	}
@@ -710,7 +710,7 @@ __lookup(struct radix_tree_node *slot, void ***results, unsigned long index,
 		}
 
 		shift -= RADIX_TREE_MAP_SHIFT;
-		slot = rcu_dereference(slot->slots[i]);
+		slot = rcu_dereference_raw(slot->slots[i]);
 		if (slot == NULL)
 			goto out;
 	}
@@ -757,7 +757,7 @@ radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
 	unsigned long cur_index = first_index;
 	unsigned int ret;
 
-	node = rcu_dereference(root->rnode);
+	node = rcu_dereference_raw(root->rnode);
 	if (!node)
 		return 0;
 
@@ -786,7 +786,7 @@ radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
 			slot = *(((void ***)results)[ret + i]);
 			if (!slot)
 				continue;
-			results[ret + nr_found] = rcu_dereference(slot);
+			results[ret + nr_found] = rcu_dereference_raw(slot);
 			nr_found++;
 		}
 		ret += nr_found;
@@ -825,7 +825,7 @@ radix_tree_gang_lookup_slot(struct radix_tree_root *root, void ***results,
 	unsigned long cur_index = first_index;
 	unsigned int ret;
 
-	node = rcu_dereference(root->rnode);
+	node = rcu_dereference_raw(root->rnode);
 	if (!node)
 		return 0;
 
@@ -914,7 +914,7 @@ __lookup_tag(struct radix_tree_node *slot, void ***results, unsigned long index,
 			}
 		}
 		shift -= RADIX_TREE_MAP_SHIFT;
-		slot = rcu_dereference(slot->slots[i]);
+		slot = rcu_dereference_raw(slot->slots[i]);
 		if (slot == NULL)
 			break;
 	}
@@ -950,7 +950,7 @@ radix_tree_gang_lookup_tag(struct radix_tree_root *root, void **results,
 	if (!root_tag_get(root, tag))
 		return 0;
 
-	node = rcu_dereference(root->rnode);
+	node = rcu_dereference_raw(root->rnode);
 	if (!node)
 		return 0;
 
@@ -979,7 +979,7 @@ radix_tree_gang_lookup_tag(struct radix_tree_root *root, void **results,
 			slot = *(((void ***)results)[ret + i]);
 			if (!slot)
 				continue;
-			results[ret + nr_found] = rcu_dereference(slot);
+			results[ret + nr_found] = rcu_dereference_raw(slot);
 			nr_found++;
 		}
 		ret += nr_found;
@@ -1019,7 +1019,7 @@ radix_tree_gang_lookup_tag_slot(struct radix_tree_root *root, void ***results,
 	if (!root_tag_get(root, tag))
 		return 0;
 
-	node = rcu_dereference(root->rnode);
+	node = rcu_dereference_raw(root->rnode);
 	if (!node)
 		return 0;
 
-- 
1.5.2.5

