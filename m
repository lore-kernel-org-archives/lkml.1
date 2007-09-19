Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbXISDjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbXISDjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 23:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbXISDg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 23:36:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53636 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752050AbXISDgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 23:36:43 -0400
Message-Id: <20070919033643.073962340@sgi.com>
From: Christoph Lameter <clameter@sgi.com>
References: <20070919033605.785839297@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 20:36:17 -0700
To: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [12/17] Virtual Compound page allocation from interrupt context.
Content-Disposition: inline; filename=vcompound_interrupt_alloc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In an interrupt context we cannot wait for the vmlist_lock in
__get_vm_area_node(). So use a trylock instead. If the trylock fails
then the atomic allocation will fail and subsequently be retried.

This only works because the flush_cache_vunmap in use for
allocation is never performing any IPIs in contrast to flush_tlb_...
in use for freeing.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/vmalloc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/vmalloc.c
===================================================================
--- linux-2.6.orig/mm/vmalloc.c	2007-09-18 10:52:11.000000000 -0700
+++ linux-2.6/mm/vmalloc.c	2007-09-18 10:54:21.000000000 -0700
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
