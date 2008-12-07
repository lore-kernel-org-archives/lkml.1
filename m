Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbYLGRal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbYLGRal (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 12:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYLGRac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 12:30:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51389 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbYLGRab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 12:30:31 -0500
Date: Sun, 7 Dec 2008 18:28:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Hugh Dickins <hugh@veritas.com>, Jay Lan <jlan@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Pirko <jpirko@redhat.com>, linux-kernel@vger.kernel.org,
       Jonathan Lim <jlim@sgi.com>
Subject: Re: [PATCH] introduce get_mm_hiwater_xxx(), fix
	taskstats->hiwater_xxx accounting
Message-ID: <20081207172845.GA28520@redhat.com>
References: <20081203181220.GA22918@redhat.com> <Pine.LNX.4.64.0812031957570.19174@blonde.anvils> <20081204135250.GA5448@redhat.com> <Pine.LNX.4.64.0812051216020.10157@blonde.anvils> <493975BE.60202@sgi.com> <20081206084223.GA24782@balbir.in.ibm.com> <Pine.LNX.4.64.0812060950120.22390@blonde.anvils> <20081206103904.GC24782@balbir.in.ibm.com> <20081207161750.GA25966@redhat.com> <20081207165828.GA13333@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081207165828.GA13333@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07, Balbir Singh wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2008-12-07 17:17:50]:
>
> > On 12/06, Balbir Singh wrote:
> > >
> > > * Hugh Dickins <hugh@veritas.com> [2008-12-06 09:56:19]:
> > >
> > > > On Sat, 6 Dec 2008, Balbir Singh wrote:
> > > > >
> > > > > Yes, true and getdelays can display all the exported information.
> > > > >
> > > > > The race does seem concerning, I would vote for keeping the update in
> > > > > there and disabling preemption around the update, so that hiwater
> > > > > cannot swing back and forth.
> > > >
> > > > ??  Oleg is _fixing_ a race by removing the update from do_exit();
> > > > and he is fixing the way the hiwater info was collected in tsacct.c.
> > >
> > > I see that change and the reasoning seems accurate that we can query
> > > the task at anytime, but I worry that if taskstats is not enabled, we'll
> > > never call update_hiwater.* on the exiting task.
> >
> > With this patch, even if taskstats _is_ enabled, we never call update_
> > on do_exit() path. Because there is no point to do this.
>
> Hmmm.. I thought the rules were to update it when RSS/total_vm is
> decreasing.

Yes, but we are not going to decrease rss/vm,

> taskstats_exit() calls fill_pid(), which in turn calls
> xacct_add_tsk().

Yes, but we can't rely on update_hiwater_xxx() in do_exit(), because
this path can be called before this thread/process exits.

> > > I wonder if a thread came in and like Oleg said, did (without taskstats
> > > enabled)
> > >
> > > free(malloc(some size)), followed by exit()
> > >
> > > whether task_mem() would show the correct results for hiwater.*.
> >
> > unlike taskstats, task_mem() doesn't rely on update_hiwater_xxx(),
> > it reads the current values and calculates the maximum. And this is
> > the "right thing".
> >
> > update_hiwater_xxx() is only needed when we are going to decrease
> > the current value, so we can lose the info if we don't calculate
> > the maximum right now.
> >
>
> This is a bit confusing, look at strerror_l.c in libc. It frees the
> last strerror value on exit of the thread. If a thread did strerror()
> followed by exit(). If free() and malloc() map to mmap() and munmap(),
> do_exit() will affect RSS and total_vm... no?

No. When the task does unmap, vm does update_hiwater_vm() "internally",
it does not need the help from do_exit(). And do_exit() can't help,
it is to late to calculate the maximum, ->total_vm was already decreased.

do_exit() itself does not affect rss/vm. Until we call exit_mmap(),
but at this point ->mm is dead, nobody can look at it, its ->mm_users
is zero.

> > We can disable preemption around update_ in do_exit(), but this
> > doesn't close the race. We can even disable irqs but this (in
> > theory) is not enough either. But the main point we do not need
> > to update.
> >
>
> See above.

See above ;)

> > And please note that taskstats was wrong even if update_ was not
> > racy. Exactly because it relies on update_ in do_exit(), but it
> > should not.
> >
>
> This is because you believe we should do the comparison like
> task_mem()? task_mem() does no updates of hi_water.*.

Yes. please read the patch, taskstats uses the new get_mm_hiwater_xxx()
helpers.

> > As for ru_maxrss accounting, we can keep these update_hiwater_xxx()
> > calls in do_exit() and then use mm->hiwater_xxx directly, but we
> > should check group_dead in that case. I don't really think this
> > would be cleaner/better, and then we have the similar problems with
> > CLONE_VM tasks.
>
> CLONE_VM without thread groups is sort of annoying and hopefully dead
> :) mm_owner had a lot of complexity due to that

Yes, I know. But I doubt we can stop support CLONE_VM ;)

Oleg.

