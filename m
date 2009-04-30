Return-Path: <linux-kernel-owner+w=401wt.eu-S1757782AbZD3Mu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbZD3Mu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 08:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759427AbZD3MuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 08:50:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56652 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758195AbZD3MuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 08:50:14 -0400
Date: Thu, 30 Apr 2009 14:50:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nikanth Karthikesan <knikanth@novell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Detect and warn on atomic_inc/atomic_dec wrapping
	around
Message-ID: <20090430125004.GA20047@elte.hu>
References: <200904291221.40361.knikanth@novell.com> <200904301738.55301.knikanth@novell.com> <20090430122159.GB32751@elte.hu> <200904301756.42210.knikanth@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904301756.42210.knikanth@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nikanth Karthikesan <knikanth@novell.com> wrote:

> diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
> index 7abdaa9..edf5619 100644
> --- a/include/asm-generic/atomic.h
> +++ b/include/asm-generic/atomic.h
> @@ -4,15 +4,71 @@
>   * Copyright (C) 2005 Silicon Graphics, Inc.
>   *	Christoph Lameter
>   *
> - * Allows to provide arch independent atomic definitions without the need to
> - * edit all arch specific atomic.h files.
>   */
>  
> +#include <linux/kernel.h>
>  #include <asm/types.h>
> +#include <asm/bug.h>
> +
> +#ifdef CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP
> +
> +/**
> + * atomic_inc - increment atomic variable
> + * @v: pointer of type atomic_t
> + *
> + * Atomically increments @v by 1.
> + * Prints a warning if it wraps around.
> + */
> +static inline void atomic_inc(atomic_t *v)
> +{
> +	WARN_ON(atomic_add_unless(v, 1, INT_MAX) == 0);
> +}
> +
> +/**
> + * atomic_dec - decrement atomic variable
> + * @v: pointer of type atomic_t
> + *
> + * Atomically decrements @v by 1.
> + * Prints a warning if it wraps around.
> + */
> +static inline void atomic_dec(atomic_t *v)
> +{
> +	WARN_ON(atomic_add_unless(v, -1, INT_MIN) == 0);
> +}
> +
> +#else
> +
> +/**
> + * atomic_inc - increment atomic variable
> + * @v: pointer of type atomic_t
> + *
> + * Atomically increments @v by 1.
> + */
> +static inline void atomic_inc(atomic_t *v)
> +{
> +	raw_atomic_inc(v);
> +}
> +
> +/**
> + * atomic_dec - increment atomic variable
> + * @v: pointer of type atomic_t
> + *
> + * Atomically decrements @v by 1.
> + */
> +static inline void atomic_dec(atomic_t *v)
> +{
> +	raw_atomic_dec(v);
> +}
> +
> +#endif

Here i think it makes sense to have a single definition:

static inline void atomic_inc(atomic_t *v)
{
#ifdef CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP
	WARN_ON(atomic_add_unless(v, 1, INT_MAX) == 0);
#else
	raw_atomic_inc(v);
#endif
}

Or, better yet, i'd suggest to define an 'invalid value' range for 
atomic integer types - not restricted to the single value of 
INT_MAX, but in the range of: [ UINT_MAX/4 ... INT_MAX/4*3 ].

Then there could be a single, straightforward value check:

static inline void atomic_inc(atomic_t *v)
{
	debug_atomic_check_value(v);
	raw_atomic_inc(v);
}

Where debug_atomic_check_value() is just an atomic_read():

static inline void debug_atomic_check_value(atomic_t *v)
{
	WARN_ONCE(in_range(atomic_read(v), UINT_MAX/4, UINT_MAX/4*3),
		  KERN_ERR "atomic counter check failure!");
}

It's a constant check.

If are overflowing on such a massive rate, it doesnt matter how 
early or late we check the value.

Agreed?

	Ingo
