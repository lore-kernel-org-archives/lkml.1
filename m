Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbZBSDHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbZBSDHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 22:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758453AbZBSDHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 22:07:36 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:58568 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbZBSDHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 22:07:34 -0500
Date: Wed, 18 Feb 2009 19:07:21 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, roland@redhat.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, daniel@hozac.com,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7][v8] Protect cinit from blocked fatal signals
Message-ID: <20090219030721.GF18990@us.ibm.com>
References: <20090219030207.GA18783@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090219030207.GA18783@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Wed, 24 Dec 2008 14:04:24 -0800
Subject: [PATCH 6/7][v8] Protect cinit from blocked fatal signals

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
index 2b45bc5..ddfa413 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -841,6 +841,8 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	atomic_set(&sig->live, 1);
 	init_waitqueue_head(&sig->wait_chldexit);
 	sig->flags = 0;
+	if (clone_flags & CLONE_NEWPID)
+		sig->flags |= SIGNAL_UNKILLABLE;
 	sig->group_exit_code = 0;
 	sig->group_exit_task = NULL;
 	sig->group_stop_count = 0;
diff --git a/kernel/signal.c b/kernel/signal.c
index a3a1304..c94355b 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1862,9 +1862,16 @@ relock:
 
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

