Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbZJSPHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbZJSPHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbZJSPHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:07:07 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:43306 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523AbZJSPHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:07:05 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC/PATCH] ratelimit: make output more useful
Date: Mon, 19 Oct 2009 17:06:42 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc4-self-00094-g80f5069-dirty; KDE/4.3.1; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Dave Young <hidave.darkstar@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200910191706.42223.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today I got 


[39648.224782] Registered led device: iwl-phy0::TX
[40676.545099] __ratelimit: 246 callbacks suppressed
[40676.545103] abcdef[23675]: segfault at 0 ...

as you can see the ratelimit message contains a function prefix. Since this is 
always __ratelimit, this wont help much. This patch changes __ratelimit and 
printk_ratelimit to print the function name  that calls ratelimit.

Opinions?

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Dave Young <hidave.darkstar@gmail.com>

 include/linux/kernel.h    |    6 +++++-
 include/linux/ratelimit.h |    3 ++-
 kernel/printk.c           |    9 +--------
 lib/ratelimit.c           |    6 +++---
 4 files changed, 11 insertions(+), 13 deletions(-)

Index: linux-2.6/include/linux/kernel.h
===================================================================
--- linux-2.6.orig/include/linux/kernel.h
+++ linux-2.6/include/linux/kernel.h
@@ -241,8 +241,12 @@ asmlinkage int vprintk(const char *fmt, 
 asmlinkage int printk(const char * fmt, ...)
 	__attribute__ ((format (printf, 1, 2))) __cold;
 
+/*
+ * printk rate limiting, lifted from the networking subsystem.
+ */
 extern struct ratelimit_state printk_ratelimit_state;
-extern int printk_ratelimit(void);
+#define printk_ratelimit() ___ratelimit(&printk_ratelimit_state, __func__)
+
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
 
Index: linux-2.6/include/linux/ratelimit.h
===================================================================
--- linux-2.6.orig/include/linux/ratelimit.h
+++ linux-2.6/include/linux/ratelimit.h
@@ -16,5 +16,6 @@ struct ratelimit_state {
 #define DEFINE_RATELIMIT_STATE(name, interval, burst)		\
 		struct ratelimit_state name = {interval, burst,}
 
-extern int __ratelimit(struct ratelimit_state *rs);
+extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
+#define __ratelimit(state) ___ratelimit(state, __func__)
 #endif
Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -1369,18 +1369,11 @@ late_initcall(disable_boot_consoles);
 #if defined CONFIG_PRINTK
 
 /*
- * printk rate limiting, lifted from the networking subsystem.
- *
  * This enforces a rate limit: not more than 10 kernel messages
  * every 5s to make a denial-of-service attack impossible.
  */
 DEFINE_RATELIMIT_STATE(printk_ratelimit_state, 5 * HZ, 10);
-
-int printk_ratelimit(void)
-{
-	return __ratelimit(&printk_ratelimit_state);
-}
-EXPORT_SYMBOL(printk_ratelimit);
+EXPORT_SYMBOL(printk_ratelimit_state);
 
 /**
  * printk_timed_ratelimit - caller-controlled printk ratelimiting
Index: linux-2.6/lib/ratelimit.c
===================================================================
--- linux-2.6.orig/lib/ratelimit.c
+++ linux-2.6/lib/ratelimit.c
@@ -23,7 +23,7 @@ static DEFINE_SPINLOCK(ratelimit_lock);
  * This enforces a rate limit: not more than @rs->ratelimit_burst callbacks
  * in every @rs->ratelimit_jiffies
  */
-int __ratelimit(struct ratelimit_state *rs)
+int ___ratelimit(struct ratelimit_state *rs, const char *func)
 {
 	unsigned long flags;
 
@@ -37,7 +37,7 @@ int __ratelimit(struct ratelimit_state *
 	if (time_is_before_jiffies(rs->begin + rs->interval)) {
 		if (rs->missed)
 			printk(KERN_WARNING "%s: %d callbacks suppressed\n",
-				__func__, rs->missed);
+				func, rs->missed);
 		rs->begin = 0;
 		rs->printed = 0;
 		rs->missed = 0;
@@ -54,4 +54,4 @@ print:
 	spin_unlock_irqrestore(&ratelimit_lock, flags);
 	return 1;
 }
-EXPORT_SYMBOL(__ratelimit);
+EXPORT_SYMBOL(___ratelimit);
