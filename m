Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbYBQXL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbYBQXL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 18:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbYBQXLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 18:11:21 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:39620 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbYBQXLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 18:11:19 -0500
Date: Mon, 18 Feb 2008 02:10:19 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] do_signal_stop: use signal_group_exit()
Message-ID: <20080217231019.GA83@tv-sign.ru>
References: <20080215180204.GA4359@tv-sign.ru> <20080215193756.9e5b8205.akpm@linux-foundation.org> <20080216140212.GA1421@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080216140212.GA1421@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Oleg Nesterov wrote:
>
> On 02/15, Andrew Morton wrote:
> >
> > ug.  On about the fourth boot with the current -mm lineup I hit:
> >
> > : BUG: unable to handle kernel paging request at 0000000000200200
>                                                    ^^^^^^^^^^^^^^^^
> == LIST_POISON2
> 
> > : IP: [<ffffffff802444f5>] free_pid+0x35/0x8e
> 
> most probably == hlist_del_rcu(pid_chain)
> 
> > : Call Trace:
> > :  [<ffffffff80237727>] ? release_task+0x152/0x2e5
> > :  [<ffffffff80237f81>] ? do_wait+0x6c7/0xa1c
> > :  [<ffffffff8022f4cc>] ? default_wake_function+0x0/0xe
> > :  [<ffffffff8023e670>] ? sys_rt_sigaction+0x7a/0x98
> > :  [<ffffffff80238360>] ? sys_wait4+0x8a/0xa1
> > :  [<ffffffff8020be4b>] ? system_call_after_swapgs+0x7b/0x80
> 
> (Can't understand why there is no detach_pid() in this stack trace,
>  but it is the only possible caller of free_pid()).
> 
> So, detach_pid()->free_pid() hit an already unhashed pid. But this
> is not possible?
> 
> This means we already did detach_pid(), but in that case the previous
> detach_pid() has set task->pids[].pid = NULL, and we should OOPS earlier,
> somewhere at "if (!hlist_empty(&pid->tasks[tmp]))".

Yes, this is not possible.

But what possible is: we have the unbalanced put_pid(pid) which frees the
live pid. The next alloc_pid() gets the same memory, and initializes all
pid->tasks[] lists.

Now, if that pid was used as PIDTYPE_PGID/PIDTYPE_SID, the next detach_pid()
from this pgrp/sid sees that the pid is not used (all lists are hlist_empty),
frees this pid again, and the bug manifests itself this way.

	tiocspgrp:

		put_pid(real_tty->pgrp);
		// ------ WINDOW ------
		real_tty->pgrp = get_pid(pgrp);

When bash spawns the command, both parent and child do ioctl(TIOCSPGRP,child),
and it is possible that both do put_pid() on the same parent's pid.

Damn, when you know what the bug is, the test case is trivial:

	$ while true; do perl -e0; done

The kernel crashes.

>From 2.6.25-rc2-mm1.bz2 patch:
>
> -       .ioctl          = tty_ioctl,
> +       .unlocked_ioctl = tty_ioctl,

and this is why this didn't happen before, I guess.

> I'll try to think more about this, but I doubt very much I'll find the
> reason :(

Ohhh... 7 (!!!) hours of hacking + some vodka did the trick.

(Kamalesh, I think you hit the same bug).

Oleg.

