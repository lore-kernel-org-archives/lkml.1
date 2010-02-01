Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab0BAUtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 15:49:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711Ab0BAUtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 15:49:14 -0500
Date: Mon, 1 Feb 2010 12:48:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       <linux-fsdevel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
Message-Id: <20100201124825.cc024f2a.akpm@linux-foundation.org>
In-Reply-To: <20100130094957.692671259@intel.com>
References: <20100130094515.475881280@intel.com>
	<20100130094957.692671259@intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jan 2010 17:45:17 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> This allows use of hweight_long() in BUILD_BUG_ON().
> Suggested by Jamie.
> 
> CC: Jamie Lokier <jamie@shareable.org>
> CC: Roland Dreier <rdreier@cisco.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  include/linux/bitops.h |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> --- linux-mm.orig/include/linux/bitops.h	2009-07-20 20:10:19.000000000 +0800
> +++ linux-mm/include/linux/bitops.h	2010-01-30 17:41:15.000000000 +0800
> @@ -40,10 +40,14 @@ static __inline__ int get_count_order(un
>  	return order;
>  }
>  
> -static inline unsigned long hweight_long(unsigned long w)
> -{
> -	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
> -}
> +#define hweight_long(x)				\
> +(						\
> +	__builtin_constant_p(x) ?		\
> +		__builtin_popcountl(x) :	\
> +		(sizeof(x) <= 4 ?		\
> +			 hweight32(x) :		\
> +			 hweight64(x))		\
> +)
>  
>  /**
>   * rol32 - rotate a 32-bit value left

Peter's been mucking with a compile-time HWEIGHT().  An outdated
version of that is presently in linux-next.

(I wonder if it could have used __builtin_popcount)

(I wonder which gcc versions support __builtin_popcount)

Anyway, I suspect you should be using that rather than tweaking
hweight_long().
