Return-Path: <linux-kernel-owner+w=401wt.eu-S1030567AbXAZDU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030567AbXAZDU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 22:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030582AbXAZDU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 22:20:56 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43241 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030567AbXAZDUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 22:20:55 -0500
Date: Thu, 25 Jan 2007 19:20:44 -0800
From: Andrew Morton <akpm@osdl.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       dhowells@redhat.com
Subject: Re: [PATCH] Add a rounddown_pow_of_two() macro to log2.h.
Message-Id: <20070125192044.c9c2a093.akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0701250426400.7715@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0701250426400.7715@CPE00045a9c397f-CM001225dbafb6>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007 04:32:12 -0500 (EST)
"Robert P. J. Day" <rpjday@mindspring.com> wrote:

> 
>   In the same way that include/linux/log2.h defines the
> roundup_pow_of_two() macro, define the rounddown_pow_of_two() macro so
> peopls can stop re-implementing this operation using a loop.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
>   compile tested on x86 using "make allyesconfig", but there wasn't
> much chance of the build failing anyway since the patch only adds the
> macro definition, it doesn't change any existing code to use it.
> those patches will be submitted later, bit by bit.
> 
> diff --git a/include/linux/log2.h b/include/linux/log2.h
> index d02e1a5..6cf7081 100644
> --- a/include/linux/log2.h
> +++ b/include/linux/log2.h
> @@ -52,6 +63,15 @@ unsigned long __roundup_pow_of_two(unsigned long n)
>  	return 1UL << fls_long(n - 1);
>  }
> 
> +/*
> + * round down to nearest power of two
> + */
> +static inline __attribute__((const))
> +unsigned long __rounddown_pow_of_two(unsigned long n)
> +{
> +	return 1UL << (fls_long(n) - 1);
> +}

So __rounddown_pow_of_two(16) returns 8?

>  /**
>   * ilog2 - log of base 2 of 32-bit or a 64-bit unsigned value
>   * @n - parameter
> @@ -154,4 +174,20 @@ unsigned long __roundup_pow_of_two(unsigned long n)
>  	__roundup_pow_of_two(n)			\
>   )
> 
> +/**
> + * rounddown_pow_of_two - round the given value down to nearest power of two
> + * @n - parameter
> + *
> + * round the given value down to the nearest power of two
> + * - the result is undefined when n == 0
> + * - this can be used to initialise global variables from constant data
> + */
> +#define rounddown_pow_of_two(n)			\
> +(						\
> +	__builtin_constant_p(n) ? (		\
> +		(n == 1) ? 0 :			\
> +		(1UL << ilog2(n)) :		\
> +	__rounddown_pow_of_two(n)		\
> + )

But (1UL << ilog2(16)) returns 16?


And, afiact, your __rounddown_pow_of_two() is basically equivalent to (1UL
<< ilog2(n)) anyway.  So a suitable (and less buggy) implementation might be

static inline unsigned long rounddown_pow_of_two(unsigned long n)
{
	return (n == 1) ? 0 : (1UL << ilog2(n));
}

But I'm not sure.  Please create a userspace test harness to test this
patch.
