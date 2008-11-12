Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbYKLM3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbYKLM3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbYKLM1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:27:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46257 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbYKLM1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:27:53 -0500
Date: Wed, 12 Nov 2008 13:27:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH] tracing: branch tracer, fix vdso crash
Message-ID: <20081112122715.GA16918@elte.hu>
References: <20081112051438.843792214@goodmis.org> <20081112051518.503323629@goodmis.org> <20081112112536.GC31958@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112112536.GC31958@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2b7d0390a6d6d595f43ea3806639664afe5b9ebe Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 12 Nov 2008 13:17:38 +0100
Subject: [PATCH] tracing: branch tracer, fix vdso crash

Impact: fix bootup crash

the branch tracer missed arch/x86/vdso/vclock_gettime.c from
disabling tracing, which caused such bootup crashes:

  [  201.840097] init[1]: segfault at 7fffed3fe7c0 ip 00007fffed3fea2e sp 000077

also clean up the ugly ifdefs in arch/x86/kernel/vsyscall_64.c by
creating DISABLE_UNLIKELY_PROFILE facility for code to turn off
instrumentation on a per file basis.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/vsyscall_64.c  |    9 ++-------
 arch/x86/vdso/vclock_gettime.c |    3 +++
 include/linux/compiler.h       |    6 +++++-
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 2f90202..ece0293 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -17,13 +17,8 @@
  *  want per guest time just set the kernel.vsyscall64 sysctl to 0.
  */
 
-/* Protect userspace from profiling */
-#ifdef CONFIG_TRACE_UNLIKELY_PROFILE
-# undef likely
-# undef unlikely
-# define likely(x)		likely_notrace(x)
-# define unlikely(x)		unlikely_notrace(x)
-#endif
+/* Disable profiling for userspace code: */
+#define DISABLE_UNLIKELY_PROFILE
 
 #include <linux/time.h>
 #include <linux/init.h>
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 1ef0f90..6e66763 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -9,6 +9,9 @@
  * Also alternative() doesn't work.
  */
 
+/* Disable profiling for userspace code: */
+#define DISABLE_UNLIKELY_PROFILE
+
 #include <linux/kernel.h>
 #include <linux/posix-timers.h>
 #include <linux/time.h>
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 935e30c..63b7d90 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -59,7 +59,11 @@ extern void __chk_io_ptr(const volatile void __iomem *);
  * specific implementations come from the above header files
  */
 
-#ifdef CONFIG_TRACE_UNLIKELY_PROFILE
+/*
+ * Note: DISABLE_UNLIKELY_PROFILE can be used by special lowlevel code
+ * to disable branch tracing on a per file basis.
+ */
+#if defined(CONFIG_TRACE_UNLIKELY_PROFILE) && !defined(DISABLE_UNLIKELY_PROFILE)
 struct ftrace_likely_data {
 	const char *func;
 	const char *file;
