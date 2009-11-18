Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbZKROwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbZKROwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757549AbZKROv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:51:59 -0500
Received: from server1.wserver.cz ([82.113.45.157]:51175 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbZKROv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:51:58 -0500
From: Jiri Slaby <jslaby@novell.com>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org,
       Jiri Slaby <jslaby@novell.com>, James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 02/16] core: do security check under task_lock
Date: Wed, 18 Nov 2009 15:51:48 +0100
Message-Id: <1258555922-2064-2-git-send-email-jslaby@novell.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <4B040A03.2020508@gmail.com>
References: <4B040A03.2020508@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do security_task_setrlimit under task_lock. Other tasks may
change limits under our hands while we are checking limits
inside the function. From now on, they can't.

Signed-off-by: Jiri Slaby <jslaby@novell.com>
Cc: James Morris <jmorris@namei.org>
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
1.6.4.2

