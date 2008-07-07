Return-Path: <linux-kernel-owner+w=401wt.eu-S1759085AbYGGWJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085AbYGGWJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbYGGWJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:09:07 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63300 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754502AbYGGWJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:09:06 -0400
Date: Mon, 7 Jul 2008 23:08:57 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Q] Is 64bit LVTT screwed
In-Reply-To: <20080702184024.GC7003@cvg>
Message-ID: <Pine.LNX.4.55.0807072243410.20615@cliff.in.clinika.pl>
References: <20080702184024.GC7003@cvg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008, Cyrill Gorcunov wrote:

> while I'm in path of unification apic code I found a bit
> strange code snippet
> 
> apic_32.c
> ---------
> #define APIC_DIVISOR 16
> static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
> {
> 	...
> 	if (!oneshot)
> 		apic_write_around(APIC_TMICT, clocks / APIC_DIVISOR);
> 
> }
> 
> apic_64.c
> ---------
> static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
> {
>         ...
> 	if (!oneshot)
> 		apic_write_around(APIC_TMICT, clocks);
> }
> 
> but in both cases we use "divide by 16" in divide register. The only
> explanation I imagine - for 64bit mode we are required to 'stuck'
> for a bit longer (by 16 times longer to be precise). Am I right?
> Or there is another reason why we dont use APIC_DIVISOR here. Actually,
> as I see it not fair to a caller. For 64bit mode APIC timer is requested
> to count 250000000 ticks but in real it will count 250000000 * 16.
> Not sure who is right there. I think the better would be to
> use 4000000000 and APIC_DIVISOR in 64bit mode. How do you think?

 The APIC clock varies across systems so the timer setup includes
calibration.  Which means both variations end up with the correct
interrupt rate probably, except using different divisors.  We used to
print the APIC clock rate and that would be off with one of the above, but
I don't we do this anymore.  We had a similar problem with the 82489DX
where the prescaler was bypassed altogether resulting in an incorrect 
clock rate printed, but the rate of timer interrupt was correctly 
calibrated regardless.

 This is of course merely an explanation why the code you quoted does not
explode spectacularly.  It does not make it correct.  If the prescaler is
indeed set to 16 for 64-bit systems, then APIC_DIVISOR should obviously be
used in the calculation above too.  And if not, then I think the prescaler 
should be set consistently across systems and then the setting reflected 
in the calculations accordingly.  Please note that only values between 2 
and 16 are supported in a uniform way across all the APIC models and using 
low values risks an overflow as clock rates are in the GHz range these 
days already.  The value of 16 seems a reasonable one.

  Maciej
