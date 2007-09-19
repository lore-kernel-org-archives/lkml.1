Return-Path: <linux-kernel-owner+w=401wt.eu-S1760506AbXISOi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760506AbXISOi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 10:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbXISOis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 10:38:48 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:23341
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760055AbXISOir convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 10:38:47 -0400
Message-Id: <46F150CB.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 19 Sep 2007 15:39:39 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386/PAE: avoid temporarily inconsistent pte-s
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One more of these issues (which were considered fixed a few releases
back): Other than on x86-64, i386 allows set_fixmap() to replace
already present mappings. Consequently, on PAE, care must be taken to
not update the high half of a pte while the low half is still holding
the old value.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/i386/mm/pgtable.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.23-rc6/arch/i386/mm/pgtable.c	2007-09-14 17:38:47.000000000 +0200
+++ 2.6.23-rc6-i386-set-fixmap/arch/i386/mm/pgtable.c	2007-09-19 10:49:53.000000000 +0200
@@ -97,8 +97,7 @@ static void set_pte_pfn(unsigned long va
 	}
 	pte = pte_offset_kernel(pmd, vaddr);
 	if (pgprot_val(flags))
-		/* <pfn,flags> stored as-is, to permit clearing entries */
-		set_pte(pte, pfn_pte(pfn, flags));
+		set_pte_present(&init_mm, vaddr, pte, pfn_pte(pfn, flags));
 	else
 		pte_clear(&init_mm, vaddr, pte);
 



