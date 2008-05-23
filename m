Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbYEWOST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbYEWOST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 10:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbYEWOSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 10:18:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:42821 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbYEWOSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 10:18:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=xYHrECdlC9Ub/sF9ifjW8KCIv+zhhHDGaQFfuDaIQmtqg9nx4ULn3DgkuvgJnNmnVnEgNYtL1SiZAPaX+xXsBw5cf6h2yqeEVDBDyNAimKIP47fYadx9lV9Z45URw9Llrc27/shW2IbLPaA799GxaNBFuC1Y2ZJsdr6rCTFFF2M=
Date: Fri, 23 May 2008 16:17:59 +0200
To: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kmemcheck: SMP support
Message-ID: <20080523141759.GA1833@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This works on real hw, but not on qemu. It seems to get stuck waiting for one
of the atomic values to change. Don't know why yet, it might just be yet
another bug in qemu... (we've hit at least two of them so far. And they were
real bugs too.)

But do you think this approach is feasible? It will kill interactivity,
that's for sure, though only when kmemcheck is run-time enabled and number
of CPUs > 1 (the more the worse).


Vegard


From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 23 May 2008 15:53:03 +0200
Subject: [PATCH] kmemcheck: SMP support

This patch adds SMP support to kmemcheck, that is, the ability to boot
more than one processor even when kmemcheck is enabled. (Previously,
only one CPU would be booted even if more were present in the system.)

On page fault, kmemcheck needs to pause all the other CPUs in the system
in order to guarantee that no other CPU will modify the same memory
location (which will otherwise be unprotected after we set the present
bit of the PTE).

Since the page fault can be taken with any irq state (i.e. enabled or
disabled), we can't send a normal IPI broadcast since this can deadlock.

Instead, we send an NMI. This is guaranteed to be received _except_ if
the processor is already inside the NMI handler.

This is of course not very efficient, and booting with maxcpus=1 is
recommended, however, this allows the kernel to be configured with
CONFIG_KMEMCHECK=y with close to zero overhead when kmemcheck is
disabled. (It can still be runtime-enabled at any time, though.)

The patch has been tested on real hardware.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/kernel/kmemcheck.c |  108 +++++++++++++++++++++++++++++++++++++++----
 1 files changed, 98 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/kmemcheck.c b/arch/x86/kernel/kmemcheck.c
index c0045e8..fdf8acb 100644
--- a/arch/x86/kernel/kmemcheck.c
+++ b/arch/x86/kernel/kmemcheck.c
@@ -16,6 +16,7 @@
 #include <linux/kmemcheck.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/notifier.h>
 #include <linux/page-flags.h>
 #include <linux/percpu.h>
 #include <linux/stacktrace.h>
@@ -23,9 +24,12 @@
 #include <asm/cacheflush.h>
 #include <asm/kmemcheck.h>
 #include <asm/pgtable.h>
+#include <asm/smp.h>
 #include <asm/string.h>
 #include <asm/tlbflush.h>
 
+#include <mach_ipi.h>
+
 enum shadow {
 	SHADOW_UNALLOCATED,
 	SHADOW_UNINITIALIZED,
@@ -240,18 +244,91 @@ static void do_wakeup(unsigned long data)
 	}
 }
 
