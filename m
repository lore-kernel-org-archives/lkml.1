Return-Path: <linux-kernel-owner+w=401wt.eu-S1750773AbXBSIWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750773AbXBSIWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 03:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbXBSIWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 03:22:54 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42879 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbXBSIWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 03:22:53 -0500
Date: Mon, 19 Feb 2007 10:22:52 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, mcr@sandelman.ca, clameter@sgi.com
Subject: [PATCH] slab: ensure cache_alloc_refill terminates
Message-ID: <Pine.LNX.4.64.0702191020490.2085@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

If slab->inuse is corrupted, cache_alloc_refill can enter an infinite
loop as detailed by Michael Richardson in the following post:
<http://lkml.org/lkml/2007/2/16/292>.

This patch adds a BUG_ON for the case where a slab in partial or free
list has no available objects for allocation to ensure
cache_alloc_refill terminates.

Cc: Michael Richardson <mcr@sandelman.ca>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slab.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: 2.6/mm/slab.c
===================================================================
--- 2.6.orig/mm/slab.c	2007-02-19 09:58:28.000000000 +0200
+++ 2.6/mm/slab.c	2007-02-19 10:19:20.000000000 +0200
@@ -2987,6 +2987,14 @@
 		slabp = list_entry(entry, struct slab, list);
 		check_slabp(cachep, slabp);
 		check_spinlock_acquired(cachep);
+
+		/*
+		 * The slab was either on partial or free list so
+		 * there must be at least one object available for
+		 * allocation.
+		 */
+		BUG_ON(slabp->inuse >= cachep->num);
+
 		while (slabp->inuse < cachep->num && batchcount--) {
 			STATS_INC_ALLOCED(cachep);
 			STATS_INC_ACTIVE(cachep);
