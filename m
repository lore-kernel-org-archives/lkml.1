Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840Ab0A2Jat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab0A2Jat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824Ab0A2Jaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:30:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:57548 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979Ab0A2Jao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:30:44 -0500
Date: Fri, 29 Jan 2010 09:29:53 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100127221121.967610372@chello.nl>
References: <20100127221121.967610372@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events, x86: Fix event constraint masks
Message-ID: <tip-ed8777fc132e589d48a0ba854fdbb5d8203b58e5@git.kernel.org>
Git-Commit-ID: ed8777fc132e589d48a0ba854fdbb5d8203b58e5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:29:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ed8777fc132e589d48a0ba854fdbb5d8203b58e5
Gitweb:     http://git.kernel.org/tip/ed8777fc132e589d48a0ba854fdbb5d8203b58e5
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 27 Jan 2010 23:07:46 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Jan 2010 09:01:46 +0100

perf_events, x86: Fix event constraint masks

Since constraints are specified on the event number, not number
and unit mask shorten the constraint masks so that we'll
actually match something.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <20100127221121.967610372@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/perf_event.h |    2 +-
 arch/x86/kernel/cpu/perf_event.c  |   13 +++++++++----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index dbc0826..ff5ede1 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -49,7 +49,7 @@
 	 INTEL_ARCH_INV_MASK| \
 	 INTEL_ARCH_EDGE_MASK|\
 	 INTEL_ARCH_UNIT_MASK|\
-	 INTEL_ARCH_EVENT_MASK)
+	 INTEL_ARCH_EVTSEL_MASK)
 
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		      0x3c
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK		(0x00 << 8)
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 07fa0c2..951213a 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
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
