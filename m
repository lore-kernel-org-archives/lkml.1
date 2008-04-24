Return-Path: <linux-kernel-owner+w=401wt.eu-S1759714AbYDXSV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759714AbYDXSV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 14:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757154AbYDXSVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 14:21:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:53740 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057AbYDXSVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 14:21:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=jsbAhnW+3MH6esZ+YtxS/kgIPNTvJWXXJr6jc7rsurUaOge3uL1ecLLepQ7R4jXqGCMbkLtlc/3u0SbpXrWrXWlfUxL305cxqmRZbioyI9mgRrw/ZRLweqByxh3uMwoy/SFCS/FZxR9POt4bTzn6ASWpODSM5dtiU3nyg59prPQ=
Date: Thu, 24 Apr 2008 22:21:01 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] init - dont loose initcall code returned
Message-ID: <20080424182101.GC7717@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an ability to loose initcall returned code if it happened
with irq disabled or imbalanced preemption (and if we debug initcall)

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Please review carefully - *ANY* comments are welcome!


Index: linux-2.6.git/init/main.c
===================================================================
--- linux-2.6.git.orig/init/main.c	2008-04-24 12:30:17.000000000 +0400
+++ linux-2.6.git/init/main.c	2008-04-24 22:13:22.000000000 +0400
@@ -698,7 +698,6 @@ static void __init do_initcalls(void)
 
 	for (call = __initcall_start; call < __initcall_end; call++) {
 		ktime_t t0, t1, delta;
-		char *msg = NULL;
 		char msgbuf[40];
 		int result;
 
@@ -727,23 +726,22 @@ static void __init do_initcalls(void)
 				(unsigned long) *call);
 		}
 
-		if (result && result != -ENODEV && initcall_debug) {
-			sprintf(msgbuf, "error code %d", result);
-			msg = msgbuf;
-		}
+		msgbuf[0] = 0;
+		if (result && result != -ENODEV && initcall_debug)
+			sprintf(msgbuf, "error code %d ", result);
 		if (preempt_count() != count) {
-			msg = "preemption imbalance";
+			strncat(msgbuf, "preemption imbalance", sizeof(msgbuf));
 			preempt_count() = count;
 		}
 		if (irqs_disabled()) {
-			msg = "disabled interrupts";
+			strncat(msgbuf, "disabled interrupts", sizeof(msgbuf));
 			local_irq_enable();
 		}
-		if (msg) {
+		if (msgbuf[0]) {
 			printk(KERN_WARNING "initcall at 0x%p", *call);
 			print_fn_descriptor_symbol(": %s()",
 					(unsigned long) *call);
-			printk(": returned with %s\n", msg);
+			printk(": returned with %s\n", msgbuf);
 		}
 	}
 
