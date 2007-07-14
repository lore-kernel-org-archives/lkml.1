Return-Path: <linux-kernel-owner+w=401wt.eu-S1765447AbXGNB26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765447AbXGNB26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764706AbXGNB1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:27:08 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38486 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764812AbXGNB1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:27:05 -0400
Message-Id: <20070714012622.926568381@polymtl.ca>
References: <20070714012439.285079881@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 13 Jul 2007 21:24:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 1/8] Immediate values - Global modules list and module mutex
Content-Disposition: inline; filename=immediate-values-global-modules-list-and-mutex.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat, 14 Jul 2007 01:26:23 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove "static" from module_mutex and the modules list so it can be used by
other builtin objects in the kernel. Otherwise, every code depending on the
module list would have to be put in kernel/module.c. Since the immediate values
depends on the module list but can be considered as logically different, it
makes sense to implement them in their own file.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/module.h |    4 ++++
 kernel/module.c        |    4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2007-07-13 19:30:44.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2007-07-13 20:23:34.000000000 -0400
@@ -65,8 +65,8 @@
 static DEFINE_SPINLOCK(modlist_lock);
 
 /* List of modules, protected by module_mutex AND modlist_lock */
-static DEFINE_MUTEX(module_mutex);
-static LIST_HEAD(modules);
+DEFINE_MUTEX(module_mutex);
+LIST_HEAD(modules);
 static DECLARE_MUTEX(notify_mutex);
 
 static BLOCKING_NOTIFIER_HEAD(module_notify_list);
Index: linux-2.6-lttng/include/linux/module.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/module.h	2007-07-13 20:24:22.000000000 -0400
+++ linux-2.6-lttng/include/linux/module.h	2007-07-13 20:24:26.000000000 -0400
@@ -60,6 +60,10 @@
 	struct kobject *drivers_dir;
 };
 
+/* Protects the list of modules. */
+extern struct mutex module_mutex;
+extern struct list_head modules;
+
 /* These are either module local, or the kernel's dummy ones. */
 extern int init_module(void);
 extern void cleanup_module(void);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
