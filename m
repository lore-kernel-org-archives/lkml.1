Return-Path: <linux-kernel-owner+w=401wt.eu-S932313AbXDEAXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbXDEAXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932179AbXDEARd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:17:33 -0400
Received: from 230.sub-75-208-113.myvzw.com ([75.208.113.230]:36893 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932184AbXDEAQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:16:57 -0400
Message-Id: <20070404191204.813957928@goop.org>
References: <20070404191151.009821039@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 04 Apr 2007 12:11:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 02/20] Remove CONFIG_DEBUG_PARAVIRT
Content-Disposition: inline; filename=remove-CONFIG_DEBUG_PARAVIRT.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove CONFIG_DEBUG_PARAVIRT.  When inlining code, this option
attempts to trash registers in the patch-site's "clobber" field, on
the grounds that this should find bugs with incorrect clobbers.
Unfortunately, the clobber field really means "registers modified by
this patch site", which includes return values.

Because of this, this option has outlived its usefulness, so remove
it.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>

---
 arch/i386/Kconfig.debug        |   10 ----------
 arch/i386/kernel/alternative.c |   14 +-------------
 2 files changed, 1 insertion(+), 23 deletions(-)

===================================================================
--- a/arch/i386/Kconfig.debug
+++ b/arch/i386/Kconfig.debug
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
===================================================================
--- a/arch/i386/kernel/alternative.c
+++ b/arch/i386/kernel/alternative.c
@@ -359,19 +359,7 @@ void apply_paravirt(struct paravirt_patc
 
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

-- 

