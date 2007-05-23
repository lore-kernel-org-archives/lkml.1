Return-Path: <linux-kernel-owner+w=401wt.eu-S934268AbXEWO7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268AbXEWO7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 10:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759042AbXEWO7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 10:59:09 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:50868 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbXEWO7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 10:59:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Zx3tFmEp1mOyExff5pNNDGllYu5W00kSdZsdQuNK3iolOj2bg5NTvLiBanjkLJtueq3MGZwAoKAH5in/fzuOHf2LINBKrmZwVjARpHREqni/6UkAOxsuvMZUm78XZMpqtLQL2Yx2e/7b/iK9WFGWmxSf7HSyxDxSfTcCQeOIpLI=
Message-ID: <524f69650705230759h709887d7y740f532ae4f53fc@mail.gmail.com>
Date: Wed, 23 May 2007 09:59:04 -0500
From: "Steve French" <smfrench@gmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       shaggy@austin.ibm.com, hi_dave.darkstar@gmail.com
Subject: Re: 2.6.22-rc1-mm1 cifs_mount oops
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is what I now have in the cifs git tree.  (only minor change is
that I now have since fixed the missing space after the if)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 216fb62..f6963d1 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2069,8 +2069,15 @@ cifs_mount(struct super_block *sb, struct
cifs_sb_info *cifs_sb,
                        srvTcp->tcpStatus = CifsExiting;
                        spin_unlock(&GlobalMid_Lock);
                        if (srvTcp->tsk) {
+                               struct task_struct *tsk;
+                               /* If we could verify that kthread_stop would
+                                  always wake up processes blocked in
+                                  tcp in recv_mesg then we could remove the
+                                  send_sig call */
                                send_sig(SIGKILL,srvTcp->tsk,1);
-                               kthread_stop(srvTcp->tsk);
+                               tsk = srvTcp->tsk;
+                               if(tsk)
+                                       kthread_stop(srvTcp->tsk);
                        }
                }
                 /* If find_unc succeeded then rc == 0 so we can not end */
@@ -2085,8 +2092,11 @@ cifs_mount(struct super_block *sb, struct
cifs_sb_info *cifs_sb,
                                        /* if the socketUseCount is now zero */
                                        if ((temp_rc == -ESHUTDOWN) &&
                                           (pSesInfo->server) &&
(pSesInfo->server->tsk)) {
+                                               struct task_struct *tsk;

send_sig(SIGKILL,pSesInfo->server->tsk,1);
-
kthread_stop(pSesInfo->server->tsk);
+                                               tsk = pSesInfo->server->tsk;
+                                               if(tsk)
+                                                       kthread_stop(tsk);
                                        }
                                } else
                                        cFYI(1, ("No session or bad tcon"));


-- 
Thanks,

Steve
