Return-Path: <linux-kernel-owner+w=401wt.eu-S1761235AbXH2Nkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761235AbXH2Nkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 09:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758315AbXH2NkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 09:40:24 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:20890 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756913AbXH2NkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 09:40:21 -0400
Message-ID: <46D57658.2040704@openvz.org>
Date: Wed, 29 Aug 2007 17:36:24 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Switch nfs/callback.c to using struct pid, not pid_t
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pid namespaces make it dangerous to use pid and tgid values
when run in some namespace. The struct pid itself is going
to be the only way for working with task pids, so make the
nfs callback thread use it.

Since nfs_callback_info.pid is set to current's one and reset
on the thread exit, it is safe not to get the struct pid. 

Since this pid is used later under lock_kernel() w/o sleeping 
operations, checking for i to be not NULL and killing the 
thread with kill_pid() is safe.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
index a796be5..5b8e5fc 100644
--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -27,7 +27,7 @@
 struct nfs_callback_data {
 	unsigned int users;
 	struct svc_serv *serv;
-	pid_t pid;
+	struct pid *pid;
 	struct completion started;
 	struct completion stopped;
 };
@@ -64,7 +64,7 @@ static void nfs_callback_svc(struct svc_
 	__module_get(THIS_MODULE);
 	lock_kernel();
 
-	nfs_callback_info.pid = current->pid;
+	nfs_callback_info.pid = task_pid(current);
 	daemonize("nfsv4-svc");
 	/* Process request with signals blocked, but allow SIGKILL.  */
 	allow_signal(SIGKILL);
@@ -98,7 +98,7 @@ static void nfs_callback_svc(struct svc_
 	}
 
 	svc_exit_thread(rqstp);
-	nfs_callback_info.pid = 0;
+	nfs_callback_info.pid = NULL;
 	complete(&nfs_callback_info.stopped);
 	unlock_kernel();
 	module_put_and_exit(0);
@@ -114,7 +114,7 @@ int nfs_callback_up(void)
 
 	lock_kernel();
 	mutex_lock(&nfs_callback_mutex);
-	if (nfs_callback_info.users++ || nfs_callback_info.pid != 0)
+	if (nfs_callback_info.users++ || nfs_callback_info.pid != NULL)
 		goto out;
 	init_completion(&nfs_callback_info.started);
 	init_completion(&nfs_callback_info.stopped);
@@ -157,9 +157,9 @@ void nfs_callback_down(void)
 	mutex_lock(&nfs_callback_mutex);
 	nfs_callback_info.users--;
 	do {
-		if (nfs_callback_info.users != 0 || nfs_callback_info.pid == 0)
+		if (nfs_callback_info.users != 0 || nfs_callback_info.pid == NULL)
 			break;
-		if (kill_proc(nfs_callback_info.pid, SIGKILL, 1) < 0)
+		if (kill_pid(nfs_callback_info.pid, SIGKILL, 1) < 0)
 			break;
 	} while (wait_for_completion_timeout(&nfs_callback_info.stopped, 5*HZ) == 0);
 	mutex_unlock(&nfs_callback_mutex);
