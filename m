Return-Path: <linux-kernel-owner+w=401wt.eu-S1762440AbYBEW1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762440AbYBEW1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760160AbYBEW1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:27:03 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:32871 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbYBEW1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:27:01 -0500
Date: Tue, 5 Feb 2008 22:26:01 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] stop c_p_a corrupting the pds
Message-ID: <Pine.LNX.4.64.0802052218190.11822@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When change_page_attr splits a large page on x86_32 (without PAE), it is
currently corrupting every process's page directory: fix that by removing
the thinko which passes down a physical instead of a virtual address.

Signed-off-by: Hugh Dickins <hugh@veritas.com>

--- 2.6.24-git/arch/x86/mm/pageattr.c	2008-02-05 16:43:45.000000000 +0000
+++ linux/arch/x86/mm/pageattr.c	2008-02-05 21:34:18.000000000 +0000
@@ -237,7 +237,6 @@ static void __set_pmd_pte(pte_t *kpte, u
 	if (!SHARED_KERNEL_PMD) {
 		struct page *page;
 
-		address = __pa(address);
 		list_for_each_entry(page, &pgd_list, lru) {
 			pgd_t *pgd;
 			pud_t *pud;
