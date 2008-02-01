Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbYBAJkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbYBAJkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbYBAJjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:39:55 -0500
Received: from hu-out-0506.google.com ([72.14.214.224]:29024 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbYBAJjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:39:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LUeLDyF3tp21uxQhUPu1yUj2SX3DN2Y6B2FKxsowVC+mPnt1G4Ner+xSE/FDtgYjHXxxnHG6tMdlnjYAJyGaOE5sr9k5kpf32WJomvCZDGm78cjvy5NWj4NfRDHRDQmLQqG1ZGWGRAFVKqp5MJC8eo4k6XR2aBCFqeVKMdkE908=
Subject: [PATCH] x86: Remove long dead cyrix mtrr code
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 01:39:07 -0800
Message-Id: <1201858747.23523.103.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cyrix_arr_init was #if 0 all the way back to at least v2.6.12.

This was the only place where arr3_protected was set to anything
but zero.  Eliminate this variable.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/cyrix.c |  107 --------------------------------------
 arch/x86/kernel/cpu/mtrr/main.c  |   12 ----
 2 files changed, 0 insertions(+), 119 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cyrix.c b/arch/x86/kernel/cpu/mtrr/cyrix.c
index 8e139c7..ff14c32 100644
--- a/arch/x86/kernel/cpu/mtrr/cyrix.c
+++ b/arch/x86/kernel/cpu/mtrr/cyrix.c
@@ -7,8 +7,6 @@
 #include <asm/processor-flags.h>
 #include "mtrr.h"
 
-int arr3_protected;
-
 static void
 cyrix_get_arr(unsigned int reg, unsigned long *base,
 	      unsigned long *size, mtrr_type * type)
@@ -99,8 +97,6 @@ cyrix_get_free_region(unsigned long base, unsigned long size, int replace_reg)
 	case 4:
 		return replace_reg;
 	case 3:
-		if (arr3_protected)
-			break;
 	case 2:
 	case 1:
 	case 0:
@@ -115,8 +111,6 @@ cyrix_get_free_region(unsigned long base, unsigned long size, int replace_reg)
 	} else {
 		for (i = 0; i < 7; i++) {
 			cyrix_get_arr(i, &lbase, &lsize, &ltype);
-			if ((i == 3) && arr3_protected)
-				continue;
 			if (lsize == 0)
 				return i;
 		}
@@ -260,107 +254,6 @@ static void cyrix_set_all(void)
 	post_set();
 }
 
