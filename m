Return-Path: <linux-kernel-owner+w=401wt.eu-S932145AbYBEW2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbYBEW2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760470AbYBEW2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:28:39 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:47460 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760556AbYBEW2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:28:38 -0500
Date: Tue, 5 Feb 2008 22:27:21 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH mm] stop c_p_a corrupting the pds
In-Reply-To: <Pine.LNX.4.64.0802052218190.11822@blonde.site>
Message-ID: <Pine.LNX.4.64.0802052226140.11822@blonde.site>
References: <Pine.LNX.4.64.0802052218190.11822@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When change_page_attr splits a large page on x86_32 (without PAE), it is
currently corrupting every process's page directory: fix that by removing
the thinko which passes down a physical instead of a virtual address -
this version of the patch being the hotfix for 2.6.24-mm1.

Signed-off-by: Hugh Dickins <hugh@veritas.com>

--- 2.6.24-mm1/arch/x86/mm/pageattr.c	2008-02-04 12:25:09.000000000 +0000
+++ linux/arch/x86/mm/pageattr.c	2008-02-05 20:52:43.000000000 +0000
@@ -218,8 +218,7 @@ static int split_large_page(pte_t *kpte,
 		goto out_unlock;
 	}
 
-	address = __pa(address);
-	addr = address & LARGE_PAGE_MASK;
+	addr = __pa(address) & LARGE_PAGE_MASK;
 	pbase = (pte_t *)page_address(base);
 #ifdef CONFIG_X86_32
 	paravirt_alloc_pt(&init_mm, page_to_pfn(base));
