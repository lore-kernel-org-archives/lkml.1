Return-Path: <linux-kernel-owner+w=401wt.eu-S1760041AbZCCAkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760041AbZCCAkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbZCCAkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:40:32 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:41361 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbZCCAkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:40:31 -0500
Date: Mon, 2 Mar 2009 17:40:29 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
cc: linux-omap@vger.kernel.org, tony@atomide.com, r-woodruff2@ti.com,
       catalin.marinas@arm.com
Subject: [2nd REPOST] [PATCH] ARM: MMU: add a Non-cacheable Normal executable
 memory type
Message-ID: <alpine.DEB.2.00.0903021732510.30037@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

this is the second repost of this patch (the previous repost was 5 Feb 
2009).  

This patch, or one like it, is a necessary pre-requisite for merging the 
OMAP3 CORE DVFS patches.  No comments have been received.  Any reason why 
this patch cannot be merged?


- Paul


---------- Forwarded message ----------
Date: Mon, 15 Dec 2008 14:07:07 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-omap@vger.kernel.org, r-woodruff2@ti.com
Subject: [PATCH] ARM: MMU: add a Non-cacheable Normal executable memory type


This patch adds a Non-cacheable Normal ARM executable memory type, 
MT_MEMORY_NONCACHED.

On OMAP3, this is used for rapid dynamic voltage/frequency scaling in the 
VDD2 voltage domain.  OMAP3's SDRAM controller (SDRC) is in the VDD2 
voltage domain, and its clock frequency must change along with voltage.  
The SDRC clock change code cannot run from SDRAM itself, since SDRAM 
accesses are paused during the clock change.  So the current 
implementation of the DVFS code executes from OMAP on-chip SRAM, aka "OCM 
RAM."

If the OCM RAM pages are marked as Cacheable, the ARM cache controller 
will attempt to flush dirty cache lines to the SDRC, so it can fill those 
lines with OCM RAM instruction code.  The problem is that the SDRC is 
paused during DVFS, and so any SDRAM access causes the ARM MPU subsystem 
to hang.

TI's original solution to this problem was to mark the OCM RAM sections as 
Strongly Ordered memory, thus preventing caching.  This is overkill: since 
the memory is marked as non-bufferable, OCM RAM writes become quite 
needlessly slow.  The idea of "Strongly Ordered SRAM" is also conceptually 
disturbing.  Previous LAKML list discussion is here:

   http://www.spinics.net/lists/arm-kernel/msg54312.html

Now this memory type MT_MEMORY_NONCACHED is used by a future patch for OCM 
RAM.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Richard Woodruff <r-woodruff2@ti.com>
---
 arch/arm/include/asm/mach/map.h |    1 +
 arch/arm/mm/mmu.c               |   23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/mach/map.h b/arch/arm/include/asm/mach/map.h
index 39d949b..58cf91f 100644
--- a/arch/arm/include/asm/mach/map.h
+++ b/arch/arm/include/asm/mach/map.h
@@ -26,6 +26,7 @@ struct map_desc {
 #define MT_HIGH_VECTORS		8
 #define MT_MEMORY		9
 #define MT_ROM			10
+#define MT_MEMORY_NONCACHED	11
 
 #ifdef CONFIG_MMU
 extern void iotable_init(struct map_desc *, int);
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 7f36c82..9ad6413 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -242,6 +242,10 @@ static struct mem_type mem_types[] = {
 		.prot_sect = PMD_TYPE_SECT,
 		.domain    = DOMAIN_KERNEL,
 	},
+	[MT_MEMORY_NONCACHED] = {
+		.prot_sect = PMD_TYPE_SECT | PMD_SECT_AP_WRITE,
+		.domain    = DOMAIN_KERNEL,
+	},
 };
 
 const struct mem_type *get_mem_type(unsigned int type)
@@ -405,9 +409,28 @@ static void __init build_mem_type_table(void)
 		kern_pgprot |= L_PTE_SHARED;
 		vecs_pgprot |= L_PTE_SHARED;
 		mem_types[MT_MEMORY].prot_sect |= PMD_SECT_S;
+		mem_types[MT_MEMORY_NONCACHED].prot_sect |= PMD_SECT_S;
 #endif
 	}
 
+	/*
+	 * Non-cacheable Normal - intended for memory areas that must
+	 * not cause dirty cache line writebacks when used
+	 */
+	if (cpu_arch >= CPU_ARCH_ARMv6) {
+		if (cpu_arch >= CPU_ARCH_ARMv7 && (cr & CR_TRE)) {
+			/* Non-cacheable Normal is XCB = 001 */
+			mem_types[MT_MEMORY_NONCACHED].prot_sect |=
+				PMD_SECT_BUFFERED;
+		} else {
+			/* For both ARMv6 and non-TEX-remapping ARMv7 */
+			mem_types[MT_MEMORY_NONCACHED].prot_sect |=
+				PMD_SECT_TEX(1);
+		}
+	} else {
+		mem_types[MT_MEMORY_NONCACHED].prot_sect |= PMD_SECT_BUFFERABLE;
+	}
+
 	for (i = 0; i < 16; i++) {
 		unsigned long v = pgprot_val(protection_map[i]);
 		protection_map[i] = __pgprot(v | user_pgprot);

-------------------------------------------------------------------
List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
