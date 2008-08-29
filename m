Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbYH2Tsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbYH2Tsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 15:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbYH2Tsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 15:48:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbYH2Tsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 15:48:36 -0400
Date: Fri, 29 Aug 2008 12:48:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Aaron Straus <aaron@merfinllc.com>
Cc: mpm@selenic.com, linux-kernel@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: Re: drivers/char/random.c line 728 BUG
Message-Id: <20080829124807.54293904.akpm@linux-foundation.org>
In-Reply-To: <20080828225924.GD6432@merfinllc.com>
References: <20080826225918.GC5452@merfinllc.com>
	<20080828225924.GD6432@merfinllc.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008 15:59:24 -0700
Aaron Straus <aaron@merfinllc.com> wrote:

> Hi,
> 
> On Aug 26 03:59 PM, Aaron Straus wrote:
> > kernel BUG at drivers/char/random.c:728!
> 
> OK so that's (outside spinlock):
> 
>    BUG_ON(r->entropy_count > r->poolinfo->POOLBITS); 
> 
> in credit_entropy_bits we do (inside spinlock):
> 
> 	r->entropy_count += nbits;
> 	if (r->entropy_count < 0) {
> 		DEBUG_ENT("negative entropy/overflow\n");
> 		r->entropy_count = 0;
> 	} else if (r->entropy_count > r->poolinfo->POOLBITS)
> 		r->entropy_count = r->poolinfo->POOLBITS;
> 
> I wonder if we got unlucky and did the:
> 
>   r->entropy_count += nbits
> 
>  - overflowed the entropy_count THEN
>  - another thread hits the BUG before this thread reaches
> 
>    r->entropy_count = r->poolinfo->POOLBITS;
> 
> --
> 
> I notice before this commit:
> 
> commit adc782dae6c4c0f6fb679a48a544cfbcd79ae3dc
> Author: Matt Mackall <mpm@selenic.com>
> Date:   Tue Apr 29 01:03:07 2008 -0700
> 
>     random: simplify and rename credit_entropy_store
> 
> The credit_entropy_store function looks like this:
> 
> 	spin_lock_irqsave(&r->lock, flags);
> 
> 	if (r->entropy_count + nbits < 0) {
> 		DEBUG_ENT("negative entropy/overflow (%d+%d)\n",
> 			  r->entropy_count, nbits);
> 		r->entropy_count = 0;
> 	} else if (r->entropy_count + nbits > r->poolinfo->POOLBITS) {
> 		r->entropy_count = r->poolinfo->POOLBITS;
> 	} else {
> 		r->entropy_count += nbits;
> 		if (nbits)
> 			DEBUG_ENT("added %d entropy credits to %s\n",
> 				  nbits, r->name);
> 	}
> 
> 
> Notice the old version is careful not to overflow r->entropy_count at
> any point (even within the spinlock).  So perhaps that's why we didn't
> hit this BUG() in the past?
> 

yep, I would agree with all that.

How's this look?


From: Andrew Morton <akpm@linux-foundation.org>

Fix a bug reported by and diagnosed by Aaron Straus.

This is a regression intruduced into 2.6.26 by

    commit adc782dae6c4c0f6fb679a48a544cfbcd79ae3dc
    Author: Matt Mackall <mpm@selenic.com>
    Date:   Tue Apr 29 01:03:07 2008 -0700

        random: simplify and rename credit_entropy_store

credit_entropy_bits() does:

	spin_lock_irqsave(&r->lock, flags);
	...
	if (r->entropy_count > r->poolinfo->POOLBITS)
		r->entropy_count = r->poolinfo->POOLBITS;

so there is a time window in which this BUG_ON():

static size_t account(struct entropy_store *r, size_t nbytes, int min,
		      int reserved)
{
	unsigned long flags;

	BUG_ON(r->entropy_count > r->poolinfo->POOLBITS);

	/* Hold lock while accounting */
	spin_lock_irqsave(&r->lock, flags);

can trigger.

We could fix this by moving the assertion inside the lock, but it seems
safer and saner to revert to the old behaviour wherein
entropy_store.entropy_count at no time exceeds
entropy_store.poolinfo->POOLBITS.

Reported-by: Aaron Straus <aaron@merfinllc.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: <stable@kernel.org>		[2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/char/random.c~drivers-char-randomc-fix-a-race-which-can-lead-to-a-bogus-bug drivers/char/random.c
--- a/drivers/char/random.c~drivers-char-randomc-fix-a-race-which-can-lead-to-a-bogus-bug
+++ a/drivers/char/random.c
@@ -520,6 +520,7 @@ static void mix_pool_bytes(struct entrop
 static void credit_entropy_bits(struct entropy_store *r, int nbits)
 {
 	unsigned long flags;
+	int entropy_count;
 
 	if (!nbits)
 		return;
@@ -527,20 +528,20 @@ static void credit_entropy_bits(struct e
 	spin_lock_irqsave(&r->lock, flags);
 
 	DEBUG_ENT("added %d entropy credits to %s\n", nbits, r->name);
-	r->entropy_count += nbits;
-	if (r->entropy_count < 0) {
+	entropy_count = r->entropy_count;
+	entropy_count += nbits;
+	if (entropy_count < 0) {
 		DEBUG_ENT("negative entropy/overflow\n");
-		r->entropy_count = 0;
-	} else if (r->entropy_count > r->poolinfo->POOLBITS)
-		r->entropy_count = r->poolinfo->POOLBITS;
+		entropy_count = 0;
+	} else if (entropy_count > r->poolinfo->POOLBITS)
+		entropy_count = r->poolinfo->POOLBITS;
 
 	/* should we wake readers? */
-	if (r == &input_pool &&
-	    r->entropy_count >= random_read_wakeup_thresh) {
+	if (r == &input_pool && entropy_count >= random_read_wakeup_thresh) {
 		wake_up_interruptible(&random_read_wait);
 		kill_fasync(&fasync, SIGIO, POLL_IN);
 	}
-
+	r->entropy_count = entropy_count;
 	spin_unlock_irqrestore(&r->lock, flags);
 }
 
_

