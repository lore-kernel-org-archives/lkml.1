Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbZLCSbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbZLCSbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 13:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756332AbZLCSbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 13:31:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42210 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611AbZLCSbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 13:31:17 -0500
Date: Thu, 3 Dec 2009 19:30:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] core/printk for v2.6.33
Message-ID: <20091203183054.GA12100@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-printk-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-printk-for-linus

 Thanks,

	Ingo

------------------>
Christian Borntraeger (1):
      ratelimit: Make suppressed output messages more useful

Ingo Molnar (3):
      ratelimit: Use per ratelimit context locking
      ratelimit: Fix/allow use in atomic contexts
      printk: Remove ratelimit.h from kernel.h


 include/linux/kernel.h     |    5 +--
 include/linux/net.h        |    1 +
 include/linux/ratelimit.h  |   33 +++++++++++++++++++++----------
 kernel/printk.c            |    7 +++--
 kernel/sysctl.c            |    3 ++
 lib/ratelimit.c            |   45 ++++++++++++++++++++++++-------------------
 net/core/sysctl_net_core.c |    2 +
 net/core/utils.c           |    2 +
 8 files changed, 61 insertions(+), 37 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2b5b1e0..21d0d82 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -15,7 +15,6 @@
 #include <linux/bitops.h>
 #include <linux/log2.h>
 #include <linux/typecheck.h>
-#include <linux/ratelimit.h>
 #include <linux/dynamic_debug.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
@@ -241,8 +240,8 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 asmlinkage int printk(const char * fmt, ...)
 	__attribute__ ((format (printf, 1, 2))) __cold;
 
-extern struct ratelimit_state printk_ratelimit_state;
-extern int printk_ratelimit(void);
+extern int __printk_ratelimit(const char *func);
+#define printk_ratelimit() __printk_ratelimit(__func__)
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
 
diff --git a/include/linux/net.h b/include/linux/net.h
index 9040a10..df20f68 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -358,6 +358,7 @@ static const struct proto_ops name##_ops = {			\
 
 #ifdef CONFIG_SYSCTL
 #include <linux/sysctl.h>
+#include <linux/ratelimit.h>
 extern struct ratelimit_state net_ratelimit_state;
 #endif
 
diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
index 00044b8..668cf1b 100644
--- a/include/linux/ratelimit.h
+++ b/include/linux/ratelimit.h
@@ -1,20 +1,31 @@
 #ifndef _LINUX_RATELIMIT_H
 #define _LINUX_RATELIMIT_H
+
 #include <linux/param.h>
+#include <linux/spinlock_types.h>
 
-#define DEFAULT_RATELIMIT_INTERVAL (5 * HZ)
-#define DEFAULT_RATELIMIT_BURST 10
+#define DEFAULT_RATELIMIT_INTERVAL	(5 * HZ)
+#define DEFAULT_RATELIMIT_BURST		10
 
 struct ratelimit_state {
-	int interval;
-	int burst;
-	int printed;
-	int missed;
-	unsigned long begin;
+	spinlock_t	lock;		/* protect the state */
+
+	int		interval;
+	int		burst;
+	int		printed;
+	int		missed;
+	unsigned long	begin;
 };
 
-#define DEFINE_RATELIMIT_STATE(name, interval, burst)		\
-		struct ratelimit_state name = {interval, burst,}
+#define DEFINE_RATELIMIT_STATE(name, interval_init, burst_init)		\
+									\
+	struct ratelimit_state name = {					\
+		.lock		= __SPIN_LOCK_UNLOCKED(name.lock),	\
+		.interval	= interval_init,			\
+		.burst		= burst_init,				\
+	}
+
+extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
+#define __ratelimit(state) ___ratelimit(state, __func__)
 
-extern int __ratelimit(struct ratelimit_state *rs);
-#endif
+#endif /* _LINUX_RATELIMIT_H */
diff --git a/kernel/printk.c b/kernel/printk.c
index 602033a..8283dbe 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -33,6 +33,7 @@
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
 #include <linux/kexec.h>
+#include <linux/ratelimit.h>
 
 #include <asm/uaccess.h>
 
