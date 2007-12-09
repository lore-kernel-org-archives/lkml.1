Return-Path: <linux-kernel-owner+w=401wt.eu-S1754295AbXLIAlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbXLIAlZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 19:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbXLIAlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 19:41:18 -0500
Received: from waste.org ([66.93.16.53]:50143 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbXLIAlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 19:41:17 -0500
Date: Sat, 8 Dec 2007 18:40:17 -0600
From: Matt Mackall <mpm@selenic.com>
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] random: use xor for mixing
Message-ID: <20071209004017.GQ19691@waste.org>
References: <2.753618428@selenic.com> <3.753618428@selenic.com> <20071209000103.GS17037@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071209000103.GS17037@thunk.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 07:01:04PM -0500, Theodore Tso wrote:
> On Sat, Dec 08, 2007 at 05:20:16PM -0600, Matt Mackall wrote:
> > random: use xor for mixing
> > 
> > With direct assignment, we can determine the twist table element used
> > for mixing (the high 3 bits of the table are unique) and reverse a
> > single step of mixing. Instead, use xor, which should also help
> > preserve entropy in a given pool slot.
> > 
> > Signed-off-by: Matt Mackall <mpm@selenic.com>
> > 
> > diff -r bc336762cfdb drivers/char/random.c
> > --- a/drivers/char/random.c	Wed Dec 05 17:20:02 2007 -0600
> > +++ b/drivers/char/random.c	Sat Dec 08 13:27:34 2007 -0600
> > @@ -496,7 +496,7 @@ static void __add_entropy_words(struct e
> >  		w ^= r->pool[(i + tap4) & wordmask];
> >  		w ^= r->pool[(i + tap5) & wordmask];
> >  		w ^= r->pool[i];
> > -		r->pool[i] = (w >> 3) ^ twist_table[w & 7];
> > +		r->pool[i] ^= (w >> 3) ^ twist_table[w & 7];
> >  	}
> 
> In the original design of add_entropy_words(), in order to provably
> not lose any entropy, you want add_entropy_words() to be reversible if
> you mix in all zero's.

Ahh, yes, that's true. I'd somehow missed that we effectively had a
tap at 0, so I thought this was actually improving the situation. I'll
replace this with a comment explaining the situation.

> The internals of the pool are never exposed, so an attacker should
> never gain direct access to the entropy pool; hence worry about
> whether someone can "reverse" the mixing isn't particuarly a worry;
> indeed, in order to make sure we preserve entropy, the whole *point*
> of the mixing algorithm is that it is reversible.

I'm working on strengthening forward security for cases where the
internals are exposed to an attacker. There are any number of
situations where this can and does happen, and ensuring we don't
expose ourselves to backtracking is a worthwhile theoretical concern.

---
random: document revisibility of mixing function.

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r bc336762cfdb drivers/char/random.c
--- a/drivers/char/random.c	Wed Dec 05 17:20:02 2007 -0600
+++ b/drivers/char/random.c	Sat Dec 08 18:38:15 2007 -0600
@@ -447,6 +447,12 @@ static struct entropy_store nonblocking_
  * degree, and then twisted.  We twist by three bits at a time because
  * it's cheap to do so and helps slightly in the expected case where
  * the entropy is concentrated in the low-order bits.
+ *
+ * This function is intentionally reversible, meaning that if we mix
+ * in known values, we can run the algorithm backwards and recover the
+ * earlier state. Because we can recover the original state, we are
+ * provably not destroying any existing entropy content in the pool
+ * when we mix.
  */
 static void __add_entropy_words(struct entropy_store *r, const __u32 *in,
 				int nwords, __u32 out[16])

-- 
Mathematics is the supreme nostalgia of our time.
