Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbYCRF3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbYCRF3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbYCRFYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:23 -0400
Received: from gw.goop.org ([64.81.55.164]:37850 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbYCRFYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:10 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 17 of 31] xen: make use of pte_t union
X-Mercurial-Node: 8355eaf061e8fd74996c18de3d7cfe697cf16eb8
Message-Id: <8355eaf061e8fd74996c.1205797028@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:37:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pte_t always contains a "pte" field for the whole pte value, so make
use of it.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -216,12 +216,10 @@
 
 pteval_t xen_pte_val(pte_t pte)
 {
-	pteval_t ret = 0;
+	pteval_t ret = pte.pte;
 
-	if (pte.pte_low) {
-		ret = ((pteval_t)pte.pte_high << 32) | pte.pte_low;
-		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
-	}
+	if (ret & _PAGE_PRESENT)
+		ret = machine_to_phys(XMADDR(ret)).paddr | _PAGE_PRESENT;
 
 	return ret;
 }
@@ -229,16 +227,16 @@
 pmdval_t xen_pmd_val(pmd_t pmd)
 {
 	pmdval_t ret = pmd.pmd;
-	if (ret)
-		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
+	if (ret & _PAGE_PRESENT)
+		ret = machine_to_phys(XMADDR(ret)).paddr | _PAGE_PRESENT;
 	return ret;
 }
 
 pgdval_t xen_pgd_val(pgd_t pgd)
 {
 	pgdval_t ret = pgd.pgd;
-	if (ret)
-		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
+	if (ret & _PAGE_PRESENT)
+		ret = machine_to_phys(XMADDR(ret)).paddr | _PAGE_PRESENT;
 	return ret;
 }
 
@@ -254,7 +252,7 @@
 
 pmd_t xen_make_pmd(pmdval_t pmd)
 {
-	if (pmd & 1)
+	if (pmd & _PAGE_PRESENT)
 		pmd = phys_to_machine(XPADDR(pmd)).maddr;
 
 	return (pmd_t){ pmd };
@@ -275,7 +273,7 @@
 
 pteval_t xen_pte_val(pte_t pte)
 {
-	pteval_t ret = pte.pte_low;
+	pteval_t ret = pte.pte;
 
 	if (ret & _PAGE_PRESENT)
 		ret = machine_to_phys(XMADDR(ret)).paddr;
@@ -286,8 +284,8 @@
 pgdval_t xen_pgd_val(pgd_t pgd)
 {
 	pteval_t ret = pgd.pgd;
-	if (ret)
-		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
+	if (ret & _PAGE_PRESENT)
+		ret = machine_to_phys(XMADDR(ret)).paddr | _PAGE_PRESENT;
 	return ret;
 }
 


