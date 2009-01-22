Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbZAVBZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbZAVBZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 20:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756424AbZAVBYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 20:24:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:51913 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349AbZAVBYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 20:24:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:cc:subject;
        b=I0bGtcZEpyTAdv4/fTHygydJsxfwt3ntR6+do9RApq6DKux5Q6Y5nF6hjml6P3LmxY
         lAQPrQQFqwFmYvuJeMs61H+XwYZOgK8tVQBYud7BHDfkmaYnpL7QGzBjYJqI9QDCaPw8
         IxwBvMdgIeNsqgtF+k9wUJLNk27cM5UOAg66A=
Message-ID: <4977cae2.0c58560a.7b05.ffffde44@mx.google.com>
Date: Wed, 21 Jan 2009 17:24:50 -0800 (PST)
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] tracing/function-graph-tracer: drop the kernel_text_address check
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the function graph tracer picks a return address, it ensures this address
is really a kernel text one by calling __kernel_text_address()
Actually this path has never been taken. Its role was more likely to debug the tracer
on the beginning of its development but this function is wasteful since it is called
for every traced function.

The fault check is already sufficient.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/ftrace.c |    7 -------
 kernel/extable.c         |    4 ++--
 kernel/module.c          |    2 +-
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 1b43086..838ff7c 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -511,13 +511,6 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 		return;
 	}
 
-	if (unlikely(!__kernel_text_address(old))) {
-		ftrace_graph_stop();
-		*parent = old;
-		WARN_ON(1);
-		return;
-	}
-
 	calltime = cpu_clock(raw_smp_processor_id());
 
 	if (push_return_trace(old, calltime,
diff --git a/kernel/extable.c b/kernel/extable.c
index e136ed8..0df6253 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -41,7 +41,7 @@ const struct exception_table_entry *search_exception_tables(unsigned long addr)
 	return e;
 }
 
-__notrace_funcgraph int core_kernel_text(unsigned long addr)
+int core_kernel_text(unsigned long addr)
 {
 	if (addr >= (unsigned long)_stext &&
 	    addr <= (unsigned long)_etext)
@@ -54,7 +54,7 @@ __notrace_funcgraph int core_kernel_text(unsigned long addr)
 	return 0;
 }
 
-__notrace_funcgraph int __kernel_text_address(unsigned long addr)
+int __kernel_text_address(unsigned long addr)
 {
 	if (core_kernel_text(addr))
 		return 1;
diff --git a/kernel/module.c b/kernel/module.c
index e8b51d4..b60e5ab 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2720,7 +2720,7 @@ int is_module_address(unsigned long addr)
 
 
 /* Is this a valid kernel address? */
-__notrace_funcgraph struct module *__module_text_address(unsigned long addr)
+struct module *__module_text_address(unsigned long addr)
 {
 	struct module *mod;
 
-- 
1.6.0.4


