Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab0BKMET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 07:04:19 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:54446 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab0BKMEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 07:04:16 -0500
To: oleg@redhat.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       dipankar@in.ibm.com, mingo@elte.hu, peterz@infradead.org,
       viro@zeniv.linux.org.uk, jmorris@namei.org, dhowells@redhat.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-security-module@vger.kernel.org
Subject: [PATCH] sys: Fix missing rcu protection for sys_getpriority.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20091210001308.247025548@linutronix.de>
	<20091210004703.029784964@linutronix.de>
	<20091210142036.GA8226@redhat.com>
In-Reply-To: <20091210142036.GA8226@redhat.com>
Message-Id: <201002112104.BAG73411.LFHFSVQtOOMOJF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 11 Feb 2010 21:04:14 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> This also fixes another bug here. find_task_by_vpid() is not safe
> without rcu_read_lock(). I do not mean it is not safe to use the
> result, just find_pid_ns() by itself is not safe.
> 
> Usually tasklist gives enough protection, but if copy_process() fails
> it calls free_pid() lockless and does call_rcu(delayed_put_pid().
> This means, without rcu lock find_pid_ns() can't scan the hash table
> safely.

This bug for sys_setpriority() was fixed, but not fixed for sys_getpriority().
Why not to add it as well?
--------------------
[PATCH] sys: Fix missing rcu protection for sys_setpriority.

find_task_by_vpid() is not safe without rcu_read_lock().
2.6.33-rc7 got RCU protection for sys_setpriority() but missed it for
sys_getpriority().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 kernel/sys.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.33-rc7.orig/kernel/sys.c
+++ linux-2.6.33-rc7/kernel/sys.c
@@ -222,6 +222,7 @@ SYSCALL_DEFINE2(getpriority, int, which,
 	if (which > PRIO_USER || which < PRIO_PROCESS)
 		return -EINVAL;
 
+	rcu_read_lock();
 	read_lock(&tasklist_lock);
 	switch (which) {
 		case PRIO_PROCESS:
@@ -267,6 +268,7 @@ SYSCALL_DEFINE2(getpriority, int, which,
 	}
 out_unlock:
 	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	return retval;
 }
