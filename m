Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbYAASw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbYAASw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 13:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbYAASwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 13:52:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57499 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbYAASwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 13:52:19 -0500
Date: Tue, 1 Jan 2008 19:45:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "David P. Reed" <dpreed@reed.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@gmail.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20080101184524.GA6655@elte.hu>
References: <4765DCB0.8030901@gmail.com> <4765EE7F.80002@zytor.com> <47667366.7010405@gmail.com> <4766AE88.4080904@zytor.com> <4766D175.7040807@reed.com> <20071217212509.5edaa372@the-village.bc.nu> <477A634C.8040000@reed.com> <20080101161557.3ce2d5f8@the-village.bc.nu> <20080101164338.GA901@elte.hu> <20080101173212.1bba4939@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101173212.1bba4939@the-village.bc.nu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > there strong counter-arguments against doing the clean thing and 
> > adding an udelay(2) (or udelay(1)) to replace those _p() uses in ISA 
> > drivers?
> 
> #1 udelay has to be for the worst case bus clock (6MHz) while the 
> #device may be at 10Mhz or even 12MHz ISA. So it slows it down stuff
> unneccessarily- and stuff that really really is slow enough as is.

udelay is supposed to be reliable. If someone runs a new kernel and has 
no TSC (which might happen even on modern hardware or with notsc) _and_ 
finds that udelay is not calibrated well enough then that's a kernel bug 
we want to fix.

> #2 Most of the ancient wind up relics with ISA bus don't have a tsc so
> their udelay value is kind of iffy.

iffy in what way? Again, we might be hiding real udelay bugs.

> #3 Not changing it is the lowest risk for a lot of the old ISA code 
> #that never occurs on newer boxes

Not changing the kernel _at all_ is what is the "lowest risk" option. If 
the kernel is changed, it should be tested - and if we have a buggy 
udelay, that should be fixed - because it could cause many other bugs in 
other drivers.

yes, there are always risks in changing something, but using udelay is a 
common-sense consolidation of code.

> > _will_ change a bit, no matter what we do. Alignments change, the 
> > compiler output will change (old compilers get deprecated so a new 
> > compiler might have to be picked), cache effects change - and this 
> > is inevitable. The important thing is to not eliminate the delays - 
> > but we sure dont have to keep them cycle accurate (we couldnt even 
> > if we wanted to). The only way to get the _exact same_ behavior is 
> > to not change the kernel at all.
> 
> ISA bus cycles are *slow*, the subtle processor cache and gcc 
> triggered timing changes are lost in the noise.

gcc triggered timing changes can easily add up to a LOT more - 
especially if a loop is involved and especially on older hardware. 
Remember, 1 microsecond is just a handful of instructions on real old 
hardware. The kernel's timings are _not_ immutable, never were, never 
will be.

	Ingo
