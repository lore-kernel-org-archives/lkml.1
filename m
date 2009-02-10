Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbZBJFvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbZBJFvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 00:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbZBJFvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 00:51:24 -0500
Received: from mail.suse.de ([195.135.220.2]:42280 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbZBJFvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 00:51:23 -0500
Date: Tue, 10 Feb 2009 06:51:19 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: [patch] mm: vmap fix overflow
Message-ID: <20090210055119.GE28301@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is appropriate for 2.6.28 too.

--

The new vmap allocator can wrap the address and get confused in the case of
large allocations or VMALLOC_END near the end of address space.

Problem reported by Christoph Hellwig on a 32-bit XFS workload.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 mm/vmalloc.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/mm/vmalloc.c
===================================================================
--- linux-2.6.orig/mm/vmalloc.c
+++ linux-2.6/mm/vmalloc.c
@@ -334,6 +334,9 @@ retry:
 	addr = ALIGN(vstart, align);
 
 	spin_lock(&vmap_area_lock);
+	if (addr + size < addr)
+		goto overflow;
+
 	/* XXX: could have a last_hole cache */
 	n = vmap_area_root.rb_node;
 	if (n) {
@@ -365,6 +368,8 @@ retry:
 
 		while (addr + size > first->va_start && addr + size <= vend) {
 			addr = ALIGN(first->va_end + PAGE_SIZE, align);
+			if (addr + size < addr)
+				goto overflow;
 
 			n = rb_next(&first->rb_node);
 			if (n)
@@ -375,6 +380,7 @@ retry:
 	}
 found:
 	if (addr + size > vend) {
+overflow:
 		spin_unlock(&vmap_area_lock);
 		if (!purged) {
 			purge_vmap_area_lazy();
