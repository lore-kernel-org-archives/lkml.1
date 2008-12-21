Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbYLUAzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbYLUAzy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 19:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbYLUAzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 19:55:42 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:40337 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbYLUAzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 19:55:41 -0500
Date: Sat, 20 Dec 2008 16:54:24 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       bastian@waldi.eu.org
Cc: daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, sukadev@us.ibm.com
Subject: [RFC][PATCH 4/6][v3] Define siginfo_from_ancestor_ns()
Message-ID: <20081221005424.GD5025@us.ibm.com>
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
Date: Sat, 20 Dec 2008 12:19:29 -0800
Subject: [RFC][PATCH 4/6][v3] Define siginfo_from_ancestor_ns()

Determine if sender of a signal is from an ancestor namespace. This
function will be used in a follow-on patch.

This is an early/lightly tested RFC patch. Would it be safe to implement
siginfo_from_user() as below and then use it dereference the pid
namespace of sender ?

This is based on discussions on the patch from Oleg Nesterov and me
http://lkml.org/lkml/2008/11/25/462.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 kernel/signal.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 55f41b6..058b4c0 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -820,6 +820,47 @@ static inline int legacy_queue(struct sigpending *signals, int sig)
 {
 	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
 }
+/*
+ * Return 1 if this signal originated directly from a user process (i.e via
+ * kill(), tkill(), sigqueue()).  Return 0 otherwise.
+ *
+ * TODO:
+ * 	  Making SI_ASYNCIO a kernel signal could make this less hacky.
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
+
+static inline int siginfo_from_ancestor_ns(struct task_struct *t,
+                       siginfo_t *info)
+{
+	/*
+	 * Ensure signal is from user-space before checking pid namespace
+	 */
+	if (siginfo_from_user(info)) {
+		/*
+		 * If we do not have a pid in the receiver's namespace,
+		 * we must be an ancestor of the receiver.
+		 */
+		if (task_pid_nr_ns(current, task_active_pid_ns(t)) <= 0)
+			return 1;
+	}
+
+	return 0;
+}
+#else
+static inline int siginfo_from_ancestor_ns(struct task_struct *t, siginfo_t *info)
+{
+       return 0;
+}
+#endif
+
 
 static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			int group)
-- 
1.5.2.5

