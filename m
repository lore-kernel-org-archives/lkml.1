Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbZAMWBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbZAMWBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbZAMWA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:00:59 -0500
Received: from broadrack.ru ([195.178.208.66]:48514 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbZAMWA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:00:58 -0500
Date: Wed, 14 Jan 2009 01:00:56 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Rientjes <rientjes@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090113220056.GD27227@ioremap.net>
References: <20090112155615.GA21350@ioremap.net> <20090112161931.6203f96e@lxorguk.ukuu.org.uk> <20090112162938.GA22647@ioremap.net> <496BCB7A.2010804@tmr.com> <20090112231728.GA23803@ioremap.net> <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com> <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com> <20090113115408.GA22289@ioremap.net> <alpine.DEB.2.00.0901131104420.8522@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901131104420.8522@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 11:15:26AM -0800, David Rientjes (rientjes@google.com) wrote:
> > Should this explain why ssh is killed?
> 
> If you would like to make sshd immune from the oom killer, use
> 
> 	echo -17 > /proc/$(pidof sshd)/oom_adj
> 
> just like any other task.  This score will be inherited by any task that 
> it executes, so you'll probably want to readjust your shell's oom_adj 
> score appropriately in your rc file.

For every process? What about short-living ones? Again, parent can not
be changed, since it has to stay, only its children should be killed
(and in some cases not eall, but only those from special set, like cgi
daemons started by the clients, and not database connections).

> > It is very subtle approach. Consider the case when you have a pool of
> > threads/processes which are created and released on demand, there are
> > several such pools for different servers and you do know which one
> > will very likely being guilty.
> > 
> > Who should adjust the scores for newly created processes? Who should
> > check that processes in the first group have negative oom ajustment and
> > in the second group a positive value? Who determines when its time to
> > ajust the scores?
> > 
> 
> It is userspace's responsibility to set the policy, the kernel merely 
> provides the mechanism.

Which does not work for the specified cases. There is no way to specify
the pid of the short-living processes and parent can not be changed (at
least for long enough time).

> > > With oom_adj scores, you have the ability to specify oom kill preferences 
> > > within a cpuset or memory controller as well, whereas oom_victim_name is 
> > > global and very costly when not found in select_bad_process().
> > >
> 
> You chose not to respond to this, which is a major flaw in your approach.  
> 
> Your patch makes cpuset and memory controller oom killing much slower 
> because it requires two iterations through the system tasklist when your 
> global oom_victim_name task is either not running or in a disjoint cpuset 
> or memcg.

It does exactly the same which happens for usual processes, it just
selects the ones with given name and then calculate badness and so on.
It has really nothing with memory group or cpuset, process is selected in
the given memory group.

> > It is not really costly, since most of the time we skip an entry and do
> > not lock the task and do not calculate its badness value. No one scares
> > that 'ps ax' is costly because it has to run through all the processes.
> > 
> 
> Talk to SGI about oom killer tasklist scans for their large systems; it 
> was a prerequisite for me to provide /proc/sys/vm/oom_kill_allocating_task 
> to avoid a single scan when I made cpuset-constrained ooms go through 
> select_bad_process().

If user specifies the name of the process he knows what he is doing. It
is always possibble to set it to null and avoid second scan.
More on this: the loop with check inside and loop without it in sum
equal to the loop with check and other processing.
Which means that if I change the patch to select two process: one with
given name and another one among the others, it will take exactly the
same time and will not introduce second loop (module loop prefetch
optimisations). For example:

loop {
  if (a)
    do_something1();
}

loop {
  do_something2();
}

equals to
loop {
  if (a)
    do_something1();
  do_something2();
}

Getting amount of the checks in that loop already, another one to
compare several (and most of the time just one) letters in the
name does not add overhead. So this does not count.

What really counts is the fact, that so far it is while not perfect, but
working solution for the problem I described, and existing (and
proposed) methods do not work.

-- 
	Evgeniy Polyakov
