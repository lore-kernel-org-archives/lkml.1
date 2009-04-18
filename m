Return-Path: <linux-kernel-owner+w=401wt.eu-S1759761AbZDRVjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759761AbZDRVjh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 17:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759373AbZDRViq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 17:38:46 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:37748 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759601AbZDRVio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 17:38:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cP/efqD8PeGEip7eSxHjzw6FKT+b2JW0azTzQSqDt6hgUDHLfPyJ+BoHTJso13EdqC
         ef42/o6lNrtvvuUmPHBOmz6hTHHU0JtkeVlgta4p36zg51EWBFA/Fj2INsu1oXjJ80WE
         SV1D5x4U7a6FFZQc8XClfXR3B1pTxhYT7aBgQ=
From: Andrea Righi <righi.andrea@gmail.com>
To: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, Nauman Rafique <nauman@google.com>,
       fchecconi@gmail.com, paolo.valente@unimore.it,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH 2/7] res_counter: introduce ratelimiting attributes
Date: Sat, 18 Apr 2009 23:38:27 +0200
Message-Id: <1240090712-1058-3-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1240090712-1058-1-git-send-email-righi.andrea@gmail.com>
References: <1240090712-1058-1-git-send-email-righi.andrea@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce attributes and functions in res_counter to implement throttling-based
cgroup subsystems.

The following attributes have been added to struct res_counter:
 * @policy:     the limiting policy / algorithm
 * @capacity:   the maximum capacity of the resource
 * @timestamp:  timestamp of the last accounted resource request

Currently the available policies are: token-bucket and leaky-bucket and the
attribute @capacity is only used by token-bucket policy (to represent the
bucket size).

The following function has been implemented to return the amount of time a
cgroup should sleep to remain within the defined resource limits.

  unsigned long long
  res_counter_ratelimit_sleep(struct res_counter *res, ssize_t val);

[ Note: only the interfaces needed by the cgroup IO controller are implemented
right now ]

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 include/linux/res_counter.h |   69 +++++++++++++++++++++++++++++++----------
 kernel/res_counter.c        |   72 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 124 insertions(+), 17 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index 4c5bcf6..9bed6af 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -14,30 +14,36 @@
  */
 
 #include <linux/cgroup.h>
+#include <linux/jiffies.h>
 
-/*
- * The core object. the cgroup that wishes to account for some
- * resource may include this counter into its structures and use
- * the helpers described beyond
- */
+/* The various policies that can be used for ratelimiting resources */
+#define	RATELIMIT_LEAKY_BUCKET	0
+#define	RATELIMIT_TOKEN_BUCKET	1
 
