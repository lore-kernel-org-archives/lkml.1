Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbYJ3TYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbYJ3TYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbYJ3TXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:23:55 -0400
Received: from smtp-out.google.com ([216.239.45.13]:38399 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbYJ3TXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:23:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=Jq17ClNY0BTldqlPgiUh4MKOzbIgPq5AIJ0RFvHfeUpRyBOfNfJYnHlQMJUlzcMi8
	/poUl7yuHYpOqsHIWM9/w==
Date: Thu, 30 Oct 2008 12:23:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <cl@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <peterz@infradead.org>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
Subject: [patch 1/7] cpusets: add dirty map to struct address_space
In-Reply-To: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0810300310180.18283@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux-foundation.org>

In a NUMA system it is helpful to know where the dirty pages of a mapping
are located.  That way we will be able to implement writeout for
applications that are constrained to a portion of the memory of the
system as required by cpusets.

This patch implements the management of dirty node maps for an address
space through the following functions:

cpuset_clear_dirty_nodes(mapping)	Clear the map of dirty nodes

cpuset_update_nodes(mapping, page)	Record a node in the dirty nodes
					map

cpuset_init_dirty_nodes(mapping)	Initialization of the map


The dirty map may be stored either directly in the mapping (for NUMA
systems with less then BITS_PER_LONG nodes) or separately allocated for
systems with a large number of nodes (f.e. ia64 with 1024 nodes).

Updating the dirty map may involve allocating it first for large
configurations.  Therefore, we protect the allocation and setting of a
node in the map through the tree_lock.  The tree_lock is already taken
when a page is dirtied so there is no additional locking overhead if we
insert the updating of the nodemask there.

The dirty map is only cleared (or freed) when the inode is cleared.  At
that point no pages are attached to the inode anymore and therefore it
can be done without any locking. The dirty map therefore records all nodes
that have been used for dirty pages by that inode until the inode is no
longer used.

If the mapping for an inode's set of dirty nodes does not intersect the
set under writeback, the inode is requeued for later.  This is the
mechanism for enforcing the writeback control's set of nodes policy.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Menage <menage@google.com>
Cc: Derek Fults <dfults@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/buffer.c               |    2 +
 fs/fs-writeback.c         |    7 ++++++
 fs/inode.c                |    3 ++
 include/linux/cpuset.h    |   51 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h        |    7 ++++++
 include/linux/writeback.h |    2 +
 kernel/cpuset.c           |   53 +++++++++++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c       |    2 +
 8 files changed, 127 insertions(+), 0 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -41,6 +41,7 @@
 #include <linux/bitops.h>
 #include <linux/mpage.h>
 #include <linux/bit_spinlock.h>
+#include <linux/cpuset.h>
 
 static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
 
@@ -719,6 +720,7 @@ static int __set_page_dirty(struct page *page,
 		radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 	}
+	cpuset_update_dirty_nodes(mapping, page);
 	spin_unlock_irq(&mapping->tree_lock);
 	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -23,6 +23,7 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/buffer_head.h>
+#include <linux/cpuset.h>
 #include "internal.h"
 
 
@@ -487,6 +488,12 @@ void generic_sync_sb_inodes(struct super_block *sb,
 			continue;		/* blockdev has wrong queue */
 		}
 
+		if (!cpuset_intersects_dirty_nodes(mapping, wbc->nodes)) {
+			/* No node pages under writeback */
+			requeue_io(inode);
+			continue;
+		}
+
 		/* Was this inode dirtied after sync_sb_inodes was called? */
 		if (time_after(inode->dirtied_when, start))
 			break;
diff --git a/fs/inode.c b/fs/inode.c
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -22,6 +22,7 @@
 #include <linux/bootmem.h>
 #include <linux/inotify.h>
 #include <linux/mount.h>
+#include <linux/cpuset.h>
 
 /*
  * This is needed for the following functions:
@@ -167,6 +168,7 @@ static struct inode *alloc_inode(struct super_block *sb)
 		mapping->assoc_mapping = NULL;
 		mapping->backing_dev_info = &default_backing_dev_info;
 		mapping->writeback_index = 0;
+		cpuset_init_dirty_nodes(mapping);
 
 		/*
 		 * If the block_device provides a backing_dev_info for client
@@ -271,6 +273,7 @@ void clear_inode(struct inode *inode)
 		bd_forget(inode);
 	if (S_ISCHR(inode->i_mode) && inode->i_cdev)
 		cd_forget(inode);
+	cpuset_clear_dirty_nodes(inode->i_mapping);
 	inode->i_state = I_CLEAR;
 }
 
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -80,6 +80,36 @@ extern int current_cpuset_is_being_rebound(void);
 
 extern void rebuild_sched_domains(void);
 
+/*
+ * We need macros since struct address_space is not defined yet
+ */
+#if MAX_NUMNODES <= BITS_PER_LONG
+#define cpuset_init_dirty_nodes(__mapping)				\
+	(__mapping)->dirty_nodes = NODE_MASK_NONE
+
+#define cpuset_update_dirty_nodes(__mapping, __page)			\
+	node_set(page_to_nid(__page), (__mapping)->dirty_nodes);
+
+#define cpuset_clear_dirty_nodes(__mapping)				\
+	(__mapping)->dirty_nodes = NODE_MASK_NONE
+
+#define cpuset_intersects_dirty_nodes(__mapping, __nodemask_ptr)	\
+	(!(__nodemask_ptr) ||						\
+	 nodes_intersects((__mapping)->dirty_nodes, *(__nodemask_ptr)))
+
+#else
+struct address_space;
+
+#define cpuset_init_dirty_nodes(__mapping)				\
+	(__mapping)->dirty_nodes = NULL
+
+extern void cpuset_update_dirty_nodes(struct address_space *mapping,
+				      struct page *page);
+extern void cpuset_clear_dirty_nodes(struct address_space *mapping);
+extern int cpuset_intersects_dirty_nodes(struct address_space *mapping,
+					 nodemask_t *mask);
+#endif
+
 #else /* !CONFIG_CPUSETS */
 
 static inline int cpuset_init_early(void) { return 0; }
@@ -163,6 +193,27 @@ static inline void rebuild_sched_domains(void)
 	partition_sched_domains(1, NULL, NULL);
 }
 
