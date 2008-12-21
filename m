Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbYLUA44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbYLUA44 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 19:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYLUA4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 19:56:47 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:32802 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbYLUA4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 19:56:46 -0500
Date: Sat, 20 Dec 2008 16:55:29 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       bastian@waldi.eu.org
Cc: daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, sukadev@us.ibm.com
Subject: [RFC][PATCH 6/6][v3] Protect cinit from blocked fatal signals
Message-ID: <20081221005529.GF5025@us.ibm.com>
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
Date: Sat, 20 Dec 2008 14:15:41 -0800
Subject: [RFC][PATCH 6/6][v3] Protect cinit from blocked fatal signals

Normally SIG_DFL signals to global and container-init are dropped early.
But if a signal is blocked when it is posted, we cannot drop the signal
since the receiver may install a handler before unblocking the signal.
Once this signal is queued however, the receiver container-init has
no way of knowing if the signal was sent from an ancestor or descendant
namespace.  This patch ensures that contianer-init drop all SIG_DFL
signals in get_signal_to_deliver() except SIGKILL/SIGSTOP.

If SIGSTOP/SIGKILL originate from a descendant of container-init they
are never queued (i.e dropped in sig_ignored() in an earler patch).

If SIGSTOP/SIGKILL originate from parent namespace, the signal is queued
and container-init processes the signal.

See comments in patch below for details.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 kernel/signal.c |   41 +++++++++++++++++++++++++++++++++++++++--
 1 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 2dfca62..4abacf4 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1816,6 +1816,42 @@ static int ptrace_signal(int signr, siginfo_t *info,
 	return signr;
 }
 
+/*
+ * Return 1 if the signal @sig should NOT kill the task that owns @signal.
+ * Return 0 otherwise.
+ *
+ * If @signal refers to the global-init, it is unkillable (return 1).
+ *
+ * If @signal refers to a task a that is neither a container-init nor the
+ * global init, the task is killable (return 0).
+ *
+ * If @signal refers to a container-init and @sig is either SIGKILL or
+ * SIGSTOP, the signal must be from an ancestor container. So the task
+ * (container-init) should be killable (return 0).
+ *
+ * If @signal refers to a container-init and @sig is neither SIGKILL nor
+ * SIGSTOP, it was queued because it was blocked when it was posed. The
+ * signal may have come from same container - hence it should not be
+ * killable (return 1).
+ *
+ * Note:
+ * 	This means that SIGKILL is the only sure way to terminate a
+ * 	container-init even from ancestor namespace.
+ */
+static int sig_unkillable(struct signal_struct *signal, int sig)
+{
+	if (signal->flags & SIGNAL_UNKILLABLE_FROM_NS)
+		return !sig_kernel_only(sig);
+
+	/*
+	 * We must have dropped SIGKILL/SIGSTOP in sig_ignored()
+	 * TODO: Remove BUG_ON().
+	 */
+	BUG_ON(signal->flags & SIGNAL_UNKILLABLE && sig_kernel_only(sig));
+
+	return (signal->flags & SIGNAL_UNKILLABLE);
+}
+
 int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
 			  struct pt_regs *regs, void *cookie)
 {
@@ -1907,9 +1943,10 @@ relock:
 
 		/*
 		 * Global init gets no signals it doesn't want.
+		 * Container-init gets no signals it doesn't want from same
+		 * container.
 		 */
-		if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
-		    !signal_group_exit(signal))
+		if (sig_unkillable(signal, signr) && !signal_group_exit(signal))
 			continue;
 
 		if (sig_kernel_stop(signr)) {
-- 
1.5.2.5

