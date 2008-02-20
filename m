Return-Path: <linux-kernel-owner+w=401wt.eu-S933566AbYBTRNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933566AbYBTRNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934013AbYBTRN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:13:28 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:56120 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933459AbYBTRNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:13:25 -0500
Date: Wed, 20 Feb 2008 20:09:13 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@sw.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH] do_task_stat: don't take rcu_read_lock()
Message-ID: <20080220170913.GA465@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(depends on "[PATCH 1/2] lock_task_sighand: add rcu lock/unlock",
 http://marc.info/?l=linux-kernel&m=120335433821564)

lock_task_sighand() was changed, and do_task_stat() doesn't need rcu_read_lock
any longer. sighand->siglock protects all "interesting" fields.

Except: it doesn't protect ->tty->pgrp, but neither does rcu_read_lock(), this
should be fixed.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- MM/fs/proc/array.c~DTS	2008-02-17 23:40:07.000000000 +0300
+++ MM/fs/proc/array.c	2008-02-20 19:53:37.000000000 +0300
@@ -425,7 +425,6 @@ static int do_task_stat(struct seq_file 
 	cutime = cstime = utime = stime = cputime_zero;
 	cgtime = gtime = cputime_zero;
 
-	rcu_read_lock();
 	if (lock_task_sighand(task, &flags)) {
 		struct signal_struct *sig = task->signal;
 
@@ -469,7 +468,6 @@ static int do_task_stat(struct seq_file 
 
 		unlock_task_sighand(task, &flags);
 	}
-	rcu_read_unlock();
 
 	if (!whole || num_threads < 2)
 		wchan = get_wchan(task);

