Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbYLUAyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbYLUAyp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 19:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYLUAyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 19:54:37 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:37934 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbYLUAyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 19:54:36 -0500
Date: Sat, 20 Dec 2008 16:53:19 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       bastian@waldi.eu.org
Cc: daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, sukadev@us.ibm.com
Subject: [RFC][PATCH 2/6][v3] Protect init from unwanted signals more
Message-ID: <20081221005319.GB5025@us.ibm.com>
References: <20081221005106.GA4912@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081221005106.GA4912@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Fri, 19 Dec 2008 13:12:45 -0800
Subject: [RFC][PATCH 2/6][v3] Protect init from unwanted signals more

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

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 kernel/signal.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 7945e71..55f41b6 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -53,10 +53,21 @@ static int sig_handler_ignored(void __user *handler, int sig)
 		(handler == SIG_DFL && sig_kernel_ignore(sig));
 }
 
-static int sig_ignored(struct task_struct *t, int sig)
+static int sig_task_ignored(struct task_struct *t, int sig)
 {
 	void __user *handler;
 
+	handler = sig_handler(t, sig);
+
+	if (unlikely(t->signal->flags & SIGNAL_UNKILLABLE) &&
+			(handler == SIG_IGN || handler == SIG_DFL))
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
@@ -65,8 +76,7 @@ static int sig_ignored(struct task_struct *t, int sig)
 	if (sigismember(&t->blocked, sig) || sigismember(&t->real_blocked, sig))
 		return 0;
 
-	handler = sig_handler(t, sig);
-	if (!sig_handler_ignored(handler, sig))
+	if (!sig_task_ignored(t, sig))
 		return 0;
 
 	/*
-- 
1.5.2.5

