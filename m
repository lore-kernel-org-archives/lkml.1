Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbZEWQdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbZEWQdP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 12:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbZEWQc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 12:32:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48985 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbZEWQc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 12:32:58 -0400
Message-Id: <20090523163012.739756497@chello.nl>
References: <20090523162854.599719825@chello.nl>
User-Agent: quilt/0.46-1
Date: Sat, 23 May 2009 18:28:58 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 4/7] perf_counter: fix userspace build
Content-Disposition: inline; filename=perf_counter-userspace-fix-build.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

recent userspace (F11) seems to already include the linux/unistd.h bits
which means we cannot include the version in the kernel sources due to
the header guards being the same.

Ensure we include the kernel version first.

LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/perf_counter/builtin-record.c |    3 --
 Documentation/perf_counter/builtin-stat.c   |    5 ----
 Documentation/perf_counter/builtin-top.c    |    5 ----
 Documentation/perf_counter/perf.h           |   31 +++++++++++++++++-----------
 4 files changed, 22 insertions(+), 22 deletions(-)

Index: linux-2.6/Documentation/perf_counter/builtin-record.c
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/builtin-record.c
+++ linux-2.6/Documentation/perf_counter/builtin-record.c
@@ -1,5 +1,6 @@
 
 
+#include "perf.h"
 #include "util/util.h"
 
 #include <sys/types.h>
@@ -30,9 +31,7 @@
 #include <linux/unistd.h>
 #include <linux/types.h>
 
-#include "../../include/linux/perf_counter.h"
 
-#include "perf.h"
 
 #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
 #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
Index: linux-2.6/Documentation/perf_counter/builtin-stat.c
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/builtin-stat.c
+++ linux-2.6/Documentation/perf_counter/builtin-stat.c
@@ -61,6 +61,7 @@
   * Released under the GPL v2. (and only v2, not any later version)
   */
 
+#include "perf.h"
 #include "util/util.h"
 
 #include <getopt.h>
@@ -83,10 +84,6 @@
 #include <linux/unistd.h>
 #include <linux/types.h>
 
-#include "../../include/linux/perf_counter.h"
-
-#include "perf.h"
-
 #define EVENT_MASK_KERNEL		1
 #define EVENT_MASK_USER			2
 
Index: linux-2.6/Documentation/perf_counter/builtin-top.c
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/builtin-top.c
+++ linux-2.6/Documentation/perf_counter/builtin-top.c
@@ -42,6 +42,7 @@
   * Released under the GPL v2. (and only v2, not any later version)
   */
 
+#include "perf.h"
 #include "util/util.h"
 
 #include <getopt.h>
@@ -64,10 +65,6 @@
 #include <linux/unistd.h>
 #include <linux/types.h>
 
-#include "../../include/linux/perf_counter.h"
-
-#include "perf.h"
-
 static int			system_wide			=  0;
 
 static int			nr_counters			=  0;
Index: linux-2.6/Documentation/perf_counter/perf.h
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/perf.h
+++ linux-2.6/Documentation/perf_counter/perf.h
@@ -1,6 +1,25 @@
 #ifndef _PERF_PERF_H
 #define _PERF_PERF_H
 
+#if defined(__x86_64__) || defined(__i386__)
+#include "../../arch/x86/include/asm/unistd.h"
+#define rmb()		asm volatile("lfence" ::: "memory")
+#define cpu_relax()	asm volatile("rep; nop" ::: "memory");
+#endif
+
+#ifdef __powerpc__
+#include "../../arch/powerpc/include/asm/unistd.h"
+#define rmb()		asm volatile ("sync" ::: "memory")
+#define cpu_relax()	asm volatile ("" ::: "memory");
+#endif
+
+#include <time.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/syscall.h>
+
+#include "../../include/linux/perf_counter.h"
+
 /*
  * prctl(PR_TASK_PERF_COUNTERS_DISABLE) will (cheaply) disable all
  * counters in the current task.
@@ -26,18 +45,6 @@ static inline unsigned long long rdclock
 #define __user
 #define asmlinkage
 
-#if defined(__x86_64__) || defined(__i386__)
-#include "../../arch/x86/include/asm/unistd.h"
-#define rmb()		asm volatile("lfence" ::: "memory")
-#define cpu_relax()	asm volatile("rep; nop" ::: "memory");
-#endif
-
-#ifdef __powerpc__
-#include "../../arch/powerpc/include/asm/unistd.h"
-#define rmb()		asm volatile ("sync" ::: "memory")
-#define cpu_relax()	asm volatile ("" ::: "memory");
-#endif
-
 #define unlikely(x)	__builtin_expect(!!(x), 0)
 #define min(x, y) ({				\
 	typeof(x) _min1 = (x);			\

-- 

