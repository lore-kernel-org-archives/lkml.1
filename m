Return-Path: <linux-kernel-owner+w=401wt.eu-S1758796AbZIPKZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbZIPKZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758775AbZIPKZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:25:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:58448 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758759AbZIPKZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:25:16 -0400
Date: Wed, 16 Sep 2009 10:24:54 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add SD_PREFER_LOCAL
Message-ID: <tip-59abf02644c45f1591e1374ee7bb45dc757fcb88@git.kernel.org>
Git-Commit-ID: 59abf02644c45f1591e1374ee7bb45dc757fcb88
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:24:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  59abf02644c45f1591e1374ee7bb45dc757fcb88
Gitweb:     http://git.kernel.org/tip/59abf02644c45f1591e1374ee7bb45dc757fcb88
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 16 Sep 2009 08:28:30 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Sep 2009 08:42:40 +0200

sched: Add SD_PREFER_LOCAL

And turn it on for NUMA and MC domains. This improves
locality in balancing decisions by keeping up to
capacity amount of tasks local before looking for idle
CPUs. (and twice the capacity if SD_POWERSAVINGS_BALANCE
is set.)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h    |    2 +-
 include/linux/topology.h |    2 ++
 kernel/sched_fair.c      |    7 +++++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ee1f889..b4a39bb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -805,7 +805,7 @@ enum cpu_idle_type {
 #define SD_BALANCE_FORK		0x0008	/* Balance on fork, clone */
 #define SD_BALANCE_WAKE		0x0010  /* Balance on wakeup */
 #define SD_WAKE_AFFINE		0x0020	/* Wake task to waking CPU */
-
+#define SD_PREFER_LOCAL		0x0040  /* Prefer to keep tasks local to this domain */
 #define SD_SHARE_CPUPOWER	0x0080	/* Domain members share cpu power */
 #define SD_POWERSAVINGS_BALANCE	0x0100	/* Balance for power savings */
 #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 936ab2b..a6614b0 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -129,6 +129,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_FORK			\
 				| 1*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
+				| 1*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
@@ -161,6 +162,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_FORK			\
 				| 1*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
+				| 1*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 280892e..a37f311 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1360,7 +1360,7 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int flags)
 		 * If power savings logic is enabled for a domain, see if we
 		 * are not overloaded, if so, don't balance wider.
 		 */
-		if (tmp->flags & SD_POWERSAVINGS_BALANCE) {
+		if (tmp->flags & (SD_POWERSAVINGS_BALANCE|SD_PREFER_LOCAL)) {
 			unsigned long power = 0;
 			unsigned long nr_running = 0;
 			unsigned long capacity;
@@ -1373,7 +1373,10 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int flags)
 
 			capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
 
-			if (nr_running/2 < capacity)
+			if (tmp->flags & SD_POWERSAVINGS_BALANCE)
+				nr_running /= 2;
+
+			if (nr_running < capacity)
 				break;
 		}
 
