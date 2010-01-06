Return-Path: <linux-kernel-owner+w=401wt.eu-S932751Ab0AFUdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab0AFUdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 15:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932571Ab0AFUdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 15:33:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932463Ab0AFUdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 15:33:15 -0500
Date: Wed, 6 Jan 2010 12:33:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, Bart Van Assche <bart.vanassche@gmail.com>,
       David Dillow <dave@thedillows.org>
Subject: Re: [PATCH] log2.h: Macro-ize is_power_of_2() for use in
 BUILD_BUG_ON
Message-Id: <20100106123306.ac85e557.akpm@linux-foundation.org>
In-Reply-To: <ada3a2jugqu.fsf@roland-alpha.cisco.com>
References: <ada3a2jugqu.fsf@roland-alpha.cisco.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jan 2010 12:21:13 -0800
Roland Dreier <rdreier@cisco.com> wrote:

> When code relies on a constant being a power of 2:
> 
> 	#define FOO	512	/* must be a power of 2 */
> 
> it would be nice to be able to do:
> 
> 	BUILD_BUG_ON(!is_power_of_2(FOO));
> 
> However applying an inline function does not result in a compile-time
> constant that can be used with BUILD_BUG_ON(), so trying that gives
> results in:
> 
> 	error: bit-field '<anonymous>' width not an integer constant
> 
> We can fix this by changing is_power_of_2() to a macro; we leave the
> inline function for the non-constant case, to avoid evaluating the
> parameter more than once.  (gcc does not accept a multi-statement
> expression like "({ unsigned long __n = n; ... })" as a compile-time
> constant so that solution doesn't work)
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> ---
> This is somewhat of an RFC -- I'm a bit undecided whether it's really
> worth making this change.  It's prompted by
> http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg01941.html and
> http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg01950.html
> which do ugly things to work around is_power_of_2 not being usable in
> BUILD_BUG_ON().
> 
> On the other hand maybe just
> 
> /* FOO must be a power of 2 */
> #define FOO_SHIFT 9
> #define FOO (1 << FOO_SHIFT)
> 
> is good enough.
> 
>  include/linux/log2.h |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/log2.h b/include/linux/log2.h
> index 25b8086..248f69c 100644
> --- a/include/linux/log2.h
> +++ b/include/linux/log2.h
> @@ -49,11 +49,18 @@ int __ilog2_u64(u64 n)
>   */
>  
>  static inline __attribute__((const))
> -bool is_power_of_2(unsigned long n)
> +bool __is_power_of_2(unsigned long n)
>  {
>  	return (n != 0 && ((n & (n - 1)) == 0));
>  }
>  
> +#define is_power_of_2(n)					\
> +(								\
> +	__builtin_constant_p(n) ?				\
> +		(((n) != 0) && (((n) & ((n) - 1)) == 0)) :	\
> +		__is_power_of_2(n)				\
> +)
> +

We've had recurring struggles with various versions of gcc screwing up
constructs of this form and trying to emit the non-constant code when
the arg was clearly a compile-time constant.  One episode which comes
to mind was when we made changes to kmalloc().

Of course, that might not bite us in this case - it would need a lot of
coverage testing to find out.


Perhaps we can avoid worrying about that via

#define BUILD_BUG_ON_NOT_POWER_OF_2(n)	\
	BUILD_BUG_ON((n != 0 && ((n & (n - 1)) == 0)))

?
