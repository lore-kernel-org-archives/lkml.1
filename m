Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbZINUIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbZINUIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757028AbZINUIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:19 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:53987 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757002AbZINUIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:17 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 04/72] Blackfin: make EVT3->EVT5 lowering more robust wrt IPEND[4]
Date: Mon, 14 Sep 2009 16:07:08 -0400
Message-Id: <1252958896-25150-5-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

We handle many exceptions at EVT5 (hardware error level) so that we can
catch exceptions in our exception handling code.  Today - if the global
interrupt enable bit (IPEND[4]) is set (interrupts disabled) our trap
handling code goes into a infinite loop, since we need interrupts to be
on to defer things to EVT5.

Normal kernel code should not trigger this for any reason as IPEND[4] gets
cleared early (when doing an interrupt context save) and the kernel stack
there should be sane (or something much worse is happening in the system).
But there have been a few times where this has happened, so this change
makes sure we dump a proper crash message even when things have gone south.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/pda.h    |    1 +
 arch/blackfin/kernel/asm-offsets.c |    1 +
 arch/blackfin/kernel/traps.c       |   19 ++++----
 arch/blackfin/mach-common/entry.S  |   86 ++++++++++++++++++++++-------------
 4 files changed, 66 insertions(+), 41 deletions(-)

diff --git a/arch/blackfin/include/asm/pda.h b/arch/blackfin/include/asm/pda.h
index b42555c..69b96b4 100644
--- a/arch/blackfin/include/asm/pda.h
+++ b/arch/blackfin/include/asm/pda.h
@@ -50,6 +50,7 @@ struct blackfin_pda {			/* Per-processor Data Area */
 	unsigned long ex_optr;
 	unsigned long ex_buf[4];
 	unsigned long ex_imask;		/* Saved imask from exception */
+	unsigned long ex_ipend;		/* Saved IPEND from exception */
 	unsigned long *ex_stack;	/* Exception stack space */
 
 #ifdef ANOMALY_05000261
diff --git a/arch/blackfin/kernel/asm-offsets.c b/arch/blackfin/kernel/asm-offsets.c
index b5df945..8ad4f2c 100644
--- a/arch/blackfin/kernel/asm-offsets.c
+++ b/arch/blackfin/kernel/asm-offsets.c
@@ -145,6 +145,7 @@ int main(void)
 	DEFINE(PDA_EXBUF, offsetof(struct blackfin_pda, ex_buf));
 	DEFINE(PDA_EXIMASK, offsetof(struct blackfin_pda, ex_imask));
 	DEFINE(PDA_EXSTACK, offsetof(struct blackfin_pda, ex_stack));
+	DEFINE(PDA_EXIPEND, offsetof(struct blackfin_pda, ex_ipend));
 #ifdef ANOMALY_05000261
 	DEFINE(PDA_LFRETX, offsetof(struct blackfin_pda, last_cplb_fault_retx));
 #endif
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index bf2b2d1..fccf741 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -267,11 +267,6 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	 * double faults if the stack has become corrupt
 	 */
 
-#ifndef CONFIG_KGDB
-	/* IPEND is skipped if KGDB isn't enabled (see entry code) */
-	fp->ipend = bfin_read_IPEND();
-#endif
-
 	/* trap_c() will be called for exceptions. During exceptions
 	 * processing, the pc value should be set with retx value.
 	 * With this change we can cleanup some code in signal.c- TODO
@@ -1116,10 +1111,16 @@ void show_regs(struct pt_regs *fp)
 
 	verbose_printk(KERN_NOTICE "%s", linux_banner);
 
-	verbose_printk(KERN_NOTICE "\nSEQUENCER STATUS:\t\t%s\n",
-		       print_tainted());
-	verbose_printk(KERN_NOTICE " SEQSTAT: %08lx  IPEND: %04lx  SYSCFG: %04lx\n",
-		       (long)fp->seqstat, fp->ipend, fp->syscfg);
+	verbose_printk(KERN_NOTICE "\nSEQUENCER STATUS:\t\t%s\n", print_tainted());
+	verbose_printk(KERN_NOTICE " SEQSTAT: %08lx  IPEND: %04lx  IMASK: %04lx  SYSCFG: %04lx\n",
+		(long)fp->seqstat, fp->ipend, cpu_pda[smp_processor_id()].ex_imask, fp->syscfg);
+	if (fp->ipend & EVT_IRPTEN)
+		verbose_printk(KERN_NOTICE "  Global Interrupts Disabled (IPEND[4])\n");
+	if (!(cpu_pda[smp_processor_id()].ex_imask & (EVT_IVG13 | EVT_IVG12 | EVT_IVG11 |
+			EVT_IVG10 | EVT_IVG9 | EVT_IVG8 | EVT_IVG7 | EVT_IVTMR)))
+		verbose_printk(KERN_NOTICE "  Peripheral interrupts masked off\n");
+	if (!(cpu_pda[smp_processor_id()].ex_imask & (EVT_IVG15 | EVT_IVG14)))
+		verbose_printk(KERN_NOTICE "  Kernel interrupts masked off\n");
 	if ((fp->seqstat & SEQSTAT_EXCAUSE) == VEC_HWERR) {
 		verbose_printk(KERN_NOTICE "  HWERRCAUSE: 0x%lx\n",
 			(fp->seqstat & SEQSTAT_HWERRCAUSE) >> 14);
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index fb1795d..4c07fcb 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -301,25 +301,31 @@ ENTRY(_ex_replaceable)
 	nop;
 
 ENTRY(_ex_trap_c)
+	/* The only thing that has been saved in this context is
+	 * (R7:6,P5:4), ASTAT & SP - don't use anything else
+	 */
+
+	GET_PDA(p5, r6);
+
 	/* Make sure we are not in a double fault */
 	p4.l = lo(IPEND);
 	p4.h = hi(IPEND);
 	r7 = [p4];
 	CC = BITTST (r7, 5);
 	if CC jump _double_fault;
+	[p5 + PDA_EXIPEND] = r7;
 
 	/* Call C code (trap_c) to handle the exception, which most
 	 * likely involves sending a signal to the current process.
 	 * To avoid double faults, lower our priority to IRQ5 first.
 	 */
-	P5.h = _exception_to_level5;
-	P5.l = _exception_to_level5;
+	r7.h = _exception_to_level5;
+	r7.l = _exception_to_level5;
 	p4.l = lo(EVT5);
 	p4.h = hi(EVT5);
-	[p4] = p5;
+	[p4] = r7;
 	csync;
 
-	GET_PDA(p5, r6);
 #ifndef CONFIG_DEBUG_DOUBLEFAULT
 
 	/*
@@ -349,8 +355,7 @@ ENTRY(_ex_trap_c)
 	BITCLR(r6, SYSCFG_SSSTEP_P);
 	SYSCFG = r6;
 
-	/* Disable all interrupts, but make sure level 5 is enabled so
-	 * we can switch to that level.  Save the old mask.  */
+	/* Save the current IMASK, since we change in order to jump to level 5 */
 	cli r6;
 	[p5 + PDA_EXIMASK] = r6;
 
@@ -358,9 +363,21 @@ ENTRY(_ex_trap_c)
 	p4.h = hi(SAFE_USER_INSTRUCTION);
 	retx = p4;
 
+	/* Disable all interrupts, but make sure level 5 is enabled so
+	 * we can switch to that level.
+	 */
 	r6 = 0x3f;
 	sti r6;
 
+	/* In case interrupts are disabled IPEND[4] (global interrupt disable bit)
+	 * clear it (re-enabling interrupts again) by the special sequence of pushing
+	 * RETI onto the stack.  This way we can lower ourselves to IVG5 even if the
+	 * exception was taken after the interrupt handler was called but before it
+	 * got a chance to enable global interrupts itself.
+	 */
+	[--sp] = reti;
+	sp += 4;
+
 	raise 5;
 	jump.s _bfin_return_from_exception;
 ENDPROC(_ex_trap_c)
@@ -420,47 +437,52 @@ ENDPROC(_double_fault)
 ENTRY(_exception_to_level5)
 	SAVE_ALL_SYS
 
-	GET_PDA(p4, r7);        /* Fetch current PDA */
-	r6 = [p4 + PDA_RETX];
+	GET_PDA(p5, r7);        /* Fetch current PDA */
+	r6 = [p5 + PDA_RETX];
 	[sp + PT_PC] = r6;
 
-	r6 = [p4 + PDA_SYSCFG];
+	r6 = [p5 + PDA_SYSCFG];
 	[sp + PT_SYSCFG] = r6;
 
-	/* Restore interrupt mask.  We haven't pushed RETI, so this
-	 * doesn't enable interrupts until we return from this handler.  */
-	r6 = [p4 + PDA_EXIMASK];
-	sti r6;
-
 	/* Restore the hardware error vector.  */
-	P5.h = _evt_ivhw;
-	P5.l = _evt_ivhw;
+	r7.h = _evt_ivhw;
+	r7.l = _evt_ivhw;
 	p4.l = lo(EVT5);
 	p4.h = hi(EVT5);
-	[p4] = p5;
+	[p4] = r7;
 	csync;
 
-	p2.l = lo(IPEND);
-	p2.h = hi(IPEND);
-	csync;
-	r0 = [p2];              /* Read current IPEND */
-	[sp + PT_IPEND] = r0;   /* Store IPEND */
+#ifdef CONFIG_DEBUG_DOUBLEFAULT
+	/* Now that we have the hardware error vector programmed properly
+	 * we can re-enable interrupts (IPEND[4]), so if the _trap_c causes
+	 * another hardware error, we can catch it (self-nesting).
+	 */
+	[--sp] = reti;
+	sp += 4;
+#endif
+
+	r7 = [p5 + PDA_EXIPEND]	/* Read the IPEND from the Exception state */
+	[sp + PT_IPEND] = r7;   /* Store IPEND onto the stack */
 
 	r0 = sp; 	/* stack frame pt_regs pointer argument ==> r0 */
 	SP += -12;
 	call _trap_c;
 	SP += 12;
 
-#ifdef CONFIG_DEBUG_DOUBLEFAULT
-	/* Grab ILAT */
-	p2.l = lo(ILAT);
-	p2.h = hi(ILAT);
-	r0 = [p2];
-	r1 = 0x20;  /* Did I just cause anther HW error? */
-	r0 = r0 & r1;
-	CC = R0 == R1;
-	if CC JUMP _double_fault;
-#endif
+	/* If interrupts were off during the exception (IPEND[4] = 1), turn them off
+	 * before we return.
+	 */
+	CC = BITTST(r7, EVT_IRPTEN_P)
+	if !CC jump 1f;
+	/* this will load a random value into the reti register - but that is OK,
+	 * since we do restore it to the correct value in the 'RESTORE_ALL_SYS' macro
+	 */
+	sp += -4;
+	reti = [sp++];
+1:
+	/* restore the interrupt mask (IMASK) */
+	r6 = [p5 + PDA_EXIMASK];
+	sti r6;
 
 	call _ret_from_exception;
 	RESTORE_ALL_SYS
-- 
1.6.4.2

