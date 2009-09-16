Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbZIPIo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbZIPIo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757789AbZIPIm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:42:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:43151 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbZIPImy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:42:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,396,1249282800"; 
   d="scan'208";a="448946663"
From: Sheng Yang <sheng@linux.intel.com>
To: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jun Nakajima <jun.nakajima@intel.com>, Eddie Dong <eddie.dong@intel.com>,
       linux-kernel@vger.kernel.org, xen-devel <xen-devel@lists.xensource.com>,
       Sheng Yang <sheng@linux.intel.com>
Subject: [RFC][PATCH 05/10] xen/hybrid: Add PV halt support
Date: Wed, 16 Sep 2009 16:42:26 +0800
Message-Id: <1253090551-7969-6-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1253090551-7969-1-git-send-email-sheng@linux.intel.com>
References: <1253090551-7969-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/xen/enlighten.c |    2 ++
 arch/x86/xen/irq.c       |   10 ++++++++++
 arch/x86/xen/xen-ops.h   |    1 +
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index b290d65..b95c696 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1122,5 +1122,7 @@ void __init xen_start_hybrid(void)
 	r = init_hybrid_info();
 	if (r < 0)
 		return;
+
+	xen_hybrid_init_irq_ops();
 }
 
diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
index cfd1779..52885c1 100644
--- a/arch/x86/xen/irq.c
+++ b/arch/x86/xen/irq.c
@@ -98,6 +98,10 @@ PV_CALLEE_SAVE_REGS_THUNK(xen_irq_enable);
 
 static void xen_safe_halt(void)
 {
+	/* Do local_irq_enable() explicitly in hybrid guest */
+	if (xen_hybrid_enabled())
+		local_irq_enable();
+
 	/* Blocking includes an implicit local_irq_enable(). */
 	if (HYPERVISOR_sched_op(SCHEDOP_block, NULL) != 0)
 		BUG();
@@ -130,3 +134,9 @@ void __init xen_init_irq_ops()
 {
 	pv_irq_ops = xen_irq_ops;
 }
+
+void __init xen_hybrid_init_irq_ops(void)
+{
+	pv_irq_ops.safe_halt = xen_safe_halt;
+	pv_irq_ops.halt = xen_halt;
+}
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index ca6596b..9bb90d5 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -43,6 +43,7 @@ void xen_vcpu_restore(void);
 void __init xen_build_dynamic_phys_to_machine(void);
 
 void xen_init_irq_ops(void);
+void xen_hybrid_init_irq_ops(void);
 void xen_setup_timer(int cpu);
 void xen_teardown_timer(int cpu);
 cycle_t xen_clocksource_read(void);
-- 
1.5.4.5

