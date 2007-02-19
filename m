Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbXBSL4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbXBSL4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 06:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932185AbXBSL4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 06:56:42 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:40154 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183AbXBSL4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:56:41 -0500
Message-ID: <45D9906F.2090605@in.ibm.com>
Date: Mon, 19 Feb 2007 17:26:31 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: vatsa@in.ibm.com, ckrm-tech@lists.sourceforge.net, xemul@sw.ru,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, menage@google.com,
       svaidy@linux.vnet.ibm.com, devel@openvz.org
Subject: Re: [ckrm-tech] [RFC][PATCH][2/4] Add RSS accounting and control
References: <20070219065019.3626.33947.sendpatchset@balbir-laptop> <20070219065034.3626.2658.sendpatchset@balbir-laptop> <20070219005828.3b774d8f.akpm@linux-foundation.org> <45D97DF8.5080000@in.ibm.com> <20070219030141.42c65bc0.akpm@linux-foundation.org> <45D9856D.1070902@in.ibm.com> <20070219032352.2856af36.akpm@linux-foundation.org>
In-Reply-To: <20070219032352.2856af36.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 19 Feb 2007 16:39:33 +0530 Balbir Singh <balbir@in.ibm.com> wrote:
> 
>> Andrew Morton wrote:
>>> On Mon, 19 Feb 2007 16:07:44 +0530 Balbir Singh <balbir@in.ibm.com> wrote:
>>>
>>>>>> +void memctlr_mm_free(struct mm_struct *mm)
>>>>>> +{
>>>>>> +	kfree(mm->counter);
>>>>>> +}
>>>>>> +
>>>>>> +static inline void memctlr_mm_assign_container_direct(struct mm_struct *mm,
>>>>>> +							struct container *cont)
>>>>>> +{
>>>>>> +	write_lock(&mm->container_lock);
>>>>>> +	mm->container = cont;
>>>>>> +	write_unlock(&mm->container_lock);
>>>>>> +}
>>>>> More weird locking here.
>>>>>
>>>> The container field of the mm_struct is protected by a read write spin lock.
>>> That doesn't mean anything to me.
>>>
>>> What would go wrong if the above locking was simply removed?  And how does
>>> the locking prevent that fault?
>>>
>> Some pages could charged to the wrong container. Apart from that I do not
>> see anything going bad (I'll double check that).
> 
> Argh.  Please, think about this.
> 

Sure, I will. I guess I am short circuiting my thinking process :-)


> That locking *doesn't do anything*.  Except for that one situation I
> described: some other holder of the lock reads mm->container twice inside
> the lock and requires that the value be the same both times (and that sort
> of code should be converted to take a local copy, so this locking here can
> be removed).
> 

Yes, that makes sense.

>>>>>> +
>>>>>> +	read_lock(&mm->container_lock);
>>>>>> +	cont = mm->container;
>>>>>> +	read_unlock(&mm->container_lock);
>>>>>> +
>>>>>> +	if (!cont)
>>>>>> +		goto done;
>>>>> And here.  I mean, if there was a reason for taking the lock around that
>>>>> read, then testing `cont' outside the lock just invalidated that reason.
>>>>>
>>>> We took a consistent snapshot of cont. It cannot change outside the lock,
>>>> we check the value outside. I am sure I missed something.
>>> If it cannot change outside the lock then we don't need to take the lock!
>>>
>> We took a snapshot that we thought was consistent.
> 
> Consistent with what?  That's a single-word read inside that lock.
> 

Yes, that makes sense.

>> We check for the value
>> outside. I guess there is no harm, the worst thing that could happen
>> is wrong accounting during mm->container changes (when a task changes
>> container).
> 
> If container->lock is held when a task is removed from the
> container then yes, `cont' here can refer to a container to which the task
> no longer belongs.
> 
> More worrisome is the potential for use-after-free.  What prevents the
> pointer at mm->container from referring to freed memory after we're dropped
> the lock?
> 

The container cannot be freed unless all tasks holding references to it are
gone, that would ensure that all mm->containers are pointing elsewhere and
never to a stale value.

I hope my short-circuited brain got this right :-)



-- 
	Warm Regards,
	Balbir Singh
