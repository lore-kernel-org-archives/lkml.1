Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbXHNHL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbXHNHL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 03:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbXHNHLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 03:11:20 -0400
Received: from mx12.go2.pl ([193.17.41.142]:37166 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750796AbXHNHLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 03:11:19 -0400
Date: Tue, 14 Aug 2007 09:12:03 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       "marcin\.slusarz" <marcin.slusarz@gmail.com>
Subject: Re: [patch 3/3] genirq: mark io_apic level interrupts to avoid resend
Message-ID: <20070814071203.GA1702@ff.dom.local>
References: <20070812152213.551812576@inhelltoy.tec.linutronix.de> <20070812152303.177006193@inhelltoy.tec.linutronix.de> <20070813112821.GA2863@ff.dom.local> <1187006835.12828.112.camel@chaos> <20070813135311.GB4026@ff.dom.local> <1187022620.12828.127.camel@chaos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187022620.12828.127.camel@chaos>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 06:30:20PM +0200, Thomas Gleixner wrote:
> On Mon, 2007-08-13 at 15:53 +0200, Jarek Poplawski wrote:
> > On Mon, Aug 13, 2007 at 02:07:15PM +0200, Thomas Gleixner wrote:
> > > On Mon, 2007-08-13 at 13:28 +0200, Jarek Poplawski wrote:
> > > > Maybe I miss something, but:
> > > > - why it's not done in other places with handle_level_irq or
> > > 
> > > I removed the PENDING bit magic in handle_level_irq, which was put there
> > > by a mismerge.
> > 
> > But, this flag is used in many "strange" places like e.g. autoprobe,
> > so, on any problems with this, we have to check them all...
> 
> No, the point is that the resend is suppressed for all interrupts which
> are marked with IRQ_LEVEL:
> 
>         /*
>          * We do not resend level type interrupts. Level type
>          * interrupts are resent by hardware when they are still
>          * active.
>          */
>         if ((status & (IRQ_LEVEL | IRQ_PENDING | IRQ_REPLAY)) == IRQ_PENDING) {
> 	....
> 
> This is not witchcraft, this is how the hardware works.

Sorry! It's probably something with my English: I like this flag very
much! But I simply can't find where this flag is set for any irq using
handle_level_irq, or, otherwise, can't understand why it's not set
(because in this case I don't think not setting IRQ_PENDING by the
handler should be enough).

> 
> > > It is quite clear what happened:
> > > 
> > > 1. The retrigger/resend mechanism was never meant to be used for level
> > > type interrupts and it makes absolutely no sense. When a level type
> > > interrupt is masked while active it is resent by hardware on unmask when
> > > it is still active. The resend / retrigger mechanism is only useful for
> > > edge type interrupts, because we would lose an interrupt when we mask it
> > > delayed without triggering a resend on unmask.
> > 
> > Of course, I think you are right with this, but:
> > - this patch was active for quite a long time and, if it was so wrong
> > there was astonishingly small number of similar problems;
> > - there where many changes in drivers done around similar problems,
> > so how can you guarantee, they will behave resonably after such serious
> > change again;
> > - this new way with levels is different from 2.6.21/22 and 2.6.20 too;
> > it was tested only on 2 x86_64 boxes mainly for network; it's really
> > not much considering the number of various quirks.
> 
> But it is not different from the original implementation before we
> introduced the delayed disable, simply because before the delayed
> disable change only edge type interrupts were ever resent.

It's different because e.g. for x86_64 fasteoi level type irqs were
masked during disable_irq, so there was very small probability any
irq were skipped, plus the state of io_apic was different from this
point (regarding this irq). Now it's for sure many interrupts could
be 'missing'.

BTW, of course, my knowledge of this is very limited, but I wonder
about these level type irqs used e.g. by apics. 'Normal' chips hold
some data until it's read by a driver, so there is something more
needed than an ack by io_apic. But isn't there any possibility
some level type irqs possible for IPIs or local interrupts (82489DX?)
could be missing here? Are we sure there is no hardware using level
type irqs in a similar way (drop after acking)?

> 
> > > There is nothing to confuse anymore. The resend for level type
> > > interrupts is not happening, which is the same behavior as we had before
> > > the delayed disable. The edge type interrupts resend is there since we
> > > did the big genirq changes (2.6.18) and it was tested on various boxen
> > > (including the above one) quite extensive.
> > > 
> > > The delayed disable was added later and unfortunately introduced the
> > > problems we've seen.
> > 
> > See my argument above... This is not 100% guarantee, and I think,
> 
> There is no 100% guarantee for any of the proposed changes.

That's why, sometimes, with such hard to predict changes there are
added some safety options or at least some debugging.

> 
> > there is no reason to endanger even a small number of users/admins
> > for stresses like this, done to Marcin or Jean-Baptiste, when it's
> > possible to do this safer without much changes.
> 
> Safer in what way ? 

Because, if there were a visible config option or kernel parameter
e.g.  with a comment like "legacy level irq handling - obsolete",
some people would be happy when they find it's useful for them, and
you would know about the problem much sooner, as well.

> 
> The alternative patches (including my first debug patch, which got
> merged during my vacation) are just pampering over the real problem
> instead of fixing it.
> 
> > As a matter of fact I think about still another possibility, which
> > wasn't tested at all: let's say there is this "new" (retriggered)
> > interrupt possible instantly after enable_irq in a place, which
> > earlier wasn't affected with this. So, e.g. network _xmit or
> > _timeout code for some drivers can be interrupted in a place which
> > was always "wrong" for this, but for some reasons, not very probable
> > to hit (before this resending patch). Then, maybe it's all wrong
> > only because this level resending works OK here, but uncovers weak,
> > not irq-safe  places? In such a case skipping resend and software
> > resend should be OK: sw resend could be blocked here by softirqs off.
> > Of course, this can be false idea as well, but since it wasn't checked
> > yet (plus maybe several other possibilities) - we should be rather
> > cautious here.
> 
> If there is code which gets affected by the removal of the useless
> resend of level type interrupts, then this code needs to be fixed and
> not a wrong behavior preserved for no good reason.

100% right! But this is only another example to show there could be
very complex and hard to debug problems around, even after doing
completely resonable changes in such a place.

Regards,
Jarek P.
