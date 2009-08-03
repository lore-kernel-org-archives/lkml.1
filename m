Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbZHCIOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbZHCIOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 04:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbZHCIOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 04:14:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:56365 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbZHCIOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 04:14:07 -0400
Date: Mon, 3 Aug 2009 08:12:51 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       davem@davemloft.net, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       davem@davemloft.net, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090802140809.7ec4bb6b.akpm@linux-foundation.org>
References: <20090802140809.7ec4bb6b.akpm@linux-foundation.org>
Subject: [tip:core/debug] debug lockups: Improve lockup detection, fix generic arch fallback
Message-ID: <tip-47cab6a722d44c71c4f8224017ef548522243cf4@git.kernel.org>
Git-Commit-ID: 47cab6a722d44c71c4f8224017ef548522243cf4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 03 Aug 2009 08:12:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47cab6a722d44c71c4f8224017ef548522243cf4
Gitweb:     http://git.kernel.org/tip/47cab6a722d44c71c4f8224017ef548522243cf4
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 3 Aug 2009 09:31:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 3 Aug 2009 09:56:52 +0200

debug lockups: Improve lockup detection, fix generic arch fallback

As Andrew noted, my previous patch ("debug lockups: Improve lockup
detection") broke/removed SysRq-L support from architecture that do
not provide a __trigger_all_cpu_backtrace implementation.

Restore a fallback path and clean up the SysRq-L machinery a bit:

 - Rename the arch method to arch_trigger_all_cpu_backtrace()

 - Simplify the define

 - Document the method a bit - in the hope of more architectures
   adding support for it.

[ The patch touches Sparc code for the rename. ]

Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>
LKML-Reference: <20090802140809.7ec4bb6b.akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/sparc/include/asm/irq_64.h |    4 ++--
 arch/sparc/kernel/process_64.c  |    4 ++--
 arch/x86/include/asm/nmi.h      |    4 ++--
 arch/x86/kernel/apic/nmi.c      |    2 +-
 drivers/char/sysrq.c            |   15 ++++++++++++++-
 include/linux/nmi.h             |   19 +++++++++++++++++--
 6 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/arch/sparc/include/asm/irq_64.h b/arch/sparc/include/asm/irq_64.h
index 1934f2c..a0b443c 100644
--- a/arch/sparc/include/asm/irq_64.h
+++ b/arch/sparc/include/asm/irq_64.h
@@ -89,8 +89,8 @@ static inline unsigned long get_softint(void)
 	return retval;
 }
 
-void __trigger_all_cpu_backtrace(void);
-#define trigger_all_cpu_backtrace() __trigger_all_cpu_backtrace()
+void arch_trigger_all_cpu_backtrace(void);
+#define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
 
 extern void *hardirq_stack[NR_CPUS];
 extern void *softirq_stack[NR_CPUS];
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index 4041f94..18d6785 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -251,7 +251,7 @@ static void __global_reg_poll(struct global_reg_snapshot *gp)
 	}
 }
 
-void __trigger_all_cpu_backtrace(void)
+void arch_trigger_all_cpu_backtrace(void)
 {
 	struct thread_info *tp = current_thread_info();
 	struct pt_regs *regs = get_irq_regs();
@@ -304,7 +304,7 @@ void __trigger_all_cpu_backtrace(void)
 
 static void sysrq_handle_globreg(int key, struct tty_struct *tty)
 {
-	__trigger_all_cpu_backtrace();
+	arch_trigger_all_cpu_backtrace();
 }
 
 static struct sysrq_key_op sparc_globalreg_op = {
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index c86e5ed..e63cf7d 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -45,8 +45,8 @@ extern int proc_nmi_enabled(struct ctl_table *, int , struct file *,
 			void __user *, size_t *, loff_t *);
 extern int unknown_nmi_panic;
 
-void __trigger_all_cpu_backtrace(void);
-#define trigger_all_cpu_backtrace() __trigger_all_cpu_backtrace()
+void arch_trigger_all_cpu_backtrace(void);
+#define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
 
 static inline void localise_nmi_watchdog(void)
 {
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index 1bb1ac2..db72202 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -554,7 +554,7 @@ int do_nmi_callback(struct pt_regs *regs, int cpu)
 	return 0;
 }
 
-void __trigger_all_cpu_backtrace(void)
+void arch_trigger_all_cpu_backtrace(void)
 {
 	int i;
 
diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index 165f307..50eecfe 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -223,7 +223,20 @@ static DECLARE_WORK(sysrq_showallcpus, sysrq_showregs_othercpus);
 
 static void sysrq_handle_showallcpus(int key, struct tty_struct *tty)
 {
-	trigger_all_cpu_backtrace();
+	/*
+	 * Fall back to the workqueue based printing if the
+	 * backtrace printing did not succeed or the
+	 * architecture has no support for it:
+	 */
+	if (!trigger_all_cpu_backtrace()) {
+		struct pt_regs *regs = get_irq_regs();
+
+		if (regs) {
+			printk(KERN_INFO "CPU%d:\n", smp_processor_id());
+			show_regs(regs);
+		}
+		schedule_work(&sysrq_showallcpus);
+	}
 }
 
 static struct sysrq_key_op sysrq_showallcpus_op = {
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 29af2d5..b752e80 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -28,8 +28,23 @@ static inline void acpi_nmi_disable(void) { }
 static inline void acpi_nmi_enable(void) { }
 #endif
 
-#ifndef trigger_all_cpu_backtrace
-#define trigger_all_cpu_backtrace() do { } while (0)
+/*
+ * Create trigger_all_cpu_backtrace() out of the arch-provided
+ * base function. Return whether such support was available,
+ * to allow calling code to fall back to some other mechanism:
+ */
+#ifdef arch_trigger_all_cpu_backtrace
+static inline bool trigger_all_cpu_backtrace(void)
+{
+	arch_trigger_all_cpu_backtrace();
+
+	return true;
+}
+#else
+static inline bool trigger_all_cpu_backtrace(void)
+{
+	return false;
+}
 #endif
 
 #endif
