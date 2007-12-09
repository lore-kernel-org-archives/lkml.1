Return-Path: <linux-kernel-owner+w=401wt.eu-S1752105AbXLIRFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbXLIRFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 12:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbXLIRFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 12:05:48 -0500
Received: from waste.org ([66.93.16.53]:46209 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbXLIRFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 12:05:47 -0500
Date: Sun, 9 Dec 2007 11:05:20 -0600
From: Matt Mackall <mpm@selenic.com>
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] random: make backtracking attacks harder
Message-ID: <20071209170520.GY19691@waste.org>
References: <2.753618428@selenic.com> <5.753618428@selenic.com> <20071209014550.GU17037@thunk.org> <20071209054337.GT19691@waste.org> <20071209133300.GB17037@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071209133300.GB17037@thunk.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2007 at 08:33:00AM -0500, Theodore Tso wrote:
> On Sat, Dec 08, 2007 at 11:43:37PM -0600, Matt Mackall wrote:
> > > If you are trying to find the value of the 80 bits that were
> > > extracted, and you know the current state of the pool, yes, you can
> > > take the 96 bits that were changed after the last extraction, and try
> > > all possible 2**96 combinations of the bits; but you probably won't
> > > rule anything out, since after you iterate over all of the 2**96
> > > combinations, you'll probably be able to generate all of the 2**80
> > > possible output bits.  So you won't gain anything by trying to do a
> > > backtracking attack.  So I don't think there's anything to worry about
> > > here.
> > 
> > Two observations:
> > 
> > - 2**96 << 2**160 so our feedback is much weaker than our hash so we
> >   should improve it on general principle
> 
> Well, no.  You're comparing apples and oranges here.  You can iterate
> over 2**96 choices, but given that even if you are doing an iterative
> guessing attack, you have 2**80 knowns, and 2**96 unknowns, it doesn't
> buy you anything.  So saying that there is a successful attack with
> O(2**96) simply isn't true!

Again, I agree that there's not any sort of useful attack here.

> > - there's a way to improve this attack to 2**64 in some situations!
> 
> Yeah, but again, what does this "attack" buy you?  If you know the
> output, and the current state of the pool, after doing 2**64
> iterations you can get the state of the pool before the output.
> Big-di-whoopdie-do.  You can't actually *do* anything with it.  

Ahh, but this an attack on the output! You know only:

 pool' (including a fortuitously placed add_ptr)

and from that, you can get all but 64 bits of pool. By 2**64 iterations of:

 pool = pool' + guess
 hash = SHA1(init, pool) # simplified
 pool^ = add(pool, hash)
 if pool^ = pool':
  success!

Now you've recovered pool. Then you can recover the *output* with:

 hash = SHA1(init, pool)
 pool' = add(pool, hash)
 entropy = extract(pool)
 output = SHA1(hash, entropy)

Depending on where the add_ptr lands, we might even be able to go back
another iteration. 

By the way, I think the paper missed out on some corner case attacks
which extend the range to greater than half of the possible add_ptr
positions. Whenever less than 96 bits are changed in the first block,
we can discover the pool in O(2**64).

> It's fixing a non-problem, but I don't think changing actually hurts
> anything.  My preferred way of dealing with this problem is simply to
> increase the output pool size, since that increases the number of bits
> that change each time from 96 bits to 160 bits.

Let's do that. But let's also do this because it makes the code more
readable and somewhat stronger (for instance the first word fed back
will be cascaded from the whole pool rather than the first 512 bits).
We also only need to grab the lock once.

-- 
Mathematics is the supreme nostalgia of our time.
