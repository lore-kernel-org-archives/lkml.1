Return-Path: <linux-kernel-owner+w=401wt.eu-S1758405AbZJEDLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405AbZJEDLF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 23:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758190AbZJEDLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 23:11:04 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48692 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbZJEDLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 23:11:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC96391.1060001@jp.fujitsu.com>
Date: Mon, 05 Oct 2009 12:10:09 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] mce-inject: use injected mce only during faked handler
 call
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com> <4AC95F5A.4000708@jp.fujitsu.com>
In-Reply-To: <4AC95F5A.4000708@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current implementation, injected MCE is valid from the point
the MCE is injected to the point the MCE is processed by the faked
handler call.

This has an undesired side-effect: it is possible for it to be
consumed by real machine_check_poll. This may confuse a real system
error and may confuse the mce test suite.

To fix this, this patch introduces struct mce_fake_banks to hold
injected data and a flag which indicates that the injected data is
ready for the handler.

The mce_fake_banks.valid becomes 1 only during faked MCE handler call
and protected by IRQ disabling. This make it impossible for real
machine_check_poll to consume it.

(I suppose that in the near future the mce_fake_banks will be patched
 to support injecting multiple errors on a cpu.)

Reported-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/mce.h              |   12 +++++++++++-
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   25 ++++++++++++++++++++-----
 arch/x86/kernel/cpu/mcheck/mce.c        |   16 +++++++++-------
 3 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index d051abd..2f1c0ef 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -192,7 +192,6 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b);
 int mce_notify_irq(void);
 void mce_notify_process(void);
 
-DECLARE_PER_CPU(struct mce, injectm);
 extern struct file_operations mce_chrdev_ops;
 
 /*
@@ -218,5 +217,16 @@ void intel_init_thermal(struct cpuinfo_x86 *c);
 
 void mce_log_therm_throt_event(__u64 status);
 
+/*
+ * For error injection
+ */
+
+struct mce_fake_banks {
+	int valid;
+	struct mce injectm;
+};
+
+DECLARE_PER_CPU(struct mce_fake_banks, mce_fake_banks);
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_MCE_H */
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 4fb5b78..a481291 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -28,7 +28,7 @@
 /* Update fake mce registers on current CPU. */
 static void inject_mce(struct mce *m)
 {
-	struct mce *i = &per_cpu(injectm, m->extcpu);
+	struct mce *i = &per_cpu(mce_fake_banks, m->extcpu).injectm;
 
 	/* Make sure noone reads partially written injectm */
 	i->finished = 0;
@@ -50,8 +50,11 @@ static void raise_poll(struct mce *m)
 	mce_banks_t b;
 
 	memset(&b, 0xff, sizeof(mce_banks_t));
+
 	local_irq_save(flags);
+	__get_cpu_var(mce_fake_banks).valid = 1;
 	machine_check_poll(0, &b);
+	__get_cpu_var(mce_fake_banks).valid = 0;
 	local_irq_restore(flags);
 	m->finished = 0;
 }
@@ -67,9 +70,12 @@ static void raise_exception(struct mce *m, struct pt_regs *pregs)
 		regs.cs = m->cs;
 		pregs = &regs;
 	}
+
 	/* in mcheck exeception handler, irq will be disabled */
 	local_irq_save(flags);
+	__get_cpu_var(mce_fake_banks).valid = 1;
 	do_machine_check(pregs, 0);
+	__get_cpu_var(mce_fake_banks).valid = 0;
 	local_irq_restore(flags);
 	m->finished = 0;
 }
