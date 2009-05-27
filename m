Return-Path: <linux-kernel-owner+w=401wt.eu-S1763313AbZE0HdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763313AbZE0HdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762440AbZE0H1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:27:11 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:46942 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762407AbZE0H1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:27:08 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       michal.simek@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 02/29] microblaze_mmu_v2: MMU update for startup code
Date: Wed, 27 May 2009 08:47:27 +0200
Message-Id: <1243406874-3917-3-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1243406874-3917-2-git-send-email-monstr@monstr.eu>
References: <1243406874-3917-1-git-send-email-monstr@monstr.eu>
 <1243406874-3917-2-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/head.S |  190 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 190 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/kernel/head.S b/arch/microblaze/kernel/head.S
index 319dc35..e568d6e 100644
--- a/arch/microblaze/kernel/head.S
+++ b/arch/microblaze/kernel/head.S
@@ -3,6 +3,26 @@
  * Copyright (C) 2007-2009 PetaLogix
  * Copyright (C) 2006 Atmark Techno, Inc.
  *
+ * MMU code derived from arch/ppc/kernel/head_4xx.S:
+ *    Copyright (c) 1995-1996 Gary Thomas <gdt@linuxppc.org>
+ *      Initial PowerPC version.
+ *    Copyright (c) 1996 Cort Dougan <cort@cs.nmt.edu>
+ *      Rewritten for PReP
+ *    Copyright (c) 1996 Paul Mackerras <paulus@cs.anu.edu.au>
+ *      Low-level exception handers, MMU support, and rewrite.
+ *    Copyright (c) 1997 Dan Malek <dmalek@jlc.net>
+ *      PowerPC 8xx modifications.
+ *    Copyright (c) 1998-1999 TiVo, Inc.
+ *      PowerPC 403GCX modifications.
+ *    Copyright (c) 1999 Grant Erickson <grant@lcse.umn.edu>
+ *      PowerPC 403GCX/405GP modifications.
+ *    Copyright 2000 MontaVista Software Inc.
+ *	PPC405 modifications
+ *      PowerPC 403GCX/405GP modifications.
+ * 	Author: MontaVista Software, Inc.
+ *         	frank_rowand@mvista.com or source@mvista.com
+ * 	   	debbie_chu@mvista.com
+ *
  * This file is subject to the terms and conditions of the GNU General Public
  * License. See the file "COPYING" in the main directory of this archive
  * for more details.
@@ -12,6 +32,22 @@
 #include <asm/thread_info.h>
 #include <asm/page.h>
 
+#ifdef CONFIG_MMU
+#include <asm/setup.h> /* COMMAND_LINE_SIZE */
+#include <asm/mmu.h>
+#include <asm/processor.h>
+
+.data
+.global empty_zero_page
+.align 12
+empty_zero_page:
+	.space	4096
+.global swapper_pg_dir
+swapper_pg_dir:
+	.space	4096
+
+#endif /* CONFIG_MMU */
+
 	.text
 ENTRY(_start)
 	mfs	r1, rmsr
@@ -32,6 +68,123 @@ _copy_fdt:
 	addik	r3, r3, -4 /* descrement loop */
 no_fdt_arg:
 
