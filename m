Return-Path: <linux-kernel-owner+w=401wt.eu-S1030694AbXD2Rcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030694AbXD2Rcd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbXD2RcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:32:07 -0400
Received: from gw.goop.org ([64.81.55.164]:57194 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030694AbXD2Ras (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:30:48 -0400
Message-Id: <20070429172917.065864000@goop.org>
References: <20070429172835.284784000@goop.org>
User-Agent: quilt/0.46-1
Date: Sun, 29 Apr 2007 10:29:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 32/32] xen: Xen machine operations
Content-Disposition: inline; filename=xen-machine-ops.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make the appropriate hypercalls to halt and reboot the virtual machine.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/xen/enlighten.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 arch/i386/xen/smp.c       |    4 +---
 2 files changed, 44 insertions(+), 3 deletions(-)

===================================================================
--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -14,6 +14,7 @@
 
 #include <xen/interface/xen.h>
 #include <xen/interface/vcpu.h>
+#include <xen/interface/sched.h>
 #include <xen/features.h>
 #include <xen/page.h>
 
@@ -28,6 +29,7 @@
 #include <asm/pgtable.h>
 #include <asm/smp.h>
 #include <asm/tlbflush.h>
+#include <asm/reboot.h>
 
 #include "xen-ops.h"
 #include "mmu.h"
@@ -787,6 +789,45 @@ static const struct smp_ops xen_smp_ops 
 };
 #endif	/* CONFIG_SMP */
 
+static void xen_reboot(int reason)
+{
+#ifdef CONFIG_SMP
+	smp_send_stop();
+#endif
+
+	if (HYPERVISOR_sched_op(SCHEDOP_shutdown, reason))
+		BUG();
+}
+
+static void xen_restart(char *msg)
+{
+	xen_reboot(SHUTDOWN_reboot);
+}
+
+static void xen_emergency_restart(void)
+{
+	xen_reboot(SHUTDOWN_reboot);
+}
+
+static void xen_machine_halt(void)
+{
+	xen_reboot(SHUTDOWN_poweroff);
+}
+
+static void xen_crash_shutdown(struct pt_regs *regs)
+{
+	xen_reboot(SHUTDOWN_crash);
+}
+
+static const struct machine_ops __initdata xen_machine_ops = {
+	.restart = xen_restart,
+	.halt = xen_machine_halt,
+	.power_off = xen_machine_halt,
+	.shutdown = xen_machine_halt,
+	.crash_shutdown = xen_crash_shutdown,
+	.emergency_restart = xen_emergency_restart,
+};
+
 /* First C function to be called on Xen boot */
 static asmlinkage void __init xen_start_kernel(void)
 {
@@ -800,6 +841,8 @@ static asmlinkage void __init xen_start_
 
 	/* Install Xen paravirt ops */
 	paravirt_ops = xen_paravirt_ops;
+	machine_ops = xen_machine_ops;
+
 #ifdef CONFIG_SMP
 	smp_ops = xen_smp_ops;
 #endif
===================================================================
--- a/arch/i386/xen/smp.c
+++ b/arch/i386/xen/smp.c
@@ -303,9 +303,7 @@ static void stop_self(void *v)
 
 void xen_smp_send_stop(void)
 {
-	cpumask_t mask = cpu_online_map;
-	cpu_clear(smp_processor_id(), mask);
-	xen_smp_call_function_mask(mask, stop_self, NULL, 0);
+	smp_call_function(stop_self, NULL, 0, 0);
 }
 
 void xen_smp_send_reschedule(int cpu)

-- 