-#if 0
-/*
- * On Cyrix 6x86(MX) and M II the ARR3 is special: it has connection
- * with the SMM (System Management Mode) mode. So we need the following:
- * Check whether SMI_LOCK (CCR3 bit 0) is set
- *   if it is set, write a warning message: ARR3 cannot be changed!
- *     (it cannot be changed until the next processor reset)
- *   if it is reset, then we can change it, set all the needed bits:
- *   - disable access to SMM memory through ARR3 range (CCR1 bit 7 reset)
- *   - disable access to SMM memory (CCR1 bit 2 reset)
- *   - disable SMM mode (CCR1 bit 1 reset)
- *   - disable write protection of ARR3 (CCR6 bit 1 reset)
- *   - (maybe) disable ARR3
- * Just to be sure, we enable ARR usage by the processor (CCR5 bit 5 set)
- */
-static void __init
-cyrix_arr_init(void)
-{
-	struct set_mtrr_context ctxt;
-	unsigned char ccr[7];
-	int ccrc[7] = { 0, 0, 0, 0, 0, 0, 0 };
-#ifdef CONFIG_SMP
-	int i;
-#endif
-
-	/* flush cache and enable MAPEN */
-	set_mtrr_prepare_save(&ctxt);
-	set_mtrr_cache_disable(&ctxt);
-
-	/* Save all CCRs locally */
-	ccr[0] = getCx86(CX86_CCR0);
-	ccr[1] = getCx86(CX86_CCR1);
-	ccr[2] = getCx86(CX86_CCR2);
-	ccr[3] = ctxt.ccr3;
-	ccr[4] = getCx86(CX86_CCR4);
-	ccr[5] = getCx86(CX86_CCR5);
-	ccr[6] = getCx86(CX86_CCR6);
-
-	if (ccr[3] & 1) {
-		ccrc[3] = 1;
-		arr3_protected = 1;
-	} else {
-		/* Disable SMM mode (bit 1), access to SMM memory (bit 2) and
-		 * access to SMM memory through ARR3 (bit 7).
-		 */
-		if (ccr[1] & 0x80) {
-			ccr[1] &= 0x7f;
-			ccrc[1] |= 0x80;
-		}
-		if (ccr[1] & 0x04) {
-			ccr[1] &= 0xfb;
-			ccrc[1] |= 0x04;
-		}
-		if (ccr[1] & 0x02) {
-			ccr[1] &= 0xfd;
-			ccrc[1] |= 0x02;
-		}
-		arr3_protected = 0;
-		if (ccr[6] & 0x02) {
-			ccr[6] &= 0xfd;
-			ccrc[6] = 1;	/* Disable write protection of ARR3 */
-			setCx86(CX86_CCR6, ccr[6]);
-		}
-		/* Disable ARR3. This is safe now that we disabled SMM. */
-		/* cyrix_set_arr_up (3, 0, 0, 0, FALSE); */
-	}
-	/* If we changed CCR1 in memory, change it in the processor, too. */
-	if (ccrc[1])
-		setCx86(CX86_CCR1, ccr[1]);
-
-	/* Enable ARR usage by the processor */
-	if (!(ccr[5] & 0x20)) {
-		ccr[5] |= 0x20;
-		ccrc[5] = 1;
-		setCx86(CX86_CCR5, ccr[5]);
-	}
-#ifdef CONFIG_SMP
-	for (i = 0; i < 7; i++)
-		ccr_state[i] = ccr[i];
-	for (i = 0; i < 8; i++)
-		cyrix_get_arr(i,
-			      &arr_state[i].base, &arr_state[i].size,
-			      &arr_state[i].type);
-#endif
-
-	set_mtrr_done(&ctxt);	/* flush cache and disable MAPEN */
-
-	if (ccrc[5])
-		printk(KERN_INFO "mtrr: ARR usage was not enabled, enabled manually\n");
-	if (ccrc[3])
-		printk(KERN_INFO "mtrr: ARR3 cannot be changed\n");
-/*
-    if ( ccrc[1] & 0x80) printk ("mtrr: SMM memory access through ARR3 disabled\n");
-    if ( ccrc[1] & 0x04) printk ("mtrr: SMM memory access disabled\n");
-    if ( ccrc[1] & 0x02) printk ("mtrr: SMM mode disabled\n");
-*/
-	if (ccrc[6])
-		printk(KERN_INFO "mtrr: ARR3 was write protected, unprotected\n");
-}
-#endif
-
 static struct mtrr_ops cyrix_mtrr_ops = {
 	.vendor            = X86_VENDOR_CYRIX,
 //	.init              = cyrix_arr_init,
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 7159195..822d8f9 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -59,12 +59,6 @@ struct mtrr_ops * mtrr_if = NULL;
 static void set_mtrr(unsigned int reg, unsigned long base,
 		     unsigned long size, mtrr_type type);
 
-#ifndef CONFIG_X86_64
-extern int arr3_protected;
-#else
-#define arr3_protected 0
-#endif
-
 void set_mtrr_ops(struct mtrr_ops * ops)
 {
 	if (ops->vendor && ops->vendor < X86_VENDOR_NUM)
@@ -513,12 +507,6 @@ int mtrr_del_page(int reg, unsigned long base, unsigned long size)
 		printk(KERN_WARNING "mtrr: register: %d too big\n", reg);
 		goto out;
 	}
-	if (is_cpu(CYRIX) && !use_intel()) {
-		if ((reg == 3) && arr3_protected) {
-			printk(KERN_WARNING "mtrr: ARR3 cannot be changed\n");
-			goto out;
-		}
-	}
 	mtrr_if->get(reg, &lbase, &lsize, &ltype);
 	if (lsize < 1) {
 		printk(KERN_WARNING "mtrr: MTRR %d not used\n", reg);
-- 
1.5.4.rc4.1142.gf5a97



