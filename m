Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbZHLPwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbZHLPwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbZHLPwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:52:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:40392 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbZHLPwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:52:19 -0400
Date: Wed, 12 Aug 2009 15:51:58 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:irq/urgent] genirq: Prevent race between free_irq() and handle_IRQ_event()
Message-ID: <tip-84b277af44cadb263d8d588b0c0b7d5d85f5bc2a@git.kernel.org>
Git-Commit-ID: 84b277af44cadb263d8d588b0c0b7d5d85f5bc2a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 12 Aug 2009 15:51:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84b277af44cadb263d8d588b0c0b7d5d85f5bc2a
Gitweb:     http://git.kernel.org/tip/84b277af44cadb263d8d588b0c0b7d5d85f5bc2a
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 12 Aug 2009 17:22:02 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 12 Aug 2009 17:24:16 +0200

genirq: Prevent race between free_irq() and handle_IRQ_event()

If an interrupt is freed we do not check whether the interrupt is in
progress when we remove the action from the action chain. With
threaded handlers this can race against wake_up_process(action->thread)
in handle_IRQ_event and wake_up_process() might dereference a NULL
pointer.

Check action->thread before we call wake_up_process()

LKML-Reference: <new-submission>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 kernel/irq/handle.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 065205b..4e7f17a 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -403,8 +403,16 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 			 */
 			if (likely(!test_bit(IRQTF_DIED,
 					     &action->thread_flags))) {
+				struct task_struct *tsk = action->thread;
+
 				set_bit(IRQTF_RUNTHREAD, &action->thread_flags);
-				wake_up_process(action->thread);
+				/*
+				 * Check tsk as we might race against
+				 * free_irq which sets action->thread
+				 * to NULL
+				 */
+				if (tsk)
+					wake_up_process(tsk);
 			}
 
 			/* Fall through to add to randomness */
