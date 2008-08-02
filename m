Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbYHBNny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbYHBNny (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 09:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbYHBNnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 09:43:47 -0400
Received: from gustav.zipernowsky.hu ([193.225.20.248]:43404 "EHLO
	gustav.zipernowsky.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbYHBNnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 09:43:46 -0400
MIME-Version: 1.0
Date: Sat, 02 Aug 2008 15:43:40 +0200
From: Oliver Pinter <oliver@zipernowsky.hu>
To: Russell King <rmk@dyn-67.arm.linux.org.uk>, stable@kernel.org
Cc: Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org
Subject: [RFC, 2.6.26.2-rc1] Fix shared mmap when more than two maps of the same
 file exist
Reply-To: oliver.pntr@gmail.com
Message-ID: <d9b1665a88f594981fec92807792bcff@zipernowsky.hu>
User-Agent: RoundCube Webmail/0.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 53cdb27a933e4032934cbda0b447cfc9943c0eac Mon Sep 17 00:00:00 2001
From: Russell King <rmk@dyn-67.arm.linux.org.uk>
Date: Sun, 27 Jul 2008 10:35:54 +0100
Subject: [PATCH] [ARM] Fix shared mmap when more than two maps of the same
file exist

[ Upstream commit 53cdb27a933e4032934cbda0b447cfc9943c0eac ]

The shared mmap code works fine for the test case, which only checked
for two shared maps of the same file.  However, three shared maps
result in one mapping remaining cached, resulting in stale data being
visible via that mapping.  Fix this.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/arch/arm/mm/fault-armv.c b/arch/arm/mm/fault-armv.c
index fbfa260..a8ec97b 100644
--- a/arch/arm/mm/fault-armv.c
+++ b/arch/arm/mm/fault-armv.c
@@ -37,7 +37,7 @@ static int adjust_pte(struct vm_area_struct *vma,
unsigned long address)
 	pgd_t *pgd;
 	pmd_t *pmd;
 	pte_t *pte, entry;
-	int ret = 0;
+	int ret;
 
 	pgd = pgd_offset(vma->vm_mm, address);
 	if (pgd_none(*pgd))
@@ -55,15 +55,19 @@ static int adjust_pte(struct vm_area_struct *vma,
unsigned long address)
 	entry = *pte;
 
 	/*
+	 * If this page is present, it's actually being shared.
+	 */
+	ret = pte_present(entry);
+
+	/*
 	 * If this page isn't present, or is already setup to
 	 * fault (ie, is old), we can safely ignore any issues.
 	 */
-	if (pte_present(entry) && pte_val(entry) & shared_pte_mask) {
+	if (ret && pte_val(entry) & shared_pte_mask) {
 		flush_cache_page(vma, address, pte_pfn(entry));
 		pte_val(entry) &= ~shared_pte_mask;
 		set_pte_at(vma->vm_mm, address, pte, entry);
 		flush_tlb_page(vma, address);
-		ret = 1;
 	}
 	pte_unmap(pte);
 	return ret;


