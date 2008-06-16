Return-Path: <linux-kernel-owner+w=401wt.eu-S1758782AbYFPWCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782AbYFPWCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 18:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbYFPWCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 18:02:36 -0400
Received: from gw.goop.org ([64.81.55.164]:38904 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756125AbYFPWCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 18:02:35 -0400
Message-ID: <4856E2D1.6000307@goop.org>
Date: Mon, 16 Jun 2008 15:01:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: the arch/x86 maintainers <x86@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stable Kernel <stable@kernel.org>
Subject: [PATCH 1/2] xen: mask unwanted pte bits in __supported_pte_mask
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than ad-hoc masking unwanted bits when constructing a pte, just
prevent them from ever being set by removing them from
__supported_pte_mask.

[ Stable: this isn't a bugfix in itself, but it's a pre-requiste
  for "xen: don't drop NX bit" ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Stable Kernel <stable@kernel.org>
---
 arch/x86/xen/enlighten.c |    5 +++++
 arch/x86/xen/mmu.c       |    4 +---
 2 files changed, 6 insertions(+), 3 deletions(-)

===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1294,6 +1294,11 @@
 	if (xen_feature(XENFEAT_supervisor_mode_kernel))
 		pv_info.kernel_rpl = 0;
 
+	/* Prevent unwanted bits from being set in PTEs. */
+	__supported_pte_mask &= ~_PAGE_GLOBAL;
+	if (!is_initial_xendomain())
+		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
+
 	/* set the limit of our address space */
 	xen_reserve_top();
 
===================================================================
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -375,10 +375,8 @@
 
 pte_t xen_make_pte(pteval_t pte)
 {
-	if (pte & _PAGE_PRESENT) {
+	if (pte & _PAGE_PRESENT)
 		pte = phys_to_machine(XPADDR(pte)).maddr;
-		pte &= ~(_PAGE_PCD | _PAGE_PWT);
-	}
 
 	return (pte_t){ .pte = pte };
 }

