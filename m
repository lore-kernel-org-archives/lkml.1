Return-Path: <linux-kernel-owner+w=401wt.eu-S933789AbXDASQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789AbXDASQv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933794AbXDASQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:16:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35569 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933795AbXDASQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:16:20 -0400
Date: Sun, 1 Apr 2007 20:16:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] enhance initcall_debug, measure latency
Message-ID: <20070401181614.GA25648@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [patch] enhance initcall_debug, measure latency
From: Ingo Molnar <mingo@elte.hu>

enhance the initcall_debug boot option:

 - measure the time the initcall took to execute and report
   it in units of milliseconds.

 - show the return code of initcalls (useful to see failures and
   to make sure that an initcall hung)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 init/main.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

Index: linux/init/main.c
===================================================================
--- linux.orig/init/main.c
+++ linux/init/main.c
@@ -685,6 +685,7 @@ static void __init do_initcalls(void)
 	int count = preempt_count();
 
 	for (call = __initcall_start; call < __initcall_end; call++) {
+		ktime_t t0, t1, delta;
 		char *msg = NULL;
 		char msgbuf[40];
 		int result;
@@ -694,10 +695,26 @@ static void __init do_initcalls(void)
 			print_fn_descriptor_symbol(": %s()",
 					(unsigned long) *call);
 			printk("\n");
+			t0 = ktime_get();
 		}
 
 		result = (*call)();
 
+		if (initcall_debug) {
+			t1 = ktime_get();
+			delta = ktime_sub(t1, t0);
+
+			printk("initcall 0x%p", *call);
+			print_fn_descriptor_symbol(": %s()",
+					(unsigned long) *call);
+			printk(" returned %d.\n", result);
+
+			printk("initcall 0x%p ran for %Ld msecs: ",
+				*call, delta.tv64 >> 20);
+			print_fn_descriptor_symbol("%s()\n",
+				(unsigned long) *call);
+		}
+
 		if (result && result != -ENODEV && initcall_debug) {
 			sprintf(msgbuf, "error code %d", result);
 			msg = msgbuf;
