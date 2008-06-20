Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbYFTRFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbYFTRFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 13:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYFTRFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 13:05:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbYFTRFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 13:05:44 -0400
Message-ID: <485BE2C6.1080901@redhat.com>
Date: Fri, 20 Jun 2008 13:03:02 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Hideo AOKI <haoki@redhat.com>
Subject: [RFC][Patch 2/2] markers: example of irq regular kernel markers
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add trace points of irq handle events ported from LTTng's markers.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
I just rewrote LTTng's irq event by using DEFINE_TRACE for example.

 include/linux/irq_trace.h |    6 ++++++
 kernel/irq/handle.c       |    6 ++++++
 2 files changed, 12 insertions(+)

Index: 2.6.26-rc5-mm3/include/linux/irq_trace.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ 2.6.26-rc5-mm3/include/linux/irq_trace.h	2008-06-16 12:27:51.000000000 -0400
@@ -0,0 +1,6 @@
+#include <linux/marker.h>
+
+DEFINE_TRACE(irq_entry, (int irq_id, int kernel_mode), irq_id, kernel_mode);
+
+DEFINE_TRACE(irq_exit, (void));
+
Index: 2.6.26-rc5-mm3/kernel/irq/handle.c
===================================================================
--- 2.6.26-rc5-mm3.orig/kernel/irq/handle.c	2008-06-16 12:27:50.000000000 -0400
+++ 2.6.26-rc5-mm3/kernel/irq/handle.c	2008-06-16 12:27:51.000000000 -0400
@@ -15,6 +15,7 @@
 #include <linux/random.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
+#include <linux/irq_trace.h>

 #include "internals.h"

@@ -130,6 +131,9 @@ irqreturn_t handle_IRQ_event(unsigned in
 {
 	irqreturn_t ret, retval = IRQ_NONE;
 	unsigned int status = 0;
+	struct pt_regs *regs = get_irq_regs();
+
+	trace_irq_entry(irq, (regs)?(!user_mode(regs)):(1));

 	handle_dynamic_tick(action);

@@ -148,6 +152,8 @@ irqreturn_t handle_IRQ_event(unsigned in
 		add_interrupt_randomness(irq);
 	local_irq_disable();

+	trace_irq_exit();
+
 	return retval;
 }

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

