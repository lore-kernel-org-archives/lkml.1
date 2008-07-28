Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbYG1Sg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbYG1Sg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbYG1Sgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:36:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754083AbYG1Sgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:36:48 -0400
Date: Mon, 28 Jul 2008 11:32:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [git pull] cpus4096 fixes
In-Reply-To: <488E06F0.4070404@sgi.com>
Message-ID: <alpine.LFD.1.10.0807281127150.3486@nehalem.linux-foundation.org>
References: <20080727190601.GA764@elte.hu> <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org> <200807281042.12860.rusty@rustcorp.com.au> <488E06F0.4070404@sgi.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Jul 2008, Mike Travis wrote:
> 
> Sorry, I didn't know that was the protocol.  And yes, the clever idea of
> compacting the memory is a good one (wish I would have thought of it... ;-)
> But, and it's a big but, if you really have 4096 cpus present (not NR_CPUS,
> but nr_cpu_ids), then 2MB is pretty much chump change.

Umm. Yes, it's chump change, but if you compile a kernel to be generic, 
and you actually only have a few CPU's, it's no longer chump change.

> But I'll redo the patch again.

Here's a trivial setup, that is even tested. It's _small_ too.

	/* cpu_bit_bitmap[0] is empty - so we can back into it */
	#define MASK_DECLARE_1(x) [x+1][0] = 1ul << (x)
	#define MASK_DECLARE_2(x) MASK_DECLARE_1(x), MASK_DECLARE_1(x+1)
	#define MASK_DECLARE_4(x) MASK_DECLARE_2(x), MASK_DECLARE_2(x+2)
	#define MASK_DECLARE_8(x) MASK_DECLARE_4(x), MASK_DECLARE_4(x+4)

	static const unsigned long cpu_bit_bitmap[BITS_PER_LONG+1][BITS_TO_LONGS(NR_CPUS)] = {
		MASK_DECLARE_8(0), MASK_DECLARE_8(8),
		MASK_DECLARE_8(16), MASK_DECLARE_8(24),
	#if BITS_PER_LONG > 32
		MASK_DECLARE_8(32), MASK_DECLARE_8(40),
		MASK_DECLARE_8(48), MASK_DECLARE_8(56),
	#endif
	};

	static inline const cpumask_t *get_cpu_mask(unsigned int nr)
	{
		const unsigned long *p = cpu_bit_bitmap[1 + nr % BITS_PER_LONG];
		p -= nr / BITS_PER_LONG;
		return (const cpumask_t *)p;
	}

that should be all you need to do.

Honesty in advertizing: my "testing" was some trivial user-space harness, 
maybe I had some bug in it. But at least it's not _horribly_ wrong.

And yes, this has the added optimization from Viro of overlapping the 
cpumask_t's internally too, rather than making them twice the size. So 
with 4096 CPU's, this should result 32.5kB of static const data.

			Linus
