Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbZCXOB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbZCXOB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbZCXOBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:01:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:55004 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbZCXOBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:01:15 -0400
Date: Tue, 24 Mar 2009 14:00:30 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237902017.25315.90.camel@penberg-laptop>
References: <1237902017.25315.90.camel@penberg-laptop>
Subject: [tip:tracing/kmemtrace] kmemtrace: define tracepoints when CONFIG_TRACEPOINTS is enabled
Message-ID: <tip-676a628ddd84753eaba571146e081f98d9a4c757@git.kernel.org>
Git-Commit-ID: 676a628ddd84753eaba571146e081f98d9a4c757
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 14:00:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  676a628ddd84753eaba571146e081f98d9a4c757
Gitweb:     http://git.kernel.org/tip/676a628ddd84753eaba571146e081f98d9a4c757
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Tue, 24 Mar 2009 15:40:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Mar 2009 14:59:05 +0100

kmemtrace: define tracepoints when CONFIG_TRACEPOINTS is enabled

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

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
LKML-Reference: <1237902017.25315.90.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
