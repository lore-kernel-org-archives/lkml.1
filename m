Return-Path: <linux-kernel-owner+w=401wt.eu-S933303AbXCFTmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303AbXCFTmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 14:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933312AbXCFTmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 14:42:52 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:25924 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933303AbXCFTmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 14:42:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=K5f/skAKS7f9IIagPODAj6EQVzb9ghbrQq274GBLblNsIN0FcZuIyjR5mGtK/IV1vtuu8ImUcot2GkWm6tOhHdeuiec/NQSIYJvjqhri/mTU7Fcu7uVt0I9/1G8Mr4hTYDFNv9rNHvbWzKJT8/F2UwuXmLtXCsmtKsSLcq3tqEY=
Date: Tue, 6 Mar 2007 22:42:56 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@osdl.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, johannes@sipsolutions.net
Subject: Re: [PATCH] Fix get_order() [try #2]
Message-ID: <20070306194255.GA5524@martell.zuzino.mipt.ru>
References: <20070306183426.10768.51800.stgit@warthog.cambridge.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306183426.10768.51800.stgit@warthog.cambridge.redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 06:34:26PM +0000, David Howells wrote:
> Provide an ilog2_up() that rounds its result up (ilog2() rounds down).
>
> Fix get_order() to use ilog2_up() not ilog2() to get the correct rounding.
>
> Adjust the documentation surrounding ilog2() and co. to indicate what rounding
> they perform.
>
> Fix roundup_pow_of_two(1) to give 1, not 0.

> --- a/include/asm-generic/page.h
> +++ b/include/asm-generic/page.h
> @@ -17,11 +17,15 @@ static inline __attribute__((const))
>  int __get_order(unsigned long size, int page_shift)
>  {
>  #if BITS_PER_LONG == 32 && defined(ARCH_HAS_ILOG2_U32)

There is no such thing except on FRV, where it's redundant.

				      CONFIG_ARCH_HAS_ILOG2_U32
				      ^^^^^^

> -	int order = __ilog2_u32(size) - page_shift;
> -	return order >= 0 ? order : 0;
> +	if (size <= (1UL << page_shift))
> +		return 0;
> +	else
> +		return __ilog2_u32(size - 1) + 1 - page_shift;
>  #elif BITS_PER_LONG == 64 && defined(ARCH_HAS_ILOG2_U64)

ditto

> -	int order = __ilog2_u64(size) - page_shift;
> -	return order >= 0 ? order : 0;
> +	if (size <= (1UL << page_shift))
> +		return 0;
> +	else
> +		return __ilog2_u64(size - 1) + 1 - page_shift;
>  #else
>  	int order;

