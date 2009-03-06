Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbZCFPgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbZCFPgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbZCFPgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:36:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60590 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754514AbZCFPgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:36:18 -0500
Message-ID: <49B142D8.7020601@redhat.com>
Date: Fri, 06 Mar 2009 10:35:52 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH -tip 1/4] Text Edit Lock - Architecture Independent Code (v2)
References: <49B1428A.9050500@redhat.com>
In-Reply-To: <49B1428A.9050500@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

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

Index: 2.6.29-rc7/include/linux/memory.h
===================================================================
--- 2.6.29-rc7.orig/include/linux/memory.h
+++ 2.6.29-rc7/include/linux/memory.h
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
Index: 2.6.29-rc7/mm/memory.c
===================================================================
--- 2.6.29-rc7.orig/mm/memory.c
+++ 2.6.29-rc7/mm/memory.c
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
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

