Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbZDXHnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbZDXHnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 03:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbZDXHnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 03:43:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:41867 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbZDXHnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 03:43:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,240,1239001200"; 
   d="scan'208";a="509544424"
Date: Fri, 24 Apr 2009 09:43:09 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com
Subject: [patch] x86, ds: fix buffer alignment in debug store selftest
Message-ID: <20090424094309.A30145@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The debug store selftest code uses a stack-allocated buffer, which is
not necessarily correctly aligned.

For tests using a buffer to hold a single entry, the buffer that is
passed to ds_request must already be suitably aligned.

Pass a suitably aligned portion of the bigger buffer.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/kernel/ds_selftest.c |    6 	4 +	2 -	0 !
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: b/arch/x86/kernel/ds_selftest.c
===================================================================
--- a/arch/x86/kernel/ds_selftest.c
+++ b/arch/x86/kernel/ds_selftest.c
@@ -323,13 +323,15 @@ static int ds_selftest_bts_bad_request_t
 int ds_selftest_bts(void)
 {
 	struct ds_selftest_bts_conf conf;
-	unsigned char buffer[BUFFER_SIZE];
+	unsigned char buffer[BUFFER_SIZE], *small_buffer;
 	unsigned long irq;
 	int cpu;
 
 	printk(KERN_INFO "[ds] bts selftest...");
 	conf.error = 0;
 
+	small_buffer = (unsigned char *)ALIGN((unsigned long)buffer, 8) + 8;
+
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		conf.suspend = ds_suspend_bts_wrap;
@@ -381,7 +383,7 @@ int ds_selftest_bts(void)
 	conf.suspend = ds_suspend_bts_noirq;
 	conf.resume = ds_resume_bts_noirq;
 	conf.tracer =
-		ds_request_bts_task(current, buffer, SMALL_BUFFER_SIZE,
+		ds_request_bts_task(current, small_buffer, SMALL_BUFFER_SIZE,
 				   NULL, (size_t)-1, BTS_KERNEL);
 	local_irq_save(irq);
 	ds_selftest_bts_cpu(&conf);
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

