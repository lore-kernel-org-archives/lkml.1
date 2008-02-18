Return-Path: <linux-kernel-owner+w=401wt.eu-S1758568AbYBREUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568AbYBREUG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 23:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbYBRETy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 23:19:54 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58591 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970AbYBRETx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 23:19:53 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [PATCH] do_signal_stop: use signal_group_exit()
References: <20080215180204.GA4359@tv-sign.ru>
	<20080215193756.9e5b8205.akpm@linux-foundation.org>
	<20080216140212.GA1421@tv-sign.ru> <20080217231019.GA83@tv-sign.ru>
Date: Sun, 17 Feb 2008 21:11:14 -0700
In-Reply-To: <20080217231019.GA83@tv-sign.ru> (Oleg Nesterov's message of
	"Mon, 18 Feb 2008 02:10:19 +0300")
Message-ID: <m1skzq9a59.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 02/16, Oleg Nesterov wrote:
>>
>> On 02/15, Andrew Morton wrote:
>> >
>> > ug.  On about the fourth boot with the current -mm lineup I hit:
>> >
>> > : BUG: unable to handle kernel paging request at 0000000000200200
>>                                                    ^^^^^^^^^^^^^^^^
>> == LIST_POISON2
>> 
>> > : IP: [<ffffffff802444f5>] free_pid+0x35/0x8e
>> 
>> most probably == hlist_del_rcu(pid_chain)
>> 
>> > : Call Trace:
>> > :  [<ffffffff80237727>] ? release_task+0x152/0x2e5
>> > :  [<ffffffff80237f81>] ? do_wait+0x6c7/0xa1c
>> > :  [<ffffffff8022f4cc>] ? default_wake_function+0x0/0xe
>> > :  [<ffffffff8023e670>] ? sys_rt_sigaction+0x7a/0x98
>> > :  [<ffffffff80238360>] ? sys_wait4+0x8a/0xa1
>> > :  [<ffffffff8020be4b>] ? system_call_after_swapgs+0x7b/0x80
>> 
>> (Can't understand why there is no detach_pid() in this stack trace,
>>  but it is the only possible caller of free_pid()).

That is just because of tail call optimization.  There is no need
to return to detach_pid so we just jumped to free_pid.

>
>> So, detach_pid()->free_pid() hit an already unhashed pid. But this
>> is not possible?
>> 
>> This means we already did detach_pid(), but in that case the previous
>> detach_pid() has set task->pids[].pid = NULL, and we should OOPS earlier,
>> somewhere at "if (!hlist_empty(&pid->tasks[tmp]))".
>
> Yes, this is not possible.
>
> But what possible is: we have the unbalanced put_pid(pid) which frees the
> live pid. The next alloc_pid() gets the same memory, and initializes all
> pid->tasks[] lists.
>
> Now, if that pid was used as PIDTYPE_PGID/PIDTYPE_SID, the next detach_pid()
> from this pgrp/sid sees that the pid is not used (all lists are hlist_empty),
> frees this pid again, and the bug manifests itself this way.
>
> 	tiocspgrp:
>
> 		put_pid(real_tty->pgrp);
> 		// ------ WINDOW ------
> 		real_tty->pgrp = get_pid(pgrp);
>
> When bash spawns the command, both parent and child do ioctl(TIOCSPGRP,child),
> and it is possible that both do put_pid() on the same parent's pid.
>
> Damn, when you know what the bug is, the test case is trivial:
>
> 	$ while true; do perl -e0; done
>
> The kernel crashes.
>
>>From 2.6.25-rc2-mm1.bz2 patch:
>>
>> -       .ioctl          = tty_ioctl,
>> +       .unlocked_ioctl = tty_ioctl,
>
> and this is why this didn't happen before, I guess.
>
>> I'll try to think more about this, but I doubt very much I'll find the
>> reason :(
>
> Ohhh... 7 (!!!) hours of hacking + some vodka did the trick.
>
> (Kamalesh, I think you hit the same bug).

Thanks.  Looks like we need to grab a lock there.
At a quick skim I think we need the tty lock.


Eric
