Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbYH0QJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbYH0QJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758232AbYH0QH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:07:59 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:24012 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758218AbYH0QH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:07:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Dx9Pr6R7ntOUdlOBY6jaFPcu8FraYTQi/1YSGrPrSZXpy/3vhePZ3/OOb1Gv+jCLRv
         LT+b+tvEiTBoAm+3Y/LDKQo2e6VkKY3qk3XpPrA78eMAQeEVBw0jvIlJ2xHSiDugkNHR
         plBsLQLw9YQ1PtSSKTCpondA9kvUzBDZhQU9M=
From: Andrea Righi <righi.andrea@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>
Cc: agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       baramsori72@gmail.com, Carl Henrik Lunde <chlunde@ping.uio.no>,
       dave@linux.vnet.ibm.com, Divyesh Shah <dpshah@google.com>,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
       Hirokazu Takahashi <taka@valinux.co.jp>, Li Zefan <lizf@cn.fujitsu.com>,
       Marco Innocenti <m.innocenti@cineca.it>, matt@bluehost.com,
       ngupta@google.com, randy.dunlap@oracle.com, roberto@unbit.it,
       Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Andrea Righi <righi.andrea@gmail.com>
Subject: [RFC][PATCH -mm 2/5] introduce struct res_counter_ratelimit
Date: Wed, 27 Aug 2008 18:07:34 +0200
Message-Id: <1219853257-11052-3-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce res_counter_ratelimit as a generic structure to implement
throttling-based cgroup subsystems.

[ Only the interfaces needed by the IO controller are implemented right now ]

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 include/linux/res_counter.h |   70 +++++++++++++++++++++++++
 kernel/res_counter.c        |  118 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 187 insertions(+), 1 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index 626f8aa..8c44746 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -14,6 +14,7 @@
  */
 
 #include <linux/cgroup.h>
