Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbXLIPss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbXLIPss (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 10:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbXLIPsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 10:48:41 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59585 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbXLIPsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 10:48:40 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] will_become_orphaned_pgrp: we have threads
References: <20071208183800.GA9940@tv-sign.ru>
	<m11w9wpx03.fsf@ebiederm.dsl.xmission.com>
	<20071209142116.GB131@tv-sign.ru>
Date: Sun, 09 Dec 2007 08:45:58 -0700
In-Reply-To: <20071209142116.GB131@tv-sign.ru> (Oleg Nesterov's message of
	"Sun, 9 Dec 2007 17:21:16 +0300")
Message-ID: <m14perooqx.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 12/08, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@tv-sign.ru> writes:
>> 
>> > p->exit_state != 0 doesn't mean this process is dead, it may have
> sub-threads.
>> >
>> > However, the new "p->exit_state && thread_group_empty(p)" check is not
> correct
>> > either, this is just the temporary hack. Perhaps we can just remove this
> check,
>> > but I don't understand orphaned process groups magic. At all. However, I
> think
>> > exit_notify() is obviously and completely wrong wrt this helper.
>> 
>> The problem that orphaned processes groups address is what happens if
>> an entire process group is stopped, and there is not a process that
>> can wake them up.
>> 
>> The rule for an unprivileged process sending a signal to a process
>> group is that it must be in the same session as the process group.
>> 
>> The rule for sending a signal to a process group is that the signal sender
>> must be in the same session.
>> 
>> So we are testing for a process group that does not have a living
>> member with a parent outside of the process that can send the process
>> group a signal.
>
> Ah, thanks a lot Eric, I am _starting_ to understand this.
>
>> Oleg what do you see wrong with checking p->exit_state &&
>> thread_group_empty(p)?   Since non-leader threads all self reap
>> that seems to be a valid test for an dead thread group.
>
> There is a window when exit_notify() drops tasklist and before release_task().
> Suppose the last (non-leader) thread exits. This means that entire group exits,
> but thread_group_empty() is not true.


And if you are an observer this is important.

Equally messed up is a our status in /proc at that point.  Which
says our sleeping process is a zombie.

I'm thinking we need to do at least some of the thread group leadership
transfer in do_exit, instead of de_thread.  Then p->group_leader->exit_state
would be sufficient to see if the entire thread group was alive,
as the group_leader would be whoever was left alive.  The original
group_leader might still need to be kept around for it's pid...

I think that would solve most of the problems you have with a dead
thread group leader and sending SIG_STOP as well.

Eric