+struct address_space;
+
+static inline void cpuset_init_dirty_nodes(struct address_space *mapping)
+{
+}
+
+static inline void cpuset_update_dirty_nodes(struct address_space *mapping,
+					     struct page *page)
+{
+}
+
+static inline void cpuset_clear_dirty_nodes(struct address_space *mapping)
+{
+}
+
+static inline int cpuset_intersects_dirty_nodes(struct address_space *mapping,
+						nodemask_t *mask)
+{
+	return 1;
+}
+
 #endif /* !CONFIG_CPUSETS */
 
 #endif /* _LINUX_CPUSET_H */
diff --git a/include/linux/fs.h b/include/linux/fs.h
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -544,6 +544,13 @@ struct address_space {
 	spinlock_t		private_lock;	/* for use by the address_space */
 	struct list_head	private_list;	/* ditto */
 	struct address_space	*assoc_mapping;	/* ditto */
+#ifdef CONFIG_CPUSETS
+#if MAX_NUMNODES <= BITS_PER_LONG
+	nodemask_t		dirty_nodes;	/* nodes with dirty pages */
+#else
+	nodemask_t		*dirty_nodes;	/* pointer to mask, if dirty */
+#endif
+#endif
 } __attribute__((aligned(sizeof(long))));
 	/*
 	 * On most architectures that alignment is already the case; but
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -72,6 +72,8 @@ struct writeback_control {
 	 * so we use a single control to update them
 	 */
 	unsigned no_nrwrite_index_update:1;
+
+	nodemask_t *nodes;		/* Nodemask to writeback */
 };
 
 /*
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -16,6 +16,7 @@
  *  2006 Rework by Paul Menage to use generic cgroups
  *  2008 Rework of the scheduler domains and CPU hotplug handling
  *       by Max Krasnyansky
+ *  2008 Cpuset writeback by Christoph Lameter
  *
  *  This file is subject to the terms and conditions of the GNU General Public
  *  License.  See the file COPYING in the main directory of the Linux
@@ -2323,6 +2324,58 @@ int cpuset_mem_spread_node(void)
 }
 EXPORT_SYMBOL_GPL(cpuset_mem_spread_node);
 
+#if MAX_NUMNODES > BITS_PER_LONG
+/*
+ * Special functions for NUMA systems with a large number of nodes.  The
+ * nodemask is pointed to from the address_space structure.  The attachment of
+ * the dirty_nodes nodemask is protected by the tree_lock.  The nodemask is
+ * freed only when the inode is cleared (and therefore unused, thus no locking
+ * is necessary).
+ */
+void cpuset_update_dirty_nodes(struct address_space *mapping,
+			       struct page *page)
+{
+	nodemask_t *nodes = mapping->dirty_nodes;
+	int node = page_to_nid(page);
+
+	if (!nodes) {
+		nodes = kmalloc(sizeof(nodemask_t), GFP_ATOMIC);
+		if (!nodes)
+			return;
+
+		*nodes = NODE_MASK_NONE;
+		mapping->dirty_nodes = nodes;
+	}
+	node_set(node, *nodes);
+}
+
+void cpuset_clear_dirty_nodes(struct address_space *mapping)
+{
+	nodemask_t *nodes = mapping->dirty_nodes;
+
+	if (nodes) {
+		mapping->dirty_nodes = NULL;
+		kfree(nodes);
+	}
+}
+
+/*
+ * Called without tree_lock.  The nodemask is only freed when the inode is
+ * cleared and therefore this is safe.
+ */
+int cpuset_intersects_dirty_nodes(struct address_space *mapping,
+				  nodemask_t *mask)
+{
+	nodemask_t *dirty_nodes = mapping->dirty_nodes;
+
+	if (!mask)
+		return 1;
+	if (!dirty_nodes)
+		return 0;
+	return nodes_intersects(*dirty_nodes, *mask);
+}
+#endif
+
 /**
  * cpuset_mems_allowed_intersects - Does @tsk1's mems_allowed intersect @tsk2's?
  * @tsk1: pointer to task_struct of some task.
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -34,6 +34,7 @@
 #include <linux/syscalls.h>
 #include <linux/buffer_head.h>
 #include <linux/pagevec.h>
+#include <linux/cpuset.h>
 
 /*
  * The maximum number of pages to writeout in a single bdflush/kupdate
@@ -1104,6 +1105,7 @@ int __set_page_dirty_nobuffers(struct page *page)
 			radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 		}
+		cpuset_update_dirty_nodes(mapping, page);
 		spin_unlock_irq(&mapping->tree_lock);
 		if (mapping->host) {
 			/* !PageAnon && !swapper_space */
