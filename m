Return-Path: <linux-kernel-owner+w=401wt.eu-S1757655AbYCEWmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655AbYCEWmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756454AbYCEWmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:42:09 -0500
Received: from vpnflf.ccur.com ([12.192.68.2]:51198 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751353AbYCEWmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:42:05 -0500
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2008 17:42:05 EST
Date: Wed, 5 Mar 2008 17:33:14 -0500
From: Joe Korty <joe.korty@ccur.com>
To: clameter@sgi.com
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, davem@davemloft.net
Subject: [PATCH] NUMA slab allocator migration bugfix
Message-ID: <20080305223314.GA4277@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NUMA slab allocator cpu migration bugfix

The NUMA slab allocator (specifically, cache_alloc_refill)
is not refreshing its local copies of what cpu and what
numa node it is on, when it drops and reacquires the irq
block that it inherited from its caller.  As a result
those values become invalid if an attempt to migrate the
process to another numa node occured while the irq block
had been dropped.

The solution is to make cache_alloc_refill reload these
variables whenever it drops and reacquires the irq block.

The error is very difficult to hit.  When it does occur,
one gets the following oops + stack traceback bits in
check_spinlock_acquired:

	kernel BUG at mm/slab.c:2417
	cache_alloc_refill+0xe6
	kmem_cache_alloc+0xd0
	...

This patch was developed against 2.6.23, ported to and
compiled-tested only against 2.6.25-rc4.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.25-rc4/mm/slab.c
===================================================================
--- 2.6.25-rc4.orig/mm/slab.c	2008-03-05 16:07:56.000000000 -0500
+++ 2.6.25-rc4/mm/slab.c	2008-03-05 16:17:47.000000000 -0500
@@ -2964,11 +2964,10 @@
 	struct array_cache *ac;
 	int node;
 
-	node = numa_node_id();
-
+retry:
 	check_irq_off();
+	node = numa_node_id();
 	ac = cpu_cache_get(cachep);
-retry:
 	batchcount = ac->batchcount;
 	if (!ac->touched && batchcount > BATCHREFILL_LIMIT) {
 		/*
