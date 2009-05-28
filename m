Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbZE1N3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbZE1N3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 09:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758769AbZE1N31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 09:29:27 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53964 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbZE1N3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 09:29:25 -0400
Subject: [PATCH] init: call vfs_caches_init_early() later in the boot
 sequence
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: cl@linux-foundation.com, torvals@linux-foundation.org, mpm@selenic.com,
       npiggin@suse.de, yinghai@kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 28 May 2009 16:29:25 +0300
Message-Id: <1243517365.11533.65.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

There's no need to call vfs_caches_init_early() before kmem_cache_init(). All
we have to do is make sure we don't attempt to use the bootmem allocator after
we've called mem_init().

Cc: Christoph Lameter <cl@linux-foundation.com>
Cc: Linus Torvalds <torvals@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/dcache.c |    2 +-
 fs/inode.c  |    2 +-
 init/main.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index ee60ce4..6c48ba1 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2255,7 +2255,7 @@ static void __init dcache_init_early(void)
 					sizeof(struct hlist_head),
 					dhash_entries,
 					13,
-					HASH_EARLY,
+					0,
 					&d_hash_shift,
 					&d_hash_mask,
 					0);
diff --git a/fs/inode.c b/fs/inode.c
index 0571983..92379c8 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1487,7 +1487,7 @@ void __init inode_init_early(void)
 					sizeof(struct hlist_head),
 					ihash_entries,
 					14,
-					HASH_EARLY,
+					0,
 					&i_hash_shift,
 					&i_hash_mask,
 					0);
diff --git a/init/main.c b/init/main.c
index 5a19578..f6bd51f 100644
--- a/init/main.c
+++ b/init/main.c
@@ -588,7 +588,6 @@ asmlinkage void __init start_kernel(void)
 	 * kmem_cache_init()
 	 */
 	pidhash_init();
-	vfs_caches_init_early();
 	/*
 	 * Set up kernel memory allocators
 	 */
@@ -658,6 +657,7 @@ asmlinkage void __init start_kernel(void)
 		initrd_start = 0;
 	}
 #endif
+	vfs_caches_init_early();
 	cpuset_init_early();
 	page_cgroup_init();
 	enable_debug_pagealloc();
-- 
1.6.0.4



