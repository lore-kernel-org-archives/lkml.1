Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYGALFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYGALFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 07:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYGALFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 07:05:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44672 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbYGALE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 07:04:59 -0400
Date: Tue, 1 Jul 2008 13:04:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel <linux-kernel@vger.kernel.org>,
       florian.fainelli@telecomint.eu,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH RFC] x86: Add user configurable GPIO-lib support
Message-ID: <20080701110436.GA32365@elte.hu>
References: <200807011249.40551.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807011249.40551.mb@bu3sch.de>
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


* Michael Buesch <mb@bu3sch.de> wrote:

> So this adds user-configurable GPIO support through gpiolib on 
> subarchitectures that do not implement a GPIO implementation, yet. 
> Currently that's everything except X86_RDC321X.
> 
> The advantage of this is to make it possible to use generic PCI (or 
> other bus) GPIO extention cards in standard PCs through the standard 
> GPIO API.
> 
> If another subarch implements its own GPIO, it needs to add itself as 
> an inverted dependency to GPIO_USERSELECTION to make sure the user 
> does not enable two GPIO API implementations.
> 
> About the asm-x86/gpio.h:
> I'm not sure what this <gpio.h> include currently is.
> Can somebody explain that to me? Where is this supposed
> to include a gpio.h file from?
> 
> What's your opinion on this?

( i've Cc:-ed Florian on this who's maintaining the RDC R-321X bits. )

The longer-term goal is that we'd like to remove the explicit RDC 
sub-arch and just support such systems out of box on x86.

We are almost there - Florian already moved a few special drivers out of 
arch/x86, the only missing piece is this complication in 
include/asm-x86/timex.h:

 #ifdef CONFIG_X86_ELAN
 #  define PIT_TICK_RATE 1189200 /* AMD Elan has different frequency! */
 #elif defined(CONFIG_X86_RDC321X)
 #  define PIT_TICK_RATE 1041667 /* Underlying HZ for R8610 */
 #else
 #  define PIT_TICK_RATE 1193182 /* Underlying HZ */
 #endif

... once that is made dynamic/quirkable we are there.

And we could even remove the AMD Elan subarch that way: AFAICS it's a 
486 compatible with an A20 quirk and this PIT_TICK quirk.

... and if we do that we'll also remove these:

        select GENERIC_GPIO
        select LEDS_CLASS
        select LEDS_GPIO
        select NEW_LEDS

... and thus perhaps your GPIO_USERSELECTION patch should move into 
drivers/ and be generally accessible, not special to x86?

	Ingo
