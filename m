Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbZAGHzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbZAGHzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 02:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756934AbZAGHyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 02:54:45 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55516 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbZAGHyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 02:54:44 -0500
Date: Tue, 6 Jan 2009 23:52:14 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       bastian@waldi.eu.org
Cc: containers@lists.osdl.org, linux-kernel@vger.kernel.org, xemul@openvz.org
Subject: [PATCH 6/7][v6] Protect cinit from blocked fatal signals
Message-ID: <20090107075214.GF27985@us.ibm.com>
References: <20090107074558.GA27881@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107074558.GA27881@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Wed, 24 Dec 2008 14:04:24 -0800
Subject: [PATCH 6/7][v6] Protect cinit from blocked fatal signals

Normally SIG_DFL signals to global and container-init are dropped early.
But if a signal is blocked when it is posted, we cannot drop the signal
since the receiver may install a handler before unblocking the signal.
Once this signal is queued however, the receiver container-init has
no way of knowing if the signal was sent from an ancestor or descendant
namespace.  This patch ensures that contianer-init drops all SIG_DFL
signals in get_signal_to_deliver() except SIGKILL/SIGSTOP.

If SIGSTOP/SIGKILL originate from a descendant of container-init they
are never queued (i.e dropped in sig_ignored() in an earler patch).

If SIGSTOP/SIGKILL originate from parent namespace, the signal is queued
and container-init processes the signal.

IOW, if get_signal_to_deliver() sees a sig_kernel_only() signal for global
or container-init, the signal must have been generated internally or must
have come from an ancestor ns and we process the signal.

Further, the signal_group_exit() check was needed to cover the case of
a multi-threaded init sending SIGKILL to other threads when doing an
exit() or exec(). But since the new sig_kernel_only() check covers the
SIGKILL, the signal_group_exit() check is no longer needed and can be
removed.

Finally, now that we have all pieces in place, set SIGNAL_UNKILLABLE for
container-inits.

Changelog[v6]:
	- Add a note regarding the signal_group_exit() in patch description.

Changelog[v5]:
	- (Oleg Nesterov) Drop signal_unkillable(), simplify check in
	  get_signal_to_deliver() and drop check for signal_group_exit()
	  since it is covered by sig_kernel_only().

Changelog[v4]:
	- Rename sig_unkillable() to unkillable_by_sig()
	- Remove SIGNAL_UNKILLABLE_FROM_NS flag and simplify (Oleg Nesterov)
	- Set SIGNAL_UNKILLABLE for container-init in this patch.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 kernel/fork.c   |    2 ++
 kernel/signal.c |    9 ++++++++-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index dba2d3f..d3e93ef 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -812,6 +812,8 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	atomic_set(&sig->live, 1);
 	init_waitqueue_head(&sig->wait_chldexit);
 	sig->flags = 0;
+	if (clone_flags & CLONE_NEWPID)
+		sig->flags |= SIGNAL_UNKILLABLE;
 	sig->group_exit_code = 0;
 	sig->group_exit_task = NULL;
 	sig->group_stop_count = 0;
diff --git a/kernel/signal.c b/kernel/signal.c
index 3156dab..6ad47c0 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1890,9 +1890,16 @@ relock:
 
 		/*
 		 * Global init gets no signals it doesn't want.
+		 * Container-init gets no signals it doesn't want from same
+		 * container.
+		 *
+		 * Note that if global/container-init sees a sig_kernel_only()
+		 * signal here, the signal must have been generated internally
+		 * or must have come from an ancestor namespace. In either
+		 * case, the signal cannot be dropped.
 		 */
 		if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
-		    !signal_group_exit(signal))
+				!sig_kernel_only(signr))
 			continue;
 
 		if (sig_kernel_stop(signr)) {
-- 
1.5.2.5

