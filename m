Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab0BYKMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:12:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:40863 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758940Ab0BYKMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:12:42 -0500
Date: Thu, 25 Feb 2010 10:12:11 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1266887105-1528-10-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1266887105-1528-10-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] radix-tree: Disable RCU lockdep checking in radix tree
Message-ID: <tip-2676a58c980b7ef076cc9bbff3fd8c9d2d5417ea@git.kernel.org>
Git-Commit-ID: 2676a58c980b7ef076cc9bbff3fd8c9d2d5417ea
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 10:12:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2676a58c980b7ef076cc9bbff3fd8c9d2d5417ea
Gitweb:     http://git.kernel.org/tip/2676a58c980b7ef076cc9bbff3fd8c9d2d5417ea
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 22 Feb 2010 17:04:54 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 10:34:50 +0100

radix-tree: Disable RCU lockdep checking in radix tree

Because the radix tree is used with many different locking
designs, we cannot do any effective checking without changing
the radix-tree APIs. It might make sense to do this later, but
only if the RCU lockdep checking proves itself sufficiently
valuable.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <1266887105-1528-10-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
