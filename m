Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbYEGONt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbYEGONt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbYEGONX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:13:23 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:14517 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321AbYEGOND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:13:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=Z+Q28mvUYUdkz7oL1+uRJEuRW/FiwqTE3ZStAPiB3XjGSLYZ+VewzrXELTrRFxGdsSH11noScUhMjqi5QQts/XI619SxWxvWVjFeuzI0RUD4NL/fEiho4uUBu5A1tgfH2tvRDyYdpW5TEvSFsgJSd5TmTYGI1UyULPhMnqNQ1cI=
Date: Wed, 7 May 2008 18:12:55 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] init - dont loose initcall code returned v2
Message-ID: <20080507141255.GA6859@cvg>
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

Andrew, it's an updated version


Index: linux-2.6.git/init/main.c
===================================================================
--- linux-2.6.git.orig/init/main.c	2008-05-06 17:51:27.000000000 +0400
+++ linux-2.6.git/init/main.c	2008-05-07 18:10:22.000000000 +0400
@@ -702,7 +702,6 @@ static void __init do_initcalls(void)
 
 	for (call = __initcall_start; call < __initcall_end; call++) {
 		ktime_t t0, t1, delta;
-		char *msg = NULL;
 		char msgbuf[40];
 		int result;
 
@@ -724,22 +723,23 @@ static void __init do_initcalls(void)
 				(unsigned long long) delta.tv64 >> 20);
 		}
 
-		if (result && result != -ENODEV && initcall_debug) {
-			sprintf(msgbuf, "error code %d", result);
-			msg = msgbuf;
-		}
+		msgbuf[0] = 0;
+
+		if (result && result != -ENODEV && initcall_debug)
+			sprintf(msgbuf, "error code %d ", result);
+
 		if (preempt_count() != count) {
-			msg = "preemption imbalance";
+			strncat(msgbuf, "preemption imbalance ", sizeof(msgbuf));
 			preempt_count() = count;
 		}
 		if (irqs_disabled()) {
-			msg = "disabled interrupts";
+			strncat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
 			local_irq_enable();
 		}
-		if (msg) {
+		if (msgbuf[0]) {
 			print_fn_descriptor_symbol(KERN_WARNING "initcall %s()",
 					(unsigned long) *call);
-			printk(" returned with %s\n", msg);
+			printk(" returned with %s\n", msgbuf);
 		}
 	}
 
