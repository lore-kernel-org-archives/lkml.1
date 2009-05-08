Return-Path: <linux-kernel-owner+w=401wt.eu-S1763026AbZEHQYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763026AbZEHQYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 12:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbZEHQY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 12:24:27 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:37566 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZEHQY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 12:24:26 -0400
X-BigFish: VPS-10(zz936eQ4015Lzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KJC2WA-01-IF9-01
Date: Fri, 8 May 2009 18:23:50 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: display extended apic registers with print_local_APIC
	and cpu_debug code
Message-ID: <20090508162350.GO29045@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 08 May 2009 16:24:15.0496 (UTC) FILETIME=[6DEF1080:01C9CFF9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both print_local_APIC (used when apic=debug kernel param is set) and
cpu_debug code missed support for some extended APIC registers that
I'd like to see.

This adds support to show
- extended APIC feature register
- extended APIC control register
- extended LVT registers

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/apicdef.h  |    8 ++++----
 arch/x86/kernel/apic/apic.c     |    2 +-
 arch/x86/kernel/apic/io_apic.c  |   14 +++++++++++++-
 arch/x86/kernel/cpu/cpu_debug.c |   14 +++++++++++++-
 4 files changed, 31 insertions(+), 7 deletions(-)

Please apply.

Thanks,
Andreas

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index bc9514f..7ddb36a 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -22,6 +22,7 @@
 #  define	APIC_INTEGRATED(x)	(1)
 #endif
 #define		APIC_XAPIC(x)		((x) >= 0x14)
+#define		APIC_EXT_SPACE(x)	((x) & 0x80000000)
 #define	APIC_TASKPRI	0x80
 #define		APIC_TPRI_MASK		0xFFu
 #define	APIC_ARBPRI	0x90
@@ -116,7 +117,9 @@
 #define		APIC_TDR_DIV_32		0x8
 #define		APIC_TDR_DIV_64		0x9
 #define		APIC_TDR_DIV_128	0xA
-#define	APIC_EILVT0     0x500
+#define	APIC_EFEAT	0x400
+#define	APIC_ECTRL	0x410
+#define APIC_EILVTn(n)	(0x500 + 0x10 * n)
 #define		APIC_EILVT_NR_AMD_K8	1	/* # of extended interrupts */
 #define		APIC_EILVT_NR_AMD_10H	4
 #define		APIC_EILVT_LVTOFF(x)	(((x) >> 4) & 0xF)
@@ -125,9 +128,6 @@
 #define		APIC_EILVT_MSG_NMI	0x4
 #define		APIC_EILVT_MSG_EXT	0x7
 #define		APIC_EILVT_MASKED	(1 << 16)
-#define	APIC_EILVT1     0x510
-#define	APIC_EILVT2     0x520
-#define	APIC_EILVT3     0x530
 
 #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
 #define APIC_BASE_MSR	0x800
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index f287092..a0d4865 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -348,7 +348,7 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 
 static void setup_APIC_eilvt(u8 lvt_off, u8 vector, u8 msg_type, u8 mask)
 {
-	unsigned long reg = (lvt_off << 4) + APIC_EILVT0;
+	unsigned long reg = (lvt_off << 4) + APIC_EILVTn(0);
 	unsigned int  v   = (mask << 16) | (msg_type << 8) | vector;
 
 	apic_write(reg, v);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 30da617..7823754 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1869,7 +1869,7 @@ __apicdebuginit(void) print_APIC_bitfield(int base)
 
 __apicdebuginit(void) print_local_APIC(void *dummy)
 {
-	unsigned int v, ver, maxlvt;
+	unsigned int i, v, ver, maxlvt;
 	u64 icr;
 
 	if (apic_verbosity == APIC_QUIET)
@@ -1957,6 +1957,18 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
 	printk(KERN_DEBUG "... APIC TMCCT: %08x\n", v);
 	v = apic_read(APIC_TDCR);
 	printk(KERN_DEBUG "... APIC TDCR: %08x\n", v);
+
+	if (boot_cpu_has(X86_FEATURE_EXTAPIC)) {
+		v = apic_read(APIC_EFEAT);
+		maxlvt = (v >> 16) & 0xff;
+		printk(KERN_DEBUG "... APIC EFEAT: %08x\n", v);
+		v = apic_read(APIC_ECTRL);
+		printk(KERN_DEBUG "... APIC ECTRL: %08x\n", v);
+		for (i = 0; i < maxlvt; i++) {
+			v = apic_read(APIC_EILVTn(i));
+			printk(KERN_DEBUG "... APIC EILVT%d: %08x\n", i, v);
+		}
+	}
 	printk("\n");
 }
 
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index 46e29ab..2fc4f6b 100644
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -588,8 +588,20 @@ static void print_apic(void *arg)
 	seq_printf(seq, " TMICT\t\t: %08x\n",  apic_read(APIC_TMICT));
 	seq_printf(seq, " TMCCT\t\t: %08x\n",  apic_read(APIC_TMCCT));
 	seq_printf(seq, " TDCR\t\t: %08x\n",  apic_read(APIC_TDCR));
-#endif /* CONFIG_X86_LOCAL_APIC */
+	if (boot_cpu_has(X86_FEATURE_EXTAPIC)) {
+		unsigned int i, v, maxeilvt;
+
+		v = apic_read(APIC_EFEAT);
+		maxeilvt = (v >> 16) & 0xff;
+		seq_printf(seq, " EFEAT\t\t: %08x\n", v);
+		seq_printf(seq, " ECTRL\t\t: %08x\n", apic_read(APIC_ECTRL));
 
+		for (i = 0; i < maxeilvt; i++) {
+			v = apic_read(APIC_EILVTn(i));
+			seq_printf(seq, " EILVT%d\t\t: %08x\n", i, v);
+		}
+	}
+#endif /* CONFIG_X86_LOCAL_APIC */
 	seq_printf(seq, "\n MSR\t:\n");
 }
 
-- 
1.6.2



