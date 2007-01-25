Return-Path: <linux-kernel-owner+w=401wt.eu-S1030557AbXAYUgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030557AbXAYUgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 15:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030559AbXAYUgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 15:36:51 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60520 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030557AbXAYUgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 15:36:50 -0500
Date: Thu, 25 Jan 2007 14:36:44 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Cedric Le Goater <clg@fr.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Daniel Hokka Zakrisson <daniel@hozac.com>, herbert@13thfloor.at,
       akpm@osdl.org, trond.myklebust@fys.uio.no,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH] namespaces: fix race at task exit
Message-ID: <20070125203644.GC21534@sergelap.austin.ibm.com>
References: <20070125150542.GA27472@sergelap.austin.ibm.com> <m14pqfysrq.fsf@ebiederm.dsl.xmission.com> <20070125173556.GA10073@sergelap.austin.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070125173556.GA10073@sergelap.austin.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serue@us.ibm.com):
> Quoting Eric W. Biederman (ebiederm@xmission.com):
> > "Serge E. Hallyn" <serue@us.ibm.com> writes:
> > 
> > > In do_exit(), the exit_task_namespaces() was placed after
> > > exit_notify() because exit_notify ends up using the pid
> > > namespace both to access the reaper, and for detaching the
> > > pid.  However, this placement allows an nfs server to reap
> > > the task before exit_task_namespaces() completes.
> > >
> > > This patch moves the exit_task_namespaces() into release_task,
> > > below release_thread() which puts the pids(), and just above
> > > the call_rcu(delayed_put_task_struct).  I believe this should
> > > solve both problems.
> > 
> > 
> > For the pid namespace this seems to be correct placement.
> > For the mount namespace this would seem to exacerbate the problem
> > because it now gets called after the task has been reaped!
> > 
> > I'd love to be convinced otherwise but I do not believe we
> > can safely exit both the mount and the pid namespace at the
> > same location in the code.
> > 
> > The NFS unmount currently wants a killable thread as it
> > uses interruptible sleeps.  How does starting that process
> > after the process in which it lives aid this?
> 
> I should have mentioned I'm unable to reproduce the original
> oops myself, so i wanted confirmation about whether this fixed
> the problem.
> 
> I had thought the mount problem was that the nfs server causes
> the task_struct to be freed before exit_task_namespaces() completes,
> so that exit_task_namespaces() dereferences a bad pointer.  If
> that were the case, this would fix it by not putting the final
> reference to the task_struct (with delayed_put_task_struct())
> until after exit_task_namespaces().  It sounds like I misunderstood
> the nfs server problem though.
> 
> > But thanks for remembering this.  This is a real problem we
> > do need to solve.
> 
> If it is confirmed that my patch is wrong, then I guess we simply
> need a two-stage namespace exit, where the first stage happens
> above exit_notify() and exits the mounts namespace, and the second
> stage can happen in the location I used in this patch.

Of course the problem with this is that the mounts and proc
namespaces now have slightly different lifetimes, and we cannot
use one use count to track both because it's quite possible
that the two last tasks in a namespace could both come to the
release_mounts_namespaces() point at the same time, then both
come to the exit_tasks_namespaces().

So it seems to me we need to either pull one of the two out of
the nsproxy, or add a second use count to the nsproxy.  The
second use count looks kludgier, but uses less space and seems
safer to maintain because at least the lifetime management happens
somewhat close to each other, whereas moving moutns namespace back
outside of nsproxy means going back to a completely differnet meaning
of mnt_ns->count.

Opinions, or other ideas?

thanks,
-serge