@@ -1363,11 +1364,11 @@ late_initcall(disable_boot_consoles);
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
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 1a631ba..6c37048 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -37,6 +37,7 @@
 #include <linux/sysrq.h>
 #include <linux/highuid.h>
 #include <linux/writeback.h>
+#include <linux/ratelimit.h>
 #include <linux/hugetlb.h>
 #include <linux/initrd.h>
 #include <linux/key.h>
@@ -155,6 +156,8 @@ extern int no_unaligned_warning;
 extern int unaligned_dump_stack;
 #endif
 
+extern struct ratelimit_state printk_ratelimit_state;
+
 #ifdef CONFIG_RT_MUTEXES
 extern int max_lock_depth;
 #endif
diff --git a/lib/ratelimit.c b/lib/ratelimit.c
index 26187ed..09f5ce1 100644
--- a/lib/ratelimit.c
+++ b/lib/ratelimit.c
@@ -7,15 +7,12 @@
  * parameter. Now every user can use their own standalone ratelimit_state.
  *
  * This file is released under the GPLv2.
- *
  */
 
-#include <linux/kernel.h>
+#include <linux/ratelimit.h>
 #include <linux/jiffies.h>
 #include <linux/module.h>
 
-static DEFINE_SPINLOCK(ratelimit_lock);
-
 /*
  * __ratelimit - rate limiting
  * @rs: ratelimit_state data
@@ -23,35 +20,43 @@ static DEFINE_SPINLOCK(ratelimit_lock);
  * This enforces a rate limit: not more than @rs->ratelimit_burst callbacks
  * in every @rs->ratelimit_jiffies
  */
-int __ratelimit(struct ratelimit_state *rs)
+int ___ratelimit(struct ratelimit_state *rs, const char *func)
 {
 	unsigned long flags;
+	int ret;
 
 	if (!rs->interval)
 		return 1;
 
-	spin_lock_irqsave(&ratelimit_lock, flags);
+	/*
+	 * If we contend on this state's lock then almost
+	 * by definition we are too busy to print a message,
+	 * in addition to the one that will be printed by
+	 * the entity that is holding the lock already:
+	 */
+	if (!spin_trylock_irqsave(&rs->lock, flags))
+		return 1;
+
 	if (!rs->begin)
 		rs->begin = jiffies;
 
 	if (time_is_before_jiffies(rs->begin + rs->interval)) {
 		if (rs->missed)
 			printk(KERN_WARNING "%s: %d callbacks suppressed\n",
-				__func__, rs->missed);
-		rs->begin = 0;
+				func, rs->missed);
+		rs->begin   = 0;
 		rs->printed = 0;
-		rs->missed = 0;
+		rs->missed  = 0;
 	}
-	if (rs->burst && rs->burst > rs->printed)
-		goto print;
-
-	rs->missed++;
-	spin_unlock_irqrestore(&ratelimit_lock, flags);
-	return 0;
+	if (rs->burst && rs->burst > rs->printed) {
+		rs->printed++;
+		ret = 1;
+	} else {
+		rs->missed++;
+		ret = 0;
+	}
+	spin_unlock_irqrestore(&rs->lock, flags);
 
-print:
-	rs->printed++;
-	spin_unlock_irqrestore(&ratelimit_lock, flags);
-	return 1;
+	return ret;
 }
-EXPORT_SYMBOL(__ratelimit);
+EXPORT_SYMBOL(___ratelimit);
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 7db1de0..887c03c 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -10,7 +10,9 @@
 #include <linux/module.h>
 #include <linux/socket.h>
 #include <linux/netdevice.h>
+#include <linux/ratelimit.h>
 #include <linux/init.h>
+
 #include <net/ip.h>
 #include <net/sock.h>
 
diff --git a/net/core/utils.c b/net/core/utils.c
index 83221ae..8382502 100644
--- a/net/core/utils.c
+++ b/net/core/utils.c
@@ -24,6 +24,8 @@
 #include <linux/types.h>
 #include <linux/percpu.h>
 #include <linux/init.h>
+#include <linux/ratelimit.h>
+
 #include <net/sock.h>
 
 #include <asm/byteorder.h>
