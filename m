Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbZBSDGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbZBSDGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 22:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbZBSDGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 22:06:10 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55343 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbZBSDGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 22:06:08 -0500
Date: Wed, 18 Feb 2009 19:05:55 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, roland@redhat.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, daniel@hozac.com,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7][v8] Protect init from unwanted signals more
Message-ID: <20090219030555.GB18990@us.ibm.com>
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


From: Oleg Nesterov <oleg@redhat.com>
Date: Wed, 24 Dec 2008 13:35:23 -0800
Subject: [PATCH 2/7][v8] Protect init from unwanted signals more

(This is a modified version of the patch submitted by Oleg Nesterov
http://lkml.org/lkml/2008/11/18/249 and tries to address comments
that came up in that discussion)

init ignores the SIG_DFL signals but we queue them anyway, including
SIGKILL. This is mostly OK, the signal will be dropped silently when
dequeued, but the pending SIGKILL has 2 bad implications:

        - it implies fatal_signal_pending(), so we confuse things
          like wait_for_completion_killable/lock_page_killable.

        - for the sub-namespace inits, the pending SIGKILL can
          mask (legacy_queue) the subsequent SIGKILL from the
          parent namespace which must kill cinit reliably.
          (preparation, cinits don't have SIGNAL_UNKILLABLE yet)

The patch can't help when init is ptraced, but ptracing of init is
not "safe" anyway.

Changelog[v5]:
	- (Oleg Nesterov) Remove SIG_IGN check in sig_task_ignored()
	  and let sig_handler_ignored() check SIG_IGN.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Roland McGrath <roland@redhat.com>
---
 kernel/signal.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index ee8a8f1..8761e4c 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -55,10 +55,21 @@ static int sig_handler_ignored(void __user *handler, int sig)
 		(handler == SIG_DFL && sig_kernel_ignore(sig));
 }
 
-static int sig_ignored(struct task_struct *t, int sig)
+static int sig_task_ignored(struct task_struct *t, int sig)
 {
 	void __user *handler;
 
+	handler = sig_handler(t, sig);
+
+	if (unlikely(t->signal->flags & SIGNAL_UNKILLABLE) &&
+			handler == SIG_DFL)
+		return 1;
+
+	return sig_handler_ignored(handler, sig);
+}
+
+static int sig_ignored(struct task_struct *t, int sig)
+{
 	/*
 	 * Blocked signals are never ignored, since the
 	 * signal handler may change by the time it is
@@ -67,8 +78,7 @@ static int sig_ignored(struct task_struct *t, int sig)
 	if (sigismember(&t->blocked, sig) || sigismember(&t->real_blocked, sig))
 		return 0;
 
-	handler = sig_handler(t, sig);
-	if (!sig_handler_ignored(handler, sig))
+	if (!sig_task_ignored(t, sig))
 		return 0;
 
 	/*
-- 
1.5.2.5

