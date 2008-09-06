Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbYIFWkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbYIFWkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 18:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbYIFWkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 18:40:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50802 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbYIFWkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 18:40:36 -0400
Date: Sun, 7 Sep 2008 00:40:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Alok Kataria <akataria@vmware.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Dan Hecht <dhecht@vmware.com>,
       Garrett Smith <garrett@vmware.com>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
Message-ID: <20080906224016.GA9229@elte.hu>
References: <20080904205236.GA3864@elte.hu> <alpine.LFD.1.10.0809041403450.3117@nehalem.linux-foundation.org> <20080904213350.GA15678@elte.hu> <1220653095.14401.72.camel@alok-dev1> <alpine.LFD.1.10.0809051522410.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809061803470.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809061328400.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809062233500.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809061347120.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809061351170.3117@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809061351170.3117@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> "expect" is an unsigned char. There are absolutely _zero_ issues with 
> overflow, underflow, random phases of the moon, madness levels or 
> anything else. But yes, it does look like Ingo screwed up when adding 
> that final check, since expect was already decremented at the end of 
> the loop.
> 
> Ingo? Did you actually test it?

hm, yes, that's my brown paper bag fault, sorry.

I did that addition in tip/x86/tsc and posted it to you and i did test 
it immediately - and i noticed that i never saw the fast-calibration 
message i expected to see. I even pasted the boot log over irc yesterday 
and i still have it:

 *> [  0.000] TSC: PIT calibration deviates from PMTIMER: 738839 846296.
 *> [  0.000] TSC: Using PIT calibration value
 *> [  0.000] Detected 738.839 MHz processor.
 *> does not seem to trigger anywhere

i wanted to debug that problem straight after i worked down my 800+ 
mails post-vacation mbox :-/ Which state i reached about 2 hours ago so 
i'm now free - the fix is below.

i _think_ that the quality of calibration should now be pretty OK with 
latest -git. The clever fast calibration stuff could be .28 material. 

And/or we could change the 5x 50msec calibration to 3x 30msec right now, 
the precision is still plenty and the 90 msec is then replaced with your 
fast-calibrate method anyway on proper boxes. Hm?

	Ingo

------------------->
>From 5df45515512436a808d3476a90e83f2efb022422 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 6 Sep 2008 23:55:40 +0200
Subject: [PATCH] x86, tsc calibration: fix

my brown paperbag day ...

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/tsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 6dab90f..4847a92 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -319,7 +319,7 @@ static unsigned long quick_pit_calibrate(void)
 		/*
 		 * Make sure we can rely on the second TSC timestamp:
 		 */
-		if (!pit_expect_msb(--expect))
+		if (!pit_expect_msb(expect))
 			goto failed;
 
 		/*
