Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbYLCUqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbYLCUqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbYLCUq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 15:46:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57872 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYLCUq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 15:46:26 -0500
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, Mingming Cao <cmm@us.ibm.com>
In-Reply-To: <4936EB04.8000609@cosmosbay.com>
References: <4936D287.6090206@cosmosbay.com>
	 <4936EB04.8000609@cosmosbay.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 03 Dec 2008 21:45:46 +0100
Message-Id: <1228337146.24749.43.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 21:24 +0100, Eric Dumazet wrote:
> Eric Dumazet a écrit :
> > Hi Andrew
> > 
> > While working on percpu_counter on net-next-2.6, I found
> > a CPU unplug race in percpu_counter_destroy()
> > 
> > (Very unlikely of course)
> > 
> > Thank you
> > 
> > [PATCH] percpu_counter: fix CPU unplug race in percpu_counter_destroy()
> > 
> > We should first delete the counter from percpu_counters list
> > before freeing memory, or a percpu_counter_hotcpu_callback()
> > could dereference a NULL pointer.
> > 
> > Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> > ---
> > lib/percpu_counter.c |    4 ++--
> > 1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> 
> Well, this percpu_counter stuff is simply not working at all.
> 
> We added some percpu_counters to network tree for 2.6.29 and we get
> drift bugs if calling __percpu_counter_sum() while some heavy duty
> benches are running, on a 8 cpus machine
> 
> 1) __percpu_counter_sum() is buggy, it should not write
> on per_cpu_ptr(fbc->counters, cpu), or another cpu
> could get its changes lost.
> 
> __percpu_counter_sum should be read only (const struct percpu_counter *fbc),
> and no locking needed.
> 
> 
> 2) Un-needed lock in percpu_counter_set()
>    This wont block another cpu doing an _add anyway.
>    Not a bug, but disturbing, giving false feeling of protection.
>    percpu_counter are not precise, we cannot reliably set them
>    or read them. Period.
>    In fact percpu_counter_set() callers should use
>    percpu_counter_add(). (only used from lib/proportions.c )
> 
> 
> Thank you

Yeah, I see the race, and should have seen it much earlier. Thanks for
spotting it.

ext4 added this, and somehow relies on it (non of the other users
cares), mingming?

> [PATCH] percpu_counter: Fix __percpu_counter_sum()
> 
> This function should not write into percpu local storage,
> without proper locking, or some changes done on other cpus
> might be lost.
> 
> Adding proper locking would need to use atomic
> operations in fast path and would be expensive.
> 
> Results of __percpu_counter_sum() can be wrong, this is a
> known fact.
> 
> We also dont need to acquire the lock, this gives
> no better results.
> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
>  lib/percpu_counter.c |    5 -----
>  1 files changed, 5 deletions(-)
> plain text document attachment (__percpu_counter_sum.patch)
> diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
> index a866389..e79bbae 100644
> --- a/lib/percpu_counter.c
> +++ b/lib/percpu_counter.c
> @@ -57,16 +57,11 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
>  	s64 ret;
>  	int cpu;
>  
> -	spin_lock(&fbc->lock);
>  	ret = fbc->count;
>  	for_each_online_cpu(cpu) {
>  		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
>  		ret += *pcount;
> -		*pcount = 0;
>  	}
> -	fbc->count = ret;
> -
> -	spin_unlock(&fbc->lock);
>  	return ret;
>  }
>  EXPORT_SYMBOL(__percpu_counter_sum);

