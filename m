Return-Path: <linux-kernel-owner+w=401wt.eu-S1760255AbYDUS5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255AbYDUS5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 14:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbYDUS5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 14:57:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:12750 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758843AbYDUS5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 14:57:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=PACGymrYD4nOOc6ImDH+0nFpyx9r1DGXR69chSBmS8txMASPC5OvcDbYH06lljJArb3IRUcc15ojiVejaTafG/v8M0vIwyNDyJOL0oYkMfNx/UqHrLA8yjtNk5zMXAZvoyLOLLJOj2f+FEdZUFWO0AKEdk2A+fuVIhdeZe1P/qQ=
Date: Mon, 21 Apr 2008 20:57:03 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: don't ever allocate PTEs from lowmem
Message-ID: <20080421185703.GA5022@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is needed for the kernel to boot properly without OOMing if PSE is
not present or disabled for some reason. It is the fix that you proposed for
the kmemcheck OOM-on-boot case. It would also be possible to check the PSE
feature before deciding where to allocate from, but I don't think it really
matters.

Looks ok?

(And yes, this DOES fix the OOM for me. :-D)


Vegard


>From a9ba2e2b1888fad824d3f73561460e2027b2a149 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Mon, 21 Apr 2008 20:41:44 +0200
Subject: [PATCH] x86: don't ever allocate PTEs from lowmem

The PSE feature can be non-present for other reasons than having
CONFIG_DEBUG_PAGEALLOC=y and may OOM for those cases too. Therefore, always
try to allocate PTEs from the normal bootmem pool before falling back to
lowmem.

This is an update of:

commit 509a80c49c512ac88bd67b981145f925a306111b
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Oct 17 18:04:34 2007 +0200

    x86: fix CONFIG_PAGEALLOC related boot hangs/OOMs

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/mm/init_32.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index ee1091a..d3a411b 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -91,9 +91,7 @@ static pte_t * __init one_page_table_init(pmd_t *pmd)
 	if (!(pmd_val(*pmd) & _PAGE_PRESENT)) {
 		pte_t *page_table = NULL;
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
 		page_table = (pte_t *) alloc_bootmem_pages(PAGE_SIZE);
-#endif
 		if (!page_table) {
 			page_table =
 				(pte_t *)alloc_bootmem_low_pages(PAGE_SIZE);
-- 
1.5.4.1

