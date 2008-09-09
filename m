Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbYIILYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbYIILYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 07:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbYIILX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 07:23:58 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:5172 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbYIILX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 07:23:57 -0400
X-IronPort-AV: E=Sophos;i="4.32,364,1217822400"; 
   d="scan'208";a="19089469"
From: Alex Nixon <alex.nixon@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alex Nixon <alex.nixon@citrix.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Xen: Fix pte unpin BUG when !CONFIG_SMP
Date: Tue,  9 Sep 2008 12:25:08 +0100
Message-Id: <1220959508-13806-1-git-send-email-alex.nixon@citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-OriginalArrivalTime: 09 Sep 2008 11:23:55.0283 (UTC) FILETIME=[8B7F0630:01C9126E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We still need to pin PTEs, even if there are no PTE locks.  Otherwise we'll BUG whenever there aren't PTE locks (i.e. whenever NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS), as we try to unpin PTEs which were never pinned in the first place.

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/xen/mmu.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index f5af913..1239bda 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -819,9 +819,10 @@ static int xen_pin_page(struct page *page, enum pt_level level)
 					pfn_pte(pfn, PAGE_KERNEL_RO),
 					level == PT_PGD ? UVMF_TLB_FLUSH : 0);
 
-		if (ptl) {
+		if (level == PT_PTE)
 			xen_do_pin(MMUEXT_PIN_L1_TABLE, pfn);
 
+		if (ptl) {
 			/* Queue a deferred unlock for when this batch
 			   is completed. */
 			xen_mc_callback(xen_pte_unlock, ptl);
@@ -924,9 +925,7 @@ static int xen_unpin_page(struct page *page, enum pt_level level)
 		 */
 		if (level == PT_PTE) {
 			ptl = xen_pte_lock(page);
-
-			if (ptl)
-				xen_do_pin(MMUEXT_UNPIN_TABLE, pfn);
+			xen_do_pin(MMUEXT_UNPIN_TABLE, pfn);
 		}
 
 		mcs = __xen_mc_entry(0);
-- 
1.5.4.3

