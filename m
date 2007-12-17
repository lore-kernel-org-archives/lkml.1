Return-Path: <linux-kernel-owner+w=401wt.eu-S934752AbXLQDEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934752AbXLQDEa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 22:04:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760001AbXLQDEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 22:04:22 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39166 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758241AbXLQDEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 22:04:22 -0500
Date: Sun, 16 Dec 2007 19:04:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: div64: Rework 64-bit type safety checks in do_div().
Message-Id: <20071216190418.8acc64d1.akpm@linux-foundation.org>
In-Reply-To: <20071217014805.GA15156@linux-sh.org>
References: <20071217014805.GA15156@linux-sh.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 10:48:05 +0900 Paul Mundt <lethal@linux-sh.org> wrote:

> The current do_div() implementation has a bogus pointer compare to
> generate build warnings on mismatch on 32-bit, unfortunately this not
> only triggers for size mismatch, but also _any_ type mismatch, even on
> reasonable 64-bit values:
> 
> In file included from kernel/sched.c:869:
> kernel/sched_debug.c: In function 'nsec_high':
> kernel/sched_debug.c:38: warning: comparison of distinct pointer types lacks a cast
> kernel/sched_debug.c:41: warning: comparison of distinct pointer types lacks a cast
> kernel/sched_debug.c: In function 'nsec_low':
> kernel/sched_debug.c:51: warning: comparison of distinct pointer types lacks a cast
> ...
> 
> The options are to either 'fix' all callers of do_div() to make sure
> they're using a uint64_t explicitly, or to update do_div() to make sure
> that the value is 64-bits, regardless of specific type. Currently
> everything that uses the generic do_div() causes a warning when using one
> of 'u64', 'long long', etc. instead of 'uint64_t'.

u64 and uint64_t should be identical?

> Half-assed empirical testing indicates that the number of false positives
> far outweighs any benefits of this type of checking:
> 
> $ git grep uint64_t | wc -l
> 947
> $ git grep u64 | wc -l
> 13942
> 
> In short, screw uint64_t and its fan club.

I don't get it.  Are u64 and uint64_t different on any arch?

> diff --git a/include/asm-generic/div64.h b/include/asm-generic/div64.h
> index a4a4937..63e7768 100644
> --- a/include/asm-generic/div64.h
> +++ b/include/asm-generic/div64.h
> @@ -19,6 +19,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/compiler.h>
> +#include <linux/kernel.h>
>  
>  #if BITS_PER_LONG == 64
>  
> @@ -39,13 +40,11 @@ static inline uint64_t div64_64(uint64_t dividend, uint64_t divisor)
>  
>  extern uint32_t __div64_32(uint64_t *dividend, uint32_t divisor);
>  
> -/* The unnecessary pointer compare is there
> - * to check for type safety (n must be 64bit)
> - */
> +/* The BUILD_BUG_ON() is there to check for type safety (n must be 64bit) */
>  # define do_div(n,base) ({				\
>  	uint32_t __base = (base);			\
>  	uint32_t __rem;					\
> -	(void)(((typeof((n)) *)0) == ((uint64_t *)0));	\
> +	BUILD_BUG_ON(sizeof(n) != sizeof(uint64_t));	\
>  	if (likely(((n) >> 32) == 0)) {			\
>  		__rem = (uint32_t)(n) % __base;		\
>  		(n) = (uint32_t)(n) / __base;		\

The mismatch which I've seen triggering a lot is doing do_div() on an s64
when it expects a u64.

And I think that _is_ a bug, isn't it?  do_div(-10, 10) should return -1,
but as the implementation will convert -10 to <monstrously large +ve
number>, the return value will be wildly wrong?

I'm thinking that the problem here is that x86's do_div(s64, ...) doesn't
warn.  So people write wrong code and then the problems only crop up on
architectures which use asm-generic/div64.h, which does warn?

