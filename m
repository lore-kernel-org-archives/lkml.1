Return-Path: <linux-kernel-owner+w=401wt.eu-S1755003AbZCFOkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbZCFOkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 09:40:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbZCFOkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 09:40:01 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43892 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZCFOkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 09:40:01 -0500
Subject: [RFC][PATCH]: wait: don't resched in prepare_to_wait()
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <onestero@redhat.com>, Nick Piggin <npiggin@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 15:39:37 +0100
Message-Id: <1236350377.6326.389.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does the below make sense?

After prepare to wait, we either call schedule() or find !cond in which
case we'll call finish_wait() which contains another preemption check.

Not-signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/wait.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/wait.c b/kernel/wait.c
index 42a2dbc..7b866ab 100644
--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -73,7 +73,9 @@ prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state)
 	if (list_empty(&wait->task_list))
 		__add_wait_queue(q, wait);
 	set_current_state(state);
+	preempt_disable();
 	spin_unlock_irqrestore(&q->lock, flags);
+	preempt_enable_no_resched();
 }
 EXPORT_SYMBOL(prepare_to_wait);
 
@@ -87,7 +89,9 @@ prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state)
 	if (list_empty(&wait->task_list))
 		__add_wait_queue_tail(q, wait);
 	set_current_state(state);
+	preempt_disable();
 	spin_unlock_irqrestore(&q->lock, flags);
+	preempt_enable_no_resched();
 }
 EXPORT_SYMBOL(prepare_to_wait_exclusive);
 