@@ -81,14 +87,20 @@ static int mce_raise_notify(struct notifier_block *self,
 {
 	struct die_args *args = (struct die_args *)data;
 	int cpu = smp_processor_id();
-	struct mce *m = &__get_cpu_var(injectm);
+	struct mce *m = &__get_cpu_var(mce_fake_banks).injectm;
+
 	if (val != DIE_NMI_IPI || !cpu_isset(cpu, mce_inject_cpumask))
 		return NOTIFY_DONE;
 	cpu_clear(cpu, mce_inject_cpumask);
+
+	if (!m->finished)
+		return NOTIFY_STOP;
+
 	if (m->inject_flags & MCE_INJ_EXCEPTION)
 		raise_exception(m, args->regs);
 	else
 		raise_poll(m);
+
 	return NOTIFY_STOP;
 }
 
@@ -100,11 +112,14 @@ static struct notifier_block mce_raise_nb = {
 /* Inject mce on current CPU */
 static int raise_local(void)
 {
-	struct mce *m = &__get_cpu_var(injectm);
+	struct mce *m = &__get_cpu_var(mce_fake_banks).injectm;
 	int context = MCE_INJ_CTX(m->inject_flags);
 	int ret = 0;
 	int cpu = m->extcpu;
 
+	if (!m->finished)
+		return 0;
+
 	if (m->inject_flags & MCE_INJ_EXCEPTION) {
 		printk(KERN_INFO "Triggering MCE exception on CPU %d\n", cpu);
 		switch (context) {
@@ -149,8 +164,8 @@ static void raise_mce(struct mce *m)
 		mce_inject_cpumask = cpu_online_map;
 		cpu_clear(get_cpu(), mce_inject_cpumask);
 		for_each_online_cpu(cpu) {
-			struct mce *mcpu = &per_cpu(injectm, cpu);
-			if (!mcpu->finished || MCE_INJ_CTX(mcpu->inject_flags)
+			struct mce *m = &per_cpu(mce_fake_banks, cpu).injectm;
+			if (!m->finished || MCE_INJ_CTX(m->inject_flags)
 							!= MCE_INJ_CTX_RANDOM)
 				cpu_clear(cpu, mce_inject_cpumask);
 		}
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 413aba8..a6d5d4a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -110,8 +110,8 @@ void mce_setup(struct mce *m)
 	rdmsrl(MSR_IA32_MCG_CAP, m->mcgcap);
 }
 
-DEFINE_PER_CPU(struct mce, injectm);
-EXPORT_PER_CPU_SYMBOL_GPL(injectm);
+DEFINE_PER_CPU(struct mce_fake_banks, mce_fake_banks);
+EXPORT_PER_CPU_SYMBOL_GPL(mce_fake_banks);
 
 /*
  * Lockless MCE logging infrastructure.
@@ -284,7 +284,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 
 static int msr_to_offset(u32 msr)
 {
-	unsigned bank = __get_cpu_var(injectm.bank);
+	unsigned bank = __get_cpu_var(mce_fake_banks).injectm.bank;
 	if (msr == rip_msr)
 		return offsetof(struct mce, ip);
 	if (msr == MSR_IA32_MCx_STATUS(bank))
@@ -303,12 +303,13 @@ static u64 mce_rdmsrl(u32 msr)
 {
 	u64 v;
 
-	if (__get_cpu_var(injectm).finished) {
+	if (__get_cpu_var(mce_fake_banks).valid) {
 		int offset = msr_to_offset(msr);
+		char *m = (char *)&__get_cpu_var(mce_fake_banks).injectm;
 
 		if (offset < 0)
 			return 0;
-		return *(u64 *)((char *)&__get_cpu_var(injectm) + offset);
+		return *(u64 *)(m + offset);
 	}
 
 	if (rdmsrl_safe(msr, &v)) {
@@ -326,11 +327,12 @@ static u64 mce_rdmsrl(u32 msr)
 
 static void mce_wrmsrl(u32 msr, u64 v)
 {
-	if (__get_cpu_var(injectm).finished) {
+	if (__get_cpu_var(mce_fake_banks).valid) {
 		int offset = msr_to_offset(msr);
+		char *m = (char *)&__get_cpu_var(mce_fake_banks).injectm;
 
 		if (offset >= 0)
-			*(u64 *)((char *)&__get_cpu_var(injectm) + offset) = v;
+			*(u64 *)(m + offset) = v;
 		return;
 	}
 	wrmsrl(msr, v);
-- 
1.6.4.3


