Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbZLIOUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbZLIOUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 09:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755558AbZLIOUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 09:20:11 -0500
Received: from www.tglx.de ([62.245.132.106]:34394 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567AbZLIOUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 09:20:09 -0500
Message-Id: <20091209141634.769056460@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 09 Dec 2009 14:19:41 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Oleg Nesterov <oleg@redhat.com>
Subject: [patch 3/3] audit: Use rcu for task lookup protection
References: <20091209141540.067855785@linutronix.de>
Content-Disposition: inline; filename=audit-use-rcu-for-lookup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect the task lookups in audit_receive_msg() with rcu_read_lock()
instead of tasklist_lock and use lock/unlock_sighand to protect
against the exit race.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/audit.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

Index: linux-2.6-tip/kernel/audit.c
===================================================================
--- linux-2.6-tip.orig/kernel/audit.c
+++ linux-2.6-tip/kernel/audit.c
@@ -873,17 +873,16 @@ static int audit_receive_msg(struct sk_b
 	case AUDIT_TTY_GET: {
 		struct audit_tty_status s;
 		struct task_struct *tsk;
+		unsigned long flags;
 
-		read_lock(&tasklist_lock);
+		rcu_read_lock();
 		tsk = find_task_by_vpid(pid);
-		if (!tsk)
-			err = -ESRCH;
-		else {
-			spin_lock_irq(&tsk->sighand->siglock);
+		if (tsk && lock_task_sighand(tsk, &flags)) {
 			s.enabled = tsk->signal->audit_tty != 0;
-			spin_unlock_irq(&tsk->sighand->siglock);
-		}
-		read_unlock(&tasklist_lock);
+			unlock_task_sighand(tsk, &flags);
+		} else
+			err = -ESRCH;
+		rcu_read_unlock();
 
 		if (!err)
 			audit_send_reply(NETLINK_CB(skb).pid, seq,
@@ -893,22 +892,21 @@ static int audit_receive_msg(struct sk_b
 	case AUDIT_TTY_SET: {
 		struct audit_tty_status *s;
 		struct task_struct *tsk;
+		unsigned long flags;
 
 		if (nlh->nlmsg_len < sizeof(struct audit_tty_status))
 			return -EINVAL;
 		s = data;
 		if (s->enabled != 0 && s->enabled != 1)
 			return -EINVAL;
-		read_lock(&tasklist_lock);
+		rcu_read_lock();
 		tsk = find_task_by_vpid(pid);
-		if (!tsk)
-			err = -ESRCH;
-		else {
-			spin_lock_irq(&tsk->sighand->siglock);
+		if (tsk && lock_task_sighand(tsk, &flags)) {
 			tsk->signal->audit_tty = s->enabled != 0;
-			spin_unlock_irq(&tsk->sighand->siglock);
-		}
-		read_unlock(&tasklist_lock);
+			unlock_task_sighand(tsk, &flags);
+		} else
+			err = -ESRCH;
+		rcu_read_unlock();
 		break;
 	}
 	default:


