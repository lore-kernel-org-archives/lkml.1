Return-Path: <linux-kernel-owner+w=401wt.eu-S1757029AbYACH0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbYACH0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 02:26:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757605AbYACHY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 02:24:26 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:42050 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbYACHYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 02:24:16 -0500
Message-Id: <20080103072227.568329878@goodmis.org>
References: <20080103071609.478486470@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 03 Jan 2008 02:16:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 06/11] add notrace annotations to vsyscall.
Content-Disposition: inline; filename=mcount-add-x86-vdso-notrace-annotations.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the notrace annotations to some of the vsyscall functions.

Note: checkpatch errors on the define of vsyscall_fn because it thinks
   that it is a complex macro that needs paranthesis. Unfortunately
   we can't put paranthesis on this macro.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/vdso/vclock_gettime.c |   15 ++++++++-------
 arch/x86/vdso/vgetcpu.c        |    3 ++-
 include/asm-x86/vsyscall.h     |    3 ++-
 3 files changed, 12 insertions(+), 9 deletions(-)

Index: linux-compile.git/arch/x86/vdso/vclock_gettime.c
===================================================================
--- linux-compile.git.orig/arch/x86/vdso/vclock_gettime.c	2008-01-02 22:53:52.000000000 -0500
+++ linux-compile.git/arch/x86/vdso/vclock_gettime.c	2008-01-02 22:59:09.000000000 -0500
@@ -24,7 +24,7 @@
 
 #define gtod vdso_vsyscall_gtod_data
 
-static long vdso_fallback_gettime(long clock, struct timespec *ts)
+static long notrace vdso_fallback_gettime(long clock, struct timespec *ts)
 {
 	long ret;
 	asm("syscall" : "=a" (ret) :
@@ -32,7 +32,7 @@ static long vdso_fallback_gettime(long c
 	return ret;
 }
 
-static inline long vgetns(void)
+static inline long notrace vgetns(void)
 {
 	long v;
 	cycles_t (*vread)(void);
@@ -41,7 +41,7 @@ static inline long vgetns(void)
 	return (v * gtod->clock.mult) >> gtod->clock.shift;
 }
 
-static noinline int do_realtime(struct timespec *ts)
+static noinline int notrace do_realtime(struct timespec *ts)
 {
 	unsigned long seq, ns;
 	do {
@@ -55,7 +55,8 @@ static noinline int do_realtime(struct t
 }
 
 /* Copy of the version in kernel/time.c which we cannot directly access */
-static void vset_normalized_timespec(struct timespec *ts, long sec, long nsec)
+static void notrace
+vset_normalized_timespec(struct timespec *ts, long sec, long nsec)
 {
 	while (nsec >= NSEC_PER_SEC) {
 		nsec -= NSEC_PER_SEC;
@@ -69,7 +70,7 @@ static void vset_normalized_timespec(str
 	ts->tv_nsec = nsec;
 }
 
-static noinline int do_monotonic(struct timespec *ts)
+static noinline int notrace do_monotonic(struct timespec *ts)
 {
 	unsigned long seq, ns, secs;
 	do {
@@ -83,7 +84,7 @@ static noinline int do_monotonic(struct 
 	return 0;
 }
 
-int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
+int notrace __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
 	if (likely(gtod->sysctl_enabled && gtod->clock.vread))
 		switch (clock) {
@@ -97,7 +98,7 @@ int __vdso_clock_gettime(clockid_t clock
 int clock_gettime(clockid_t, struct timespec *)
 	__attribute__((weak, alias("__vdso_clock_gettime")));
 
-int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
+int notrace __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 {
 	long ret;
 	if (likely(gtod->sysctl_enabled && gtod->clock.vread)) {
Index: linux-compile.git/arch/x86/vdso/vgetcpu.c
===================================================================
--- linux-compile.git.orig/arch/x86/vdso/vgetcpu.c	2008-01-02 22:53:52.000000000 -0500
+++ linux-compile.git/arch/x86/vdso/vgetcpu.c	2008-01-02 22:59:35.000000000 -0500
@@ -13,7 +13,8 @@
 #include <asm/vgtod.h>
 #include "vextern.h"
 
-long __vdso_getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *unused)
+long notrace
+__vdso_getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *unused)
 {
 	unsigned int dummy, p;
 
Index: linux-compile.git/include/asm-x86/vsyscall.h
===================================================================
--- linux-compile.git.orig/include/asm-x86/vsyscall.h	2008-01-02 22:53:52.000000000 -0500
+++ linux-compile.git/include/asm-x86/vsyscall.h	2008-01-02 23:00:34.000000000 -0500
@@ -24,7 +24,8 @@ enum vsyscall_num {
 	((unused, __section__ (".vsyscall_gtod_data"),aligned(16)))
 #define __section_vsyscall_clock __attribute__ \
 	((unused, __section__ (".vsyscall_clock"),aligned(16)))
-#define __vsyscall_fn __attribute__ ((unused,__section__(".vsyscall_fn")))
+#define __vsyscall_fn __attribute__ \
+	((unused, __section__(".vsyscall_fn"))) notrace
 
 #define VGETCPU_RDTSCP	1
 #define VGETCPU_LSL	2

-- 
