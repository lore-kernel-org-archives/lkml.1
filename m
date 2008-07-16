Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbYGPAYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbYGPAYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbYGPAXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:23:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:8513 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbYGPAXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:23:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=MEBmYA0ZfEQuDLoDuGNVep1+AF7VtSDQ18MNEWvnXhRBp3z8l4bMBO1KQ2k5kXsSYR
         L84km7R6Mnl3uqQHS9WXvYFerewGzpul928dBiD/KlGF6HdZM+yU6T2NjFVR8FUDGPEr
         1f51vLzvUZNVxkqg9qDu06DNrRtseJ7OuWSic=
Date: Wed, 16 Jul 2008 02:23:08 +0200
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/13] tasklets: new tasklet scheduling function
Message-ID: <20080716002308.GF12564@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 56191494294198977f7db536988291199881c751 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Wed, 21 May 2008 22:53:13 +0200
Subject: [PATCH 05/13] tasklets: new tasklet scheduling function

Rationale: kmemcheck needs to be able to schedule a tasklet without
touching any dynamically allocated memory _at_ _all_ (since that would
lead to a recursive page fault). This tasklet is used for writing the
error reports to the kernel log.

The new scheduling function avoids touching any other tasklets by
inserting the new tasklist as the head of the "tasklet_hi" list instead
of on the tail.

Also don't wake up the softirq thread lest the scheduler access some
tracked memory and we go down with a recursive page fault.

In this case, we'd better just wait for the maximum time of 1/HZ for the
message to appear.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/linux/interrupt.h |   14 ++++++++++++++
 kernel/softirq.c          |   11 +++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index f1fc747..ce0598b 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -377,6 +377,20 @@ static inline void tasklet_hi_schedule(struct tasklet_struct *t)
 		__tasklet_hi_schedule(t);
 }
 
+extern void __tasklet_hi_schedule_first(struct tasklet_struct *t);
+
+/*
+ * This version avoids touching any other tasklets. Needed for kmemcheck
+ * in order not to take any page faults while enqueueing this tasklet;
+ * consider VERY carefully whether you really need this or
+ * tasklet_hi_schedule()...
+ */
+static inline void tasklet_hi_schedule_first(struct tasklet_struct *t)
+{
+	if (!test_and_set_bit(TASKLET_STATE_SCHED, &t->state))
+		__tasklet_hi_schedule_first(t);
+}
+
 
 static inline void tasklet_disable_nosync(struct tasklet_struct *t)
 {
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 36e0617..23dc889 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -393,6 +393,17 @@ void __tasklet_hi_schedule(struct tasklet_struct *t)
 
 EXPORT_SYMBOL(__tasklet_hi_schedule);
 
+void __tasklet_hi_schedule_first(struct tasklet_struct *t)
+{
+	BUG_ON(!irqs_disabled());
+
+	t->next = __get_cpu_var(tasklet_hi_vec).head;
+	__get_cpu_var(tasklet_hi_vec).head = t;
+	__raise_softirq_irqoff(HI_SOFTIRQ);
+}
+
+EXPORT_SYMBOL(__tasklet_hi_schedule_first);
+
 static void tasklet_action(struct softirq_action *a)
 {
 	struct tasklet_struct *list;
-- 
1.5.5.1

