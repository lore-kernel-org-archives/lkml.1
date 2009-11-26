Return-Path: <linux-kernel-owner+w=401wt.eu-S1760708AbZKZQHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708AbZKZQHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760700AbZKZQHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:07:31 -0500
Received: from www84.your-server.de ([213.133.104.84]:34670 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271AbZKZQH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:07:29 -0500
Subject: Re: [PATCH 7/7] kfifo: add record handling functions
From: Stefani Seibold <stefani@seibold.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <20091123141914.e320c341.akpm@linux-foundation.org>
References: <1258704942.4426.5.camel@wall-e>
	 <1258705988.4426.22.camel@wall-e>
	 <20091123141914.e320c341.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 26 Nov 2009 17:07:12 +0100
Message-ID: <1259251632.26705.17.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +static inline unsigned int __kfifo_out_rec(struct kfifo *fifo,
> > +	void *to, unsigned int n, unsigned int recsize,
> > +	unsigned int *total)
> > +{
> > +	unsigned int l;
> > +
> > +	if (!recsize) {
> > +		l = n;
> > +		if (total)
> > +			*total = l;
> > +	} else {
> > +		l = __kfifo_peek_n(fifo, recsize);
> > +		if (total)
> > +			*total = l;
> > +		if (n < l)
> > +			return l;
> > +	}
> > +
> > +	return __kfifo_out_n(fifo, to, l, recsize);
> > +}
> 
> The amount of inlining in this header is pretty wild.  These are large
> functions!  Inlining them will create a large kernel and most likely a
> slower one, due to the increased instruction cache footprint.
> 
> So please, let's see a "kfifo: uninline everything" patch?  
> 
> but...
> 
> > +/**
> > + * kfifo_out_rec - gets some record data from the FIFO
> > + * @fifo: the fifo to be used.
> > + * @to: where the data must be copied.
> > + * @n: the size of the destination buffer.
> > + * @recsize: size of record field
> > + * @total: pointer where the total number of to copied bytes should stored
> > + *
> > + * This function copies at most @n bytes from the FIFO to @to and returns the
> > + * number of bytes which cannot be copied.
> > + * A returned value greater than the @n value means that the record doesn't
> > + * fit into the @to buffer.
> > + *
> > + * Note that with only one concurrent reader and one concurrent
> > + * writer, you don't need extra locking to use these functions.
> > + */
> > +static inline __must_check unsigned int kfifo_out_rec(struct kfifo *fifo,
> > +	void *to, unsigned int n, unsigned int recsize,
> > +	unsigned int *total)
> > +
> > +{
> > +	if (!__builtin_constant_p(recsize))
> > +		return __kfifo_out_generic(fifo, to, n, recsize, total);
> > +	return __kfifo_out_rec(fifo, to, n, recsize, total);
> > +}
> 
> OK, so I see that some attention has been paid to the text footprint issue.
> 
> But how much, and was it successful?
> 

I analyzed the code and most of them will be optimized away by the
compiler. The reason for this design decision was that i want no
performance regression against the old kfifo implementation.

But if the majority vote for an non inline version i will do it. It will
make the code more readable and slim down the footprint.


