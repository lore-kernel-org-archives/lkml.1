Return-Path: <linux-kernel-owner+w=401wt.eu-S1755791AbZAMLyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbZAMLyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 06:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbZAMLyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 06:54:11 -0500
Received: from broadrack.ru ([195.178.208.66]:55551 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbZAMLyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 06:54:10 -0500
Date: Tue, 13 Jan 2009 14:54:08 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Rientjes <rientjes@google.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090113115408.GA22289@ioremap.net>
References: <20090112155030.GA21063@ioremap.net> <20090112155239.5f677a17@lxorguk.ukuu.org.uk> <20090112155615.GA21350@ioremap.net> <20090112161931.6203f96e@lxorguk.ukuu.org.uk> <20090112162938.GA22647@ioremap.net> <496BCB7A.2010804@tmr.com> <20090112231728.GA23803@ioremap.net> <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com> <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 01:54:02AM -0800, David Rientjes (rientjes@google.com) wrote:
> > It is a theory, not a practice. OOM-killer most of time starts from ssh,
> > database and lighttpd on the tested machines, when it could start in
> > the reverse order and do not touch ssh at all. Better not from daemon
> > itself, but its fastcgi spawned processes.
> 
> In the unconstrained system-wide oom case, it scans each task on the 
> system (which can take very long, ask SGI) and rates its badness scoring.  
> When a memory-hogging task is identified, which you have complete control 
> over in userspace by tuning /proc/pid/oom_adj, it attempts to kill a child 
> first if it will allow for memory freeing without killing the parent.

Should this explain why ssh is killed?

> > I agree, that there are ways to tune the way oom-killer selects the
> > victim, and likely after hours of games this subtly will work for the
> > specified workload.
> 
> It doesn't involve "hours of games," it is a very simple heuristic that 
> you can easily tune to specify your preferences.
> 
> What you're looking for with your patch is simply a way to specify an oom 
> preference before the task has been forked, but that's simple to do with 
> the current logic since oom_adj scores are inherited and preference is 
> given to killing a child before parent.

It is very subtle approach. Consider the case when you have a pool of
threads/processes which are created and released on demand, there are
several such pools for different servers and you do know which one
will very likely being guilty.

Who should adjust the scores for newly created processes? Who should
check that processes in the first group have negative oom ajustment and
in the second group a positive value? Who determines when its time to
ajust the scores?

> > What I propose is the simplest way for the most
> > commonly used case.
> 
> No, procfs is the correct interface for tuning oom kill preferences and 
> not by name parsing.
> 
> With oom_adj scores, you have the ability to specify oom kill preferences 
> within a cpuset or memory controller as well, whereas oom_victim_name is 
> global and very costly when not found in select_bad_process().
>
> > It is a help for the admin and not the force to
> > invent complex machinery which will be error-prone and hard to debug
> > when eventually oom happens.
> 
> It's very simple to debug the oom killer's decisions, which is why I 
> introduced /proc/sys/vm/oom_dump_tasks.
> 
> It also requires two expensive scans of the entire tasklist (I introduced 
> /proc/sys/vm/oom_kill_allocating_task specifically to avoid _one_ 
> expensive scan) when oom_victim_name isn't found.

It is not really costly, since most of the time we skip an entry and do
not lock the task and do not calculate its badness value. No one scares
that 'ps ax' is costly because it has to run through all the processes.

Messing with the scores is actually more expensive since we have to lock
the task and perform a calculus. I do not say it is wrong, but it is
much more complex task to being stable compared to simple task selection
by its name. It is what is used and what people expect to have (that's
actually why it was implemented :) and not to write some daemons to
monitor the clients and appropriate processes or change the code of the
servers.

-- 
	Evgeniy Polyakov
