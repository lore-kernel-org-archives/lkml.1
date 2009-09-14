Return-Path: <linux-kernel-owner+w=401wt.eu-S933796AbZINURM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933796AbZINURM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933526AbZINUQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:16:58 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54093 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933566AbZINUIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:44 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 37/72] Blackfin: improve double fault debug handling
Date: Mon, 14 Sep 2009 16:07:41 -0400
Message-Id: <1252958896-25150-38-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Since the hardware only provides reporting for the last exception handled,
and the values are valid only when executing the exception handler, we
need to save the context for reporting at a later point.  While we do this
for one exception, it doesn't work properly when handling a second one as
the original exception is clobbered by the double fault.  So when double
fault debugging is enabled, create a dedicated shadow of these values and
save/restore out of there.  Now the crash report properly displays the
first exception as well as the second one.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/pda.h      |    6 ++++++
 arch/blackfin/kernel/asm-offsets.c   |    6 ++++++
 arch/blackfin/kernel/traps.c         |    8 ++++----
 arch/blackfin/mach-bf561/secondary.S |    8 ++++----
 arch/blackfin/mach-common/entry.S    |   22 +++++++++++++---------
 arch/blackfin/mach-common/head.S     |    8 ++++----
 6 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/arch/blackfin/include/asm/pda.h b/arch/blackfin/include/asm/pda.h
index 69b96b4..a6f9569 100644
--- a/arch/blackfin/include/asm/pda.h
+++ b/arch/blackfin/include/asm/pda.h
@@ -61,6 +61,12 @@ struct blackfin_pda {			/* Per-processor Data Area */
 	unsigned long retx;
 	unsigned long seqstat;
 	unsigned int __nmi_count;	/* number of times NMI asserted on this CPU */
+#ifdef CONFIG_DEBUG_DOUBLEFAULT
+	unsigned long dcplb_doublefault_addr;
+	unsigned long icplb_doublefault_addr;
+	unsigned long retx_doublefault;
+	unsigned long seqstat_doublefault;
+#endif
 };
 
 extern struct blackfin_pda cpu_pda[];
diff --git a/arch/blackfin/kernel/asm-offsets.c b/arch/blackfin/kernel/asm-offsets.c
index 8ad4f2c..f05d1b9 100644
--- a/arch/blackfin/kernel/asm-offsets.c
+++ b/arch/blackfin/kernel/asm-offsets.c
@@ -153,6 +153,12 @@ int main(void)
 	DEFINE(PDA_ICPLB, offsetof(struct blackfin_pda, icplb_fault_addr));
 	DEFINE(PDA_RETX, offsetof(struct blackfin_pda, retx));
 	DEFINE(PDA_SEQSTAT, offsetof(struct blackfin_pda, seqstat));
+#ifdef CONFIG_DEBUG_DOUBLEFAULT
+	DEFINE(PDA_DF_DCPLB, offsetof(struct blackfin_pda, dcplb_doublefault_addr));
+	DEFINE(PDA_DF_ICPLB, offsetof(struct blackfin_pda, icplb_doublefault_addr));
+	DEFINE(PDA_DF_SEQSTAT, offsetof(struct blackfin_pda, seqstat_doublefault));
+	DEFINE(PDA_DF_RETX, offsetof(struct blackfin_pda, retx_doublefault));
+#endif
 #ifdef CONFIG_SMP
 	/* Inter-core lock (in L2 SRAM) */
 	DEFINE(SIZEOF_CORELOCK, sizeof(struct corelock_slot));
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 644e35e..0904430 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -229,12 +229,12 @@ asmlinkage void double_fault_c(struct pt_regs *fp)
 	if (((long)fp->seqstat &  SEQSTAT_EXCAUSE) == VEC_UNCOV) {
 		unsigned int cpu = smp_processor_id();
 		char buf[150];
-		decode_address(buf, cpu_pda[cpu].retx);
+		decode_address(buf, cpu_pda[cpu].retx_doublefault);
 		printk(KERN_EMERG "While handling exception (EXCAUSE = 0x%x) at %s:\n",
-			(unsigned int)cpu_pda[cpu].seqstat & SEQSTAT_EXCAUSE, buf);
-		decode_address(buf, cpu_pda[cpu].dcplb_fault_addr);
+			(unsigned int)cpu_pda[cpu].seqstat_doublefault & SEQSTAT_EXCAUSE, buf);
+		decode_address(buf, cpu_pda[cpu].dcplb_doublefault_addr);
 		printk(KERN_NOTICE "   DCPLB_FAULT_ADDR: %s\n", buf);
-		decode_address(buf, cpu_pda[cpu].icplb_fault_addr);
+		decode_address(buf, cpu_pda[cpu].icplb_doublefault_addr);
 		printk(KERN_NOTICE "   ICPLB_FAULT_ADDR: %s\n", buf);
 
 		decode_address(buf, fp->retx);
diff --git a/arch/blackfin/mach-bf561/secondary.S b/arch/blackfin/mach-bf561/secondary.S
index 35280f0..097550f 100644
--- a/arch/blackfin/mach-bf561/secondary.S
+++ b/arch/blackfin/mach-bf561/secondary.S
@@ -126,22 +126,22 @@ ENTRY(_coreb_trampoline_start)
 	 * below
 	 */
 	GET_PDA(p0, r0);
