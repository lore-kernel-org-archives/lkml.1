Return-Path: <linux-kernel-owner+w=401wt.eu-S1760432AbZCXNkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760432AbZCXNkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbZCXNkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:40:22 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39303 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbZCXNkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:40:21 -0400
Subject: [PATCH] kmemtrace: define tracepoints when CONFIG_TRACEPOINTS is
	enabled
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
Date: Tue, 24 Mar 2009 15:40:17 +0200
Message-Id: <1237902017.25315.90.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Impact: fix build

If CONFIG_KMEMTRACE is disabled but CONFIG_TRACEPOINTS is enabled, we need to
define the tracepoints; otherwise linkage fails:

    LD      .tmp_vmlinux1
  arch/x86/kernel/built-in.o: In function `sys_ioperm':
  (.text+0x3743): undefined reference to `__tracepoint_kmalloc'
  arch/x86/kernel/built-in.o: In function `sys_ioperm':
  (.text+0x3784): undefined reference to `__tracepoint_kmalloc'
  arch/x86/kernel/built-in.o: In function `cache_sysfs_init':
  intel_cacheinfo.c:(.cpuinit.text+0x5f3): undefined reference to `__tracepoint_kmalloc'
  intel_cacheinfo.c:(.cpuinit.text+0x768): undefined reference to `__tracepoint_kmalloc'
  arch/x86/mm/built-in.o: In function `reserve_memtype':
  (.text+0x2fb3): undefined reference to `__tracepoint_kmalloc'

Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 kernel/trace/kmemtrace.c |   15 ---------------
 mm/util.c                |   16 ++++++++++++++++
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 53b9c7c..5011f4d 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -17,21 +17,6 @@
 #include "trace_output.h"
 #include "trace.h"
 
-/* Tracepoints definitions. */
-DEFINE_TRACE(kmalloc);
-DEFINE_TRACE(kmem_cache_alloc);
-DEFINE_TRACE(kmalloc_node);
-DEFINE_TRACE(kmem_cache_alloc_node);
-DEFINE_TRACE(kfree);
-DEFINE_TRACE(kmem_cache_free);
-
-EXPORT_TRACEPOINT_SYMBOL(kmalloc);
-EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
-EXPORT_TRACEPOINT_SYMBOL(kmalloc_node);
-EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc_node);
-EXPORT_TRACEPOINT_SYMBOL(kfree);
-EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);
-
 /* Select an alternative, minimalistic output than the original one */
 #define TRACE_KMEM_OPT_MINIMAL	0x1
 
diff --git a/mm/util.c b/mm/util.c
index 37eaccd..8d4b900 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -4,6 +4,7 @@
 #include <linux/module.h>
 #include <linux/err.h>
 #include <linux/sched.h>
+#include <linux/tracepoint.h>
 #include <asm/uaccess.h>
 
 /**
@@ -206,3 +207,18 @@ int __attribute__((weak)) get_user_pages_fast(unsigned long start,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(get_user_pages_fast);
+
+/* Tracepoints definitions. */
+DEFINE_TRACE(kmalloc);
+DEFINE_TRACE(kmem_cache_alloc);
+DEFINE_TRACE(kmalloc_node);
+DEFINE_TRACE(kmem_cache_alloc_node);
+DEFINE_TRACE(kfree);
+DEFINE_TRACE(kmem_cache_free);
+
+EXPORT_TRACEPOINT_SYMBOL(kmalloc);
+EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
+EXPORT_TRACEPOINT_SYMBOL(kmalloc_node);
+EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc_node);
+EXPORT_TRACEPOINT_SYMBOL(kfree);
+EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);
-- 
1.5.4.3



