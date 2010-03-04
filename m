Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab0CDJbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 04:31:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54726 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755122Ab0CDJbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 04:31:37 -0500
Message-ID: <4B8F7DE7.1050705@cn.fujitsu.com>
Date: Thu, 04 Mar 2010 17:31:19 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Lee Schermerhorn <lee.schermerhorn@hp.com>,
       David Rientjes <rientjes@google.com>, Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 1/4] cpuset: fix the problem that cpuset_mem_spread_node()
 returns an offline node(was: Re: [regression] cpuset,mm: update tasks' mems_allowed
 in time (58568d2))
References: <4B8E3DAB.1090307@cn.fujitsu.com> <20100304032209.GM8653@laptop>
In-Reply-To: <20100304032209.GM8653@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2010-3-4 11:22, Nick Piggin wrote:
...
>> +	/* 
>> +	 * After current->mems_allowed is set to a new value, current will
>> +	 * allocate new pages for the migrating memory region. So we must
>> +	 * ensure that update of current->mems_allowed have been completed
>> +	 * by this moment.
>> +	 */
>> +	smp_wmb();
>>  	do_migrate_pages(mm, from, to, MPOL_MF_MOVE_ALL);
>>  
>>  	guarantee_online_mems(task_cs(tsk),&tsk->mems_allowed);
>> +
>> +	/* 
>> +	 * After doing migrate pages, current will allocate new pages for
>> +	 * itself not the other tasks. So we must ensure that update of
>> +	 * current->mems_allowed have been completed by this moment.
>> +	 */
>> +	smp_wmb();
> 
> The comments don't really make sense. A task always sees its own
> memory operations in program order. You keep saying *current* allocates
> pages so *current*->mems_allowed must be updated. This doesn't make
> sense. Do you mean to say tsk->?
> 
> Secondly, memory ordering operations do not ensure anything is
> completed. They only ensure ordering. So to make sense to use them,
> you generally need corresponding barriers in other code that can
> run concurrently.
> 
> So you need to comment what is being ordered (ie. at least 2 memory
> operations). And what other code might be running that requires this
> ordering.
> 
> You need to comment to all these sites and operations. Sprinkling of
> memory barriers just gets unmaintainable.

My thought is wrong.
I thought the kernel might call do_migrate_pages() before updating
->mems_allowed, so I used smp_wmb() to ensure this order.

In fact, this problem which I worried can't occur, so these smp_wmb()
is unnecessary.

Thanks!
Miao

