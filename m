Return-Path: <linux-kernel-owner+w=401wt.eu-S1755101AbZEGJ1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbZEGJ1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761571AbZEGJYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:24:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:40528 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761553AbZEGJYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:24:13 -0400
Date: Thu, 7 May 2009 09:23:38 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090403144559.394583000@intel.com>
References: <20090403144559.394583000@intel.com>
Subject: [tip:tracing/core] x86, ds: selftest each cpu
Message-ID: <tip-01f6569ece6915616f6cae1d7d8b46ab8da9c1bd@git.kernel.org>
Git-Commit-ID: 01f6569ece6915616f6cae1d7d8b46ab8da9c1bd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:23:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  01f6569ece6915616f6cae1d7d8b46ab8da9c1bd
Gitweb:     http://git.kernel.org/tip/01f6569ece6915616f6cae1d7d8b46ab8da9c1bd
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 3 Apr 2009 16:43:44 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 13:36:25 +0200

x86, ds: selftest each cpu

Perform debug store selftests on each cpu.

Cover both the normal and the _noirq variant of the debug store interface.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Cc: roland@redhat.com
Cc: eranian@googlemail.com
Cc: oleg@redhat.com
Cc: juan.villacis@intel.com
Cc: ak@linux.jf.intel.com
LKML-Reference: <20090403144559.394583000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ds_selftest.c |  182 ++++++++++++++++++++++++++++++-----------
 1 files changed, 135 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kernel/ds_selftest.c b/arch/x86/kernel/ds_selftest.c
index cccc19a..599a963 100644
--- a/arch/x86/kernel/ds_selftest.c
+++ b/arch/x86/kernel/ds_selftest.c
@@ -11,13 +11,21 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/smp.h>
+#include <linux/cpu.h>
 
 #include <asm/ds.h>
 
 
