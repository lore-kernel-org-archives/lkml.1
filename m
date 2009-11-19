Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbZKSRVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbZKSRVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108AbZKSRVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:21:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188AbZKSRVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:21:42 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 12/28] FS-Cache: Use radix tree preload correctly in tracking
	of pages to be stored
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:21:35 +0000
Message-ID: <20091119172135.1679.8699.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__fscache_write_page() attempts to load the radix tree preallocation pool for
the CPU it is on before calling radix_tree_insert(), as the insertion must be
done inside a pair of spinlocks.

Use of the preallocation pool, however, is contingent on the radix tree being
initialised without __GFP_WAIT specified.  __fscache_acquire_cookie() was
passing GFP_NOFS to INIT_RADIX_TREE() - but that includes __GFP_WAIT.

The solution is to AND out __GFP_WAIT.

Additionally, the banner comment to radix_tree_preload() is altered to make
note of this prerequisite.  Possibly there should be a WARN_ON() too.

Without this fix, I have seen the following recursive deadlock caused by
radix_tree_insert() attempting to allocate memory inside the spinlocked
region, which resulted in FS-Cache being called back into to release memory -
which required the spinlock already held.

=============================================
[ INFO: possible recursive locking detected ]
2.6.32-rc6-cachefs #24
---------------------------------------------
nfsiod/7916 is trying to acquire lock:
 (&cookie->lock){+.+.-.}, at: [<ffffffffa0076872>] __fscache_uncache_page+0xdb/0x160 [fscache]

but task is already holding lock:
 (&cookie->lock){+.+.-.}, at: [<ffffffffa0076acc>] __fscache_write_page+0x15c/0x3f3 [fscache]

other info that might help us debug this:
5 locks held by nfsiod/7916:
 #0:  (nfsiod){+.+.+.}, at: [<ffffffff81048290>] worker_thread+0x19a/0x2e2
 #1:  (&task->u.tk_work#2){+.+.+.}, at: [<ffffffff81048290>] worker_thread+0x19a/0x2e2
 #2:  (&cookie->lock){+.+.-.}, at: [<ffffffffa0076acc>] __fscache_write_page+0x15c/0x3f3 [fscache]
 #3:  (&object->lock#2){+.+.-.}, at: [<ffffffffa0076b07>] __fscache_write_page+0x197/0x3f3 [fscache]
 #4:  (&cookie->stores_lock){+.+...}, at: [<ffffffffa0076b0f>] __fscache_write_page+0x19f/0x3f3 [fscache]

