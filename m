Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab0BDJwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:52:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:52011 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756340Ab0BDJwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:52:20 -0500
Date: Thu, 4 Feb 2010 09:51:42 GMT
From: tip-bot for Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, maneesh@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, schwidefsky@de.ibm.com, peterz@infradead.org,
       mahesh@linux.vnet.ibm.com, ananth@in.ibm.com, fweisbec@gmail.com,
       heiko.carstens@de.ibm.com, tglx@linutronix.de,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, maneesh@in.ibm.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org,
       schwidefsky@de.ibm.com, mahesh@linux.vnet.ibm.com, ananth@in.ibm.com,
       fweisbec@gmail.com, heiko.carstens@de.ibm.com, tglx@linutronix.de,
       prasad@linux.vnet.ibm.com
In-Reply-To: <20100130045518.GA20776@in.ibm.com>
References: <20100130045518.GA20776@in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Make bp_len type to u64 generic across the arch
Message-ID: <tip-cd757645fbdc34a8343c04bb0e74e06fccc2cb10@git.kernel.org>
Git-Commit-ID: cd757645fbdc34a8343c04bb0e74e06fccc2cb10
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 09:51:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd757645fbdc34a8343c04bb0e74e06fccc2cb10
Gitweb:     http://git.kernel.org/tip/cd757645fbdc34a8343c04bb0e74e06fccc2cb10
Author:     Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
AuthorDate: Sat, 30 Jan 2010 10:25:18 +0530
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Thu, 4 Feb 2010 01:07:12 +0100

perf: Make bp_len type to u64 generic across the arch

Change 'bp_len' type to __u64 to make it work across archs as
the s390 architecture watch point length can be upto 2^64.

reference:
	http://lkml.org/lkml/2010/1/25/212

This is an ABI change that is not backward compatible with
the previous hardware breakpoint info layout integrated in this
development cycle, a rebuilt of perf tools is necessary for
versions based on 2.6.33-rc1 - 2.6.33-rc6 to work with a
kernel based on this patch.

Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: "K. Prasad" <prasad@linux.vnet.ibm.com>
Cc: Maneesh Soni <maneesh@in.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin <schwidefsky@de.ibm.com>
LKML-Reference: <20100130045518.GA20776@in.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/hw_breakpoint.h |    2 +-
 include/linux/perf_event.h    |    6 ++----
 kernel/hw_breakpoint.c        |    2 +-
 kernel/perf_event.c           |    2 +-
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 070ba06..5977b72 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -44,7 +44,7 @@ static inline int hw_breakpoint_type(struct perf_event *bp)
 	return bp->attr.bp_type;
 }
 
-static inline int hw_breakpoint_len(struct perf_event *bp)
+static inline unsigned long hw_breakpoint_len(struct perf_event *bp)
 {
 	return bp->attr.bp_len;
 }
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8fa7187..a177698 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -211,11 +211,9 @@ struct perf_event_attr {
 		__u32		wakeup_watermark; /* bytes before wakeup   */
 	};
 
-	__u32			__reserved_2;
-
-	__u64			bp_addr;
 	__u32			bp_type;
-	__u32			bp_len;
+	__u64			bp_addr;
+	__u64			bp_len;
 };
 
 /*
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 8a5c7d5..967e661 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -360,8 +360,8 @@ EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
 int modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr)
 {
 	u64 old_addr = bp->attr.bp_addr;
+	u64 old_len = bp->attr.bp_len;
 	int old_type = bp->attr.bp_type;
-	int old_len = bp->attr.bp_len;
 	int err = 0;
 
 	perf_event_disable(bp);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index d27746b..2b19297 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4580,7 +4580,7 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	if (attr->type >= PERF_TYPE_MAX)
 		return -EINVAL;
 
-	if (attr->__reserved_1 || attr->__reserved_2)
+	if (attr->__reserved_1)
 		return -EINVAL;
 
 	if (attr->sample_type & ~(PERF_SAMPLE_MAX-1))
