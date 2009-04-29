Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbZD2Mmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbZD2Mmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbZD2Mma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:42:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56405 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbZD2Mm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:42:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090429115550.GA25368@redhat.com>
References: <20090429115550.GA25368@redhat.com> <20090429102511.GA10767@redhat.com> <20090429065809.GA477@redhat.com> <20090428223025.GA11997@redhat.com> <alpine.LRH.2.00.0904291024001.5246@tundra.namei.org> <7242.1240999370@redhat.com> <7150.1241003840@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, Roland McGrath <roland@redhat.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: Re: Q: selinux_bprm_committed_creds() && signals/do_wait
Date: Wed, 29 Apr 2009 13:42:13 +0100
Message-ID: <19024.1241008933@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> No need to check ->shared_pending + ->pending. We can't have SIGKILL
> (shared or not) without SIGNAL_GROUP_EXIT.

Okay, I didn't realise we did this now.

How about the attached patch then?

David
---
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] SELinux: Don't flush inherited SIGKILL during execve()

Don't flush inherited SIGKILL during execve() in SELinux's post cred commit
hook.  This isn't really a security problem: if the SIGKILL came before the
credentials were changed, then we were right to receive it at the time, and
should honour it; if it came after the creds were changed, then we definitely
should honour it; and in any case, all that will happen is that the process
will be scrapped before it ever returns to userspace.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/sched.h    |    1 +
 kernel/signal.c          |   11 ++++++++---
 security/selinux/hooks.c |   10 +++++-----
 3 files changed, 14 insertions(+), 8 deletions(-)


diff --git a/include/linux/sched.h b/include/linux/sched.h
index b4c38bc..3fa82b3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1885,6 +1885,7 @@ extern void sched_dead(struct task_struct *p);
 
 extern void proc_caches_init(void);
 extern void flush_signals(struct task_struct *);
+extern void __flush_signals(struct task_struct *);
 extern void ignore_signals(struct task_struct *);
 extern void flush_signal_handlers(struct task_struct *, int force_default);
 extern int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info);
diff --git a/kernel/signal.c b/kernel/signal.c
index d803473..d2dd9cf 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -249,14 +249,19 @@ void flush_sigqueue(struct sigpending *queue)
 /*
  * Flush all pending signals for a task.
  */
+void __flush_signals(struct task_struct *t)
+{
+	clear_tsk_thread_flag(t, TIF_SIGPENDING);
+	flush_sigqueue(&t->pending);
+	flush_sigqueue(&t->signal->shared_pending);
+}
+
 void flush_signals(struct task_struct *t)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&t->sighand->siglock, flags);
-	clear_tsk_thread_flag(t, TIF_SIGPENDING);
-	flush_sigqueue(&t->pending);
-	flush_sigqueue(&t->signal->shared_pending);
+	__flush_signals(t);
 	spin_unlock_irqrestore(&t->sighand->siglock, flags);
 }
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 02c2647..76670e2 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2378,7 +2378,6 @@ static void selinux_bprm_committed_creds(struct linux_binprm *bprm)
 	struct sighand_struct *psig;
 	u32 osid, sid;
 	int rc, i;
-	unsigned long flags;
 
 	osid = tsec->osid;
 	sid = tsec->sid;
@@ -2398,11 +2397,12 @@ static void selinux_bprm_committed_creds(struct linux_binprm *bprm)
 		memset(&itimer, 0, sizeof itimer);
 		for (i = 0; i < 3; i++)
 			do_setitimer(i, &itimer, NULL);
-		flush_signals(current);
 		spin_lock_irq(&current->sighand->siglock);
-		flush_signal_handlers(current, 1);
-		sigemptyset(&current->blocked);
-		recalc_sigpending();
+		if (!(current->signal->flags & SIGNAL_GROUP_EXIT)) {
+			__flush_signals(current);
+			flush_signal_handlers(current, 1);
+			sigemptyset(&current->blocked);
+		}
 		spin_unlock_irq(&current->sighand->siglock);
 	}
 

