Return-Path: <linux-kernel-owner+w=401wt.eu-S1757166AbYGYWEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166AbYGYWEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 18:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbYGYWDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 18:03:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52243 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbYGYWDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 18:03:36 -0400
Message-Id: <20080725220334.931959350@goodmis.org>
References: <20080725220040.911370182@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 25 Jul 2008 18:00:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>
Cc: Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] ftrace: disable tracing on acpi idle calls
Content-Disposition: inline; filename=ftrace-stop-tracing-acpi-mwait.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The acpi idle waits calls local_irq_save and then uses mwait to go into
idle. The tracer gets reenabled at local_irq_save but does not detect that
the idle allows for wake ups.

This patch adds code to disable the tracing when acpi puts the CPU to idle.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

Index: linux-tip.git/drivers/acpi/processor_idle.c
===================================================================
--- linux-tip.git.orig/drivers/acpi/processor_idle.c
+++ linux-tip.git/drivers/acpi/processor_idle.c
@@ -272,6 +272,8 @@ static atomic_t c3_cpu_count;
 /* Common C-state entry for C2, C3, .. */
 static void acpi_cstate_enter(struct acpi_processor_cx *cstate)
 {
+	/* Don't trace irqs off for idle */
+	stop_critical_timings();
 	if (cstate->entry_method == ACPI_CSTATE_FFH) {
 		/* Call into architectural FFH based C-state */
 		acpi_processor_ffh_cstate_enter(cstate);
@@ -284,6 +286,7 @@ static void acpi_cstate_enter(struct acp
 		   gets asserted in time to freeze execution properly. */
 		unused = inl(acpi_gbl_FADT.xpm_timer_block.address);
 	}
+	start_critical_timings();
 }
 #endif /* !CONFIG_CPU_IDLE */
 
@@ -1418,6 +1421,8 @@ static inline void acpi_idle_update_bm_r
  */
 static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
 {
+	/* Don't trace irqs off for idle */
+	stop_critical_timings();
 	if (cx->entry_method == ACPI_CSTATE_FFH) {
 		/* Call into architectural FFH based C-state */
 		acpi_processor_ffh_cstate_enter(cx);
@@ -1432,6 +1437,7 @@ static inline void acpi_idle_do_entry(st
 		   gets asserted in time to freeze execution properly. */
 		unused = inl(acpi_gbl_FADT.xpm_timer_block.address);
 	}
+	start_critical_timings();
 }
 
 /**

-- 
