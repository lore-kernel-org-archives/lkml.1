Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbXLIABb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbXLIABb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 19:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbXLIABX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 19:01:23 -0500
Received: from THUNK.ORG ([69.25.196.29]:37901 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbXLIABW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 19:01:22 -0500
Date: Sat, 8 Dec 2007 19:01:04 -0500
From: Theodore Tso <tytso@mit.edu>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] random: use xor for mixing
Message-ID: <20071209000103.GS17037@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Matt Mackall <mpm@selenic.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <2.753618428@selenic.com> <3.753618428@selenic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3.753618428@selenic.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 05:20:16PM -0600, Matt Mackall wrote:
> random: use xor for mixing
> 
> With direct assignment, we can determine the twist table element used
> for mixing (the high 3 bits of the table are unique) and reverse a
> single step of mixing. Instead, use xor, which should also help
> preserve entropy in a given pool slot.
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>
> 
> diff -r bc336762cfdb drivers/char/random.c
> --- a/drivers/char/random.c	Wed Dec 05 17:20:02 2007 -0600
> +++ b/drivers/char/random.c	Sat Dec 08 13:27:34 2007 -0600
> @@ -496,7 +496,7 @@ static void __add_entropy_words(struct e
>  		w ^= r->pool[(i + tap4) & wordmask];
>  		w ^= r->pool[(i + tap5) & wordmask];
>  		w ^= r->pool[i];
> -		r->pool[i] = (w >> 3) ^ twist_table[w & 7];
> +		r->pool[i] ^= (w >> 3) ^ twist_table[w & 7];
>  	}

In the original design of add_entropy_words(), in order to provably
not lose any entropy, you want add_entropy_words() to be reversible if
you mix in all zero's.  So the fact that you can determine the twist
table element used from looking at the high bits was deliberate.  The
mixing done in add_entropy_words() is *not* intended to be
cryptographic, but merely to smear the bits around as they are added
and then to permute the pool so that when you use SHA in the output
stage, enough bits are changing that even if there are weaknesses
discovered in the crypto hash algorithm, it won't help the attacker.

The internals of the pool are never exposed, so an attacker should
never gain direct access to the entropy pool; hence worry about
whether someone can "reverse" the mixing isn't particuarly a worry;
indeed, in order to make sure we preserve entropy, the whole *point*
of the mixing algorithm is that it is reversible.

(note: credit for this design should go to Colin Plumb, who worked
with me on this aspect of the design.  Colin was responsible for the
original random number generator in PGP....)

					- Ted
