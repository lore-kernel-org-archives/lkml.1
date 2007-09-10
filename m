Return-Path: <linux-kernel-owner+w=401wt.eu-S964930AbXIJNIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964930AbXIJNIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 09:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757525AbXIJNIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 09:08:04 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:43984
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756683AbXIJNIB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 09:08:01 -0400
Message-Id: <46E55E01.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 10 Sep 2007 14:08:49 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: multi-byte single instruction NOPs
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for and use the multi-byte NOPs recently documented to be
available on all PentiumPro and later processors.

This patch only applies cleanly on top of the "x86: misc.
constifications" patch sent earlier.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/i386/kernel/alternative.c |   23 ++++++++++++++++++++++-
 include/asm-i386/processor.h   |   22 ++++++++++++++++++++++
 include/asm-x86_64/processor.h |   22 ++++++++++++++++++++++
 3 files changed, 66 insertions(+), 1 deletion(-)

--- linux-2.6.23-rc5/arch/i386/kernel/alternative.c	2007-09-10 13:31:43.000000000 +0200
+++ 2.6.23-rc5-x86-const/arch/i386/kernel/alternative.c	2007-09-10 13:31:57.000000000 +0200
@@ -115,12 +115,31 @@ static const unsigned char *const k7_nop
 };
 #endif
 
+#ifdef P6_NOP1
+asm("\t.section .rodata, \"a\"\np6nops: "
+	P6_NOP1 P6_NOP2 P6_NOP3 P6_NOP4 P6_NOP5 P6_NOP6
+	P6_NOP7 P6_NOP8);
+extern const unsigned char p6nops[];
+static const unsigned char *const p6_nops[ASM_NOP_MAX+1] = {
+	NULL,
+	p6nops,
+	p6nops + 1,
+	p6nops + 1 + 2,
+	p6nops + 1 + 2 + 3,
+	p6nops + 1 + 2 + 3 + 4,
+	p6nops + 1 + 2 + 3 + 4 + 5,
+	p6nops + 1 + 2 + 3 + 4 + 5 + 6,
+	p6nops + 1 + 2 + 3 + 4 + 5 + 6 + 7,
+};
+#endif
+
 #ifdef CONFIG_X86_64
 
 extern char __vsyscall_0;
 static inline const unsigned char*const * find_nop_table(void)
 {
-	return k8_nops;
+	return boot_cpu_data.x86_vendor != X86_VENDOR_INTEL ||
+	       boot_cpu_data.x86 < 6 ? k8_nops : p6_nops;
 }
 
 #else /* CONFIG_X86_64 */
@@ -131,6 +150,8 @@ static const struct nop {
 } noptypes[] = {
 	{ X86_FEATURE_K8, k8_nops },
 	{ X86_FEATURE_K7, k7_nops },
+	{ X86_FEATURE_P4, p6_nops },
+	{ X86_FEATURE_P3, p6_nops },
 	{ -1, NULL }
 };
 
