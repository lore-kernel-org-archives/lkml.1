Return-Path: <linux-kernel-owner+w=401wt.eu-S1760465AbZKZMej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760465AbZKZMej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 07:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760453AbZKZMei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 07:34:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:57874 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760447AbZKZMeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 07:34:36 -0500
Date: Thu, 26 Nov 2009 12:34:01 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, spencer@bluehost.com, hpa@zytor.com,
       mingo@redhat.com, johnstul@linux.vnet.ibm.com,
       seto.hidetoshi@jp.fujitsu.com, peterz@infradead.org,
       xiyou.wangcong@gmail.com, balbir@in.ibm.com, tglx@linutronix.de,
       oleg@redhat.com, sgruszka@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, spencer@bluehost.com,
       linux-kernel@vger.kernel.org, johnstul@linux.vnet.ibm.com,
       seto.hidetoshi@jp.fujitsu.com, peterz@infradead.org,
       xiyou.wangcong@gmail.com, balbir@in.ibm.com, oleg@redhat.com,
       tglx@linutronix.de, sgruszka@redhat.com, mingo@elte.hu
In-Reply-To: <4B0E16E7.5070307@jp.fujitsu.com>
References: <4B0E16E7.5070307@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, time: Define nsecs_to_jiffies()
Message-ID: <tip-b7b20df91d43d5e59578b8fc16e895c0c8cbd9b5@git.kernel.org>
Git-Commit-ID: b7b20df91d43d5e59578b8fc16e895c0c8cbd9b5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7b20df91d43d5e59578b8fc16e895c0c8cbd9b5
Gitweb:     http://git.kernel.org/tip/b7b20df91d43d5e59578b8fc16e895c0c8cbd9b5
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Thu, 26 Nov 2009 14:49:27 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 12:59:20 +0100

sched, time: Define nsecs_to_jiffies()

Use of msecs_to_jiffies() for nsecs_to_cputime() have some
problems:

 - The type of msecs_to_jiffies()'s argument is unsigned int, so
   it cannot convert msecs greater than UINT_MAX = about 49.7 days.

 - msecs_to_jiffies() returns MAX_JIFFY_OFFSET if MSB of argument
   is set, assuming that input was negative value.  So it cannot
   convert msecs greater than INT_MAX = about 24.8 days too.

This patch defines a new function nsecs_to_jiffies() that can
deal greater values, and that can deal all incoming values as
unsigned.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Spencer Candland <spencer@bluehost.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Amrico Wang <xiyou.wangcong@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <johnstul@linux.vnet.ibm.com>
LKML-Reference: <4B0E16E7.5070307@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/jiffies.h |    1 +
 kernel/sched.c          |    3 +--
 kernel/time.c           |   30 ++++++++++++++++++++++++++++++
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 1a9cf78..6811f4b 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -307,6 +307,7 @@ extern clock_t jiffies_to_clock_t(long x);
 extern unsigned long clock_t_to_jiffies(unsigned long x);
 extern u64 jiffies_64_to_clock_t(u64 x);
 extern u64 nsec_to_clock_t(u64 x);
+extern unsigned long nsecs_to_jiffies(u64 n);
 
 #define TIMESTAMP_SIZE	30
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 82251c2..b3d4e2b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5192,8 +5192,7 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 #else
 
 #ifndef nsecs_to_cputime
-# define nsecs_to_cputime(__nsecs) \
-	msecs_to_cputime(div_u64((__nsecs), NSEC_PER_MSEC))
+# define nsecs_to_cputime(__nsecs)	nsecs_to_jiffies(__nsecs)
 #endif
 
 void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
diff --git a/kernel/time.c b/kernel/time.c
index 2e2e469..8047980 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -662,6 +662,36 @@ u64 nsec_to_clock_t(u64 x)
 #endif
 }
 
+/**
+ * nsecs_to_jiffies - Convert nsecs in u64 to jiffies
+ *
+ * @n:	nsecs in u64
+ *
+ * Unlike {m,u}secs_to_jiffies, type of input is not unsigned int but u64.
+ * And this doesn't return MAX_JIFFY_OFFSET since this function is designed
+ * for scheduler, not for use in device drivers to calculate timeout value.
+ *
+ * note:
+ *   NSEC_PER_SEC = 10^9 = (5^9 * 2^9) = (1953125 * 512)
+ *   ULLONG_MAX ns = 18446744073.709551615 secs = about 584 years
+ */
+unsigned long nsecs_to_jiffies(u64 n)
+{
+#if (NSEC_PER_SEC % HZ) == 0
+	/* Common case, HZ = 100, 128, 200, 250, 256, 500, 512, 1000 etc. */
+	return div_u64(n, NSEC_PER_SEC / HZ);
+#elif (HZ % 512) == 0
+	/* overflow after 292 years if HZ = 1024 */
+	return div_u64(n * HZ / 512, NSEC_PER_SEC / 512);
+#else
+	/*
+	 * Generic case - optimized for cases where HZ is a multiple of 3.
+	 * overflow after 64.99 years, exact for HZ = 60, 72, 90, 120 etc.
+	 */
+	return div_u64(n * 9, (9ull * NSEC_PER_SEC + HZ / 2) / HZ);
+#endif
+}
+
 #if (BITS_PER_LONG < 64)
 u64 get_jiffies_64(void)
 {
