Return-Path: <linux-kernel-owner+w=401wt.eu-S933552AbZDCOyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552AbZDCOyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765881AbZDCOqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:46:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:46720 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932708AbZDCOqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:46:12 -0400
Content-Type: multipart/mixed; boundary="===============1064607013=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,319,1235980800"; 
   d="scan'208";a="503328389"
Message-Id: <20090403144606.139137000@intel.com>
References: <20090403144332.799740000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 03 Apr 2009 16:43:51 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 19/20] x86, ds: allow small debug store buffers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============1064607013==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.ds.small_buffers.patch

Check the buffer size more precisely to allow buffers for exactly one element
provided the base address is already properly aligned.

Add a debug store selftest.


Reported-by: Stephane Eranian <eranian@googlemail.com>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/kernel/ds.c          |    9 	7 +	2 -	0 !
 arch/x86/kernel/ds_selftest.c |    6 	3 +	3 -	0 !
 2 files changed, 10 insertions(+), 5 deletions(-)

Index: b/arch/x86/kernel/ds.c
===================================================================
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -656,6 +656,7 @@ static int ds_request(struct ds_tracer *
 {
 	struct ds_context *context;
 	int error;
+	size_t req_size;
 
 	error = -EOPNOTSUPP;
 	if (!ds_cfg.sizeof_rec[qual])
@@ -665,9 +666,13 @@ static int ds_request(struct ds_tracer *
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
Index: b/arch/x86/kernel/ds_selftest.c
===================================================================
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

-- 

--===============1064607013==
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

--===============1064607013==--