--- linux-2.6.23-rc5/include/asm-i386/processor.h	2007-09-10 13:31:43.000000000 +0200
+++ 2.6.23-rc5-x86-const/include/asm-i386/processor.h	2007-09-10 13:31:57.000000000 +0200
@@ -674,6 +674,17 @@ static inline unsigned int cpuid_edx(uns
 #define K7_NOP7        ".byte 0x8D,0x04,0x05,0,0,0,0\n"
 #define K7_NOP8        K7_NOP7 ASM_NOP1
 
+/* P6 nops */
+/* uses eax dependencies (Intel-recommended choice) */
+#define P6_NOP1	GENERIC_NOP1
+#define P6_NOP2	".byte 0x66,0x90\n"
+#define P6_NOP3	".byte 0x0f,0x1f,0x00\n"
+#define P6_NOP4	".byte 0x0f,0x1f,0x40,0\n"
+#define P6_NOP5	".byte 0x0f,0x1f,0x44,0x00,0\n"
+#define P6_NOP6	".byte 0x66,0x0f,0x1f,0x44,0x00,0\n"
+#define P6_NOP7	".byte 0x0f,0x1f,0x80,0,0,0,0\n"
+#define P6_NOP8	".byte 0x0f,0x1f,0x84,0x00,0,0,0,0\n"
+
 #ifdef CONFIG_MK8
 #define ASM_NOP1 K8_NOP1
 #define ASM_NOP2 K8_NOP2
@@ -692,6 +703,17 @@ static inline unsigned int cpuid_edx(uns
 #define ASM_NOP6 K7_NOP6
 #define ASM_NOP7 K7_NOP7
 #define ASM_NOP8 K7_NOP8
+#elif defined(CONFIG_M686) || defined(CONFIG_MPENTIUMII) || \
+      defined(CONFIG_MPENTIUMIII) || defined(CONFIG_MPENTIUMM) || \
+      defined(CONFIG_MCORE2) || defined(CONFIG_PENTIUM4)
+#define ASM_NOP1 P6_NOP1
+#define ASM_NOP2 P6_NOP2
+#define ASM_NOP3 P6_NOP3
+#define ASM_NOP4 P6_NOP4
+#define ASM_NOP5 P6_NOP5
+#define ASM_NOP6 P6_NOP6
+#define ASM_NOP7 P6_NOP7
+#define ASM_NOP8 P6_NOP8
 #else
 #define ASM_NOP1 GENERIC_NOP1
 #define ASM_NOP2 GENERIC_NOP2
--- linux-2.6.23-rc5/include/asm-x86_64/processor.h	2007-09-10 13:31:43.000000000 +0200
+++ 2.6.23-rc5-x86-const/include/asm-x86_64/processor.h	2007-09-10 13:31:57.000000000 +0200
@@ -334,6 +334,16 @@ struct extended_sigtable {
 };
 
 
+#if defined(CONFIG_MPSC) || defined(CONFIG_MCORE2)
+#define ASM_NOP1 P6_NOP1
+#define ASM_NOP2 P6_NOP2
+#define ASM_NOP3 P6_NOP3
+#define ASM_NOP4 P6_NOP4
+#define ASM_NOP5 P6_NOP5
+#define ASM_NOP6 P6_NOP6
+#define ASM_NOP7 P6_NOP7
+#define ASM_NOP8 P6_NOP8
+#else
 #define ASM_NOP1 K8_NOP1
 #define ASM_NOP2 K8_NOP2
 #define ASM_NOP3 K8_NOP3
@@ -342,6 +352,7 @@ struct extended_sigtable {
 #define ASM_NOP6 K8_NOP6
 #define ASM_NOP7 K8_NOP7
 #define ASM_NOP8 K8_NOP8
+#endif
 
 /* Opteron nops */
 #define K8_NOP1 ".byte 0x90\n"
@@ -353,6 +364,17 @@ struct extended_sigtable {
 #define K8_NOP7	K8_NOP4 K8_NOP3
 #define K8_NOP8	K8_NOP4 K8_NOP4
 
+/* P6 nops */
+/* uses eax dependencies (Intel-recommended choice) */
+#define P6_NOP1	".byte 0x90\n"
+#define P6_NOP2	".byte 0x66,0x90\n"
+#define P6_NOP3	".byte 0x0f,0x1f,0x00\n"
+#define P6_NOP4	".byte 0x0f,0x1f,0x40,0\n"
+#define P6_NOP5	".byte 0x0f,0x1f,0x44,0x00,0\n"
+#define P6_NOP6	".byte 0x66,0x0f,0x1f,0x44,0x00,0\n"
+#define P6_NOP7	".byte 0x0f,0x1f,0x80,0,0,0,0\n"
+#define P6_NOP8	".byte 0x0f,0x1f,0x84,0x00,0,0,0,0\n"
+
 #define ASM_NOP_MAX 8
 
 /* REP NOP (PAUSE) is a good thing to insert into busy-wait loops. */


