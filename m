Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbYFKUyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbYFKUyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756005AbYFKUx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:53:56 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:6937 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755953AbYFKUxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:53:52 -0400
Message-Id: <20080611204917.136735991@mvista.com>
References: <20080611204916.271608740@mvista.com>
User-Agent: quilt/0.46-1
Date: Wed, 11 Jun 2008 13:49:18 -0700
Subject: [PATCH 2/5] futex: update prio on requeue
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: Ulrich Drepper <drepper@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Content-Disposition: inline; filename=futex-update-prio-on-requeue.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the priority may have changed, the requeue is a good place to update
the priority since we're already deleting and adding to a new list.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 kernel/futex.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.25/kernel/futex.c
===================================================================
--- linux-2.6.25.orig/kernel/futex.c
+++ linux-2.6.25/kernel/futex.c
@@ -980,7 +980,10 @@ static int futex_requeue(u32 __user *uad
 			 * requeue.
 			 */
 			if (likely(head1 != &hb2->chain)) {
+				struct task_struct *task = this->task;
+				int prio = min(task->normal_prio, MAX_RT_PRIO);
 				plist_del(&this->list, &hb1->chain);
+				plist_node_init(&this->list, prio);
 				plist_add(&this->list, &hb2->chain);
 				this->lock_ptr = &hb2->lock;
 #ifdef CONFIG_DEBUG_PI_LIST

-- 
