Return-Path: <linux-kernel-owner+w=401wt.eu-S932825AbZAQUjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbZAQUjY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 15:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763908AbZAQUjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 15:39:09 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:48575 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758212AbZAQUjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 15:39:08 -0500
Date: Sat, 17 Jan 2009 12:35:52 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       bastian@waldi.eu.org
Cc: daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/7][v7] Add from_ancestor_ns parameter to send_signal()
Message-ID: <20090117203552.GD11825@us.ibm.com>
References: <20090117202638.GA11825@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117202638.GA11825@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Tue, 6 Jan 2009 17:28:05 -0800
Subject: [PATCH 3/7][v7] Add from_ancestor_ns parameter to send_signal()

send_signal() (or its helper) needs to determine the pid namespace
of the sender. But a signal sent via kill_pid_info_as_uid() comes
from within the kernel and send_signal() does not need to determine
the pid namespace of the sender. So define a helper for send_signal()
which takes an additional parameter, 'from_ancestor_ns' and have
kill_pid_info_as_uid() use that helper directly.

The 'from_ancestor_ns' parameter will be used in a follow-on patch.

Changelog[v6]:
	- New patch added to this patchset, based on suggestions from
	  Roland McGrath and Oleg Nesterov.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 kernel/signal.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 87f3f30..bb3b6f5 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -821,8 +821,8 @@ static inline int legacy_queue(struct sigpending *signals, int sig)
 	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
 }
 
-static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
-			int group)
+static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
+			int group, int from_ancestor_ns)
 {
 	struct sigpending *pending;
 	struct sigqueue *q;
@@ -896,6 +896,12 @@ out_set:
 	return 0;
 }
 
+static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
+			int group)
+{
+	return __send_signal(sig, info, t, group, 0);
+}
+
 int print_fatal_signals;
 
 static void print_fatal_signal(struct pt_regs *regs, int signr)
@@ -1138,7 +1144,7 @@ int kill_pid_info_as_uid(int sig, struct siginfo *info, struct pid *pid,
 	if (sig && p->sighand) {
 		unsigned long flags;
 		spin_lock_irqsave(&p->sighand->siglock, flags);
-		ret = __group_send_sig_info(sig, info, p);
+		ret = __send_signal(sig, info, p, 1, 0);
 		spin_unlock_irqrestore(&p->sighand->siglock, flags);
 	}
 out_unlock:
-- 
1.5.2.5

