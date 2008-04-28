Return-Path: <linux-kernel-owner+w=401wt.eu-S934696AbYD1Ocb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934696AbYD1Ocb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933212AbYD1OcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:32:22 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:53647 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932432AbYD1OcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:32:22 -0400
Message-Id: <1209393140.17030.1250266603@webmail.messagingengine.com>
X-Sasl-Enc: VofDbZR2CVUTHWdTZbpBWwPmdse847IRl+wnivVSqW9e 1209393140
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Harvey Harrison" <harvey.harrison@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1209327591.14173.74.camel@brick>
Subject: Re: [PATCH] bitops: simplify generic bit finding functions
In-Reply-To: <1209327591.14173.74.camel@brick>
Date: Mon, 28 Apr 2008 16:32:20 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ingo just pointed me to this thread.

On Sun, 27 Apr 2008 13:19:51 -0700, "Harvey Harrison"
<harvey.harrison@gmail.com> said:
> No need for a sentinal if we explicitly catch the no bits/all bits set
> cases, make it clear they are special cases returning size/BITS_PER_LONG.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  include/linux/bitops.h |   93
>  ++++++++++++++++++++----------------------------
>  1 files changed, 39 insertions(+), 54 deletions(-)
> 
> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> index 48bde60..d9eb58a 100644
> --- a/include/linux/bitops.h
> +++ b/include/linux/bitops.h
> @@ -127,18 +127,17 @@ extern unsigned long __find_first_bit(const
> unsigned long *addr,
>  static __always_inline unsigned long
>  find_first_bit(const unsigned long *addr, unsigned long size)
>  {
> -	/* Avoid a function call if the bitmap size is a constant */
> -	/* and not bigger than BITS_PER_LONG. */
> -
> -	/* insert a sentinel so that __ffs returns size if there */
> -	/* are no set bits in the bitmap */
> -	if (__builtin_constant_p(size) && (size < BITS_PER_LONG))
> -		return __ffs((*addr) | (1ul << size));
> -
> -	/* the result of __ffs(0) is undefined, so it needs to be */
> -	/* handled separately */
> -	if (__builtin_constant_p(size) && (size == BITS_PER_LONG))
> -		return ((*addr) == 0) ? BITS_PER_LONG : __ffs(*addr);
> +	/*
> +	 * Avoid a function call if the bitmap size is a constant and not
> +	 * bigger than BITS_PER_LONG.  Ensure we return size if there are
> +	 * no set bits.
> +	 */
> +	if (__builtin_constant_p(size) && (size <= BITS_PER_LONG)) {
> +		if (*addr == 0)
> +			return (size < BITS_PER_LONG) ? size : BITS_PER_LONG;
> +		else
> +			return __ffs(*addr);
> +	}

Ehm... assume size=16 and *addr=0x80000000
    then __ffs(*addr) = 31. Not 16.

>  	/* size is not constant or too big */
>  	return __find_first_bit(addr, size);
> @@ -157,20 +156,17 @@ extern unsigned long __find_first_zero_bit(const
> unsigned long *addr,
>  static __always_inline unsigned long
>  find_first_zero_bit(const unsigned long *addr, unsigned long size)
>  {
> -	/* Avoid a function call if the bitmap size is a constant */
> -	/* and not bigger than BITS_PER_LONG. */
> -
> -	/* insert a sentinel so that __ffs returns size if there */
> -	/* are no set bits in the bitmap */
> -	if (__builtin_constant_p(size) && (size < BITS_PER_LONG)) {
> -		return __ffs(~(*addr) | (1ul << size));
> +	/*
> +	 * Avoid a function call if the bitmap size is a constant and not
> +	 * bigger than BITS_PER_LONG.  Ensure we return size if all bits set.
> +	 */
> +	if (__builtin_constant_p(size) && (size <= BITS_PER_LONG)) {
> +		if ((~(*addr)) == 0)
> +			return (size < BITS_PER_LONG) ? size : BITS_PER_LONG;
> +		else
> +			return __ffs(~(*addr));
>  	}
>  
> -	/* the result of __ffs(0) is undefined, so it needs to be */
> -	/* handled separately */
> -	if (__builtin_constant_p(size) && (size == BITS_PER_LONG))
> -		return (~(*addr) == 0) ? BITS_PER_LONG : __ffs(~(*addr));
> -
>  	/* size is not constant or too big */
>  	return __find_first_zero_bit(addr, size);
>  }
> @@ -192,22 +188,17 @@ find_next_bit(const unsigned long *addr, unsigned
> long size,
>  {
>  	unsigned long value;
>  
> -	/* Avoid a function call if the bitmap size is a constant */
> -	/* and not bigger than BITS_PER_LONG. */
> -
> -	/* insert a sentinel so that __ffs returns size if there */
> -	/* are no set bits in the bitmap */
> -	if (__builtin_constant_p(size) && (size < BITS_PER_LONG)) {
> +	/*
> +	 * Avoid a function call if the bitmap size is a constant and not
> +	 * bigger than BITS_PER_LONG.  Ensure we return size if there are
> +	 * no set bits.
> +	 */
> +	if (__builtin_constant_p(size) && (size <= BITS_PER_LONG)) {
>  		value = (*addr) & ((~0ul) << offset);
> -		value |= (1ul << size);
> -		return __ffs(value);
> -	}
> -
> -	/* the result of __ffs(0) is undefined, so it needs to be */
> -	/* handled separately */
> -	if (__builtin_constant_p(size) && (size == BITS_PER_LONG)) {
> -		value = (*addr) & ((~0ul) << offset);
> -		return (value == 0) ? BITS_PER_LONG : __ffs(value);
> +		if (value == 0)
> +			return (size < BITS_PER_LONG) ? size : BITS_PER_LONG;
> +		else
> +			return __ffs(value);
>  	}
>  
>  	/* size is not constant or too big */
> @@ -229,22 +220,16 @@ find_next_zero_bit(const unsigned long *addr,
> unsigned long size,
>  {
>  	unsigned long value;
>  
> -	/* Avoid a function call if the bitmap size is a constant */
> -	/* and not bigger than BITS_PER_LONG. */
> -
> -	/* insert a sentinel so that __ffs returns size if there */
> -	/* are no set bits in the bitmap */
> -	if (__builtin_constant_p(size) && (size < BITS_PER_LONG)) {
> -		value = (~(*addr)) & ((~0ul) << offset);
> -		value |= (1ul << size);
> -		return __ffs(value);
> -	}
> -
> -	/* the result of __ffs(0) is undefined, so it needs to be */
> -	/* handled separately */
> -	if (__builtin_constant_p(size) && (size == BITS_PER_LONG)) {
> +	/*
> +	 * Avoid a function call if the bitmap size is a constant and not
> +	 * bigger than BITS_PER_LONG.  Ensure we return size if all bits set.
> +	 */
> +	if (__builtin_constant_p(size) && (size <= BITS_PER_LONG)) {
>  		value = (~(*addr)) & ((~0ul) << offset);
> -		return (value == 0) ? BITS_PER_LONG : __ffs(value);
> +		if (value == 0)
> +			return (size < BITS_PER_LONG) ? size : BITS_PER_LONG;
> +		else
> +			return __ffs(value);
>  	}
>  
>  	/* size is not constant or too big */
> -- 
> 1.5.5.1.270.g89765
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - mmm... Fastmail...

