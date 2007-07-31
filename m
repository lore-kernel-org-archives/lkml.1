Return-Path: <linux-kernel-owner+w=401wt.eu-S1764071AbXGaNZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764071AbXGaNZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759625AbXGaNYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:24:43 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:49915
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761606AbXGaNYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:24:40 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/2] RT: Add priority inheritance to the VFCIPI facility
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ghaskins@novell.com
Date: Tue, 31 Jul 2007 09:24:23 -0400
Message-ID: <20070731132423.4790.19170.stgit@novell1.haskins.net>
In-Reply-To: <20070731132153.4790.37217.stgit@novell1.haskins.net>
References: <20070731132153.4790.37217.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/vfcipi/thread.c |  144 ++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 131 insertions(+), 13 deletions(-)

diff --git a/kernel/vfcipi/thread.c b/kernel/vfcipi/thread.c
index 45bb4e2..306560a 100644
--- a/kernel/vfcipi/thread.c
+++ b/kernel/vfcipi/thread.c
@@ -27,6 +27,7 @@
 #include <linux/irqflags.h>
 #include <linux/module.h>
 #include <linux/cpumask.h>
+#include <linux/syscalls.h>
 
 #include <asm/atomic.h>
 #include <asm/cmpxchg.h>
@@ -53,9 +54,16 @@ struct vfcipi_queueitem {
 	struct vfcipi_workitem *item;
 };
 
+struct prio_array {
+	DECLARE_BITMAP(bitmap, MAX_RT_PRIO+1); /* include 1 bit for delimiter */
+	unsigned long	 count;
+	struct list_head queue[MAX_RT_PRIO];
+};
+
 struct vfcipi_task {
 	raw_spinlock_t	    lock;
 	struct task_struct *task;
+	int                 prio;
 	struct prio_array   rt_rq; /* Real-time request queue */
 	struct list_head    rq;	   /* Normal request queue */
 };
@@ -64,6 +72,67 @@ static DEFINE_PER_CPU(struct vfcipi_task*, vfcipi_tasks);
 
 /*
  * ----------------------------------------
+ * prio_array
+ * ----------------------------------------
+ */
+static void prio_array_init(struct prio_array *array)
+{
+	int i;
+
+	memset(array->bitmap, 0, sizeof(array->bitmap));
+	array->count = 0;
+
+	for (i=0; i<MAX_RT_PRIO; i++)
+		INIT_LIST_HEAD(&array->queue[i]);
+}
+
+/* Note: prio_array code credit goes to the RT scheduler...*/
+static struct vfcipi_queueitem* prio_array_dequeue(struct prio_array *array)
+{
+	struct list_head        *head;
+	struct vfcipi_queueitem *qi;
+	int			 idx;
+
+	if (!array->count)
+		return NULL;
+
+	idx = sched_find_first_bit(array->bitmap);
+
+	head = array->queue + idx;
+
+	/* If we got here, there better be something in the list */
+	BUG_ON(!head);
+	BUG_ON(list_empty(head));
+
+	qi = list_first_entry(head, struct vfcipi_queueitem, list);
+	BUG_ON(!qi);
+
+	list_del(&qi->list);
+	array->count--;
+
+	if (list_empty(head))
+		__clear_bit(idx, &array->bitmap);
+
+	return qi;
+}
+
+static void prio_array_enqueue(struct prio_array *array,
+			       struct vfcipi_queueitem *qi,
+			       int prio)
+{
+	struct list_head *head;
+
+	BUG_ON(prio < 0);
+	BUG_ON(prio > MAX_RT_PRIO);
+
+	head = array->queue + prio;
+	list_add_tail(&qi->list, head);
+	__set_bit(prio, &array->bitmap);
+	array->count++;
+}
+
+/*
+ * ----------------------------------------
  * vfcipi_status
  * ----------------------------------------
  */
