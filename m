Return-Path: <linux-kernel-owner+w=401wt.eu-S1759933AbXEXCiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759933AbXEXCiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 22:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757867AbXEXCir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 22:38:47 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:41515 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844AbXEXCiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 22:38:46 -0400
In-Reply-To: <a8e1da0705231805j47fb7438k1a2f5926b20835f9@mail.gmail.com>
To: "young dave" <hidave.darkstar@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       David Kleikamp <shaggy@us.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Shirish S Pargaonkar <shirishp@us.ibm.com>
Subject: Re: 2.6.22-rc1-mm1 cifs_mount oops
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0 HF144 February 01, 2006
Message-ID: <OFCF0CB811.0BB7E4C2-ON872572E5.000DBBDA-862572E5.000E8FD1@us.ibm.com>
From: Steven French <sfrench@us.ibm.com>
Date: Wed, 23 May 2007 21:38:35 -0500
X-MIMETrack: Serialize by Router on D03NM123/03/M/IBM(Release 7.0.2HF32 | October 17, 2006) at
 05/23/2007 20:38:37,
	Serialize complete at 05/23/2007 20:38:37
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If srvTcp->tsk is NULL then the thread (cifs_demultiplex_thread) is 
getting ready to exit and kthread_stop would not be needed.

It would probably be possible to recode this so we don't need to call 
kthread_stop at all (send_sig is apparently required to wake up this 
thread when blocked in certain places in the tcp stack - and in 
combination with the existing flags might be good enough) - but I don't 
know if it would make it simpler.    Fortunately there is no race, a few 
lines after srvTcp->tsk is set to zero by the cifs_demultipex_thread, it 
will sleep briefly before exiting (kthread_stop won't be called on a 
thread that does not exist).

That section of code in fs/cifs/connect.c now looks like:

2071                         if (srvTcp->tsk) {
2072                                 struct task_struct *tsk;
2073 
                                /* If we could verify that kthread_stop would
2074 
                                   always wake up processes blocked in
2075 
                                   tcp in recv_mesg then we could remove the
2076                                    send_sig call */
2077                                 send_sig(SIGKILL,srvTcp->tsk,1);
2078                                 tsk = srvTcp->tsk;
2079                                 if(tsk)
2080                                         kthread_stop(srvTcp->tsk);
2081                         }
2082                 }
2083 
                 /* If find_unc succeeded then rc == 0 so we can not end */
2084 
                if (tcon)  /* up accidently freeing someone elses tcon struct */
2085                         tconInfoFree(tcon);
2086                 if (existingCifsSes == NULL) {
2087                         if (pSesInfo) {
2088                                 if ((pSesInfo->server) && 
2089                                     (pSesInfo->status == CifsGood)) {
2090                                         int temp_rc;
2091 
                                        temp_rc = CIFSSMBLogoff(xid, pSesInfo);
2092 
                                        /* if the socketUseCount is now zero */
2093 
                                        if ((temp_rc == -ESHUTDOWN) &&
2094 
                                           (pSesInfo->server) && (pSesInfo->server->tsk)) {
2095 
                                                struct task_struct *tsk;
2096 
                                                send_sig(SIGKILL,pSesInfo->server->tsk,1);
2097 
                                                tsk = pSesInfo->server->tsk;
2098                                                 if(tsk)
2099 
                                                        kthread_stop(tsk);


Steve French
Senior Software Engineer
Linux Technology Center - IBM Austin
phone: 512-838-2294
email: sfrench at-sign us dot ibm dot com



"young dave" <hidave.darkstar@gmail.com> 
05/23/2007 08:05 PM

To
Steven French/Austin/IBM@IBMUS
cc
"Andrew Morton" <akpm@linux-foundation.org>, David 
Kleikamp/Austin/IBM@IBMUS, "Linux Kernel Mailing List" 
<linux-kernel@vger.kernel.org>, Shirish S Pargaonkar/Austin/IBM@IBMUS
Subject
Re: 2.6.22-rc1-mm1 cifs_mount oops






Hi,

I have one problem about this:  after the srvTcp->tsk is set to NULL
(maybe the thread is  still there, isn't it?), is the kthread still
needed to be stopped by calling kthread_stop()? If it is true, then
the task_struct should be saved before send_sig like my patch:

                        if (srvTcp->tsk) {
+                               struct task_struct * tsk = srvTcp->tsk;
                               send_sig(SIGKILL,srvTcp->tsk,1);
-                               kthread_stop(srvTcp->tsk);
+                               kthread_stop(tsk);

Regards
dave


