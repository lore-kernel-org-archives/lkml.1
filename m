Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbZCCBar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbZCCBar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 20:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbZCCBaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 20:30:39 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:49937 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbZCCBai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 20:30:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhwFACMXrElMQW1W/2dsb2JhbACBWdMlhAYG
Date: Mon, 2 Mar 2009 20:30:29 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Masami Hiramatsu <mhiramat@redhat.com>,
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
Subject: [PATCH] Text Edit Lock - Architecture Independent Code (v2)
Message-ID: <20090303013029.GA7783@Krystal>
References: <49AC10E9.1090102@redhat.com> <20090302171914.GB21735@Krystal> <49AC5A87.7000604@redhat.com> <20090302222254.GA31962@elte.hu> <49AC63FA.70801@redhat.com> <20090302230915.GA11626@elte.hu> <49AC6DEA.2050304@redhat.com> <20090302234910.GA17956@elte.hu> <20090303000054.GC3906@Krystal> <20090303003237.GA30221@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090303003237.GA30221@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:29:56 up 2 days, 21:56,  4 users,  load average: 0.28, 0.39,
	0.56
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

Changelog :
Export text_mutex directly.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>
---
 include/linux/memory.h |    6 ++++++
 mm/memory.c            |    9 +++++++++
 2 files changed, 15 insertions(+)

Index: linux-2.6-lttng/include/linux/memory.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/memory.h	2009-03-02 13:13:35.000000000 -0500
+++ linux-2.6-lttng/include/linux/memory.h	2009-03-02 19:23:52.000000000 -0500
@@ -99,4 +99,10 @@ enum mem_add_context { BOOT, HOTPLUG };
 #define hotplug_memory_notifier(fn, pri) do { } while (0)
 #endif
 
+/*
+ * Kernel text modification mutex, used for code patching. Users of this lock
+ * can sleep.
+ */
+extern struct mutex text_mutex;
+
 #endif /* _LINUX_MEMORY_H_ */
Index: linux-2.6-lttng/mm/memory.c
===================================================================
--- linux-2.6-lttng.orig/mm/memory.c	2009-03-02 13:13:35.000000000 -0500
+++ linux-2.6-lttng/mm/memory.c	2009-03-02 19:24:33.000000000 -0500
@@ -48,6 +48,8 @@
 #include <linux/rmap.h>
 #include <linux/module.h>
 #include <linux/delayacct.h>
+#include <linux/kprobes.h>
+#include <linux/mutex.h>
 #include <linux/init.h>
 #include <linux/writeback.h>
 #include <linux/memcontrol.h>
@@ -99,6 +101,13 @@ int randomize_va_space __read_mostly =
 					2;
 #endif
 
+/*
+ * mutex protecting text section modification (dynamic code patching).
+ * some users need to sleep (allocating memory...) while they hold this lock.
+ */
+DEFINE_MUTEX(text_mutex);
+EXPORT_SYMBOL_GPL(text_mutex);
+
 static int __init disable_randmaps(char *s)
 {
 	randomize_va_space = 0;
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
