Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbZKPWHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbZKPWHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbZKPWHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:07:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:49489 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991AbZKPWHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:07:04 -0500
Date: Mon, 16 Nov 2009 22:06:41 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       kees.cook@canonical.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       kees.cook@canonical.com, tglx@linutronix.de
In-Reply-To: <1258154897-6770-2-git-send-email-hpa@zytor.com>
References: <1258154897-6770-2-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86-32: Use symbolic constants, safer CPUID when enabling EFER.NX
Message-ID: <tip-8a50e5135af0c243e117e94e27feb8d149c879b4@git.kernel.org>
Git-Commit-ID: 8a50e5135af0c243e117e94e27feb8d149c879b4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a50e5135af0c243e117e94e27feb8d149c879b4
Gitweb:     http://git.kernel.org/tip/8a50e5135af0c243e117e94e27feb8d149c879b4
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 13 Nov 2009 15:28:13 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 16 Nov 2009 13:44:56 -0800

x86-32: Use symbolic constants, safer CPUID when enabling EFER.NX

Use symbolic constants rather than hard-coded values when setting
EFER.NX in head_32.S, and do a more rigorous test for the validity of
the response when probing for the extended CPUID range.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <1258154897-6770-2-git-send-email-hpa@zytor.com>
Acked-by: Kees Cook <kees.cook@canonical.com>
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
 
