Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbYBYQ36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbYBYQ36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 11:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755972AbYBYQ3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 11:29:15 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53892
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755767AbYBYQ3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 11:29:12 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [(RT RFC) PATCH v2 2/9] sysctl for runtime-control of lateral mutex
	stealing
To: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, pavel@ucw.cz,
       acme@redhat.com, gregkh@suse.de, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com, ghaskins@novell.com
Date: Mon, 25 Feb 2008 11:00:48 -0500
Message-ID: <20080225160048.11268.55059.stgit@novell1.haskins.net>
In-Reply-To: <20080225155959.11268.35541.stgit@novell1.haskins.net>
References: <20080225155959.11268.35541.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sven-Thorsten Dietrich <sdietrich@suse.de>

Add /proc/sys/kernel/lateral_steal, to allow switching on and off
equal-priority mutex stealing between threads.

Signed-off-by: Sven-Thorsten Dietrich <sdietrich@suse.de>
---

 kernel/rtmutex.c |    7 ++++++-
 kernel/sysctl.c  |   14 ++++++++++++++
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 6624c66..cd39c26 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -18,6 +18,10 @@
 
 #include "rtmutex_common.h"
 
+#ifdef CONFIG_RTLOCK_LATERAL_STEAL
+int rtmutex_lateral_steal __read_mostly = 1;
+#endif
+
 /*
  * lock->owner state tracking:
  *
@@ -321,7 +325,8 @@ static inline int lock_is_stealable(struct task_struct *pendowner, int unfair)
 	if (current->prio > pendowner->prio)
 		return 0;
 
-	if (!unfair && (current->prio == pendowner->prio))
+	if (unlikely(current->prio == pendowner->prio) &&
+	   !(unfair && rtmutex_lateral_steal))
 #endif
 		return 0;
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c913d48..c24c53d 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -175,6 +175,10 @@ extern struct ctl_table inotify_table[];
 int sysctl_legacy_va_layout;
 #endif
 
+#ifdef CONFIG_RTLOCK_LATERAL_STEAL
+extern int rtmutex_lateral_steal;
+#endif
+
 extern int prove_locking;
 extern int lock_stat;
 
@@ -836,6 +840,16 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_RTLOCK_LATERAL_STEAL
+	{
+		.ctl_name       = CTL_UNNUMBERED,
+		.procname       = "rtmutex_lateral_steal",
+		.data           = &rtmutex_lateral_steal,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = &proc_dointvec,
+       },
+#endif
 #ifdef CONFIG_PROC_FS
 	{
 		.ctl_name       = CTL_UNNUMBERED,

