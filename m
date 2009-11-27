Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbZK0XLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbZK0XLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbZK0XLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:11:09 -0500
Received: from server1.wserver.cz ([82.113.45.157]:60466 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbZK0XGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:06:05 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH v3 10/27] core: do security check under task_lock
Date: Sat, 28 Nov 2009 00:05:50 +0100
Message-Id: <1259363167-9347-10-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do security_task_setrlimit under task_lock. Other tasks may
change limits under our hands while we are checking limits
inside the function. From now on, they can't.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: James Morris <jmorris@namei.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/sys.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 605ab9c..0f86199 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1243,7 +1243,7 @@ int setrlimit(struct task_struct *tsk, unsigned int resource,
 		struct rlimit *new_rlim)
 {
 	struct rlimit *old_rlim;
-	int retval;
+	int retval = 0;
 
 	if (new_rlim->rlim_cur > new_rlim->rlim_max)
 		return -EINVAL;
@@ -1260,10 +1260,6 @@ int setrlimit(struct task_struct *tsk, unsigned int resource,
 		}
 	}
 
-	retval = security_task_setrlimit(tsk, resource, new_rlim);
-	if (retval)
-		goto out;
-
 	if (resource == RLIMIT_CPU && new_rlim->rlim_cur == 0) {
 		/*
 		 * The caller is asking for an immediate RLIMIT_CPU
@@ -1276,11 +1272,13 @@ int setrlimit(struct task_struct *tsk, unsigned int resource,
 
 	old_rlim = tsk->signal->rlim + resource;
 	task_lock(tsk->group_leader);
-	if ((new_rlim->rlim_max <= old_rlim->rlim_max) ||
-				capable(CAP_SYS_RESOURCE))
-		*old_rlim = *new_rlim;
-	else
+	if ((new_rlim->rlim_max > old_rlim->rlim_max) &&
+				!capable(CAP_SYS_RESOURCE))
 		retval = -EPERM;
+	if (!retval)
+		retval = security_task_setrlimit(tsk, resource, new_rlim);
+	if (!retval)
+		*old_rlim = *new_rlim;
 	task_unlock(tsk->group_leader);
 
 	if (retval || resource != RLIMIT_CPU)
-- 
1.6.5.3

