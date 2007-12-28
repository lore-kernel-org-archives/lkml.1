Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbXL1VZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbXL1VZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 16:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbXL1VZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 16:25:28 -0500
Received: from relay1.sgi.com ([192.48.171.29]:60147 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751714AbXL1VZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 16:25:28 -0500
From: Jonathan Lim <jlim@sgi.com>
Message-Id: <200712282126.lBSLQ76K042714@sabah.engr.sgi.com>
Subject: [PATCH] Provide u64 version of jiffies_to_usecs() in kernel/tsacct.c
To: linux-kernel@vger.kernel.org
Date: Fri, 28 Dec 2007 13:26:07 -0800 (PST)
Cc: jlan@sgi.com
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

Diff'd against: linux/kernel/git/stable/linux-2.6.23.y.git

Signed-off-by: Jonathan Lim <jlim@sgi.com>

--- a/kernel/tsacct.c	2007-12-28 11:58:05.182065029 -0800
+++ b/kernel/tsacct.c	2007-12-28 11:57:37.949013675 -0800
@@ -71,6 +71,17 @@ void bacct_add_tsk(struct taskstats *sta
 
 #ifdef CONFIG_TASK_XACCT
 
+static inline u64 jiffies_to_usecs_u64(const u64 j)
+{
+#if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
+	return (USEC_PER_SEC / HZ) * j;
+#elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
+	return (j + (HZ / USEC_PER_SEC) - 1)/(HZ / USEC_PER_SEC);
+#else
+	return (j * USEC_PER_SEC) / HZ;
+#endif
+}
+
 #define KB 1024
 #define MB (1024*KB)
 /*
@@ -81,8 +92,8 @@ void xacct_add_tsk(struct taskstats *sta
 	struct mm_struct *mm;
 
 	/* convert pages-jiffies to Mbyte-usec */
-	stats->coremem = jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
-	stats->virtmem = jiffies_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
+	stats->coremem = jiffies_to_usecs_u64(p->acct_rss_mem1) * PAGE_SIZE / MB;
+	stats->virtmem = jiffies_to_usecs_u64(p->acct_vm_mem1) * PAGE_SIZE / MB;
 	mm = get_task_mm(p);
 	if (mm) {
 		/* adjust to KB unit */