@@ -154,9 +223,33 @@ static void vfcipi_workitem_wait(struct vfcipi_workitem *item, int wait)
 		 * function completes entirely.
 		 */
 		vfcipi_status_wait(&item->finished);
+}
 
+/*
+ * ----------------------------------------
+ * priority-inheritance helpers
+ * ----------------------------------------
+ */
+
+/* Assumes ftask->lock is held */
+static void vfcipi_task_setprio(struct vfcipi_task *ftask, int prio)
+{
+	struct sched_param param = { 0, };
+	pid_t              pid   = ftask->task->pid;
+
+	if (ftask->prio != prio) {
+		if (prio != -1) {
+			param.sched_priority = prio;
+			sys_sched_setscheduler(pid, SCHED_FIFO, &param);
+		} else {
+			sys_sched_setscheduler(pid, SCHED_NORMAL, &param);
+		}
+
+		ftask->prio = prio;
+	}
 }
 
+
 /*
  * ----------------------------------------
  * vfcipi_thread - daemon process for vfcipi per CPU
@@ -169,33 +262,48 @@ static int vfcipi_thread(void *data)
 
 	while (1) {
 		struct vfcipi_workitem *item;
-		struct vfcipi_queueitem *qi = NULL;
+		struct vfcipi_queueitem *qi;
 
 		spin_lock(&ftask->lock);
 		
-		if (!list_empty(&ftask->rq)) {
-			qi = list_first_entry(&ftask->rq,
-					      struct vfcipi_queueitem,
-					      list);
-			BUG_ON(!qi);
-			list_del(&qi->list);
-		}
-
+		/* First check the RT items */
+		qi  = prio_array_dequeue(&ftask->rt_rq);
+		if (!qi) {
+			/* If nothing is found there, check the normal queue */
+			if (!list_empty(&ftask->rq)) {
+				qi = list_first_entry(&ftask->rq,
+						      struct vfcipi_queueitem,
+						      list);
+				BUG_ON(!qi);
+				list_del(&qi->list);
+			}
+ 		}
+ 
 		if (!qi) {
 			/* Nothing to process for now.. */
+
+			/* Set us back to normal priority */
+			vfcipi_task_setprio(ftask, -1);
+
 			set_current_state(TASK_INTERRUPTIBLE);
 			spin_unlock(&ftask->lock);
 			schedule();
 			continue;
 		}
 
+		item = qi->item;
+
+		/*
+		 * Adjust the priority of our task based on what was pulled
+		 * from the queue.  In theory, its our highest priority item
+		 */
+		vfcipi_task_setprio(ftask, item->prio);
+
 		spin_unlock(&ftask->lock);
 
 		/*
-		 * Extract the real pointer and discard the queueitem shell.
-		 * We no longer need it.
+		 * Discard the shell since the item is already extracted.
 		 */
-		item = qi->item;
 		vfcipi_heap_free(qi);
 
 		/*
@@ -235,7 +343,15 @@ static int vfcipi_enqueue(struct vfcipi_workitem *item, int cpu)
 
 	spin_lock(&ftask->lock);
 
-	list_add_tail(&qi->list, &ftask->rq);
+	if (rt_task(current)) {
+		item->prio = current->rt_priority;
+		prio_array_enqueue(&ftask->rt_rq, qi, item->prio);
+
+		/* Priority inheritance on the kthread */
+		if (ftask->prio < item->prio)
+			vfcipi_task_setprio(ftask, item->prio);
+	} else
+		list_add_tail(&qi->list, &ftask->rq);
 
 	wake_up_process(ftask->task);
 
@@ -346,6 +462,8 @@ int __init vfcipi_init(void)
 			goto out_free;
 
 		spin_lock_init(&ftask->lock);
+		ftask->prio = -1;
+		prio_array_init(&ftask->rt_rq);
 		INIT_LIST_HEAD(&ftask->rq);
 		per_cpu(vfcipi_tasks, cpu) = ftask;
 

