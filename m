Return-Path: <linux-kernel-owner+w=401wt.eu-S1762126AbXE2SAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762126AbXE2SAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbXE2SAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:00:25 -0400
Received: from waste.org ([66.93.16.53]:49730 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbXE2SAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:00:24 -0400
Date: Tue, 29 May 2007 13:00:10 -0500
From: Matt Mackall <mpm@selenic.com>
To: Theodore Tso <tytso@mit.edu>, M Macnair <mmacnair@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Seeding /dev/random not working
Message-ID: <20070529180009.GV11115@waste.org>
References: <de6d2b4f0705290453kec2b050pb4d0bebc256b87a5@mail.gmail.com> <20070529131501.GA9899@thunk.org> <20070529174614.GG11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529174614.GG11166@waste.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 12:46:14PM -0500, Matt Mackall wrote:
> We might as well mix jiffies and cycles in at init time in a manner
> similar to the above. Something like this (untested):

Scratch that one. Here's one that compiles and seems to work under
lguest:

Index: l/drivers/char/random.c
===================================================================
--- l.orig/drivers/char/random.c	2007-05-29 12:45:00.000000000 -0500
+++ l/drivers/char/random.c	2007-05-29 12:50:02.000000000 -0500
@@ -559,6 +559,26 @@ static struct timer_rand_state input_tim
 static struct timer_rand_state *irq_timer_state[NR_IRQS];
 
 /*
+ * Mix a sample of the current time into the pool with no entropy
+ * accounting
+ */
+static long __add_timer_randomness(unsigned num)
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
+	timestamp = __add_timer_randomness(num);
 
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
+	__add_timer_randomness(0);
 	return 0;
 }
 module_init(rand_initialize);
@@ -1028,6 +1041,8 @@ random_write(struct file * file, const c
 	const char __user *p = buffer;
 	size_t c = count;
 
+	__add_timer_randomness(0);
+
 	while (c > 0) {
 		bytes = min(c, sizeof(buf));
 

-- 
Mathematics is the supreme nostalgia of our time.
