Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbXIOSxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbXIOSxQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 14:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbXIOSxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 14:53:05 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:47636 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbXIOSxE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 14:53:04 -0400
Date: Sat, 15 Sep 2007 20:51:24 +0200
From: Guillaume Chazarain <guichaz@yahoo.fr>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       balbir@in.ibm.com, jlan@engr.sgi.com, jlim@sgi.com
Subject: Re: +
 taskstats-add-all-thread-stats-for-taskstats_cmd_attr_tgid.patch added to
 -mm tree
Message-ID: <20070915205124.4ccac9a9@localhost.localdomain>
In-Reply-To: <20070913124141.GA2673@tv-sign.ru>
References: <200709130018.l8D0IgHl026136@imap1.linux-foundation.org>
	<20070913124141.GA2673@tv-sign.ru>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le Thu, 13 Sep 2007 16:41:41 +0400,
Oleg Nesterov <oleg@tv-sign.ru> a écrit :

> (sorry, have no time to read the patch carefully, just a couple of
> minor random "unless I misread this patch" nits)

Thank you Oleg, hopefully I addressed all your comments in v4.

> > +	do
> > +		if (!tsk->exit_state)
> > +			add_tsk(stats, tsk);
> > +	while_each_thread(first, tsk);
> 
> This reminds me. The "!tsk->exit_state" is not good and racy, it
> can't prevent the double accounting (of course, I don't blame this
> patch).

I documented this in v4, but I was wondering if always setting
tsk->exit_state under the protection of lock_task_sighand() would fix
the race.

> > +	if (thread_group_leader(task)) {
> > +		stats->ac_exitcode = task->exit_code;
> > +		if (task->flags & PF_FORKNOEXEC)
> >  			stats->ac_flag |= AFORK;
> 
> Actually, I can't understand this "thread_group_leader()" check, but

Seems like this code was copied from kernel/acct.c:acct_collect():
	if (thread_group_leader(current)) {
		pacct->ac_exitcode = exitcode;
		if (current->flags & PF_FORKNOEXEC)
			pacct->ac_flag |= AFORK;
	}

> I don't know what ->ac_exitcode and AFORK means to the user-space.

>From include/linux/acct.h: executed fork, but did not exec

Except that it talks about fork(2), not do_fork() hence the
thread_group_leader() test to avoid flagging threads.

> But it looks a bit suspicious. Perhaps we need
> ->signal->group_exit_code, not task->exit_code?

I put ->signal->group_exit_code if not null, otherwise
leader->exit_code.

Thank again to you and Andrew for the review.

-- 
Guillaume
