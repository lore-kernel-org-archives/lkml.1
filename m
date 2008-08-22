Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbYHVBrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbYHVBrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 21:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbYHVBrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 21:47:47 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:21982 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752168AbYHVBrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 21:47:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MFgVNi5grjCtMB4b0r51pWfNgIdqPp0sYMcdeiNYF7iQ08AXb35oTsZgfhBDUbTT789RhxDMPiLJPLoSpHzuSuHPgmjfup0ozAeheBMCjDmiXDQV/hCTSFmY2DriEKNDPol+vrzod2gUWcUrQjZGbDio8ocMGo2elCruZuUGUhI=  ;
X-YMail-OSG: 8M1K26QVM1m7vkirDdd7fdZhrTlEno8frzmFGB1X1lX66ds5p1XhL0RW1lpO8dfjvWG19m_M1wxx.0HbPB9XLGPuOTEOb6gHBMQKxqLWLQ5Usv_9y8jwheG80XN381hqWh_iIvOY8G5RISgScWxFA1HR7SH.n5sEvG0-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/2] smp_call_function: don't use lock in call_function_data
Date: Fri, 22 Aug 2008 11:47:39 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
References: <48AE087C.4000408@goop.org>
In-Reply-To: <48AE087C.4000408@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808221147.39974.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 August 2008 10:29, Jeremy Fitzhardinge wrote:
> There's no need for a lock in call_function_data, since it's only used
> to decrement-and-test a counter.  Use an atomic instead.

Actually I wanted to convert the cpu_clear operation to be non-atomic,
and keep it under the lock. Thus the spinlock would save one atomic
operation. I simply forgot about this after Jens took over the patchset.

We could get rid of that WARN_ON branch in 2.6.28 I expect, unless we
see it trigger.

>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  kernel/smp.c |   17 ++++-------------
>  1 file changed, 4 insertions(+), 13 deletions(-)
>
> ===================================================================
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -10,6 +10,7 @@
>  #include <linux/rcupdate.h>
>  #include <linux/rculist.h>
>  #include <linux/smp.h>
> +#include <asm/atomic.h>
>
>  bool __read_mostly smp_single_ipi_queue = false;
>
> @@ -37,8 +38,7 @@
>
>  struct call_function_data {
>  	struct call_single_data csd;
> -	spinlock_t lock;
> -	unsigned int refs;
> +	atomic_t refs;
>  	cpumask_t cpumask;
>  	struct rcu_head rcu_head;
>  };
> @@ -125,21 +125,13 @@
>  	 */
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(data, &queue->list, csd.list) {
> -		int refs;
> -
>  		if (!cpu_isset(cpu, data->cpumask))
>  			continue;
>
>  		data->csd.func(data->csd.info);
>
> -		spin_lock(&data->lock);
>  		cpu_clear(cpu, data->cpumask);
> -		WARN_ON(data->refs == 0);
> -		data->refs--;
> -		refs = data->refs;
> -		spin_unlock(&data->lock);
> -
> -		if (refs)
> +		if (!atomic_dec_and_test(&data->refs))
>  			continue;
>
>  		spin_lock(&queue->lock);
> @@ -379,10 +371,9 @@
>  		slowpath = 1;
>  	}
>
> -	spin_lock_init(&data->lock);
>  	data->csd.func = func;
>  	data->csd.info = info;
> -	data->refs = num_cpus;
> +	atomic_set(&data->refs, num_cpus);
>  	data->cpumask = mask;
>
>  	spin_lock_irqsave(&queue->lock, flags);
