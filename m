Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbYDNKEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbYDNKEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 06:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYDNKEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 06:04:13 -0400
Received: from ozlabs.org ([203.10.76.45]:36515 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbYDNKEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:04:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18435.11286.201115.396713@cargo.ozlabs.ibm.com>
Date: Mon, 14 Apr 2008 20:04:06 +1000
From: Paul Mackerras <paulus@samba.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, nacc@us.ibm.com
Subject: Re: [BUG] 2.6.25-rc2-git4 - Regression Kernel oops  while running
 kernbench and tbench on powerpc
In-Reply-To: <47FC5227.3030501@linux.vnet.ibm.com>
References: <47BC40BC.3040405@linux.vnet.ibm.com>
	<18427.11023.8067.795279@cargo.ozlabs.ibm.com>
	<47FB5C5A.5020104@linux.vnet.ibm.com>
	<18427.65299.403151.344959@cargo.ozlabs.ibm.com>
	<47FC5227.3030501@linux.vnet.ibm.com>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal writes:

> The SHA1 ID of the kernel is 0e81a8ae37687845f7cdfa2adce14ea6a5f1dd34 (2.6.25-rc8) 
> and the source seems to have the patch 44387e9ff25267c78a99229aca55ed750e9174c7.
> 
> The kernel was patched only the patch you gave me (http://lkml.org/lkml/2008/4/8/42). 

Please try again with both that patch and the one below.  Once again
it won't fix the bug but will give us more information.  When the oops
occurs, the kernel will print a lot of debug information that should
help locate the problem.

Paul.

diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index e932b43..f16db50 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -144,6 +144,9 @@ int main(void)
 	DEFINE(PACA_SLBSHADOWPTR, offsetof(struct paca_struct, slb_shadow_ptr));
 	DEFINE(PACA_DATA_OFFSET, offsetof(struct paca_struct, data_offset));
 	DEFINE(PACA_TRAP_SAVE, offsetof(struct paca_struct, trap_save));
+	DEFINE(PACASLBLOG, offsetof(struct paca_struct, slblog));
+	DEFINE(PACASLBLOGIX, offsetof(struct paca_struct, slblog_ix));
+	DEFINE(PACALASTSLB, offsetof(struct paca_struct, last_slb));
 
 	DEFINE(SLBSHADOW_STACKVSID,
 	       offsetof(struct slb_shadow, save_area[SLB_NUM_BOLTED - 1].vsid));
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 148a354..663df17 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -419,6 +419,18 @@ END_FTR_SECTION_IFSET(CPU_FTR_1T_SEGMENT)
 	slbmte	r7,r0
 	isync
 
+	ld	r4,PACASLBLOGIX(r13)
+	addi	r4,r4,1
+	clrldi	r4,r4,64-6
+	std	r4,PACASLBLOGIX(r13)
+	add	r4,r4,r13
+	addi	r4,r4,PACASLBLOG
+	li	r5,4
+	std	r5,0(r4)
+	mftb	r5
+	std	r5,8(r4)
+	std	r6,16(r4)
+	std	r0,24(r4)
 2:
 	clrrdi	r7,r8,THREAD_SHIFT	/* base of new stack */
 	/* Note: this uses SWITCH_FRAME_SIZE rather than INT_FRAME_SIZE
@@ -533,6 +545,17 @@ END_FW_FTR_SECTION_IFSET(FW_FEATURE_ISERIES)
 
 	stdcx.	r0,0,r1		/* to clear the reservation */
 
+	li	r4,0
+	slbmfee	r2,r4
+	std	r2,PACALASTSLB(r13)
+	slbmfev	r2,r4
+	std	r2,PACALASTSLB+8(r13)
+	li	r4,1
+	slbmfee	r2,r4
+	std	r2,PACALASTSLB+16(r13)
+	slbmfev	r2,r4
+	std	r2,PACALASTSLB+24(r13)
+
 	/*
 	 * Clear RI before restoring r13.  If we are returning to
 	 * userspace and we take an exception after restoring r13,
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 4b5b7ff..c918f33 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -1141,6 +1141,40 @@ void SPEFloatingPointException(struct pt_regs *regs)
 }
 #endif
 
+static void dump_unrecov_slb(void)
+{
+#ifdef CONFIG_PPC64
+	long entry, rstart;
+	unsigned long esid, vsid;
+
+	printk(KERN_EMERG "SLB contents now:\n");
+	for (entry = 0; entry < 64; ++entry) {
+		asm volatile("slbmfee  %0,%1" : "=r" (esid) : "r" (entry));
+		if (esid == 0)
+			/* valid bit is clear along with everything else */
+			continue;
+		asm volatile("slbmfev  %0,%1" : "=r" (vsid) : "r" (entry));
+		printk(KERN_EMERG "%d: %.16lx %.16lx\n", entry, esid, vsid);
+	}
+
+	printk(KERN_EMERG "SLB 0-1 at last exception exit:\n");
+	printk(KERN_EMERG "0: %.16lx %.16lx\n", get_paca()->last_slb[0][0],
+	       get_paca()->last_slb[0][1]);
+	printk(KERN_EMERG "1: %.16lx %.16lx\n", get_paca()->last_slb[1][0],
+	       get_paca()->last_slb[1][1]);
+	printk(KERN_EMERG "SLB update log:\n");
+	rstart = entry = get_paca()->slblog_ix;
+	do {
+		printk(KERN_EMERG "%d: %lx %lx %.16lx %.16lx\n", entry,
+		       get_paca()->slblog[entry][0],
+		       get_paca()->slblog[entry][1],
+		       get_paca()->slblog[entry][2],
+		       get_paca()->slblog[entry][3]);
+		entry = (entry + 1) % 63;
+	} while (entry != rstart);
+#endif
+}
+
 /*
  * We enter here if we get an unrecoverable exception, that is, one
  * that happened at a point where the RI (recoverable interrupt) bit
@@ -1151,6 +1185,8 @@ void unrecoverable_exception(struct pt_regs *regs)
 {
 	printk(KERN_EMERG "Unrecoverable exception %lx at %lx\n",
 	       regs->trap, regs->nip);
+	if (regs->trap == 0x4100)
+		dump_unrecov_slb();
 	die("Unrecoverable exception", regs, SIGABRT);
 }
 
diff --git a/arch/powerpc/mm/slb.c b/arch/powerpc/mm/slb.c
index 906daed..235edf7 100644
--- a/arch/powerpc/mm/slb.c
+++ b/arch/powerpc/mm/slb.c
@@ -105,6 +105,7 @@ void slb_flush_and_rebolt(void)
 	 * appropriately too. */
 	unsigned long linear_llp, vmalloc_llp, lflags, vflags;
 	unsigned long ksp_esid_data, ksp_vsid_data;
