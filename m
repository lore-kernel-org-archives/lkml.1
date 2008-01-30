Return-Path: <linux-kernel-owner+w=401wt.eu-S1761777AbYA3VKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761777AbYA3VKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758161AbYA3VFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:05:54 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:51422 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758052AbYA3VFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:05:37 -0500
Message-Id: <20080130210525.547283853@goodmis.org>
References: <20080130210357.927754294@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 30 Jan 2008 16:04:02 -0500
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
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 05/23 -v8] add notrace annotations to vsyscall.
Content-Disposition: inline; filename=mcount-add-x86-vdso-notrace-annotations.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the notrace annotations to some of the vsyscall functions.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/vsyscall_64.c  |    3 ++-
 arch/x86/vdso/vclock_gettime.c |   15 ++++++++-------
 arch/x86/vdso/vgetcpu.c        |    3 ++-
 include/asm-x86/vsyscall.h     |    3 ++-
 4 files changed, 14 insertions(+), 10 deletions(-)

Index: linux-mcount.git/arch/x86/kernel/vsyscall_64.c
===================================================================
--- linux-mcount.git.orig/arch/x86/kernel/vsyscall_64.c	2008-01-30 14:35:51.000000000 -0500
+++ linux-mcount.git/arch/x86/kernel/vsyscall_64.c	2008-01-30 14:47:08.000000000 -0500
@@ -42,7 +42,8 @@
 #include <asm/topology.h>
 #include <asm/vgtod.h>
 
-#define __vsyscall(nr) __attribute__ ((unused,__section__(".vsyscall_" #nr)))
+#define __vsyscall(nr) \
+		__attribute__ ((unused, __section__(".vsyscall_" #nr))) notrace
 #define __syscall_clobber "r11","rcx","memory"
 #define __pa_vsymbol(x)			\
 	({unsigned long v;  		\
Index: linux-mcount.git/arch/x86/vdso/vclock_gettime.c
===================================================================
--- linux-mcount.git.orig/arch/x86/vdso/vclock_gettime.c	2008-01-30 14:35:51.000000000 -0500
+++ linux-mcount.git/arch/x86/vdso/vclock_gettime.c	2008-01-30 14:47:08.000000000 -0500
@@ -24,7 +24,7 @@
 
 #define gtod vdso_vsyscall_gtod_data
 
-static long vdso_fallback_gettime(long clock, struct timespec *ts)
+notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 {
 	long ret;
 	asm("syscall" : "=a" (ret) :
@@ -32,7 +32,7 @@ static long vdso_fallback_gettime(long c
 	return ret;
 }
 
-static inline long vgetns(void)
+notrace static inline long vgetns(void)
 {
 	long v;
 	cycles_t (*vread)(void);
@@ -41,7 +41,7 @@ static inline long vgetns(void)
 	return (v * gtod->clock.mult) >> gtod->clock.shift;
 }
 
-static noinline int do_realtime(struct timespec *ts)
+notrace static noinline int do_realtime(struct timespec *ts)
 {
 	unsigned long seq, ns;
 	do {
@@ -55,7 +55,8 @@ static noinline int do_realtime(struct t
 }
 
 /* Copy of the version in kernel/time.c which we cannot directly access */
-static void vset_normalized_timespec(struct timespec *ts, long sec, long nsec)
+notrace static void
+vset_normalized_timespec(struct timespec *ts, long sec, long nsec)
 {
 	while (nsec >= NSEC_PER_SEC) {
 		nsec -= NSEC_PER_SEC;
@@ -69,7 +70,7 @@ static void vset_normalized_timespec(str
 	ts->tv_nsec = nsec;
 }
 
-static noinline int do_monotonic(struct timespec *ts)
+notrace static noinline int do_monotonic(struct timespec *ts)
 {
 	unsigned long seq, ns, secs;
 	do {
@@ -83,7 +84,7 @@ static noinline int do_monotonic(struct 
 	return 0;
 }
 
-int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
+notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
 	if (likely(gtod->sysctl_enabled && gtod->clock.vread))
 		switch (clock) {
@@ -97,7 +98,7 @@ int __vdso_clock_gettime(clockid_t clock
 int clock_gettime(clockid_t, struct timespec *)
 	__attribute__((weak, alias("__vdso_clock_gettime")));
 
-int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
+notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 {
 	long ret;
 	if (likely(gtod->sysctl_enabled && gtod->clock.vread)) {
Index: linux-mcount.git/arch/x86/vdso/vgetcpu.c
===================================================================
--- linux-mcount.git.orig/arch/x86/vdso/vgetcpu.c	2008-01-30 14:35:51.000000000 -0500
+++ linux-mcount.git/arch/x86/vdso/vgetcpu.c	2008-01-30 14:47:08.000000000 -0500
@@ -13,7 +13,8 @@
 #include <asm/vgtod.h>
 #include "vextern.h"
 
-long __vdso_getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *unused)
+notrace long
+__vdso_getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *unused)
 {
 	unsigned int dummy, p;
 
Index: linux-mcount.git/include/asm-x86/vsyscall.h
===================================================================
--- linux-mcount.git.orig/include/asm-x86/vsyscall.h	2008-01-30 14:35:51.000000000 -0500
+++ linux-mcount.git/include/asm-x86/vsyscall.h	2008-01-30 14:47:08.000000000 -0500
@@ -24,7 +24,8 @@ enum vsyscall_num {
 	((unused, __section__ (".vsyscall_gtod_data"),aligned(16)))
 #define __section_vsyscall_clock __attribute__ \
 	((unused, __section__ (".vsyscall_clock"),aligned(16)))
-#define __vsyscall_fn __attribute__ ((unused,__section__(".vsyscall_fn")))
+#define __vsyscall_fn \
+	__attribute__ ((unused, __section__(".vsyscall_fn"))) notrace
 
 #define VGETCPU_RDTSCP	1
 #define VGETCPU_LSL	2

-- 
