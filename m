Return-Path: <linux-kernel-owner+w=401wt.eu-S933866AbZDCOvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933866AbZDCOvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932809AbZDCOqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:46:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:65184 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766005AbZDCOqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:46:05 -0400
Content-Type: multipart/mixed; boundary="===============1514592330=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,319,1235980800"; 
   d="scan'208";a="503328357"
Message-Id: <20090403144559.394583000@intel.com>
References: <20090403144332.799740000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 03 Apr 2009 16:43:44 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 12/20] x86, ds: selftest each cpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============1514592330==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.ds_selftest.for_each_cpu.patch

Perform debug store selftests on each cpu.

Cover both the normal and the _noirq variant of the debug store interface.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/kernel/ds_selftest.c |  186 	137 +	49 -	0 !
 1 file changed, 137 insertions(+), 49 deletions(-)

Index: b/arch/x86/kernel/ds_selftest.c
===================================================================
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
@@ -125,36 +133,32 @@ static int ds_selftest_bts_read(struct b
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
-
-	trace = ds_read_bts(tracer);
-
-	error = ds_selftest_bts_consistency(trace);
-	if (error < 0)
-		goto out;
+	conf->error = conf->resume(conf->tracer);
+	if (conf->error < 0)
+		return;
+
+	conf->error = conf->suspend(conf->tracer);
+	if (conf->error < 0)
+		return;
+
+	trace = ds_read_bts(conf->tracer);
+
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
 
-	printk(KERN_CONT "%s.\n", (error ? "failed" : "passed"));
+static int ds_resume_bts_wrap(struct bts_tracer *tracer)
+{
+	ds_resume_bts(tracer);
+	return 0;
+}
 
-	return error;
+static void ds_release_bts_noirq_wrap(void *tracer)
+{
+	(void)ds_release_bts_noirq(tracer);
+}
+
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

-- 

--===============1514592330==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--===============1514592330==--
