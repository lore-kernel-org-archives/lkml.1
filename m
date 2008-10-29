Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbYJ2BOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbYJ2BOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 21:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbYJ2BN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 21:13:59 -0400
Received: from smtp-out.google.com ([216.239.45.13]:9347 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYJ2BN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 21:13:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=ttb0fW7DfwJLDQmH6e/XQYk18T/P55L0P4vqntDeokcHqmqre671mkM4Pfk2HOA2I
	crG7kJkbMNxNOegc7qEeg==
Date: Tue, 28 Oct 2008 18:13:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/7] cpusets: add dirty map to struct address_space
In-Reply-To: <alpine.DEB.1.10.0810281337530.6470@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0810281722290.23743@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com> <1225215459.15763.33.camel@lappy.programming.kicks-ass.net> <alpine.DEB.1.10.0810281337530.6470@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008, David Rientjes wrote:

> Yeah, if we don't serialize with tree_lock then we'll need to protect the 
> attachment of mapping->dirty_nodes with a new spinlock in struct 
> address_space (and only for configs where MAX_NUMNODES > BITS_PER_LONG). 
> That locking overhead is negligible when mapping->dirty_nodes is non-NULL 
> since there's no requirement to protect the setting of the node in the 
> nodemask.
> 
> Are your concurrent pagecache patches in the latest mmotm?  If so, I can 
> rebase this entire patchset off that.

We're still taking mapping->tree_lock in both __set_page_dirty() and 
__set_page_dirty_nobuffers() in today's mmotm.

When tree_lock is removed with your patchset, we can add a spinlock to 
protect mapping->dirty_nodes when MAX_NUMNODES > BITS_PER_LONG.

Would you like to fold this patch into your series (which assumes we're 
not taking mapping->tree_lock in either of the two callers above)?
---
diff --git a/fs/inode.c b/fs/inode.c
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -223,6 +223,9 @@ void inode_init_once(struct inode *inode)
 	INIT_LIST_HEAD(&inode->inotify_watches);
 	mutex_init(&inode->inotify_mutex);
 #endif
+#if MAX_NUMNODES > BITS_PER_LONG
+	spin_lock_init(&inode->i_data.dirty_nodes_lock);
+#endif
 }
 
 EXPORT_SYMBOL(inode_init_once);
diff --git a/include/linux/fs.h b/include/linux/fs.h
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -554,6 +554,7 @@ struct address_space {
 	nodemask_t		dirty_nodes;	/* nodes with dirty pages */
 #else
 	nodemask_t		*dirty_nodes;	/* pointer to mask, if dirty */
+	spinlock_t		dirty_nodes_lock; /* protects the above */
 #endif
 #endif
 } __attribute__((aligned(sizeof(long))));
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2413,10 +2413,7 @@ EXPORT_SYMBOL_GPL(cpuset_mem_spread_node);
 #if MAX_NUMNODES > BITS_PER_LONG
 /*
  * Special functions for NUMA systems with a large number of nodes.  The
- * nodemask is pointed to from the address_space structure.  The attachment of
- * the dirty_nodes nodemask is protected by the tree_lock.  The nodemask is
- * freed only when the inode is cleared (and therefore unused, thus no locking
- * is necessary).
+ * nodemask is pointed to from the address_space structure.
  */
 void cpuset_update_dirty_nodes(struct address_space *mapping,
 			       struct page *page)
@@ -2424,14 +2421,18 @@ void cpuset_update_dirty_nodes(struct address_space *mapping,
 	nodemask_t *nodes = mapping->dirty_nodes;
 	int node = page_to_nid(page);
 
+	spin_lock_irq(&mapping->dirty_nodes_lock);
 	if (!nodes) {
 		nodes = kmalloc(sizeof(nodemask_t), GFP_ATOMIC);
-		if (!nodes)
+		if (!nodes) {
+			spin_unlock_irq(&mapping->dirty_nodes_lock);
 			return;
+		}
 
 		*nodes = NODE_MASK_NONE;
 		mapping->dirty_nodes = nodes;
 	}
+	spin_unlock_irq(&mapping->dirty_nodes_lock);
 	node_set(node, *nodes);
 }
 
@@ -2446,8 +2447,8 @@ void cpuset_clear_dirty_nodes(struct address_space *mapping)
 }
 
 /*
- * Called without tree_lock.  The nodemask is only freed when the inode is
- * cleared and therefore this is safe.
+ * The nodemask is only freed when the inode is cleared and therefore this
+ * requires no locking.
  */
 int cpuset_intersects_dirty_nodes(struct address_space *mapping,
 				  nodemask_t *mask)
