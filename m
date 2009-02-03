Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbZBCWtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbZBCWtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 17:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbZBCWtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 17:49:23 -0500
Received: from smtp-out.google.com ([216.239.45.13]:55258 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbZBCWtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 17:49:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=mtlZiXUqybgwNxCaBVzKfeLN25yqR2B7B79QaZeK/PiMUyoUHt6Yr9qGbkRogSMyM
	QWJ20zCb9+gT9Vx7gLVdQ==
MIME-Version: 1.0
In-Reply-To: <20090203141645.91c7ea18.akpm@linux-foundation.org>
References: <4976D77C.3020107@cn.fujitsu.com>
	 <20090127144233.18cf9b3f.akpm@linux-foundation.org>
	 <4987B925.1010405@cn.fujitsu.com>
	 <20090203141645.91c7ea18.akpm@linux-foundation.org>
Date: Tue, 3 Feb 2009 14:49:15 -0800
Message-ID: <6599ad830902031449j1fa3dd08re842b57f8700b389@mail.gmail.com>
Subject: Re: [PATCH] cpuset: fix allocating page cache/slab object on the 
	unallowed node when memory spread is set
From: Paul Menage <menage@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: miaox@cn.fujitsu.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, nickpiggin@yahoo.com.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.148
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 3, 2009 at 2:16 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 03 Feb 2009 11:25:25 +0800
> Miao Xie <miaox@cn.fujitsu.com> wrote:
>
>> on 2009-1-28 6:42 Andrew Morton wrote:
>> > On Wed, 21 Jan 2009 16:06:20 +0800
>> > Miao Xie <miaox@cn.fujitsu.com> wrote:
>> >
>> >> The task still allocated the page caches on old node after modifying its
>> >> cpuset's mems when 'memory_spread_page' was set, it is caused by the old
>> >> mem_allowed_list of the task, the current kernel doesn't updates it unless some
>> >> function invokes cpuset_update_task_memory_state(), it is too late sometimes.
>> >> We must update the mem_allowed_list of the tasks in time.
>> >>
>> >> Slab has the same problem.
>> >>
>> >> We fixes the bug by updating tasks' mem_allowed_list and spread flag after
>> >> its cpuset's mems or spread flag is changed.
>> >>
>> >>
>> >> ...
>> >>
>> >> --- a/kernel/kthread.c
>> >> +++ b/kernel/kthread.c
>> >> @@ -242,6 +242,7 @@ int kthreadd(void *unused)
>> >>    set_user_nice(tsk, KTHREAD_NICE_LEVEL);
>> >>    set_cpus_allowed_ptr(tsk, CPU_MASK_ALL_PTR);
>> >>
>> >> +  current->mems_allowed = node_possible_map;
>> >>    current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
>> >
>> > Why this change?  kthreadd() is called from rest_init(), before anyone
>> > has had a chance to alter ->mems_allowed?
>>
>> I found that after mems_allowed of kthreadd was not initialized applying this patch,
>> every bit of it is 1, so...
>> Maybe it is redundant.
>
> I think it is redundant.  kthreadd's mems_allowed _should_ be all-ones.
> Or at least, all-nodes-allowed.
>
> I wasn't able to find out where the setting of init'smems_allowed
> happens, after a bit of grepping and hunting.  It should be done within
> INIT_TASK, but isn't.
>
> Still, kthreadd is reliably parented by swapper, and there shold be no
> need to alter its mems_allowed.
>
> Similarly, what was the reason for setting current->mems_allowed in
> kernel_init()?  That also should be unneeded.
>
> Finally, I've somewhat lost track of where we are with this patch.
> Paul, do you see any other remaining issues?

AFAICS this patch still has a race between a thread reading its
mems_allowed, and another thread updating it. The current architecture
of having task->mems_allowed be only updatable by current was PaulJ's
code originally, and I'm a bit loathe to touch it. But if we're going
to, we'll need at the minimum to add a lock for any code that touches
current->mems_allowed.

Paul
