Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbZL1K53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbZL1K53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbZL1K52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:57:28 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41275 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbZL1K52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:57:28 -0500
Message-ID: <50863609fb8263f3a0f9111a304a9dbc.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <1261996258.7135.67.camel@laptop>
References: <20091225105140.263180e8.kamezawa.hiroyu@jp.fujitsu.com>
    <1261915391.15854.31.camel@laptop>
    <20091228093606.9f2e666c.kamezawa.hiroyu@jp.fujitsu.com>
    <1261989047.7135.3.camel@laptop>
    <27db4d47e5a95e7a85942c0278892467.squirrel@webmail-b.css.fujitsu.com>
    <1261996258.7135.67.camel@laptop>
Date: Mon, 28 Dec 2009 19:57:25 +0900 (JST)
Subject: Re: [RFC PATCH] asynchronous page fault.
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2009-12-28 at 18:58 +0900, KAMEZAWA Hiroyuki wrote:
>> Peter Zijlstra wrote:
>> > On Mon, 2009-12-28 at 09:36 +0900, KAMEZAWA Hiroyuki wrote:
>> >>
>> >> > The idea is to let the RCU lock span whatever length you need the
>> vma
>> >> > for, the easy way is to simply use PREEMPT_RCU=y for now,
>> >>
>> >> I tried to remove his kind of reference count trick but I can't do
>> that
>> >> without synchronize_rcu() somewhere in unmap code. I don't like that
>> and
>> >> use this refcnt.
>> >
>> > Why, because otherwise we can access page tables for an already
>> unmapped
>> > vma? Yeah that is the interesting bit ;-)
>> >
>> Without that
>>   vma->a_ops->fault()
>> and
>>   vma->a_ops->unmap()
>> can be called at the same time. and vma->vm_file can be dropped while
>> vma->a_ops->fault() is called. etc...
>
> Right, so acquiring the PTE lock will either instantiate page tables for
> a non-existing vma, leaving you with an interesting mess to clean up, or
> you can also RCU free the page tables (in the same RCU domain as the
> vma) which will mostly[*] avoid that issue.
>
> [ To make live really really interesting you could even re-use the
>   page-tables and abort the RCU free when the region gets re-mapped
>   before the RCU callbacks happen, this will avoid a free/alloc cycle
>   for fast remapping workloads. ]
>
> Once you hold the PTE lock, you can validate the vma you looked up,
> since ->unmap() syncs against it. If at that time you find the
> speculative vma is dead, you fail and re-try the fault.
>
My previous one did similar but still used vma->refcnt. I'll consider again.

> [*] there still is the case of faulting on an address that didn't
> previously have page-tables hence the unmap page table scan will have
> skipped it -- my hacks simply leaked page tables here, but the idea was
> to acquire the mmap_sem for reading and cleanup properly.
>
Hmm, thank you for hints.

But this current version implementation has some reasons.
  - because pmd has some trobles because of quicklists..I don't wanted to
    touch free routine of them.
  - pmd can be removed asynchronously while page fault is going on.
  - I'd like to avoid modification to free_pte_range etc...

I feel pmd/page-table-lock is a hard to handle object than expected.

I'll consider some about per-thread approach or split vma approach
or scalable range lock or some synchronization without heavy atomic op.

Anyway, I think I show something can be done without mmap_sem modification.
See you next year.

Thanks,
-Kame