+#ifdef CONFIG_MMU
+
+#ifndef CONFIG_CMDLINE_BOOL
+/*
+ * handling command line
+ * copy command line to __init_end. There is space for storing command line.
+ */
+	or	r6, r0, r0		/* incremment */
+	ori	r4, r0, __init_end	/* load address of command line */
+	tophys(r4,r4)			/* convert to phys address */
+	ori	r3, r0, COMMAND_LINE_SIZE - 1 /* number of loops */
+_copy_command_line:
+	lbu	r7, r5, r6 /* r7=r5+r6 - r5 contain pointer to command line */
+	sb	r7, r4, r6		/* addr[r4+r6]= r7*/
+	addik	r6, r6, 1		/* increment counting */
+	bgtid	r3, _copy_command_line	/* loop for all entries       */
+	addik	r3, r3, -1		/* descrement loop */
+	addik	r5, r4, 0		/* add new space for command line */
+	tovirt(r5,r5)
+#endif /* CONFIG_CMDLINE_BOOL */
+
+#ifdef NOT_COMPILE
+/* save bram context */
+	or	r6, r0, r0				/* incremment */
+	ori	r4, r0, TOPHYS(_bram_load_start)	/* save bram context */
+	ori	r3, r0, (LMB_SIZE - 4)
+_copy_bram:
+	lw	r7, r0, r6		/* r7 = r0 + r6 */
+	sw	r7, r4, r6		/* addr[r4 + r6] = r7*/
+	addik	r6, r6, 4		/* increment counting */
+	bgtid	r3, _copy_bram		/* loop for all entries */
+	addik	r3, r3, -4		/* descrement loop */
+#endif
+	/* We have to turn on the MMU right away. */
+
+	/*
+	 * Set up the initial MMU state so we can do the first level of
+	 * kernel initialization.  This maps the first 16 MBytes of memory 1:1
+	 * virtual to physical.
+	 */
+	nop
+	addik	r3, r0, 63		/* Invalidate all TLB entries */
+_invalidate:
+	mts	rtlbx, r3
+	mts	rtlbhi, r0			/* flush: ensure V is clear   */
+	bgtid	r3, _invalidate		/* loop for all entries       */
+	addik	r3, r3, -1
+	/* sync */
+
+	/*
+	 * We should still be executing code at physical address area
+	 * RAM_BASEADDR at this point. However, kernel code is at
+	 * a virtual address. So, set up a TLB mapping to cover this once
+	 * translation is enabled.
+	 */
+
+	addik	r3,r0, CONFIG_KERNEL_START /* Load the kernel virtual address */
+	tophys(r4,r3)			/* Load the kernel physical address */
+
+	mts	rpid,r0			/* Load the kernel PID */
+	nop
+	bri	4
+
+	/*
+	 * Configure and load two entries into TLB slots 0 and 1.
+	 * In case we are pinning TLBs, these are reserved in by the
+	 * other TLB functions.  If not reserving, then it doesn't
+	 * matter where they are loaded.
+	 */
+	andi	r4,r4,0xfffffc00	/* Mask off the real page number */
+	ori	r4,r4,(TLB_WR | TLB_EX)	/* Set the write and execute bits */
+
+	andi	r3,r3,0xfffffc00	/* Mask off the effective page number */
+	ori	r3,r3,(TLB_VALID | TLB_PAGESZ(PAGESZ_16M))
+
+	mts     rtlbx,r0		/* TLB slow 0 */
+
+	mts	rtlblo,r4		/* Load the data portion of the entry */
+	mts	rtlbhi,r3		/* Load the tag portion of the entry */
+
+	addik	r4, r4, 0x01000000	/* Map next 16 M entries */
+	addik	r3, r3, 0x01000000
+
+	ori	r6,r0,1			/* TLB slot 1 */
+	mts     rtlbx,r6
+
+	mts	rtlblo,r4		/* Load the data portion of the entry */
+	mts	rtlbhi,r3		/* Load the tag portion of the entry */
+
+	/*
+	 * Load a TLB entry for LMB, since we need access to
+	 * the exception vectors, using a 4k real==virtual mapping.
+	 */
+	ori	r6,r0,3			/* TLB slot 3 */
+	mts     rtlbx,r6
+
+	ori	r4,r0,(TLB_WR | TLB_EX)
+	ori	r3,r0,(TLB_VALID | TLB_PAGESZ(PAGESZ_4K))
+
+	mts	rtlblo,r4		/* Load the data portion of the entry */
+	mts	rtlbhi,r3		/* Load the tag portion of the entry */
+
+	/*
+	 * We now have the lower 16 Meg of RAM mapped into TLB entries, and the
+	 * caches ready to work.
+	 */
+turn_on_mmu:
+	ori	r15,r0,start_here
+	ori	r4,r0,MSR_KERNEL_VMS
+	mts	rmsr,r4
+	nop
+	rted	r15,0			/* enables MMU */
+	nop
+
+start_here:
+#endif /* CONFIG_MMU */
+
 	/* Initialize small data anchors */
 	la	r13, r0, _KERNEL_SDA_BASE_
 	la	r2, r0, _KERNEL_SDA2_BASE_
@@ -51,6 +204,43 @@ no_fdt_arg:
 	brald	r15, r8
 	nop
 
+#ifndef CONFIG_MMU
 	la	r15, r0, machine_halt
 	braid	start_kernel
 	nop
+#else
+	/*
+	 * Initialize the MMU.
+	 */
+	bralid	r15, mmu_init
+	nop
+
+	/* Go back to running unmapped so we can load up new values
+	 * and change to using our exception vectors.
+	 * On the MicroBlaze, all we invalidate the used TLB entries to clear
+	 * the old 16M byte TLB mappings.
+	 */
+	ori	r15,r0,TOPHYS(kernel_load_context)
+	ori	r4,r0,MSR_KERNEL
+	mts	rmsr,r4
+	nop
+	bri	4
+	rted	r15,0
+	nop
+
+	/* Load up the kernel context */
+kernel_load_context:
+	# Keep entry 0 and 1 valid. Entry 3 mapped to LMB can go away.
+	ori	r5,r0,3
+	mts     rtlbx,r5
+	nop
+	mts	rtlbhi,r0
+	nop
+	addi	r15, r0, machine_halt
+	ori	r17, r0, start_kernel
+	ori	r4, r0, MSR_KERNEL_VMS
+	mts	rmsr, r4
+	nop
+	rted	r17, 0		/* enable MMU and jump to start_kernel */
+	nop
+#endif /* CONFIG_MMU */
-- 
1.5.5.1

