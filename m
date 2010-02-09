Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab0BIN3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 08:29:55 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:51495 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753794Ab0BIN3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 08:29:53 -0500
Subject: [PATCH]  fs: buffer_head, remove kmem_cache constructor to reduce
 memory usage under slub
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Nick Piggin <npiggin@suse.de>, "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Feb 2010 13:29:51 +0000
Message-ID: <1265722191.4033.36.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs: Remove the buffer_head kmem_cache constructor to reduce memory usage
under slub.

When using slub, having a kmem_cache constructor forces slub to add a
free pointer to the size of the cached object, which can have a
significant impact to the number of small objects that can fit into a
slab. 

As buffer_head is relatively small and we can have large numbers of
them, removing the constructor is a definite win.

On x86_64 removing the constructor gives me 39 objects/slab, 3 more than
without the patch. And on x86_32 73 objects/slab, which is 9 more.

As alloc_buffer_head() already initializes each new object there is very
little difference in actual code run.  

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
----
This patch against 2.6.33-rc7

I've been running this patch for over a week on both a x86_64 desktop & 
a x86_32 laptop with no problems, only having fewer pages in the
buffer_head cache :)

regards
Richard




diff --git a/fs/buffer.c b/fs/buffer.c
index 6fa5302..bc3212e 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3265,7 +3265,7 @@ static void recalc_bh_state(void)
 	
 struct buffer_head *alloc_buffer_head(gfp_t gfp_flags)
 {
-	struct buffer_head *ret = kmem_cache_alloc(bh_cachep, gfp_flags);
+	struct buffer_head *ret = kmem_cache_zalloc(bh_cachep, gfp_flags);
 	if (ret) {
 		INIT_LIST_HEAD(&ret->b_assoc_buffers);
 		get_cpu_var(bh_accounting).nr++;
@@ -3352,15 +3352,6 @@ int bh_submit_read(struct buffer_head *bh)
 }
 EXPORT_SYMBOL(bh_submit_read);
 
-static void
-init_buffer_head(void *data)
-{
-	struct buffer_head *bh = data;
-
-	memset(bh, 0, sizeof(*bh));
-	INIT_LIST_HEAD(&bh->b_assoc_buffers);
-}
-
 void __init buffer_init(void)
 {
 	int nrpages;
@@ -3369,7 +3360,7 @@ void __init buffer_init(void)
 			sizeof(struct buffer_head), 0,
 				(SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
 				SLAB_MEM_SPREAD),
-				init_buffer_head);
+				NULL);
 
 	/*
 	 * Limit the bh occupancy to 10% of ZONE_NORMAL


