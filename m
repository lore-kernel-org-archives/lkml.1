Return-Path: <linux-kernel-owner+w=401wt.eu-S1757134AbXIYXrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134AbXIYXrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbXIYXnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:43:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36410 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752867AbXIYXmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:42:52 -0400
Message-Id: <20070925234251.981728700@sgi.com>
References: <20070925234204.546836393@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 25 Sep 2007 16:42:16 -0700
From: Christoph Lameter <clameter@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [12/17] Virtual Compound page allocation from interrupt context.
Content-Disposition: inline; filename=vcompound_interrupt_alloc
To: unlisted-recipients:; (no To-header on input)
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
--- linux-2.6.orig/mm/vmalloc.c	2007-09-24 16:03:49.000000000 -0700
+++ linux-2.6/mm/vmalloc.c	2007-09-24 16:04:32.000000000 -0700
@@ -289,7 +289,6 @@ static struct vm_struct *__get_vm_area_n
 	unsigned long align = 1;
 	unsigned long addr;
 
-	BUG_ON(in_interrupt());
 	if (flags & VM_IOREMAP) {
 		int bit = fls(size);
 
@@ -314,7 +313,14 @@ static struct vm_struct *__get_vm_area_n
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
