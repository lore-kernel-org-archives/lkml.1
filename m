Return-Path: <linux-kernel-owner+w=401wt.eu-S1752150AbZHaXhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbZHaXhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 19:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbZHaXhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 19:37:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:57059 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbZHaXho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 19:37:44 -0400
Date: Mon, 31 Aug 2009 23:37:27 GMT
From: tip-bot for Borislav Petkov <petkovbb@googlemail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       petkovbb@googlemail.com, tglx@linutronix.de, petkovbb@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       petkovbb@googlemail.com, tglx@linutronix.de, petkovbb@gmail.com
In-Reply-To: <1251705011-18636-2-git-send-email-petkovbb@gmail.com>
References: <1251705011-18636-2-git-send-email-petkovbb@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, msr: Rewrite AMD rd/wrmsr variants
Message-ID: <tip-177fed1ee8d727c39601ce9fc2299b4cb25a718e@git.kernel.org>
Git-Commit-ID: 177fed1ee8d727c39601ce9fc2299b4cb25a718e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 31 Aug 2009 23:37:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  177fed1ee8d727c39601ce9fc2299b4cb25a718e
Gitweb:     http://git.kernel.org/tip/177fed1ee8d727c39601ce9fc2299b4cb25a718e
Author:     Borislav Petkov <petkovbb@googlemail.com>
AuthorDate: Mon, 31 Aug 2009 09:50:10 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 31 Aug 2009 15:14:28 -0700

x86, msr: Rewrite AMD rd/wrmsr variants

Switch them to native_{rd,wr}msr_safe_regs and remove
pv_cpu_ops.read_msr_amd.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
LKML-Reference: <1251705011-18636-2-git-send-email-petkovbb@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


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
