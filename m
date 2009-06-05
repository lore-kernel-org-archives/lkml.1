Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbZFEDMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbZFEDMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 23:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbZFEDLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 23:11:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:14380 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbZFEDLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 23:11:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,308,1241420400"; 
   d="scan'208";a="150923527"
Subject: [PATCH 2/2 -v2] x86: MCE: Support specifying raise mode for
 software MCE injection
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 05 Jun 2009 11:11:48 +0800
Message-Id: <1244171508.8361.495.camel@yhuang-dev.sh.intel.com>
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
@@ -43,7 +43,7 @@ static void inject_mce(struct mce *m)
 	i->finished = 1;
 }
 
-static void raise_corrected(struct mce *m)
+static void raise_poll(struct mce *m)
 {
 	unsigned long flags;
 	mce_banks_t b;
@@ -55,7 +55,7 @@ static void raise_corrected(struct mce *
 	m->finished = 0;
 }
 
-static void raise_uncorrected(struct mce *m, struct pt_regs *pregs)
+static void raise_exception(struct mce *m, struct pt_regs *pregs)
 {
 	struct pt_regs regs;
 	unsigned long flags;
@@ -84,10 +84,10 @@ static int mce_raise_notify(struct notif
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
 
@@ -103,7 +103,7 @@ static int raise_local(struct mce *m)
 	int ret = 0;
 	int cpu = m->extcpu;
 
-	if (m->status & MCI_STATUS_UC) {
+	if (m->inject_flags & MCJ_EXCEPTION) {
 		printk(KERN_INFO "Triggering MCE exception on CPU %d\n", cpu);
 		switch (context) {
 		case MCJ_CTX_IRQ:
@@ -114,7 +114,7 @@ static int raise_local(struct mce *m)
 			 */
 			/*FALL THROUGH*/
 		case MCJ_CTX_PROCESS:
-			raise_uncorrected(m, NULL);
+			raise_exception(m, NULL);
 			break;
 		default:
 			printk(KERN_INFO "Invalid MCE context\n");
@@ -123,7 +123,7 @@ static int raise_local(struct mce *m)
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