+static atomic_t nmi_wait;
+static atomic_t nmi_resume;
+static atomic_t started;
+static atomic_t finished;
+
+static int nmi_notifier(struct notifier_block *self,
+	unsigned long val, void *data)
+{
+	struct die_args *args = (struct die_args *) data;
+
+	if (val != DIE_NMI_IPI || !atomic_read(&nmi_wait))
+		return NOTIFY_DONE;
+
+	atomic_inc(&started);
+
+	/* Pause until the fault has been handled */
+	while (!atomic_read(&nmi_resume))
+		cpu_relax();
+
+	atomic_inc(&finished);
+
+	return NOTIFY_STOP;
+}
+
+static void
+pause_allbutself(void)
+{
+#ifdef CONFIG_SMP
+	static spinlock_t nmi_spinlock;
+
+	int cpus;
+	cpumask_t mask = cpu_online_map;
+
+	spin_lock(&nmi_spinlock);
+
+	cpus = num_online_cpus() - 1;
+
+	atomic_set(&started, 0);
+	atomic_set(&finished, 0);
+	atomic_set(&nmi_wait, 1);
+	atomic_set(&nmi_resume, 0);
+
+	cpu_clear(safe_smp_processor_id(), mask);
+	if (!cpus_empty(mask))
+		send_IPI_mask(mask, NMI_VECTOR);
+
+	while (atomic_read(&started) != cpus)
+		cpu_relax();
+
+	atomic_set(&nmi_wait, 0);
+
+	spin_unlock(&nmi_spinlock);
+#endif
+}
+
+static void
+resume(void)
+{
+#ifdef CONFIG_SMP
+	int cpus;
+
+	cpus = num_online_cpus() - 1;
+
+	atomic_set(&nmi_resume, 1);
+
+	while (atomic_read(&finished) != cpus)
+		cpu_relax();
+#endif
+}
+
+#ifdef CONFIG_SMP
+static struct notifier_block nmi_nb = {
+	.notifier_call = &nmi_notifier,
+};
+#endif
+
 void __init kmemcheck_init(void)
 {
+	int err;
+
 	printk(KERN_INFO "kmemcheck: \"Bugs, beware!\"\n");
 
 #ifdef CONFIG_SMP
-	/* Limit SMP to use a single CPU. We rely on the fact that this code
-	 * runs before SMP is set up. */
-	if (setup_max_cpus > 1) {
-		printk(KERN_INFO
-			"kmemcheck: Limiting number of CPUs to 1.\n");
-		setup_max_cpus = 1;
-	}
+	err = register_die_notifier(&nmi_nb);
+	BUG_ON(err);
 #endif
 }
 
@@ -376,11 +453,14 @@ void kmemcheck_show(struct pt_regs *regs)
 
 	BUG_ON(!irqs_disabled());
 
+	pause_allbutself();
+
 	if (unlikely(data->balance != 0)) {
 		show_addr(data->addr1);
 		show_addr(data->addr2);
 		error_save_bug(regs);
 		data->balance = 0;
+		resume();
 		return;
 	}
 
@@ -390,8 +470,10 @@ void kmemcheck_show(struct pt_regs *regs)
 
 	/* None of the addresses actually belonged to kmemcheck. Note that
 	 * this is not an error. */
-	if (n == 0)
+	if (n == 0) {
+		resume();
 		return;
+	}
 
 	++data->balance;
 
@@ -421,8 +503,10 @@ void kmemcheck_hide(struct pt_regs *regs)
 
 	BUG_ON(!irqs_disabled());
 
-	if (data->balance == 0)
+	if (data->balance == 0) {
+		resume();
 		return;
+	}
 
 	if (unlikely(data->balance != 1)) {
 		show_addr(data->addr1);
@@ -436,6 +520,7 @@ void kmemcheck_hide(struct pt_regs *regs)
 			regs->flags &= ~X86_EFLAGS_TF;
 		if (data->flags & X86_EFLAGS_IF)
 			regs->flags |= X86_EFLAGS_IF;
+		resume();
 		return;
 	}
 
@@ -448,8 +533,10 @@ void kmemcheck_hide(struct pt_regs *regs)
 		n += show_addr(data->addr2);
 	}
 
-	if (n == 0)
+	if (n == 0) {
+		resume();
 		return;
+	}
 
 	--data->balance;
 
@@ -460,6 +547,7 @@ void kmemcheck_hide(struct pt_regs *regs)
 		regs->flags &= ~X86_EFLAGS_TF;
 	if (data->flags & X86_EFLAGS_IF)
 		regs->flags |= X86_EFLAGS_IF;
+	resume();
 }
 
 void kmemcheck_show_pages(struct page *p, unsigned int n)
-- 
1.5.4.1

