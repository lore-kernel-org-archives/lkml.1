Return-Path: <linux-kernel-owner+w=401wt.eu-S933747AbZLFOHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933747AbZLFOHl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 09:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932334AbZLFOHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 09:07:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59667 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286AbZLFOH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 09:07:29 -0500
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20091206307.542816612@firstfloor.org>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [1/2] perf: Make location of kernel source configurable
Date: Sun,  6 Dec 2009 15:07:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


tools/perf has no support for separate object directories
and lots of hard coded paths assuming that the kernel source
is always in ../..

As a first step of compiling it separately without messing
up clean source trees allow to configure the kernel source
location using a KERNELSRC variable 

This allows at least to copy the whole tools/perf
directory elsewhere and build it separately.

The default is still ../.., so for a standard build
nothing changes

This also removes a lot of ugly ../.. from the source.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 tools/perf/Makefile                    |   12 +++++++-----
 tools/perf/perf.h                      |   16 ++++++++--------
 tools/perf/util/header.h               |    2 +-
 tools/perf/util/include/linux/list.h   |    2 +-
 tools/perf/util/include/linux/poison.h |    2 +-
 tools/perf/util/include/linux/rbtree.h |    2 +-
 tools/perf/util/util.h                 |    2 +-
 7 files changed, 20 insertions(+), 18 deletions(-)

Index: linux-2.6.32-ak/tools/perf/Makefile
===================================================================
--- linux-2.6.32-ak.orig/tools/perf/Makefile
+++ linux-2.6.32-ak/tools/perf/Makefile
@@ -146,6 +146,8 @@ all::
 # your external grep (e.g., if your system lacks grep, if its grep is
 # broken, or spawning external process is slower than built-in grep perf has).
 
+KERNELSRC := ../..
+
 PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN
 -include PERF-VERSION-FILE
@@ -259,7 +261,7 @@ SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powe
 # Those must not be GNU-specific; they are shared with perl/ which may
 # be built by a different compiler. (Note that this is an artifact now
 # but it still might be nice to keep that distinction.)
-BASIC_CFLAGS = -Iutil/include
+BASIC_CFLAGS = -Iutil/include -I $(KERNELSRC)
 BASIC_LDFLAGS =
 
 # Guard against environment variables
@@ -324,9 +326,9 @@ export PERL_PATH
 
 LIB_FILE=libperf.a
 
-LIB_H += ../../include/linux/perf_event.h
-LIB_H += ../../include/linux/rbtree.h
-LIB_H += ../../include/linux/list.h
+LIB_H += $(KERNELSRC)/include/linux/perf_event.h
+LIB_H += $(KERNELSRC)/include/linux/rbtree.h
+LIB_H += $(KERNELSRC)/include/linux/list.h
 LIB_H += util/include/linux/list.h
 LIB_H += perf.h
 LIB_H += util/types.h
@@ -784,7 +786,7 @@ builtin-init-db.o: builtin-init-db.c PER
 util/config.o: util/config.c PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $*.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
-util/rbtree.o: ../../lib/rbtree.c PERF-CFLAGS
+util/rbtree.o: $(KERNELSRC)/lib/rbtree.c PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o util/rbtree.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
 perf-%$X: %.o $(PERFLIBS)
Index: linux-2.6.32-ak/tools/perf/perf.h
===================================================================
--- linux-2.6.32-ak.orig/tools/perf/perf.h
+++ linux-2.6.32-ak/tools/perf/perf.h
@@ -2,31 +2,31 @@
 #define _PERF_PERF_H
 
 #if defined(__i386__)
-#include "../../arch/x86/include/asm/unistd.h"
+#include "arch/x86/include/asm/unistd.h"
 #define rmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
 #endif
 
 #if defined(__x86_64__)
-#include "../../arch/x86/include/asm/unistd.h"
+#include "arch/x86/include/asm/unistd.h"
 #define rmb()		asm volatile("lfence" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
 #endif
 
 #ifdef __powerpc__
