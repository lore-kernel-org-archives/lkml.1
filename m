Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbZCEILs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbZCEILs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 03:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbZCEILj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 03:11:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:46275 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbZCEILi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 03:11:38 -0500
Message-ID: <49AF891A.30200@kernel.org>
Date: Thu, 05 Mar 2009 17:11:06 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: percpu allocator vs reclaim
References: <1236184563.5330.8074.camel@laptop>	 <49AEAEF2.7040908@kernel.org> <1236185363.5330.8121.camel@laptop>
In-Reply-To: <1236185363.5330.8121.camel@laptop>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 08:11:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2009-03-05 at 01:40 +0900, Tejun Heo wrote:
>> Peter Zijlstra wrote:
>>> Hi Tejun,
>>>
>>> Thomas hit the below on recent -tip kernels.
>>>
>>> Which basically states that we could deadlock due to reclaim lock
>>> recursion.
>>>
>>> Looking at the code I don't see a quick solution, other than using
>>> GFP_NOFS, which is a bit of a bother (as I suspect it might easily grow
>>> __GFP_IO inversion too, if it doesn't already have it).
>> Ah... maybe percpu allocator should just swallow @gfp.  Any better
>> ideas? :-(
> 
> Could you somehow break that lock so that you get something like:
> 
>   alloc_lock
>     kmalloc(GFP_KERNEL)
>     free_lock
> 
> Where
> 
>  percpu_free()
>    lock(free_lock)
>      put area on free list
> 
>  percpu_alloc()
>    lock(free_list)
>      collect free list
>    kmalloc()
> 
> Then the free code can be used from reclaim, because there's never an
> allocation done while holding it, and the alloc path can first
> check/cleanup whatever mess the last free left behind before trying an
> allocation.

Yeap, I think I can do that.  Will work on it.

Thanks.

-- 
tejun
