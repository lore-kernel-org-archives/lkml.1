Return-Path: <linux-kernel-owner+w=401wt.eu-S1030934AbXDYPVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030934AbXDYPVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031056AbXDYPVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:21:13 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:42640 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030934AbXDYPVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:21:13 -0400
X-AuditID: d80ac287-adacabb00000590d-13-462f71e83988 
Date: Wed, 25 Apr 2007 16:21:00 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] slub: update cpu after new_slab()
Message-ID: <Pine.LNX.4.64.0704251613280.19217@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 25 Apr 2007 15:21:12.0030 (UTC) FILETIME=[5B79F7E0:01C7874D]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SLUB gave me a NULL pointer dereference in slab_alloc(), in the
slab_lock(page) of its "Current cpuslab is acceptable" block: cpu
1 had been looking at cpu_slab[2], which then went NULL beneath it.
Since new_slab() may reenable interrupts and sleep (when __GFP_WAIT),
we may get rescheduled on a different cpu: so need to reevaluate it.

Signed-off-by: Hugh Dickins <hugh@veritas.com>

--- 2.6.21-rc7-mm1/mm/slub.c	2007-04-24 20:26:48.000000000 +0100
+++ linux/mm/slub.c	2007-04-25 15:49:12.000000000 +0100
@@ -1234,11 +1234,12 @@ have_slab:
 
 	page = new_slab(s, gfpflags, node);
 	if (page) {
+		cpu = smp_processor_id();
 		if (s->cpu_slab[cpu]) {
 			/*
-			 * Someone else populated the cpu_slab while
-			 * we enabled interrupts. The page may not
-			 * be on the requested node.
+			 * Someone else populated the cpu_slab while we enabled
+			 * interrupts, or we have got scheduled on another cpu.
+			 * The page may not be on the requested node.
 			 */
 			if (node == -1 ||
 				page_to_nid(s->cpu_slab[cpu]) == node) {
