Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbZK0XGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbZK0XGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbZK0XGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:06:11 -0500
Received: from server1.wserver.cz ([82.113.45.157]:60453 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbZK0XGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:06:04 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com
Subject: [PATCH v3 07/27] core: optimize setrlimit for current task
Date: Sat, 28 Nov 2009 00:05:47 +0100
Message-Id: <1259363167-9347-7-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Don't take tasklist lock for 'current'. It's not needed, since
current->sighand/signal can't disappear.

This improves serlimit called especially via sys_setrlimit.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sys.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 3082eaf..605ab9c 100644
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
1.6.5.3

