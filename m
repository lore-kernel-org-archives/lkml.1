Return-Path: <linux-kernel-owner+w=401wt.eu-S2992466AbXEAEDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992466AbXEAEDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946311AbXEAEBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:01:40 -0400
Received: from ns1.suse.de ([195.135.220.2]:60922 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946408AbXEAD6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:07 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [9/30] x86_64: Use symbolic CPU features in early CPUID check
Message-Id: <20070501035806.AE6BF13CAF@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Dead to magic numbers!

Generated code is the same.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/verify_cpu.S |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

Index: linux/arch/x86_64/kernel/verify_cpu.S
===================================================================
--- linux.orig/arch/x86_64/kernel/verify_cpu.S
+++ linux/arch/x86_64/kernel/verify_cpu.S
@@ -30,18 +30,27 @@
  * 	appropriately. Either display a message or halt.
  */
 
-verify_cpu:
+#include <asm/cpufeature.h>
 
+verify_cpu:
 	pushfl				# Save caller passed flags
 	pushl	$0			# Kill any dangerous flags
 	popfl
 
-	/* minimum CPUID flags for x86-64 */
-	/* see http://www.x86-64.org/lists/discuss/msg02971.html */
-#define SSE_MASK ((1<<25)|(1<<26))
-#define REQUIRED_MASK1 ((1<<0)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<8)|\
-					   (1<<13)|(1<<15)|(1<<24))
-#define REQUIRED_MASK2 (1<<29)
+	/* minimum CPUID flags for x86-64 as defined by AMD */
+#define M(x) (1<<(x))
+#define M2(a,b) M(a)|M(b)
+#define M4(a,b,c,d) M(a)|M(b)|M(c)|M(d)
+
+#define SSE_MASK \
+	(M2(X86_FEATURE_XMM,X86_FEATURE_XMM2))
+#define REQUIRED_MASK1 \
+	(M4(X86_FEATURE_FPU,X86_FEATURE_PSE,X86_FEATURE_TSC,X86_FEATURE_MSR)|\
+	 M4(X86_FEATURE_PAE,X86_FEATURE_CX8,X86_FEATURE_PGE,X86_FEATURE_CMOV)|\
+	 M(X86_FEATURE_FXSR))
+#define REQUIRED_MASK2 \
+	(M(X86_FEATURE_LM - 32))
+
 	pushfl				# standard way to check for cpuid
 	popl	%eax
 	movl	%eax,%ebx
