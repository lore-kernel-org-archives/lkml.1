Return-Path: <linux-kernel-owner+w=401wt.eu-S934255AbZGQImQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934255AbZGQImQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 04:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934239AbZGQImQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 04:42:16 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:57171 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934228AbZGQImP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 04:42:15 -0400
X-IronPort-AV: E=Sophos;i="4.42,416,1243828800"; 
   d="scan'208";a="1672352"
From: Barry Song <21cnbao@gmail.com>
To: mingo@redhat.com, dahlmann.thomas@arcor.de
CC: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Barry Song <21cnbao@gmail.com>
Subject: [PATCH] Delete redundant IRQ_DISABLED check in irq_thread
Date: Fri, 17 Jul 2009 16:43:49 +0800
Message-ID: <1247820229-4983-1-git-send-email-21cnbao@gmail.com>
X-Mailer: git-send-email 1.5.6.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Barry Song <21cnbao@gmail.com>
I think it is completely redundant to check IRQ_DISABLED to decide whether thread_fn will be called.

At first, the irq_thread is waken up by HARDIRQ handler, if IRQ_DISABLED is true, HARDIRQ will have no chance to run, then irq_thread will not run. So there is only a situation that both HARDIRQ can run and IRQ_DISABLED is set.
The case is that the flag is set in the interval of HARDIRQ enter and irq_thread is scheduled to run. I think there is nobody which is interested to disable irq in the interval except HARDIRQ handler itself. Then that causes the second problem I will explain.

Secondly, checking the flag causes some problems in fact. We often call disable_irq_nosync to diable irq in HARDIRQ to avoid flooding irq to follow. But the disable_irq_nosync will set IRQ_DISABLED flag, then that will prevent the execution of thread_fn. That's not the original idea to call disable_irq_nosync in HARDIRQ.

So I guess deleting the check is maybe better and more compact.

-Barry
---
 kernel/irq/manage.c |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 50da676..ff4e05d 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -460,22 +460,7 @@ static int irq_thread(void *data)
 
 		atomic_inc(&desc->threads_active);
 
-		spin_lock_irq(&desc->lock);
-		if (unlikely(desc->status & IRQ_DISABLED)) {
-			/*
-			 * CHECKME: We might need a dedicated
-			 * IRQ_THREAD_PENDING flag here, which
-			 * retriggers the thread in check_irq_resend()
-			 * but AFAICT IRQ_PENDING should be fine as it
-			 * retriggers the interrupt itself --- tglx
-			 */
-			desc->status |= IRQ_PENDING;
-			spin_unlock_irq(&desc->lock);
-		} else {
-			spin_unlock_irq(&desc->lock);
-
-			action->thread_fn(action->irq, action->dev_id);
-		}
+		action->thread_fn(action->irq, action->dev_id);
 
 		wake = atomic_dec_and_test(&desc->threads_active);
 
-- 
1.5.6.3

