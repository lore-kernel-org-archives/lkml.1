Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbZICUJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbZICUJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 16:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756414AbZICUJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 16:09:31 -0400
Received: from server1.wserver.cz ([82.113.45.157]:51035 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324AbZICUIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 16:08:40 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: oleg@redhat.com
Cc: akpm@linux-foundation.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH v2 7/8] core: optimize setrlimit for current task
Date: Thu,  3 Sep 2009 22:08:43 +0200
Message-Id: <1252008524-5376-7-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090903174106.GC27161@redhat.com>
References: <20090903174106.GC27161@redhat.com>
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
index 791b5c5..feca9d6 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1247,11 +1247,14 @@ int setrlimit(struct task_struct *tsk, unsigned int resource,
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
@@ -1291,7 +1294,8 @@ int setrlimit(struct task_struct *tsk, unsigned int resource,
 
 	update_rlimit_cpu(tsk, new_rlim->rlim_cur);
 out:
-	read_unlock(&tasklist_lock);
+	if (tsk != current)
+		read_unlock(&tasklist_lock);
 	return retval;
 }
 
-- 
1.6.3.3

