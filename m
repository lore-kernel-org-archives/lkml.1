Return-Path: <linux-kernel-owner+w=401wt.eu-S932573AbZKMX2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbZKMX2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932541AbZKMX2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:28:15 -0500
Received: from mga06.intel.com ([134.134.136.21]:11893 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932291AbZKMX2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:28:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,739,1249282800"; 
   d="scan'208";a="569382153"
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, x86@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/5] x86-32: use symbolic constants, safer CPUID when enabling EFER.NX
Date: Fri, 13 Nov 2009 15:28:13 -0800
Message-Id: <1258154897-6770-2-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258154897-6770-1-git-send-email-hpa@zytor.com>
References: <1258154897-6770-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use symbolic constants rather than hard-coded values when setting
EFER.NX in head_32.S, and do a more rigorous test for the validity of
the response when probing for the extended CPUID range.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/head_32.S |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 050c278..7fd318b 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -18,6 +18,8 @@
 #include <asm/asm-offsets.h>
 #include <asm/setup.h>
 #include <asm/processor-flags.h>
+#include <asm/msr-index.h>
+#include <asm/cpufeature.h>
 #include <asm/percpu.h>
 
 /* Physical address */
@@ -297,25 +299,27 @@ ENTRY(startup_32_smp)
 	orl %edx,%eax
 	movl %eax,%cr4
 
-	btl $5, %eax		# check if PAE is enabled
-	jnc 6f
+	testb $X86_CR4_PAE, %al		# check if PAE is enabled
+	jz 6f
 
 	/* Check if extended functions are implemented */
 	movl $0x80000000, %eax
 	cpuid
-	cmpl $0x80000000, %eax
-	jbe 6f
+	/* Value must be in the range 0x80000001 to 0x8000ffff */
+	subl $0x80000001, %eax
+	cmpl $(0x8000ffff-0x80000001), %eax
+	ja 6f
 	mov $0x80000001, %eax
 	cpuid
 	/* Execute Disable bit supported? */
-	btl $20, %edx
+	btl $(X86_FEATURE_NX & 31), %edx
 	jnc 6f
 
 	/* Setup EFER (Extended Feature Enable Register) */
-	movl $0xc0000080, %ecx
+	movl $MSR_EFER, %ecx
 	rdmsr
 
-	btsl $11, %eax
+	btsl $_EFER_NX, %eax
 	/* Make changes effective */
 	wrmsr
 
-- 
1.6.2.5

