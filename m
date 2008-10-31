Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbYJaTuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbYJaTuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 15:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbYJaTuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 15:50:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57497 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbYJaTun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 15:50:43 -0400
Date: Fri, 31 Oct 2008 19:50:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: rostedt@goodmis.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Re: alpha: undefined reference to `save_stack_trace'
Message-ID: <20081031195040.GV28946@ZenIV.linux.org.uk>
References: <20081031165751.GA13558@x200.localdomain> <20081031182411.GR28946@ZenIV.linux.org.uk> <20081031184822.GS28946@ZenIV.linux.org.uk> <20081031185526.GT28946@ZenIV.linux.org.uk> <20081031190608.GU28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031190608.GU28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 07:06:08PM +0000, Al Viro wrote:
> On Fri, Oct 31, 2008 at 06:55:26PM +0000, Al Viro wrote:
> 
> > It's too ugly for words, but it does deal with this mess ;-/
> 
> ... doesn't.  Unfortunately.

... since we also need to ifdef out the guts of ftrace_trace_stack().
We also want to disallow setting TRACE_ITER_STACKTRACE in trace_flags
on such configs, but that can wait.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index b58f43b..33dbefd 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -25,7 +25,7 @@ config TRACING
 	bool
 	select DEBUG_FS
 	select RING_BUFFER
-	select STACKTRACE
+	select STACKTRACE if STACKTRACE_SUPPORT
 	select TRACEPOINTS
 	select NOP_TRACER
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8a499e2..85bee77 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -705,6 +705,7 @@ static void ftrace_trace_stack(struct trace_array *tr,
 			       unsigned long flags,
 			       int skip, int pc)
 {
+#ifdef CONFIG_STACKTRACE
 	struct ring_buffer_event *event;
 	struct stack_entry *entry;
 	struct stack_trace trace;
@@ -730,6 +731,7 @@ static void ftrace_trace_stack(struct trace_array *tr,
 
 	save_stack_trace(&trace);
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+#endif
 }
 
 void __trace_stack(struct trace_array *tr,
