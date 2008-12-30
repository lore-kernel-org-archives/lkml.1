Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751AbYL3XgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbYL3XgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 18:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYL3XgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 18:36:11 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:46075 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbYL3XgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 18:36:10 -0500
Message-ID: <495AB065.3080707@us.ibm.com>
Date: Tue, 30 Dec 2008 15:36:05 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
CC: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Rusty Russell <rusty@au1.ibm.com>
Subject: Re: [PATCH 2/2] futex: correct futex_requeue futex key ref counting
 in requeue loop
References: <20081229185238.10342.75651.stgit@Aeon> <20081229185402.10342.77396.stgit@Aeon>
In-Reply-To: <20081229185402.10342.77396.stgit@Aeon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Hart wrote:
> The requeue loop takes multiple references to key2, but the corresponding
> put loop decrements the refs for key1.  This patch corrects the accounting.
> 
> Build and boot tested on an x86_64 system.
> 
> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Rusty Russell <rusty@au1.ibm.com>
> ---
> 
>  kernel/futex.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index cf363ce..3b66d91 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -919,7 +919,7 @@ out_unlock:
> 
>  	/* drop_futex_key_refs() must be called outside the spinlocks. */
>  	while (--drop_count >= 0)
> -		drop_futex_key_refs(&key1);
> +		drop_futex_key_refs(&key2);
> 
>  	put_futex_key(fshared, &key2);
>  out_put_key1:
> 

Ugh, so I'm having second thoughts about this patch.  I believe what is 
happening here is that the requeue loop requeues each waiter from one 
futex (key1) to another (key2).  It rightly takes a reference to the 
futex at key2 and then decrements the references to key1 by drop_count 
(since the waiters now reference key2, not key1).  The newly taken key2 
references will be dropped in futex_wait() when each waiter is woken up 
and takes the futex.

I apologize for the confusion on this.  Thanks for suggesting I send 
this patch out independently from the rest Peter ;-)

If we can come to a consensus on this, I suggest pulling this patch from 
tip/core/futexes.


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
