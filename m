Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbZFXPNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbZFXPNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 11:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbZFXPNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 11:13:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39806 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbZFXPNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 11:13:07 -0400
Date: Wed, 24 Jun 2009 17:13:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: PREEMPT_ACTIVE too low error with all asm-generic headers for
	some arches
Message-ID: <20090624151302.GA15037@elte.hu>
References: <8bd0f97a0906231508s4c115d3dr2848626bc5a28c5e@mail.gmail.com> <20090624131357.GA6224@elte.hu> <200906241602.38422.arnd@arndb.de> <8bd0f97a0906240802ieec96fav2864fa199d3f1b90@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0906240802ieec96fav2864fa199d3f1b90@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Wed, Jun 24, 2009 at 10:02, Arnd Bergmann wrote:
> > On Wednesday 24 June 2009, Ingo Molnar wrote:
> >> * Mike Frysinger <vapier.adi@gmail.com> wrote:
> >> > if we look at linux/hardirq.h, it makes this claim:
> >> >  * - bit 28 is the PREEMPT_ACTIVE flag
> >> > if that's true, then why are we letting any arch set this define ?  a
> >> > quick survey shows that half the arches (11) are using 0x10000000 (bit
> >> > 28) while the other half (10) are using 0x4000000 (bit 26).  and then
> >> > there is the ia64 oddity which uses bit 30.  the exact value here
> >> > shouldnt really matter across arches though should it ?
> >
> > actually alpha, arm and avr32 also use bit 30 (0x40000000), there are only
> > five (or eight, depending on how you count) architectures (blackfin, h8300,
> > m68k, s390 and sparc) using bit 26.
> 
> meh, too many zeros ;)
> 
> >> Correct - what matters is to have no collision between the fields.
> >>
> >> > how about adding this to linux/thread_info.h:
> >> > #ifndef PREEMPT_ACTIVE
> >> > # ifndef PREEMPT_ACTIVE_BIT
> >> > #  define PREEMPT_ACTIVE_BIT 28
> >> > # endif
> >> > # define PREEMPT_ACTIVE (1 << PREEMPT_ACTIVE_BIT)
> >> > #endif
> >>
> >> Makes sense i guess - but do we really need that level of
> >> #ifdef nesting? PREEMPT_ACTIVE_BIT should be the main control - with
> >> a default to 28 if it's not set. PREEMPT_ACTIVE is then derived off
> >> that, without any #ifdefs.
> >
> > I think it would fit better into linux/hardirq.h instead of
> > linux/thread_info.h, because that is where the other bits of
> > the preempt count are defined.
> 
> agreed
> 
> > --- a/include/linux/hardirq.h
> > +++ b/include/linux/hardirq.h
> > @@ -62,6 +62,12 @@
> >  #define HARDIRQ_OFFSET (1UL << HARDIRQ_SHIFT)
> >  #define NMI_OFFSET     (1UL << NMI_SHIFT)
> >
> > +#ifndef PREEMPT_ACTIVE
> > +#define PREEMPT_ACTIVE_BITS    1
> > +#define PREEMPT_ACTIVE_SHIFT   (NMI_SHIFT + NMI_BITS)
> > +#define PREEMPT_ACTIVE (__IRQ_MASK(PREEMPT_ACTIVE_BITS) << PREEMPT_SHIFT)
> 
> i think you meant "<< PREEMPT_ACTIVE_SHIFT" there.  once i make 
> that change, it builds fine.

With that fix:

 Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
