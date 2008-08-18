Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbYHRS4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbYHRS4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761129AbYHRSz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:55:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665AbYHRSzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:55:23 -0400
Date: Mon, 18 Aug 2008 11:43:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Stephen Hemminger <shemminger@vyatta.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 26/60] random32: seeding improvement
Message-ID: <20080818184326.GA29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="random32-seeding-improvement.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>

[ Upstream commit 697f8d0348a652593d195a13dd1067d9df911a82 ]

The rationale is:
   * use u32 consistently
   * no need to do LCG on values from (better) get_random_bytes
   * use more data from get_random_bytes for secondary seeding
   * don't reduce state space on srandom32()
   * enforce state variable initialization restrictions

Note: the second paper has a version of random32() with even longer period
and a version of random64() if needed.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/random32.c |   48 +++++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

--- a/lib/random32.c
+++ b/lib/random32.c
@@ -56,23 +56,12 @@ static u32 __random32(struct rnd_state *
 	return (state->s1 ^ state->s2 ^ state->s3);
 }
 
-static void __set_random32(struct rnd_state *state, unsigned long s)
+/*
+ * Handle minimum values for seeds
+ */
+static inline u32 __seed(u32 x, u32 m)
 {
-	if (s == 0)
-		s = 1;      /* default seed is 1 */
-
-#define LCG(n) (69069 * n)
-	state->s1 = LCG(s);
-	state->s2 = LCG(state->s1);
-	state->s3 = LCG(state->s2);
-
-	/* "warm it up" */
-	__random32(state);
-	__random32(state);
-	__random32(state);
-	__random32(state);
-	__random32(state);
-	__random32(state);
+	return (x < m) ? x + m : x;
 }
 
 /**
@@ -107,7 +96,7 @@ void srandom32(u32 entropy)
 	 */
 	for_each_possible_cpu (i) {
 		struct rnd_state *state = &per_cpu(net_rand_state, i);
-		__set_random32(state, state->s1 ^ entropy);
+		state->s1 = __seed(state->s1 ^ entropy, 1);
 	}
 }
 EXPORT_SYMBOL(srandom32);
@@ -122,7 +111,19 @@ static int __init random32_init(void)
 
 	for_each_possible_cpu(i) {
 		struct rnd_state *state = &per_cpu(net_rand_state,i);
-		__set_random32(state, i + jiffies);
+
+#define LCG(x)	((x) * 69069)	/* super-duper LCG */
+		state->s1 = __seed(LCG(i + jiffies), 1);
+		state->s2 = __seed(LCG(state->s1), 7);
+		state->s3 = __seed(LCG(state->s2), 15);
+
+		/* "warm it up" */
+		__random32(state);
+		__random32(state);
+		__random32(state);
+		__random32(state);
+		__random32(state);
+		__random32(state);
 	}
 	return 0;
 }
@@ -135,13 +136,18 @@ core_initcall(random32_init);
 static int __init random32_reseed(void)
 {
 	int i;
-	unsigned long seed;
 
 	for_each_possible_cpu(i) {
 		struct rnd_state *state = &per_cpu(net_rand_state,i);
+		u32 seeds[3];
+
+		get_random_bytes(&seeds, sizeof(seeds));
+		state->s1 = __seed(seeds[0], 1);
+		state->s2 = __seed(seeds[1], 7);
+		state->s3 = __seed(seeds[2], 15);
 
-		get_random_bytes(&seed, sizeof(seed));
-		__set_random32(state, seed);
+		/* mix it in */
+		__random32(state);
 	}
 	return 0;
 }

-- 
