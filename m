Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbYL0UzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbYL0UzW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 15:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYL0UzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 15:55:07 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35541 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbYL0UzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 15:55:06 -0500
Date: Sat, 27 Dec 2008 12:53:19 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       bastian@waldi.eu.org
Cc: daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/6][v5] Protect cinit from unblocked SIG_DFL signals
Message-ID: <20081227205319.GC27337@us.ibm.com>
References: <20081227204658.GA27197@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227204658.GA27197@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Wed, 24 Dec 2008 14:03:57 -0800
Subject: [PATCH 4/6][v5] Protect cinit from unblocked SIG_DFL signals

Drop early any SIG_DFL or SIG_IGN signals to container-init from within
the same container. But queue SIGSTOP and SIGKILL to the container-init
if they are from an ancestor container.

Blocked, fatal signals (i.e when SIG_DFL is to terminate) from within the
container can still terminate the container-init. That will be addressed
in the next patch.

Note:	To be bisect-safe, SIGNAL_UNKILLABLE will be set for container-inits
   	in a follow-on patch. Until then, this patch is just a preparatory
	step.

Changelog[v4]:
	- (Oleg Nesterov) Remove SIGNAL_UNKILLABLE_FROM_NS and rename
	  'same_ns' to 'from_ancestor_ns'.
	- SIGNAL_UNKILLABLE is not yet set for container-inits (will be
	  set in follow-on patch).

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 kernel/signal.c |   36 +++++++++++++++++++++++++++---------
 1 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index f33100d..b51781e 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -53,20 +53,34 @@ static int sig_handler_ignored(void __user *handler, int sig)
 		(handler == SIG_DFL && sig_kernel_ignore(sig));
 }
 
-static int sig_task_ignored(struct task_struct *t, int sig)
+/*
+ * Return 1 if task @t is either the global init or the container-init
+ * of the sender's container. Return 0 otherwise.
+ */
+static int sig_task_unkillable(struct task_struct *t, int from_ancestor_ns)
+{
+	int flags = t->signal->flags;
+
+	if (unlikely(flags & SIGNAL_UNKILLABLE) && !from_ancestor_ns)
+		return 1;
+
+	return 0;
+}
+
+static int sig_task_ignored(struct task_struct *t, int sig, int from_ancestor_ns)
 {
 	void __user *handler;
 
 	handler = sig_handler(t, sig);
 
-	if (unlikely(t->signal->flags & SIGNAL_UNKILLABLE) &&
+	if (sig_task_unkillable(t, from_ancestor_ns) &&
 			handler == SIG_DFL)
 		return 1;
-	
+
 	return sig_handler_ignored(handler, sig);
 }
 
-static int sig_ignored(struct task_struct *t, int sig)
+static int sig_ignored(struct task_struct *t, int sig, int from_ancestor_ns)
 {
 	/*
 	 * Blocked signals are never ignored, since the
@@ -76,7 +90,7 @@ static int sig_ignored(struct task_struct *t, int sig)
 	if (sigismember(&t->blocked, sig) || sigismember(&t->real_blocked, sig))
 		return 0;
 
-	if (!sig_task_ignored(t, sig))
+	if (!sig_task_ignored(t, sig, from_ancestor_ns))
 		return 0;
 
 	/*
@@ -632,7 +646,7 @@ static int check_kill_permission(int sig, struct siginfo *info,
  * Returns true if the signal should be actually delivered, otherwise
  * it should be dropped.
  */
-static int prepare_signal(int sig, struct task_struct *p)
+static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 {
 	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
@@ -716,7 +730,7 @@ static int prepare_signal(int sig, struct task_struct *p)
 		}
 	}
 
-	return !sig_ignored(p, sig);
+	return !sig_ignored(p, sig, from_ancestor_ns);
 }
 
 /*
@@ -881,11 +895,15 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 {
 	struct sigpending *pending;
 	struct sigqueue *q;
+	int from_ancestor_ns;
 
 	trace_sched_signal_send(sig, t);
 
 	assert_spin_locked(&t->sighand->siglock);
-	if (!prepare_signal(sig, t))
+
+	from_ancestor_ns = siginfo_from_ancestor_ns(t, info);
+
+	if (!prepare_signal(sig, t, from_ancestor_ns))
 		return 0;
 
 	pending = group ? &t->signal->shared_pending : &t->pending;
@@ -1380,7 +1398,7 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
 		goto ret;
 
 	ret = 1; /* the signal is ignored */
-	if (!prepare_signal(sig, t))
+	if (!prepare_signal(sig, t, 1))
 		goto out;
 
 	ret = 0;
-- 
1.5.2.5

