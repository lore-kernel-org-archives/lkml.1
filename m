Return-Path: <linux-kernel-owner+w=401wt.eu-S1751187AbXBUIaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187AbXBUIaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 03:30:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbXBUIaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 03:30:15 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34969 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbXBUIaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 03:30:14 -0500
Date: Wed, 21 Feb 2007 10:30:12 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: mcr@sandelman.ca, clameter@sgi.com, linux-kernel@vger.kernel.org
Subject: [PATCH] slab: ensure cache_alloc_refill terminates
Message-ID: <Pine.LNX.4.64.0702211029340.9758@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

If slab->inuse is corrupted, cache_alloc_refill can enter an infinite
loop as detailed by Michael Richardson in the following post:
<http://lkml.org/lkml/2007/2/16/292>. This adds a BUG_ON to catch
those cases.

Cc: Michael Richardson <mcr@sandelman.ca>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slab.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: 2.6/mm/slab.c
===================================================================
--- 2.6.orig/mm/slab.c	2007-02-19 15:15:17.000000000 +0200
+++ 2.6/mm/slab.c	2007-02-20 08:39:26.000000000 +0200
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
+		BUG_ON(slabp->inuse < 0 || slabp->inuse >= cachep->num);
+
 		while (slabp->inuse < cachep->num && batchcount--) {
 			STATS_INC_ALLOCED(cachep);
 			STATS_INC_ACTIVE(cachep);
