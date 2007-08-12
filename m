Return-Path: <linux-kernel-owner+w=401wt.eu-S936619AbXHLPLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936619AbXHLPLx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936220AbXHLPIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:08:46 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47592 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936105AbXHLPIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:08:44 -0400
Message-Id: <20070812150814.037498091@polymtl.ca>
References: <20070812150702.769065566@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 11:07:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 1/8] Immediate Values - Global Modules List and Module Mutex
Content-Disposition: inline; filename=immediate-values-global-modules-list-and-mutex.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 15:08:14 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove "static" from module_mutex and the modules list so it can be used by
other builtin objects in the kernel. Otherwise, every code depending on the
module list would have to be put in kernel/module.c. Since the immediate values
depends on the module list but can be considered as logically different, it
makes sense to implement them in their own file.

The alternative to this would be to disable preemption in code path that need
such synchronization, so they can be protected against module unload by
stop_machine(), but not being able to sleep within while needing such
synchronization is limiting.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/module.h |    4 ++++
 kernel/module.c        |    4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2007-08-07 11:03:56.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2007-08-07 11:40:22.000000000 -0400
@@ -64,8 +64,8 @@ extern int module_sysfs_initialized;
 
 /* List of modules, protected by module_mutex or preempt_disable
  * (add/delete uses stop_machine). */
-static DEFINE_MUTEX(module_mutex);
-static LIST_HEAD(modules);
+DEFINE_MUTEX(module_mutex);
+LIST_HEAD(modules);
 static DECLARE_MUTEX(notify_mutex);
 
 static BLOCKING_NOTIFIER_HEAD(module_notify_list);
Index: linux-2.6-lttng/include/linux/module.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/module.h	2007-08-07 11:03:48.000000000 -0400
+++ linux-2.6-lttng/include/linux/module.h	2007-08-07 11:39:55.000000000 -0400
@@ -60,6 +60,10 @@ struct module_kobject
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
