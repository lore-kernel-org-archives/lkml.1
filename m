Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbYJTFEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbYJTFEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 01:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYJTFE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 01:04:26 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:45445 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbYJTFEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 01:04:25 -0400
Message-ID: <48FC0E68.50902@mxs.nes.nec.co.jp>
Date: Mon, 20 Oct 2008 13:51:52 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: kexec-ml <kexec@lists.infradead.org>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] kdump: Fix invalid access on i386 sparsemem.
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Since linux-2.6.27, kdump has failed on i386 sparsemem kernel.
1st-kernel gets a panic just before switching to 2nd-kernel.

The cause is that a kernel accesses invalid mem_section by
page_to_pfn(image->swap_page) at machine_kexec().
image->swap_page is allocated if kexec for hibernation, but
it is not allocated if kdump. So if kdump, a kernel should
not access the mem_section corresponding to image->swap_page.
The attached patch fixes this invalid access.


Thanks
Ken'ichi Ohmichi

Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
---
diff -rpuN a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
--- a/arch/x86/kernel/machine_kexec_32.c	2008-10-10 07:13:53.000000000 +0900
+++ b/arch/x86/kernel/machine_kexec_32.c	2008-10-17 20:38:37.000000000 +0900
@@ -162,7 +162,10 @@ void machine_kexec(struct kimage *image)
 	page_list[VA_PTE_0] = (unsigned long)kexec_pte0;
 	page_list[PA_PTE_1] = __pa(kexec_pte1);
 	page_list[VA_PTE_1] = (unsigned long)kexec_pte1;
-	page_list[PA_SWAP_PAGE] = (page_to_pfn(image->swap_page) << PAGE_SHIFT);
+
+	if (image->type == KEXEC_TYPE_DEFAULT)
+		page_list[PA_SWAP_PAGE] = (page_to_pfn(image->swap_page)
+						<< PAGE_SHIFT);
 
 	/* The segment registers are funny things, they have both a
 	 * visible and an invisible part.  Whenever the visible part is
_
