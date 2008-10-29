Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbYJ2EnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbYJ2EnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 00:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbYJ2EnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 00:43:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:60844 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbYJ2EnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 00:43:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lrzy8bADeckSeGrhMSL5Fe5xaAhXQys5prl29SgpMwyCtJuYTSMNdwY5jbOuNxy3hp
         zDihu2vXqqDIQHpVIGq9gaqzvWq6P8pG57bZfANrJPVmCR4kMain4vw0Y9iA8FLxr6as
         7zCpQHRfpNlygjxaRKL7azMeg88hrOZs8PS64=
Date: Wed, 29 Oct 2008 07:44:47 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@osdl.org
Cc: viro@zeniv.linux.org.uk, acme@ghostprotocols.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] headers: move release_kernel_lock(),
	reacquire_kernel_lock() to sched.c
Message-ID: <20081029044447.GB2304@x200.localdomain>
References: <20081029044351.GA2304@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029044351.GA2304@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 21b76c6e7d2340805664b91dc1c83eb23c6f785d Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 27 Oct 2008 00:57:28 +0300
Subject: [PATCH 1/2] headers: move release_kernel_lock(), reacquire_kernel_lock() to sched.c

Both are used only by scheduler, both are low-level enough to not allow in
drivers. Removal allows to remove sched.h from smp_lock.h, which is needed
solely for inline function.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 include/linux/smp_lock.h |   18 ------------------
 kernel/sched.c           |   20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/include/linux/smp_lock.h b/include/linux/smp_lock.h
index 813be59..6052f02 100644
--- a/include/linux/smp_lock.h
+++ b/include/linux/smp_lock.h
@@ -8,22 +8,6 @@
 
 extern int __lockfunc __reacquire_kernel_lock(void);
 extern void __lockfunc __release_kernel_lock(void);
-
-/*
- * Release/re-acquire global kernel lock for the scheduler
- */
-#define release_kernel_lock(tsk) do { 		\
-	if (unlikely((tsk)->lock_depth >= 0))	\
-		__release_kernel_lock();	\
-} while (0)
-
-static inline int reacquire_kernel_lock(struct task_struct *task)
-{
-	if (unlikely(task->lock_depth >= 0))
-		return __reacquire_kernel_lock();
-	return 0;
-}
-
 extern void __lockfunc lock_kernel(void)	__acquires(kernel_lock);
 extern void __lockfunc unlock_kernel(void)	__releases(kernel_lock);
 
@@ -43,9 +27,7 @@ static inline void cycle_kernel_lock(void)
 
 #define lock_kernel()				do { } while(0)
 #define unlock_kernel()				do { } while(0)
-#define release_kernel_lock(task)		do { } while(0)
 #define cycle_kernel_lock()			do { } while(0)
-#define reacquire_kernel_lock(task)		0
 #define kernel_locked()				1
 
 #endif /* CONFIG_LOCK_KERNEL */
diff --git a/kernel/sched.c b/kernel/sched.c
index 6625c3c..96a4462 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -79,6 +79,26 @@
 
 #include "sched_cpupri.h"
 
+#ifdef CONFIG_LOCK_KERNEL
+/*
+ * Release/re-acquire global kernel lock for the scheduler
+ */
+#define release_kernel_lock(tsk) do { 		\
+	if (unlikely((tsk)->lock_depth >= 0))	\
+		__release_kernel_lock();	\
+} while (0)
+
+static inline int reacquire_kernel_lock(struct task_struct *task)
+{
+	if (unlikely(task->lock_depth >= 0))
+		return __reacquire_kernel_lock();
+	return 0;
+}
+#else
+#define release_kernel_lock(task)		do { } while(0)
+#define reacquire_kernel_lock(task)		0
+#endif
+
 /*
  * Convert user-nice values [ -20 ... 0 ... 19 ]
  * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
-- 
1.5.6.5

