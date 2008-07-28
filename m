Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbYG1SlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbYG1SlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbYG1SlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:41:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753311AbYG1Sk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:40:59 -0400
Date: Mon, 28 Jul 2008 11:37:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [git pull] cpus4096 fixes
In-Reply-To: <alpine.LFD.1.10.0807281127150.3486@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807281135060.3486@nehalem.linux-foundation.org>
References: <20080727190601.GA764@elte.hu> <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org> <200807281042.12860.rusty@rustcorp.com.au> <488E06F0.4070404@sgi.com> <alpine.LFD.1.10.0807281127150.3486@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Jul 2008, Linus Torvalds wrote:
> 
> Here's a trivial setup, that is even tested. It's _small_ too.
> 
> 	/* cpu_bit_bitmap[0] is empty - so we can back into it */
> 	#define MASK_DECLARE_1(x) [x+1][0] = 1ul << (x)
> 	#define MASK_DECLARE_2(x) MASK_DECLARE_1(x), MASK_DECLARE_1(x+1)
> 	#define MASK_DECLARE_4(x) MASK_DECLARE_2(x), MASK_DECLARE_2(x+2)
> 	#define MASK_DECLARE_8(x) MASK_DECLARE_4(x), MASK_DECLARE_4(x+4)
> 
> 	static const unsigned long cpu_bit_bitmap[BITS_PER_LONG+1][BITS_TO_LONGS(NR_CPUS)] = {
> 		MASK_DECLARE_8(0), MASK_DECLARE_8(8),
> 		MASK_DECLARE_8(16), MASK_DECLARE_8(24),
> 	#if BITS_PER_LONG > 32
> 		MASK_DECLARE_8(32), MASK_DECLARE_8(40),
> 		MASK_DECLARE_8(48), MASK_DECLARE_8(56),
> 	#endif
> 	};
> 
> 	static inline const cpumask_t *get_cpu_mask(unsigned int nr)
> 	{
> 		const unsigned long *p = cpu_bit_bitmap[1 + nr % BITS_PER_LONG];
> 		p -= nr / BITS_PER_LONG;
> 		return (const cpumask_t *)p;
> 	}

Btw, Ingo, can we get this issue resolved asap, please?

I was planning on doing -rc1 today, but this kind of hangs over me. The 
above three lines of code (and more lines of macro initializers) obviously 
does need some more testing, but if you hook it into the other changes you 
already had, maybe we can get it done.

Hmm?

			Linus
