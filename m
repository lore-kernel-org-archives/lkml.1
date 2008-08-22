Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbYHVIeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbYHVIeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 04:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbYHVId4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 04:33:56 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:55512 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbYHVIdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 04:33:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LCzbhRefeIW9kqBe80y6OWsye4B+u0AwIzJcXK8WdMlIl97UgSs734IwPAoSeP/sDi
         MDVADku0aXzXFcxaKjJ6i7+rLBji2by0n4HZWI7ty039P0uGYF9RKPp4F6e1Z7S3K9Mz
         YkmvC97+JUf8W+l2ryS4Av5P7S9ztG0kPcMI0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86_64: printout msr -v2
Date: Fri, 22 Aug 2008 01:32:50 -0700
Message-Id: <1219393970-29199-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commandline show_msr=1 for bsp, show_msr=32 for all 32 cpus.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index 35d11ef..43f1aa5 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -430,6 +430,49 @@ static __init int setup_noclflush(char *arg)
 }
 __setup("noclflush", setup_noclflush);
 
+struct msr_range {
+	unsigned min;
+	unsigned max;
+};
+
+static struct msr_range msr_range_array[] __cpuinitdata = {
+	{ 0x00000000, 0x00000418},
+	{ 0xc0000000, 0xc000040b},
+	{ 0xc0010000, 0xc0010142},
+	{ 0xc0011000, 0xc001103b},
+};
+
+static void __cpuinit print_cpu_msr(void)
+{
+	unsigned index;
+	u64 val;
+	int i;
+	unsigned index_min, index_max;
+
+	for (i = 0; i < ARRAY_SIZE(msr_range_array); i++) {
+		index_min = msr_range_array[i].min;
+		index_max = msr_range_array[i].max;
+		for (index = index_min; index < index_max; index++) {
+			if (rdmsrl_amd_safe(index, &val))
+				continue;
+			printk(KERN_INFO " MSR%08x: %016llx\n", index, val);
+		}
+	}
+}
+
+static int show_msr __cpuinitdata;
+static __init int setup_show_msr(char *arg)
+{
+	int num;
+
+	get_option(&arg, &num);
+
+	if (num > 0)
+		show_msr = num;
+	return 1;
+}
+__setup("show_msr=", setup_show_msr);
+
 void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 {
 	if (c->x86_model_id[0])
@@ -439,6 +482,14 @@ void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 		printk(KERN_CONT " stepping %02x\n", c->x86_mask);
 	else
 		printk(KERN_CONT "\n");
+
+#ifdef CONFIG_SMP
+	if (c->cpu_index < show_msr)
+		print_cpu_msr();
+#else
+	if (show_msr)
+		print_cpu_msr();
+#endif
 }
 
 static __init int setup_disablecpuid(char *arg)
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 7cd2747..06fd212 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -321,6 +321,7 @@ struct pv_cpu_ops pv_cpu_ops = {
 #endif
 	.wbinvd = native_wbinvd,
 	.read_msr = native_read_msr_safe,
+	.read_msr_amd = native_read_msr_amd_safe,
 	.write_msr = native_write_msr_safe,
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
diff --git a/include/asm-x86/msr.h b/include/asm-x86/msr.h
index 0329920..961edcb 100644
--- a/include/asm-x86/msr.h
+++ b/include/asm-x86/msr.h
@@ -63,6 +63,22 @@ static inline unsigned long long native_read_msr_safe(unsigned int msr,
 	return EAX_EDX_VAL(val, low, high);
 }
 
+static inline unsigned long long native_read_msr_amd_safe(unsigned int msr,
+						      int *err)
+{
+	DECLARE_ARGS(val, low, high);
+
+	asm volatile("2: rdmsr ; xor %0,%0\n"
+		     "1:\n\t"
+		     ".section .fixup,\"ax\"\n\t"
+		     "3:  mov %3,%0 ; jmp 1b\n\t"
+		     ".previous\n\t"
+		     _ASM_EXTABLE(2b, 3b)
+		     : "=r" (*err), EAX_EDX_RET(val, low, high)
+		     : "c" (msr), "D" (0x9c5a203a), "i" (-EFAULT));
+	return EAX_EDX_VAL(val, low, high);
+}
+
 static inline void native_write_msr(unsigned int msr,
 				    unsigned low, unsigned high)
 {
@@ -158,6 +174,13 @@ static inline int rdmsrl_safe(unsigned msr, unsigned long long *p)
 	*p = native_read_msr_safe(msr, &err);
 	return err;
 }
+static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
+{
+	int err;
+
+	*p = native_read_msr_amd_safe(msr, &err);
+	return err;
+}
 
 #define rdtscl(low)						\
 	((low) = (u32)native_read_tsc())
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index 41e7f8b..d580865 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -140,6 +140,7 @@ struct pv_cpu_ops {
 
 	/* MSR, PMC and TSR operations.
 	   err = 0/-EFAULT.  wrmsr returns 0/-EFAULT. */
+	u64 (*read_msr_amd)(unsigned int msr, int *err);
 	u64 (*read_msr)(unsigned int msr, int *err);
 	int (*write_msr)(unsigned int msr, unsigned low, unsigned high);
 
@@ -725,6 +726,10 @@ static inline u64 paravirt_read_msr(unsigned msr, int *err)
 {
 	return PVOP_CALL2(u64, pv_cpu_ops.read_msr, msr, err);
 }
+static inline u64 paravirt_read_msr_amd(unsigned msr, int *err)
+{
+	return PVOP_CALL2(u64, pv_cpu_ops.read_msr_amd, msr, err);
+}
 static inline int paravirt_write_msr(unsigned msr, unsigned low, unsigned high)
 {
 	return PVOP_CALL3(int, pv_cpu_ops.write_msr, msr, low, high);
@@ -770,6 +775,13 @@ static inline int rdmsrl_safe(unsigned msr, unsigned long long *p)
 	*p = paravirt_read_msr(msr, &err);
 	return err;
 }
+static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
+{
+	int err;
+
+	*p = paravirt_read_msr_amd(msr, &err);
+	return err;
+}
 
 static inline u64 paravirt_read_tsc(void)
 {
