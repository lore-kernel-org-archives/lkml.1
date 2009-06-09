Return-Path: <linux-kernel-owner+w=401wt.eu-S1758467AbZFIHbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbZFIHbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 03:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758149AbZFIHbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 03:31:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:42215 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758680AbZFIHbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 03:31:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,330,1241420400"; 
   d="scan'208";a="697690459"
Subject: [PATCH 2/3 -v3] x86: MCE: inject: Support specifying raise mode
 for software MCE injection
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 09 Jun 2009 15:31:37 +0800
Message-Id: <1244532697.8361.649.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raise mode include raising as exception or raising as poll, it is
specified via the mce.inject_flags field.

This can be used to specify raise mode of UCNA, which is UC error but
raised not as exception. And this can be used to test the filter code
of poll handler or exception handler too. For example, enforce a poll
raise mode for a fatal MCE.


ChangeLog:

v2:

- Re-base on latest x86-tip.git/mce3

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/include/asm/mce.h              |    1 +
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   16 ++++++++--------
 2 files changed, 9 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -44,7 +44,7 @@ static void inject_mce(struct mce *m)
 	i->finished = 1;
 }
 
-static void raise_corrected(struct mce *m)
+static void raise_poll(struct mce *m)
 {
 	unsigned long flags;
 	mce_banks_t b;
@@ -56,7 +56,7 @@ static void raise_corrected(struct mce *
 	m->finished = 0;
 }
 
-static void raise_uncorrected(struct mce *m, struct pt_regs *pregs)
+static void raise_exception(struct mce *m, struct pt_regs *pregs)
 {
 	struct pt_regs regs;
 	unsigned long flags;
@@ -85,10 +85,10 @@ static int mce_raise_notify(struct notif
 	if (val != DIE_NMI_IPI || !cpu_isset(cpu, mce_inject_cpumask))
 		return NOTIFY_DONE;
 	cpu_clear(cpu, mce_inject_cpumask);
-	if (m->status & MCI_STATUS_UC)
-		raise_uncorrected(m, args->regs);
+	if (m->inject_flags & MCJ_EXCEPTION)
+		raise_exception(m, args->regs);
 	else if (m->status)
-		raise_corrected(m);
+		raise_poll(m);
 	return NOTIFY_STOP;
 }
 
@@ -104,7 +104,7 @@ static int raise_local(struct mce *m)
 	int ret = 0;
 	int cpu = m->extcpu;
 
-	if (m->status & MCI_STATUS_UC) {
+	if (m->inject_flags & MCJ_EXCEPTION) {
 		printk(KERN_INFO "Triggering MCE exception on CPU %d\n", cpu);
 		switch (context) {
 		case MCJ_CTX_IRQ:
@@ -115,7 +115,7 @@ static int raise_local(struct mce *m)
 			 */
 			/*FALL THROUGH*/
 		case MCJ_CTX_PROCESS:
-			raise_uncorrected(m, NULL);
+			raise_exception(m, NULL);
 			break;
 		default:
 			printk(KERN_INFO "Invalid MCE context\n");
@@ -124,7 +124,7 @@ static int raise_local(struct mce *m)
 		printk(KERN_INFO "MCE exception done on CPU %d\n", cpu);
 	} else if (m->status) {
 		printk(KERN_INFO "Starting machine check poll CPU %d\n", cpu);
-		raise_corrected(m);
+		raise_poll(m);
 		mce_notify_irq();
 		printk(KERN_INFO "Machine check poll done on CPU %d\n", cpu);
 	} else
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -44,6 +44,7 @@
 #define MCJ_CTX_PROCESS		1    /* inject context: process */
 #define MCJ_CTX_IRQ		2    /* inject context: IRQ */
 #define MCJ_NMI_BROADCAST	4    /* do NMI broadcasting */
+#define MCJ_EXCEPTION		8    /* raise as exception */
 
 /* Fields are zero when not available */
 struct mce {


