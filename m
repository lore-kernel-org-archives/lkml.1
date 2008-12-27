Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbYL0U4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbYL0U4T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 15:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755147AbYL0Uz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 15:55:56 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:55458 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbYL0Uzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 15:55:55 -0500
Date: Sat, 27 Dec 2008 12:54:09 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       bastian@waldi.eu.org
Cc: daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/6][v5] Protect cinit from blocked fatal signals
Message-ID: <20081227205409.GD27337@us.ibm.com>
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
Date: Wed, 24 Dec 2008 14:04:24 -0800
Subject: [PATCH 5/6][v5] Protect cinit from blocked fatal signals

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

And now that we have all pieces in place, set SIGNAL_UNKILLABLE for
container-inits.

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
 kernel/signal.c |    6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

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
index b51781e..d90b033 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1914,9 +1914,11 @@ relock:
 
 		/*
 		 * Global init gets no signals it doesn't want.
+		 * Container-init gets no signals it doesn't want from same
+		 * container.
 		 */
-		if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
-		    !signal_group_exit(signal))
+		if ((signal->flags & SIGNAL_UNKILLABLE) &&
+				!sig_kernel_only(signr))
 			continue;
 
 		if (sig_kernel_stop(signr)) {
-- 
1.5.2.5

