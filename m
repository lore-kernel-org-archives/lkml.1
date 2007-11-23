Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbXKWMh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbXKWMh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 07:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbXKWMht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 07:37:49 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:52408 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbXKWMhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 07:37:48 -0500
Date: Fri, 23 Nov 2007 13:37:39 +0100
From: Pierre Peiffer <pierre.peiffer@bull.net>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.24-rc3-mm1] IPC/semaphores: consolidate SEM_STAT and
 IPC_STAT commands
Message-Id: <20071123133739.330189e4.pierre.peiffer@bull.net>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 23/11/2007 13:45:01,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 23/11/2007 13:45:03,
	Serialize complete at 23/11/2007 13:45:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


These both commands (SEM_STAT and IPC_STAT) are rather doing the same things
(only the meaning of the id given as input and the return value differ).
However, for the semaphores, they are handled in two different places
(two different functions).

This patch consolidates this for clarification by handling these both
commands in the same place in semctl_nolock(). It also removes one
unused parameter for this function.

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
---

 ipc/sem.c |   38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

Index: b/ipc/sem.c
===================================================================
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -599,8 +599,8 @@ static unsigned long copy_semid_to_user(
 	}
 }
 
-static int semctl_nolock(struct ipc_namespace *ns, int semid, int semnum,
-		int cmd, int version, union semun arg)
+static int semctl_nolock(struct ipc_namespace *ns, int semid,
+			 int cmd, int version, union semun arg)
 {
 	int err = -EINVAL;
 	struct sem_array *sma;
@@ -639,14 +639,23 @@ static int semctl_nolock(struct ipc_name
 			return -EFAULT;
 		return (max_id < 0) ? 0: max_id;
 	}
+	case IPC_STAT:
 	case SEM_STAT:
 	{
 		struct semid64_ds tbuf;
 		int id;
 
-		sma = sem_lock(ns, semid);
-		if (IS_ERR(sma))
-			return PTR_ERR(sma);
+		if (cmd == SEM_STAT) {
+			sma = sem_lock(ns, semid);
+			if (IS_ERR(sma))
+				return PTR_ERR(sma);
+			id = sma->sem_perm.id;
+		} else {
+			sma = sem_lock_check(ns, semid);
+			if (IS_ERR(sma))
+				return PTR_ERR(sma);
+			id = 0;
+		}
 
 		err = -EACCES;
 		if (ipcperms (&sma->sem_perm, S_IRUGO))
@@ -656,8 +665,6 @@ static int semctl_nolock(struct ipc_name
 		if (err)
 			goto out_unlock;
 
-		id = sma->sem_perm.id;
-
 		memset(&tbuf, 0, sizeof(tbuf));
 
 		kernel_to_ipc64_perm(&sma->sem_perm, &tbuf.sem_perm);
@@ -792,19 +799,6 @@ static int semctl_main(struct ipc_namesp
 		err = 0;
 		goto out_unlock;
 	}
-	case IPC_STAT:
-	{
-		struct semid64_ds tbuf;
-		memset(&tbuf,0,sizeof(tbuf));
-		kernel_to_ipc64_perm(&sma->sem_perm, &tbuf.sem_perm);
-		tbuf.sem_otime  = sma->sem_otime;
-		tbuf.sem_ctime  = sma->sem_ctime;
-		tbuf.sem_nsems  = sma->sem_nsems;
-		sem_unlock(sma);
-		if (copy_semid_to_user (arg.buf, &tbuf, version))
-			return -EFAULT;
-		return 0;
-	}
 	/* GETVAL, GETPID, GETNCTN, GETZCNT, SETVAL: fall-through */
 	}
 	err = -EINVAL;
@@ -971,15 +965,15 @@ asmlinkage long sys_semctl (int semid, i
 	switch(cmd) {
 	case IPC_INFO:
 	case SEM_INFO:
+	case IPC_STAT:
 	case SEM_STAT:
-		err = semctl_nolock(ns,semid,semnum,cmd,version,arg);
+		err = semctl_nolock(ns, semid, cmd, version, arg);
 		return err;
 	case GETALL:
 	case GETVAL:
 	case GETPID:
 	case GETNCNT:
 	case GETZCNT:
-	case IPC_STAT:
 	case SETVAL:
 	case SETALL:
 		err = semctl_main(ns,semid,semnum,cmd,version,arg);

-- 
Pierre Peiffer
