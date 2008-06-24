Return-Path: <linux-kernel-owner+w=401wt.eu-S1757920AbYFXXWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbYFXXWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 19:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbYFXXVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 19:21:43 -0400
Received: from homer.mvista.com ([63.81.120.158]:38004 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753728AbYFXXVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 19:21:42 -0400
Message-Id: <20080624232019.985969773@mvista.com>
References: <20080624232018.817822790@mvista.com>
User-Agent: quilt/0.46-1
Date: Tue, 24 Jun 2008 16:20:20 -0700
Subject: [PATCH 2/6] futex: update prio on requeue
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Disposition: inline; filename=futex-update-prio-on-requeue.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the priority may have changed, the requeue is a good place to update
the priority since we're already deleting and adding to a new list.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 kernel/futex.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.25/kernel/futex.c
===================================================================
--- linux-2.6.25.orig/kernel/futex.c
+++ linux-2.6.25/kernel/futex.c
@@ -949,7 +949,11 @@ static int futex_requeue(u32 __user *uad
 			 * requeue.
 			 */
 			if (likely(head1 != &hb2->chain)) {
+				struct task_struct *task = this->task;
+				int prio = min(task->normal_prio, MAX_RT_PRIO);
+
 				plist_del(&this->list, &hb1->chain);
+				plist_node_init(&this->list, prio);
 				plist_add(&this->list, &hb2->chain);
 				this->lock_ptr = &hb2->lock;
 #ifdef CONFIG_DEBUG_PI_LIST

-- 
