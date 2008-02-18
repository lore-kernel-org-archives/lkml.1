Return-Path: <linux-kernel-owner+w=401wt.eu-S1758484AbYBRREi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484AbYBRREi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 12:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbYBRRE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 12:04:29 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:50189 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbYBRRE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 12:04:28 -0500
Date: Mon, 18 Feb 2008 20:07:32 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] lock_task_sighand: add rcu lock/unlock
Message-ID: <20080218170732.GA2712@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the callers of lock_task_sighand() doesn't actually need rcu_lock().
lock_task_sighand() needs it only to safely play with tsk->sighand, it can take
the lock itself.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~1_LTS_RCU	2008-02-15 20:34:32.000000000 +0300
+++ 25/kernel/signal.c	2008-02-18 18:35:04.000000000 +0300
@@ -978,13 +978,11 @@ int fastcall __fatal_signal_pending(stru
 }
 EXPORT_SYMBOL(__fatal_signal_pending);
 
-/*
- * Must be called under rcu_read_lock() or with tasklist_lock read-held.
- */
 struct sighand_struct *lock_task_sighand(struct task_struct *tsk, unsigned long *flags)
 {
 	struct sighand_struct *sighand;
 
+	rcu_read_lock();
 	for (;;) {
 		sighand = rcu_dereference(tsk->sighand);
 		if (unlikely(sighand == NULL))
@@ -995,6 +993,7 @@ struct sighand_struct *lock_task_sighand
 			break;
 		spin_unlock_irqrestore(&sighand->siglock, *flags);
 	}
+	rcu_read_unlock();
 
 	return sighand;
 }