+/**
+ * struct res_counter - the core object to account cgroup resources
+ *
+ * @usage:	the current resource consumption level
+ * @max_usage:	the maximal value of the usage from the counter creation
+ * @limit:	the limit that usage cannot be exceeded
+ * @failcnt:	the number of unsuccessful attempts to consume the resource
+ * @policy:	the limiting policy / algorithm
+ * @capacity:	the maximum capacity of the resource
+ * @timestamp:	timestamp of the last accounted resource request
+ * @lock:	the lock to protect all of the above.
+ *		The routines below consider this to be IRQ-safe
+ *
+ * The cgroup that wishes to account for some resource may include this counter
+ * into its structures and use the helpers described beyond.
+ */
 struct res_counter {
-	/*
-	 * the current resource consumption level
-	 */
 	unsigned long long usage;
-	/*
-	 * the maximal value of the usage from the counter creation
-	 */
 	unsigned long long max_usage;
-	/*
-	 * the limit that usage cannot exceed
-	 */
 	unsigned long long limit;
-	/*
-	 * the number of unsuccessful attempts to consume the resource
-	 */
 	unsigned long long failcnt;
+	unsigned long long policy;
+	unsigned long long capacity;
+	unsigned long long timestamp;
 	/*
 	 * the lock to protect all of the above.
 	 * the routines below consider this to be IRQ-safe
@@ -84,6 +90,9 @@ enum {
 	RES_USAGE,
 	RES_MAX_USAGE,
 	RES_LIMIT,
+	RES_POLICY,
+	RES_TIMESTAMP,
+	RES_CAPACITY,
 	RES_FAILCNT,
 };
 
@@ -130,6 +139,15 @@ static inline bool res_counter_limit_check_locked(struct res_counter *cnt)
 	return false;
 }
 
+static inline unsigned long long
+res_counter_ratelimit_delta_t(struct res_counter *res)
+{
+	return (long long)get_jiffies_64() - (long long)res->timestamp;
+}
+
+unsigned long long
+res_counter_ratelimit_sleep(struct res_counter *res, ssize_t val);
+
 /*
  * Helper function to detect if the cgroup is within it's limit or
  * not. It's currently called from cgroup_rss_prepare()
@@ -163,6 +181,23 @@ static inline void res_counter_reset_failcnt(struct res_counter *cnt)
 	spin_unlock_irqrestore(&cnt->lock, flags);
 }
 
+static inline int
+res_counter_ratelimit_set_limit(struct res_counter *cnt,
+			unsigned long long policy,
+			unsigned long long limit, unsigned long long max)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cnt->lock, flags);
+	cnt->limit = limit;
+	cnt->capacity = max;
+	cnt->policy = policy;
+	cnt->timestamp = get_jiffies_64();
+	cnt->usage = 0;
+	spin_unlock_irqrestore(&cnt->lock, flags);
+	return 0;
+}
+
 static inline int res_counter_set_limit(struct res_counter *cnt,
 		unsigned long long limit)
 {
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index bf8e753..b62319c 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -9,6 +9,7 @@
 
 #include <linux/types.h>
 #include <linux/parser.h>
+#include <linux/jiffies.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/res_counter.h>
@@ -20,6 +21,8 @@ void res_counter_init(struct res_counter *counter, struct res_counter *parent)
 	spin_lock_init(&counter->lock);
 	counter->limit = (unsigned long long)LLONG_MAX;
 	counter->parent = parent;
+	counter->capacity = (unsigned long long)LLONG_MAX;
+	counter->timestamp = get_jiffies_64();
 }
 
 int res_counter_charge_locked(struct res_counter *counter, unsigned long val)
@@ -99,6 +102,12 @@ res_counter_member(struct res_counter *counter, int member)
 		return &counter->max_usage;
 	case RES_LIMIT:
 		return &counter->limit;
+	case RES_POLICY:
+		return &counter->policy;
+	case RES_TIMESTAMP:
+		return &counter->timestamp;
+	case RES_CAPACITY:
+		return &counter->capacity;
 	case RES_FAILCNT:
 		return &counter->failcnt;
 	};
@@ -163,3 +172,66 @@ int res_counter_write(struct res_counter *counter, int member,
 	spin_unlock_irqrestore(&counter->lock, flags);
 	return 0;
 }
+
+static unsigned long long
+ratelimit_leaky_bucket(struct res_counter *res, ssize_t val)
+{
+	unsigned long long delta, t;
+
+	res->usage += val;
+	delta = res_counter_ratelimit_delta_t(res);
+	if (!delta)
+		return 0;
+	t = res->usage * USEC_PER_SEC;
+	t = usecs_to_jiffies(div_u64(t, res->limit));
+	if (t > delta)
+		return t - delta;
+	/* Reset i/o statistics */
+	res->usage = 0;
+	res->timestamp = get_jiffies_64();
+	return 0;
+}
+
+static unsigned long long
+ratelimit_token_bucket(struct res_counter *res, ssize_t val)
+{
+	unsigned long long delta;
+	long long tok;
+
+	res->usage -= val;
+	delta = jiffies_to_msecs(res_counter_ratelimit_delta_t(res));
+	res->timestamp = get_jiffies_64();
+	tok = (long long)res->usage * MSEC_PER_SEC;
+	if (delta) {
+		long long max = (long long)res->capacity * MSEC_PER_SEC;
+
+		tok += delta * res->limit;
+		if (tok > max)
+			tok = max;
+		res->usage = (unsigned long long)div_s64(tok, MSEC_PER_SEC);
+	}
+	return (tok < 0) ? msecs_to_jiffies(div_u64(-tok, res->limit)) : 0;
+}
+
+unsigned long long
+res_counter_ratelimit_sleep(struct res_counter *res, ssize_t val)
+{
+	unsigned long long sleep = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&res->lock, flags);
+	if (res->limit)
+		switch (res->policy) {
+		case RATELIMIT_LEAKY_BUCKET:
+			sleep = ratelimit_leaky_bucket(res, val);
+			break;
+		case RATELIMIT_TOKEN_BUCKET:
+			sleep = ratelimit_token_bucket(res, val);
+			break;
+		default:
+			WARN_ON(1);
+			break;
+		}
+	spin_unlock_irqrestore(&res->lock, flags);
+	return sleep;
+}
-- 
1.5.6.3

