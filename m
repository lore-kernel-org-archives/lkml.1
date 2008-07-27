Return-Path: <linux-kernel-owner+w=401wt.eu-S1759295AbYG0USy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295AbYG0USy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 16:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757840AbYG0USq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 16:18:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757740AbYG0USp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 16:18:45 -0400
Date: Sun, 27 Jul 2008 13:15:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [git pull] cpus4096 fixes
In-Reply-To: <20080727190601.GA764@elte.hu>
Message-ID: <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org>
References: <20080727190601.GA764@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 27 Jul 2008, Ingo Molnar wrote:
> 
> Please pull the latest cpus4096-fixes git tree from:

No. Not without explanations.

Quite frankly, this "fix" looks like a huge stinking pile of sh*t.

I can't follow that thread on lkml.org (horrible web interface with 
hard-to-follow threading), and I'm too lazy to bother to look in my lkml 
email archives, but whoever said

  "The simple version is just a static array of [NR_CPUS] cpumask_t's."

and then implemented this piece of shit is a complete and utter moron.

I'm sorry, but guys, I really expect people to have better taste than 
this, and also expect people to be able to _think_ better than this. 

Am I right, and all you want is NR_CPU constant bitmasks that have just a 
single big set in each (for that single CPU)?

And I further right, adn you are so STUPID that you cannot see that you 
can share all the zero words?

In other words, on a 64-bit architecture, you only ever need 64 of these 
arrays - with a different bit set in ONE SINGLE WORD (with enough zero 
words around it so that you can create any bitmask by just offsetting in 
that big array). And then you just put enough zeroes around it that you 
can point _every_single_cpumask_ to be one of those things.

So when you have 4k CPU's, instead of having 4k arrays (of 4k bits each, 
with one bit set in each array - 2MB memory total), you have exactly 64 
arrays instead, each 8k bits in size (64kB total). 

And then you just point cpumask(n) to the right position (which you can 
calculate dynamically). Once you have the right arrays, getting 
"cpumask(n)" ends up being something like

	static const cpumask_t *cpumask_of_cpu(int cpu)
	{
		/* Get the array with the right bit set */
		unsigned long *p = array[cpu % BITS_PER_LONG];

		/* Offset it so that it's in the right word */
		p += (NR_CPUS-n)/BITS_PER_LONG;

		/* Return it as a cpumask_t */
		return (cpumask_t) p;
	}

And once you're not being a total idiot about wasting memory that is just 
filled with a single bit in various different places, you don't need all 
those games to re-create the arrays in some dense format, because they're 
already going to be dense enough. If you compile a kernel for up to 4k 
CPU's, "wasting" that 64kB of memory is a non-issue (especially since by 
doing this "overlapping" trick you probbaly get better cache behaviour 
anyway).

Ok, so now that I've insulted you and your pets (they're ugly!), show me 
wrong, and then call me a d*ckhead. ("Linus - you're a d*ckhead, and you 
didn't understand the problem, so you're a _stupid_ d*ckhead. And my 
pet may be ugly, but yours _smells_ bad!").

Or say "Uh, yeah, we're morons, and here's the much better patch, and we 
won't do that again".

			Linus
