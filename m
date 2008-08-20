Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbYHTLU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbYHTLU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 07:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbYHTLUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 07:20:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40178 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbYHTLUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 07:20:45 -0400
Date: Wed, 20 Aug 2008 13:20:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Juergen Beisert <jbe@pengutronix.de>
Cc: Samuel Sieb <samuel@sieb.net>, linux-kernel@vger.kernel.org,
       "Rafael C. de Almeida" <almeidaraf@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Magnus Damm <magnus@valinux.co.jp>, takada <takada@mbf.nifty.com>
Subject: Re: kernel won't boot on a Cyrix MediaGXm (Geode )
Message-ID: <20080820112025.GA24067@elte.hu>
References: <48841A92.4020301@sieb.net> <200808201144.02919.jbe@pengutronix.de> <20080820104538.GF2816@elte.hu> <200808201304.00956.jbe@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808201304.00956.jbe@pengutronix.de>
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


* Juergen Beisert <jbe@pengutronix.de> wrote:

> On Mittwoch, 20. August 2008, Ingo Molnar wrote:
> > * Juergen Beisert <jbe@pengutronix.de> wrote:
> > > On Mittwoch, 20. August 2008, Ingo Molnar wrote:
> > > > * Samuel Sieb <samuel@sieb.net> wrote:
> > > > > Ingo Molnar wrote:
> > > > >> any patch we should pick up to make your box boot?
> > > > >
> > > > > I've looked through various datasheets and found that the GXm and
> > > > > GXLV Geode processors don't have an incrementor.  I attached two
> > > > > patches. One only calls the incrementor setup for GX1 or better.  The
> > > > > other one removes the incrementor setup entirely.  As the incrementor
> > > > > value differs according to clock speed and we would hope that the
> > > > > BIOS configures it correctly, it is probably the better one to
> > > > > choose.  But I will leave that choice up to you.  Either one works
> > > > > for me. :-)
> > > >
> > > > i went for the commit below and queued it up in tip/x86/urgent - thanks
> > > > Samuel.
> > > >
> > > > what happens if the incrementor is not set up correctly by the BIOS
> > >
> > > The system can freeze. The clock the incrementor modifies is used for
> > > the external SDRAM (something like a delay line or jitter reduction).
> > > Thats why its setting depends on the core clock speed.
> >
> > so, what's the recommendation - is the patch fine? (which removes
> > incrementor setting, leaving it to the BIOS)
> 
> In my environment I need the incrementor setting in accordance to the 
> CPU core frequency, as my BIOS sets a wrong value. Removing it is no 
> solution for me.
> 
> But: There where a few bug reports in the last weeks, and all had 
> problems when the incrementor setting is changed inside the kernel. 
> Seems only my BIOS is broken.
> 
> So I vote for removing the incrementor setting. I can life with a 
> local patch for my kernels.

is there any way to specifically identify your board/bios combo, like a 
DMI string? I have absolutely no problem with adding a quirk for your 
box. In fact i'd much prefer that solution than you having to carry a 
local patch - quirks are local only in the rarest of circumstances.

Mind doing a quirk patch ontop of the patch below, for us to apply for 
v2.6.27?

	Ingo

----------------->
>From c6744955d0ec0cb485c28c51eeb7185e260f6172 Mon Sep 17 00:00:00 2001
From: Samuel Sieb <samuel@sieb.net>
Date: Wed, 6 Aug 2008 22:06:29 -0700
Subject: [PATCH] x86: fix "kernel won't boot on a Cyrix MediaGXm (Geode)"

Cyrix MediaGXm/Cx5530 Unicorn Revision 1.19.3B has stopped
booting starting at v2.6.22.

The reason is this commit:

> commit f25f64ed5bd3c2932493681bdfdb483ea707da0a
> Author: Juergen Beisert <juergen@kreuzholzen.de>
> Date:   Sun Jul 22 11:12:38 2007 +0200
>
>     x86: Replace NSC/Cyrix specific chipset access macros by inlined functions.

this commit activated a macro which was dormant before due to (buggy)
macro side-effects.

I've looked through various datasheets and found that the GXm and GXLV
Geode processors don't have an incrementor.

Remove the incrementor setup entirely.  As the incrementor value
differs according to clock speed and we would hope that the BIOS
configures it correctly, it is probably the right solution.

Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/cyrix.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 3fd7a67..e710a21 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -134,23 +134,6 @@ static void __cpuinit set_cx86_memwb(void)
 	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x14);
 }
 
-static void __cpuinit set_cx86_inc(void)
-{
-	unsigned char ccr3;
-
-	printk(KERN_INFO "Enable Incrementor on Cyrix/NSC processor.\n");
-
-	ccr3 = getCx86(CX86_CCR3);
-	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10); /* enable MAPEN */
-	/* PCR1 -- Performance Control */
-	/* Incrementor on, whatever that is */
-	setCx86(CX86_PCR1, getCx86(CX86_PCR1) | 0x02);
-	/* PCR0 -- Performance Control */
-	/* Incrementor Margin 10 */
-	setCx86(CX86_PCR0, getCx86(CX86_PCR0) | 0x04);
-	setCx86(CX86_CCR3, ccr3);	/* disable MAPEN */
-}
-
 /*
  *	Configure later MediaGX and/or Geode processor.
  */
@@ -174,7 +157,6 @@ static void __cpuinit geode_configure(void)
 
 	set_cx86_memwb();
 	set_cx86_reorder();
-	set_cx86_inc();
 
 	local_irq_restore(flags);
 }
