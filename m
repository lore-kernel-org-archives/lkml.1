Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbYH2UWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbYH2UWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 16:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbYH2UWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 16:22:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816AbYH2UWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 16:22:21 -0400
Date: Fri, 29 Aug 2008 13:22:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jan Beulich" <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BUILD_BUG_ON() should not use array type
Message-Id: <20080829132211.d0ed1932.akpm@linux-foundation.org>
In-Reply-To: <48B7FDBA.76E4.0078.0@novell.com>
References: <48B7FDBA.76E4.0078.0@novell.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 12:46:34 +0100
"Jan Beulich" <jbeulich@novell.com> wrote:

> With gcc's extension of variable size arrays, using the size of an
> array type for BUILD_BUG_ON() doesn't always work, since non-constant
> conditions aren't being detected, and hence the intention of the
> construct cannot be met anymore. It is therefore necessary to use a
> construct where all compilers can be expected to only accept constant
> expressions with certain values being invalid, and the only thing I
> could think of are bit-fields.
> 
> Note that in the virtio_config.h case MAYBE_BUILD_BUG_ON() really just
> serves documentation purposes - even if the expression is compile time
> constant (__builtin_constant_p() yields true), the array is still deemed
> of variable length by gcc, and hence the whole expression doesn#t have
> the intended effect.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  drivers/net/niu.c             |    2 +-
>  include/linux/kernel.h        |    8 ++++++--
>  include/linux/virtio_config.h |    3 +--
>  3 files changed, 8 insertions(+), 5 deletions(-)
> 
> --- linux-2.6.27-rc5/drivers/net/niu.c	2008-08-21 14:37:31.000000000 +0200
> +++ 2.6.27-rc5-build-bug-on/drivers/net/niu.c	2008-08-28 16:51:40.000000000 +0200
> @@ -5144,7 +5144,7 @@ static void niu_init_tx_mac(struct niu *
>  	/* The XMAC_MIN register only accepts values for TX min which
>  	 * have the low 3 bits cleared.
>  	 */
> -	BUILD_BUG_ON(min & 0x7);
> +	BUG_ON(min & 0x7);
>  
>  	if (np->flags & NIU_FLAGS_XMAC)
>  		niu_init_tx_xmac(np, min, max);
> --- linux-2.6.27-rc5/include/linux/kernel.h	2008-08-21 14:37:35.000000000 +0200
> +++ 2.6.27-rc5-build-bug-on/include/linux/kernel.h	2008-08-28 15:10:28.000000000 +0200
> @@ -468,13 +468,17 @@ struct sysinfo {
>  };
>  
>  /* Force a compilation error if condition is true */
> -#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
> +#define BUILD_BUG_ON(condition) ((void)BUILD_BUG_ON_ZERO(condition))
> +
> +/* Force a compilation error if condition is constant and true */
> +#define MAYBE_BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2 * !!(cond)]))

MAYBE_BUILD_BUG_ON() hurts my brain.  It's doing:

	if (__builtin_constant_p(expr))
		BUILD_BUG_ON(expr);

yes?  For inlined (or macro) callsites which can be used with constant
or non-constant args.

It's tempting to just zap the one callsite and not add this at all, but
I suppose that it's a legitimate thing to want to do, and that other
users of it may well turn up.  Many of them are probably just using run-time
BUG_ON(), which is sensible, but less efficient.

However it would benefit from a clearer description and perhaps a
better name.  BUILD_BUG_ON_IF_CONSTANT?


>  /* Force a compilation error if condition is true, but also produce a
>     result (of value 0 and type size_t), so the expression can be used
>     e.g. in a structure initializer (or where-ever else comma expressions
>     aren't permitted). */
> -#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
> +#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
> +#define BUILD_BUG_ON_NULL(e) ((void *)BUILD_BUG_ON_ZERO(e))

What does BUILD_BUG_ON_NULL() do and why did you add it?  It has no
callers.

>  /* Trap pasters of __FUNCTION__ at compile-time */
>  #define __FUNCTION__ (__func__)
> --- linux-2.6.27-rc5/include/linux/virtio_config.h	2008-08-21 14:37:35.000000000 +0200
> +++ 2.6.27-rc5-build-bug-on/include/linux/virtio_config.h	2008-08-28 15:08:47.000000000 +0200
> @@ -96,8 +96,7 @@ static inline bool virtio_has_feature(co
>  				      unsigned int fbit)
>  {
>  	/* Did you forget to fix assumptions on max features? */
> -	if (__builtin_constant_p(fbit))
> -		BUILD_BUG_ON(fbit >= 32);
> +	MAYBE_BUILD_BUG_ON(fbit >= 32);
>  
>  	virtio_check_driver_offered_feature(vdev, fbit);
>  	return test_bit(fbit, vdev->features);
> 
> 
> 