-	r7 = [p0 + PDA_RETX];
+	r7 = [p0 + PDA_DF_RETX];
 	p1.l = _init_saved_retx_coreb;
 	p1.h = _init_saved_retx_coreb;
 	[p1] = r7;
 
-	r7 = [p0 + PDA_DCPLB];
+	r7 = [p0 + PDA_DF_DCPLB];
 	p1.l = _init_saved_dcplb_fault_addr_coreb;
 	p1.h = _init_saved_dcplb_fault_addr_coreb;
 	[p1] = r7;
 
-	r7 = [p0 + PDA_ICPLB];
+	r7 = [p0 + PDA_DF_ICPLB];
 	p1.l = _init_saved_icplb_fault_addr_coreb;
 	p1.h = _init_saved_icplb_fault_addr_coreb;
 	[p1] = r7;
 
-	r7 = [p0 + PDA_SEQSTAT];
+	r7 = [p0 + PDA_DF_SEQSTAT];
 	p1.l = _init_saved_seqstat_coreb;
 	p1.h = _init_saved_seqstat_coreb;
 	[p1] = r7;
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index cbc5b6d..4e8e3fe 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -326,8 +326,6 @@ ENTRY(_ex_trap_c)
 	[p4] = r7;
 	csync;
 
-#ifndef CONFIG_DEBUG_DOUBLEFAULT
-
 	/*
 	 * Save these registers, as they are only valid in exception context
 	 *  (where we are now - as soon as we defer to IRQ5, they can change)
@@ -347,7 +345,10 @@ ENTRY(_ex_trap_c)
 
 	r6 = retx;
 	[p5 + PDA_RETX] = r6;
-#endif
+
+	r6 = SEQSTAT;
+	[p5 + PDA_SEQSTAT] = r6;
+
 	/* Save the state of single stepping */
 	r6 = SYSCFG;
 	[p5 + PDA_SYSCFG] = r6;
@@ -444,6 +445,9 @@ ENTRY(_exception_to_level5)
 	r6 = [p5 + PDA_SYSCFG];
 	[sp + PT_SYSCFG] = r6;
 
+	r6 = [p5 + PDA_SEQSTAT]; /* Read back seqstat */
+	[sp + PT_SEQSTAT] = r6;
+
 	/* Restore the hardware error vector.  */
 	r7.h = _evt_ivhw;
 	r7.l = _evt_ivhw;
@@ -496,7 +500,7 @@ ENTRY(_trap) /* Exception: 4th entry into system event table(supervisor mode)*/
 	 */
 	EX_SCRATCH_REG = sp;
 	GET_PDA_SAFE(sp);
-	sp = [sp + PDA_EXSTACK]
+	sp = [sp + PDA_EXSTACK];
 	/* Try to deal with syscalls quickly.  */
 	[--sp] = ASTAT;
 	[--sp] = (R7:6,P5:4);
@@ -532,18 +536,18 @@ ENTRY(_trap) /* Exception: 4th entry into system event table(supervisor mode)*/
 	p4.l = lo(DCPLB_FAULT_ADDR);
 	p4.h = hi(DCPLB_FAULT_ADDR);
 	r7 = [p4];
-	[p5 + PDA_DCPLB] = r7;
+	[p5 + PDA_DF_DCPLB] = r7;
 
 	p4.l = lo(ICPLB_FAULT_ADDR);
 	p4.h = hi(ICPLB_FAULT_ADDR);
 	r7 = [p4];
-	[p5 + PDA_ICPLB] = r7;
+	[p5 + PDA_DF_ICPLB] = r7;
 
-	r6 = retx;
-	[p5 + PDA_RETX] = r6;
+	r7 = retx;
+	[p5 + PDA_DF_RETX] = r7;
 
 	r7 = SEQSTAT;		/* reason code is in bit 5:0 */
-	[p5 + PDA_SEQSTAT] = r7;
+	[p5 + PDA_DF_SEQSTAT] = r7;
 #else
 	r7 = SEQSTAT;           /* reason code is in bit 5:0 */
 #endif
diff --git a/arch/blackfin/mach-common/head.S b/arch/blackfin/mach-common/head.S
index 6691012..9c79dfe 100644
--- a/arch/blackfin/mach-common/head.S
+++ b/arch/blackfin/mach-common/head.S
@@ -124,22 +124,22 @@ ENTRY(__start)
 	 * below
 	 */
 	GET_PDA(p0, r0);
-	r6 = [p0 + PDA_RETX];
+	r6 = [p0 + PDA_DF_RETX];
 	p1.l = _init_saved_retx;
 	p1.h = _init_saved_retx;
 	[p1] = r6;
 
-	r6 = [p0 + PDA_DCPLB];
+	r6 = [p0 + PDA_DF_DCPLB];
 	p1.l = _init_saved_dcplb_fault_addr;
 	p1.h = _init_saved_dcplb_fault_addr;
 	[p1] = r6;
 
-	r6 = [p0 + PDA_ICPLB];
+	r6 = [p0 + PDA_DF_ICPLB];
 	p1.l = _init_saved_icplb_fault_addr;
 	p1.h = _init_saved_icplb_fault_addr;
 	[p1] = r6;
 
-	r6 = [p0 + PDA_SEQSTAT];
+	r6 = [p0 + PDA_DF_SEQSTAT];
 	p1.l = _init_saved_seqstat;
 	p1.h = _init_saved_seqstat;
 	[p1] = r6;
-- 
1.6.4.2

