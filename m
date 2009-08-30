Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbZH3Luu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbZH3Luu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 07:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbZH3Luk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 07:50:40 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:45725 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbZH3Lue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 07:50:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EMaElEWuID9aWuI5fU63k3aG4uSamaSyTgwI1uUYtk7vAr6puWIshZaVJcEqMEhJNg
         jLGuKdEUuySO8vakNSgyb+P81xRisu2AFyCImcEx6eU5++GrZJRs+NA2Yx+wJtC+dRb+
         As3Izw628DWRzG9ZjIsG2aV8dkDqGOoCHxVBU=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <hpa@zytor.com>
Cc: <mingo@redhat.com>, linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: [PATCH 2/3] x86, msr: rewrite AMD rd/wrmsr variants
Date: Sun, 30 Aug 2009 13:50:30 +0200
Message-Id: <1251633031-2244-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1251633031-2244-1-git-send-email-petkovbb@gmail.com>
References: <1251633031-2244-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <20090830114329.GA9038@liondog.tnic>
References: <20090830114329.GA9038@liondog.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch them to native_{rd,wr}msr_safe_regs and remove
pv_cpu_ops.read_msr_amd.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 arch/x86/include/asm/msr.h      |   45 +++++++++++++++++++++++---------------
 arch/x86/include/asm/paravirt.h |   30 ++++++++++++++++++++-----
 arch/x86/kernel/paravirt.c      |    1 -
 3 files changed, 51 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 184d4a1..0b8697f 100644
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
@@ -184,14 +168,39 @@ static inline int rdmsrl_safe(unsigned msr, unsigned long long *p)
 	*p = native_read_msr_safe(msr, &err);
 	return err;
 }
+
+#define memset(d,c,l) __builtin_memset(d,c,l)
 static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
 {
-	int err;
+	u32 gprs[8];
+	int err, i;
+
+	memset(gprs, 0, sizeof(u32) * 8);
+
+	gprs[1] = msr;
+	gprs[7] = 0x9c5a203a;
+
+	err = native_rdmsr_safe_regs(gprs);
+
+	*p = gprs[0] | ((u64)gprs[2] << 32);
 
-	*p = native_read_msr_amd_safe(msr, &err);
 	return err;
 }
 
+static inline int wrmsr_amd_safe(unsigned msr, unsigned low, unsigned high)
+{
+	u32 gprs[8];
+
+	memset(gprs, 0, sizeof(u32) * 8);
+
+	gprs[0] = low;
+	gprs[1] = msr;
+	gprs[2] = high;
+	gprs[7] = 0x9c5a203a;
+
+	return native_wrmsr_safe_regs(gprs);
+}
+
 static inline int rdmsr_safe_regs(u32 *regs)
 {
 	return native_rdmsr_safe_regs(regs);
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 1705944..8933b1d 100644
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
@@ -887,12 +882,35 @@ static inline int rdmsrl_safe(unsigned msr, unsigned long long *p)
 }
 static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
 {
+	u32 gprs[8];
 	int err;
 
-	*p = paravirt_read_msr_amd(msr, &err);
+	memset(gprs, 0, sizeof(u32) * 8);
+
+	gprs[1] = msr;
+	gprs[7] = 0x9c5a203a;
+
+	err = paravirt_rdmsr_regs(gprs);
+
+	*p = gprs[0] | ((u64)gprs[2] << 32);
+
 	return err;
 }
 
+static inline int wrmsr_amd_safe(unsigned msr, unsigned low, unsigned high)
+{
+	u32 gprs[8];
+
+	memset(gprs, 0, sizeof(u32) * 8);
+
+	gprs[0] = low;
+	gprs[1] = msr;
+	gprs[2] = high;
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

