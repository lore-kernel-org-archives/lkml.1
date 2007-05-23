Return-Path: <linux-kernel-owner+w=401wt.eu-S1765089AbXEWQKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765089AbXEWQKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757071AbXEWQKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:10:24 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756921AbXEWQKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:10:23 -0400
Date: Wed, 23 May 2007 09:10:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven French <sfrench@us.ibm.com>
Cc: "young dave" <hidave.darkstar@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       David Kleikamp <shaggy@us.ibm.com>,
       Shirish S Pargaonkar <shirishp@us.ibm.com>
Subject: Re: 2.6.22-rc1-mm1 cifs_mount oops
Message-Id: <20070523091013.b1475211.akpm@linux-foundation.org>
In-Reply-To: <OF794FED81.D7F8CFC9-ON872572E4.004974FE-862572E4.004A1708@us.ibm.com>
References: <a8e1da0705230137r1b2b06cbg7133141d75292e22@mail.gmail.com>
	<OF794FED81.D7F8CFC9-ON872572E4.004974FE-862572E4.004A1708@us.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 08:28:47 -0500 Steven French <sfrench@us.ibm.com> wrote:

> Yes - this patch looks better.
> 
> I also am not sure whether the send_sig is still necessary to wake up a 
> thread blocked in tcp recv_msg (only do a wake_up_process vs. doing a 
> send_sig(SIGKILL) )
> 
> Unless someone knows for sure whether the send_sig is redundant, I would 
> like to merge Shaggy's version of the patch
> 
> 
> "young dave" <hidave.darkstar@gmail.com> wrote on 05/23/2007 03:37:04 AM:
> 
> > Hi,
> > Sorry for the wrong patch in my last post.
> > 
> > How about save the tsk then call kthread_stop like this:
> > 
> > diff -udr linux/fs/cifs/connect.c linux.new/fs/cifs/connect.c
> > --- linux/fs/cifs/connect.c     2007-05-23 10:59:13.000000000 +0000
> > +++ linux.new/fs/cifs/connect.c 2007-05-23 16:33:54.000000000 +0000
> > @@ -2069,8 +2069,9 @@
> >                         srvTcp->tcpStatus = CifsExiting;
> >                         spin_unlock(&GlobalMid_Lock);
> >                         if (srvTcp->tsk) {
> > +                               struct task_struct * tsk = srvTcp->tsk;
> >                                 send_sig(SIGKILL,srvTcp->tsk,1);
> > -                               kthread_stop(srvTcp->tsk);
> > +                               kthread_stop(tsk);
> >                         }
> >                 }
> >                  /* If find_unc succeeded then rc == 0 so we can not end 
> */
> > 
> > Regards
> > dave
> 
> Shaggy's suggested patch seems slightly better:
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 216fb62..b6e2158 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2069,8 +2069,12 @@ cifs_mount(struct super_block *sb, struct 
> cifs_sb_info *cifs_sb,
>                                                  srvTcp->tcpStatus = 
> CifsExiting;
>  spin_unlock(&GlobalMid_Lock);
>                                                  if (srvTcp->tsk) {
> +                                                                struct 
> task_struct *tsk;
>  send_sig(SIGKILL,srvTcp->tsk,1);
> - kthread_stop(srvTcp->tsk);
> +                                                                /* 
> srvTcp->tsk can be zeroed at any time */
> +                                                                tsk = 
> srvTcp->tsk;
> +                                                                if (tsk)
> +  kthread_stop(tsk);
>                                                  }
>                                  }
>                                   /* If find_unc succeeded then rc == 0 so 
> we can not end */

The wordwrapping made that extraordinarily hard to read.  Repairing...

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2069,8 +2069,12 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
			srvTcp->tcpStatus = CifsExiting;
			spin_unlock(&GlobalMid_Lock);
			if (srvTcp->tsk) {
				struct  task_struct *tsk;
				send_sig(SIGKILL,srvTcp->tsk,1);
-				kthread_stop(srvTcp->tsk);
+				/*  srvTcp->tsk can be zeroed at any time */
+				tsk = srvTcp->tsk;
+				if (tsk)
+					kthread_stop(tsk);
			}
		}
		/* If find_unc succeeded then rc == 0 so we can not end */


This can end up running kthread_stop() against an already-exited task.

