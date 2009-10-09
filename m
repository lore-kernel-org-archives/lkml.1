Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbZJIFpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbZJIFpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 01:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbZJIFpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 01:45:49 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46210 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbZJIFps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 01:45:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4ACECDDD.1040206@jp.fujitsu.com>
Date: Fri, 09 Oct 2009 14:45:01 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] mce-inject: use individual members instead of struct
 mce
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>	 <4AC95F5A.4000708@jp.fujitsu.com>  <4AC96391.1060001@jp.fujitsu.com> <1255053299.5228.28.camel@yhuang-dev.sh.intel.com> <4ACECC49.7000602@jp.fujitsu.com>
In-Reply-To: <4ACECC49.7000602@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct mce have many members and almost half of them are not used
for mce injection.  So make struct mce_fake_banks to have required
members instead of having struct mce in it.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/mce.h              |   15 +++++-
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   79 ++++++++++++++++--------------
 arch/x86/kernel/cpu/mcheck/mce.c        |   16 +++---
 3 files changed, 63 insertions(+), 47 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 4b5ef3c..0668044 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -235,8 +235,19 @@ void mce_log_therm_throt_event(__u64 status);
  */
 
 struct mce_fake_banks {
-	int valid;
-	struct mce injectm;
+	int valid:1;	/* 1 if injected data is ready for consume */
+	int loaded:1;	/* 1 if injected data is available */
+
+	__u64 mcgstatus;
+	__u64 ip;
+	__u8  cs;
+
+	__u8  inject_flags;	/* software inject flags */
+
+	__u8  bank;
+	__u64 status;
+	__u64 misc;
+	__u64 addr;
 };
 
 DECLARE_PER_CPU(struct mce_fake_banks, mce_fake_banks);
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 835c072..6275318 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -28,23 +28,27 @@
 /* Update fake mce registers on current CPU. */
 static void inject_mce(struct mce *m)
 {
-	struct mce *i = &per_cpu(mce_fake_banks, m->extcpu).injectm;
+	struct mce_fake_banks *banks = &per_cpu(mce_fake_banks, m->extcpu);
+
+	banks->mcgstatus	= m->mcgstatus;
+	banks->ip		= m->ip;
+	banks->cs		= m->cs;
+	banks->inject_flags	= m->inject_flags;
+	banks->bank		= m->bank;
+	banks->status		= m->status;
+	banks->addr		= m->addr;
+	banks->misc		= m->misc;
 
-	/* Make sure noone reads partially written injectm */
-	i->finished = 0;
-	mb();
-	m->finished = 0;
-	/* First set the fields after finished */
-	i->extcpu = m->extcpu;
-	mb();
-	/* Now write record in order, finished last (except above) */
-	memcpy(i, m, sizeof(struct mce));
-	/* Finally activate it */
 	mb();
-	i->finished = 1;
+	banks->loaded = 1;
 }
 
-static void raise_poll(struct mce *m)
+static void clean_injected(struct mce_fake_banks *banks)
+{
+	banks->loaded = 0;
+}
+
+static void raise_poll(struct mce_fake_banks *banks)
 {
 	unsigned long flags;
 	mce_banks_t b;
@@ -52,32 +56,34 @@ static void raise_poll(struct mce *m)
 	memset(&b, 0xff, sizeof(mce_banks_t));
 
 	local_irq_save(flags);
-	__get_cpu_var(mce_fake_banks).valid = 1;
+	banks->valid = 1;
 	machine_check_poll(0, &b);
-	__get_cpu_var(mce_fake_banks).valid = 0;
+	banks->valid = 0;
 	local_irq_restore(flags);
-	m->finished = 0;
+
+	clean_injected(banks);
 }
 
-static void raise_exception(struct mce *m, struct pt_regs *pregs)
+static void raise_exception(struct mce_fake_banks *banks, struct pt_regs *pregs)
 {
 	struct pt_regs regs;
 	unsigned long flags;
 
 	if (!pregs) {
 		memset(&regs, 0, sizeof(struct pt_regs));
-		regs.ip = m->ip;
-		regs.cs = m->cs;
+		regs.ip = banks->ip;
+		regs.cs = banks->cs;
 		pregs = &regs;
 	}
 
 	/* in mcheck exeception handler, irq will be disabled */
 	local_irq_save(flags);
-	__get_cpu_var(mce_fake_banks).valid = 1;
+	banks->valid = 1;
 	do_machine_check(pregs, 0);
-	__get_cpu_var(mce_fake_banks).valid = 0;
+	banks->valid = 0;
 	local_irq_restore(flags);
-	m->finished = 0;
+
+	clean_injected(banks);
 }
 
 static cpumask_t mce_inject_cpumask;
