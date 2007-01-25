Return-Path: <linux-kernel-owner+w=401wt.eu-S1030475AbXAYRhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030475AbXAYRhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 12:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030472AbXAYRhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 12:37:00 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:41490 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030475AbXAYRg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 12:36:59 -0500
Date: Thu, 25 Jan 2007 11:36:55 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Cedric Le Goater <clg@fr.ibm.com>,
       Daniel Hokka Zakrisson <daniel@hozac.com>, herbert@13thfloor.at,
       akpm@osdl.org, trond.myklebust@fys.uio.no,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH] namespaces: fix race at task exit
Message-ID: <20070125173655.GB10073@sergelap.austin.rr.com>
References: <20070125150542.GA27472@sergelap.austin.ibm.com> <20070125163936.GA249@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070125163936.GA249@tv-sign.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@tv-sign.ru):
> On 01/25, Serge E. Hallyn wrote:
> >
> > In do_exit(), the exit_task_namespaces() was placed after
> > exit_notify() because exit_notify ends up using the pid
> > namespace both to access the reaper, and for detaching the
> > pid.  However, this placement allows an nfs server to reap
> > the task before exit_task_namespaces() completes.
> > 
> > This patch moves the exit_task_namespaces() into release_task,
> > below release_thread() which puts the pids(), and just above
> > the call_rcu(delayed_put_task_struct).  I believe this should
> > solve both problems.
> > 
> > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> > 
> > ---
> > 
> >  kernel/exit.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > 765277a4170d7bbd1c4613de661ec6ac64d5580a
> > diff --git a/kernel/exit.c b/kernel/exit.c
> > index 3540172..ab9ae30 100644
> > --- a/kernel/exit.c
> > +++ b/kernel/exit.c
> > @@ -174,6 +174,7 @@ repeat:
> >  	write_unlock_irq(&tasklist_lock);
> >  	proc_flush_task(p);
> >  	release_thread(p);
> > +	exit_task_namespaces(p);
> >  	call_rcu(&p->rcu, delayed_put_task_struct);
> 
> Probably I missed some other patches in this area, but I can't understand
> this fix.
> 
> With this change we are doing __put_mnt_ns() when we surely don't have ->sighand,
> no? Could you please explain?

Explanation: it's wrong  :)

we'll just need to break exit_task_namespaces() up.

thanks,
-serge
