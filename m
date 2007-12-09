Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbXLIBqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbXLIBqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 20:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbXLIBqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 20:46:08 -0500
Received: from THUNK.ORG ([69.25.196.29]:40558 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbXLIBqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 20:46:06 -0500
Date: Sat, 8 Dec 2007 20:45:50 -0500
From: Theodore Tso <tytso@mit.edu>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] random: make backtracking attacks harder
Message-ID: <20071209014550.GU17037@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Matt Mackall <mpm@selenic.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <2.753618428@selenic.com> <5.753618428@selenic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5.753618428@selenic.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 05:20:38PM -0600, Matt Mackall wrote:
> random: make backtracking attacks harder
> 
> At each extraction, we change (poolbits / 16) + 32 bits in the pool,
> or 96 bits in the case of the secondary pools. Thus, a brute-force
> backtracking attack on the pool state is less difficult than breaking
> the hash. In certain cases, this difficulty may be is reduced to 2^64
> iterations.

OK, a backtracking attack assumes a fairly catastrophic case where the
attacker has managed to compromise the internal pool state.  In Linux,
if an attacker has this much access, in most scenarios the attacker
probably has the ability to gain write access to kernel memory as
well, at which point you have far worse problems.

The definition of a backtracking attack is when the attacker uses the
current pool state to try to recover the last entropy extraction.  As
you point out, at each extraction, 96 bits are changed in the pool.
But at each extraction, only 80 bits are extracted.

If you are trying to find the value of the 80 bits that were
extracted, and you know the current state of the pool, yes, you can
take the 96 bits that were changed after the last extraction, and try
all possible 2**96 combinations of the bits; but you probably won't
rule anything out, since after you iterate over all of the 2**96
combinations, you'll probably be able to generate all of the 2**80
possible output bits.  So you won't gain anything by trying to do a
backtracking attack.  So I don't think there's anything to worry about
here.

What you describe in your comments:

> +	 * We mix the hash back into the pool to prevent backtracking
> +	 * attacks (where the attacker knows the state of the pool
> +	 * plus the current outputs, and attempts to find previous
> +	 * ouputs), unless the hash function can be inverted. By
> +	 * mixing at least a SHA1 worth of hash data back, we make
> +	 * brute-forcing the feedback as hard as brute-forcing the
> +	 * hash.
>  	 */

.... sounds like not a backtracking attack, but an Iterative guessing
attack, where "knowledge of internal state at some point and the
intervening PRNG outputs, to learn internal state at a later point
when the inputs collected during this span of time are guessable by
the attacker."  (Definition taken from:
http://www.ee.oulu.fi/research/ouspg/frontier/sota/whitepaper-prng/)

But note first of all, all this lets you do is unwind to an earlier
state just before the known PRNG outputs.  In order to use this to
guess PRNG output, you still have to solve the above mentioned
backtracking attack --- where you have 96 bits that changed, and 80
possible extraction bits.  

Secondly, the fact that we use catastrophic reseeding means that even
if the state was compromised, at some point in time, every so often
when we do a "catastrophic reseed", this acts as a firewall to limit
the damage caused by a internal state exposure, both in the past and
the future.

						- Ted
