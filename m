Return-Path: <linux-kernel-owner+w=401wt.eu-S1751865AbXLDSSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbXLDSSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 13:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbXLDSSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 13:18:12 -0500
Received: from smtp2a.orange.fr ([80.12.242.140]:33552 "EHLO smtp2a.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbXLDSSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 13:18:11 -0500
X-ME-UUID: 20071204181808982.EFC2170000AB@mwinf2a18.orange.fr
Message-ID: <475599D6.4030008@cosmosbay.com>
Date: Tue, 04 Dec 2007 19:17:58 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.13 (Windows/20070809)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Adrian Bunk <bunk@kernel.org>, Marc Haber <mh+linux-kernel@zugschlus.de>,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
References: <20071204114125.GA17310@torres.zugschlus.de>	<20071204161811.GB15974@stusta.de> <20071204164720.6e4dc2c4@the-village.bc.nu>
In-Reply-To: <20071204164720.6e4dc2c4@the-village.bc.nu>
Content-Type: multipart/mixed;
 boundary="------------060304030701040906030408"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060304030701040906030408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Alan Cox a =E9crit :
>> No matter what you consider as being better, changing a 12 years old a=
nd=20
>> widely used userspace interface like /dev/urandom is simply not an=20
>> option.
>>    =20
>
> Fixing it to be more efficient in its use of entropy and also fixing th=
e
> fact its not actually a good random number source would be worth lookin=
g
> at however.
>  =20
Yes, since current behavior on network irq is very pessimistic.

If you have some trafic, (ie more than HZ/2  interrupts per second),=20
then add_timer_randomness() feeds
 some entropy but gives no credit (calling credit_entropy_store() with=20
nbits=3D0)

This is because we take into account only the jiffies difference, and=20
not the get_cycles() that should give
 us more entropy on most plaforms.

In this patch, I suggest that we feed only one u32 word of entropy,=20
combination of the previous distinct
words (with some of them being constant or so), so that the nbits=20
estimation is less pessimistic, but also to
avoid injecting false entropy.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>



--------------060304030701040906030408
Content-Type: text/plain;
 name="random.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="random.patch"

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 5fee056..6eccfc9 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -550,8 +550,8 @@ static void credit_entropy_store(struct entropy_store *r, int nbits)
 
 /* There is one of these per entropy source */
 struct timer_rand_state {
-	cycles_t last_time;
-	long last_delta,last_delta2;
+	u32      last_word;
+	int last_delta,last_delta2;
 	unsigned dont_count_entropy:1;
 };
 
@@ -570,12 +570,17 @@ static struct timer_rand_state *irq_timer_state[NR_IRQS];
  */
 static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 {
-	struct {
-		cycles_t cycles;
-		long jiffies;
-		unsigned num;
+	union {
+		struct {
+			cycles_t cycles;
+			long jiffies;
+			unsigned num;
+		};
+		u32 words[1];
 	} sample;
-	long delta, delta2, delta3;
+	u32 word;
+	unsigned int ui;
+	int delta, delta2, delta3;
 
 	preempt_disable();
 	/* if over the trickle threshold, use only 1 in 4096 samples */
@@ -586,7 +591,12 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 	sample.jiffies = jiffies;
 	sample.cycles = get_cycles();
 	sample.num = num;
-	add_entropy_words(&input_pool, (u32 *)&sample, sizeof(sample)/4);
+
+	word = sample.words[0];
+	for (ui = 1; ui < sizeof(sample)/4; ui++)
+		word += sample.words[ui];
+
+	add_entropy_words(&input_pool, &word, 1);
 
 	/*
 	 * Calculate number of bits of randomness we probably added.
@@ -595,8 +605,8 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 	 */
 
 	if (!state->dont_count_entropy) {
-		delta = sample.jiffies - state->last_time;
-		state->last_time = sample.jiffies;
+		delta = word - state->last_word;
+		state->last_word = word;
 
 		delta2 = delta - state->last_delta;
 		state->last_delta = delta;

--------------060304030701040906030408--


