Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbYICSVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbYICSVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbYICSV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:21:26 -0400
Received: from waste.org ([66.93.16.53]:51857 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbYICSVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:21:25 -0400
Subject: Re: drivers/char/random.c line 728 BUG
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Straus <aaron@merfinllc.com>, linux-kernel@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
In-Reply-To: <20080829124807.54293904.akpm@linux-foundation.org>
References: <20080826225918.GC5452@merfinllc.com>
	 <20080828225924.GD6432@merfinllc.com>
	 <20080829124807.54293904.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 03 Sep 2008 13:18:21 -0500
Message-Id: <1220465901.17608.55.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-08-29 at 12:48 -0700, Andrew Morton wrote:
> On Thu, 28 Aug 2008 15:59:24 -0700
> Aaron Straus <aaron@merfinllc.com> wrote:
> 
> > Hi,
> > 
> > On Aug 26 03:59 PM, Aaron Straus wrote:
> > > kernel BUG at drivers/char/random.c:728!
> > 
> > OK so that's (outside spinlock):
> > 
> >    BUG_ON(r->entropy_count > r->poolinfo->POOLBITS); 
> > 
> > in credit_entropy_bits we do (inside spinlock):
> > 
> > 	r->entropy_count += nbits;
> > 	if (r->entropy_count < 0) {
> > 		DEBUG_ENT("negative entropy/overflow\n");
> > 		r->entropy_count = 0;
> > 	} else if (r->entropy_count > r->poolinfo->POOLBITS)
> > 		r->entropy_count = r->poolinfo->POOLBITS;
> > 
> > I wonder if we got unlucky and did the:
> > 
> >   r->entropy_count += nbits
> > 
> >  - overflowed the entropy_count THEN
> >  - another thread hits the BUG before this thread reaches
> > 
> >    r->entropy_count = r->poolinfo->POOLBITS;
> > 
> > --
> > 
> > I notice before this commit:
> > 
> > commit adc782dae6c4c0f6fb679a48a544cfbcd79ae3dc
> > Author: Matt Mackall <mpm@selenic.com>
> > Date:   Tue Apr 29 01:03:07 2008 -0700
> > 
> >     random: simplify and rename credit_entropy_store
> > 
> > The credit_entropy_store function looks like this:
> > 
> > 	spin_lock_irqsave(&r->lock, flags);
> > 
> > 	if (r->entropy_count + nbits < 0) {
> > 		DEBUG_ENT("negative entropy/overflow (%d+%d)\n",
> > 			  r->entropy_count, nbits);
> > 		r->entropy_count = 0;
> > 	} else if (r->entropy_count + nbits > r->poolinfo->POOLBITS) {
> > 		r->entropy_count = r->poolinfo->POOLBITS;
> > 	} else {
> > 		r->entropy_count += nbits;
> > 		if (nbits)
> > 			DEBUG_ENT("added %d entropy credits to %s\n",
> > 				  nbits, r->name);
> > 	}
> > 
> > 
> > Notice the old version is careful not to overflow r->entropy_count at
> > any point (even within the spinlock).  So perhaps that's why we didn't
> > hit this BUG() in the past?
> > 
> 
> yep, I would agree with all that.
> 
> How's this look?
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Fix a bug reported by and diagnosed by Aaron Straus.
> 
> This is a regression intruduced into 2.6.26 by
> 
>     commit adc782dae6c4c0f6fb679a48a544cfbcd79ae3dc
>     Author: Matt Mackall <mpm@selenic.com>
>     Date:   Tue Apr 29 01:03:07 2008 -0700
> 
>         random: simplify and rename credit_entropy_store
> 
> credit_entropy_bits() does:
> 
> 	spin_lock_irqsave(&r->lock, flags);
> 	...
> 	if (r->entropy_count > r->poolinfo->POOLBITS)
> 		r->entropy_count = r->poolinfo->POOLBITS;
> 
> so there is a time window in which this BUG_ON():
> 
> static size_t account(struct entropy_store *r, size_t nbytes, int min,
> 		      int reserved)
> {
> 	unsigned long flags;
> 
> 	BUG_ON(r->entropy_count > r->poolinfo->POOLBITS);
> 
> 	/* Hold lock while accounting */
> 	spin_lock_irqsave(&r->lock, flags);
> 
> can trigger.
> 
> We could fix this by moving the assertion inside the lock, but it seems
> safer and saner to revert to the old behaviour wherein
> entropy_store.entropy_count at no time exceeds
> entropy_store.poolinfo->POOLBITS.
> 
> Reported-by: Aaron Straus <aaron@merfinllc.com>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: <stable@kernel.org>		[2.6.26.x]
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/char/random.c |   17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff -puN drivers/char/random.c~drivers-char-randomc-fix-a-race-which-can-lead-to-a-bogus-bug drivers/char/random.c
> --- a/drivers/char/random.c~drivers-char-randomc-fix-a-race-which-can-lead-to-a-bogus-bug
> +++ a/drivers/char/random.c
> @@ -520,6 +520,7 @@ static void mix_pool_bytes(struct entrop
>  static void credit_entropy_bits(struct entropy_store *r, int nbits)
>  {
>  	unsigned long flags;
> +	int entropy_count;
>  
>  	if (!nbits)
>  		return;
> @@ -527,20 +528,20 @@ static void credit_entropy_bits(struct e
>  	spin_lock_irqsave(&r->lock, flags);
>  
>  	DEBUG_ENT("added %d entropy credits to %s\n", nbits, r->name);
> -	r->entropy_count += nbits;
> -	if (r->entropy_count < 0) {
> +	entropy_count = r->entropy_count;
> +	entropy_count += nbits;
> +	if (entropy_count < 0) {
>  		DEBUG_ENT("negative entropy/overflow\n");
> -		r->entropy_count = 0;
> -	} else if (r->entropy_count > r->poolinfo->POOLBITS)
> -		r->entropy_count = r->poolinfo->POOLBITS;
> +		entropy_count = 0;
> +	} else if (entropy_count > r->poolinfo->POOLBITS)
> +		entropy_count = r->poolinfo->POOLBITS;
>  
>  	/* should we wake readers? */
> -	if (r == &input_pool &&
> -	    r->entropy_count >= random_read_wakeup_thresh) {
> +	if (r == &input_pool && entropy_count >= random_read_wakeup_thresh) {
>  		wake_up_interruptible(&random_read_wait);
>  		kill_fasync(&fasync, SIGIO, POLL_IN);
>  	}
> -
> +	r->entropy_count = entropy_count;
>  	spin_unlock_irqrestore(&r->lock, flags);
>  }

Sorry, just back from being offline for a week.

This fix is bogus - it assumes that r->entropy_count has atomic
assignment which is not universally true (witness the existence of
atomic_t). So we can still observe partial updates to entropy_count on
some architectures. Now it's probably the case that we'll never see a
partial update that actually triggers the BUG_ON, but it's still
conceptually wrong to do things this way.

The right fix in such a case is simply to never look at such things
outside the relevant lock. Especially so in this case, where we take the
lock unconditionally one line later - there's absolutely no upside to
examining it outside the lock.

I'm fine with using a local for entropy_count as prettification, but not
for trying to avoid races. We should do this instead:

Avoid checking lock-protected entropy_count when lock isn't held.

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r ddae8a8d3c6f drivers/char/random.c
--- a/drivers/char/random.c	Tue Jul 29 03:07:11 2008 +0000
+++ b/drivers/char/random.c	Wed Sep 03 13:10:22 2008 -0500
@@ -726,11 +726,10 @@
 {
 	unsigned long flags;
 
-	BUG_ON(r->entropy_count > r->poolinfo->POOLBITS);
-
 	/* Hold lock while accounting */
 	spin_lock_irqsave(&r->lock, flags);
 
+	BUG_ON(r->entropy_count > r->poolinfo->POOLBITS);
 	DEBUG_ENT("trying to extract %d bits from %s\n",
 		  nbytes * 8, r->name);
 


-- 
Mathematics is the supreme nostalgia of our time.

