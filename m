Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085AbXLIFn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbXLIFn5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 00:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750702AbXLIFnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 00:43:49 -0500
Received: from waste.org ([66.93.16.53]:48482 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbXLIFns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 00:43:48 -0500
Date: Sat, 8 Dec 2007 23:43:37 -0600
From: Matt Mackall <mpm@selenic.com>
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] random: make backtracking attacks harder
Message-ID: <20071209054337.GT19691@waste.org>
References: <2.753618428@selenic.com> <5.753618428@selenic.com> <20071209014550.GU17037@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071209014550.GU17037@thunk.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 08:45:50PM -0500, Theodore Tso wrote:
> On Sat, Dec 08, 2007 at 05:20:38PM -0600, Matt Mackall wrote:
> > random: make backtracking attacks harder
> > 
> > At each extraction, we change (poolbits / 16) + 32 bits in the pool,
> > or 96 bits in the case of the secondary pools. Thus, a brute-force
> > backtracking attack on the pool state is less difficult than breaking
> > the hash. In certain cases, this difficulty may be is reduced to 2^64
> > iterations.
> 
> OK, a backtracking attack assumes a fairly catastrophic case where the
> attacker has managed to compromise the internal pool state.  In Linux,
> if an attacker has this much access, in most scenarios the attacker
> probably has the ability to gain write access to kernel memory as
> well, at which point you have far worse problems.
> 
> The definition of a backtracking attack is when the attacker uses the
> current pool state to try to recover the last entropy extraction.  As
> you point out, at each extraction, 96 bits are changed in the pool.
> But at each extraction, only 80 bits are extracted.

Agreed.
 
> If you are trying to find the value of the 80 bits that were
> extracted, and you know the current state of the pool, yes, you can
> take the 96 bits that were changed after the last extraction, and try
> all possible 2**96 combinations of the bits; but you probably won't
> rule anything out, since after you iterate over all of the 2**96
> combinations, you'll probably be able to generate all of the 2**80
> possible output bits.  So you won't gain anything by trying to do a
> backtracking attack.  So I don't think there's anything to worry about
> here.

Two observations:

- 2**96 << 2**160 so our feedback is much weaker than our hash so we
  should improve it on general principle
- there's a way to improve this attack to 2**64 in some situations!

I presume you've seen this paper:

 http://eprint.iacr.org/2006/086.pdf

It was fairly obsolete at printing and makes a bunch of mistakes. But
they do observe that at certain points in our feedback, the first
512-bit block of the pool is not overwritten by the feedback and thus
32 bits of feedback can be immediately discovered. Then an attacker
can run 2**64 hashes to recover the remaining bits with excellent odds
of having a unique preimage. It can't usually be extended multiple
iterations because we move the add_ptr too much, so it's fairly weak
as a backtracking attack.

They precede this with a more general description of a 2**96 attack
which doesn't work for precisely the reason you describe (2**16
possible preimages for each output). But their 2**64 attack does seem
like it works (in the world of cryptanalysis, and not real hardware of
course!).

Simply feeding back all five words of our hash rather than three in
the secondary pools hardens this all right up. This patch also makes
everything in here much easier to read and analyze.

> What you describe in your comments:
> 
> > +	 * We mix the hash back into the pool to prevent backtracking
> > +	 * attacks (where the attacker knows the state of the pool
> > +	 * plus the current outputs, and attempts to find previous
> > +	 * ouputs), unless the hash function can be inverted. 

That part of the comment is not new, but I don't remember which of us
wrote it.. 

> > ...By
> > +	 * mixing at least a SHA1 worth of hash data back, we make
> > +	 * brute-forcing the feedback as hard as brute-forcing the
> > +	 * hash.
> >  	 */

That part is new and I think is accurate.

> Secondly, the fact that we use catastrophic reseeding means that even
> if the state was compromised, at some point in time, every so often
> when we do a "catastrophic reseed", this acts as a firewall to limit
> the damage caused by a internal state exposure, both in the past and
> the future.

Absolutely. Having some depth in the design is quite valuable. But
that doesn't mean we shouldn't shore up individual weaknesses when we
find them.

-- 
Mathematics is the supreme nostalgia of our time.
