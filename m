Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbZJQVWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbZJQVWj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 17:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbZJQVWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 17:22:38 -0400
Received: from server1.wserver.cz ([82.113.45.157]:60880 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbZJQVVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 17:21:23 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH -repost 6/8] core: allow setrlimit to non-current tasks
Date: Sat, 17 Oct 2009 23:21:20 +0200
Message-Id: <1255814482-13994-6-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1255814482-13994-1-git-send-email-jirislaby@gmail.com>
References: <1255814482-13994-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add locking to allow setrlimit accept task parameter other than
current.

Namely, lock tasklist_lock for read and check whether the task
structure has sighand non-null. Do all the signal processing under
that lock still held.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sys.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 2dc84b9..5bb80d6 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1238,6 +1238,7 @@ SYSCALL_DEFINE2(old_getrlimit, unsigned int, resource,
 
 #endif
 
+/* make sure you are allowed to change @tsk limits before calling this */
 int setrlimit(struct task_struct *tsk, unsigned int resource,
 		struct rlimit *new_rlim)
 {
@@ -1249,9 +1250,16 @@ int setrlimit(struct task_struct *tsk, unsigned int resource,
 	if (resource == RLIMIT_NOFILE && new_rlim->rlim_max > sysctl_nr_open)
 		return -EPERM;
 
+	/* protect tsk->signal and tsk->sighand from disappearing */
+	read_lock(&tasklist_lock);
+	if (!tsk->sighand) {
+		retval = -ESRCH;
+		goto out;
+	}
+
 	retval = security_task_setrlimit(tsk, resource, new_rlim);
 	if (retval)
-		return retval;
+		goto out;
 
 	if (resource == RLIMIT_CPU && new_rlim->rlim_cur == 0) {
 		/*
@@ -1286,6 +1294,7 @@ int setrlimit(struct task_struct *tsk, unsigned int resource,
 
 	update_rlimit_cpu(tsk, new_rlim->rlim_cur);
 out:
+	read_unlock(&tasklist_lock);
 	return retval;
 }
 
-- 
1.6.4.2

