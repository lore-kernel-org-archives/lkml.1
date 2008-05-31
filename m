Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbYEaQO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbYEaQO2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 12:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbYEaQN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 12:13:59 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:38340 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbYEaQN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 12:13:58 -0400
Date: Sat, 31 May 2008 20:15:27 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] __exit_signal: don't take rcu lock
Message-ID: <20080531161527.GA5560@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason for rcu_read_lock() in __exit_signal(). tsk->sighand can
only be changed if tsk does exec, obviously this is not possible.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/exit.c~0_ES_NO_RCU	2008-05-26 18:09:12.000000000 +0400
+++ 26-rc2/kernel/exit.c	2008-05-31 20:08:11.000000000 +0400
@@ -84,7 +84,6 @@ static void __exit_signal(struct task_st
 	BUG_ON(!sig);
 	BUG_ON(!atomic_read(&sig->count));
 
-	rcu_read_lock();
 	sighand = rcu_dereference(tsk->sighand);
 	spin_lock(&sighand->siglock);
 
@@ -135,7 +134,6 @@ static void __exit_signal(struct task_st
 	tsk->signal = NULL;
 	tsk->sighand = NULL;
 	spin_unlock(&sighand->siglock);
-	rcu_read_unlock();
 
 	__cleanup_sighand(sighand);
 	clear_tsk_thread_flag(tsk,TIF_SIGPENDING);

