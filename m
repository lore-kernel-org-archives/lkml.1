Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbZJWPME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbZJWPME (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 11:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZJWPMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 11:12:03 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:54823 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbZJWPMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 11:12:01 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC/PATCH] ratelimit: make output more useful
Date: Fri, 23 Oct 2009 17:12:00 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-tip-tip-01652-g1846719-dirty; KDE/4.3.1; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Young <hidave.darkstar@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200910191706.42223.borntraeger@de.ibm.com> <200910231458.11832.borntraeger@de.ibm.com> <20091023145509.GA13793@elte.hu>
In-Reply-To: <20091023145509.GA13793@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910231712.00722.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 23 Oktober 2009 16:55:09 schrieb Ingo Molnar:
> Any reason why it couldnt be pushed inside printk.c? We just need the
> func string - not the pointer pass-in. That would also address some of
> the call-site bloat.

Right, I changed that and made the patch a bit simpler. So what about:

[PATCH] ratelimit: make output more useful

Today I got 

[39648.224782] Registered led device: iwl-phy0::TX
[40676.545099] __ratelimit: 246 callbacks suppressed
[40676.545103] abcdef[23675]: segfault at 0 ...

as you can see the ratelimit message contains a function prefix. Since this
is  always __ratelimit, this wont help much. This patch changes __ratelimit
and printk_ratelimit to print the function name  that calls ratelimit.
This will pinpoint the responsible function, as long as not several different 
places call ratelimit with the same ratelimit state at the same time. In that
case we catch only one random function that calls ratelimit after the wait
period.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/kernel.h    |    3 ++-
 include/linux/ratelimit.h |    3 ++-
 kernel/printk.c           |    6 +++---
 lib/ratelimit.c           |    6 +++---
 4 files changed, 10 insertions(+), 8 deletions(-)

Index: tip/include/linux/kernel.h
===================================================================
--- tip.orig/include/linux/kernel.h
+++ tip/include/linux/kernel.h
@@ -332,7 +332,8 @@ asmlinkage int vprintk(const char *fmt, 
 asmlinkage int printk(const char * fmt, ...)
 	__attribute__ ((format (printf, 1, 2))) __cold;
 
-extern int printk_ratelimit(void);
+extern int __printk_ratelimit(const char *func);
+#define printk_ratelimit() __printk_ratelimit(__func__)
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
 
Index: tip/include/linux/ratelimit.h
===================================================================
--- tip.orig/include/linux/ratelimit.h
+++ tip/include/linux/ratelimit.h
@@ -25,6 +25,7 @@ struct ratelimit_state {
 		.burst		= burst_init,				\
 	}
 
-extern int __ratelimit(struct ratelimit_state *rs);
+extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
+#define __ratelimit(state) ___ratelimit(state, __func__)
 
 #endif /* _LINUX_RATELIMIT_H */
Index: tip/kernel/printk.c
===================================================================
--- tip.orig/kernel/printk.c
+++ tip/kernel/printk.c
@@ -1377,11 +1377,11 @@ late_initcall(disable_boot_consoles);
  */
 DEFINE_RATELIMIT_STATE(printk_ratelimit_state, 5 * HZ, 10);
 
-int printk_ratelimit(void)
+int __printk_ratelimit(const char *func)
 {
-	return __ratelimit(&printk_ratelimit_state);
+	return ___ratelimit(&printk_ratelimit_state, func);
 }
-EXPORT_SYMBOL(printk_ratelimit);
+EXPORT_SYMBOL(__printk_ratelimit);
 
 /**
  * printk_timed_ratelimit - caller-controlled printk ratelimiting
Index: tip/lib/ratelimit.c
===================================================================
--- tip.orig/lib/ratelimit.c
+++ tip/lib/ratelimit.c
@@ -20,7 +20,7 @@
  * This enforces a rate limit: not more than @rs->ratelimit_burst callbacks
  * in every @rs->ratelimit_jiffies
  */
-int __ratelimit(struct ratelimit_state *rs)
+int ___ratelimit(struct ratelimit_state *rs, const char *func)
 {
 	unsigned long flags;
 	int ret;
@@ -43,7 +43,7 @@ int __ratelimit(struct ratelimit_state *
 	if (time_is_before_jiffies(rs->begin + rs->interval)) {
 		if (rs->missed)
 			printk(KERN_WARNING "%s: %d callbacks suppressed\n",
-				__func__, rs->missed);
+				func, rs->missed);
 		rs->begin   = 0;
 		rs->printed = 0;
 		rs->missed  = 0;
@@ -59,4 +59,4 @@ int __ratelimit(struct ratelimit_state *
 
 	return ret;
 }
-EXPORT_SYMBOL(__ratelimit);
+EXPORT_SYMBOL(___ratelimit);
