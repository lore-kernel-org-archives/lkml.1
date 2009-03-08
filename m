Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbZCHPwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbZCHPwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 11:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbZCHPv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 11:51:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:34089 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbZCHPv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 11:51:58 -0400
Date: Sun, 8 Mar 2009 15:51:24 GMT
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B142D8.7020601@redhat.com>
References: <49B142D8.7020601@redhat.com>
Subject: [tip:tracing/core] tracing, Text Edit Lock - Architecture Independent Code
Message-ID: <tip-0e39ac444636ff5be39b26f1cb56d79594654dda@git.kernel.org>
Git-Commit-ID: 0e39ac444636ff5be39b26f1cb56d79594654dda
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 08 Mar 2009 15:51:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e39ac444636ff5be39b26f1cb56d79594654dda
Gitweb:     http://git.kernel.org/tip/0e39ac444636ff5be39b26f1cb56d79594654dda
Author:     "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
AuthorDate: Fri, 6 Mar 2009 10:35:52 -0500
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 Mar 2009 16:48:59 +0100

tracing, Text Edit Lock - Architecture Independent Code

This is an architecture independant synchronization around kernel text
modifications through use of a global mutex.

A mutex has been chosen so that kprobes, the main user of this, can sleep
during memory allocation between the memory read of the instructions it
must replace and the memory write of the breakpoint.

Other user of this interface: immediate values.

Paravirt and alternatives are always done when SMP is inactive, so there
is no need to use locks.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
LKML-Reference: <49B142D8.7020601@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/memory.h |    6 ++++++
 mm/memory.c            |   10 ++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/memory.h b/include/linux/memory.h
index 3fdc108..86a6c0f 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
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
diff --git a/mm/memory.c b/mm/memory.c
index baa999e..05fab3b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -48,6 +48,8 @@
 #include <linux/rmap.h>
 #include <linux/module.h>
 #include <linux/delayacct.h>
+#include <linux/kprobes.h>
+#include <linux/mutex.h>
 #include <linux/init.h>
 #include <linux/writeback.h>
 #include <linux/memcontrol.h>
@@ -99,6 +101,14 @@ int randomize_va_space __read_mostly =
 					2;
 #endif
 
+/*
+ * mutex protecting text section modification (dynamic code patching).
+ * some users need to sleep (allocating memory...) while they hold this lock.
+ *
+ * NOT exported to modules - patching kernel text is a really delicate matter.
+ */
+DEFINE_MUTEX(text_mutex);
+
 static int __init disable_randmaps(char *s)
 {
 	randomize_va_space = 0;
