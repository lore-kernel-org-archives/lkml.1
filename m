Return-Path: <linux-kernel-owner+w=401wt.eu-S1761622AbZE0Ha2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761622AbZE0Ha2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762217AbZE0H0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:26:23 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:46916 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762246AbZE0H0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:26:22 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       michal.simek@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 04/29] microblaze_mmu_v2: TLB low level code
Date: Wed, 27 May 2009 08:47:29 +0200
Message-Id: <1243406874-3917-5-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1243406874-3917-4-git-send-email-monstr@monstr.eu>
References: <1243406874-3917-1-git-send-email-monstr@monstr.eu>
 <1243406874-3917-2-git-send-email-monstr@monstr.eu>
 <1243406874-3917-3-git-send-email-monstr@monstr.eu>
 <1243406874-3917-4-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/misc.S |  120 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 120 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/misc.S

diff --git a/arch/microblaze/kernel/misc.S b/arch/microblaze/kernel/misc.S
new file mode 100644
index 0000000..d623efc
--- /dev/null
+++ b/arch/microblaze/kernel/misc.S
@@ -0,0 +1,120 @@
+/*
+ * Miscellaneous low-level MMU functions.
+ *
+ * Copyright (C) 2008-2009 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2008-2009 PetaLogix
+ * Copyright (C) 2007 Xilinx, Inc.  All rights reserved.
+ *
+ * Derived from arch/ppc/kernel/misc.S
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ */
+
+#include <linux/linkage.h>
+#include <linux/sys.h>
+#include <asm/unistd.h>
+#include <linux/errno.h>
+#include <asm/mmu.h>
+#include <asm/page.h>
+
+	.text
+/*
+ * Flush MMU TLB
+ *
+ * We avoid flushing the pinned 0, 1 and possibly 2 entries.
+ */
+.globl _tlbia;
+.align 4;
+_tlbia:
+	addik	r12, r0, 63 /* flush all entries (63 - 3) */
+	/* isync */
+_tlbia_1:
+	mts	rtlbx, r12
+	nop
+	mts	rtlbhi, r0 /* flush: ensure V is clear */
+	nop
+	addik	r11, r12, -2
+	bneid	r11, _tlbia_1 /* loop for all entries */
+	addik	r12, r12, -1
+	/* sync */
+	rtsd	r15, 8
+	nop
+
+/*
+ * Flush MMU TLB for a particular address (in r5)
+ */
+.globl _tlbie;
+.align 4;
+_tlbie:
+	mts	rtlbsx, r5 /* look up the address in TLB */
+	nop
+	mfs	r12, rtlbx /* Retrieve index */
+	nop
+	blti	r12, _tlbie_1 /* Check if found */
+	mts	rtlbhi, r0 /* flush: ensure V is clear */
+	nop
+_tlbie_1:
+	rtsd	r15, 8
+	nop
+
+/*
+ * Allocate TLB entry for early console
+ */
+.globl early_console_reg_tlb_alloc;
+.align 4;
+early_console_reg_tlb_alloc:
+	/*
+	 * Load a TLB entry for the UART, so that microblaze_progress() can use
+	 * the UARTs nice and early.  We use a 4k real==virtual mapping.
+	 */
+	ori	r4, r0, 2
+	mts	rtlbx, r4 /* TLB slot 2 */
+
+	or	r4,r5,r0
+	andi	r4,r4,0xfffff000
+	ori	r4,r4,(TLB_WR|TLB_I|TLB_M|TLB_G)
+
+	andi	r5,r5,0xfffff000
+	ori	r5,r5,(TLB_VALID | TLB_PAGESZ(PAGESZ_4K))
+
+	mts	rtlblo,r4 /* Load the data portion of the entry */
+	nop
+	mts	rtlbhi,r5 /* Load the tag portion of the entry */
+	nop
+	rtsd	r15, 8
+	nop
+
+/*
+ * Copy a whole page (4096 bytes).
+ */
+#define COPY_16_BYTES		\
+	lwi	r7, r6, 0;	\
+	lwi	r8, r6, 4;	\
+	lwi	r9, r6, 8;	\
+	lwi	r10, r6, 12;	\
+	swi	r7, r5, 0;	\
+	swi	r8, r5, 4;	\
+	swi	r9, r5, 8;	\
+	swi	r10, r5, 12
+
+
+/* FIXME DCACHE_LINE_BYTES (CONFIG_XILINX_MICROBLAZE0_DCACHE_LINE_LEN * 4)*/
+#define DCACHE_LINE_BYTES (4 * 4)
+
+.globl copy_page;
+.align 4;
+copy_page:
+	ori	r11, r0, (PAGE_SIZE/DCACHE_LINE_BYTES) - 1
+_copy_page_loop:
+	COPY_16_BYTES
+#if DCACHE_LINE_BYTES >= 32
+	COPY_16_BYTES
+#endif
+	addik	r6, r6, DCACHE_LINE_BYTES
+	addik	r5, r5, DCACHE_LINE_BYTES
+	bneid	r11, _copy_page_loop
+	addik	r11, r11, -1
+	rtsd	r15, 8
+	nop
-- 
1.5.5.1

