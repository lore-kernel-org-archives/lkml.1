Return-Path: <linux-kernel-owner+w=401wt.eu-S1751726AbZLUXtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbZLUXtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 18:49:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbZLUXtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 18:49:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:57511 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbZLUXtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 18:49:08 -0500
Message-ID: <4B3009DC.7020407@kernel.org>
Date: Tue, 22 Dec 2009 08:50:52 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
References: <1261141088-2014-1-git-send-email-tj@kernel.org>	 <1261143924.20899.169.camel@laptop>  <4B2EE5A5.2030208@kernel.org>	 <1261387377.4314.37.camel@laptop>  <4B2F7879.2080901@kernel.org> <1261405604.4314.154.camel@laptop>
In-Reply-To: <1261405604.4314.154.camel@laptop>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/21/2009 11:26 PM, Peter Zijlstra wrote:
>> I think you're primarily concerned with the scheduler modifications
> 
> No I think the whole wq redesign sucks chunks, because it:
> 
>  1) looses the queue property

Restored with max_active based ST workqueue implementation.

>  2) doesn't deal with cpu heavy tasks/wakeup parallelism

workqueue was never suited for this.  MT workqueues have strong CPU
affinity which doesn't make sense for CPU-heavy workloads.  ST
workqueues can't take advantage of parallelism.  We can easily mark
some workqueues as not contributing to concurrency accounting such
that works queued for such wqs are always considered blocked for MT
CPU-heavy workloads.  But I don't think that's the right use of
workqueues.  For CPU-heavy workloads, let's use something which is
more suited to the job.  Something which can take advantage of
parallelism.

>  3) gets fragile at memory-pressure/reclaim

Shared dynamic pool is going to be affected by memory pressure no
matter how you implement it.  cmwq tries to maintain stable level of
workers and has forward progress guarantee.  If you're gonna do shared
pool, it can't get much better.

>  4) didn't consider the RT needs

Can you be more specific?  What RT needs?  It's pretty difficult to
tell when there's no in-kernel user and any shared worker pool would
have pretty similar properties as cmwq.

> Also, I think that whole move tasks back on online stuff is utter crazy,
> just move then to another cpu and leave them there.

Can you be more specific?  Why is it crazy when moving to online but
!active cpu is necessary anyway?

> Also, I don't think it can properly warn of simple AB-BA flush
> deadlocks, where work A flushes B and B flushes A.

During transformation, I lost per-work lockdep annoation in flush_work
path which used to go through wait_on_work().  It can easily be
restored.  Nothing changed at per-work level.  The same lockdep
annoations will work.

> (I also don't much like the colour coding flush implementation, but I
> haven't spend a lot of time considering alternatives)

When you can come up with much better one, let me know.  Will be happy
to replace the current one.

>> and think that the choose-between-two-masks on migration is ugly.  I
>> agree it's not the prettiest thing in this world but then again it's
>> not a lot of code.  The reason why it looks ugly is because the way
>> migration is implemented and parameter is passed in.  API-wise, I
>> think making kthread_bind() synchronized against cpu onliness should
>> be pretty clean.
> 
> Assuming you only migrate blocked tasks the current kthread_bind()
> should suit your needs -- I recently reworked most of the migration
> logic.

Okay, that requires another thread which would watch whether those
rescuers which need to be migrated are scheduled out and a mechanism
to make sure they stay scheduled out.  After the "migration" thread
makes that sure, it would call kthread_bind() and wake up the migrated
rescuers, right?  That's basically what the scheduler "migration"
mechanism does.  Why implement it again?

> But as it stands I don't think its wise to replace the current workqueue
> implementation with this, esp since there are known heavy CPU users
> using it, nor have you addressed the queueing issue (or is that the
> restoration of the single-queue workqueue?)

The queueing one is addressed and which CPU-heavy users are you
talking about?  Workqueues have always been CPU-affine.  Not much
changes for its users by cmwq.

Thanks.

-- 
tejun