@@ -87,19 +93,19 @@ static int mce_raise_notify(struct notifier_block *self,
 {
 	struct die_args *args = (struct die_args *)data;
 	int cpu = smp_processor_id();
-	struct mce *m = &__get_cpu_var(mce_fake_banks).injectm;
+	struct mce_fake_banks *banks = &__get_cpu_var(mce_fake_banks);
 
 	if (val != DIE_NMI_IPI || !cpu_isset(cpu, mce_inject_cpumask))
 		return NOTIFY_DONE;
 	cpu_clear(cpu, mce_inject_cpumask);
 
-	if (!m->finished)
+	if (!banks->loaded)
 		return NOTIFY_STOP;
 
-	if (m->inject_flags & MCE_INJ_EXCEPTION)
-		raise_exception(m, args->regs);
+	if (banks->inject_flags & MCE_INJ_EXCEPTION)
+		raise_exception(banks, args->regs);
 	else
-		raise_poll(m);
+		raise_poll(banks);
 
 	return NOTIFY_STOP;
 }
@@ -112,17 +118,16 @@ static struct notifier_block mce_raise_nb = {
 /* Inject mce on current CPU */
 static int raise_local(void)
 {
-	struct mce *m = &__get_cpu_var(mce_fake_banks).injectm;
-	int context = MCE_INJ_CTX(m->inject_flags);
+	struct mce_fake_banks *banks = &__get_cpu_var(mce_fake_banks);
+	int cpu = smp_processor_id();
 	int ret = 0;
-	int cpu = m->extcpu;
 
-	if (!m->finished)
+	if (!banks->loaded)
 		return 0;
 
-	if (m->inject_flags & MCE_INJ_EXCEPTION) {
+	if (banks->inject_flags & MCE_INJ_EXCEPTION) {
 		printk(KERN_INFO "Triggering MCE exception on CPU %d\n", cpu);
-		switch (context) {
+		switch (MCE_INJ_CTX(banks->inject_flags)) {
 		case MCE_INJ_CTX_IRQ:
 			/*
 			 * Could do more to fake interrupts like
@@ -131,7 +136,7 @@ static int raise_local(void)
 			 */
 			/*FALL THROUGH*/
 		case MCE_INJ_CTX_PROCESS:
-			raise_exception(m, NULL);
+			raise_exception(banks, NULL);
 			break;
 		default:
 			printk(KERN_INFO "Invalid MCE context\n");
@@ -140,7 +145,7 @@ static int raise_local(void)
 		printk(KERN_INFO "MCE exception done on CPU %d\n", cpu);
 	} else {
 		printk(KERN_INFO "Starting machine check poll CPU %d\n", cpu);
-		raise_poll(m);
+		raise_poll(banks);
 		mce_notify_irq();
 		printk(KERN_INFO "Machine check poll done on CPU %d\n", cpu);
 	}
@@ -159,8 +164,8 @@ static void raise_global(void)
 	cpu_clear(get_cpu(), mce_inject_cpumask);
 
 	for_each_online_cpu(cpu) {
-		struct mce *m = &per_cpu(mce_fake_banks, cpu).injectm;
-		if (!m->finished || MCE_INJ_CTX(m->inject_flags)
+		struct mce_fake_banks *banks = &per_cpu(mce_fake_banks, cpu);
+		if (!banks->loaded || MCE_INJ_CTX(banks->inject_flags)
 							!= MCE_INJ_CTX_RANDOM)
 			cpu_clear(cpu, mce_inject_cpumask);
 	}
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index fad3daa..5a6f17d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -303,17 +303,17 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 
 static int msr_to_offset(u32 msr)
 {
-	unsigned bank = __get_cpu_var(mce_fake_banks).injectm.bank;
+	unsigned bank = __get_cpu_var(mce_fake_banks).bank;
 	if (msr == rip_msr)
-		return offsetof(struct mce, ip);
+		return offsetof(struct mce_fake_banks, ip);
 	if (msr == MSR_IA32_MCx_STATUS(bank))
-		return offsetof(struct mce, status);
+		return offsetof(struct mce_fake_banks, status);
 	if (msr == MSR_IA32_MCx_ADDR(bank))
-		return offsetof(struct mce, addr);
+		return offsetof(struct mce_fake_banks, addr);
 	if (msr == MSR_IA32_MCx_MISC(bank))
-		return offsetof(struct mce, misc);
+		return offsetof(struct mce_fake_banks, misc);
 	if (msr == MSR_IA32_MCG_STATUS)
-		return offsetof(struct mce, mcgstatus);
+		return offsetof(struct mce_fake_banks, mcgstatus);
 	return -1;
 }
 
@@ -324,7 +324,7 @@ static u64 mce_rdmsrl(u32 msr)
 
 	if (__get_cpu_var(mce_fake_banks).valid) {
 		int offset = msr_to_offset(msr);
-		char *m = (char *)&__get_cpu_var(mce_fake_banks).injectm;
+		char *m = (char *)&__get_cpu_var(mce_fake_banks);
 
 		if (offset < 0)
 			return 0;
@@ -348,7 +348,7 @@ static void mce_wrmsrl(u32 msr, u64 v)
 {
 	if (__get_cpu_var(mce_fake_banks).valid) {
 		int offset = msr_to_offset(msr);
-		char *m = (char *)&__get_cpu_var(mce_fake_banks).injectm;
+		char *m = (char *)&__get_cpu_var(mce_fake_banks);
 
 		if (offset >= 0)
 			*(u64 *)(m + offset) = v;
-- 
1.6.2.2


