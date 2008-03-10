Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbYCJGZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbYCJGZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 02:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYCJGZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 02:25:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:28808 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbYCJGZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 02:25:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=hTqZXbCPxMKMBZoqbHmVz+OyVjdTnpe9PcoYO8cmdX05r58vUhvVDx1cuJNLMhh0PDOMLAgfE8qo7CITa3nHsFbAcPzOQYDlokx1Q1D4oX3KU7ZwKv/a1JIOGR2FusWe9r9kmWk99Is9s0aq3CbjP+8BzsWe7ZKb+/lBOzdCA9M=
Date: Mon, 10 Mar 2008 14:31:15 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com
Subject: [PATCH RFC] [1/3] isolate ratelimit from printk.c for other use
Message-ID: <20080310063115.GA6745@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series include 3 patch, they need to be applied in order.
1) isolate ratelimit from printk.c
2) add WARN_ON_SECS macro
3) use WARN_ON_SECS macro in rcupreempt.h

Please give some comments and suggestions for improvement, thanks.

---

Due to the rcupreempt.h WARN_ON trigged, I got 2G syslog file. For some
serious complaining of kernel, we need repeat the warnings, so here I
isolate the ratelimit part of printk.c to a standalone file.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
include/linux/kernel.h |    1 
kernel/printk.c        |   26 ------------------------
lib/Makefile           |    2 -
lib/ratelimit.c        |   51 +++++++++++++++++++++++++++++++++++++++++++++++++
4 files changed, 54 insertions(+), 26 deletions(-)

diff -uprN linux/include/linux/kernel.h linux.new/include/linux/kernel.h
--- linux/include/linux/kernel.h	2008-03-10 13:41:18.000000000 +0800
+++ linux.new/include/linux/kernel.h	2008-03-10 13:42:06.000000000 +0800
@@ -188,6 +188,7 @@ extern int log_buf_copy(char *dest, int 
 extern int printk_ratelimit_jiffies;
 extern int printk_ratelimit_burst;
 extern int printk_ratelimit(void);
+extern int __ratelimit(int ratelimit_jiffies, int ratelimit_burst);
 extern int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst);
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
diff -uprN linux/kernel/printk.c linux.new/kernel/printk.c
--- linux/kernel/printk.c	2008-03-10 13:41:37.000000000 +0800
+++ linux.new/kernel/printk.c	2008-03-10 13:42:19.000000000 +0800
@@ -1261,31 +1261,7 @@ void tty_write_message(struct tty_struct
  */
 int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst)
 {
-	static DEFINE_SPINLOCK(ratelimit_lock);
-	static unsigned toks = 10 * 5 * HZ;
-	static unsigned long last_msg;
-	static int missed;
-	unsigned long flags;
-	unsigned long now = jiffies;
-
-	spin_lock_irqsave(&ratelimit_lock, flags);
-	toks += now - last_msg;
-	last_msg = now;
-	if (toks > (ratelimit_burst * ratelimit_jiffies))
-		toks = ratelimit_burst * ratelimit_jiffies;
-	if (toks >= ratelimit_jiffies) {
-		int lost = missed;
-
-		missed = 0;
-		toks -= ratelimit_jiffies;
-		spin_unlock_irqrestore(&ratelimit_lock, flags);
-		if (lost)
-			printk(KERN_WARNING "printk: %d messages suppressed.\n", lost);
-		return 1;
-	}
-	missed++;
-	spin_unlock_irqrestore(&ratelimit_lock, flags);
-	return 0;
+	return __ratelimit(ratelimit_jiffies, ratelimit_burst);
 }
 EXPORT_SYMBOL(__printk_ratelimit);
 
diff -uprN linux/lib/Makefile linux.new/lib/Makefile
--- linux/lib/Makefile	2008-03-10 13:43:57.000000000 +0800
+++ linux.new/lib/Makefile	2008-03-10 13:42:38.000000000 +0800
@@ -6,7 +6,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
-	 proportions.o prio_heap.o
+	 proportions.o prio_heap.o ratelimit.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
diff -uprN linux/lib/ratelimit.c linux.new/lib/ratelimit.c
--- linux/lib/ratelimit.c	1970-01-01 07:00:00.000000000 +0700
+++ linux.new/lib/ratelimit.c	2008-03-10 13:42:46.000000000 +0800
@@ -0,0 +1,51 @@
+/*
+ * ratelimit.c - Do something with rate limit.
+ *
+ * Isolated from kernel/printk.c by Dave Young <hidave.darkstar@gmail.com>
+ *
+ * This file is released under the GPLv2.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/jiffies.h>
+#include <linux/module.h>
+
+/*
+ * __ratelimit - rate limiting
+ * @ratelimit_jiffies: minimum time in jiffies between too callbacks
+ * @ratelimit_burst: number of callbacks we do before ratelimiting
+ *
+ * This enforces a rate limit: not more than @ratelimit_burst callbacks
+ * in every ratelimit_jiffies
+ */
+int __ratelimit(int ratelimit_jiffies, int ratelimit_burst)
+{
+	static DEFINE_SPINLOCK(ratelimit_lock);
+	static unsigned toks = 10 * 5 * HZ;
+	static unsigned long last_msg;
+	static int missed;
+	unsigned long flags;
+	unsigned long now = jiffies;
+
+	spin_lock_irqsave(&ratelimit_lock, flags);
+	toks += now - last_msg;
+	last_msg = now;
+	if (toks > (ratelimit_burst * ratelimit_jiffies))
+		toks = ratelimit_burst * ratelimit_jiffies;
+	if (toks >= ratelimit_jiffies) {
+		int lost = missed;
+
+		missed = 0;
+		toks -= ratelimit_jiffies;
+		spin_unlock_irqrestore(&ratelimit_lock, flags);
+		if (lost)
+			printk(KERN_WARNING "__ratelimit: %d messages"
+				" suppressed.\n", lost);
+		return 1;
+	}
+	missed++;
+	spin_unlock_irqrestore(&ratelimit_lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL(__ratelimit);
