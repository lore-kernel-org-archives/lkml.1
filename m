Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbXH1Kp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbXH1Kp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 06:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbXH1KpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 06:45:21 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:27500
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752289AbXH1KpU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 06:45:20 -0400
Message-Id: <46D418FE.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 28 Aug 2007 11:45:50 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: [PATCH] honor _PAGE_PSE bit on page walks
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/i386/mm/fault.c   |    3 ++-
 arch/x86_64/mm/fault.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.23-rc4/arch/i386/mm/fault.c	2007-08-28 09:41:59.000000000 +0200
+++ 2.6.23-rc4-x86-page-walk-pse/arch/i386/mm/fault.c	2007-08-15 12:20:48.000000000 +0200
@@ -570,7 +570,8 @@ no_context:
 		 * it's allocated already.
 		 */
 		if ((page >> PAGE_SHIFT) < max_low_pfn
-		    && (page & _PAGE_PRESENT)) {
+		    && (page & _PAGE_PRESENT)
+		    && !(page & _PAGE_PSE)) {
 			page &= PAGE_MASK;
 			page = ((__typeof__(page) *) __va(page))[(address >> PAGE_SHIFT)
 			                                         & (PTRS_PER_PTE - 1)];
--- linux-2.6.23-rc4/arch/x86_64/mm/fault.c	2007-08-28 09:42:05.000000000 +0200
+++ 2.6.23-rc4-x86-page-walk-pse/arch/x86_64/mm/fault.c	2007-08-15 12:25:03.000000000 +0200
@@ -175,7 +175,7 @@ void dump_pagetable(unsigned long addres
 	pmd = pmd_offset(pud, address);
 	if (bad_address(pmd)) goto bad;
 	printk("PMD %lx ", pmd_val(*pmd));
-	if (!pmd_present(*pmd))	goto ret;	 
+	if (!pmd_present(*pmd) || pmd_large(*pmd)) goto ret;
 
 	pte = pte_offset_kernel(pmd, address);
 	if (bad_address(pte)) goto bad;



