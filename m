Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbYLXLxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbYLXLxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 06:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYLXLw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 06:52:57 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44303 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbYLXLw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 06:52:56 -0500
Date: Wed, 24 Dec 2008 03:51:24 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       bastian@waldi.eu.org
Cc: daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 3/7][v4] Define siginfo_from_ancestor_ns()
Message-ID: <20081224115124.GC8020@us.ibm.com>
References: <20081224114414.GA7879@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081224114414.GA7879@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [RFC][PATCH 3/7][v4] Define siginfo_from_ancestor_ns()

Determine if sender of a signal is from an ancestor namespace. This
function will be used in a follow-on patch.

This is an early/lightly tested RFC patch. Would it be safe to implement
siginfo_from_user() as below and then use it dereference the pid
namespace of sender ?

This is based on discussions on the patch from Oleg Nesterov and me
http://lkml.org/lkml/2008/11/25/462.

Changelog[v2]:
	- siginfo_from_ancestor_ns() is fairly clean and it does not need
	  to be under CONFIG_PID_NS. Only siginfo_from_user() needs to be.
	- Warn if rt_sigqueueinfo() uses SI_ASYNCIO.
	- Added a check for pid-ns of receiver being NULL (in case it is
	  exiting).

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 kernel/signal.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 55f41b6..0011f99 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -820,6 +820,56 @@ static inline int legacy_queue(struct sigpending *signals, int sig)
 {
 	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
 }
+/*
+ * Return 1 if this signal originated directly from a user process (i.e via
+ * kill(), tkill(), sigqueue()).  Return 0 otherwise.
+ *
+ * TODO:
+ * 	  To make this less hacky, make SI_ASYNCIO a kernel signal (and
+ * 	  remove the warning in sys_rt_sigqueueinfo()).
+ */
+#ifdef CONFIG_PID_NS
+static inline int siginfo_from_user(siginfo_t *info)
+{
+	if (!is_si_special(info) && SI_FROMUSER(info) &&
+				info->si_code != SI_ASYNCIO)
+		return 1;
+
+	return 0;
+}
+#else
+static inline int siginfo_from_user(siginfo_t *info)
+{
+	return 0;
+}
+#endif
+
+static inline int siginfo_from_ancestor_ns(struct task_struct *t,
+                       siginfo_t *info)
+{
+	struct pid_namespace *ns;
+
+	/*
+	 * Ensure signal is from user-space before checking pid namespace
+	 */
+	if (siginfo_from_user(info)) {
+		/*
+		 * If we do not have a pid in the receiver's namespace,
+		 * we must be an ancestor of the receiver. 
+		 *
+		 * CHECK:
+		 * 	If receiver is exiting, ns == NULL, signal will be
+		 * 	queued but ignored (wants_signal() is FALSES). For
+		 * 	compatibility with current behavior, assume it is
+		 * 	from ancestor and queue the signal anyway ?
+		 */
+		ns = task_active_pid_ns(t);
+		if (!ns || task_pid_nr_ns(current, ns) <= 0)
+			return 1;
+	}
+
+	return 0;
+}
 
 static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			int group)
@@ -2312,6 +2362,20 @@ sys_tkill(pid_t pid, int sig)
 	return do_tkill(0, pid, sig);
 }
 
+#ifdef CONFIG_PID_NS
+/*
+ * siginfo_from_user() assumes that si_code SI_ASYNCIO comes only from
+ * within the kernel. If an application is passing in SI_ASYNCIO we 
+ * want to know about it.
+ */
+static void warn_on_asyncio(siginfo_t *info)
+{
+	WARN_ON_ONCE(info->si_code == SI_ASYNCIO);
+}
+#else
+#define warn_on_asyncio(info)	{}
+#endif
+
 asmlinkage long
 sys_rt_sigqueueinfo(pid_t pid, int sig, siginfo_t __user *uinfo)
 {
@@ -2324,6 +2388,9 @@ sys_rt_sigqueueinfo(pid_t pid, int sig, siginfo_t __user *uinfo)
 	   Nor can they impersonate a kill(), which adds source info.  */
 	if (info.si_code >= 0)
 		return -EPERM;
+
+	warn_on_asyncio(&info);
+
 	info.si_signo = sig;
 
 	/* POSIX.1b doesn't mention process groups.  */
-- 
1.5.2.5

