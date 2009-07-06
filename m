Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbZGFMTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbZGFMTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 08:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbZGFMTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 08:19:10 -0400
Received: from ozlabs.org ([203.10.76.45]:53967 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbZGFMTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 08:19:09 -0400
Date: Mon, 6 Jul 2009 22:18:45 +1000
From: Anton Blanchard <anton@samba.org>
To: mingo@elte.hu, a.p.zijlstra@chello.nl, paulus@samba.org,
       benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH] powerpc/perf_counter: Add alignment-faults and
	emulation-faults sw events
Message-ID: <20090706121845.GD4391@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hook up the alignment-faults and emulation-faults events for powerpc.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Lots of duplication between PPC_WARN_EMULATED() and perf_swcounter_event()
here. Maybe we need to create PPC_WARN_ALIGNMENT(), use it and hide all
calls to perf_swcounter_event in the macros.

Index: linux.trees.git/arch/powerpc/kernel/align.c
===================================================================
--- linux.trees.git.orig/arch/powerpc/kernel/align.c	2009-07-06 21:50:53.000000000 +1000
+++ linux.trees.git/arch/powerpc/kernel/align.c	2009-07-06 22:10:41.000000000 +1000
@@ -25,6 +25,7 @@
 #include <asm/cache.h>
 #include <asm/cputable.h>
 #include <asm/emulated_ops.h>
+#include <linux/perf_counter.h>
 
 struct aligninfo {
 	unsigned char len;
@@ -707,6 +708,9 @@
 	 */
 	CHECK_FULL_REGS(regs);
 
+	perf_swcounter_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, 0, regs,
+			     regs->nip);
+
 	dsisr = regs->dsisr;
 
 	/* Some processors don't provide us with a DSISR we can use here,
Index: linux.trees.git/arch/powerpc/kernel/traps.c
===================================================================
--- linux.trees.git.orig/arch/powerpc/kernel/traps.c	2009-07-06 21:50:53.000000000 +1000
+++ linux.trees.git/arch/powerpc/kernel/traps.c	2009-07-06 22:11:52.000000000 +1000
@@ -34,6 +34,7 @@
 #include <linux/bug.h>
 #include <linux/kdebug.h>
 #include <linux/debugfs.h>
+#include <linux/perf_counter.h>
 
 #include <asm/emulated_ops.h>
 #include <asm/pgtable.h>
@@ -759,6 +760,8 @@
 
 	/* Emulate the mfspr rD, PVR. */
 	if ((instword & PPC_INST_MFSPR_PVR_MASK) == PPC_INST_MFSPR_PVR) {
+		perf_swcounter_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, 0,
+				     regs, regs->nip);
 		PPC_WARN_EMULATED(mfpvr);
 		rd = (instword >> 21) & 0x1f;
 		regs->gpr[rd] = mfspr(SPRN_PVR);
@@ -767,6 +770,8 @@
 
 	/* Emulating the dcba insn is just a no-op.  */
 	if ((instword & PPC_INST_DCBA_MASK) == PPC_INST_DCBA) {
+		perf_swcounter_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, 0,
+				     regs, regs->nip);
 		PPC_WARN_EMULATED(dcba);
 		return 0;
 	}
@@ -776,6 +781,8 @@
 		int shift = (instword >> 21) & 0x1c;
 		unsigned long msk = 0xf0000000UL >> shift;
 
+		perf_swcounter_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, 0,
+				     regs, regs->nip);
 		PPC_WARN_EMULATED(mcrxr);
 		regs->ccr = (regs->ccr & ~msk) | ((regs->xer >> shift) & msk);
 		regs->xer &= ~0xf0000000UL;
@@ -784,18 +791,24 @@
 
 	/* Emulate load/store string insn. */
 	if ((instword & PPC_INST_STRING_GEN_MASK) == PPC_INST_STRING) {
+		perf_swcounter_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, 0,
+				     regs, regs->nip);
 		PPC_WARN_EMULATED(string);
 		return emulate_string_inst(regs, instword);
 	}
 
 	/* Emulate the popcntb (Population Count Bytes) instruction. */
 	if ((instword & PPC_INST_POPCNTB_MASK) == PPC_INST_POPCNTB) {
+		perf_swcounter_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, 0,
+				     regs, regs->nip);
 		PPC_WARN_EMULATED(popcntb);
 		return emulate_popcntb_inst(regs, instword);
 	}
 
 	/* Emulate isel (Integer Select) instruction */
 	if ((instword & PPC_INST_ISEL_MASK) == PPC_INST_ISEL) {
+		perf_swcounter_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, 0,
+				     regs, regs->nip);
 		PPC_WARN_EMULATED(isel);
 		return emulate_isel(regs, instword);
 	}
@@ -994,8 +1007,11 @@
 
 #ifdef CONFIG_MATH_EMULATION
 	errcode = do_mathemu(regs);
-	if (errcode >= 0)
+	if (errcode >= 0) {
+		perf_swcounter_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, 0,
+				     regs, regs->nip);
 		PPC_WARN_EMULATED(math);
+	}
 
 	switch (errcode) {
 	case 0:
@@ -1017,8 +1033,11 @@
 
 #elif defined(CONFIG_8XX_MINIMAL_FPEMU)
 	errcode = Soft_emulate_8xx(regs);
-	if (errcode >= 0)
+	if (errcode >= 0) {
+		perf_swcounter_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, 0,
+				     regs, regs->nip);
 		PPC_WARN_EMULATED(8xx);
+	}
 
 	switch (errcode) {
 	case 0:
@@ -1129,6 +1148,8 @@
 
 	flush_altivec_to_thread(current);
 
+	perf_swcounter_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, 0, regs,
+			     regs->nip);
 	PPC_WARN_EMULATED(altivec);
 	err = emulate_altivec(regs);
 	if (err == 0) {
