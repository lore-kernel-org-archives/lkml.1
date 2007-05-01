Return-Path: <linux-kernel-owner+w=401wt.eu-S933452AbXEAEGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452AbXEAEGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932212AbXEAEBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:01:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946485AbXEAD6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:11 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [13/30] i386: Evaluate constant cpu features at runtime
Message-Id: <20070501035811.0135B13CAF@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Redefine cpu_has() to evaluate cpu features already checked in early 
boot at compile time.  This way the compiler might eliminate some dead code.
Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-i386/cpufeature.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux/include/asm-i386/cpufeature.h
===================================================================
--- linux.orig/include/asm-i386/cpufeature.h
+++ linux/include/asm-i386/cpufeature.h
@@ -106,8 +106,12 @@
 #define X86_FEATURE_LAHF_LM	(6*32+ 0) /* LAHF/SAHF in long mode */
 #define X86_FEATURE_CMP_LEGACY	(6*32+ 1) /* If yes HyperThreading not valid */
 
-#define cpu_has(c, bit)		test_bit(bit, (c)->x86_capability)
-#define boot_cpu_has(bit)	test_bit(bit, boot_cpu_data.x86_capability)
+#define cpu_has(c, bit)					\
+	((__builtin_constant_p(bit) && (bit) < 32 && 	\
+		(1UL << (bit)) & REQUIRED_MASK1) ?	\
+		1 : 					\
+	test_bit(bit, (c)->x86_capability))
+#define boot_cpu_has(bit)	cpu_has(&boot_cpu_data, bit)
 
 #define cpu_has_fpu		boot_cpu_has(X86_FEATURE_FPU)
 #define cpu_has_vme		boot_cpu_has(X86_FEATURE_VME)