+#include <linux/jiffies.h>
 
 /*
  * The core object. the cgroup that wishes to account for some
@@ -45,6 +46,38 @@ struct res_counter {
 	spinlock_t lock;
 };
 
+/* The various policies that can be used for throttling */
+#define	RATELIMIT_LEAKY_BUCKET	0
+#define	RATELIMIT_TOKEN_BUCKET	1
+
+struct res_counter_ratelimit {
+	/*
+	 * the current resource consumption level
+	 */
+	unsigned long long usage;
+	/*
+	 * the maximal value of the usage from the counter creation
+	 */
+	unsigned long long max_usage;
+	/*
+	 * the rate limit that cannot be exceeded
+	 */
+	unsigned long long limit;
+	/*
+	 * the limiting policy / algorithm
+	 */
+	unsigned long long policy;
+	/*
+	 * timestamp of the last accounted resource request
+	 */
+	unsigned long long timestamp;
+	/*
+	 * the lock to protect all of the above.
+	 * the routines below consider this to be IRQ-safe
+	 */
+	spinlock_t lock;
+};
+
 /**
  * Helpers to interact with userspace
  * res_counter_read_u64() - returns the value of the specified member.
@@ -60,10 +93,17 @@ struct res_counter {
 
 u64 res_counter_read_u64(struct res_counter *counter, int member);
 
+u64 res_counter_ratelimit_read_u64(struct res_counter_ratelimit *counter,
+				int member);
+
 ssize_t res_counter_read(struct res_counter *counter, int member,
 		const char __user *buf, size_t nbytes, loff_t *pos,
 		int (*read_strategy)(unsigned long long val, char *s));
 
+ssize_t res_counter_ratelimit_read(struct res_counter_ratelimit *counter,
+		int member, const char __user *buf, size_t nbytes, loff_t *pos,
+		int (*read_strategy)(unsigned long long val, char *s));
+
 typedef int (*write_strategy_fn)(const char *buf, unsigned long long *val);
 
 int res_counter_memparse_write_strategy(const char *buf,
@@ -80,6 +120,8 @@ enum {
 	RES_USAGE,
 	RES_MAX_USAGE,
 	RES_LIMIT,
+	RES_POLICY,
+	RES_TIMESTAMP,
 	RES_FAILCNT,
 };
 
@@ -89,6 +131,8 @@ enum {
 
 void res_counter_init(struct res_counter *counter);
 
+void res_counter_ratelimit_init(struct res_counter_ratelimit *counter);
+
 /*
  * charge - try to consume more resource.
  *
@@ -126,6 +170,15 @@ static inline bool res_counter_limit_check_locked(struct res_counter *cnt)
 	return false;
 }
 
+static inline unsigned long long
+res_counter_ratelimit_delta_t(struct res_counter_ratelimit *res)
+{
+	return (long long)get_jiffies_64() - (long long)res->timestamp;
+}
+
+unsigned long long
+res_counter_ratelimit_sleep(struct res_counter_ratelimit *res, ssize_t val);
+
 /*
  * Helper function to detect if the cgroup is within it's limit or
  * not. It's currently called from cgroup_rss_prepare()
@@ -174,6 +227,23 @@ static inline int res_counter_set_limit(struct res_counter *cnt,
 	return ret;
 }
 
+static inline int
+res_counter_ratelimit_set_limit(struct res_counter_ratelimit *cnt,
+			unsigned long long policy,
+			unsigned long long limit, unsigned long long max)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cnt->lock, flags);
+	cnt->limit = limit;
+	cnt->max_usage = max;
+	cnt->policy = policy;
+	cnt->timestamp = get_jiffies_64();
+	cnt->usage = 0;
+	spin_unlock_irqrestore(&cnt->lock, flags);
+	return 0;
+}
+
 /*
  * Add the value val to the resource counter and check if we are
  * still under the limit.
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index f275c8e..cf23205 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -9,6 +9,7 @@
 
 #include <linux/types.h>
 #include <linux/parser.h>
+#include <linux/jiffies.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/res_counter.h>
@@ -21,6 +22,15 @@ void res_counter_init(struct res_counter *counter)
 	counter->limit = (unsigned long long)LLONG_MAX;
 }
 
+void res_counter_ratelimit_init(struct res_counter_ratelimit *counter)
+{
+	spin_lock_init(&counter->lock);
+	counter->limit = (unsigned long long)LLONG_MAX;
+	counter->max_usage = (unsigned long long)LLONG_MAX;
+	counter->usage = 0;
+	counter->timestamp = get_jiffies_64();
+}
+
 int res_counter_charge_locked(struct res_counter *counter, unsigned long val)
 {
 	if (counter->usage + val > counter->limit) {
@@ -62,7 +72,6 @@ void res_counter_uncharge(struct res_counter *counter, unsigned long val)
 	spin_unlock_irqrestore(&counter->lock, flags);
 }
 
-
 static inline unsigned long long *
 res_counter_member(struct res_counter *counter, int member)
 {
@@ -81,6 +90,26 @@ res_counter_member(struct res_counter *counter, int member)
 	return NULL;
 }
 
+static inline unsigned long long *
+res_counter_ratelimit_member(struct res_counter_ratelimit *counter, int member)
+{
+	switch (member) {
+	case RES_USAGE:
+		return &counter->usage;
+	case RES_MAX_USAGE:
+		return &counter->max_usage;
+	case RES_LIMIT:
+		return &counter->limit;
+	case RES_POLICY:
+		return &counter->policy;
+	case RES_TIMESTAMP:
+		return &counter->timestamp;
+	};
+
+	BUG();
+	return NULL;
+}
+
 ssize_t res_counter_read(struct res_counter *counter, int member,
 		const char __user *userbuf, size_t nbytes, loff_t *pos,
 		int (*read_strategy)(unsigned long long val, char *st_buf))
@@ -98,11 +127,35 @@ ssize_t res_counter_read(struct res_counter *counter, int member,
 			pos, buf, s - buf);
 }
 
+ssize_t res_counter_ratelimit_read(struct res_counter_ratelimit *counter,
+		int member, const char __user *userbuf, size_t nbytes,
+		loff_t *pos,
+		int (*read_strategy)(unsigned long long val, char *st_buf))
+{
+	unsigned long long *val;
+	char buf[64], *s;
+
+	s = buf;
+	val = res_counter_ratelimit_member(counter, member);
+	if (read_strategy)
+		s += read_strategy(*val, s);
+	else
+		s += sprintf(s, "%llu\n", *val);
+	return simple_read_from_buffer((void __user *)userbuf, nbytes,
+			pos, buf, s - buf);
+}
+
 u64 res_counter_read_u64(struct res_counter *counter, int member)
 {
 	return *res_counter_member(counter, member);
 }
 
+u64 res_counter_ratelimit_read_u64(struct res_counter_ratelimit *counter,
+				int member)
+{
+	return *res_counter_ratelimit_member(counter, member);
+}
+
 int res_counter_memparse_write_strategy(const char *buf,
 					unsigned long long *res)
 {
@@ -137,3 +190,66 @@ int res_counter_write(struct res_counter *counter, int member,
 	spin_unlock_irqrestore(&counter->lock, flags);
 	return 0;
 }
+
+static unsigned long long
+ratelimit_leaky_bucket(struct res_counter_ratelimit *res, ssize_t val)
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
+ratelimit_token_bucket(struct res_counter_ratelimit *res, ssize_t val)
+{
+	unsigned long long delta;
+	long long tok;
+
+	res->usage -= val;
+	delta = jiffies_to_msecs(res_counter_ratelimit_delta_t(res));
+	res->timestamp = get_jiffies_64();
+	tok = (long long)res->usage * MSEC_PER_SEC;
+	if (delta) {
+		long long max = (long long)res->max_usage * MSEC_PER_SEC;
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
+res_counter_ratelimit_sleep(struct res_counter_ratelimit *res, ssize_t val)
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
1.5.4.3

