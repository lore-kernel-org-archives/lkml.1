Return-Path: <linux-kernel-owner+w=401wt.eu-S1761130AbYBYW1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761130AbYBYW1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757830AbYBYW1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:27:23 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46009 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756565AbYBYW1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:27:22 -0500
From: Jonathan Lim <jlim@sgi.com>
Message-Id: <200802252227.m1PMRwbk020090@sabah.engr.sgi.com>
Subject: Re: [PATCH] Provide u64 version of jiffies_to_usecs() in kernel/tsacct.c
To: linux-kernel@vger.kernel.org
Date: Mon, 25 Feb 2008 14:27:58 -0800 (PST)
Cc: akpm@linux-foundation.org, randy.dunlap@oracle.com
In-Reply-To: <no.id> from "jlim" at Feb 19, 2008 06:17:01 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible that the values used in and returned from jiffies_to_usecs() are
incorrect because of truncation when variables of type u64 are involved.  So a
function specific to that type is used instead.

This version implements a correction to jiffies_64_to_usecs() based on feedback
from Randy Dunlap.

Diff'd against: linux/kernel/git/torvalds/linux-2.6.git

Signed-off-by: Jonathan Lim <jlim@sgi.com>

--- a/include/linux/jiffies.h	Thu Feb 14 18:04:14 PST 2008
+++ b/include/linux/jiffies.h	Thu Feb 14 18:07:17 PST 2008
@@ -42,7 +42,7 @@
 /* LATCH is used in the interval timer and ftape setup. */
 #define LATCH  ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
 
-/* Suppose we want to devide two numbers NOM and DEN: NOM/DEN, then we can
+/* Suppose we want to divide two numbers NOM and DEN: NOM/DEN, then we can
  * improve accuracy by shifting LSH bits, hence calculating:
  *     (NOM << LSH) / DEN
  * This however means trouble for large NOM, because (NOM << LSH) may no
@@ -204,7 +204,7 @@ extern unsigned long preset_lpj;
  * operator if the result is a long long AND at least one of the
  * operands is cast to long long (usually just prior to the "*" so as
  * not to confuse it into thinking it really has a 64-bit operand,
- * which, buy the way, it can do, but it takes more code and at least 2
+ * which, by the way, it can do, but it takes more code and at least 2
  * mpys).
 
  * We also need to be aware that one second in nanoseconds is only a
@@ -269,6 +269,7 @@ extern unsigned long preset_lpj;
  */
 extern unsigned int jiffies_to_msecs(const unsigned long j);
 extern unsigned int jiffies_to_usecs(const unsigned long j);
+extern u64 jiffies_64_to_usecs(const u64 j);
 extern unsigned long msecs_to_jiffies(const unsigned int m);
 extern unsigned long usecs_to_jiffies(const unsigned int u);
 extern unsigned long timespec_to_jiffies(const struct timespec *value);
--- a/kernel/time.c	Thu Feb 14 18:05:12 PST 2008
+++ b/kernel/time.c	Mon Feb 25 14:22:27 PST 2008
@@ -38,6 +38,7 @@
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
+#include <asm/div64.h>
 
 #include "timeconst.h"
 
@@ -267,6 +268,12 @@ unsigned int inline jiffies_to_usecs(con
 #endif
 }
 EXPORT_SYMBOL(jiffies_to_usecs);
+
+u64 jiffies_64_to_usecs(const u64 j)
+{
+	return div64_64(j*HZ_TO_USEC_NUM + HZ_TO_USEC_DEN-1, HZ_TO_USEC_DEN);
+}
+EXPORT_SYMBOL(jiffies_64_to_usecs);
 
 /**
  * timespec_trunc - Truncate timespec to a granularity
--- a/kernel/tsacct.c	Thu Feb 14 18:06:17 PST 2008
+++ b/kernel/tsacct.c	Thu Feb 14 18:08:47 PST 2008
@@ -85,8 +85,8 @@ void xacct_add_tsk(struct taskstats *sta
 	struct mm_struct *mm;
 
 	/* convert pages-jiffies to Mbyte-usec */
-	stats->coremem = jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
-	stats->virtmem = jiffies_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
+	stats->coremem = jiffies_64_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
+	stats->virtmem = jiffies_64_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
 	mm = get_task_mm(p);
 	if (mm) {
 		/* adjust to KB unit */
