Return-Path: <linux-kernel-owner+w=401wt.eu-S1761264AbZBLXR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761264AbZBLXR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 18:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZBLXRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 18:17:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:36310 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbZBLXRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 18:17:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:date:subject;
        b=K1IEd6RxqE3yL76z0zCe33IasHV2rKyjbselc2pALwYYAtyHbP7kfiV9Nzjz/yJyK/
         8+NTT7YIQj7x55cqgJfSg1Op+mIeypxkai0vyMas2X8iF6qpVKed8s92GY837YM2lJzl
         KM+xYH8/CfUwq79Ow6Jl9oUZDN1U+veBA23Ic=
Message-ID: <4994ae18.1358560a.454d.403b@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 12 Feb 2009 19:27:08 +0100
Subject: [PATCH 1/2] rt/threadirqs: don't need to save irqs in do_hardirq()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_hardirq() has only one caller do_irqd() in a path where irq are already
disabled. So we don't need to save irqs while holding desc->lock

Replace spin_lock_irqsave by spin_lock.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/irq/manage.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index ed7c5e3..6e9baf8 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -905,7 +905,7 @@ static void do_hardirq(struct irq_desc *desc)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&desc->lock, flags);
+	spin_lock(&desc->lock);
 
 	if (!(desc->status & IRQ_INPROGRESS))
 		goto out;
@@ -921,7 +921,7 @@ static void do_hardirq(struct irq_desc *desc)
 	else
 		thread_do_irq(desc);
  out:
-	spin_unlock_irqrestore(&desc->lock, flags);
+	spin_unlock(&desc->lock);
 
 	if (waitqueue_active(&desc->wait_for_handler))
 		wake_up(&desc->wait_for_handler);
-- 
1.6.1


