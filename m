Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbZJXBFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbZJXBFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbZJXBFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:05:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:51767 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359AbZJXBE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:04:59 -0400
Date: Sat, 24 Oct 2009 01:04:16 GMT
From: tip-bot for Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hidave.darkstar@gmail.com, hpa@zytor.com,
       mingo@redhat.com, torvalds@linux-foundation.org, borntraeger@de.ibm.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, hidave.darkstar@gmail.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       borntraeger@de.ibm.com, mingo@elte.hu
In-Reply-To: <200910231458.11832.borntraeger@de.ibm.com>
References: <200910231458.11832.borntraeger@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] ratelimit: Make suppressed output messages more useful
Message-ID: <tip-5c828713358cb9df8aa174371edcbbb62203a490@git.kernel.org>
Git-Commit-ID: 5c828713358cb9df8aa174371edcbbb62203a490
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5c828713358cb9df8aa174371edcbbb62203a490
Gitweb:     http://git.kernel.org/tip/5c828713358cb9df8aa174371edcbbb62203a490
Author:     Christian Borntraeger <borntraeger@de.ibm.com>
AuthorDate: Fri, 23 Oct 2009 14:58:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 23 Oct 2009 17:26:37 +0200

ratelimit: Make suppressed output messages more useful

Today I got:

  [39648.224782] Registered led device: iwl-phy0::TX
  [40676.545099] __ratelimit: 246 callbacks suppressed
  [40676.545103] abcdef[23675]: segfault at 0 ...

as you can see the ratelimit message contains a function prefix.
Since this is always __ratelimit, this wont help much.

This patch changes __ratelimit and printk_ratelimit to print the
function name that calls ratelimit.

This will pinpoint the responsible function, as long as not several
different places call ratelimit with the same ratelimit state at
the same time. In that case we catch only one random function that
calls ratelimit after the wait period.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <200910231458.11832.borntraeger@de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/kernel.h    |    3 ++-
 include/linux/ratelimit.h |    3 ++-
 kernel/printk.c           |    6 +++---
 lib/ratelimit.c           |    6 +++---
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3305f33..21d0d82 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -240,7 +240,8 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 asmlinkage int printk(const char * fmt, ...)
 	__attribute__ ((format (printf, 1, 2))) __cold;
 
-extern int printk_ratelimit(void);
+extern int __printk_ratelimit(const char *func);
+#define printk_ratelimit() __printk_ratelimit(__func__)
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
 
diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
index 187bc16..668cf1b 100644
--- a/include/linux/ratelimit.h
+++ b/include/linux/ratelimit.h
@@ -25,6 +25,7 @@ struct ratelimit_state {
 		.burst		= burst_init,				\
 	}
 
-extern int __ratelimit(struct ratelimit_state *rs);
+extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
+#define __ratelimit(state) ___ratelimit(state, __func__)
 
 #endif /* _LINUX_RATELIMIT_H */
diff --git a/kernel/printk.c b/kernel/printk.c
index b997c89..8283dbe 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1364,11 +1364,11 @@ late_initcall(disable_boot_consoles);
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
diff --git a/lib/ratelimit.c b/lib/ratelimit.c
index 5551731..09f5ce1 100644
--- a/lib/ratelimit.c
+++ b/lib/ratelimit.c
@@ -20,7 +20,7 @@
  * This enforces a rate limit: not more than @rs->ratelimit_burst callbacks
  * in every @rs->ratelimit_jiffies
  */
-int __ratelimit(struct ratelimit_state *rs)
+int ___ratelimit(struct ratelimit_state *rs, const char *func)
 {
 	unsigned long flags;
 	int ret;
@@ -43,7 +43,7 @@ int __ratelimit(struct ratelimit_state *rs)
 	if (time_is_before_jiffies(rs->begin + rs->interval)) {
 		if (rs->missed)
 			printk(KERN_WARNING "%s: %d callbacks suppressed\n",
-				__func__, rs->missed);
+				func, rs->missed);
 		rs->begin   = 0;
 		rs->printed = 0;
 		rs->missed  = 0;
@@ -59,4 +59,4 @@ int __ratelimit(struct ratelimit_state *rs)
 
 	return ret;
 }
-EXPORT_SYMBOL(__ratelimit);
+EXPORT_SYMBOL(___ratelimit);
