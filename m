Return-Path: <linux-kernel-owner+w=401wt.eu-S1760612AbZLOQyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760612AbZLOQyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 11:54:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760595AbZLOQyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 11:54:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35630 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760592AbZLOQyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 11:54:12 -0500
Message-ID: <807687e0c4dabab00176fd75ada5d177.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0912150920160.16754@router.home>
References: <20091215180904.c307629f.kamezawa.hiroyu@jp.fujitsu.com>
    <20091215181337.1c4f638d.kamezawa.hiroyu@jp.fujitsu.com>
    <alpine.DEB.2.00.0912150920160.16754@router.home>
Date: Wed, 16 Dec 2009 01:54:03 +0900 (JST)
Subject: Re: [mmotm][PATCH 2/5] mm : avoid  false sharing on mm_counter
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Christoph Lameter" <cl@linux-foundation.org>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com, lee.schermerhorn@hp.com
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter さんは書きました：
> On Tue, 15 Dec 2009, KAMEZAWA Hiroyuki wrote:
>
>>  #if USE_SPLIT_PTLOCKS
>> +#define SPLIT_RSS_COUNTING
>>  struct mm_rss_stat {
>>  	atomic_long_t count[NR_MM_COUNTERS];
>>  };
>> +/* per-thread cached information, */
>> +struct task_rss_stat {
>> +	int events;	/* for synchronization threshold */
>
> Why count events? Just always increment the task counters and fold them
> at appropriate points into mm_struct.

I used event counter because I think this patch is _easy_ version of all
I've wrote since November. I'd like to start from simple one rather than
some codes which is invasive and can cause complicated discussion.

This event counter is very simple and all we do can be folded under /mm.
To be honest, I'd like to move synchronization point to tick or
schedule(), but for now, I'd like to start from this.
The point of this patch is "spliting" mm_counter counting and remove
false sharing. The problem of synchronization of counter can be
discussed later.

As you know, I have exterme version using percpu etc...but it's not
too late to think of some best counter after removing false sharing
of mmap_sem. When measuring page-fault speed, using more than 4 threads,
most of time is used for false sharing of mmap_sem and this counter's
scalability is not a problem. (So, my test program just use 2 threads.)

Considering trade-off, I'd like to start from "implement all under /mm"
imeplemnation. We can revisit and modify this after mmap_sem problem is
fixed.

If you recommend to drop this and just post 1,3,4,5. I'll do so.

> Or get rid of the mm_struct counters and only sum them up on the fly if
needed?
>
Get rid of mm_struct's counter is impossible because of get_user_pages(),
kswapd, vmscan etc...(now)

Then, we have 3 choices.
  1. leave atomic counter on mm_struct
  2. add pointer to some thread's counter in mm_struct.
  3. use percpu counter on mm_stuct.

With 2. , we'll have to take care of atomicity of updateing per-thread
counter...so, not choiced. With 3, using percpu counter, as you did, seems
attractive. But there are problem scalabilty in read-side and we'll
need some synchonization point for avoid level-down in read-side even
using percpu counter..

Considering memory foot print, the benefit of per-thread counter is
that we can put per-thread counter near to cache-line of task->mm
and we don't have to take care of extra cache-miss.
(if counter size is enough small.)


> Add a pointer to thread rss_stat structure to mm_struct and remove the
> counters? If the task has only one thread then the pointer points to the
> accurate data (most frequent case). Otherwise it can be NULL and then we
> calculate it on the fly?
>
get_user_pages(), vmscan, kvm etc...will touch other process's page table.

>> +static void add_mm_counter_fast(struct mm_struct *mm, int member, int
>> val)
>> +{
>> +	struct task_struct *task = current;
>> +
>> +	if (likely(task->mm == mm))
>> +		task->rss_stat.count[member] += val;
>> +	else
>> +		add_mm_counter(mm, member, val);
>> +}
>> +#define inc_mm_counter_fast(mm, member) add_mm_counter_fast(mm,
>> member,1)
>> +#define dec_mm_counter_fast(mm, member) add_mm_counter_fast(mm,
>> member,-1)
>> +
>
> Code will be much simpler if you always increment the task counts.
>
yes, I know and tried but failed. Maybe bigger patch will be required.

The result this patch shows is not very bad even if we have more chances.

Thanks,
-Kame


