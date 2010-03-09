Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab0CIQc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:32:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:54612 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab0CIQcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:32:54 -0500
Subject: Re: [PATCH] x86: Add optimized popcnt variants
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
In-Reply-To: <20100309162352.GB2371@aftab>
References: <20100223175457.GA2401@aftab> <4B841BC3.1000908@zytor.com>
	 <20100223190614.GB2401@aftab> <4B875BBD.4060104@zytor.com>
	 <20100226074714.GA15310@aftab> <4B88097E.7010608@zytor.com>
	 <20100227082807.GA21706@aftab> <4B8979DA.9000201@zytor.com>
	 <20100309153628.GA2371@aftab> <1268149840.5037.3.camel@laptop>
	 <20100309162352.GB2371@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Mar 2010 17:32:49 +0100
Message-ID: <1268152369.5037.10.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 17:23 +0100, Borislav Petkov wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Tue, Mar 09, 2010 at 04:50:40PM +0100
> 
> > Should all be fine as it is, that patch
> > ( http://lkml.org/lkml/2010/2/4/119 ) is against a kernel with fce877e3
> > in, I've just checked and it still applies to tip/master as of this
> > writing (although it grew a single 2 line offset for 1 hunk).
> 
> Well, this way, I'm getting
> 
> ...
> In file included from include/linux/kernel.h:15,
>                  from /home/linux-2.6/arch/x86/include/asm/percpu.h:45,
>                  from /home/linux-2.6/arch/x86/include/asm/current.h:5,
>                  from /home/linux-2.6/arch/x86/include/asm/processor.h:15,
>                  from /home/linux-2.6/arch/x86/include/asm/atomic.h:6,
>                  from include/linux/crypto.h:20,
>                  from arch/x86/kernel/asm-offsets_64.c:8,
>                  from arch/x86/kernel/asm-offsets.c:4:
> include/linux/bitops.h:52:1: warning: "HWEIGHT8" redefined
> ...
> 
> due to the fact that we have multiple definitions of HWEIGHT*:
> 
> The one batch is in <include/linux/bitops.h> introduced by fce877e3.
> 
> The other is in <include/asm-generic/bitops/const_hweight.h> which
> is pulled in into <include/linux/bitops.h> through "#include
> <asm/bitops.h>", which, in turn, <includes asm/arch_hweight.h> and
> <include/asm-generic/bitops/const_hweight.h>.
> 
> The obvious resolution is to remove the HWEIGHT* batch from
> <include/asm-generic/bitops/const_hweight.h> since they're functionally
> identical with the ones in <include/linux/bitops.h>, no?

I thought the patch did that, see this hunk (straight from
http://lkml.org/lkml/2010/2/4/119 ):


---
Index: linux-2.6/include/linux/bitops.h
===================================================================
--- linux-2.6.orig/include/linux/bitops.h
+++ linux-2.6/include/linux/bitops.h
@@ -45,31 +45,6 @@ static inline unsigned long hweight_long
 	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
 }
 
-/*
- * Clearly slow versions of the hweightN() functions, their benefit is
- * of course compile time evaluation of constant arguments.
- */
-#define HWEIGHT8(w)					\
-      (	BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) +	\
-	(!!((w) & (1ULL << 0))) +			\
-	(!!((w) & (1ULL << 1))) +			\
-	(!!((w) & (1ULL << 2))) +			\
-	(!!((w) & (1ULL << 3))) +			\
-	(!!((w) & (1ULL << 4))) +			\
-	(!!((w) & (1ULL << 5))) +			\
-	(!!((w) & (1ULL << 6))) +			\
-	(!!((w) & (1ULL << 7)))	)
-
-#define HWEIGHT16(w) (HWEIGHT8(w)  + HWEIGHT8((w) >> 8))
-#define HWEIGHT32(w) (HWEIGHT16(w) + HWEIGHT16((w) >> 16))
-#define HWEIGHT64(w) (HWEIGHT32(w) + HWEIGHT32((w) >> 32))
-
-/*
- * Type invariant version that simply casts things to the
- * largest type.
- */
-#define HWEIGHT(w)   HWEIGHT64((u64)(w))
-
 /**
  * rol32 - rotate a 32-bit value left
  * @word: value to rotate

