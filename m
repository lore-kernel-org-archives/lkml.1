Return-Path: <linux-kernel-owner+w=401wt.eu-S1751905AbXCTR6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbXCTR6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 13:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbXCTR6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 13:58:09 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59845 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbXCTR6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 13:58:08 -0400
Subject: Re: [PATCH] time : SMP friendly alignment of struct clocksource
From: john stultz <johnstul@us.ibm.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070320110936.1e445e6e.dada1@cosmosbay.com>
References: <20070320110936.1e445e6e.dada1@cosmosbay.com>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 10:58:02 -0700
Message-Id: <1174413482.17430.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 11:09 +0100, Eric Dumazet wrote:
> struct clocksource is a critical data structure.
> 
> Most of its fields are read only, some of them are heavily modified at each timer interrupt.
> 
> It makes sense to separate those fields and make sure they all share one cache line, or at least the minimum for machines with small cache lines.
> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>


Sounds fine to me. Can you actually observe a difference?

Acked-by: John Stultz <johnstul@us.ibm.com>



> --- linux-2.6.21-rc4-mm1/include/linux/clocksource.h
> +++ linux-2.6.21-rc4-mm1-ed/include/linux/clocksource.h
> @@ -49,25 +49,35 @@ struct clocksource;
>   * @flags:		flags describing special properties
>   * @vread:		vsyscall based read
>   * @cycle_interval:	Used internally by timekeeping core, please ignore.
>   * @xtime_interval:	Used internally by timekeeping core, please ignore.
>   */
>  struct clocksource {
> +	/*
> +	 * First part of structure is read mostly
> +	 */
>  	char *name;
>  	struct list_head list;
>  	int rating;
>  	cycle_t (*read)(void);
>  	cycle_t mask;
>  	u32 mult;
>  	u32 shift;
>  	unsigned long flags;
>  	cycle_t (*vread)(void);
> 
>  	/* timekeeping specific data, ignore */
> -	cycle_t cycle_last, cycle_interval;
> -	u64 xtime_nsec, xtime_interval;
> +	cycle_t cycle_interval;
> +	u64	xtime_interval;
> +	/*
> +	 * Second part is written at each timer interrupt
> +	 * Keep it in a different cache line to dirty no
> +	 * more than one cache line.
> +	 */
> +	cycle_t cycle_last ____cacheline_aligned_in_smp;
> +	u64 xtime_nsec;
>  	s64 error;
> 
>  #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
>  	/* Watchdog related data, used by the framework */
>  	struct list_head wd_list;
>  	cycle_t wd_last;

