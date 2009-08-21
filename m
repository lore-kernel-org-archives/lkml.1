Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbZHUGde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbZHUGde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 02:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbZHUGdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 02:33:33 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:34850 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbZHUGdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 02:33:33 -0400
X-SpamScore: 4
X-BigFish: VPS4(zzzz1202hzz5a6ciz32i203h43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KOPRJQ-03-6F4-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>
CC: kjwinchester@gmail.com, mikpe@it.uu.se, <linux-kernel@vger.kernel.org>,
       <x86@kernel.org>
Subject: [RESEND PATCH 1/2] x86, msr: Add an AMD wrmsr with exception handling
Date: Fri, 21 Aug 2009 08:33:18 +0200
Message-ID: <1250836399-3274-1-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 21 Aug 2009 06:33:22.0493 (UTC) FILETIME=[47ABDED0:01CA2229]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add native_write_msr_amd_safe() - we need this for a workaround.

( While at it, convert native_read_msr_amd_safe to using
  more robust named inline asm parameters as the rest of the
  functions. )

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: kjwinchester@gmail.com
Cc: mikpe@it.uu.se
Cc: brgerst@gmail.com
---
 arch/x86/include/asm/msr.h      |   32 ++++++++++++++++++++++++++++----
 arch/x86/include/asm/paravirt.h |   11 +++++++++--
 arch/x86/kernel/paravirt.c      |    1 +
 3 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 48ad9d2..3ea381b 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -76,14 +76,14 @@ static inline unsigned long long native_read_msr_amd_safe(unsigned int msr,
 {
 	DECLARE_ARGS(val, low, high);
 
-	asm volatile("2: rdmsr ; xor %0,%0\n"
+	asm volatile("2: rdmsr ; xor %[err],%[err]\n"
 		     "1:\n\t"
 		     ".section .fixup,\"ax\"\n\t"
-		     "3:  mov %3,%0 ; jmp 1b\n\t"
+		     "3:  mov %[fault],%[err] ; jmp 1b\n\t"
 		     ".previous\n\t"
 		     _ASM_EXTABLE(2b, 3b)
-		     : "=r" (*err), EAX_EDX_RET(val, low, high)
-		     : "c" (msr), "D" (0x9c5a203a), "i" (-EFAULT));
+		     : [err] "=r" (*err), EAX_EDX_RET(val, low, high)
+		     : "c" (msr), "D" (0x9c5a203a), [fault] "i" (-EFAULT));
 	return EAX_EDX_VAL(val, low, high);
 }
 
@@ -111,6 +111,25 @@ notrace static inline int native_write_msr_safe(unsigned int msr,
 	return err;
 }
 
+static inline unsigned long long native_write_msr_amd_safe(unsigned int msr,
+							   unsigned low,
+							   unsigned high)
+{
+	int err;
+	asm volatile("2: wrmsr ; xor %[err],%[err]\n"
+		     "1:\n\t"
+		     ".section .fixup,\"ax\"\n\t"
+		     "3:  mov %[fault],%[err] ; jmp 1b\n\t"
+		     ".previous\n\t"
+		     _ASM_EXTABLE(2b, 3b)
+		     : [err] "=a" (err)
+		     : "c" (msr), "0" (low), "d" (high), [fault] "i" (-EFAULT),
+		       "D" (0x9c5a203a)
+		     : "memory");
+	return err;
+
+}
+
 extern unsigned long long native_read_tsc(void);
 
 static __always_inline unsigned long long __native_read_tsc(void)
@@ -164,6 +183,11 @@ static inline int wrmsr_safe(unsigned msr, unsigned low, unsigned high)
 	return native_write_msr_safe(msr, low, high);
 }
 
+static inline int wrmsr_amd_safe(unsigned msr, unsigned low, unsigned high)
+{
+	return native_write_msr_amd_safe(msr, low, high);
+}
+
 /* rdmsr with exception handling */
 #define rdmsr_safe(msr, p1, p2)					\
 ({								\
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 4fb37c8..82143e5 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -169,6 +169,7 @@ struct pv_cpu_ops {
 	u64 (*read_msr_amd)(unsigned int msr, int *err);
 	u64 (*read_msr)(unsigned int msr, int *err);
 	int (*write_msr)(unsigned int msr, unsigned low, unsigned high);
+	u64 (*write_msr_amd)(unsigned int msr, unsigned low, unsigned high);
 
 	u64 (*read_tsc)(void);
 	u64 (*read_pmc)(int counter);
@@ -829,6 +830,11 @@ static inline int paravirt_write_msr(unsigned msr, unsigned low, unsigned high)
 	return PVOP_CALL3(int, pv_cpu_ops.write_msr, msr, low, high);
 }
 
+static inline int paravirt_write_msr_amd(unsigned msr, unsigned low, unsigned high)
+{
+	return PVOP_CALL3(u64, pv_cpu_ops.write_msr_amd, msr, low, high);
+}
+
 /* These should all do BUG_ON(_err), but our headers are too tangled. */
 #define rdmsr(msr, val1, val2)			\
 do {						\
@@ -849,8 +855,9 @@ do {						\
 	val = paravirt_read_msr(msr, &_err);	\
 } while (0)
 
-#define wrmsrl(msr, val)	wrmsr(msr, (u32)((u64)(val)), ((u64)(val))>>32)
-#define wrmsr_safe(msr, a, b)	paravirt_write_msr(msr, a, b)
+#define wrmsrl(msr, val)		wrmsr(msr, (u32)((u64)(val)), ((u64)(val))>>32)
+#define wrmsr_safe(msr, a, b)		paravirt_write_msr(msr, a, b)
+#define wrmsr_amd_safe(msr, a, b)	paravirt_write_msr_amd(msr, a, b)
 
 /* rdmsr with exception handling */
 #define rdmsr_safe(msr, a, b)			\
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 70ec9b9..9996e51 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -364,6 +364,7 @@ struct pv_cpu_ops pv_cpu_ops = {
 	.read_msr = native_read_msr_safe,
 	.read_msr_amd = native_read_msr_amd_safe,
 	.write_msr = native_write_msr_safe,
+	.write_msr_amd = native_write_msr_amd_safe,
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
 	.read_tscp = native_read_tscp,
-- 
1.6.3.3


