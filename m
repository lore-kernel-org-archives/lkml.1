Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab0BDIvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:51:38 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:43002 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab0BDIvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 03:51:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=s9488ekZD5jxeQohJFrOSYiDJrY0UiwWzmuF9zXpllrHruH8GoQ98W8LNSW/zUqZXO
         +6cJm0YTZfzKR2AAy/IPnmMUyJnmct1eV9XJ2Gu0EfHjebwW/geYTW+a4dG81pRUeGsj
         ukkx7NZvi+lV4F7zhFt0FkNKYeL8d+vfGwyiQ=
Date: Thu, 4 Feb 2010 09:51:28 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       x86 <x86@kernel.org>
Subject: Re: mtrr/state.c unused?
Message-ID: <20100204085128.GA513@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	x86 <x86@kernel.org>
References: <20100203202425.GC1367@aftab>
 <20100204082428.GA21938@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100204082428.GA21938@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 09:24:28AM +0100, Ingo Molnar wrote:
> 
> * Borislav Petkov <bp@amd64.org> wrote:
> 
> > It looks like <arch/x86/kernel/cpu/mtrr/state.c> is not used by
> > anything in the kernel.
> 
> Good catch - i dont see it used either. Mind sending a patch?

Yep, here we go:

--
>From 059e59699f15c824c35a85774c377ffcae6bffdf Mon Sep 17 00:00:00 2001
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Thu, 4 Feb 2010 09:36:03 +0100
Subject: [PATCH] x86, mtrr: Remove unused mtrr/state.c

The last reference to the helpers in <arch/x86/kernel/cpu/mtrr/state.c>
went away with 9a6b344ea967efa0bb5ca4cb5405f840652b66c4 leaving unused
code. Remove it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mtrr/Makefile |    2 +-
 arch/x86/kernel/cpu/mtrr/state.c  |   94 -------------------------------------
 2 files changed, 1 insertions(+), 95 deletions(-)
 delete mode 100644 arch/x86/kernel/cpu/mtrr/state.c

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
-- 
1.6.6

-- 
Regards/Gruss,
    Boris.
