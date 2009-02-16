Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbZBPCjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbZBPCjt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 21:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbZBPCjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 21:39:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51594 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbZBPCjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 21:39:40 -0500
Message-ID: <4998D1DC.2090704@cn.fujitsu.com>
Date: Mon, 16 Feb 2009 10:39:24 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: don't alloc_percpu for single workqueue
References: <4976EE0B.5090200@cn.fujitsu.com> <20090121121756.GA11942@redhat.com> <4977EB1C.4030405@cn.fujitsu.com> <20090122161132.GA27250@redhat.com>
In-Reply-To: <20090122161132.GA27250@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Oleg Nesterov

The new version of this patch has not been accepted.
I think it's due to that I forgot reply this mail.

(comment nesting)

Oleg Nesterov wrote:
> On 01/22, Lai Jiangshan wrote:
>> Oleg Nesterov wrote:
>>> On 01/21, Lai Jiangshan wrote:
>>>> @@ -906,6 +907,13 @@ void destroy_workqueue(struct workqueue_struct *wq)
>>>>  	const struct cpumask *cpu_map = wq_cpu_map(wq);
>>>>  	int cpu;
>>>>
>>>> +	if (is_wq_single_threaded(wq)) {
>>>> +		cleanup_workqueue_thread(wq->cpu_wq);
>>>> +		kfree(wq->cpu_wq);
>>>> +		kfree(wq);
>>>> +		return;
>>>> +	}
>>> again, not sure I understand why this change is needed. Afaics we
>>> only need to use kfree(wq->cpu_wq) instead of free_percpu() if
>>> it is single-threaded.
>>>
>> I think this change is needed.
>> In the single thread case, we don't need
>> 1) cpu_maps_update_begin(). --> require cpu_add_remove_lock
>> 2) remove workqueue from the list. (we did not inserted it)
>>
>> It is indeed that there is no bad result occurred when we do these
>> things for single thread. But I think the destroying should not
>> do things more than the creating.
> 
> I disagree.
> 
> Firstly, this path is rare and not time critical, it is better
> to save a couple of bytes from .text.

For non-critical path, I think the prior sequence aim is:

code logic is right
code's readability
save .text size
save cpu cycle

I want to make "code logic is right", so
my patch adds another special case for single thread workqueue.

And in creating site, single thread workqueue are also considered
special.

Thanks
Lai.

> 
> But mostly I dislike the fact that we add another special case
> for the single-threaded wqs which is not strictly needed.
> 
> Following your logic we can also change flush_workqueue(), it
> doesn't need for_each_cpu_mask_nr() when single-threaded.
> 
> 
> That said, I agree this is a matter of taste, I won't persist.
> 
> Oleg.
> 