+	long logix;
 
 	WARN_ON(!irqs_disabled());
 
@@ -144,6 +145,13 @@ void slb_flush_and_rebolt(void)
 		        "r"(ksp_vsid_data),
 		        "r"(ksp_esid_data)
 		     : "memory");
+	logix = get_paca()->slblog_ix;
+	logix = (logix + 1) & 63;
+	get_paca()->slblog_ix = logix;
+	get_paca()->slblog[logix][0] = 3;
+	get_paca()->slblog[logix][1] = mftb();
+	get_paca()->slblog[logix][2] = ksp_esid_data;
+	get_paca()->slblog[logix][3] = ksp_vsid_data;
 }
 
 void slb_vmalloc_update(void)
@@ -192,6 +200,7 @@ void switch_slb(struct task_struct *tsk, struct mm_struct *mm)
 	unsigned long pc = KSTK_EIP(tsk);
 	unsigned long stack = KSTK_ESP(tsk);
 	unsigned long unmapped_base;
+	long logix;
 
 	if (!cpu_has_feature(CPU_FTR_NO_SLBIE_B) &&
 	    offset <= SLB_CACHE_ENTRIES) {
@@ -204,6 +213,14 @@ void switch_slb(struct task_struct *tsk, struct mm_struct *mm)
 				<< SLBIE_SSIZE_SHIFT;
 			slbie_data |= SLBIE_C; /* C set for user addresses */
 			asm volatile("slbie %0" : : "r" (slbie_data));
+
+			logix = get_paca()->slblog_ix;
+			logix = (logix + 1) & 63;
+			get_paca()->slblog_ix = logix;
+			get_paca()->slblog[logix][0] = 2;
+			get_paca()->slblog[logix][1] = mftb();
+			get_paca()->slblog[logix][2] = slbie_data;
+			get_paca()->slblog[logix][3] = 0;
 		}
 		asm volatile("isync" : : : "memory");
 	} else {
diff --git a/arch/powerpc/mm/slb_low.S b/arch/powerpc/mm/slb_low.S
index 657f6b3..8c7ce20 100644
--- a/arch/powerpc/mm/slb_low.S
+++ b/arch/powerpc/mm/slb_low.S
@@ -249,6 +249,20 @@ _GLOBAL(slb_compare_rr_to_size)
 	 */
 	slbmte	r11,r10
 
+	ld	r3,PACASLBLOGIX(r13)
+	addi	r3,r3,1
+	clrldi	r3,r3,64-6
+	std	r3,PACASLBLOGIX(r13)
+	sldi	r3,r3,5
+	add	r3,r3,r13
+	addi	r3,r3,PACASLBLOG
+	li	r9,1
+	std	r9,0(r3)
+	mftb	r9
+	std	r9,8(r3)
+	std	r11,16(r3)
+	std	r10,24(r3)
+
 	/* we're done for kernel addresses */
 	crclr	4*cr0+eq		/* set result to "success" */
 	bgelr	cr7
diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platforms/pseries/ras.c
index a1ab25c..959ef26 100644
--- a/arch/powerpc/platforms/pseries/ras.c
+++ b/arch/powerpc/platforms/pseries/ras.c
@@ -325,6 +325,8 @@ static int recover_mce(struct pt_regs *regs, struct rtas_error_log * err)
 
 	if (err->disposition == RTAS_DISP_FULLY_RECOVERED) {
 		/* Platform corrected itself */
+		printk(KERN_ERR "FWNMI: platform corrected error %.16lx\n",
+		       *(unsigned long *)err);
 		nonfatal = 1;
 	} else if ((regs->msr & MSR_RI) &&
 		   user_mode(regs) &&
diff --git a/include/asm-powerpc/paca.h b/include/asm-powerpc/paca.h
index 748b35a..6280b82 100644
--- a/include/asm-powerpc/paca.h
+++ b/include/asm-powerpc/paca.h
@@ -115,6 +115,11 @@ struct paca_struct {
 	u64 system_time;		/* accumulated system TB ticks */
 	u64 startpurr;			/* PURR/TB value snapshot */
 	u64 startspurr;			/* SPURR value snapshot */
+
+	/* SLB update log */
+	long slblog_ix;
+	u64 slblog[64][4];
+	u64 last_slb[2][2];
 };
 
 extern struct paca_struct paca[];
