Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbZAWWyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbZAWWyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 17:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757519AbZAWWyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 17:54:23 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:57627 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473AbZAWWyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 17:54:22 -0500
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Cc: Eric Anholt <eric@anholt.net>
Subject: [PATCH] x86: Work around PAGE_KERNEL_WC not getting WC in iomap_atomic_prot_pfn.
Date: Fri, 23 Jan 2009 14:54:18 -0800
Message-Id: <1232751258-32611-2-git-send-email-eric@anholt.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1232751258-32611-1-git-send-email-eric@anholt.net>
References: <1232751258-32611-1-git-send-email-eric@anholt.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the absence of PAT, PAGE_KERNEL_WC ends up mapping to a memory type that
gets UC behavior even in the presence of a WC MTRR covering the area in
question.  By swapping to PAGE_KERNEL_UC_MINUS, we can get the actual
behavior the caller wanted (WC if you can manage it, UC otherwise).

This is recovers the 40% performance improvement of using WC in the DRM
to upload vertex data.
---
 arch/x86/mm/iomap_32.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
index d0151d8..b5e3964 100644
--- a/arch/x86/mm/iomap_32.c
+++ b/arch/x86/mm/iomap_32.c
@@ -17,6 +17,7 @@
  */
 
 #include <asm/iomap.h>
+#include <asm/pat.h>
 #include <linux/module.h>
 
 /* Map 'pfn' using fixed map 'type' and protections 'prot'
@@ -29,6 +30,14 @@ iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
 
 	pagefault_disable();
 
+	/* For non-PAT systems, promote PAGE_KERNEL_WC to PAGE_KERNEL_UC_MINUS.
+	 * PAGE_KERNEL_WC maps to PWT, which translates to uncached if the
+	 * MTRR is UC or WC.  UC_MINUS gets the real intention, of the
+	 * user, which is "WC if the MTRR is WC, UC if you can't do that."
+	 */
+	if (!pat_enabled && pgprot_val(prot) == pgprot_val(PAGE_KERNEL_WC))
+	  prot = PAGE_KERNEL_UC_MINUS;
+
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte-idx, pfn_pte(pfn, prot));
-- 
1.5.6.5

