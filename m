Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbYEaAeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbYEaAeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbYEaAdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:33:51 -0400
Received: from host217-43-228-68.range217-43.btcentralplus.com ([217.43.228.68]:41962
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752219AbYEaAdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:33:50 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 3] xen: restore vcpu_info mapping
X-Mercurial-Node: ff53af5c5b6e79f4fe7b947b1dc50a0bd737a238
Message-Id: <ff53af5c5b6e79f4fe7b.1212193982@localhost>
In-Reply-To: <patchbomb.1212193981@localhost>
Date: Sat, 31 May 2008 01:33:02 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we're using vcpu_info mapping, then make sure its restored on all
processors before relasing them from stop_machine.

The only complication is that if this fails, we can't continue because
we've already made assumptions that the mapping is available (baked in
calls to the _direct versions of the functions, for example).

Fortunately this can only happen with a 32-bit hypervisor, which may
possibly run out of mapping space.  On a 64-bit hypervisor, this is a
non-issue.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   30 +++++++++++++++++++++++++++++-
 arch/x86/xen/suspend.c   |    4 +++-
 arch/x86/xen/xen-ops.h   |    1 +
 3 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -98,7 +98,7 @@
  */
 static int have_vcpu_info_placement = 1;
 
-static void __init xen_vcpu_setup(int cpu)
+static void xen_vcpu_setup(int cpu)
 {
 	struct vcpu_register_vcpu_info info;
 	int err;
@@ -133,6 +133,34 @@
 
 		printk(KERN_DEBUG "cpu %d using vcpu_info at %p\n",
 		       cpu, vcpup);
+	}
+}
+
+/*
+ * On restore, set the vcpu placement up again.
+ * If it fails, then we're in a bad state, since
+ * we can't back out from using it...
+ */
+void xen_vcpu_restore(void)
+{
+	if (have_vcpu_info_placement) {
+		int cpu;
+
+		for_each_online_cpu(cpu) {
+			bool other_cpu = (cpu != smp_processor_id());
+
+			if (other_cpu &&
+			    HYPERVISOR_vcpu_op(VCPUOP_down, cpu, NULL))
+				BUG();
+
+			xen_vcpu_setup(cpu);
+
+			if (other_cpu &&
+			    HYPERVISOR_vcpu_op(VCPUOP_up, cpu, NULL))
+				BUG();
+		}
+
+		BUG_ON(!have_vcpu_info_placement);
 	}
 }
 
diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -26,6 +26,8 @@
 
 void xen_post_suspend(int suspend_cancelled)
 {
+	xen_setup_shared_info();
+
 	if (suspend_cancelled) {
 		xen_start_info->store_mfn =
 			pfn_to_mfn(xen_start_info->store_mfn);
@@ -35,8 +37,8 @@
 #ifdef CONFIG_SMP
 		xen_cpu_initialized_map = cpu_online_map;
 #endif
+		xen_vcpu_restore();
 	}
 
-	xen_setup_shared_info();
 }
 
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -26,6 +26,7 @@
 void __init xen_arch_setup(void);
 void __init xen_init_IRQ(void);
 void xen_enable_sysenter(void);
+void xen_vcpu_restore(void);
 
 void __init xen_build_dynamic_phys_to_machine(void);
 