-#include "../../arch/powerpc/include/asm/unistd.h"
+#include "arch/powerpc/include/asm/unistd.h"
 #define rmb()		asm volatile ("sync" ::: "memory")
 #define cpu_relax()	asm volatile ("" ::: "memory");
 #endif
 
 #ifdef __s390__
-#include "../../arch/s390/include/asm/unistd.h"
+#include "arch/s390/include/asm/unistd.h"
 #define rmb()		asm volatile("bcr 15,0" ::: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory");
 #endif
 
 #ifdef __sh__
-#include "../../arch/sh/include/asm/unistd.h"
+#include "arch/sh/include/asm/unistd.h"
 #if defined(__SH4A__) || defined(__SH5__)
 # define rmb()		asm volatile("synco" ::: "memory")
 #else
@@ -36,13 +36,13 @@
 #endif
 
 #ifdef __hppa__
-#include "../../arch/parisc/include/asm/unistd.h"
+#include "arch/parisc/include/asm/unistd.h"
 #define rmb()		asm volatile("" ::: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory");
 #endif
 
 #ifdef __sparc__
-#include "../../arch/sparc/include/asm/unistd.h"
+#include "arch/sparc/include/asm/unistd.h"
 #define rmb()		asm volatile("":::"memory")
 #define cpu_relax()	asm volatile("":::"memory")
 #endif
@@ -52,7 +52,7 @@
 #include <sys/types.h>
 #include <sys/syscall.h>
 
-#include "../../include/linux/perf_event.h"
+#include "include/linux/perf_event.h"
 #include "util/types.h"
 
 /*
Index: linux-2.6.32-ak/tools/perf/util/header.h
===================================================================
--- linux-2.6.32-ak.orig/tools/perf/util/header.h
+++ linux-2.6.32-ak/tools/perf/util/header.h
@@ -1,7 +1,7 @@
 #ifndef _PERF_HEADER_H
 #define _PERF_HEADER_H
 
-#include "../../../include/linux/perf_event.h"
+#include "include/linux/perf_event.h"
 #include <sys/types.h>
 #include "types.h"
 
Index: linux-2.6.32-ak/tools/perf/util/include/linux/list.h
===================================================================
--- linux-2.6.32-ak.orig/tools/perf/util/include/linux/list.h
+++ linux-2.6.32-ak/tools/perf/util/include/linux/list.h
@@ -1,4 +1,4 @@
-#include "../../../../include/linux/list.h"
+#include "include/linux/list.h"
 
 #ifndef PERF_LIST_H
 #define PERF_LIST_H
Index: linux-2.6.32-ak/tools/perf/util/include/linux/poison.h
===================================================================
--- linux-2.6.32-ak.orig/tools/perf/util/include/linux/poison.h
+++ linux-2.6.32-ak/tools/perf/util/include/linux/poison.h
@@ -1 +1 @@
-#include "../../../../include/linux/poison.h"
+#include "include/linux/poison.h"
Index: linux-2.6.32-ak/tools/perf/util/include/linux/rbtree.h
===================================================================
--- linux-2.6.32-ak.orig/tools/perf/util/include/linux/rbtree.h
+++ linux-2.6.32-ak/tools/perf/util/include/linux/rbtree.h
@@ -1 +1 @@
-#include "../../../../include/linux/rbtree.h"
+#include "include/linux/rbtree.h"
Index: linux-2.6.32-ak/tools/perf/util/util.h
===================================================================
--- linux-2.6.32-ak.orig/tools/perf/util/util.h
+++ linux-2.6.32-ak/tools/perf/util/util.h
@@ -77,7 +77,7 @@
 #include <netdb.h>
 #include <pwd.h>
 #include <inttypes.h>
-#include "../../../include/linux/magic.h"
+#include "include/linux/magic.h"
 
 
 #ifndef NO_ICONV
