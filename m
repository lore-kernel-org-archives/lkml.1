Return-Path: <linux-kernel-owner+w=401wt.eu-S1761397AbZEGJbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761397AbZEGJbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761931AbZEGJZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:25:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:45101 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761418AbZEGJZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:25:31 -0400
Date: Thu, 7 May 2009 09:24:53 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eranian@googlemail.com, markus.t.metzger@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eranian@googlemail.com, markus.t.metzger@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090403144606.139137000@intel.com>
References: <20090403144606.139137000@intel.com>
Subject: [tip:tracing/core] x86, ds: allow small debug store buffers
Message-ID: <tip-150f5164c1258e05b7dea16f29e592f354c48f34@git.kernel.org>
Git-Commit-ID: 150f5164c1258e05b7dea16f29e592f354c48f34
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:24:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  150f5164c1258e05b7dea16f29e592f354c48f34
Gitweb:     http://git.kernel.org/tip/150f5164c1258e05b7dea16f29e592f354c48f34
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 3 Apr 2009 16:43:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 13:36:35 +0200

x86, ds: allow small debug store buffers

Check the buffer size more precisely to allow buffers for exactly
one element provided the base address is already properly aligned.

Add a debug store selftest.

Reported-by: Stephane Eranian <eranian@googlemail.com>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Cc: roland@redhat.com
Cc: eranian@googlemail.com
Cc: oleg@redhat.com
Cc: juan.villacis@intel.com
Cc: ak@linux.jf.intel.com
LKML-Reference: <20090403144606.139137000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ds.c          |    9 +++++++--
 arch/x86/kernel/ds_selftest.c |    6 +++---
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index ebfb0fd..4e05157 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -656,6 +656,7 @@ static int ds_request(struct ds_tracer *tracer, struct ds_trace *trace,
 {
 	struct ds_context *context;
 	int error;
+	size_t req_size;
 
 	error = -EOPNOTSUPP;
 	if (!ds_cfg.sizeof_rec[qual])
@@ -665,9 +666,13 @@ static int ds_request(struct ds_tracer *tracer, struct ds_trace *trace,
 	if (!base)
 		goto out;
 
-	/* We need space for alignment adjustments in ds_init_ds_trace(). */
+	req_size = ds_cfg.sizeof_rec[qual];
+	/* We might need space for alignment adjustments. */
+	if (!IS_ALIGNED((unsigned long)base, DS_ALIGNMENT))
+		req_size += DS_ALIGNMENT;
+
 	error = -EINVAL;
-	if (size < (DS_ALIGNMENT + ds_cfg.sizeof_rec[qual]))
+	if (size < req_size)
 		goto out;
 
 	if (th != (size_t)-1) {
diff --git a/arch/x86/kernel/ds_selftest.c b/arch/x86/kernel/ds_selftest.c
index a40b253..5f104a0 100644
--- a/arch/x86/kernel/ds_selftest.c
+++ b/arch/x86/kernel/ds_selftest.c
@@ -16,8 +16,8 @@
 #include <asm/ds.h>
 
 
-#define BUFFER_SIZE	521 /* Intentionally chose an odd size. */
-
+#define BUFFER_SIZE		521	/* Intentionally chose an odd size. */
+#define SMALL_BUFFER_SIZE	24	/* A single bts entry. */
 
 struct ds_selftest_bts_conf {
 	struct bts_tracer *tracer;
@@ -381,7 +381,7 @@ int ds_selftest_bts(void)
 	conf.suspend = ds_suspend_bts_noirq;
 	conf.resume = ds_resume_bts_noirq;
 	conf.tracer =
-		ds_request_bts_task(current, buffer, BUFFER_SIZE,
+		ds_request_bts_task(current, buffer, SMALL_BUFFER_SIZE,
 				   NULL, (size_t)-1, BTS_KERNEL);
 	local_irq_save(irq);
 	ds_selftest_bts_cpu(&conf);
