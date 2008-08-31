Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbYHaQb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbYHaQb6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 12:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbYHaQbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 12:31:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:36216 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbYHaQbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 12:31:21 -0400
Date: Sun, 31 Aug 2008 09:29:35 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, tglx@tglx.de, mingo@elte.hu,
       torvalds@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/5] select: add a timespec_add_safe() function
Message-ID: <20080831092935.3f84524c@infradead.org>
In-Reply-To: <20080831092828.13ae0279@infradead.org>
References: <20080831092828.13ae0279@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] select: add a timespec_add_safe() function

For the select() rework, it's important to be able to add timespec
structures in an overflow-safe manner.

This patch adds a timespec_add_safe() function for this which is similar in
operation to ktime_add_safe(), but works on a struct timespec.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/time.h |    4 ++++
 kernel/time.c        |   18 ++++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index e15206a..7269764 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -38,6 +38,8 @@ struct timezone {
 #define NSEC_PER_SEC	1000000000L
 #define FSEC_PER_SEC	1000000000000000L
 
+#define TIME_T_MAX	(time_t)((1UL << ((sizeof(time_t) << 3) - 1)) - 1)
+
 static inline int timespec_equal(const struct timespec *a,
                                  const struct timespec *b)
 {
@@ -72,6 +74,8 @@ extern unsigned long mktime(const unsigned int year, const unsigned int mon,
 			    const unsigned int min, const unsigned int sec);
 
 extern void set_normalized_timespec(struct timespec *ts, time_t sec, long nsec);
+extern struct timespec timespec_add_safe(const struct timespec lhs,
+					 const struct timespec rhs);
 
 /*
  * sub = lhs - rhs, in normalized form
diff --git a/kernel/time.c b/kernel/time.c
index 6a08660..d63a433 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -669,3 +669,21 @@ EXPORT_SYMBOL(get_jiffies_64);
 #endif
 
 EXPORT_SYMBOL(jiffies);
+
+/*
+ * Add two timespec values and do a safety check for overflow.
+ * It's assumed that both values are valid (>= 0)
+ */
+struct timespec timespec_add_safe(const struct timespec lhs,
+				  const struct timespec rhs)
+{
+	struct timespec res;
+
+	set_normalized_timespec(&res, lhs.tv_sec + rhs.tv_sec,
+				lhs.tv_nsec + rhs.tv_nsec);
+
+	if (res.tv_sec < lhs.tv_sec || res.tv_sec < rhs.tv_sec)
+		res.tv_sec = TIME_T_MAX;
+
+	return res;
+}
-- 
1.5.5.1

