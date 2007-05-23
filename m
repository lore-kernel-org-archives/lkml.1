Return-Path: <linux-kernel-owner+w=401wt.eu-S1765412AbXEWN3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765412AbXEWN3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 09:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbXEWN2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 09:28:52 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:45921 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918AbXEWN2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 09:28:52 -0400
In-Reply-To: <a8e1da0705230137r1b2b06cbg7133141d75292e22@mail.gmail.com>
To: "young dave" <hidave.darkstar@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       David Kleikamp <shaggy@us.ibm.com>,
       Shirish S Pargaonkar <shirishp@us.ibm.com>
Subject: Re: 2.6.22-rc1-mm1 cifs_mount oops
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0 HF144 February 01, 2006
Message-ID: <OF794FED81.D7F8CFC9-ON872572E4.004974FE-862572E4.004A1708@us.ibm.com>
From: Steven French <sfrench@us.ibm.com>
Date: Wed, 23 May 2007 08:28:47 -0500
X-MIMETrack: Serialize by Router on D03NM123/03/M/IBM(Release 7.0.2HF32 | October 17, 2006) at
 05/23/2007 07:28:49,
	Serialize complete at 05/23/2007 07:28:49
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes - this patch looks better.

I also am not sure whether the send_sig is still necessary to wake up a 
thread blocked in tcp recv_msg (only do a wake_up_process vs. doing a 
send_sig(SIGKILL) )

Unless someone knows for sure whether the send_sig is redundant, I would 
like to merge Shaggy's version of the patch


"young dave" <hidave.darkstar@gmail.com> wrote on 05/23/2007 03:37:04 AM:

> Hi,
> Sorry for the wrong patch in my last post.
> 
> How about save the tsk then call kthread_stop like this:
> 
> diff -udr linux/fs/cifs/connect.c linux.new/fs/cifs/connect.c
> --- linux/fs/cifs/connect.c     2007-05-23 10:59:13.000000000 +0000
> +++ linux.new/fs/cifs/connect.c 2007-05-23 16:33:54.000000000 +0000
> @@ -2069,8 +2069,9 @@
>                         srvTcp->tcpStatus = CifsExiting;
>                         spin_unlock(&GlobalMid_Lock);
>                         if (srvTcp->tsk) {
> +                               struct task_struct * tsk = srvTcp->tsk;
>                                 send_sig(SIGKILL,srvTcp->tsk,1);
> -                               kthread_stop(srvTcp->tsk);
> +                               kthread_stop(tsk);
>                         }
>                 }
>                  /* If find_unc succeeded then rc == 0 so we can not end 
*/
> 
> Regards
> dave

Shaggy's suggested patch seems slightly better:

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 216fb62..b6e2158 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2069,8 +2069,12 @@ cifs_mount(struct super_block *sb, struct 
cifs_sb_info *cifs_sb,
                                                 srvTcp->tcpStatus = 
CifsExiting;
 spin_unlock(&GlobalMid_Lock);
                                                 if (srvTcp->tsk) {
+                                                                struct 
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
                                 }
                                  /* If find_unc succeeded then rc == 0 so 
we can not end */

Steve French
Senior Software Engineer
Linux Technology Center - IBM Austin
phone: 512-838-2294
email: sfrench at-sign us dot ibm dot com
