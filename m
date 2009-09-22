Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbZIVNfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbZIVNfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbZIVNfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:35:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:33901 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378AbZIVNfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:35:16 -0400
Date: Tue, 22 Sep 2009 13:34:02 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       davem@davemloft.net, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       davem@davemloft.net, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/printk] ratelimit: Use per ratelimit context locking
Message-ID: <tip-979f693def9084a452846365dfde5dcb28366333@git.kernel.org>
Git-Commit-ID: 979f693def9084a452846365dfde5dcb28366333
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 13:34:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  979f693def9084a452846365dfde5dcb28366333
Gitweb:     http://git.kernel.org/tip/979f693def9084a452846365dfde5dcb28366333
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 22 Sep 2009 14:44:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 22 Sep 2009 15:31:34 +0200

ratelimit: Use per ratelimit context locking

I'd like to use printk_ratelimit() in atomic context, but that's
not possible right now due to the spinlock usage this commit
introduced more than a year ago:

  717115e: printk ratelimiting rewrite

As a first step push the lock into the ratelimit state structure.
This allows us to deal with locking failures to be considered as an
event related to that state being too busy.

Also clean up the code a bit (without changing functionality):

 - tidy up the definitions

 - clean up the code flow

This also shrinks the code a tiny bit:

   text	   data	    bss	    dec	    hex	filename
    264	      0	      4	    268	    10c	ratelimit.o.before
    255	      0	      0	    255	     ff	ratelimit.o.after

( Whole-kernel data size got a bit larger, because we have
  two ratelimit-state data structures right now. )

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David S. Miller <davem@davemloft.net>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/ratelimit.h |   30 ++++++++++++++++++++----------
 lib/ratelimit.c           |   29 +++++++++++++----------------
 2 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
index 00044b8..187bc16 100644
--- a/include/linux/ratelimit.h
+++ b/include/linux/ratelimit.h
@@ -1,20 +1,30 @@
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
 
 extern int __ratelimit(struct ratelimit_state *rs);
-#endif
+
+#endif /* _LINUX_RATELIMIT_H */
diff --git a/lib/ratelimit.c b/lib/ratelimit.c
index 26187ed..0e2c28e 100644
--- a/lib/ratelimit.c
+++ b/lib/ratelimit.c
@@ -7,15 +7,12 @@
  * parameter. Now every user can use their own standalone ratelimit_state.
  *
  * This file is released under the GPLv2.
- *
  */
 
 #include <linux/kernel.h>
 #include <linux/jiffies.h>
 #include <linux/module.h>
 
-static DEFINE_SPINLOCK(ratelimit_lock);
-
 /*
  * __ratelimit - rate limiting
  * @rs: ratelimit_state data
@@ -26,11 +23,12 @@ static DEFINE_SPINLOCK(ratelimit_lock);
 int __ratelimit(struct ratelimit_state *rs)
 {
 	unsigned long flags;
+	int ret;
 
 	if (!rs->interval)
 		return 1;
 
-	spin_lock_irqsave(&ratelimit_lock, flags);
+	spin_lock_irqsave(&rs->lock, flags);
 	if (!rs->begin)
 		rs->begin = jiffies;
 
@@ -38,20 +36,19 @@ int __ratelimit(struct ratelimit_state *rs)
 		if (rs->missed)
 			printk(KERN_WARNING "%s: %d callbacks suppressed\n",
 				__func__, rs->missed);
-		rs->begin = 0;
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
 EXPORT_SYMBOL(__ratelimit);
