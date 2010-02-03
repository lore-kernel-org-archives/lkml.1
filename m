Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab0BCNmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 08:42:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:26584 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757274Ab0BCNmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 08:42:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,397,1262592000"; 
   d="scan'208";a="592791554"
Date: Wed, 3 Feb 2010 21:39:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
	hweight_long(CONSTANT)
Message-ID: <20100203133951.GA24357@localhost>
References: <20100130094515.475881280@intel.com> <20100130094957.692671259@intel.com> <20100201124825.cc024f2a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201124825.cc024f2a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 01:48:25PM -0700, Andrew Morton wrote:
> > -static inline unsigned long hweight_long(unsigned long w)
> > -{
> > -	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
> > -}
> > +#define hweight_long(x)				\
> > +(						\
> > +	__builtin_constant_p(x) ?		\
> > +		__builtin_popcountl(x) :	\
> > +		(sizeof(x) <= 4 ?		\
> > +			 hweight32(x) :		\
> > +			 hweight64(x))		\
> > +)
> >  
> >  /**
> >   * rol32 - rotate a 32-bit value left
> 
> Peter's been mucking with a compile-time HWEIGHT().  An outdated
> version of that is presently in linux-next.

Ah I find it. Thanks.

> (I wonder if it could have used __builtin_popcount)
> 
> (I wonder which gcc versions support __builtin_popcount)

This is how Jamie Lokier first recommended it to me:

        Checked GCC 3.4.3 / 4.1 / 4.4: It expands as a compile-time
        constant if the argument is a compile-time constant, so can be
        used in BUILD_BUG_ON() and even for array sizes etc.

Is there an official lowest GCC version that Linux supports?

> Anyway, I suspect you should be using that rather than tweaking
> hweight_long().

OK.

But.. if ever the GCC builtins can be used:

        __builtin_popcount(unsigned int)
        __builtin_popcountl(unsigned long)
        __builtin_popcountll(unsigned long long)

it would be more natural to use hweight_long() or even introduce
hweight_longlong() for (transparent) compile time computation.

Thanks,
Fengguang
