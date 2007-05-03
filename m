Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbXECUKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbXECUKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbXECUKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:10:20 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:37632 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754037AbXECUKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:10:19 -0400
Message-Id: <20070503200822.696754319@mvista.com>
User-Agent: quilt/0.46-1
Date: Thu, 03 May 2007 13:08:22 -0700
From: Daniel Walker <dwalker@mvista.com>
To: mingo@elte.hu
Cc: srostedt@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH -rt] wrong usage of smp_processor_id()
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Found this while debugging with Steve .. trace_hardirqs_on() isn't always 
called with interrupt off.

 BUG: using smp_processor_id() in preemptible [00000000] code: init/1

 caller is trace_hardirqs_on+0x16/0xe0
  [<c01054b1>] show_trace_log_lvl+0x21/0x50
  [<c0105c82>] show_trace+0x12/0x20
  [<c0105d56>] dump_stack+0x16/0x20
  [<c022c819>] debug_smp_processor_id+0xa9/0xb0
  [<c0152a76>] trace_hardirqs_on+0x16/0xe0
  [<c0103975>] do_notify_resume+0x115/0x7b0
  [<c01044f4>] work_notifysig+0x13/0x1b
  =======================
 ---------------------------
 | preempt count: 00000001 ]
 | 1-level deep critical section nesting:
 ----------------------------------------
 .. [<c022c7c3>] .... debug_smp_processor_id+0x53/0xb0
 .....[<c0152a76>] ..   ( <= trace_hardirqs_on+0x16/0xe0)


Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 kernel/latency_trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21/kernel/latency_trace.c
===================================================================
--- linux-2.6.21.orig/kernel/latency_trace.c
+++ linux-2.6.21/kernel/latency_trace.c
@@ -105,7 +105,7 @@ static inline int DEBUG_WARN_ON(int cond
 #ifdef CONFIG_CRITICAL_IRQSOFF_TIMING
 # ifdef CONFIG_CRITICAL_PREEMPT_TIMING
    static DEFINE_PER_CPU(int, trace_cpu_idle);
-#  define irqs_off_preempt_count() (!__get_cpu_var(trace_cpu_idle) && preempt_count())
+#  define irqs_off_preempt_count() (preempt_count() && !__get_cpu_var(trace_cpu_idle))
 # else
 #  define irqs_off_preempt_count() 0
 # endif
-- 

-- 
