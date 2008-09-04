Return-Path: <linux-kernel-owner+w=401wt.eu-S1756954AbYIDUxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbYIDUxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbYIDUxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:53:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34046 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691AbYIDUxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:53:01 -0400
Date: Thu, 4 Sep 2008 22:52:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
Message-ID: <20080904205236.GA3864@elte.hu>
References: <20080904150339.896115280@linutronix.de> <20080904153620.GC7120@elte.hu> <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org> <20080904160036.GA18382@elte.hu> <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org> <20080904190728.59634020@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org> <20080904204305.GA29065@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904204305.GA29065@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +static unsigned long quick_pit_calibrate(void)
> +{
[...]
> +	if (pit_expect_msb(0xff)) {
> +		int i;
> +		u64 t1, t2, delta;
> +		unsigned char expect = 0xfe;
> +
> +		t1 = get_cycles();
> +		for (i = 0; i < QUICK_PIT_ITERATIONS; i++, expect--) {
> +			if (!pit_expect_msb(expect))
> +				goto failed;
> +		}
> +		t2 = get_cycles();

hm, unless i'm missing something i think here we still have a small 
window for an SMI or some virtualization delay to slip in and cause 
massive inaccuracy: if the delay happens _after_ the last 
pit_expect_msb() and _before_ the external get_cycles() call. Right?

i fixed that by adding one more pit_expect_msb() call.

plus i think QUICK_PIT_ITERATIONS is quite close to overflowing 255 
which is built into the u32 'expect' variable (the MSB will only 
overflow to 10 bits or so) - so i've added a BUILD_BUG_ON() to make sure 
anyone tuning QUICK_PIT_MS above 60msec or so would get a build error 
instead of some hard(er) to track down calibration error.

but it's getting late here so please double-check me ... The commit is 
below.

	Ingo

------------>
>From 40d2650256289d3ba59c4fd146b86b972db6ec40 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 4 Sep 2008 22:47:47 +0200
Subject: [PATCH] x86: quick TSC calibration, improve

- make sure the final TSC timestamp is reliable too

- make sure nobody increases QUICK_PIT_MS so that
  QUICK_PIT_ITERATIONS can get larger than 0xff, breaking the iteration.
  (It would take about 60 msecs to reach that limit.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/tsc.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 839070b..4832a40 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -304,6 +304,11 @@ static unsigned long quick_pit_calibrate(void)
 	outb(0xff, 0x42);
 	outb(0xff, 0x42);
 
+	/*
+	 * The iteration assumes that expect never goes below zero:
+	 */
+	BUILD_BUG_ON(QUICK_PIT_ITERATIONS >= 0xff);
+
 	if (pit_expect_msb(0xff)) {
 		int i;
 		u64 t1, t2, delta;
@@ -317,6 +322,12 @@ static unsigned long quick_pit_calibrate(void)
 		t2 = get_cycles();
 
 		/*
+		 * Make sure we can rely on the second TSC timestamp:
+		 */
+		if (!pit_expect_msb(--expect))
+			goto failed;
+
+		/*
 		 * Ok, if we get here, then we've seen the
 		 * MSB of the PIT decrement QUICK_PIT_ITERATIONS
 		 * times, and each MSB had many hits, so we never
