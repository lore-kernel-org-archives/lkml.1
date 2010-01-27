Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207Ab0A0WOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0A0WOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 17:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196Ab0A0WOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 17:14:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40923 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab0A0WOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 17:14:06 -0500
Message-Id: <20100127221121.967610372@chello.nl>
References: <20100127220745.027096123@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 27 Jan 2010 23:07:46 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, eranian@google.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/4] perf_events: x86: Fix event constraint masks
Content-Disposition: inline; filename=perf-fix-constraint-mask.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since constraints are specified on the event number, not number and
unit mask shorten the constraint masks so that we'll actually match
something.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
---
 arch/x86/include/asm/perf_event.h |    2 +-
 arch/x86/kernel/cpu/perf_event.c  |   13 +++++++++----
 2 files changed, 10 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -100,12 +100,17 @@ struct cpu_hw_events {
 	.weight = HWEIGHT64((u64)(n)),	\
 }
 
-#define INTEL_EVENT_CONSTRAINT(c, n)		EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
-#define FIXED_EVENT_CONSTRAINT(c, n)		EVENT_CONSTRAINT(c, n, INTEL_ARCH_FIXED_MASK)
+#define INTEL_EVENT_CONSTRAINT(c, n)	\
+	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVTSEL_MASK)
 
-#define EVENT_CONSTRAINT_END			EVENT_CONSTRAINT(0, 0, 0)
+#define FIXED_EVENT_CONSTRAINT(c, n)	\
+	EVENT_CONSTRAINT(c, n, INTEL_ARCH_FIXED_MASK)
 
-#define for_each_event_constraint(e, c)		for ((e) = (c); (e)->cmask; (e)++)
+#define EVENT_CONSTRAINT_END		\
+	EVENT_CONSTRAINT(0, 0, 0)
+
+#define for_each_event_constraint(e, c)	\
+	for ((e) = (c); (e)->cmask; (e)++)
 
 /*
  * struct x86_pmu - generic x86 pmu
Index: linux-2.6/arch/x86/include/asm/perf_event.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/perf_event.h
+++ linux-2.6/arch/x86/include/asm/perf_event.h
@@ -50,7 +50,7 @@
 	 INTEL_ARCH_INV_MASK| \
 	 INTEL_ARCH_EDGE_MASK|\
 	 INTEL_ARCH_UNIT_MASK|\
-	 INTEL_ARCH_EVENT_MASK)
+	 INTEL_ARCH_EVTSEL_MASK)
 
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		      0x3c
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK		(0x00 << 8)

-- 

