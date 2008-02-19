Return-Path: <linux-kernel-owner+w=401wt.eu-S1760340AbYBSUwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760340AbYBSUwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 15:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbYBSUwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 15:52:12 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58530 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753046AbYBSUwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 15:52:10 -0500
From: Jonathan Lim <jlim@sgi.com>
Message-Id: <200802192052.m1JKqk9K002857@sabah.engr.sgi.com>
Subject: Re: [PATCH] Provide u64 version of jiffies_to_usecs() in kernel/tsacct.c
To: linux-kernel@vger.kernel.org
Date: Tue, 19 Feb 2008 12:52:46 -0800 (PST)
Cc: akpm@linux-foundation.org, randy.dunlap@oracle.com
In-Reply-To: <no.id> from "jlim" at Feb 14, 2008 06:27:52 PM
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
+++ b/kernel/time.c	Tue Feb 19 12:44:03 PST 2008
@@ -268,6 +268,14 @@ unsigned int inline jiffies_to_usecs(con
 }
 EXPORT_SYMBOL(jiffies_to_usecs);
 
+u64 inline jiffies_64_to_usecs(const u64 j)
+{
+	u64 tmp = j*HZ_TO_USEC_NUM + HZ_TO_USEC_DEN-1;
+	do_div(tmp, HZ_TO_USEC_DEN);
+	return tmp;
+}
+EXPORT_SYMBOL(jiffies_64_to_usecs);
+
 /**
  * timespec_trunc - Truncate timespec to a granularity
  * @t: Timespec
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
