Return-Path: <linux-kernel-owner+w=401wt.eu-S941892AbYCSW6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941892AbYCSW6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966330AbYCSVYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:24:13 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:33591 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966325AbYCSVYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:24:11 -0400
Date: Wed, 19 Mar 2008 03:31:12 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: rfc, leader_pid_type()
Message-ID: <20080319003112.GA183@tv-sign.ru>
References: <20080318153811.GA3488@tv-sign.ru> <m18x0fvh5d.fsf@ebiederm.dsl.xmission.com> <20080318221552.GA143@tv-sign.ru> <m13aqnvdnk.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m13aqnvdnk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
> > On 03/18, Eric W. Biederman wrote:
> >>
> >> Oleg Nesterov <oleg@tv-sign.ru> writes:
> >> 
> >> > Eric, Pavel.
> >> >
> >> > Without tasklist lock held, task_tgid/task_pgrp/task_session can return the
> >> > bogus NULL. Note that the last 2 can return NULL even if task == current.
> >> >
> >> > What do you think if we add yet another helper?
> >> 
> >> My current inclination is this places the cost for de_thread in the
> >> wrong place.  exec on a threaded binary should be rare.
> >> Any chance we can make de_thread rcu safe?
> >> 
> >> We are very close.
> >> 
> >> It would take a double check but I believe all we need to do is to
> >> modify detach_pid to remove link->pid.  This of course messes up
> >> pid_alive but otherwise we should be ok if we have a big fat comment.
> >
> > Not sure I understand... detach_pid(type) already sets
> >
> > 	task->pids[type].pid = NULL;
> 
> Sorry.  I meant to remove that line that clears task->pids[type].pid 
> If we don't set .pid to NULL we can still dereference while the task_struct
> is rcu reachable.

!!!!! Yes you are right.

No, we don't need to change detach_pid(), but we can change transfer_pid()
and kill this line:

	old->pids[type].pid = NULL;

this can't break de_thread()->release_task(leader)->__unhash_process()
because leader is not group_leader() any longer.

And with this change we can't see task_session() == NULL under rcu_read_lock()
during exec, great!

And. this doesn't break do_each_pid_task(PIDTYPE_SID), we can't see both
old and new leaders.

> >> We might need to replace the detach_pid, attach_pid sequence in
> >> __set_special_pids with an optimized sequence like transfer_pid
> >> call it replace_pid where we guarantee there is always a valid pid
> >> pointer in the group_leader.
> >
> > OK... I think you are right... good point.

Yes, good point. Except we need a couple of subtle but straightforward
changes, but I think this change worth it.

Perhaps I (or you ;) missed something, I'll re-check... but this all
looks like a good plan, thanks!

Oleg.

