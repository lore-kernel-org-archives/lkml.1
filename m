Return-Path: <linux-kernel-owner+w=401wt.eu-S1752074AbZI1GwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbZI1GwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 02:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbZI1GwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 02:52:13 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42687 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbZI1GwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 02:52:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC05CFC.4020702@jp.fujitsu.com>
Date: Mon, 28 Sep 2009 15:51:40 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] x86, mce: rename finished to valid in struct mce
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com> <4AC05BBF.3010102@jp.fujitsu.com>
In-Reply-To: <4AC05BBF.3010102@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The straightforward name is easier to understand.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/mce.h              |    6 +++---
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   14 +++++++-------
 arch/x86/kernel/cpu/mcheck/mce.c        |   16 ++++++++--------
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 4a48344..995dfd2 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -58,12 +58,12 @@ struct mce {
 	__u64 time;	/* wall time_t when error was detected */
 	__u8  cpuvendor;	/* cpu vendor as encoded in system.h */
 	__u8  inject_flags;	/* software inject flags */
-	__u16  pad;
+	__u16 pad;
 	__u32 cpuid;	/* CPUID 1 EAX */
-	__u8  cs;		/* code segment */
+	__u8  cs;	/* code segment */
 	__u8  bank;	/* machine check bank */
 	__u8  cpu;	/* cpu number; obsolete; use extcpu now */
-	__u8  finished;   /* entry is valid */
+	__u8  valid;	/* entry is valid */
 	__u32 extcpu;	/* linux cpu number that detected the error */
 	__u32 socketid;	/* CPU socket ID */
 	__u32 apicid;	/* CPU initial apic ID */
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 2c1fc5a..5bac818 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -31,9 +31,9 @@ static void inject_mce(struct mce *m)
 	struct mce *i = &per_cpu(injectm, m->extcpu);
 
 	/* Make sure noone reads partially written injectm */
-	i->finished = 0;
+	i->valid = 0;
 	mb();
-	m->finished = 0;
+	m->valid = 0;
 	/* First set the fields after finished */
 	i->extcpu = m->extcpu;
 	mb();
@@ -41,7 +41,7 @@ static void inject_mce(struct mce *m)
 	memcpy(i, m, sizeof(struct mce));
 	/* Finally activate it */
 	mb();
-	i->finished = 1;
+	i->valid = 1;
 }
 
 static void raise_poll(struct mce *m)
@@ -53,7 +53,7 @@ static void raise_poll(struct mce *m)
 	local_irq_save(flags);
 	machine_check_poll(0, &b);
 	local_irq_restore(flags);
-	m->finished = 0;
+	m->valid = 0;
 }
 
 static void raise_exception(struct mce *m, struct pt_regs *pregs)
@@ -71,7 +71,7 @@ static void raise_exception(struct mce *m, struct pt_regs *pregs)
 	local_irq_save(flags);
 	do_machine_check(pregs, 0);
 	local_irq_restore(flags);
-	m->finished = 0;
+	m->valid = 0;
 }
 
 static cpumask_t mce_inject_cpumask;
@@ -129,7 +129,7 @@ static int raise_local(void)
 		mce_notify_irq();
 		printk(KERN_INFO "Machine check poll done on CPU %d\n", cpu);
 	} else
-		m->finished = 0;
+		m->valid = 0;
 
 	return ret;
 }
@@ -152,7 +152,7 @@ static void raise_mce(struct mce *m)
 		cpu_clear(get_cpu(), mce_inject_cpumask);
 		for_each_online_cpu(cpu) {
 			struct mce *mcpu = &per_cpu(injectm, cpu);
-			if (!mcpu->finished || MCE_INJ_CTX(mcpu->inject_flags)
+			if (!mcpu->valid || MCE_INJ_CTX(mcpu->inject_flags)
 							!= MCE_INJ_CTX_RANDOM)
 				cpu_clear(cpu, mce_inject_cpumask);
 		}
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 4b2af86..ac4f478 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -129,7 +129,7 @@ void mce_log(struct mce *mce)
 {
 	unsigned next, entry;
 
-	mce->finished = 0;
+	mce->valid = 0;
 	wmb();
 	for (;;) {
 		entry = rcu_dereference(mcelog.next);
@@ -145,7 +145,7 @@ void mce_log(struct mce *mce)
 				return;
 			}
 			/* Old left over entry. Skip: */
-			if (mcelog.entry[entry].finished) {
+			if (mcelog.entry[entry].valid) {
 				entry++;
 				continue;
 			}
@@ -158,10 +158,10 @@ void mce_log(struct mce *mce)
 	}
 	memcpy(mcelog.entry + entry, mce, sizeof(struct mce));
 	wmb();
-	mcelog.entry[entry].finished = 1;
+	mcelog.entry[entry].valid = 1;
 	wmb();
 
-	mce->finished = 1;
+	mce->valid = 1;
 	set_bit(0, &mce_need_notify);
 }
 
@@ -306,7 +306,7 @@ static u64 mce_rdmsrl(u32 msr)
 {
 	u64 v;
 
-	if (__get_cpu_var(injectm).finished) {
+	if (__get_cpu_var(injectm).valid) {
 		int offset = msr_to_offset(msr);
 
 		if (offset < 0)
@@ -329,7 +329,7 @@ static u64 mce_rdmsrl(u32 msr)
 
 static void mce_wrmsrl(u32 msr, u64 v)
 {
-	if (__get_cpu_var(injectm).finished) {
+	if (__get_cpu_var(injectm).valid) {
 		int offset = msr_to_offset(msr);
 
 		if (offset >= 0)
@@ -1488,7 +1488,7 @@ static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
 		for (i = prev; i < next; i++) {
 			unsigned long start = jiffies;
 
-			while (!mcelog.entry[i].finished) {
+			while (!mcelog.entry[i].valid) {
 				if (time_after_eq(jiffies, start + 2)) {
 					memset(mcelog.entry + i, 0,
 					       sizeof(struct mce));
@@ -1519,7 +1519,7 @@ timeout:
 	on_each_cpu(collect_tscs, cpu_tsc, 1);
 
 	for (i = next; i < MCE_LOG_LEN; i++) {
-		if (mcelog.entry[i].finished &&
+		if (mcelog.entry[i].valid &&
 		    mcelog.entry[i].tsc < cpu_tsc[mcelog.entry[i].cpu]) {
 			err |= copy_to_user(buf, mcelog.entry+i,
 					    sizeof(struct mce));
-- 
1.6.4.3


