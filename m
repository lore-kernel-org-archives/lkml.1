Return-Path: <linux-kernel-owner+w=401wt.eu-S1760575AbXJLVos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575AbXJLVos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 17:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760311AbXJLVof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 17:44:35 -0400
Received: from 224.sub-75-208-255.myvzw.com ([75.208.255.224]:42254 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759997AbXJLVoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 17:44:34 -0400
X-Greylist: delayed 684 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Oct 2007 17:44:34 EDT
Message-Id: <20071012211147.944148000@goop.org>
References: <20071012211132.198718000@goop.org>
User-Agent: quilt/0.46-1
Date: Fri, 12 Oct 2007 14:11:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Keir Fraser <keir@xensource.com>
Subject: [PATCH 03/10] xen: yield to IPI target if necessary
Content-Disposition: inline; filename=xen-ipi-yield.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When sending a call-function IPI to a vcpu, yield if the vcpu isn't
running.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/xen/smp.c     |   14 ++++++++++----
 arch/i386/xen/time.c    |    6 ++++++
 arch/i386/xen/xen-ops.h |    2 ++
 3 files changed, 18 insertions(+), 4 deletions(-)

===================================================================
--- a/arch/i386/xen/smp.c
+++ b/arch/i386/xen/smp.c
@@ -360,7 +360,8 @@ int xen_smp_call_function_mask(cpumask_t
 			       void *info, int wait)
 {
 	struct call_data_struct data;
-	int cpus;
+	int cpus, cpu;
+	bool yield;
 
 	/* Holding any lock stops cpus from going down. */
 	spin_lock(&call_lock);
@@ -389,9 +390,14 @@ int xen_smp_call_function_mask(cpumask_t
 	/* Send a message to other CPUs and wait for them to respond */
 	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
 
-	/* Make sure other vcpus get a chance to run.
-	   XXX too severe?  Maybe we should check the other CPU's states? */
-	HYPERVISOR_sched_op(SCHEDOP_yield, 0);
+	/* Make sure other vcpus get a chance to run if they need to. */
+	yield = false;
+	for_each_cpu_mask(cpu, mask)
+		if (xen_vcpu_stolen(cpu))
+			yield = true;
+
+	if (yield)
+		HYPERVISOR_sched_op(SCHEDOP_yield, 0);
 
 	/* Wait for response */
 	while (atomic_read(&data.started) != cpus ||
===================================================================
--- a/arch/i386/xen/time.c
+++ b/arch/i386/xen/time.c
@@ -103,6 +103,12 @@ static void get_runstate_snapshot(struct
 		*res = *state;
 		barrier();
 	} while (get64(&state->state_entry_time) != state_time);
+}
+
+/* return true when a vcpu could run but has no real cpu to run on */
+bool xen_vcpu_stolen(int vcpu)
+{
+	return per_cpu(runstate, vcpu).state == RUNSTATE_runnable;
 }
 
 static void setup_runstate_info(int cpu)
===================================================================
--- a/arch/i386/xen/xen-ops.h
+++ b/arch/i386/xen/xen-ops.h
@@ -27,6 +27,8 @@ int xen_set_wallclock(unsigned long time
 int xen_set_wallclock(unsigned long time);
 unsigned long long xen_sched_clock(void);
 
+bool xen_vcpu_stolen(int vcpu);
+
 void xen_mark_init_mm_pinned(void);
 
 DECLARE_PER_CPU(enum paravirt_lazy_mode, xen_lazy_mode);

-- 

