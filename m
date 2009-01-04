Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbZADXhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbZADXhL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZADXfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:35:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56845 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbZADXf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:35:28 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200901051236.281008835@firstfloor.org>
In-Reply-To: <200901051236.281008835@firstfloor.org>
To: akpm@linux-foundation.org, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [5/5] Avoid theoretical vmalloc fault loop
Message-Id: <20090104233642.745CF3E6653@basil.firstfloor.org>
Date: Mon,  5 Jan 2009 00:36:42 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ajith Kumar noticed:

I was going through the vmalloc fault handling for x86_64 and am unclear
about the following lines in the vmalloc_fault() function.

pgd = pgd_offset(current->mm ?: &init_mm, address);
pgd_ref = pgd_offset_k(address);

Here the intention is to get the pgd corresponding to the current
process and sync it up with the pgd in init_mm(obtained from
pgd_offset_k). However, for kernel threads current->mm is NULL and hence
pgd = pgd_offset(init_mm, address) = pgd_ref which means the fault
handler returns without setting the pgd entry in the MM structure in
the context of which the kernel thread has faulted. This could lead to
never-ending faults and busy looping of kernel threads like pdflush.
So, shouldn't the pgd = pgd_offset(current->mm ?: &init_mm, address);
be
pgd = pgd_offset(current->active_mm ?: &init_mm, address);

AK: We can use active_mm unconditionally because it should
be always set. Do that.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/mm/fault.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.28-test/arch/x86/mm/fault.c
===================================================================
--- linux-2.6.28-test.orig/arch/x86/mm/fault.c	2008-10-24 13:34:41.000000000 +0200
+++ linux-2.6.28-test/arch/x86/mm/fault.c	2009-01-02 16:01:11.000000000 +0100
@@ -533,7 +533,7 @@
 	   happen within a race in page table update. In the later
 	   case just flush. */
 
-	pgd = pgd_offset(current->mm ?: &init_mm, address);
+	pgd = pgd_offset(current->active_mm, address);
 	pgd_ref = pgd_offset_k(address);
 	if (pgd_none(*pgd_ref))
 		return -1;
