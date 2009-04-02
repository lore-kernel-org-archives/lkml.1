Return-Path: <linux-kernel-owner+w=401wt.eu-S1763112AbZDBPAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763112AbZDBPAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761538AbZDBO5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:57:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:17664 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761480AbZDBO5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:57:32 -0400
Content-Type: multipart/mixed; boundary="===============0834204229=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,314,1235980800"; 
   d="scan'208";a="399764682"
Message-Id: <20090402145724.304099000@intel.com>
References: <20090402145455.597376000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 02 Apr 2009 16:55:07 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 12/18] x86, ds: add task tracing selftest
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============0834204229==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.ds_selftest.current.patch

Add selftests to cover per-task branch tracing.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/kernel/ds_selftest.c |   71 	71 +	0 -	0 !
 1 file changed, 71 insertions(+)

Index: b/arch/x86/kernel/ds_selftest.c
===================================================================
--- a/arch/x86/kernel/ds_selftest.c
+++ b/arch/x86/kernel/ds_selftest.c
@@ -280,10 +280,51 @@ static int ds_selftest_bts_bad_release_n
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

-- 

--===============0834204229==
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

--===============0834204229==--
