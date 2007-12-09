Return-Path: <linux-kernel-owner+w=401wt.eu-S1751933AbXLINdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbXLINdV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 08:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbXLINdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 08:33:13 -0500
Received: from thunk.org ([69.25.196.29]:42818 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbXLINdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 08:33:12 -0500
Date: Sun, 9 Dec 2007 08:33:00 -0500
From: Theodore Tso <tytso@mit.edu>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] random: make backtracking attacks harder
Message-ID: <20071209133300.GB17037@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Matt Mackall <mpm@selenic.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <2.753618428@selenic.com> <5.753618428@selenic.com> <20071209014550.GU17037@thunk.org> <20071209054337.GT19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071209054337.GT19691@waste.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 11:43:37PM -0600, Matt Mackall wrote:
> > If you are trying to find the value of the 80 bits that were
> > extracted, and you know the current state of the pool, yes, you can
> > take the 96 bits that were changed after the last extraction, and try
> > all possible 2**96 combinations of the bits; but you probably won't
> > rule anything out, since after you iterate over all of the 2**96
> > combinations, you'll probably be able to generate all of the 2**80
> > possible output bits.  So you won't gain anything by trying to do a
> > backtracking attack.  So I don't think there's anything to worry about
> > here.
> 
> Two observations:
> 
> - 2**96 << 2**160 so our feedback is much weaker than our hash so we
>   should improve it on general principle

Well, no.  You're comparing apples and oranges here.  You can iterate
over 2**96 choices, but given that even if you are doing an iterative
guessing attack, you have 2**80 knowns, and 2**96 unknowns, it doesn't
buy you anything.  So saying that there is a successful attack with
O(2**96) simply isn't true!  Secondly, a 160-bit hash is actually only
80 bits strong (because of the birthday attack); when SHA was
originally published by the US government, it was designed to be
paired with the Clipper chip, which was an 80 bit symmetric key cipher
with a backdoor.

> - there's a way to improve this attack to 2**64 in some situations!

Yeah, but again, what does this "attack" buy you?  If you know the
output, and the current state of the pool, after doing 2**64
iterations you can get the state of the pool before the output.
Big-di-whoopdie-do.  You can't actually *do* anything with it.  

If you want to use that to obtain the unknown 80-bit output at that
point in time, you're back to the 96-bits unknown problem, since in
the case where you don't know the output, the shortcut attack doesn't
work.

> I presume you've seen this paper:
> 
>  http://eprint.iacr.org/2006/086.pdf
> 
> It was fairly obsolete at printing and makes a bunch of mistakes. 

Oh yes, I'm familiar with the paper; I wrote a rebuttal to it to LKML
at the time, and cc'ed the authors, who never got back to me.  I also
made a bunch of changes to strengthen /dev/random against some of
their observations that described weaknesses, even though I didn't and
still don't think you could leverage them into a practical attack,
even *if* you accept their premise of a state compromise that didn't
involve even worse consequences than enabling theoretical attacks
against /dev/random.

> Simply feeding back all five words of our hash rather than three in
> the secondary pools hardens this all right up. This patch also makes
> everything in here much easier to read and analyze.

It's fixing a non-problem, but I don't think changing actually hurts
anything.  My preferred way of dealing with this problem is simply to
increase the output pool size, since that increases the number of bits
that change each time from 96 bits to 160 bits.

(This is a private paranoia patch I've been carrying around for a
while.)

     	    	      	      	      - Ted

commit 9c6c0954b3d56de04f03225e16d7f0d31c823c92
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Oct 13 00:03:26 2007 -0400

    randomness-fix-increase_output_pool

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 5fee056..731eb15 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -249,7 +249,7 @@
  * Configuration information
  */
 #define INPUT_POOL_WORDS 128
-#define OUTPUT_POOL_WORDS 32
+#define OUTPUT_POOL_WORDS 64
 #define SEC_XFER_SIZE 512
 
 /*
@@ -288,8 +288,8 @@ static struct poolinfo {
 } poolinfo_table[] = {
 	/* x^128 + x^103 + x^76 + x^51 +x^25 + x + 1 -- 105 */
 	{ 128,	103,	76,	51,	25,	1 },
-	/* x^32 + x^26 + x^20 + x^14 + x^7 + x + 1 -- 15 */
-	{ 32,	26,	20,	14,	7,	1 },
+	/* x^64 + x^52 + x^39 + x^26 + x^14 + x + 1 -- 15 */
+	{ 64,	52,	39,	26,	14,	1 },
 #if 0
 	/* x^2048 + x^1638 + x^1231 + x^819 + x^411 + x + 1  -- 115 */
 	{ 2048,	1638,	1231,	819,	411,	1 },
@@ -314,8 +314,8 @@ static struct poolinfo {
 	/* x^128 + x^103 + x^78 + x^51 + x^27 + x^2 + 1 -- 70 */
 	{ 128,	103,	78,	51,	27,	2 },
 
-	/* x^64 + x^52 + x^39 + x^26 + x^14 + x + 1 -- 15 */
-	{ 64,	52,	39,	26,	14,	1 },
+	/* x^32 + x^26 + x^20 + x^14 + x^7 + x + 1 -- 15 */
+	{ 32,	26,	20,	14,	7,	1 },
 #endif
 };
 
