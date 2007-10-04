Return-Path: <linux-kernel-owner+w=401wt.eu-S1759014AbXJDEEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759014AbXJDEEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 00:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbXJDEAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 00:00:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53773 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750902AbXJDEAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 00:00:06 -0400
Message-Id: <20071004040005.396698805@sgi.com>
References: <20071004035935.042951211@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 03 Oct 2007 20:59:51 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [16/18] Virtual Compound page allocation from interrupt context.
Content-Disposition: inline; filename=vcompound_interrupt_alloc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In an interrupt context we cannot wait for the vmlist_lock in
__get_vm_area_node(). So use a trylock instead. If the trylock fails
then the atomic allocation will fail and subsequently be retried.

This only works because the flush_cache_vunmap in use for
allocation is never performing any IPIs in contrast to flush_tlb_...
in use for freeing.  flush_cache_vunmap is only used on architectures
with a virtually mapped cache (xtensa, pa-risc).

[Note: Nick Piggin is working on a scheme to make this simpler by
no longer requiring flushes]

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/vmalloc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/vmalloc.c
===================================================================
--- linux-2.6.orig/mm/vmalloc.c	2007-10-03 16:21:10.000000000 -0700
+++ linux-2.6/mm/vmalloc.c	2007-10-03 16:25:17.000000000 -0700
@@ -177,7 +177,6 @@ static struct vm_struct *__get_vm_area_n
 	unsigned long align = 1;
 	unsigned long addr;
 
-	BUG_ON(in_interrupt());
 	if (flags & VM_IOREMAP) {
 		int bit = fls(size);
 
@@ -202,7 +201,14 @@ static struct vm_struct *__get_vm_area_n
 	 */
 	size += PAGE_SIZE;
 
-	write_lock(&vmlist_lock);
+	if (gfp_mask & __GFP_WAIT)
+		write_lock(&vmlist_lock);
+	else {
+		if (!write_trylock(&vmlist_lock)) {
+			kfree(area);
+			return NULL;
+		}
+	}
 	for (p = &vmlist; (tmp = *p) != NULL ;p = &tmp->next) {
 		if ((unsigned long)tmp->addr < addr) {
 			if((unsigned long)tmp->addr + tmp->size >= addr)

-- 
