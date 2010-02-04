Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab0BDJ6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:58:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:60205 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756318Ab0BDJ6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:58:18 -0500
Date: Thu, 4 Feb 2010 09:57:44 GMT
From: tip-bot for Borislav Petkov <petkovbb@googlemail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       petkovbb@googlemail.com, tglx@linutronix.de, mingo@elte.hu,
       borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       petkovbb@googlemail.com, tglx@linutronix.de, borislav.petkov@amd.com,
       mingo@elte.hu
In-Reply-To: <20100204085128.GA513@liondog.tnic>
References: <20100204085128.GA513@liondog.tnic>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, mtrr: Remove unused mtrr/state.c
Message-ID: <tip-34d2819f20782feb60f9434470ecfb200875fd41@git.kernel.org>
Git-Commit-ID: 34d2819f20782feb60f9434470ecfb200875fd41
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 09:57:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  34d2819f20782feb60f9434470ecfb200875fd41
Gitweb:     http://git.kernel.org/tip/34d2819f20782feb60f9434470ecfb200875fd41
Author:     Borislav Petkov <petkovbb@googlemail.com>
AuthorDate: Thu, 4 Feb 2010 09:51:28 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Feb 2010 10:01:38 +0100

x86, mtrr: Remove unused mtrr/state.c

The last reference to the helpers in
<arch/x86/kernel/cpu/mtrr/state.c> went away with
9a6b344ea967efa0bb5ca4cb5405f840652b66c4 leaving unused code.
Remove it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20100204085128.GA513@liondog.tnic>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mtrr/Makefile |    2 +-
 arch/x86/kernel/cpu/mtrr/state.c  |   94 -------------------------------------
 2 files changed, 1 insertions(+), 95 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/Makefile b/arch/x86/kernel/cpu/mtrr/Makefile
index f4361b5..ad9e5ed 100644
--- a/arch/x86/kernel/cpu/mtrr/Makefile
+++ b/arch/x86/kernel/cpu/mtrr/Makefile
@@ -1,3 +1,3 @@
-obj-y		:= main.o if.o generic.o state.o cleanup.o
+obj-y		:= main.o if.o generic.o cleanup.o
 obj-$(CONFIG_X86_32) += amd.o cyrix.o centaur.o
 
diff --git a/arch/x86/kernel/cpu/mtrr/state.c b/arch/x86/kernel/cpu/mtrr/state.c
deleted file mode 100644
index dfc80b4..0000000
--- a/arch/x86/kernel/cpu/mtrr/state.c
+++ /dev/null
@@ -1,94 +0,0 @@
-#include <linux/init.h>
-#include <linux/io.h>
-#include <linux/mm.h>
-
-#include <asm/processor-cyrix.h>
-#include <asm/processor-flags.h>
-#include <asm/mtrr.h>
-#include <asm/msr.h>
-
-#include "mtrr.h"
-
-/* Put the processor into a state where MTRRs can be safely set */
-void set_mtrr_prepare_save(struct set_mtrr_context *ctxt)
-{
-	unsigned int cr0;
-
-	/* Disable interrupts locally */
-	local_irq_save(ctxt->flags);
-
-	if (use_intel() || is_cpu(CYRIX)) {
-
-		/* Save value of CR4 and clear Page Global Enable (bit 7) */
-		if (cpu_has_pge) {
-			ctxt->cr4val = read_cr4();
-			write_cr4(ctxt->cr4val & ~X86_CR4_PGE);
-		}
-
-		/*
-		 * Disable and flush caches. Note that wbinvd flushes the TLBs
-		 * as a side-effect
-		 */
-		cr0 = read_cr0() | X86_CR0_CD;
-		wbinvd();
-		write_cr0(cr0);
-		wbinvd();
-
-		if (use_intel()) {
-			/* Save MTRR state */
-			rdmsr(MSR_MTRRdefType, ctxt->deftype_lo, ctxt->deftype_hi);
-		} else {
-			/*
-			 * Cyrix ARRs -
-			 * everything else were excluded at the top
-			 */
-			ctxt->ccr3 = getCx86(CX86_CCR3);
-		}
-	}
-}
-
-void set_mtrr_cache_disable(struct set_mtrr_context *ctxt)
-{
-	if (use_intel()) {
-		/* Disable MTRRs, and set the default type to uncached */
-		mtrr_wrmsr(MSR_MTRRdefType, ctxt->deftype_lo & 0xf300UL,
-		      ctxt->deftype_hi);
-	} else {
-		if (is_cpu(CYRIX)) {
-			/* Cyrix ARRs - everything else were excluded at the top */
-			setCx86(CX86_CCR3, (ctxt->ccr3 & 0x0f) | 0x10);
-		}
-	}
-}
-
-/* Restore the processor after a set_mtrr_prepare */
-void set_mtrr_done(struct set_mtrr_context *ctxt)
-{
-	if (use_intel() || is_cpu(CYRIX)) {
-
-		/* Flush caches and TLBs */
-		wbinvd();
-
-		/* Restore MTRRdefType */
-		if (use_intel()) {
-			/* Intel (P6) standard MTRRs */
-			mtrr_wrmsr(MSR_MTRRdefType, ctxt->deftype_lo,
-				   ctxt->deftype_hi);
-		} else {
-			/*
-			 * Cyrix ARRs -
-			 * everything else was excluded at the top
-			 */
-			setCx86(CX86_CCR3, ctxt->ccr3);
-		}
-
-		/* Enable caches */
-		write_cr0(read_cr0() & 0xbfffffff);
-
-		/* Restore value of CR4 */
-		if (cpu_has_pge)
-			write_cr4(ctxt->cr4val);
-	}
-	/* Re-enable interrupts locally (if enabled previously) */
-	local_irq_restore(ctxt->flags);
-}
