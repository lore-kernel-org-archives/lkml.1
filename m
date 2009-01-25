Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbZAYQBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbZAYQBS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 11:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbZAYQBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 11:01:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52107 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbZAYQBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 11:01:02 -0500
Date: Sun, 25 Jan 2009 17:00:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: john stultz <johnstul@us.ibm.com>, Miklos Vajna <vmiklos@frugalware.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Gabriel C <nix.or.die@googlemail.com>,
       =?iso-8859-1?Q?CS=C9CSY_L=E1szl=F3?= <boobaa@frugalware.org>,
       r.schwebel@pengutronix.de, sven@geggus.net
Subject: Re: System clock runs too fast after 2.6.27 -> 2.6.28.1 upgrade
Message-ID: <20090125160019.GA21455@elte.hu>
References: <20090121171423.GI21473@genesis.frugalware.org> <200901251218.33255.florian.fainelli@telecomint.eu> <20090125150349.GB19168@elte.hu> <200901251638.34040.florian.fainelli@telecomint.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901251638.34040.florian.fainelli@telecomint.eu>
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


* Florian Fainelli <florian.fainelli@telecomint.eu> wrote:

> Le Sunday 25 January 2009 16:03:49 Ingo Molnar, vous avez écrit :
> > * Florian Fainelli <florian.fainelli@telecomint.eu> wrote:
> > > Le Saturday 24 January 2009 10:14:04 Ingo Molnar, vous avez écrit :
> > > > * john stultz <johnstul@us.ibm.com> wrote:
> > > > > On Fri, Jan 23, 2009 at 3:04 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > > > > > * john stultz <johnstul@us.ibm.com> wrote:
> > > > > >> I'd think this would ideally be more of a subarch in the config
> > > > > >> selection like the AMD Elan is, so folks know it really is not
> > > > > >> just a extra-support feature and in fact limits what hardware you
> > > > > >> can use the resulting kernel on.
> > > > > >
> > > > > > a better solution is that if RDC is set [it is unset by default] we
> > > > > > should turn PIT_TICK_RATE into a variable, defaulting it to
> > > > > > 1193182. If a real RDC or ELAN system is running, that variable is
> > > > > > changed during early bootup, in the init functions for those
> > > > > > platforms.
> > > > >
> > > > > Took a quick look at this, and I don't see any detection code for
> > > > > either RDC. The X86_ELAN config also has no conditionals, but maybe
> > > > > the elan cpufreq code can help here.
> > > >
> > > > i'd suggest to just remove the #ifdef for now (it's causing problems)
> > > > and add the variable - we can add the quirks for those two platforms
> > > > later on, separately from your patch(es).
> > >
> > > Fine with me. Ingo, is there any infrastructure yet to get an early
> > > quirk set the PIT tick rate accordingly ?
> >
> > Not yet but it should be easy - do you have the time to implement it?
> 
> Not until a week, sorry.

ok - i've done the interim patch below. Please send a quirk patch for 
RDC's non-standard PIT frequency.

	Ingo

------------------->
>From e1b4d1143651fb3838be1117785b6e0386fa151f Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 25 Jan 2009 16:57:00 +0100
Subject: [PATCH] x86: use standard PIT frequency

the RDC and ELAN platforms use slighly different PIT clocks, resulting in
a timex.h hack that changes PIT_TICK_RATE during build time. But if a
tester enables any of these platform support .config options, the PIT
will be miscalibrated on standard PC platforms.

So use one frequency - in a subsequent patch we'll add a quirk to allow
x86 platforms to define different PIT frequencies.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/timex.h |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/timex.h b/arch/x86/include/asm/timex.h
index 1287dc1..b5c9d45 100644
--- a/arch/x86/include/asm/timex.h
+++ b/arch/x86/include/asm/timex.h
@@ -1,18 +1,13 @@
-/* x86 architecture timex specifications */
 #ifndef _ASM_X86_TIMEX_H
 #define _ASM_X86_TIMEX_H
 
 #include <asm/processor.h>
 #include <asm/tsc.h>
 
-#ifdef CONFIG_X86_ELAN
-#  define PIT_TICK_RATE 1189200 /* AMD Elan has different frequency! */
-#elif defined(CONFIG_X86_RDC321X)
-#  define PIT_TICK_RATE 1041667 /* Underlying HZ for R8610 */
-#else
-#  define PIT_TICK_RATE 1193182 /* Underlying HZ */
-#endif
-#define CLOCK_TICK_RATE	PIT_TICK_RATE
+/* The PIT ticks at this frequency (in HZ): */
+#define PIT_TICK_RATE		1193182
+
+#define CLOCK_TICK_RATE		PIT_TICK_RATE
 
 #define ARCH_HAS_READ_CURRENT_TIMER
 
