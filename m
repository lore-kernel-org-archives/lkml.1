Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbXLEIAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbXLEIAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 03:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbXLEHzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:55:40 -0500
Received: from mail.suse.de ([195.135.220.2]:38668 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbXLEHzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:55:12 -0500
Message-Id: <20071205071628.223376000@nick.local0.net>
References: <20071205071547.701344000@nick.local0.net>
User-Agent: quilt/0.46-14
Date: Wed, 05 Dec 2007 18:16:01 +1100
From: npiggin@suse.de
To: akpm@linux-foundation.org
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: [patch 14/18] oss: via nopage
Content-Disposition: inline; filename=oss-via-nopage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert OSS via driver from nopage to fault.
Remove redundant vma range checks.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: jgarzik@pobox.com
Cc: linux-kernel@vger.kernel.org
---
 sound/oss/via82cxxx_audio.c |   28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

Index: linux-2.6/sound/oss/via82cxxx_audio.c
===================================================================
--- linux-2.6.orig/sound/oss/via82cxxx_audio.c
+++ linux-2.6/sound/oss/via82cxxx_audio.c
@@ -2099,8 +2099,7 @@ static void via_dsp_cleanup (struct via_
 }
 
 
-static struct page * via_mm_nopage (struct vm_area_struct * vma,
-				    unsigned long address, int *type)
+static int via_mm_fault (struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct via_info *card = vma->vm_private_data;
 	struct via_channel *chan = &card->ch_out;
@@ -2108,22 +2107,14 @@ static struct page * via_mm_nopage (stru
 	unsigned long pgoff;
 	int rd, wr;
 
-	DPRINTK ("ENTER, start %lXh, ofs %lXh, pgoff %ld, addr %lXh\n",
-		 vma->vm_start,
-		 address - vma->vm_start,
-		 (address - vma->vm_start) >> PAGE_SHIFT,
-		 address);
-
-        if (address > vma->vm_end) {
-		DPRINTK ("EXIT, returning NOPAGE_SIGBUS\n");
-		return NOPAGE_SIGBUS; /* Disallow mremap */
-	}
+	DPRINTK ("ENTER, pgoff %ld\n", vmf->pgoff);
+
         if (!card) {
-		DPRINTK ("EXIT, returning NOPAGE_SIGBUS\n");
-		return NOPAGE_SIGBUS;	/* Nothing allocated */
+		DPRINTK ("EXIT, returning VM_FAULT_SIGBUS\n");
+		return VM_FAULT_SIGBUS;	/* Nothing allocated */
 	}
 
-	pgoff = vma->vm_pgoff + ((address - vma->vm_start) >> PAGE_SHIFT);
+	pgoff = vmf->pgoff;
 	rd = card->ch_in.is_mapped;
 	wr = card->ch_out.is_mapped;
 
@@ -2150,9 +2141,8 @@ static struct page * via_mm_nopage (stru
 	DPRINTK ("EXIT, returning page %p for cpuaddr %lXh\n",
 		 dmapage, (unsigned long) chan->pgtbl[pgoff].cpuaddr);
 	get_page (dmapage);
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return dmapage;
+	vmf->page = dmapage;
+	return 0;
 }
 
 
@@ -2165,7 +2155,7 @@ static int via_mm_swapout (struct page *
 
 
 static struct vm_operations_struct via_mm_ops = {
-	.nopage		= via_mm_nopage,
+	.fault		= via_mm_fault,
 
 #ifndef VM_RESERVED
 	.swapout	= via_mm_swapout,

-- 

