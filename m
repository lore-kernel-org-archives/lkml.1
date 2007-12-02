Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbXLCJvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbXLCJvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 04:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbXLCJvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 04:51:06 -0500
Received: from ozlabs.org ([203.10.76.45]:43930 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbXLCJvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 04:51:05 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 1/3] Percpu infrastructure to rebase the per cpu area to 0UL
Date: Sun, 2 Dec 2007 14:04:56 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andi Kleen <ak@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20071130064305.459255715@sgi.com> <20071130064359.604365398@sgi.com>
In-Reply-To: <20071130064359.604365398@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712021404.57263.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 November 2007 17:43:06 Christoph Lameter wrote:
> Support an option
>
> 	CONFIG_PERCPU_ZERO_BASED
>
> that makes offsets for per cpu variables start at zero.
>
> If a percpu area starts at zero then
>
> 1. We do not need RELOC_HIDE anymore

Hi Christoph,

    Why do you think this is true?  You're still doing arithmetic on variable 
addresses beyond the bound of the variable.

> 2. Indexes off the per cpu area for each processor are small
>
> 3. The percpu area "addresses" are offsets and we can then
>    have allocpercpu/cpu_alloc in the future also use these
>    offsets so that percpu functions can take any type of
>    percpu address if it is provided by a percpu variable
>    or a pointer obtained via allocpercpu/cpu_alloc.

This last point is orthogonal to offsetting at zero though...

> +#ifdef CONFIG_PERCPU_ZERO_BASED
> +extern char __per_cpu_load[];
> +extern char ____per_cpu_size[];
> +#define __per_cpu_size ((unsigned long)&____per_cpu_size)
> +#define __per_cpu_start ((char *)0)
> +#define __per_cpu_end ((char *)__per_cpu_size)
> +#else
>  extern char __per_cpu_start[], __per_cpu_end[];
> +#define __per_cpu_load __per_cpu_start
> +#define __per_cpu_size (__per_cpu_end - __per_cpu_start)
> +#endif

Hmm, can't you just define __per_cpu_start and __per_cpu_end in the linker 
script and fold this code back together again?

>  	for_each_possible_cpu(i) {
> -		start = (unsigned long) &__per_cpu_start + per_cpu_offset(i);
> -		end   = (unsigned long) &__per_cpu_start + PERCPU_ENOUGH_ROOM
> +		start = (unsigned long) __per_cpu_start + per_cpu_offset(i);
> +		end   = (unsigned long) __per_cpu_start + PERCPU_ENOUGH_ROOM
>  					+ per_cpu_offset(i);

I found the original clearer; why change it?

Cheers,
Rusty.
