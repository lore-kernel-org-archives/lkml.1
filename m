Return-Path: <linux-kernel-owner+w=401wt.eu-S1751959AbZI1Gvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbZI1Gvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 02:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbZI1Gvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 02:51:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50412 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbZI1Gvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 02:51:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC05CD9.3040509@jp.fujitsu.com>
Date: Mon, 28 Sep 2009 15:51:05 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] mce-inject: replace MCJ_ to MCE_INJ_
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com> <4AC05BBF.3010102@jp.fujitsu.com>
In-Reply-To: <4AC05BBF.3010102@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MCE_INJ_ is better than MCJ_ standing for "MCe inJect."

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/mce.h              |   15 ++++++++-------
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   20 ++++++++++----------
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index b608a64..4a48344 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -38,13 +38,14 @@
 #define MCM_ADDR_MEM	 3	/* memory address */
 #define MCM_ADDR_GENERIC 7	/* generic */
 
-#define MCJ_CTX_MASK		3
-#define MCJ_CTX(flags)		((flags) & MCJ_CTX_MASK)
-#define MCJ_CTX_RANDOM		0    /* inject context: random */
-#define MCJ_CTX_PROCESS		1    /* inject context: process */
-#define MCJ_CTX_IRQ		2    /* inject context: IRQ */
-#define MCJ_NMI_BROADCAST	4    /* do NMI broadcasting */
-#define MCJ_EXCEPTION		8    /* raise as exception */
+#define MCE_INJ_CTX_MASK	0x03
+#define  MCE_INJ_CTX_RANDOM	0x00    /* inject context: random */
+#define  MCE_INJ_CTX_PROCESS	0x01    /* inject context: process */
+#define  MCE_INJ_CTX_IRQ	0x02    /* inject context: IRQ */
+#define MCE_INJ_CTX(flags)	((flags) & MCE_INJ_CTX_MASK)
+
+#define MCE_INJ_NMI_BROADCAST	(1 << 2)    /* do NMI broadcasting */
+#define MCE_INJ_EXCEPTION	(1 << 3)    /* raise as exception */
 
 /* Fields are zero when not available */
 struct mce {
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 472763d..2c1fc5a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -85,7 +85,7 @@ static int mce_raise_notify(struct notifier_block *self,
 	if (val != DIE_NMI_IPI || !cpu_isset(cpu, mce_inject_cpumask))
 		return NOTIFY_DONE;
 	cpu_clear(cpu, mce_inject_cpumask);
-	if (m->inject_flags & MCJ_EXCEPTION)
+	if (m->inject_flags & MCE_INJ_EXCEPTION)
 		raise_exception(m, args->regs);
 	else if (m->status)
 		raise_poll(m);
@@ -101,21 +101,21 @@ static struct notifier_block mce_raise_nb = {
 static int raise_local(void)
 {
 	struct mce *m = &__get_cpu_var(injectm);
-	int context = MCJ_CTX(m->inject_flags);
+	int context = MCE_INJ_CTX(m->inject_flags);
 	int ret = 0;
 	int cpu = m->extcpu;
 
-	if (m->inject_flags & MCJ_EXCEPTION) {
+	if (m->inject_flags & MCE_INJ_EXCEPTION) {
 		printk(KERN_INFO "Triggering MCE exception on CPU %d\n", cpu);
 		switch (context) {
-		case MCJ_CTX_IRQ:
+		case MCE_INJ_CTX_IRQ:
 			/*
 			 * Could do more to fake interrupts like
 			 * calling irq_enter, but the necessary
 			 * machinery isn't exported currently.
 			 */
 			/*FALL THROUGH*/
-		case MCJ_CTX_PROCESS:
+		case MCE_INJ_CTX_PROCESS:
 			raise_exception(m, NULL);
 			break;
 		default:
@@ -136,15 +136,15 @@ static int raise_local(void)
 
 static void raise_mce(struct mce *m)
 {
-	int context = MCJ_CTX(m->inject_flags);
+	int context = MCE_INJ_CTX(m->inject_flags);
 
 	inject_mce(m);
 
-	if (context == MCJ_CTX_RANDOM)
+	if (context == MCE_INJ_CTX_RANDOM)
 		return;
 
 #ifdef CONFIG_X86_LOCAL_APIC
-	if (m->inject_flags & MCJ_NMI_BROADCAST) {
+	if (m->inject_flags & MCE_INJ_NMI_BROADCAST) {
 		unsigned long start;
 		int cpu;
 		get_online_cpus();
@@ -152,8 +152,8 @@ static void raise_mce(struct mce *m)
 		cpu_clear(get_cpu(), mce_inject_cpumask);
 		for_each_online_cpu(cpu) {
 			struct mce *mcpu = &per_cpu(injectm, cpu);
-			if (!mcpu->finished ||
-			    MCJ_CTX(mcpu->inject_flags) != MCJ_CTX_RANDOM)
+			if (!mcpu->finished || MCE_INJ_CTX(mcpu->inject_flags)
+							!= MCE_INJ_CTX_RANDOM)
 				cpu_clear(cpu, mce_inject_cpumask);
 		}
 		if (!cpus_empty(mce_inject_cpumask))
-- 
1.6.4.3


