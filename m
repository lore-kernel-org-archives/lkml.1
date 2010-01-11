Return-Path: <linux-kernel-owner+w=401wt.eu-S1751895Ab0AKGk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab0AKGk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 01:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834Ab0AKGk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 01:40:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab0AKGk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 01:40:58 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <dfeng@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Schmidt <mschmidt@redhat.com>,
       David Howells <dhowells@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Frans Pop <elendil@planet.nl>
Subject: [RFC PATCH] accouting: account if a task was killed by OOM killer
Date: Mon, 11 Jan 2010 14:40:34 +0800
Message-Id: <1263192034-10898-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new accounting flag which is set when a task
was killed by OOM killer. taskstats can tell users when a job has been
killed by the oomkiller.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Schmidt <mschmidt@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Frans Pop <elendil@planet.nl>
---
 Documentation/accounting/taskstats-struct.txt |    2 +-
 include/linux/acct.h                          |    1 +
 include/linux/taskstats.h                     |    2 +-
 kernel/acct.c                                 |    2 ++
 kernel/tsacct.c                               |    2 ++
 5 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/accounting/taskstats-struct.txt b/Documentation/accounting/taskstats-struct.txt
index e7512c0..c3cf3cf 100644
--- a/Documentation/accounting/taskstats-struct.txt
+++ b/Documentation/accounting/taskstats-struct.txt
@@ -45,7 +45,7 @@ struct taskstats {
 	__u32	ac_exitcode;		/* Exit status */
 
   	/* The accounting flags of a task as defined in <linux/acct.h>
-	 * Defined values are AFORK, ASU, ACOMPAT, ACORE, and AXSIG.
+	 * Defined values are AFORK, ASU, ACOMPAT, ACORE, AXSIG, and AXOOM.
 	 */
 	__u8	ac_flag;		/* Record flags */
 
diff --git a/include/linux/acct.h b/include/linux/acct.h
index 882dc72..bbb5d7c 100644
--- a/include/linux/acct.h
+++ b/include/linux/acct.h
@@ -106,6 +106,7 @@ struct acct_v3
 #define ACOMPAT		0x04	/* ... used compatibility mode (VAX only not used) */
 #define ACORE		0x08	/* ... dumped core */
 #define AXSIG		0x10	/* ... was killed by a signal */
+#define AXOOM		0x20	/* ... was killed by OOM killer */
 
 #ifdef __BIG_ENDIAN
 #define ACCT_BYTEORDER	0x80	/* accounting file is big endian */
diff --git a/include/linux/taskstats.h b/include/linux/taskstats.h
index 341dddb..9d57f68 100644
--- a/include/linux/taskstats.h
+++ b/include/linux/taskstats.h
@@ -47,7 +47,7 @@ struct taskstats {
 	__u32	ac_exitcode;		/* Exit status */
 
 	/* The accounting flags of a task as defined in <linux/acct.h>
-	 * Defined values are AFORK, ASU, ACOMPAT, ACORE, and AXSIG.
+	 * Defined values are AFORK, ASU, ACOMPAT, ACORE, AXSIG, and AXOOM.
 	 */
 	__u8	ac_flag;		/* Record flags */
 	__u8	ac_nice;		/* task_nice */
diff --git a/kernel/acct.c b/kernel/acct.c
index a6605ca..5830423 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -632,6 +632,8 @@ void acct_collect(long exitcode, int group_dead)
 		pacct->ac_flag |= ACORE;
 	if (current->flags & PF_SIGNALED)
 		pacct->ac_flag |= AXSIG;
+	if (test_tsk_thread_flag(current, TIF_MEMDIE))
+		pacct->ac_flag |= AXOOM;
 	pacct->ac_utime = cputime_add(pacct->ac_utime, current->utime);
 	pacct->ac_stime = cputime_add(pacct->ac_stime, current->stime);
 	pacct->ac_minflt += current->min_flt;
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 00d59d0..46a816a 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -52,6 +52,8 @@ void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
 		stats->ac_flag |= ACORE;
 	if (tsk->flags & PF_SIGNALED)
 		stats->ac_flag |= AXSIG;
+	if (test_tsk_thread_flag(current, TIF_MEMDIE))
+		stats->ac_flag |= AXOOM;
 	stats->ac_nice	 = task_nice(tsk);
 	stats->ac_sched	 = tsk->policy;
 	stats->ac_pid	 = tsk->pid;
-- 
1.6.5.2