stack backtrace:
Pid: 7916, comm: nfsiod Not tainted 2.6.32-rc6-cachefs #24
Call Trace:
 [<ffffffff8105ac7f>] __lock_acquire+0x1649/0x16e3
 [<ffffffff81059ded>] ? __lock_acquire+0x7b7/0x16e3
 [<ffffffff8100e27d>] ? dump_trace+0x248/0x257
 [<ffffffff8105ad70>] lock_acquire+0x57/0x6d
 [<ffffffffa0076872>] ? __fscache_uncache_page+0xdb/0x160 [fscache]
 [<ffffffff8135467c>] _spin_lock+0x2c/0x3b
 [<ffffffffa0076872>] ? __fscache_uncache_page+0xdb/0x160 [fscache]
 [<ffffffffa0076872>] __fscache_uncache_page+0xdb/0x160 [fscache]
 [<ffffffffa0077eb7>] ? __fscache_check_page_write+0x0/0x71 [fscache]
 [<ffffffffa00b4755>] nfs_fscache_release_page+0x86/0xc4 [nfs]
 [<ffffffffa00907f0>] nfs_release_page+0x3c/0x41 [nfs]
 [<ffffffff81087ffb>] try_to_release_page+0x32/0x3b
 [<ffffffff81092c2b>] shrink_page_list+0x316/0x4ac
 [<ffffffff81058a9b>] ? mark_held_locks+0x52/0x70
 [<ffffffff8135451b>] ? _spin_unlock_irq+0x2b/0x31
 [<ffffffff81093153>] shrink_inactive_list+0x392/0x67c
 [<ffffffff81058a9b>] ? mark_held_locks+0x52/0x70
 [<ffffffff810934ca>] shrink_list+0x8d/0x8f
 [<ffffffff81093744>] shrink_zone+0x278/0x33c
 [<ffffffff81052c70>] ? ktime_get_ts+0xad/0xba
 [<ffffffff8109453b>] try_to_free_pages+0x22e/0x392
 [<ffffffff8109184c>] ? isolate_pages_global+0x0/0x212
 [<ffffffff8108e16b>] __alloc_pages_nodemask+0x3dc/0x5cf
 [<ffffffff810ae24a>] cache_alloc_refill+0x34d/0x6c1
 [<ffffffff811bcf74>] ? radix_tree_node_alloc+0x52/0x5c
 [<ffffffff810ae929>] kmem_cache_alloc+0xb2/0x118
 [<ffffffff811bcf74>] radix_tree_node_alloc+0x52/0x5c
 [<ffffffff811bcfd5>] radix_tree_insert+0x57/0x19c
 [<ffffffffa0076b53>] __fscache_write_page+0x1e3/0x3f3 [fscache]
 [<ffffffffa00b4248>] __nfs_readpage_to_fscache+0x58/0x11e [nfs]
 [<ffffffffa009bb77>] nfs_readpage_release+0x34/0x9b [nfs]
 [<ffffffffa009c0d9>] nfs_readpage_release_full+0x32/0x4b [nfs]
 [<ffffffffa0006cff>] rpc_release_calldata+0x12/0x14 [sunrpc]
 [<ffffffffa0006e2d>] rpc_free_task+0x59/0x61 [sunrpc]
 [<ffffffffa0006f03>] rpc_async_release+0x10/0x12 [sunrpc]
 [<ffffffff810482e5>] worker_thread+0x1ef/0x2e2
 [<ffffffff81048290>] ? worker_thread+0x19a/0x2e2
 [<ffffffff81352433>] ? thread_return+0x3e/0x101
 [<ffffffffa0006ef3>] ? rpc_async_release+0x0/0x12 [sunrpc]
 [<ffffffff8104bff5>] ? autoremove_wake_function+0x0/0x34
 [<ffffffff81058d25>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff810480f6>] ? worker_thread+0x0/0x2e2
 [<ffffffff8104bd21>] kthread+0x7a/0x82
 [<ffffffff8100beda>] child_rip+0xa/0x20
 [<ffffffff8100b87c>] ? restore_args+0x0/0x30
 [<ffffffff8104c2b9>] ? add_wait_queue+0x15/0x44
 [<ffffffff8104bca7>] ? kthread+0x0/0x82
 [<ffffffff8100bed0>] ? child_rip+0x0/0x20


Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/cookie.c |    4 +++-
 lib/radix-tree.c    |    3 +++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index b1870a6..e6854f5 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -102,7 +102,9 @@ struct fscache_cookie *__fscache_acquire_cookie(
 	cookie->netfs_data	= netfs_data;
 	cookie->flags		= 0;
 
-	INIT_RADIX_TREE(&cookie->stores, GFP_NOFS);
+	/* radix tree insertion won't use the preallocation pool unless it's
+	 * told it may not wait */
+	INIT_RADIX_TREE(&cookie->stores, GFP_NOFS & ~__GFP_WAIT);
 
 	switch (cookie->def->type) {
 	case FSCACHE_COOKIE_TYPE_INDEX:
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 23abbd9..ae61068 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -200,6 +200,9 @@ radix_tree_node_free(struct radix_tree_node *node)
  * ensure that the addition of a single element in the tree cannot fail.  On
  * success, return zero, with preemption disabled.  On error, return -ENOMEM
  * with preemption not disabled.
+ *
+ * To make use of this facility, the radix tree must be initialised without
+ * __GFP_WAIT being passed to INIT_RADIX_TREE().
  */
 int radix_tree_preload(gfp_t gfp_mask)
 {

