Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbXLJNhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbXLJNhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 08:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbXLJNhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 08:37:39 -0500
Received: from thunk.org ([69.25.196.29]:34192 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbXLJNhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 08:37:38 -0500
Date: Mon, 10 Dec 2007 08:37:20 -0500
From: Theodore Tso <tytso@mit.edu>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] random: make backtracking attacks harder
Message-ID: <20071210133720.GI17037@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Matt Mackall <mpm@selenic.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <2.753618428@selenic.com> <5.753618428@selenic.com> <20071209014550.GU17037@thunk.org> <20071209054337.GT19691@waste.org> <20071209133300.GB17037@thunk.org> <20071209170520.GY19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071209170520.GY19691@waste.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2007 at 11:05:20AM -0600, Matt Mackall wrote:
> Ahh, but this an attack on the output! You know only:
> 
>  pool' (including a fortuitously placed add_ptr)
> 
> and from that, you can get all but 64 bits of pool. By 2**64 iterations of:
> 
>  pool = pool' + guess
>  hash = SHA1(init, pool) # simplified
>  pool^ = add(pool, hash)
>  if pool^ = pool':
>   success!

Yes, you're right.  I thought O(2**64) shortcut attack required
knowledge of the output to unwind an interation, but looking again at
the paper, I was incorrect.  You can indeed roughly half of the time,
be able to go backwards in O(2**64) operations, instead of O(2**96)
operations.  Note BTW, that if you assume that you can do SHA in 11
cycles per second (source: http://www.cryptopp.com/benchmarks.html)
and this requires you to hash approximatly half the pool, 11 cycles *
64 bytes * 2^64 operations is approximately 190.7 *centuries* assuming
a 2 gigahertz processor.  Obviously that's much better than 7 million
*millenia* (i.e., 7 billion years) for O(2**96), but 190,669 years is
quite a long time. 

I suppose if the NSA had 20,000 2Ghz processors in the basement
cranking for 10 years, then 50% of the time *after* they did a black
bag job to crack the random pool state, they could get the last 80
bits generated from /dev/random, but it just seems that if you are
assuming the power to grab the pool plus add_ptr, there would be much
more useful things you could --- like for example having the black bag
job trojaning the software to grab the private key directly.

So, I still view this as an academic weakness, and not a real-life
threat.  :-)

> Let's do that. But let's also do this because it makes the code more
> readable and somewhat stronger (for instance the first word fed back
> will be cascaded from the whole pool rather than the first 512 bits).
> We also only need to grab the lock once.

Yeah, fair enough.  Mixing in the whole hash doesn't actually cost
that much more.  It might have a theoretical chance of potentially
losing slightly more entropy, but that is really a theoretical issue
as well --- and the fact that we are mixing in the time each time we
extract more than makes up for that.  Oh, wait.  Right, I forgot, you
took that out at some point after you took over maintainership.

Can you add this patch, too?  (Compile tested, not boot tested, but
it's pretty obviously correct.)

							- Ted


commit 499aa1b63923ff8a2309b3a1eccacb54db159c58
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Dec 10 08:35:53 2007 -0500

    random: Mix in the time of extraction into the entropy pool
    
    We don't actually add any entropy credit, but we do mix in the time of
    extraction to add further jitter and make life harder for an attacker
    by making the extraction process time-dependent.  This means that any
    attacks on the /dev/random pool can't use a static analysis.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 5fee056..b05f05c 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -767,6 +767,14 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 {
 	int i;
 	__u32 data[16], buf[5 + SHA_WORKSPACE_WORDS];
+	struct {
+		cycles_t cycles;
+		long jiffies;
+	} sample;
+
+	sample.jiffies = jiffies;
+	sample.cycles = get_cycles();
+	add_entropy_words(&input_pool, (u32 *)&sample, sizeof(sample)/4);
 
 	sha_init(buf);
 	/*
