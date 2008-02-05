Return-Path: <linux-kernel-owner+w=401wt.eu-S1758531AbYBECcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531AbYBECcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 21:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755666AbYBECcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 21:32:05 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:18426 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658AbYBECcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 21:32:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=s3HmyDq84onnbUyWQOdDkrThMysbae86lu+3vDbMynId5+NAHkHS6FxuP2BACHbkOGOXwjGul7uoLlH4dFrkOx2rNesiU+RDHUGHdaup985HLPDekHIDpk4TpPQUtK6YxgXV7FEAb773RambY9U178EsjEVHCsVpl22aPKCNVko=
Subject: [PATCH] x86: fix sparse error in traps_32.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 18:32:00 -0800
Message-Id: <1202178720.6452.12.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/traps_32.c:1193:31: error: dubious one-bit signed bitfield

This was being used to ensure the proper alignment of the FXSAVE/FXRSTOR data.
This would create a sparse error in the _correct_ cases, hiding further
warnings.  Use BUILD_BUG_ON instead.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/traps_32.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 2f94f69..47ca425 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -1182,17 +1182,12 @@ void __init trap_init(void)
 #endif
 	set_trap_gate(19,&simd_coprocessor_error);
 
+	/*
+	 * Verify that the FXSAVE/FXRSTOR data will be 16-byte aligned.
+	 * Generate a build-time error if the alignment is wrong.
+	 */
+	BUILD_BUG_ON(offsetof(struct task_struct, thread.i387.fxsave) & 15);
 	if (cpu_has_fxsr) {
-		/*
-		 * Verify that the FXSAVE/FXRSTOR data will be 16-byte aligned.
-		 * Generates a compile-time "error: zero width for bit-field" if
-		 * the alignment is wrong.
-		 */
-		struct fxsrAlignAssert {
-			int _:!(offsetof(struct task_struct,
-					thread.i387.fxsave) & 15);
-		};
-
 		printk(KERN_INFO "Enabling fast FPU save and restore... ");
 		set_in_cr4(X86_CR4_OSFXSR);
 		printk("done.\n");
-- 
1.5.4.rc5.1138.g2602



