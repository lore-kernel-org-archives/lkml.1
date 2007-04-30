Return-Path: <linux-kernel-owner+w=401wt.eu-S1751049AbXD3K1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751049AbXD3K1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbXD3K1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:27:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:51141 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbXD3K1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:27:39 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, rusty@rustcorp.com.au, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [2/40] i386: Remove CONFIG_DEBUG_PARAVIRT
Message-Id: <20070430102734.CCFEB151F6@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:27:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
Remove CONFIG_DEBUG_PARAVIRT.  When inlining code, this option
attempts to trash registers in the patch-site's "clobber" field, on
the grounds that this should find bugs with incorrect clobbers.
Unfortunately, the clobber field really means "registers modified by
this patch site", which includes return values.

Because of this, this option has outlived its usefulness, so remove
it.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>

---
 arch/i386/Kconfig.debug        |   10 ----------
 arch/i386/kernel/alternative.c |   14 +-------------
 2 files changed, 1 insertion(+), 23 deletions(-)

===================================================================
Index: linux/arch/i386/Kconfig.debug
===================================================================
--- linux.orig/arch/i386/Kconfig.debug
+++ linux/arch/i386/Kconfig.debug
@@ -85,14 +85,4 @@ config DOUBLEFAULT
           option saves about 4k and might cause you much additional grey
           hair.
 
-config DEBUG_PARAVIRT
-	bool "Enable some paravirtualization debugging"
-	default n
-	depends on PARAVIRT && DEBUG_KERNEL
-	help
-	  Currently deliberately clobbers regs which are allowed to be
-	  clobbered in inlined paravirt hooks, even in native mode.
-	  If turning this off solves a problem, then DISABLE_INTERRUPTS() or
-	  ENABLE_INTERRUPTS() is lying about what registers can be clobbered.
-
 endmenu
Index: linux/arch/i386/kernel/alternative.c
===================================================================
--- linux.orig/arch/i386/kernel/alternative.c
+++ linux/arch/i386/kernel/alternative.c
@@ -334,19 +334,7 @@ void apply_paravirt(struct paravirt_patc
 
 		used = paravirt_ops.patch(p->instrtype, p->clobbers, p->instr,
 					  p->len);
-#ifdef CONFIG_DEBUG_PARAVIRT
-		{
-		int i;
-		/* Deliberately clobber regs using "not %reg" to find bugs. */
-		for (i = 0; i < 3; i++) {
-			if (p->len - used >= 2 && (p->clobbers & (1 << i))) {
-				memcpy(p->instr + used, "\xf7\xd0", 2);
-				p->instr[used+1] |= i;
-				used += 2;
-			}
-		}
-		}
-#endif
+
 		/* Pad the rest with nops */
 		nop_out(p->instr + used, p->len - used);
 	}
