Return-Path: <linux-kernel-owner+w=401wt.eu-S1761147AbXE2Rqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761147AbXE2Rqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 13:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbXE2Rq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 13:46:28 -0400
Received: from waste.org ([66.93.16.53]:54413 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbXE2Rq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 13:46:27 -0400
Date: Tue, 29 May 2007 12:46:14 -0500
From: Matt Mackall <mpm@selenic.com>
To: Theodore Tso <tytso@mit.edu>, M Macnair <mmacnair@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Seeding /dev/random not working
Message-ID: <20070529174614.GG11166@waste.org>
References: <de6d2b4f0705290453kec2b050pb4d0bebc256b87a5@mail.gmail.com> <20070529131501.GA9899@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529131501.GA9899@thunk.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 09:15:01AM -0400, Theodore Tso wrote:
> Another thing which I noticed is that when Matt Mackall took over
> maintainership of /dev/random, he apparently took out one of the
> safeguards I had, which was that before, when entropy was extracted
> from the pool the time stamp when it was extracted was mixed back into
> the pool.  The theory was that an external attacker might not know
> when a program might be calling /dev/random, so mixing in the time of
> that entropy was extracted wouldn't hurt, and might help.  I'll submit
> a patch to add that support back in, which will help you a little.

It's still there, and in the same place, it just looks different:

static void add_timer_randomness(struct timer_rand_state *state,
unsigned num)
{
...
        sample.jiffies = jiffies;
        sample.cycles = get_cycles();
        sample.num = num;
        add_entropy_words(&input_pool, (u32 *)&sample,
	sizeof(sample)/4);

Trouble is the write(2) interface calls add_entropy_words directly, as
does the pool initialization function.

We might as well mix jiffies and cycles in at init time in a manner
similar to the above. Something like this (untested):

Index: l/drivers/char/random.c
===================================================================
--- l.orig/drivers/char/random.c	2007-05-29 12:45:00.000000000 -0500
+++ l/drivers/char/random.c	2007-05-29 12:44:02.000000000 -0500
@@ -559,6 +559,26 @@ static struct timer_rand_state input_tim
 static struct timer_rand_state *irq_timer_state[NR_IRQS];
 
 /*
+ * Mix a sample of the current time into the pool with no entropy
+ * accounting
+ */
+static long __add_timer_randomness(void)
+{
+	struct {
+		cycles_t cycles;
+		long jiffies;
+		unsigned num;
+	} sample;
+
+	sample.jiffies = jiffies;
+	sample.cycles = get_cycles();
+	sample.num = num;
+	add_entropy_words(&input_pool, (u32 *)&sample, sizeof(sample)/4);
+
+	return sample.jiffies;
+}
+
+/*
  * This function adds entropy to the entropy "pool" by using timing
  * delays.  It uses the timer_rand_state structure to make an estimate
  * of how many bits of entropy this call has added to the pool.
@@ -570,12 +590,7 @@ static struct timer_rand_state *irq_time
  */
 static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 {
-	struct {
-		cycles_t cycles;
-		long jiffies;
-		unsigned num;
-	} sample;
-	long delta, delta2, delta3;
+	long timestamp, delta, delta2, delta3;
 
 	preempt_disable();
 	/* if over the trickle threshold, use only 1 in 4096 samples */
@@ -583,10 +598,7 @@ static void add_timer_randomness(struct 
 	    (__get_cpu_var(trickle_count)++ & 0xfff))
 		goto out;
 
-	sample.jiffies = jiffies;
-	sample.cycles = get_cycles();
-	sample.num = num;
-	add_entropy_words(&input_pool, (u32 *)&sample, sizeof(sample)/4);
+	timestamp = __add_timer_randomness();
 
 	/*
 	 * Calculate number of bits of randomness we probably added.
@@ -595,8 +607,8 @@ static void add_timer_randomness(struct 
 	 */
 
 	if (!state->dont_count_entropy) {
-		delta = sample.jiffies - state->last_time;
-		state->last_time = sample.jiffies;
+		delta = timestamp - state->last_time;
+		state->last_time = timestamp;
 
 		delta2 = delta - state->last_delta;
 		state->last_delta = delta;
@@ -899,6 +911,7 @@ static int __init rand_initialize(void)
 	init_std_data(&input_pool);
 	init_std_data(&blocking_pool);
 	init_std_data(&nonblocking_pool);
+	__add_timer_randomness();
 	return 0;
 }
 module_init(rand_initialize);
@@ -1028,6 +1041,8 @@ random_write(struct file * file, const c
 	const char __user *p = buffer;
 	size_t c = count;
 
+	__add_timer_randomness();
+
 	while (c > 0) {
 		bytes = min(c, sizeof(buf));
 


-- 
Mathematics is the supreme nostalgia of our time.
