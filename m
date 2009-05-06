Return-Path: <linux-kernel-owner+w=401wt.eu-S1758835AbZEFMFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbZEFMFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbZEFMFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:05:30 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:15033 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbZEFMFa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:05:30 -0400
Message-Id: <4A019977.76EA.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 06 May 2009 13:06:47 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: finish clear_highmaps()'s job wrt. _brk_end
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: bug fix

With the introduction of the .brk section, special care must be taken
that no unused page table entries remain if _brk_end and _end are
separated by a 2M page boundary. clear_highmap() runs very early and
hence cannot take care of that, hence potential entries needing to be
removed past _brk_end must be cleared once the brk allocator has done
its job.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/init.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- linux-2.6.30-rc4/arch/x86/mm/init.c	2009-04-30 09:42:42.000000000 +0200
+++ 2.6.30-rc4-x86_64-brk_end-end/arch/x86/mm/init.c	2009-05-06 13:44:01.000000000 +0200
@@ -7,6 +7,7 @@
 #include <asm/page.h>
 #include <asm/page_types.h>
 #include <asm/sections.h>
+#include <asm/setup.h>
 #include <asm/system.h>
 #include <asm/tlbflush.h>
 
@@ -304,8 +305,23 @@ unsigned long __init_refok init_memory_m
 #endif
 
 #ifdef CONFIG_X86_64
-	if (!after_bootmem)
+	if (!after_bootmem && !start) {
+		pud_t *pud;
+		pmd_t *pmd;
+
 		mmu_cr4_features = read_cr4();
+
+		/*
+		 * _brk_end cannot change anymore, but it and _end may be
+		 * located on different 2M pages. cleanup_highmap(), however,
+		 * can only consider _end when it runs, so destroy any
+		 * mappings beyond _brk_end here.
+		 */
+		pud = pud_offset(pgd_offset_k(_brk_end), _brk_end);
+		pmd = pmd_offset(pud, _brk_end - 1);
+		while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1))
+			pmd_clear(pmd);
+	}
 #endif
 	__flush_tlb_all();
 



