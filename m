Return-Path: <linux-kernel-owner+w=401wt.eu-S936544AbZLQEaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936544AbZLQEaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935774AbZLQE3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:29:50 -0500
Received: from kroah.org ([198.145.64.141]:55713 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935690AbZLQEEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:47 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:54 2009
Message-Id: <20091217035653.884061164@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [085/151] xen: re-register runstate area earlier on resume.
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Campbell <Ian.Campbell@citrix.com>

commit be012920ecba161ad20303a3f6d9e96c58cf97c7 upstream.

This is necessary to ensure the runstate area is available to
xen_sched_clock before any calls to printk which will require it in
order to provide a timestamp.

I chose to pull the xen_setup_runstate_info out of xen_time_init into
the caller in order to maintain parity with calling
xen_setup_runstate_info separately from calling xen_time_resume.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/enlighten.c |    2 ++
 arch/x86/xen/time.c      |    5 ++---
 arch/x86/xen/xen-ops.h   |    1 +
 3 files changed, 5 insertions(+), 3 deletions(-)

--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -148,6 +148,8 @@ void xen_vcpu_restore(void)
 			    HYPERVISOR_vcpu_op(VCPUOP_down, cpu, NULL))
 				BUG();
 
+			xen_setup_runstate_info(cpu);
+
 			xen_vcpu_setup(cpu);
 
 			if (other_cpu &&
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -100,7 +100,7 @@ bool xen_vcpu_stolen(int vcpu)
 	return per_cpu(runstate, vcpu).state == RUNSTATE_runnable;
 }
 
-static void setup_runstate_info(int cpu)
+void xen_setup_runstate_info(int cpu)
 {
 	struct vcpu_register_runstate_memory_area area;
 
@@ -442,8 +442,6 @@ void xen_setup_timer(int cpu)
 
 	evt->cpumask = cpumask_of(cpu);
 	evt->irq = irq;
-
-	setup_runstate_info(cpu);
 }
 
 void xen_teardown_timer(int cpu)
@@ -494,6 +492,7 @@ __init void xen_time_init(void)
 
 	setup_force_cpu_cap(X86_FEATURE_TSC);
 
+	xen_setup_runstate_info(cpu);
 	xen_setup_timer(cpu);
 	xen_setup_cpu_clockevents();
 }
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -41,6 +41,7 @@ void __init xen_build_dynamic_phys_to_ma
 
 void xen_init_irq_ops(void);
 void xen_setup_timer(int cpu);
+void xen_setup_runstate_info(int cpu);
 void xen_teardown_timer(int cpu);
 cycle_t xen_clocksource_read(void);
 void xen_setup_cpu_clockevents(void);


