Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbYIWJ3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbYIWJ3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 05:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbYIWJ2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 05:28:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:2588 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbYIWJ2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 05:28:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type;
        b=fgef8MujTr05bN8UEB/9cyMDNHMevGj0U0/gpCu48pCJKVfUNndPG1U6x65ivRWJED
         35VBgP2onscbs24uG5tLAr6p6tX1vQy+zUNDdQ1HqwciWEHBEq48/MgaU7c+tBXlXRUU
         n1Q74SWmuj36xte38nA2aK+AsS3izTcxOOiwg=
Message-ID: <48D8C638.50306@gmail.com>
Date: Tue, 23 Sep 2008 11:34:32 +0100
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Steven Noonan <steven@uplinklabs.net>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [Patch -tip 2/4] Tracing/ftrace: Make tracing suitable to run the
 initcall tracer
Content-Type: multipart/mixed;
 boundary="------------060600070205030603060409"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060600070205030603060409
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The tracing engine have now to be init in early_initcall to set the initcall tracer.
Only the debugfs settings will be initialized at fs_initcall time.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---

--------------060600070205030603060409
Content-Type: text/plain;
 name="patch2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch2.diff"

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f2ef72f..16f1409 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2990,7 +2990,7 @@ struct dentry *tracing_init_dentry(void)
 #include "trace_selftest.c"
 #endif
 
-static __init void tracer_init_debugfs(void)
+static __init int tracer_init_debugfs(void)
 {
 	struct dentry *d_tracer;
 	struct dentry *entry;
@@ -3078,6 +3078,7 @@ static __init void tracer_init_debugfs(void)
 #ifdef CONFIG_SYSPROF_TRACER
 	init_tracer_sysprof_debugfs(d_tracer);
 #endif
+	return 0;
 }
 
 int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
@@ -3504,12 +3505,16 @@ __init static int tracer_alloc_buffers(void)
 		pages, trace_nr_entries, (long)TRACE_ENTRY_SIZE);
 	pr_info("   actual entries %ld\n", global_trace.entries);
 
-	tracer_init_debugfs();
-
 	trace_init_cmdlines();
 
 	register_tracer(&nop_trace);
+#ifdef CONFIG_INITCALL_TRACER
+	register_tracer(&initcall_tracer);
+	current_trace = &initcall_tracer;
+	current_trace->init(&global_trace);
+#else
 	current_trace = &nop_trace;
+#endif
 
 	/* All seems OK, enable tracing */
 	global_trace.ctrl = tracer_enabled;
@@ -3519,7 +3524,6 @@ __init static int tracer_alloc_buffers(void)
 				       &trace_panic_notifier);
 
 	register_die_notifier(&trace_die_notifier);
-
 	return 0;
 
  free_buffers:
@@ -3548,4 +3552,5 @@ __init static int tracer_alloc_buffers(void)
 	}
 	return ret;
 }
-fs_initcall(tracer_alloc_buffers);
+early_initcall(tracer_alloc_buffers);
+fs_initcall(tracer_init_debugfs);

--------------060600070205030603060409--
