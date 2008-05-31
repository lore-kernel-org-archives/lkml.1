Return-Path: <linux-kernel-owner+w=401wt.eu-S1756344AbYEaAez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbYEaAez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbYEaAdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:33:53 -0400
Received: from host217-43-228-68.range217-43.btcentralplus.com ([217.43.228.68]:41963
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755283AbYEaAdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:33:51 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 3] xen: resume timers on all vcpus
X-Mercurial-Node: 8c350584ea558b265d112a3a686621d3ac5f860f
Message-Id: <8c350584ea558b265d11.1212193983@localhost>
In-Reply-To: <patchbomb.1212193981@localhost>
Date: Sat, 31 May 2008 01:33:03 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On resume, the vcpu timer modes will not be restored.  The timer
infrastructure doesn't do this for us, since it assumes the cpus
are offline.  We can just poke the other vcpus into the right mode
directly though.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

---
 arch/x86/xen/suspend.c |    1 +
 arch/x86/xen/time.c    |   13 +++++++++++++
 arch/x86/xen/xen-ops.h |    1 +
 3 files changed, 15 insertions(+)

diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -38,6 +38,7 @@
 		xen_cpu_initialized_map = cpu_online_map;
 #endif
 		xen_vcpu_restore();
+		xen_timer_resume();
 	}
 
 }
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -565,6 +565,19 @@
 	clockevents_register_device(&__get_cpu_var(xen_clock_events));
 }
 
+void xen_timer_resume(void)
+{
+	int cpu;
+
+	if (xen_clockevent != &xen_vcpuop_clockevent)
+		return;
+
+	for_each_online_cpu(cpu) {
+		if (HYPERVISOR_vcpu_op(VCPUOP_stop_periodic_timer, cpu, NULL))
+			BUG();
+	}
+}
+
 __init void xen_time_init(void)
 {
 	int cpu = smp_processor_id();
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -37,6 +37,7 @@
 unsigned long xen_get_wallclock(void);
 int xen_set_wallclock(unsigned long time);
 unsigned long long xen_sched_clock(void);
+void xen_timer_resume(void);
 
 irqreturn_t xen_debug_interrupt(int irq, void *dev_id);
 


