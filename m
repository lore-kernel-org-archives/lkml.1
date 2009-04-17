Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbZDQGkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbZDQGkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759950AbZDQGji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:39:38 -0400
Received: from gw.goop.org ([64.81.55.164]:56729 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756031AbZDQGjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:39:37 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: mathieu.desnoyers@polymtl.ca
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 3/5] x86/paravirt: update tracing for start/end context switch
Date: Thu, 16 Apr 2009 23:39:32 -0700
Message-Id: <1239950374-1252-4-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1239950374-1252-1-git-send-email-jeremy@goop.org>
References: <1239950374-1252-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

lazy_cpu_mode has been replaced with start/end context switch.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/paravirt-trace.h |   31 +++++++++++++++++++++----------
 arch/x86/include/asm/paravirt.h       |    2 ++
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/paravirt-trace.h b/arch/x86/include/asm/paravirt-trace.h
index 2c72964..00e755a 100644
--- a/arch/x86/include/asm/paravirt-trace.h
+++ b/arch/x86/include/asm/paravirt-trace.h
@@ -12,6 +12,7 @@
 
 struct tss_struct;
 struct thread_struct;
+struct task_struct;
 
 /* width for %0*x */
 #define HEX_FIELD(type)	((int)sizeof(type) * 2)
@@ -1119,18 +1120,28 @@ TRACE_EVENT(pmd_clear,
 
 #endif	/* CONFIG_X86_PAE */
 
-TRACE_EVENT(enter_lazy_cpu,
-	    TP_PROTO(int __dummy),
-	    TP_ARGS(__dummy),
-	    ,
-	    ,
+TRACE_EVENT(start_context_switch,
+	    TP_PROTO(struct task_struct *prev),
+	    TP_ARGS(prev),
+	    TP_STRUCT__entry(
+		    __field(struct task_struct *, prev)
+		    ),
+	    TP_fast_assign(
+		    __entry->prev = prev
+		    ),
+	    TP_printk("prev:%p", __entry->prev)
 	);
 
-TRACE_EVENT(leave_lazy_cpu,
-	    TP_PROTO(int __dummy),
-	    TP_ARGS(__dummy),
-	    ,
-	    ,
+TRACE_EVENT(end_context_switch,
+	    TP_PROTO(struct task_struct *next),
+	    TP_ARGS(next),
+	    TP_STRUCT__entry(
+		    __field(struct task_struct *, next)
+		    ),
+	    TP_fast_assign(
+		    __entry->next = next
+		    ),
+	    TP_printk("next:%p", __entry->next)
 	);
 
 TRACE_EVENT(enter_lazy_mmu,
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index fafb965..07b4e97 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -834,11 +834,13 @@ static inline void pmd_clear(pmd_t *pmdp)
 #define  __HAVE_ARCH_START_CONTEXT_SWITCH
 static inline void arch_start_context_switch(struct task_struct *prev)
 {
+	trace_start_context_switch(prev);
 	PVOP_VCALL1(pv_cpu_ops.start_context_switch, prev);
 }
 
 static inline void arch_end_context_switch(struct task_struct *next)
 {
+	trace_end_context_switch(next);
 	PVOP_VCALL1(pv_cpu_ops.end_context_switch, next);
 }
 
-- 
1.6.0.6

