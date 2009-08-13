Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbZHMTCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbZHMTCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbZHMTCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:02:44 -0400
Received: from www.tglx.de ([62.245.132.106]:50978 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343AbZHMTCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:02:43 -0400
Date: Thu, 13 Aug 2009 21:02:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] genirq fixes for 2.6.31
Message-ID: <alpine.LFD.2.00.0908132100210.1283@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

Thanks,

	tglx

------------------>
Thomas Gleixner (1):
      genirq: Prevent race between free_irq() and handle_IRQ_event()


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