-#define BUFFER_SIZE 1021 /* Intentionally chose an odd size. */
+#define BUFFER_SIZE	521 /* Intentionally chose an odd size. */
 
 
+struct ds_selftest_bts_conf {
+	struct bts_tracer *tracer;
+	int error;
+	int (*suspend)(struct bts_tracer *);
+	int (*resume)(struct bts_tracer *);
+};
+
 static int ds_selftest_bts_consistency(const struct bts_trace *trace)
 {
 	int error = 0;
@@ -125,36 +133,32 @@ static int ds_selftest_bts_read(struct bts_tracer *tracer,
 	return 0;
 }
 
-int ds_selftest_bts(void)
+static void ds_selftest_bts_cpu(void *arg)
 {
+	struct ds_selftest_bts_conf *conf = arg;
 	const struct bts_trace *trace;
-	struct bts_tracer *tracer;
-	int error = 0;
 	void *top;
-	unsigned char buffer[BUFFER_SIZE];
 
-	printk(KERN_INFO "[ds] bts selftest...");
-
-	tracer = ds_request_bts_cpu(smp_processor_id(), buffer, BUFFER_SIZE,
-				    NULL, (size_t)-1, BTS_KERNEL);
-	if (IS_ERR(tracer)) {
-		error = PTR_ERR(tracer);
-		tracer = NULL;
+	if (IS_ERR(conf->tracer)) {
+		conf->error = PTR_ERR(conf->tracer);
+		conf->tracer = NULL;
 
 		printk(KERN_CONT
-		       "initialization failed (err: %d)...", error);
-		goto out;
+		       "initialization failed (err: %d)...", conf->error);
+		return;
 	}
 
-	/* The return should already give us enough trace. */
-	ds_suspend_bts(tracer);
+	/* We should meanwhile have enough trace. */
+	conf->error = conf->suspend(conf->tracer);
+	if (conf->error < 0)
+		return;
 
 	/* Let's see if we can access the trace. */
-	trace = ds_read_bts(tracer);
+	trace = ds_read_bts(conf->tracer);
 
-	error = ds_selftest_bts_consistency(trace);
-	if (error < 0)
-		goto out;
+	conf->error = ds_selftest_bts_consistency(trace);
+	if (conf->error < 0)
+		return;
 
 	/* If everything went well, we should have a few trace entries. */
 	if (trace->ds.top == trace->ds.begin) {
@@ -168,10 +172,11 @@ int ds_selftest_bts(void)
 	}
 
 	/* Let's try to read the trace we collected. */
-	error = ds_selftest_bts_read(tracer, trace,
+	conf->error =
+		ds_selftest_bts_read(conf->tracer, trace,
 				     trace->ds.begin, trace->ds.top);
-	if (error < 0)
-		goto out;
+	if (conf->error < 0)
+		return;
 
 	/*
 	 * Let's read the trace again.
@@ -179,26 +184,31 @@ int ds_selftest_bts(void)
 	 */
 	top = trace->ds.top;
 
-	trace = ds_read_bts(tracer);
-	error = ds_selftest_bts_consistency(trace);
-	if (error < 0)
-		goto out;
+	trace = ds_read_bts(conf->tracer);
+	conf->error = ds_selftest_bts_consistency(trace);
+	if (conf->error < 0)
+		return;
 
 	if (top != trace->ds.top) {
 		printk(KERN_CONT "suspend not working...");
-		error = -1;
-		goto out;
+		conf->error = -1;
+		return;
 	}
 
 	/* Let's collect some more trace - see if resume is working. */
-	ds_resume_bts(tracer);
-	ds_suspend_bts(tracer);
+	conf->error = conf->resume(conf->tracer);
+	if (conf->error < 0)
+		return;
+
+	conf->error = conf->suspend(conf->tracer);
+	if (conf->error < 0)
+		return;
 
-	trace = ds_read_bts(tracer);
+	trace = ds_read_bts(conf->tracer);
 
-	error = ds_selftest_bts_consistency(trace);
-	if (error < 0)
-		goto out;
+	conf->error = ds_selftest_bts_consistency(trace);
+	if (conf->error < 0)
+		return;
 
 	if (trace->ds.top == top) {
 		/*
@@ -210,35 +220,113 @@ int ds_selftest_bts(void)
 		printk(KERN_CONT
 		       "no resume progress/overflow...");
 
-		error = ds_selftest_bts_read(tracer, trace,
+		conf->error =
+			ds_selftest_bts_read(conf->tracer, trace,
 					     trace->ds.begin, trace->ds.end);
 	} else if (trace->ds.top < top) {
 		/*
 		 * We had a buffer overflow - the entire buffer should
 		 * contain trace records.
 		 */
-		error = ds_selftest_bts_read(tracer, trace,
+		conf->error =
+			ds_selftest_bts_read(conf->tracer, trace,
 					     trace->ds.begin, trace->ds.end);
 	} else {
 		/*
 		 * It is quite likely that the buffer did not overflow.
 		 * Let's just check the delta trace.
 		 */
-		error = ds_selftest_bts_read(tracer, trace,
-					     top, trace->ds.top);
+		conf->error =
+			ds_selftest_bts_read(conf->tracer, trace, top,
+					     trace->ds.top);
 	}
-	if (error < 0)
-		goto out;
+	if (conf->error < 0)
+		return;
 
-	error = 0;
+	conf->error = 0;
+}
 
-	/* The final test: release the tracer while tracing is suspended. */
- out:
-	ds_release_bts(tracer);
+static int ds_suspend_bts_wrap(struct bts_tracer *tracer)
+{
+	ds_suspend_bts(tracer);
+	return 0;
+}
+
+static int ds_resume_bts_wrap(struct bts_tracer *tracer)
+{
+	ds_resume_bts(tracer);
+	return 0;
+}
 
-	printk(KERN_CONT "%s.\n", (error ? "failed" : "passed"));
+static void ds_release_bts_noirq_wrap(void *tracer)
+{
+	(void)ds_release_bts_noirq(tracer);
+}
 
-	return error;
+static int ds_selftest_bts_bad_release_noirq(int cpu,
+					     struct bts_tracer *tracer)
+{
+	int error = -EPERM;
+
+	/* Try to release the tracer on the wrong cpu. */
+	get_cpu();
+	if (cpu != smp_processor_id()) {
+		error = ds_release_bts_noirq(tracer);
+		if (error != -EPERM)
+			printk(KERN_CONT "release on wrong cpu...");
+	}
+	put_cpu();
+
+	return error ? 0 : -1;
+}
+
+int ds_selftest_bts(void)
+{
+	struct ds_selftest_bts_conf conf;
+	unsigned char buffer[BUFFER_SIZE];
+	int cpu;
+
+	printk(KERN_INFO "[ds] bts selftest...");
+	conf.error = 0;
+
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
+		conf.suspend = ds_suspend_bts_wrap;
+		conf.resume = ds_resume_bts_wrap;
+		conf.tracer =
+			ds_request_bts_cpu(cpu, buffer, BUFFER_SIZE,
+					   NULL, (size_t)-1, BTS_KERNEL);
+		ds_selftest_bts_cpu(&conf);
+		ds_release_bts(conf.tracer);
+		if (conf.error < 0)
+			goto out;
+
+		conf.suspend = ds_suspend_bts_noirq;
+		conf.resume = ds_resume_bts_noirq;
+		conf.tracer =
+			ds_request_bts_cpu(cpu, buffer, BUFFER_SIZE,
+					   NULL, (size_t)-1, BTS_KERNEL);
+		smp_call_function_single(cpu, ds_selftest_bts_cpu, &conf, 1);
+		if (conf.error >= 0) {
+			conf.error =
+				ds_selftest_bts_bad_release_noirq(cpu,
+								  conf.tracer);
+			/* We must not release the tracer twice. */
+			if (conf.error < 0)
+				conf.tracer = NULL;
+		}
+		smp_call_function_single(cpu, ds_release_bts_noirq_wrap,
+					 conf.tracer, 1);
+		if (conf.error < 0)
+			goto out;
+	}
+
+	conf.error = 0;
+ out:
+	put_online_cpus();
+	printk(KERN_CONT "%s.\n", (conf.error ? "failed" : "passed"));
+
+	return conf.error;
 }
 
 int ds_selftest_pebs(void)
