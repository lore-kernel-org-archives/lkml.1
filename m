Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbYBJHXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbYBJHXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757963AbYBJHUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:20:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56824 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757924AbYBJHUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:20:34 -0500
Date: Sun, 10 Feb 2008 08:20:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Steven Rostedt <rostedt@goodmis.org>
Subject: [07/19] x86: add notrace annotations to vsyscall.
Message-ID: <20080210072022.GH4100@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add the notrace annotations to the vsyscall functions - there we are
not in kernel context yet, so the tracer function cannot (and must not)
be called.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/vsyscall_64.c  |    3 ++-
 arch/x86/vdso/vclock_gettime.c |   15 ++++++++-------
 arch/x86/vdso/vgetcpu.c        |    3 ++-
 include/asm-x86/vsyscall.h     |    3 ++-
 4 files changed, 14 insertions(+), 10 deletions(-)

Index: linux/arch/x86/kernel/vsyscall_64.c
===================================================================
--- linux.orig/arch/x86/kernel/vsyscall_64.c
+++ linux/arch/x86/kernel/vsyscall_64.c
@@ -42,7 +42,8 @@
 #include <asm/topology.h>
 #include <asm/vgtod.h>
 
-#define __vsyscall(nr) __attribute__ ((unused,__section__(".vsyscall_" #nr)))
+#define __vsyscall(nr) \
+		__attribute__ ((unused, __section__(".vsyscall_" #nr))) notrace
 #define __syscall_clobber "r11","cx","memory"
 #define __pa_vsymbol(x)			\
 	({unsigned long v;  		\
Index: linux/arch/x86/vdso/vclock_gettime.c
===================================================================
--- linux.orig/arch/x86/vdso/vclock_gettime.c
+++ linux/arch/x86/vdso/vclock_gettime.c
@@ -23,7 +23,7 @@
 
 #define gtod vdso_vsyscall_gtod_data
 
-static long vdso_fallback_gettime(long clock, struct timespec *ts)
+notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 {
 	long ret;
 	asm("syscall" : "=a" (ret) :
@@ -31,7 +31,7 @@ static long vdso_fallback_gettime(long c
 	return ret;
 }
 
-static inline long vgetns(void)
+notrace static inline long vgetns(void)
 {
 	long v;
 	cycles_t (*vread)(void);
@@ -40,7 +40,7 @@ static inline long vgetns(void)
 	return (v * gtod->clock.mult) >> gtod->clock.shift;
 }
 
-static noinline int do_realtime(struct timespec *ts)
+notrace static noinline int do_realtime(struct timespec *ts)
 {
 	unsigned long seq, ns;
 	do {
@@ -54,7 +54,8 @@ static noinline int do_realtime(struct t
 }
 
 /* Copy of the version in kernel/time.c which we cannot directly access */
-static void vset_normalized_timespec(struct timespec *ts, long sec, long nsec)
+notrace static void
+vset_normalized_timespec(struct timespec *ts, long sec, long nsec)
 {
 	while (nsec >= NSEC_PER_SEC) {
 		nsec -= NSEC_PER_SEC;
@@ -68,7 +69,7 @@ static void vset_normalized_timespec(str
 	ts->tv_nsec = nsec;
 }
 
-static noinline int do_monotonic(struct timespec *ts)
+notrace static noinline int do_monotonic(struct timespec *ts)
 {
 	unsigned long seq, ns, secs;
 	do {
@@ -82,7 +83,7 @@ static noinline int do_monotonic(struct 
 	return 0;
 }
 
-int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
+notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
 	if (likely(gtod->sysctl_enabled && gtod->clock.vread))
 		switch (clock) {
@@ -96,7 +97,7 @@ int __vdso_clock_gettime(clockid_t clock
 int clock_gettime(clockid_t, struct timespec *)
 	__attribute__((weak, alias("__vdso_clock_gettime")));
 
-int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
+notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 {
 	long ret;
 	if (likely(gtod->sysctl_enabled && gtod->clock.vread)) {
Index: linux/arch/x86/vdso/vgetcpu.c
===================================================================
--- linux.orig/arch/x86/vdso/vgetcpu.c
+++ linux/arch/x86/vdso/vgetcpu.c
@@ -13,7 +13,8 @@
 #include <asm/vgtod.h>
 #include "vextern.h"
 
-long __vdso_getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *unused)
+notrace long
+__vdso_getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *unused)
 {
 	unsigned int p;
 
Index: linux/include/asm-x86/vsyscall.h
===================================================================
--- linux.orig/include/asm-x86/vsyscall.h
+++ linux/include/asm-x86/vsyscall.h
@@ -24,7 +24,8 @@ enum vsyscall_num {
 	((unused, __section__ (".vsyscall_gtod_data"),aligned(16)))
 #define __section_vsyscall_clock __attribute__ \
 	((unused, __section__ (".vsyscall_clock"),aligned(16)))
-#define __vsyscall_fn __attribute__ ((unused,__section__(".vsyscall_fn")))
+#define __vsyscall_fn \
+	__attribute__ ((unused, __section__(".vsyscall_fn"))) notrace
 
 #define VGETCPU_RDTSCP	1
 #define VGETCPU_LSL	2
