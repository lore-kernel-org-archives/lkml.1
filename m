Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbYLGQVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbYLGQVe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 11:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbYLGQVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 11:21:06 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48827 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234AbYLGQVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 11:21:04 -0500
Date: Sun, 7 Dec 2008 17:17:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Hugh Dickins <hugh@veritas.com>, Jay Lan <jlan@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Pirko <jpirko@redhat.com>, linux-kernel@vger.kernel.org,
       Jonathan Lim <jlim@sgi.com>
Subject: Re: [PATCH] introduce get_mm_hiwater_xxx(), fix
	taskstats->hiwater_xxx accounting
Message-ID: <20081207161750.GA25966@redhat.com>
References: <20081203181220.GA22918@redhat.com> <Pine.LNX.4.64.0812031957570.19174@blonde.anvils> <20081204135250.GA5448@redhat.com> <Pine.LNX.4.64.0812051216020.10157@blonde.anvils> <493975BE.60202@sgi.com> <20081206084223.GA24782@balbir.in.ibm.com> <Pine.LNX.4.64.0812060950120.22390@blonde.anvils> <20081206103904.GC24782@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081206103904.GC24782@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry for delay, I am travelling till 11 Dec)

On 12/06, Balbir Singh wrote:
>
> * Hugh Dickins <hugh@veritas.com> [2008-12-06 09:56:19]:
>
> > On Sat, 6 Dec 2008, Balbir Singh wrote:
> > >
> > > Yes, true and getdelays can display all the exported information.
> > >
> > > The race does seem concerning, I would vote for keeping the update in
> > > there and disabling preemption around the update, so that hiwater
> > > cannot swing back and forth.
> >
> > ??  Oleg is _fixing_ a race by removing the update from do_exit();
> > and he is fixing the way the hiwater info was collected in tsacct.c.
>
> I see that change and the reasoning seems accurate that we can query
> the task at anytime, but I worry that if taskstats is not enabled, we'll
> never call update_hiwater.* on the exiting task.

With this patch, even if taskstats _is_ enabled, we never call update_
on do_exit() path. Because there is no point to do this.

> I wonder if a thread came in and like Oleg said, did (without taskstats
> enabled)
>
> free(malloc(some size)), followed by exit()
>
> whether task_mem() would show the correct results for hiwater.*.

unlike taskstats, task_mem() doesn't rely on update_hiwater_xxx(),
it reads the current values and calculates the maximum. And this is
the "right thing".

update_hiwater_xxx() is only needed when we are going to decrease
the current value, so we can lose the info if we don't calculate
the maximum right now.

We can disable preemption around update_ in do_exit(), but this
doesn't close the race. We can even disable irqs but this (in
theory) is not enough either. But the main point we do not need
to update.

And please note that taskstats was wrong even if update_ was not
racy. Exactly because it relies on update_ in do_exit(), but it
should not.

As for ru_maxrss accounting, we can keep these update_hiwater_xxx()
calls in do_exit() and then use mm->hiwater_xxx directly, but we
should check group_dead in that case. I don't really think this
would be cleaner/better, and then we have the similar problems with
CLONE_VM tasks.

Oleg.

