Return-Path: <linux-kernel-owner+w=401wt.eu-S1763524AbYEUViT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763524AbYEUViT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbYEUViH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:38:07 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:34621 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbYEUViE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:38:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=WCjIE4Y4q5bMcLmCDaVab/MrSGMdQVOsffZMQ+FSciiRQjamNeYnEPlxh1VZVl3qjSQVG+hFF4ubPUmjU0JBxvTJWVC9fdADsdaParZLE1UXLUywRIWrKUg0w+9rFar3lLzI2OfTdWFuTnYCuf/cq/rK04/gLUSz/leKZxHHj+A=
Date: Wed, 21 May 2008 23:37:58 +0200
To: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kmemcheck: use tasklets instead of timers
Message-ID: <20080521213758.GB11061@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Wed, 21 May 2008 22:58:37 +0200
Subject: [PATCH] kmemcheck: use tasklets instead of timers

Instead of triggering a timer every HZ, we use the new tasklet function
which guarantuees not to touch any other tasklets on the tasklet list,
and is thus safe to use from the page fault handler.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/kernel/kmemcheck.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/kmemcheck.c b/arch/x86/kernel/kmemcheck.c
index def1a08..c0045e8 100644
--- a/arch/x86/kernel/kmemcheck.c
+++ b/arch/x86/kernel/kmemcheck.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/kallsyms.h>
 #include <linux/kdebug.h>
 #include <linux/kernel.h>
@@ -18,7 +19,6 @@
 #include <linux/page-flags.h>
 #include <linux/percpu.h>
 #include <linux/stacktrace.h>
-#include <linux/timer.h>
 
 #include <asm/cacheflush.h>
 #include <asm/kmemcheck.h>
@@ -73,8 +73,6 @@ static unsigned int error_rd;
 static unsigned int error_wr;
 static unsigned int error_missed_count;
 
-static struct timer_list kmemcheck_timer;
-
 static struct kmemcheck_error *error_next_wr(void)
 {
 	struct kmemcheck_error *e;
@@ -105,6 +103,9 @@ static struct kmemcheck_error *error_next_rd(void)
 	return e;
 }
 
+static void do_wakeup(unsigned long);
+static DECLARE_TASKLET(kmemcheck_tasklet, &do_wakeup, 0);
+
 static void *address_get_shadow(unsigned long address);
 
 /*
@@ -148,6 +149,8 @@ static void error_save(enum shadow state,
 	BUG_ON(!shadow_copy);
 
 	memcpy(e->shadow_copy, shadow_copy, SHADOW_COPY_SIZE);
+
+	tasklet_hi_schedule(&kmemcheck_tasklet);
 }
 
 /*
@@ -170,6 +173,8 @@ static void error_save_bug(struct pt_regs *regs)
 	e->trace.max_entries = ARRAY_SIZE(e->trace_entries);
 	e->trace.skip = 1;
 	save_stack_trace(&e->trace);
+
+	tasklet_hi_schedule(&kmemcheck_tasklet);
 }
 
 static void error_recall(void)
@@ -233,8 +238,6 @@ static void do_wakeup(unsigned long data)
 			"the queue was too small\n", error_missed_count);
 		error_missed_count = 0;
 	}
-
-	mod_timer(&kmemcheck_timer, kmemcheck_timer.expires + HZ);
 }
 
 void __init kmemcheck_init(void)
@@ -250,9 +253,6 @@ void __init kmemcheck_init(void)
 		setup_max_cpus = 1;
 	}
 #endif
-
-	setup_timer(&kmemcheck_timer, &do_wakeup, 0);
-	mod_timer(&kmemcheck_timer, jiffies + HZ);
 }
 
 #ifdef CONFIG_KMEMCHECK_DISABLED_BY_DEFAULT
-- 
1.5.4.1

