Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbXDZNla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbXDZNla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 09:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbXDZNlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 09:41:07 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56754 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791AbXDZNlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 09:41:03 -0400
Date: Thu, 26 Apr 2007 19:10:59 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH -mm] Move frozen_process() to kernel/power/process.c
Message-ID: <20070426134059.GA25992@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070419120131.GB13435@in.ibm.com> <20070420180208.GA721@tv-sign.ru> <20070423102618.GA25144@in.ibm.com> <200704260044.03975.rjw@sisk.pl> <20070425231638.GH15134@in.ibm.com> <20070425163409.4f8476c4.akpm@linux-foundation.org> <20070426060608.GA12892@in.ibm.com> <20070425231232.302a83f0.akpm@linux-foundation.org> <20070426131155.GE12892@in.ibm.com> <20070426123609.GA1076@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426123609.GA1076@tv-sign.ru>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 04:36:09PM +0400, Oleg Nesterov wrote:
> On 04/26, Gautham R Shenoy wrote:
> > 
> > Other than refrigerator, no one else calls frozen_process(). So move it from
> > include/linux/freezer.h to kernel/power/process.c.
> 
> Could you also remove this
> 
> 	static inline void frozen_process(struct task_struct *p) { BUG(); }
> 
> from freezer.h ?

Sure. Here's a more complete patch.

Thanks and Regards
gautham.

-->
Other than refrigerator, no one else calls frozen_process(). So move it
from include/linux/freezer.h to kernel/power/process.c.

Also, since a task can be marked frozen by itself, we don't need to pass
the (struct task_struct *p) parameter to frozen_process().

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---
 include/linux/freezer.h |   13 -------------
 kernel/power/process.c  |   14 +++++++++++++-
 2 files changed, 13 insertions(+), 14 deletions(-)

Index: linux-2.6.21-rc7/include/linux/freezer.h
===================================================================
--- linux-2.6.21-rc7.orig/include/linux/freezer.h
+++ linux-2.6.21-rc7/include/linux/freezer.h
@@ -58,18 +58,6 @@ static inline int thaw_process(struct ta
 	return 0;
 }
 
-/*
- * freezing is complete, mark process as frozen
- */
-static inline void frozen_process(struct task_struct *p)
-{
-	if (!unlikely(p->flags & PF_NOFREEZE)) {
-		p->flags |= PF_FROZEN;
-		wmb();
-	}
-	clear_tsk_thread_flag(p, TIF_FREEZE);
-}
-
 extern void refrigerator(void);
 extern int freeze_processes(void);
 extern void thaw_processes(void);
@@ -132,7 +120,6 @@ static inline int frozen(struct task_str
 static inline int freezing(struct task_struct *p) { return 0; }
 static inline void freeze(struct task_struct *p) { BUG(); }
 static inline int thaw_process(struct task_struct *p) { return 1; }
-static inline void frozen_process(struct task_struct *p) { BUG(); }
 
 static inline void refrigerator(void) {}
 static inline int freeze_processes(void) { BUG(); return 0; }
Index: linux-2.6.21-rc7/kernel/power/process.c
===================================================================
--- linux-2.6.21-rc7.orig/kernel/power/process.c
+++ linux-2.6.21-rc7/kernel/power/process.c
@@ -32,6 +32,18 @@ static inline int freezeable(struct task
 	return 1;
 }
 
+/*
+ * freezing is complete, mark current process as frozen
+ */
+static inline void frozen_process(void)
+{
+	if (!unlikely(current->flags & PF_NOFREEZE)) {
+		current->flags |= PF_FROZEN;
+		wmb();
+	}
+	clear_tsk_thread_flag(current, TIF_FREEZE);
+}
+
 /* Refrigerator is place where frozen processes are stored :-). */
 void refrigerator(void)
 {
@@ -41,7 +53,7 @@ void refrigerator(void)
 
 	task_lock(current);
 	if (freezing(current)) {
-		frozen_process(current);
+		frozen_process();
 		task_unlock(current);
 	} else {
 		task_unlock(current);

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
