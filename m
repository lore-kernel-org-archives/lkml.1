Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbZAGHyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbZAGHyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 02:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbZAGHxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 02:53:54 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:33174 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbZAGHxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 02:53:53 -0500
Date: Tue, 6 Jan 2009 23:51:23 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       bastian@waldi.eu.org
Cc: containers@lists.osdl.org, linux-kernel@vger.kernel.org, xemul@openvz.org
Subject: [PATCH 4/7][v6] Define siginfo_from_ancestor_ns()
Message-ID: <20090107075123.GD27985@us.ibm.com>
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
Date: Wed, 24 Dec 2008 13:46:02 -0800
Subject: [PATCH 4/7][v6] Define siginfo_from_ancestor_ns()

Determine if sender of a signal is from an ancestor namespace. This
function will be used in a follow-on patch.

This is based on discussions on the patch from Oleg Nesterov and me
http://lkml.org/lkml/2008/11/25/462.

Changelog[v6]:
	- (Oleg Nesterov) Simplify/correct comments
	- (Oleg Nesterov) Remove 'ns == NULL' check since task_active_pid_ns()
	   will return a valid ns for the target.
	- (Roland Mcgrath) Remove incorrect SI_ASYNCIO check in
	   siginfo_from_user().
Changelog[v5]:
	- (Oleg Nesterov) Put siginfo_from_ancestor_ns() back under
	  CONFIG_PID_NS.
	- (Oleg Nesterov) Remove the warning in rt_sigqueueinfo().

Changelog[v4]:
	- siginfo_from_ancestor_ns() is fairly clean and it does not need
	  to be under CONFIG_PID_NS. Only siginfo_from_user() needs to be.
	- Warn if rt_sigqueueinfo() uses SI_ASYNCIO.
	- Added a check for pid-ns of receiver being NULL (in case it is
	  exiting).

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 kernel/signal.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index bb3b6f5..d0dfa0d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -820,6 +820,43 @@ static inline int legacy_queue(struct sigpending *signals, int sig)
 {
 	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
 }
+/*
+ * Return 1 if this signal originated directly from a user process (i.e via
+ * kill(), tkill(), sigqueue()).  Return 0 otherwise.
+ */
+#ifdef CONFIG_PID_NS
+static inline int siginfo_from_user(siginfo_t *info)
+{
+	if (!is_si_special(info) && SI_FROMUSER(info))
+		return 1;
+
+	return 0;
+}
+
+static inline int siginfo_from_ancestor_ns(struct task_struct *t,
+			siginfo_t *info)
+{
+	/*
+	 * If we do not have a pid in the receiver's namespace,
+	 * we must be from an ancestor namespace.
+	 */
+	if (siginfo_from_user(info) &&
+			task_pid_nr_ns(current, task_active_pid_ns(t)) <= 0) {
+		return 1;
+	}
+
+	return 0;
+}
+
+#else
+
+static inline int siginfo_from_ancestor_ns(struct task_struct *t,
+			siginfo_t *info)
+{
+	return 0;
+}
+
+#endif
 
 static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			int group, int from_ancestor_ns)
-- 
1.5.2.5

