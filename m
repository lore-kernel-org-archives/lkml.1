Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbYGMVvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbYGMVvV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 17:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbYGMVvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 17:51:09 -0400
Received: from khc.piap.pl ([195.187.100.11]:57379 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949AbYGMVvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 17:51:08 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [bisected] kernel panic 2.6.22 -> 2.6.26-rc9+
References: <m3d4lisk4i.fsf@maximus.localdomain>
	<20080713013107.23f060f2.akpm@linux-foundation.org>
	<m3abgmcb68.fsf@maximus.localdomain>
	<20080713112230.e86ba9ae.akpm@linux-foundation.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 13 Jul 2008 23:51:06 +0200
In-Reply-To: <20080713112230.e86ba9ae.akpm@linux-foundation.org> (Andrew Morton's message of "Sun\, 13 Jul 2008 11\:22\:30 -0700")
Message-ID: <m3lk05jvw5.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> --- a/include/asm-arm/bitops.h~a
> +++ a/include/asm-arm/bitops.h
> @@ -277,9 +277,16 @@ static inline int constant_fls(int x)
>   * the clz instruction for much better code efficiency.
>   */
>  
> -#define fls(x) \
> +#define __fls(x) \
>  	( __builtin_constant_p(x) ? constant_fls(x) : \
>  	  ({ int __r; asm("clz\t%0, %1" : "=r"(__r) : "r"(x) : "cc"); 32-__r; }) )
> +
> +/* Implement fls() in C so that 64-bit args are suitably truncated */
> +static inline int fls(int x)
> +{
> +	return __fls(x);
> +}
> +

Well, I like it more as it fixes all possible places instead of only
fls64().

But... can't we just move the #define body into the inline fls(x)?
Will there be other users of __fls(x)? It seems the
__builtin_constant_p(x) works for inline functions.

The above patch fixes the kernel panic, too.
-- 
Krzysztof Halasa
