Return-Path: <linux-kernel-owner+w=401wt.eu-S1760215AbZBLXSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215AbZBLXSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 18:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761465AbZBLXR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 18:17:57 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:40250 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761061AbZBLXR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 18:17:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:date:subject;
        b=f76MkohaxKBLqITtGbRBcSljnfNPQV6BIUgndC4Frtkh9C9CoYw47Yw+b9x3bmHsIT
         NZzWvlJNYyVn0WHuVaSL3lxYM/pgCP2pgm6HfBD2EEWb2TTQzPnM0bH4BDplJkAL+jj8
         mH3fBpZn+6YrrBBxCM94on2p410ip4/APu/h0=
Message-ID: <4994ae21.170e660a.5891.430d@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 12 Feb 2009 23:33:11 +0100
Subject: [PATCH 2/2] rt/threadirqs: remove pointless irq disabling on irq thread handlers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The handlers called by the irq thread lock the desc->lock by
using spin_lock_irq.
But at this stage, the irqs are already disabled at the end
of both handle_IRQ_event() processing and cond_resched_hardirq_context().

A single spin_lock is sufficient.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/irq/manage.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 6e9baf8..8e963a9 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -802,7 +802,7 @@ static void thread_simple_irq(irq_desc_t *desc)
 		spin_unlock(&desc->lock);
 		action_ret = handle_IRQ_event(irq, action);
 		cond_resched_hardirq_context();
-		spin_lock_irq(&desc->lock);
+		spin_lock(&desc->lock);
 		if (!noirqdebug)
 			note_interrupt(irq, desc, action_ret);
 	} while (desc->status & IRQ_PENDING);
@@ -863,7 +863,7 @@ static void thread_edge_irq(irq_desc_t *desc)
 		spin_unlock(&desc->lock);
 		action_ret = handle_IRQ_event(irq, action);
 		cond_resched_hardirq_context();
-		spin_lock_irq(&desc->lock);
+		spin_lock(&desc->lock);
 		if (!noirqdebug)
 			note_interrupt(irq, desc, action_ret);
 	} while ((desc->status & IRQ_PENDING) && !desc->depth);
@@ -892,7 +892,7 @@ static void thread_do_irq(irq_desc_t *desc)
 		spin_unlock(&desc->lock);
 		action_ret = handle_IRQ_event(irq, action);
 		cond_resched_hardirq_context();
-		spin_lock_irq(&desc->lock);
+		spin_lock(&desc->lock);
 		if (!noirqdebug)
 			note_interrupt(irq, desc, action_ret);
 	} while ((desc->status & IRQ_PENDING) && !desc->depth);
@@ -903,8 +903,6 @@ static void thread_do_irq(irq_desc_t *desc)
 
 static void do_hardirq(struct irq_desc *desc)
 {
-	unsigned long flags;
-
 	spin_lock(&desc->lock);
 
 	if (!(desc->status & IRQ_INPROGRESS))
-- 
1.6.1


