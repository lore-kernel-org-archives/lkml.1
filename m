Return-Path: <linux-kernel-owner+w=401wt.eu-S1760075AbYGAXkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075AbYGAXkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 19:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYGAXkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 19:40:08 -0400
Received: from pilet.ens-lyon.fr ([140.77.167.16]:39471 "EHLO
	pilet.ens-lyon.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbYGAXkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 19:40:06 -0400
X-Greylist: delayed 1227 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jul 2008 19:40:06 EDT
Date: Wed, 2 Jul 2008 01:19:27 +0200
From: Benoit Boissinot <bboissin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jack Lloyd <lloyd@randombit.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Bug in random32.c: all-zero outputs with probability 1/2^32,
	other seeding bugs
Message-ID: <20080701231927.GW7647@pirzuine>
References: <20080619153045.GC1455@randombit.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080619153045.GC1455@randombit.net>
X-Sieve: CMU Sieve 2.2
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[who maintains random32.c ?]

On Thu, Jun 19, 2008 at 5:30 PM, Jack Lloyd <lloyd@randombit.net> wrote:
> Hi,
>
> There appears to be an error in how random seeding is done in the
> random32.c RNG. I am looking at 2.6.25.7.
>
[snip]
>
> An easy and straightforward fix for this that doesn't require changing
> any interfaces is to add
>  s &= 0xFFFFFFFF;
> before the check in __set_random32, which ensures this condition will
> be caught by the check. Alternately, you could replace the check for
> s == 0 with some logic like:
>  if((s & 0xFFFFFFFF) == 0)
>     s += 1;
> since just chopping the seed to 32 bits does throw away some of your
> seed input (with sizeof(long) == 8, at least; doesn't make any
> difference for sizeof(long) == 4)
>

I think it is cleaner to change the interface to account for long != u32

The rest of your patch (ensuring values are big enough) looks valid to me.

Signed-off-by: Benoit Boissinot <benoit.boissinot@ens-lyon.org>

diff -r ced66ca0044f lib/random32.c
--- a/lib/random32.c	Mon Jun 30 08:58:09 2008 -0700
+++ b/lib/random32.c	Wed Jul 02 01:13:12 2008 +0200
@@ -56,7 +56,7 @@
 	return (state->s1 ^ state->s2 ^ state->s3);
 }

-static void __set_random32(struct rnd_state *state, unsigned long s)
+static void __set_random32(struct rnd_state *state, u32 s)
 {
 	if (s == 0)
 		s = 1;      /* default seed is 1 */
@@ -84,7 +84,7 @@
  */
 u32 random32(void)
 {
-	unsigned long r;
+	u32 r;
 	struct rnd_state *state = &get_cpu_var(net_rand_state);
 	r = __random32(state);
 	put_cpu_var(state);
@@ -122,7 +122,7 @@

 	for_each_possible_cpu(i) {
 		struct rnd_state *state = &per_cpu(net_rand_state,i);
-		__set_random32(state, i + jiffies);
+		__set_random32(state, (u32) i + jiffies);
 	}
 	return 0;
 }
@@ -135,7 +135,7 @@
 static int __init random32_reseed(void)
 {
 	int i;
-	unsigned long seed;
+	u32 seed;

 	for_each_possible_cpu(i) {
 		struct rnd_state *state = &per_cpu(net_rand_state,i);
