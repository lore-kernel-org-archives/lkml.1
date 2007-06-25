Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbXFYWZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbXFYWZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 18:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbXFYWZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 18:25:04 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:63891 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbXFYWZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 18:25:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=HgmLPsWB6rb4hZV2x8gv5Dily4xmuY5s1u4lwS1/NIHUrE/L6MToxSLLtGo6Kad0hDdz2O97Obl4cRHoSPC1HPEKLvkVyG/JCPgX7tpjP+E0QYkGEMM9TCnElq7T1cE6vSsSTH1nqrWJHgh2LZcGPZ/bznHfLU1Se0ZBdiFwXkM=
Message-ID: <524f69650706251525g7b17ea02o5fb3e637615fe542@mail.gmail.com>
Date: Mon, 25 Jun 2007 17:25:00 -0500
From: "Steve French" <smfrench@gmail.com>
To: linux-fsdevel@vger.kernel.org, jlayton@redhat.com,
       linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org
Subject: Re: [PATCH] CIFS: make cifsd (more)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,
Not seeing any objections to your revised approach (to not allowing
signals for cifsd kernel thread), I just merged something similar to
your patch to the cifs-2.6.git tree (also fixed some nearby lines that
went past 80 columns).

Thanks



Signed-off-by: Jeff Layton <jlayton@redhat.com>

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f4e9266..27c1ebe 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -348,7 +348,6 @@ cifs_demultiplex_thread(struct TCP_Server_Info *server)
 	int isMultiRsp;
 	int reconnect;

-	allow_signal(SIGKILL);
 	current->flags |= PF_MEMALLOC;
 	server->tsk = current;	/* save process info to wake at shutdown */
 	cFYI(1, ("Demultiplex PID: %d", current->pid));
@@ -2074,7 +2073,7 @@ cifs_mount(struct super_block *sb, struct
cifs_sb_info *cifs_sb,
 				   always wake up processes blocked in
 				   tcp in recv_mesg then we could remove the
 				   send_sig call */
-				send_sig(SIGKILL,srvTcp->tsk,1);
+				force_sig(SIGKILL,srvTcp->tsk);
 				tsk = srvTcp->tsk;
 				if(tsk)
 					kthread_stop(tsk);
@@ -2093,7 +2092,7 @@ cifs_mount(struct super_block *sb, struct
cifs_sb_info *cifs_sb,
 					if ((temp_rc == -ESHUTDOWN) &&
 					   (pSesInfo->server) && (pSesInfo->server->tsk)) {
 						struct task_struct *tsk;
-						send_sig(SIGKILL,pSesInfo->server->tsk,1);
+						force_sig(SIGKILL,pSesInfo->server->tsk);
 						tsk = pSesInfo->server->tsk;
 						if (tsk)
 							kthread_stop(tsk);
@@ -3345,7 +3344,7 @@ cifs_umount(struct super_block *sb, struct
cifs_sb_info *cifs_sb)
 			} else if (rc == -ESHUTDOWN) {
 				cFYI(1,("Waking up socket by sending it signal"));
 				if (cifsd_task) {
-					send_sig(SIGKILL,cifsd_task,1);
+					force_sig(SIGKILL,cifsd_task);
 					kthread_stop(cifsd_task);
 				}
 				rc = 0;

-- 
Thanks,

Steve
