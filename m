Return-Path: <linux-kernel-owner+w=401wt.eu-S1759591AbYEUVOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591AbYEUVOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761116AbYEUVLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:11:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:9883 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937526AbYEUVLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:11:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=iuF10JsouVN0N/ek4m+ADuzA2oFRATYYuI9AMVm9B6FevxDrcDWgqhZwZT4HRMzmiKFEuONuzVDMxAoCxsQZivFUTNGjFhGgUWnmhFZNcCEr3dH487JL2lGShJq9Uzx0qrQOEYHxcvShDrwu5hIns7nENAySeCXFTB7xMLK2sv8=
Date: Wed, 21 May 2008 23:11:29 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] tasklets: new tasklet scheduling function
Message-ID: <20080521211129.GA11061@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Does this seem like anything that has even a remote possibility of entering
the Kernel? It's not a strict requirement for kmemcheck, but it's extremely
nice compared to the 1 Hz timer I've been using till now.

(Again, I can put it in my queue for now, but it would be nice to have the
necessary Signed-off-bys for when it gets merged. I mean, _if_ it gets
merged...)

Vegard


From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Wed, 21 May 2008 22:53:13 +0200
Subject: [PATCH] tasklets: new tasklet scheduling function

Rationale: kmemcheck needs to be able to schedule a tasklet without
touching any dynamically allocated memory _at_ _all_ (since that would
lead to a recursive page fault). This tasklet is used for writing the
error reports to the kernel log.

The new scheduling function avoids touching any other tasklets by
inserting the new tasklist as the head of the "tasklet_hi" list instead
of on the tail.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/linux/interrupt.h |   14 ++++++++++++++
 kernel/softirq.c          |   13 +++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

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
index 36e0617..b2edfbe 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -393,6 +393,19 @@ void __tasklet_hi_schedule(struct tasklet_struct *t)
 
 EXPORT_SYMBOL(__tasklet_hi_schedule);
 
+void __tasklet_hi_schedule_first(struct tasklet_struct *t)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	t->next = __get_cpu_var(tasklet_hi_vec).head;
+	__get_cpu_var(tasklet_hi_vec).head = t;
+	raise_softirq_irqoff(TASKLET_SOFTIRQ);
+	local_irq_restore(flags);
+}
+
+EXPORT_SYMBOL(__tasklet_hi_schedule_first);
+
 static void tasklet_action(struct softirq_action *a)
 {
 	struct tasklet_struct *list;
-- 
1.5.4.1

