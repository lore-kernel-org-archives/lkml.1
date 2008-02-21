Return-Path: <linux-kernel-owner+w=401wt.eu-S934157AbYBUQBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934157AbYBUQBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758315AbYBUPzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 10:55:14 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:41415
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932586AbYBUPzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:55:10 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH [RT] 14/14] sysctl for runtime-control of lateral mutex
	stealing
To: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, gregkh@suse.de,
       sdietrich@novell.com, pmorreale@novell.com, mkohari@novell.com,
       ghaskins@novell.com
Date: Thu, 21 Feb 2008 10:27:37 -0500
Message-ID: <20080221152737.4804.70300.stgit@novell1.haskins.net>
In-Reply-To: <20080221152504.4804.8724.stgit@novell1.haskins.net>
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sven-Thorsten Dietrich <sdietrich@novell.com>

Add /proc/sys/kernel/lateral_steal, to allow switching on and off
equal-priority mutex stealing between threads.

Signed-off-by: Sven-Thorsten Dietrich <sdietrich@suse.de>
---

 kernel/rtmutex.c |    8 ++++++--
 kernel/sysctl.c  |   14 ++++++++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index da077e5..62e7af5 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -27,6 +27,9 @@ int rtlock_timeout __read_mostly = CONFIG_RTLOCK_DELAY;
 #ifdef CONFIG_ADAPTIVE_RTMUTEX
 int rtmutex_timeout __read_mostly = CONFIG_RTMUTEX_DELAY;
 #endif
+#ifdef CONFIG_RTLOCK_LATERAL_STEAL
+int rtmutex_lateral_steal __read_mostly = 1;
+#endif
 
 /*
  * lock->owner state tracking:
@@ -331,7 +334,8 @@ static inline int lock_is_stealable(struct task_struct *pendowner, int unfair)
 	if (current->prio > pendowner->prio)
 		return 0;
 
-	if (!unfair && (current->prio == pendowner->prio))
+	if (unlikely(current->prio == pendowner->prio) &&
+	   !(unfair && rtmutex_lateral_steal))
 #endif
 		return 0;
 
@@ -355,7 +359,7 @@ static inline int try_to_steal_lock(struct rt_mutex *lock, int unfair)
 		return 1;
 
 	spin_lock(&pendowner->pi_lock);
-	if (!lock_is_stealable(pendowner, unfair)) {
+	if (!lock_is_stealable(pendowner, (unfair & rtmutex_lateral_steal))) {
 		spin_unlock(&pendowner->pi_lock);
 		return 0;
 	}
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 3465af2..c1a1c6d 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -179,6 +179,10 @@ extern struct ctl_table inotify_table[];
 int sysctl_legacy_va_layout;
 #endif
 
+#ifdef CONFIG_RTLOCK_LATERAL_STEAL
+extern int rtmutex_lateral_steal;
+#endif
+
 extern int prove_locking;
 extern int lock_stat;
 
@@ -986,6 +990,16 @@ static struct ctl_table kern_table[] = {
 		.proc_handler   = &proc_dointvec,
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

