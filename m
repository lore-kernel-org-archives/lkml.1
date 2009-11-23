Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbZKWWTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbZKWWTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 17:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757414AbZKWWTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 17:19:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54928 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756953AbZKWWTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 17:19:31 -0500
Date: Mon, 23 Nov 2009 14:19:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 7/7] kfifo: add record handling functions
Message-Id: <20091123141914.e320c341.akpm@linux-foundation.org>
In-Reply-To: <1258705988.4426.22.camel@wall-e>
References: <1258704942.4426.5.camel@wall-e>
	<1258705988.4426.22.camel@wall-e>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 09:33:08 +0100
Stefani Seibold <stefani@seibold.net> wrote:

>  Add kfifo_in_rec() - puts some record data into the FIFO
>  Add kfifo_out_rec() - gets some record data from the FIFO
>  Add kfifo_from_user_rec() - puts some data from user space into the FIFO
>  Add kfifo_to_user_rec() - gets data from the FIFO and write it to user space
>  Add kfifo_peek_rec() - gets the size of the next FIFO record field
>  Add kfifo_skip_rec() - skip the next fifo out record
>  Add kfifo_avail_rec() - determinate the number of bytes available in a record FIFO
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> Acked-by: Andi Kleen <ak@linux.intel.com>
> ---
>  include/linux/kfifo.h |  328 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/kfifo.c        |  286 +++++++++++++++++++++++++++++--------------
>  2 files changed, 521 insertions(+), 93 deletions(-)
> 
> diff -u -N -r -p kfifo6/include/linux/kfifo.h kfifo7/include/linux/kfifo.h
> --- kfifo6/include/linux/kfifo.h	2009-11-19 20:54:56.275420767 +0100
> +++ kfifo7/include/linux/kfifo.h	2009-11-19 20:55:16.596339811 +0100
> @@ -275,4 +275,332 @@ static inline unsigned int __kfifo_off(s
>  	return off & (fifo->size - 1);
>  }
>  
> +/**
> + * __kfifo_peek_n internal helper function for determinate the length of
> + * the next record in the fifo
> + */
> +static inline unsigned int __kfifo_peek_n(struct kfifo *fifo,
> +				unsigned int recsize)
> +{
> +#define __KFIFO_GET(fifo, off, shift) \
> +	((fifo)->buffer[__kfifo_off((fifo), (fifo)->out+(off))] << (shift))
> +
> +	unsigned int l;
> +
> +	l = __KFIFO_GET(fifo, 0, 0);
> +
> +	if (--recsize)
> +		l |= __KFIFO_GET(fifo, 1, 8);
> +
> +	return l;
> +}
> +
> +/**
> + * __kfifo_poke_n internal helper function for storing the length of
> + * the next record into the fifo
> + */
> +static inline void __kfifo_poke_n(struct kfifo *fifo,
> +			unsigned int recsize, unsigned int n)
> +{
> +#define __KFIFO_PUT(fifo, off, val, shift) \
> +		( \
> +		(fifo)->buffer[__kfifo_off((fifo), (fifo)->in+(off))] = \
> +		(unsigned char)((val) >> (shift)) \
> +		)
> +
> +	__KFIFO_PUT(fifo, 0, n, 0);
> +
> +	if (--recsize)
> +		__KFIFO_PUT(fifo, 1, n, 8);
> +}

This will leave the __KFIFO_GET and __KFIFO_PUT macros defined in the
.c files which use this header file.  That's messy and undesired, to it
would be better to #undef these macros as early as possible.

but...

> +static inline unsigned int __kfifo_out_rec(struct kfifo *fifo,
> +	void *to, unsigned int n, unsigned int recsize,
> +	unsigned int *total)
> +{
> +	unsigned int l;
> +
> +	if (!recsize) {
> +		l = n;
> +		if (total)
> +			*total = l;
> +	} else {
> +		l = __kfifo_peek_n(fifo, recsize);
> +		if (total)
> +			*total = l;
> +		if (n < l)
> +			return l;
> +	}
> +
> +	return __kfifo_out_n(fifo, to, l, recsize);
> +}

The amount of inlining in this header is pretty wild.  These are large
functions!  Inlining them will create a large kernel and most likely a
slower one, due to the increased instruction cache footprint.

So please, let's see a "kfifo: uninline everything" patch?  

but...

> +/**
> + * kfifo_out_rec - gets some record data from the FIFO
> + * @fifo: the fifo to be used.
> + * @to: where the data must be copied.
> + * @n: the size of the destination buffer.
> + * @recsize: size of record field
> + * @total: pointer where the total number of to copied bytes should stored
> + *
> + * This function copies at most @n bytes from the FIFO to @to and returns the
> + * number of bytes which cannot be copied.
> + * A returned value greater than the @n value means that the record doesn't
> + * fit into the @to buffer.
> + *
> + * Note that with only one concurrent reader and one concurrent
> + * writer, you don't need extra locking to use these functions.
> + */
> +static inline __must_check unsigned int kfifo_out_rec(struct kfifo *fifo,
> +	void *to, unsigned int n, unsigned int recsize,
> +	unsigned int *total)
> +
> +{
> +	if (!__builtin_constant_p(recsize))
> +		return __kfifo_out_generic(fifo, to, n, recsize, total);
> +	return __kfifo_out_rec(fifo, to, n, recsize, total);
> +}

OK, so I see that some attention has been paid to the text footprint issue.

But how much, and was it successful?

