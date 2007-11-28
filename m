Return-Path: <linux-kernel-owner+w=401wt.eu-S1760106AbXK1Bon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106AbXK1Bon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 20:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755234AbXK1Boc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 20:44:32 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37627 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbXK1Boc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 20:44:32 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <andrea@suse.de>, linux-kernel@vger.kernel.org,
       jack@suse.cz, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: /proc dcache deadlock in do_exit
References: <20071127132022.GW6840@v2.random>
	<20071127143852.601509ac.akpm@linux-foundation.org>
Date: Tue, 27 Nov 2007 18:43:02 -0700
In-Reply-To: <20071127143852.601509ac.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 27 Nov 2007 14:38:52 -0800")
Message-ID: <m1zlwzgn6h.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Tue, 27 Nov 2007 14:20:22 +0100
> Andrea Arcangeli <andrea@suse.de> wrote:
>
>> Hi,
>> 
>> this patch fixes a sles9 system hang in start_this_handle from a
>> customer with some heavy workload where all tasks are waiting on
>> kjournald to commit the transaction, but kjournald waits on t_updates
>> to go down to zero (it never does). This was reported as a lowmem
>> shortage deadlock but when checking the debug data I noticed the VM
>> wasn't under pressure at all (well it was really under vm pressure,
>> because lots of tasks hanged in the VM prune_dcache methods trying to
>> flush dirty inodes, but no task was hanging in GFP_NOFS mode, the
>> holder of the journal handle should have if this was a vm issue in the
>> first place). No task was apparently holding the leftover handle in
>> the committing transaction, so I deduced t_updates was stuck to 1
>> because a journal_stop was never run by some path (this turned out to
>> be correct). With a debug patch adding proper reverse links and stack
>> trace logging in ext3 deployed in production, I found journal_stop is
>> never run because mark_inode_dirty_sync is called inside release_task
>> called by do_exit. (that was quite fun because I would have never
>> thought about this subtleness, I thought a regular path in ext3 had a
>> bug and it forgot to call journal_stop)
>> 
>> do_exit->release_task->mark_inode_dirty_sync->schedule() (will never
>> come back to run journal_stop)
>
> I don't see why the schedule() will not return?  Because the task has
> PF_EXITING set?  Doesn't TASK_DEAD do that?

Yes, why do we not come back from schedule?

If we are not allowed to schedule after setting PF_EXITING before
we set TASK_DEAD that entire code path sounds brittle and
error prone.


> What are the implications of not running shrink_dcache_parent() on the exit
> path sometimes?  We'll leave procfs stuff behind?  Will they be reaped by
> memory pressure later on?

It should.  I think the reaping is just an optimization.  Because we
know we will never need those dentries again, and we can pin them by
open directories or opening files.  What I don't know off the top of
my head is if there is a d_drop equivalent going on that might be a
problem if we don't address it.

Eric

