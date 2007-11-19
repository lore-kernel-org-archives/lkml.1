Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbXKSSQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbXKSSQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbXKSSQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:16:04 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55138 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbXKSSQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:16:03 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] task_pid_nr_ns() breaks proc_pid_readdir()
References: <20071117181549.GA1415@tv-sign.ru>
	<m1bq9swqyu.fsf@ebiederm.dsl.xmission.com>
	<20071118142047.GA360@tv-sign.ru>
Date: Mon, 19 Nov 2007 11:15:03 -0700
In-Reply-To: <20071118142047.GA360@tv-sign.ru> (Oleg Nesterov's message of
	"Sun, 18 Nov 2007 17:20:47 +0300")
Message-ID: <m1tzniumoo.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 11/17, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@tv-sign.ru> writes:
>> 
>> > Make sure that task_pid_nr_ns() returns !0 before updating tgid. Note that
>> > next_tgid(tgid + 1) can find the same "struct pid" again, but we shouldn't
>> > go into the endless loop because pid_task(PIDTYPE_PID) must return NULL in
>> > this case, so next_tgid() can't return the same task.
>> >
>> Oleg I think I would rather update next_tgid to return the tgid (which
>> removes the need to call task_pid_nr_ns).  This keeps all of the task
>> iteration logic together in next_tgid.
>
> Yes sure, I think your patch is also correct, please use it.
>
> <offtopic>
>
> Personally, I hate the functions which use pointers to return another value.
> (yes, yes, I know, my taste is perverted). Why don't we return structure in
> this case? We can even make a common helper struct, say,
>
> Of course, another option is to rewrite the kernle in perl, in that case
> proc_pid_readdir() can just do
>
> 	(task, tgid) = next_tgid();

I wish that last syntax worked in C.  That would make returning
structures so much easier.  From a compiler optimization standpoint
returning structures is ever so much nicer.  Seeing through pointers
or references to optimize things is tricky.

> </offtopic>
>
>> Although looking at this in more detail, I'm half wondering if
>> proc_pid_make_inode() should take a struct pid instead of a task.
>
> Yes, I also thought about this. Needs more changes, and still not perfect.
>
> I am starting to think we need a more generic change. How about the patch
> below? With this change the stable task_struct implies we have the stable
> pids, this allows us to do a lot of cleanups.

I don't see the huge pile of opportunities to clean up.  But otherwise
I am in favor of it.  In the normal case it should only delay freeing
of struct pid (and the corresponding namespace) by an rcu interval so it
isn't a big deal.

I suspect it will be a help with killing things like the global pids
in task_struct.

Regardless I'm going to pass on the keeping struct pid on the task
struct until we free it and reference counting it there for the
immediate present as I think we can solve the immediate issues cleanly
without it, and we are pretty much in bug fixing territory now.

Eric
