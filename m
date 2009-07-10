Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbZGJTHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbZGJTHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 15:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbZGJTHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 15:07:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752222AbZGJTHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 15:07:24 -0400
Date: Fri, 10 Jul 2009 12:06:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [GIT PULL] core kernel fixes
In-Reply-To: <20090710162848.GA26862@elte.hu>
Message-ID: <alpine.LFD.2.01.0907101206120.3352@localhost.localdomain>
References: <20090710162848.GA26862@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 10 Jul 2009, Ingo Molnar wrote:
> 
> Joerg Roedel (1):
>       dma-debug: fix off-by-one error in overlap function
>
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index 3b93129..c9187fe 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -862,7 +862,7 @@ static inline bool overlap(void *addr, u64 size, void *start, void *end)
>  
>  	return ((addr >= start && addr < end) ||
>  		(addr2 >= start && addr2 < end) ||
> -		((addr < start) && (addr2 >= end)));
> +		((addr < start) && (addr2 > end)));
>  }
>  
>  static void check_for_illegal_area(struct device *dev, void *addr, u64 size)

The above seems like total shit.

If (addr < start && addr2 == end) then the two areas very much overlap.

What am I missing (apart from the fact that all those variables are 
horribly badly named)?

Also, the tests make no sense. That's not how you are supposed to check 
for overlap to begin with.

Isn't it easier to test for _not_ overlapping?

	/* range1 is fully before range2 */
	(end1 <= start2 || 
	/* range1 is fully after range2 */
	start1 >= end2)

possibly together with checking for overflow in the size addition? But I 
didn't think that through, so maybe I'm doing something stupid.

Finally, why is 'size' a u64? It will overflow anyway if it's bigger than 
a pointer, so it should be just 'unsigned long'. Or it should all be done 
in u64 if people care. Or we should care about overflow (which cannot be 
done with pointers).

Also, comparing pointers is unsafe to begin with. It's not clear if they 
are signed or unsigned comparisons, and gcc has historically had bugs here 
(only unsigned comparisons make sense for pointers, but _technically_ a 
crazy compiler person could argue that at least in some environments any 
valid pointers to the same object - which is the only thing C defines - 
must not cross the sign barrier, so they use a buggy signed compare).

IOW, I think this whole function is just total crap, apparently put 
together by randomly assembling characters until it compiles. Somebody 
should put more effort into looking at it, but I think it should be 
something like

	static inline int overlap(void *addr, unsigned long len, void *start, void *end)
	{
		unsigned long a1 = (unsigned long) addr;
		unsigned long b1 = a1 + len;
		unsigned long a2 = (unsigned long) start;
		unsigned long b2 = (unsigned long) end;

	#ifdef WE_CARE_DEEPLY
		/* Overflow? */
		if (b1 < a1)
			return 1;
	#ifdef AND_ARE_ANAL
		if (b2 < a2)
			return 1;
	#endif
	#endif
		return !(b1 <= a2 || a1 >= b2);
	}

but I really migth have done soemthing wrong there. It's a simple 
function, but somebody needs to double-check that I haven't made it worse.

		Linus
