Return-Path: <linux-kernel-owner+w=401wt.eu-S1751682AbZHaHu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbZHaHu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 03:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbZHaHuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 03:50:25 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:52659 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbZHaHuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 03:50:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VJKnV70SiuSurApDMpbqEvhz9RI5MarDE/nTjHEYrzQllDoKv9FB1A+zCnEfgW+A1x
         ih9hftLdgssanVZB5wXA+Xkm7cYSIuMF1HOwFzGTNll36ybUQRCCqJXVUzxLkRTzwPNJ
         x/McUtywCnEAw0sJC18Wh58SVsqxPCSvfS2xs=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <hpa@zytor.com>
Cc: <mingo@redhat.com>, linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: [PATCH 2/3] x86, msr: rewrite AMD rd/wrmsr variants
Date: Mon, 31 Aug 2009 09:50:10 +0200
Message-Id: <1251705011-18636-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1251705011-18636-1-git-send-email-petkovbb@gmail.com>
References: <1251705011-18636-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <20090831073429.GA26596@liondog.tnic>
References: <20090831073429.GA26596@liondog.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch them to native_{rd,wr}msr_safe_regs and remove
pv_cpu_ops.read_msr_amd.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 arch/x86/include/asm/msr.h      |   38 +++++++++++++++++++++-----------------
 arch/x86/include/asm/paravirt.h |   26 ++++++++++++++++++++------
 arch/x86/kernel/paravirt.c      |    1 -
 3 files changed, 41 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 184d4a1..09c5ca7 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -71,22 +71,6 @@ static inline unsigned long long native_read_msr_safe(unsigned int msr,
 	return EAX_EDX_VAL(val, low, high);
 }
 
-static inline unsigned long long native_read_msr_amd_safe(unsigned int msr,
-						      int *err)
-{
-	DECLARE_ARGS(val, low, high);
-
-	asm volatile("2: rdmsr ; xor %0,%0\n"
-		     "1:\n\t"
-		     ".section .fixup,\"ax\"\n\t"
-		     "3:  mov %3,%0 ; jmp 1b\n\t"
-		     ".previous\n\t"
-		     _ASM_EXTABLE(2b, 3b)
-		     : "=r" (*err), EAX_EDX_RET(val, low, high)
-		     : "c" (msr), "D" (0x9c5a203a), "i" (-EFAULT));
-	return EAX_EDX_VAL(val, low, high);
-}
-
 static inline void native_write_msr(unsigned int msr,
 				    unsigned low, unsigned high)
 {
@@ -184,14 +168,34 @@ static inline int rdmsrl_safe(unsigned msr, unsigned long long *p)
 	*p = native_read_msr_safe(msr, &err);
 	return err;
 }
+
 static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
 {
+	u32 gprs[8] = { 0 };
 	int err;
 
-	*p = native_read_msr_amd_safe(msr, &err);
+	gprs[1] = msr;
+	gprs[7] = 0x9c5a203a;
+
+	err = native_rdmsr_safe_regs(gprs);
+
+	*p = gprs[0] | ((u64)gprs[2] << 32);
+
 	return err;
 }
 
+static inline int wrmsrl_amd_safe(unsigned msr, unsigned long long val)
+{
+	u32 gprs[8] = { 0 };
+
+	gprs[0] = (u32)val;
+	gprs[1] = msr;
+	gprs[2] = val >> 32;
+	gprs[7] = 0x9c5a203a;
+
+	return native_wrmsr_safe_regs(gprs);
+}
+
 static inline int rdmsr_safe_regs(u32 *regs)
 {
 	return native_rdmsr_safe_regs(regs);
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 1705944..1157493 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -166,7 +166,6 @@ struct pv_cpu_ops {
 
 	/* MSR, PMC and TSR operations.
 	   err = 0/-EFAULT.  wrmsr returns 0/-EFAULT. */
-	u64 (*read_msr_amd)(unsigned int msr, int *err);
 	u64 (*read_msr)(unsigned int msr, int *err);
 	int (*rdmsr_regs)(u32 *regs);
 	int (*write_msr)(unsigned int msr, unsigned low, unsigned high);
@@ -828,10 +827,6 @@ static inline int paravirt_rdmsr_regs(u32 *regs)
 	return PVOP_CALL1(int, pv_cpu_ops.rdmsr_regs, regs);
 }
 
-static inline u64 paravirt_read_msr_amd(unsigned msr, int *err)
-{
-	return PVOP_CALL2(u64, pv_cpu_ops.read_msr_amd, msr, err);
-}
 static inline int paravirt_write_msr(unsigned msr, unsigned low, unsigned high)
 {
 	return PVOP_CALL3(int, pv_cpu_ops.write_msr, msr, low, high);
@@ -887,12 +882,31 @@ static inline int rdmsrl_safe(unsigned msr, unsigned long long *p)
 }
 static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
 {
+	u32 gprs[8] = { 0 };
 	int err;
 
-	*p = paravirt_read_msr_amd(msr, &err);
+	gprs[1] = msr;
+	gprs[7] = 0x9c5a203a;
+
+	err = paravirt_rdmsr_regs(gprs);
+
+	*p = gprs[0] | ((u64)gprs[2] << 32);
+
 	return err;
 }
 
+static inline int wrmsrl_amd_safe(unsigned msr, unsigned long long val)
+{
+	u32 gprs[8] = { 0 };
+
+	gprs[0] = (u32)val;
+	gprs[1] = msr;
+	gprs[2] = val >> 32;
+	gprs[7] = 0x9c5a203a;
+
+	return paravirt_wrmsr_regs(gprs);
+}
+
 static inline u64 paravirt_read_tsc(void)
 {
 	return PVOP_CALL0(u64, pv_cpu_ops.read_tsc);
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 67594af..f5b0b4a 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -363,7 +363,6 @@ struct pv_cpu_ops pv_cpu_ops = {
 	.wbinvd = native_wbinvd,
 	.read_msr = native_read_msr_safe,
 	.rdmsr_regs = native_rdmsr_safe_regs,
-	.read_msr_amd = native_read_msr_amd_safe,
 	.write_msr = native_write_msr_safe,
 	.wrmsr_regs = native_wrmsr_safe_regs,
 	.read_tsc = native_read_tsc,
-- 
1.6.3.3

