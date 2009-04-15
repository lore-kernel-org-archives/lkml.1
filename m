Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbZDOCdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbZDOCdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 22:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbZDOCdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 22:33:05 -0400
Received: from easi.embeddedalley.com ([71.6.201.124]:47821 "HELO
	easi.embeddedalley.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752260AbZDOCdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 22:33:04 -0400
In-Reply-To: <20090415093555.d84b6655.kamezawa.hiroyu@jp.fujitsu.com>
References: <1239660512-25468-1-git-send-email-dan@embeddedalley.com> <20090415093555.d84b6655.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <70C851F4-3BEA-4DF0-943E-4740A2E5A844@embeddedalley.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Content-Transfer-Encoding: 7bit
From: Dan Malek <dan@embeddedalley.com>
Subject: Re: [PATCH] Memory usage limit notification addition to memcg
Date: Tue, 14 Apr 2009 19:34:04 -0700
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Kame.

On Apr 14, 2009, at 5:35 PM, KAMEZAWA Hiroyuki wrote:

> Welcome to memory cgroup world :)

Thanks.  I think it's a great feature that will be realized
over time.

I was just about to resend the patch, so I'll incorporate
your comments.  I'll reply to some below as well.

> As Andrew pointed out, "percent" is not good.

I updated this to add more granularity, to xx.yy
I can't comprehend why this is a problem.  Conceptually,
it works very well with the applications I have used.  If
you guys really want to use an absolute number for a
notification limit,  we can change it, but I really don't
want to :-)

>> +The memory.notify_limit_lowait is a blocking read file.  The read  
>> will
>> +block until one of four conditions occurs:
>> +
>> +    - The usage reaches or exceeds the memory.notify_limit_percent
>> +    - The memory.notify_limit_lowait file is written with any  
>> value (debug)
>> +    - A thread is moved to another controller group
>
> Why don't you check "moved from other cgroup" case ?
> And why "moved to" case should be catched ?

Sorry, badly worded.  The test is actually when a task moves from
a cgroup.  If a task is moved from one cgroup to another, the threads
waiting for notification in the "from" group are poked to wake up.
I didn't see the need to wake up anyone in the cgroup it may move into.

> I think it's better to remove this CONFIG.

OK.  Should I just add the documentation to
Documentation/cgroups/memory.txt or leave it stand alone?
BTW, all of the ifdefs are removed even with the CONFIG
option.  I just thought if someone was really counting cycles,
wanted memcg without notify, it was easy to do that.

> I don't think this it is sane manner to check this limit  
> always...If this mem_notify is
> not required to as "hard limit", please reduce # of checks.
> How about once per 1MBytes ?
> One notified, the applications can keep observation for a while.

The overhead is small, and this kind of contradicts Andrew's
comment about wanting finer granularity.  Also, the test would have
to be scaled to match the size of the cgroup, on some of the
embedded systems 1M could be a measurable percentage.
But, let me think of some other way to do the math.  I think I'll turn
it around, do the percentage computation only to the application,
not internally.

> Hmm, I think this "lim" can be calculated when the user does "set  
> limit" or
> "set notify_percent".

Yeah, probably.

> And...please wake up all waiting thread at rmdir(). If not, rmdir()  
> will return
> -EBUSY always.

OK, I'll check to make sure this still works.  An empty cgroup causes  
the
notification thread to not sleep and returns zero.

>> +#ifdef CONFIG_CGROUP_MEM_NOTIFY
>> +	init_waitqueue_head(&mem->notify_limit_wait);
>> +	mem->notify_limit_percent = 100;
>> +#endif
>> +
>
> I think this means notify is triggerred at every "reach limit"...
> mem->notify_limit_percent = 101 or some is better.

I just didn't want it to be zero :-)  I think I'll leave it at 100  
because
that's a legal value.  Although, maybe we should allow setting up
to 101 as a way of a preventing notification even if threads are
waiting.

> Hmm. I'll add follwing interface if you necessary. (Or it's ok to  
> add in your set."
>
>   - memory.shirnk_usage_in_bytes
>   example)
>   #echo 1G > memory.limit_in_bytes.
>   use up to 999MB.
>   #echo 100M > memory.shrink_usage_to_bytes.
>         try to reduce 100M of memory usage of this cgroup. and make  
> memory usage to be 899MB.

I understand the idea, but what happens if you can't?
Of course, the proper way is to do this automatically
when the task is moved out :-)

I'll think about all of this for a bit and then submit an
updated patch.

Thanks.

	-- Dan

