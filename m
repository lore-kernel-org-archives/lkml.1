Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbZJQVVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbZJQVVe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 17:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbZJQVVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 17:21:32 -0400
Received: from server1.wserver.cz ([82.113.45.157]:60879 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbZJQVV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 17:21:27 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH -repost 7/8] core: optimize setrlimit for current task
Date: Sat, 17 Oct 2009 23:21:21 +0200
Message-Id: <1255814482-13994-7-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1255814482-13994-1-git-send-email-jirislaby@gmail.com>
References: <1255814482-13994-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't take tasklist lock for 'current'. It's not needed, since
current->sighand/signal can't disappear.

This improves serlimit called especially via sys_setrlimit.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sys.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 5bb80d6..6886f7d 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1250,11 +1250,14 @@ int setrlimit(struct task_struct *tsk, unsigned int resource,
 	if (resource == RLIMIT_NOFILE && new_rlim->rlim_max > sysctl_nr_open)
 		return -EPERM;
 
-	/* protect tsk->signal and tsk->sighand from disappearing */
-	read_lock(&tasklist_lock);
-	if (!tsk->sighand) {
-		retval = -ESRCH;
-		goto out;
+	/* optimization: 'current' doesn't need locking, e.g. setrlimit */
+	if (tsk != current) {
+		/* protect tsk->signal and tsk->sighand from disappearing */
+		read_lock(&tasklist_lock);
+		if (!tsk->sighand) {
+			retval = -ESRCH;
+			goto out;
+		}
 	}
 
 	retval = security_task_setrlimit(tsk, resource, new_rlim);
@@ -1294,7 +1297,8 @@ int setrlimit(struct task_struct *tsk, unsigned int resource,
 
 	update_rlimit_cpu(tsk, new_rlim->rlim_cur);
 out:
-	read_unlock(&tasklist_lock);
+	if (tsk != current)
+		read_unlock(&tasklist_lock);
 	return retval;
 }
 
-- 
1.6.4.2

