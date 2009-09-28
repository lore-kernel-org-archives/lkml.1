Return-Path: <linux-kernel-owner+w=401wt.eu-S1752281AbZI1Gxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbZI1Gxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 02:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbZI1Gx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 02:53:29 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42766 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbZI1Gx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 02:53:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC05D48.1000007@jp.fujitsu.com>
Date: Mon, 28 Sep 2009 15:52:56 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] mce-inject: make injected mce valid only during faked
 handler call
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com> <4AC05BBF.3010102@jp.fujitsu.com>
In-Reply-To: <4AC05BBF.3010102@jp.fujitsu.com>
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

To fix this, this patch changes mce_rdmsrl/wemsrl() to refer injected
data only when injectm.valid states 3rd state "2", which indicates that
the injected MCE entry is valid and ready for the handler.

The injectm.valid becomes "2" only during faked MCE handler call
and protected by IRQ disabling. This make it impossible for real
machine_check_poll to consume it.

Reported-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/mce.h              |    2 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   17 +++++++++++++++--
 arch/x86/kernel/cpu/mcheck/mce.c        |    4 ++--
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 995dfd2..fd9c3ca 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -63,7 +63,7 @@ struct mce {
 	__u8  cs;	/* code segment */
 	__u8  bank;	/* machine check bank */
 	__u8  cpu;	/* cpu number; obsolete; use extcpu now */
-	__u8  valid;	/* entry is valid */
+	__u8  valid;	/* 1: entry is valid, 2: valid as fake (injectm) */
 	__u32 extcpu;	/* linux cpu number that detected the error */
 	__u32 socketid;	/* CPU socket ID */
 	__u32 apicid;	/* CPU initial apic ID */
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 5bac818..702f712 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -50,10 +50,12 @@ static void raise_poll(struct mce *m)
 	mce_banks_t b;
 
 	memset(&b, 0xff, sizeof(mce_banks_t));
+
 	local_irq_save(flags);
+	m->valid = 2;
 	machine_check_poll(0, &b);
-	local_irq_restore(flags);
 	m->valid = 0;
+	local_irq_restore(flags);
 }
 
 static void raise_exception(struct mce *m, struct pt_regs *pregs)
@@ -67,11 +69,13 @@ static void raise_exception(struct mce *m, struct pt_regs *pregs)
 		regs.cs = m->cs;
 		pregs = &regs;
 	}
+
 	/* in mcheck exeception handler, irq will be disabled */
 	local_irq_save(flags);
+	m->valid = 2;
 	do_machine_check(pregs, 0);
-	local_irq_restore(flags);
 	m->valid = 0;
+	local_irq_restore(flags);
 }
 
 static cpumask_t mce_inject_cpumask;
@@ -82,13 +86,19 @@ static int mce_raise_notify(struct notifier_block *self,
 	struct die_args *args = (struct die_args *)data;
 	int cpu = smp_processor_id();
 	struct mce *m = &__get_cpu_var(injectm);
+
 	if (val != DIE_NMI_IPI || !cpu_isset(cpu, mce_inject_cpumask))
 		return NOTIFY_DONE;
 	cpu_clear(cpu, mce_inject_cpumask);
+
+	if (!m->valid)
+		return NOTIFY_STOP;
+
 	if (m->inject_flags & MCE_INJ_EXCEPTION)
 		raise_exception(m, args->regs);
 	else if (m->status)
 		raise_poll(m);
+
 	return NOTIFY_STOP;
 }
 
@@ -105,6 +115,9 @@ static int raise_local(void)
 	int ret = 0;
 	int cpu = m->extcpu;
 
+	if (!m->valid)
+		return 0;
+
 	if (m->inject_flags & MCE_INJ_EXCEPTION) {
 		printk(KERN_INFO "Triggering MCE exception on CPU %d\n", cpu);
 		switch (context) {
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index ac4f478..aeab37a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -306,7 +306,7 @@ static u64 mce_rdmsrl(u32 msr)
 {
 	u64 v;
 
-	if (__get_cpu_var(injectm).valid) {
+	if (__get_cpu_var(injectm).valid > 1) {
 		int offset = msr_to_offset(msr);
 
 		if (offset < 0)
@@ -329,7 +329,7 @@ static u64 mce_rdmsrl(u32 msr)
 
 static void mce_wrmsrl(u32 msr, u64 v)
 {
-	if (__get_cpu_var(injectm).valid) {
+	if (__get_cpu_var(injectm).valid > 1) {
 		int offset = msr_to_offset(msr);
 
 		if (offset >= 0)
-- 
1.6.4.3


