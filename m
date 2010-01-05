Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577Ab0AEONg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab0AEONg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 09:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545Ab0AEON3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 09:13:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539Ab0AEON1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 09:13:27 -0500
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org
Subject: [PATCH v3 10/12] Handle async PF in non preemptable context
Date: Tue,  5 Jan 2010 16:12:52 +0200
Message-Id: <1262700774-1808-11-git-send-email-gleb@redhat.com>
In-Reply-To: <1262700774-1808-1-git-send-email-gleb@redhat.com>
References: <1262700774-1808-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If async page fault is received by idle task or when preemp_count is
not zero guest cannot reschedule, so do sti; hlt and wait for page to be
ready. vcpu can still process interrupts while it waits for the page to
be ready.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/kernel/kvm.c |   36 ++++++++++++++++++++++++++++++++----
 1 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 2245f35..49549fd 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -33,6 +33,7 @@
 #include <linux/sched.h>
 #include <asm/timer.h>
 #include <asm/cpu.h>
+#include <asm/tlbflush.h>
 
 #define MMU_QUEUE_SIZE 1024
 
@@ -64,6 +65,8 @@ struct kvm_task_sleep_node {
 	wait_queue_head_t wq;
 	u32 token;
 	int cpu;
+	bool halted;
+	struct mm_struct *mm;
 };
 
 static struct kvm_task_sleep_head {
@@ -92,6 +95,11 @@ static void apf_task_wait(struct task_struct *tsk, u32 token)
 	struct kvm_task_sleep_head *b = &async_pf_sleepers[key];
 	struct kvm_task_sleep_node n, *e;
 	DEFINE_WAIT(wait);
+	int cpu, idle;
+
+	cpu = get_cpu();
+	idle = idle_cpu(cpu);
+	put_cpu();
 
 	spin_lock(&b->lock);
 	e = _find_apf_task(b, token);
@@ -105,17 +113,31 @@ static void apf_task_wait(struct task_struct *tsk, u32 token)
 
 	n.token = token;
 	n.cpu = smp_processor_id();
+	n.mm = percpu_read(cpu_tlbstate.active_mm);
+	n.halted = idle || preempt_count() > 1;
+	atomic_inc(&n.mm->mm_count);
 	init_waitqueue_head(&n.wq);
 	hlist_add_head(&n.link, &b->list);
 	spin_unlock(&b->lock);
 
 	for (;;) {
-		prepare_to_wait(&n.wq, &wait, TASK_UNINTERRUPTIBLE);
+		if (!n.halted)
+			prepare_to_wait(&n.wq, &wait, TASK_UNINTERRUPTIBLE);
 		if (hlist_unhashed(&n.link))
 			break;
-		schedule();
+
+		if (!n.halted) {
+			schedule();
+		} else {
+			/*
+			 * We cannot reschedule. So halt.
+			 */
+			native_safe_halt();
+			local_irq_disable();
+		}
 	}
-	finish_wait(&n.wq, &wait);
+	if (!n.halted)
+		finish_wait(&n.wq, &wait);
 
 	return;
 }
@@ -123,7 +145,12 @@ static void apf_task_wait(struct task_struct *tsk, u32 token)
 static void apf_task_wake_one(struct kvm_task_sleep_node *n)
 {
 	hlist_del_init(&n->link);
-	if (waitqueue_active(&n->wq))
+	if (!n->mm)
+		return;
+	mmdrop(n->mm);
+	if (n->halted)
+		smp_send_reschedule(n->cpu);
+	else if (waitqueue_active(&n->wq))
 		wake_up(&n->wq);
 }
 
@@ -153,6 +180,7 @@ again:
 		}
 		n->token = token;
 		n->cpu = smp_processor_id();
+		n->mm = NULL;
 		init_waitqueue_head(&n->wq);
 		hlist_add_head(&n->link, &b->list);
 	} else
-- 
1.6.5

