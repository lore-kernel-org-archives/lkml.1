Return-Path: <linux-kernel-owner+w=401wt.eu-S1762169AbXLNUOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762169AbXLNUOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 15:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbXLNUNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 15:13:54 -0500
Received: from waste.org ([66.93.16.53]:36064 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbXLNUNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 15:13:53 -0500
Date: Fri, 14 Dec 2007 14:13:05 -0600
From: Matt Mackall <mpm@selenic.com>
To: John Reiser <jreiser@BitWagon.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
Message-ID: <20071214201305.GL19691@waste.org>
References: <4762DAB1.1020807@BitWagon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4762DAB1.1020807@BitWagon.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 11:34:09AM -0800, John Reiser wrote:
> xfer_secondary_pool() in drivers/char/random.c tells add_entropy_words()
> to use uninitialized tmp[] whenever bytes is not a multiple of 4.
> Besides being unfriendly to automated dynamic checkers, this is a
> potential leak of user data into the output stream.  When called from
> extract_entropy_user, then uninit tmp[] can capture leftover data
> from a previous copy_from_user().

Yes, we use uninitialized data. But it's not a leak in any useful
sense. To the extent the previous data is secret, this actually
improves our entropy.

It's getting folded into the random number pool, where it will be
impossible to recover it unless you already know what was in the
pool. And if you know what's in the pool, you've already broken into
the kernel.

But I'm sympathetic to making Valgrind happy.

> --- ./drivers/char/random.c.orig	2007-12-14 11:06:03.000000000 -0800
> +++ ./drivers/char/random.c	2007-12-14 11:06:57.000000000 -0800
> @@ -708,7 +708,19 @@
> 
>  		bytes=extract_entropy(r->pull, tmp, bytes,
>  				      random_read_wakeup_thresh / 8, rsvd);
> - 		add_entropy_words(r, tmp, (bytes + 3) / 4);
> +		/*
> +		 * 2007-12-13 (valgrind/memcheck) Do not use undefined bytes.
> +		 * Avoid info leak when called from extract_entropy_user:
> +		 * uninit tmp[] can have data from previous copy_from_user().
> +		 * Instead: fill last word using first bytes.
> +		 */
> +		{
> +			__u8 *src = (__u8 *)&tmp[0];
> +			__u8 *dst = bytes + src;
> +			for (; 0!=(3 & bytes); ++bytes)
> +				*dst++ = *src++;
> +		}

That's hideous. How about a memset instead:

       /* clear uninitialized bytes at the end to make valgrind happy */
       memset((char *)tmp + bytes, 0, -bytes & 3);

Also, don't bother putting dates or the like in comments. We've got a
version control system for that.

> +		add_entropy_words(r, tmp, bytes>>2);

And that change is broken..

>  		credit_entropy_store(r, bytes*8);

..because it makes this line wrong. We have to add precisely the
number of bytes returned by extract_entropy to keep the books
balanced.

-- 
Mathematics is the supreme nostalgia of our time.
