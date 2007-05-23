Return-Path: <linux-kernel-owner+w=401wt.eu-S1759948AbXEWWOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbXEWWOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 18:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756699AbXEWWOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 18:14:47 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52615 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675AbXEWWOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 18:14:46 -0400
In-Reply-To: <20070523091013.b1475211.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Kleikamp <shaggy@us.ibm.com>,
       "young dave" <hidave.darkstar@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Shirish S Pargaonkar <shirishp@us.ibm.com>
Subject: Re: 2.6.22-rc1-mm1 cifs_mount oops
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0 HF144 February 01, 2006
Message-ID: <OF5C2BA51B.B63E317D-ON872572E4.00793F56-862572E4.007A3D2C@us.ibm.com>
From: Steven French <sfrench@us.ibm.com>
Date: Wed, 23 May 2007 17:14:42 -0500
X-MIMETrack: Serialize by Router on D03NM123/03/M/IBM(Release 7.0.2HF32 | October 17, 2006) at
 05/23/2007 16:14:42,
	Serialize complete at 05/23/2007 16:14:42
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This can end up running kthread_stop() against an already-exited task.
I don't think so since cifs_demultiplex_thread waits sufficiently long 
before 
exit but after setting srvTcp->tsk to zero (the wait is immediately after 
waking up any processes that may be blocked on requests on this socket to 
give
file requests time to exit from the cifs vfs).   As long as this (mount) 
process were 
scheduled within 1.25 seconds it should be ok although more complicated 
than I
would like (that is why this thread was the last one in cifs to switch
to kthread API).

I wish there were an obvious way to do this, perhaps without using 
kthread_stop at all
for this thread (since that by itself does not seem to work for threads 
blocked 
in various socket calls).


--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2069,8 +2069,12 @@ cifs_mount(struct super_block *sb, struct 
cifs_sb_info *cifs_sb,
                                                 srvTcp->tcpStatus = 
CifsExiting;
 spin_unlock(&GlobalMid_Lock);
                                                 if (srvTcp->tsk) {
                                                                 struct 
task_struct *tsk;
 send_sig(SIGKILL,srvTcp->tsk,1);
- kthread_stop(srvTcp->tsk);
+                                                                /* 
srvTcp->tsk can be zeroed at any time */
+                                                                tsk = 
srvTcp->tsk;
+                                                                if (tsk)
+  kthread_stop(tsk);
                                                 }


I don't think so 


Steve French
Senior Software Engineer
Linux Technology Center - IBM Austin
phone: 512-838-2294
email: sfrench at-sign us dot ibm dot com
