Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbXEDDIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbXEDDIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 23:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbXEDDIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 23:08:43 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60709 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754130AbXEDDIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 23:08:42 -0400
Date: Thu, 3 May 2007 20:08:41 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: Remove constructor from buffer_head
Message-ID: <Pine.LNX.4.64.0705032007540.16627@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Performance tests show a slight improvements in netperf (not a
strong case for a performance improvement but removing the
constructor has definitely no negative impact so why keep
this around?).

TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to localhost (127.0.0.1) port 0 AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

Before:
 87380  16384  16384    10.01    6026.04
 87380  16384  16384    10.01    5992.17
 87380  16384  16384    10.01    6071.23

After:
 87380  16384  16384    10.01    6090.20
 87380  16384  16384    10.01    6078.3
 87380  16384  16384    10.00    6013.52


Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/buffer.c |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

Index: slub/fs/buffer.c
===================================================================
--- slub.orig/fs/buffer.c	2007-05-03 19:17:09.000000000 -0700
+++ slub/fs/buffer.c	2007-05-03 19:57:30.000000000 -0700
@@ -2907,9 +2907,10 @@ static void recalc_bh_state(void)
 	
 struct buffer_head *alloc_buffer_head(gfp_t gfp_flags)
 {
-	struct buffer_head *ret = kmem_cache_alloc(bh_cachep,
+	struct buffer_head *ret = kmem_cache_zalloc(bh_cachep,
 				set_migrateflags(gfp_flags, __GFP_RECLAIMABLE));
 	if (ret) {
+		INIT_LIST_HEAD(&ret->b_assoc_buffers);
 		get_cpu_var(bh_accounting).nr++;
 		recalc_bh_state();
 		put_cpu_var(bh_accounting);
@@ -2928,17 +2929,6 @@ void free_buffer_head(struct buffer_head
 }
 EXPORT_SYMBOL(free_buffer_head);
 
-static void
-init_buffer_head(void *data, struct kmem_cache *cachep, unsigned long flags)
-{
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		struct buffer_head * bh = (struct buffer_head *)data;
-
-		memset(bh, 0, sizeof(*bh));
-		INIT_LIST_HEAD(&bh->b_assoc_buffers);
-	}
-}
-
 static void buffer_exit_cpu(int cpu)
 {
 	int i;
@@ -2965,12 +2955,8 @@ void __init buffer_init(void)
 {
 	int nrpages;
 
-	bh_cachep = kmem_cache_create("buffer_head",
-					sizeof(struct buffer_head), 0,
-					(SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
-					SLAB_MEM_SPREAD),
-					init_buffer_head,
-					NULL);
+	bh_cachep = KMEM_CACHE(buffer_head,
+			SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD);
 
 	/*
 	 * Limit the bh occupancy to 10% of ZONE_NORMAL
