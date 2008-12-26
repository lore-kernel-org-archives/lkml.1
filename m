Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbYLZJNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbYLZJNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 04:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbYLZJNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 04:13:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52908 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbYLZJNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 04:13:31 -0500
Message-ID: <4954A02B.4060606@cn.fujitsu.com>
Date: Fri, 26 Dec 2008 17:13:15 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: [PATCH 1/2 -tip] irq: remove unneeded desc->chip->ack check
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

desc->chip->ack is initialized to ack_bad().
It will not be NULL.

Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
---
 kernel/irq/chip.c   |    3 +--
 kernel/irq/handle.c |   14 +++++---------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index f63c706..b929803 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -530,8 +530,7 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 
 	kstat_incr_irqs_this_cpu(irq, desc);
 
-	if (desc->chip->ack)
-		desc->chip->ack(irq);
+	desc->chip->ack(irq);
 
 	action_ret = handle_IRQ_event(irq, desc->action);
 	if (!noirqdebug)
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 6492400..4408672 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -337,11 +337,9 @@ unsigned int __do_IRQ(unsigned int irq)
 		/*
 		 * No locking required for CPU-local interrupts:
 		 */
-		if (desc->chip->ack) {
-			desc->chip->ack(irq);
-			/* get new one */
-			desc = irq_remap_to_desc(irq, desc);
-		}
+		desc->chip->ack(irq);
+		/* get new one */
+		desc = irq_remap_to_desc(irq, desc);
 		if (likely(!(desc->status & IRQ_DISABLED))) {
 			action_ret = handle_IRQ_event(irq, desc->action);
 			if (!noirqdebug)
@@ -352,10 +350,8 @@ unsigned int __do_IRQ(unsigned int irq)
 	}
 
 	spin_lock(&desc->lock);
-	if (desc->chip->ack) {
-		desc->chip->ack(irq);
-		desc = irq_remap_to_desc(irq, desc);
-	}
+	desc->chip->ack(irq);
+	desc = irq_remap_to_desc(irq, desc);
 	/*
 	 * REPLAY is when Linux resends an IRQ that was dropped earlier
 	 * WAITING is used by probe to mark irqs that are being tested
-- 
1.5.3.4



