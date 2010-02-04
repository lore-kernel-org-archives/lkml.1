Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab0BDBrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 20:47:06 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62540 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab0BDBrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 20:47:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CIJ2YoaU4VK+rfO14168WMA4RHirOFDDyDDy1oZmLchy4hLcGM7GuS34F5uVjX3RbT
         TMOsw8HEB1BTqLdgeZccKhaTgSqlUNv8hpV8CWoXOOclRNbieL4BJdHfbwVf6R3/beYB
         Lm3/LIV+b9umXpAA4cNVVssqMD4BsaaIkp7MU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Maneesh Soni <maneesh@in.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin <schwidefsky@de.ibm.com>
Subject: [GIT PULL] hw-breakpoint fix
Date: Thu,  4 Feb 2010 02:46:54 +0100
Message-Id: <1265248014-7338-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/urgent branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/urgent

Thanks,
	Frederic
---

Mahesh Salgaonkar (1):
      perf: Make bp_len type to u64 generic across the arch


 include/linux/hw_breakpoint.h |    2 +-
 include/linux/perf_event.h    |    6 ++----
 kernel/hw_breakpoint.c        |    2 +-
 kernel/perf_event.c           |    2 +-
 4 files changed, 5 insertions(+), 7 deletions(-)

---
commit cd757645fbdc34a8343c04bb0e74e06fccc2cb10
Author: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Date:   Sat Jan 30 10:25:18 2010 +0530

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
