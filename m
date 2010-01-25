Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276Ab0AYUwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab0AYUwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 15:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850Ab0AYUwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 15:52:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:32193 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab0AYUwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 15:52:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=il+3IBHBPOymCiHl0Ynm0/nJHJNKuLiDF0+JFf50e59YlF1vTD/2dookfJyMtm6hxH
         2z+jqQlHHURvSjye5VzsCkCV8RqfeR1cSfxKWLJdF670ZwDM3+YeX6QXXdsP5w+yNWie
         pocfq/rMD0ITlwmtJYPbS/nPGlL5orTmpwipk=
Date: Mon, 25 Jan 2010 21:52:03 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [RFC PATCH 03/10] ftrace: Drop the ftrace_profile_enabled
	checks in tracing hot path
Message-ID: <20100125205200.GC5087@nowhere>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com> <1264122982-1553-4-git-send-regression-fweisbec@gmail.com> <1264125917.31321.312.camel@gandalf.stny.rr.com> <20100122024332.GB8140@nowhere> <1264129506.31321.325.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264129506.31321.325.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 10:05:06PM -0500, Steven Rostedt wrote:
> On Fri, 2010-01-22 at 03:43 +0100, Frederic Weisbecker wrote:
> 
> > > Now for the reason I Cc'd Paul and Mathieu...
> > > 
> > > If we had a synchronize_sched() like function that would wait and return
> > > when all preempted tasks have been scheduled again and went to either
> > > userspace or called schedule directly, then we could actually do this.
> > > 
> > > After unregistering the function graph trace, you call this
> > > "synchronize_tasks()" and it will guarantee that all currently preempted
> > > tasks have either went to userspace or have called schedule() directly.
> > > Then it would be safe to remove this check.
> > 
> > 
> > 
> > Good point!
> > 
> > I fear that would require heavy hooks in the scheduler though...
> > 
> 
> Not a heavy one. We could add a field to the task_struct and just call
> something if it is set.
> 
> 
> At start of schedule()
> 
> 	if (unlikely(current->pcount))
> 		handle_pcount_waiters(current);
> 
> 
> void handle_pcount_waiters(struct task_struct *p)
> {
> 	current->pcount = 0;
> 	wake_up(pcount_waiters);
> }
> 
> 
> and for the synchronize_tasks(), just search the task list for tasks
> that are on the run queue but not running, and add a pcount timestamp
> and record the list of tasks (allocated list).
> 
> After it is woken up, it checks the list of tasks and if a task does not
> have the pcount timestamp that matches what was stored, it removes it
> from the list. When it is finally woken up and does not have any more
> tasks on the list, it continues.
> 
> This is just a basic idea, i left out a bunch of details, but I'm sure
> it is feasible. This type of wait may work for other types of lockless
> algorithms too.
> 
> -- Steve



Sounds like a good idea. That would avoid these wasteful checks and
resident buffers.

