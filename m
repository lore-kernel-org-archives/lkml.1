Return-Path: <linux-kernel-owner+w=401wt.eu-S1765771AbYBNL7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765771AbYBNL7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 06:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754995AbYBNL7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 06:59:14 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:28267 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbYBNL7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 06:59:13 -0500
Date: Thu, 14 Feb 2008 12:59:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@osdl.org, Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Fix direct mapping correctly in ioremap 
Message-ID: <20080214115905.GA18573@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 14 Feb 2008 11:52:48.0381 (UTC) FILETIME=[1E94CAD0:01C86F00]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix direct mapping correctly in ioremap

[This fixes the general ioremap bug I mentioned earlier. It was
fortunately easier to fix that I thought first.]

set_memory_*/cpa is not currently able to resolve ioremap addresses to
their direct mapping aliases.

However uncached ioremap still needs to fix up the direct mapping
to be uncached when the direct mapping happens to overlap
the remapped area. Otherwise there would be a cached mapping
to the uncached ioremap area and that is not allowed in the x86
architecture.

Do this explicitely in ioremap() by passing the direct mapping
address to cpa and ignoring the error if the address wasn't
in the direct mapping.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/x86/mm/ioremap.c
===================================================================
--- linux.orig/arch/x86/mm/ioremap.c
+++ linux/arch/x86/mm/ioremap.c
@@ -104,6 +104,7 @@ static void __iomem *__ioremap(unsigned 
 	unsigned long pfn, offset, last_addr, vaddr;
 	struct vm_struct *area;
 	pgprot_t prot;
+	int err;
 
 	/* Don't allow wraparound or zero size */
 	last_addr = phys_addr + size - 1;
@@ -156,7 +157,12 @@ static void __iomem *__ioremap(unsigned 
 		return NULL;
 	}
 
-	if (ioremap_change_attr(vaddr, size, mode) < 0) {
+	/* Fix up the direct mapping for the new cache attributes */
+	err = ioremap_change_attr((unsigned long)__va(phys_addr),
+				size + offset, mode);
+	if (err == -EINVAL) {
+		/* Original address was partly unmapped. Valid condition; ignore. */
+	} else if (err < 0) {
 		vunmap(area->addr);
 		return NULL;
 	}
