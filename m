Return-Path: <linux-kernel-owner+w=401wt.eu-S1762000AbZEGJ2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762000AbZEGJ2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760618AbZEGJYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:24:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:40545 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761569AbZEGJYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:24:23 -0400
Date: Thu, 7 May 2009 09:23:49 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090403144600.329346000@intel.com>
References: <20090403144600.329346000@intel.com>
Subject: [tip:tracing/core] x86, ds: add task tracing selftest
Message-ID: <tip-3a68eef945b234f286406d96dc690fe17863c203@git.kernel.org>
Git-Commit-ID: 3a68eef945b234f286406d96dc690fe17863c203
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:23:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a68eef945b234f286406d96dc690fe17863c203
Gitweb:     http://git.kernel.org/tip/3a68eef945b234f286406d96dc690fe17863c203
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 3 Apr 2009 16:43:45 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 13:36:27 +0200

x86, ds: add task tracing selftest

Add selftests to cover per-task branch tracing.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Cc: roland@redhat.com
Cc: eranian@googlemail.com
Cc: oleg@redhat.com
Cc: juan.villacis@intel.com
Cc: ak@linux.jf.intel.com
LKML-Reference: <20090403144600.329346000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ds_selftest.c |   71 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ds_selftest.c b/arch/x86/kernel/ds_selftest.c
index 599a963..a40b253 100644
--- a/arch/x86/kernel/ds_selftest.c
+++ b/arch/x86/kernel/ds_selftest.c
@@ -280,10 +280,51 @@ static int ds_selftest_bts_bad_release_noirq(int cpu,
 	return error ? 0 : -1;
 }
 
+static int ds_selftest_bts_bad_request_cpu(int cpu, void *buffer)
+{
+	struct bts_tracer *tracer;
+	int error;
+
+	/* Try to request cpu tracing while task tracing is active. */
+	tracer = ds_request_bts_cpu(cpu, buffer, BUFFER_SIZE, NULL,
+				    (size_t)-1, BTS_KERNEL);
+	error = PTR_ERR(tracer);
+	if (!IS_ERR(tracer)) {
+		ds_release_bts(tracer);
+		error = 0;
+	}
+
+	if (error != -EPERM)
+		printk(KERN_CONT "cpu/task tracing overlap...");
+
+	return error ? 0 : -1;
+}
+
+static int ds_selftest_bts_bad_request_task(void *buffer)
+{
+	struct bts_tracer *tracer;
+	int error;
+
+	/* Try to request cpu tracing while task tracing is active. */
+	tracer = ds_request_bts_task(current, buffer, BUFFER_SIZE, NULL,
+				    (size_t)-1, BTS_KERNEL);
+	error = PTR_ERR(tracer);
+	if (!IS_ERR(tracer)) {
+		error = 0;
+		ds_release_bts(tracer);
+	}
+
+	if (error != -EPERM)
+		printk(KERN_CONT "task/cpu tracing overlap...");
+
+	return error ? 0 : -1;
+}
+
 int ds_selftest_bts(void)
 {
 	struct ds_selftest_bts_conf conf;
 	unsigned char buffer[BUFFER_SIZE];
+	unsigned long irq;
 	int cpu;
 
 	printk(KERN_INFO "[ds] bts selftest...");
@@ -297,6 +338,8 @@ int ds_selftest_bts(void)
 			ds_request_bts_cpu(cpu, buffer, BUFFER_SIZE,
 					   NULL, (size_t)-1, BTS_KERNEL);
 		ds_selftest_bts_cpu(&conf);
+		if (conf.error >= 0)
+			conf.error = ds_selftest_bts_bad_request_task(buffer);
 		ds_release_bts(conf.tracer);
 		if (conf.error < 0)
 			goto out;
@@ -315,12 +358,40 @@ int ds_selftest_bts(void)
 			if (conf.error < 0)
 				conf.tracer = NULL;
 		}
+		if (conf.error >= 0)
+			conf.error = ds_selftest_bts_bad_request_task(buffer);
 		smp_call_function_single(cpu, ds_release_bts_noirq_wrap,
 					 conf.tracer, 1);
 		if (conf.error < 0)
 			goto out;
 	}
 
+	conf.suspend = ds_suspend_bts_wrap;
+	conf.resume = ds_resume_bts_wrap;
+	conf.tracer =
+		ds_request_bts_task(current, buffer, BUFFER_SIZE,
+				    NULL, (size_t)-1, BTS_KERNEL);
+	ds_selftest_bts_cpu(&conf);
+	if (conf.error >= 0)
+		conf.error = ds_selftest_bts_bad_request_cpu(0, buffer);
+	ds_release_bts(conf.tracer);
+	if (conf.error < 0)
+		goto out;
+
+	conf.suspend = ds_suspend_bts_noirq;
+	conf.resume = ds_resume_bts_noirq;
+	conf.tracer =
+		ds_request_bts_task(current, buffer, BUFFER_SIZE,
+				   NULL, (size_t)-1, BTS_KERNEL);
+	local_irq_save(irq);
+	ds_selftest_bts_cpu(&conf);
+	if (conf.error >= 0)
+		conf.error = ds_selftest_bts_bad_request_cpu(0, buffer);
+	ds_release_bts_noirq(conf.tracer);
+	local_irq_restore(irq);
+	if (conf.error < 0)
+		goto out;
+
 	conf.error = 0;
  out:
 	put_online_cpus();
