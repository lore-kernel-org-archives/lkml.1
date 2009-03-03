Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbZCCACF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbZCCACF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758851AbZCCAA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:00:59 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:57491 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758853AbZCCAA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:00:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhwFABsBrElMQW1W/2dsb2JhbACBWdNYhAYG
Date: Mon, 2 Mar 2009 19:00:54 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH] Text Edit Lock - Architecture Independent Code
Message-ID: <20090303000054.GC3906@Krystal>
References: <20090227185316.GA19811@Krystal> <49A853CD.3020607@redhat.com> <49AC10E9.1090102@redhat.com> <20090302171914.GB21735@Krystal> <49AC5A87.7000604@redhat.com> <20090302222254.GA31962@elte.hu> <49AC63FA.70801@redhat.com> <20090302230915.GA11626@elte.hu> <49AC6DEA.2050304@redhat.com> <20090302234910.GA17956@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090302234910.GA17956@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:00:29 up 2 days, 20:26,  3 users,  load average: 0.55, 0.62,
	0.58
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an architecture independant synchronization around kernel text
modifications through use of a global mutex.

A mutex has been chosen so that kprobes, the main user of this, can sleep during
memory allocation between the memory read of the instructions it must replace
and the memory write of the breakpoint.

Other user of this interface: immediate values.

Paravirt and alternatives are always done when SMP is inactive, so there is no
need to use locks.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>
---
 include/linux/memory.h |    7 +++++++
 mm/memory.c            |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

Index: linux-2.6-lttng/include/linux/memory.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/memory.h	2009-01-30 09:47:59.000000000 -0500
+++ linux-2.6-lttng/include/linux/memory.h	2009-01-30 10:25:33.000000000 -0500
@@ -99,4 +99,11 @@ enum mem_add_context { BOOT, HOTPLUG };
 #define hotplug_memory_notifier(fn, pri) do { } while (0)
 #endif
 
+/*
+ * Take and release the kernel text modification lock, used for code patching.
+ * Users of this lock can sleep.
+ */
+extern void kernel_text_lock(void);
+extern void kernel_text_unlock(void);
+
 #endif /* _LINUX_MEMORY_H_ */
Index: linux-2.6-lttng/mm/memory.c
===================================================================
--- linux-2.6-lttng.orig/mm/memory.c	2009-01-30 09:47:59.000000000 -0500
+++ linux-2.6-lttng/mm/memory.c	2009-01-30 10:26:01.000000000 -0500
@@ -48,6 +48,8 @@
 #include <linux/rmap.h>
 #include <linux/module.h>
 #include <linux/delayacct.h>
+#include <linux/kprobes.h>
+#include <linux/mutex.h>
 #include <linux/init.h>
 #include <linux/writeback.h>
 #include <linux/memcontrol.h>
@@ -99,6 +101,12 @@ int randomize_va_space __read_mostly =
 					2;
 #endif
 
+/*
+ * mutex protecting text section modification (dynamic code patching).
+ * some users need to sleep (allocating memory...) while they hold this lock.
+ */
+static DEFINE_MUTEX(text_mutex);
+
 static int __init disable_randmaps(char *s)
 {
 	randomize_va_space = 0;
@@ -3192,3 +3200,29 @@ void might_fault(void)
 }
 EXPORT_SYMBOL(might_fault);
 #endif
+
+/**
+ * kernel_text_lock     -   Take the kernel text modification lock
+ *
+ * Insures mutual write exclusion of kernel and modules text live text
+ * modification. Should be used for code patching.
+ * Users of this lock can sleep.
+ */
+void __kprobes kernel_text_lock(void)
+{
+	mutex_lock(&text_mutex);
+}
+EXPORT_SYMBOL_GPL(kernel_text_lock);
+
+/**
+ * kernel_text_unlock   -   Release the kernel text modification lock
+ *
+ * Insures mutual write exclusion of kernel and modules text live text
+ * modification. Should be used for code patching.
+ * Users of this lock can sleep.
+ */
+void __kprobes kernel_text_unlock(void)
+{
+	mutex_unlock(&text_mutex);
+}
+EXPORT_SYMBOL_GPL(kernel_text_unlock);

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
