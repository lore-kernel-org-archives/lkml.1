Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYJ3TZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYJ3TZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbYJ3TYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:24:02 -0400
Received: from smtp-out.google.com ([216.239.33.17]:39580 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbYJ3TX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:23:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type;
	b=Vy367SwbLcyReL4CCocY5ceu3VG+hkTzv2s+Wci6AbL2Vg0IYmf95rrpygngBvuh9
	7EKMd4ryfGDyoGU1H0TUA==
Date: Thu, 30 Oct 2008 12:23:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <cl@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <peterz@infradead.org>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
Subject: [patch 0/7] cpuset writeback throttling
Message-ID: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This is the revised cpuset writeback throttling patchset posted to LKML 
on Tuesday, October 27.

The comments from Peter Zijlstra have been addressed.  His concurrent 
page cache patchset is not currently in -mm, so we can still serialize 
updating a struct address_space's dirty_nodes on its tree_lock.  When his 
patchset is merged, the patch at the end of this message can be used to 
introduce the necessary synchronization.

This patchset applies nicely to 2.6.28-rc2-mm1 with the exception of the 
first patch due to the alloc_inode() refactoring to inode_init_always() in
e9110864c440736beb484c2c74dedc307168b14e from linux-next and additions to 
include/linux/cpuset.h from 
oom-print-triggering-tasks-cpuset-and-mems-allowed.patch (oops :).

Please consider this for inclusion in the -mm tree.

A simple way of testing this change is to create a large file that exceeds 
the amount of memory allocated to a specific cpuset.  Then, mmap and 
modify the large file (such as in the following program) while running a 
latency sensitive task in a disjoint cpuset.  Notice the writeout 
throttling that doesn't interfere with the latency sensitive task.

#include <stdlib.h>
#include <stdio.h>
#include <sys/mman.h>
#include <fcntl.h>

int main(int argc, char **argv)
{
	void *addr;
	unsigned long length;
	unsigned long i;
	int fd;

	if (argc != 3) {
		fprintf(stderr, "usage: %s <filename> <length>\n",
			argv[0]);
		exit(1);
	}

	fd = open(argv[1], O_RDWR, 0644);
	if (fd < 0) {
		fprintf(stderr, "Cannot open file %s\n", argv[1]);
		exit(1);
	}

	length = strtoul(argv[2], NULL, 0);
	if (!length) {
		fprintf(stderr, "Invalid length %s\n", argv[2]);
		exit(1);
	}

	addr = mmap(0, length, PROT_READ | PROT_WRITE, MAP_SHARED, fd,
		    0);
	if (addr == MAP_FAILED) {
		fprintf(stderr, "mmap() failed\n");
		exit(1);
	}

	for (;;) {
		for (i = 0; i < length; i++)
			(*(char *)(addr + i))++;
		msync(addr, length, MS_SYNC);
	}
	return 0;
}



The following patch can be applied once the struct address_space's 
tree_lock is removed to protect the attachment of mapping->dirty_nodes.
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
@@ -2413,25 +2413,27 @@ EXPORT_SYMBOL_GPL(cpuset_mem_spread_node);
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
 {
-	nodemask_t *nodes = mapping->dirty_nodes;
+	nodemask_t *nodes;
 	int node = page_to_nid(page);
 
+	spin_lock_irq(&mapping->dirty_nodes_lock);
+	nodes = mapping->dirty_nodes;
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
 
@@ -2446,8 +2448,8 @@ void cpuset_clear_dirty_nodes(struct address_space *mapping)
 }
 
 /*
- * Called without tree_lock.  The nodemask is only freed when the inode is
- * cleared and therefore this is safe.
+ * The nodemask is only freed when the inode is cleared and therefore this
+ * requires no locking.
  */
 int cpuset_intersects_dirty_nodes(struct address_space *mapping,
 				  nodemask_t *mask)
