Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbZBGXWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbZBGXWR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 18:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756269AbZBGXVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 18:21:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:21589 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbZBGXVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 18:21:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:date:to:cc:subject;
        b=kz4c+aq6We6am5OdMtved2a3KznxI4Y0U2Id059QxWW3yUI3fF8djhBXkp9R8n7IYb
         aOYKg7WZfOXe3DJIUTdv72h3frlVNk8jwLSPTDQlic1pubOvE7MvN5+mcb/cwhLsgzX3
         zxBkRHC0/NyEyHnKlzR8aQm6whz9UTN5z1bO8=
Message-ID: <498e1784.1438560a.641c.2d82@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Sun, 8 Feb 2009 00:04:02 +0100
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5][RESEND] tracing/function-graph-tracer: drop the kernel_text_address check
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the function graph tracer picks a return address, it ensures this address
is really a kernel text one by calling __kernel_text_address()
Actually this path has never been taken. Its role was more likely to debug the tracer
on the beginning of its development but this function is wasteful since it is called
for every traced function.

The fault check is already sufficient.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/ftrace.c |    7 -------
 kernel/extable.c         |    4 ++--
 kernel/module.c          |    2 +-
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 4d33224..a9e7c43 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -510,13 +510,6 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
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
index ba22484..22d7379 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2735,7 +2735,7 @@ int is_module_address(unsigned long addr)
 
 
 /* Is this a valid kernel address? */
-__notrace_funcgraph struct module *__module_text_address(unsigned long addr)
+struct module *__module_text_address(unsigned long addr)
 {
 	struct module *mod;
 
-- 
1.6.1


