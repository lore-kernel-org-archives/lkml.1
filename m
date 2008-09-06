Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbYIFU63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbYIFU63 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 16:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYIFU6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 16:58:21 -0400
Received: from www.tglx.de ([62.245.132.106]:46726 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbYIFU6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 16:58:21 -0400
Date: Sat, 6 Sep 2008 22:58:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alok Kataria <akataria@vmware.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Dan Hecht <dhecht@vmware.com>,
       Garrett Smith <garrett@vmware.com>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
In-Reply-To: <alpine.LFD.1.10.0809061347120.3117@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809062253030.3243@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>  <20080904160036.GA18382@elte.hu>  <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org> 
 <20080904190728.59634020@lxorguk.ukuu.org.uk>  <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org>  <20080904204305.GA29065@elte.hu> <20080904205236.GA3864@elte.hu> 
 <alpine.LFD.1.10.0809041403450.3117@nehalem.linux-foundation.org>  <20080904213350.GA15678@elte.hu> <1220653095.14401.72.camel@alok-dev1> <alpine.LFD.1.10.0809051522410.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809061803470.3243@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0809061328400.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809062233500.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809061347120.3117@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Sep 2008, Linus Torvalds wrote:

> 
> 
> On Sat, 6 Sep 2008, Thomas Gleixner wrote:
> > 
> > Just checked. The -tip version still has the expect-- in the for()
> > which might lead to stupid results depending on the gcc madness level.
> 
> Umm. What? You're on some odd drugs.

Just straight forward german beer :)
 
 
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 6dab90f..3bfe083 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -310,8 +310,8 @@ static unsigned long quick_pit_calibrate(void)
 		unsigned char expect = 0xfe;
 
 		t1 = get_cycles();
		for (i = 0; i < QUICK_PIT_ITERATIONS; i++, expect--) {
			if (!pit_expect_msb(expect))
 				goto failed;
 		}
 		t2 = get_cycles();

 		/*
 		 * Make sure we can rely on the second TSC timestamp:
 		 */
		if (!pit_expect_msb(--expect))
 			goto failed;
 
Where is a guarantee, that excpect is not decremented before we break
out of the loop ? 

the "expect--" can be done _BEFORE_ the i < QUICK_PIT_ITERATIONS
evaluation. Not likely, but ...

This version works always

 		t1 = get_cycles();
		for (i = 0; i < QUICK_PIT_ITERATIONS; i++) {
			if (!pit_expect_msb(expect--))
 				goto failed;
 		}
 		t2 = get_cycles();

 		/*
 		 * Make sure we can rely on the second TSC timestamp:
 		 */

		if (!pit_expect_msb(expect))
 			goto failed;

Thanks,

	tglx
