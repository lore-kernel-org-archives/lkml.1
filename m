Return-Path: <linux-kernel-owner+w=401wt.eu-S946618AbXHMQ63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946618AbXHMQ63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031128AbXHMQa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:30:29 -0400
Received: from www.osadl.org ([213.239.205.134]:48847 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934657AbXHMQaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:30:25 -0400
Subject: Re: [patch 3/3] genirq: mark io_apic level interrupts to avoid
	resend
From: Thomas Gleixner <tglx@linutronix.de>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       "marcin.slusarz" <marcin.slusarz@gmail.com>
In-Reply-To: <20070813135311.GB4026@ff.dom.local>
References: <20070812152213.551812576@inhelltoy.tec.linutronix.de>
	 <20070812152303.177006193@inhelltoy.tec.linutronix.de>
	 <20070813112821.GA2863@ff.dom.local> <1187006835.12828.112.camel@chaos>
	 <20070813135311.GB4026@ff.dom.local>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 18:30:20 +0200
Message-Id: <1187022620.12828.127.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 15:53 +0200, Jarek Poplawski wrote:
> On Mon, Aug 13, 2007 at 02:07:15PM +0200, Thomas Gleixner wrote:
> > On Mon, 2007-08-13 at 13:28 +0200, Jarek Poplawski wrote:
> > > Maybe I miss something, but:
> > > - why it's not done in other places with handle_level_irq or
> > 
> > I removed the PENDING bit magic in handle_level_irq, which was put there
> > by a mismerge.
> 
> But, this flag is used in many "strange" places like e.g. autoprobe,
> so, on any problems with this, we have to check them all...

No, the point is that the resend is suppressed for all interrupts which
are marked with IRQ_LEVEL:

        /*
         * We do not resend level type interrupts. Level type
         * interrupts are resent by hardware when they are still
         * active.
         */
        if ((status & (IRQ_LEVEL | IRQ_PENDING | IRQ_REPLAY)) == IRQ_PENDING) {
	....

This is not witchcraft, this is how the hardware works.

> > It is quite clear what happened:
> > 
> > 1. The retrigger/resend mechanism was never meant to be used for level
> > type interrupts and it makes absolutely no sense. When a level type
> > interrupt is masked while active it is resent by hardware on unmask when
> > it is still active. The resend / retrigger mechanism is only useful for
> > edge type interrupts, because we would lose an interrupt when we mask it
> > delayed without triggering a resend on unmask.
> 
> Of course, I think you are right with this, but:
> - this patch was active for quite a long time and, if it was so wrong
> there was astonishingly small number of similar problems;
> - there where many changes in drivers done around similar problems,
> so how can you guarantee, they will behave resonably after such serious
> change again;
> - this new way with levels is different from 2.6.21/22 and 2.6.20 too;
> it was tested only on 2 x86_64 boxes mainly for network; it's really
> not much considering the number of various quirks.

But it is not different from the original implementation before we
introduced the delayed disable, simply because before the delayed
disable change only edge type interrupts were ever resent.

> > There is nothing to confuse anymore. The resend for level type
> > interrupts is not happening, which is the same behavior as we had before
> > the delayed disable. The edge type interrupts resend is there since we
> > did the big genirq changes (2.6.18) and it was tested on various boxen
> > (including the above one) quite extensive.
> > 
> > The delayed disable was added later and unfortunately introduced the
> > problems we've seen.
> 
> See my argument above... This is not 100% guarantee, and I think,

There is no 100% guarantee for any of the proposed changes.

> there is no reason to endanger even a small number of users/admins
> for stresses like this, done to Marcin or Jean-Baptiste, when it's
> possible to do this safer without much changes.

Safer in what way ? 

The alternative patches (including my first debug patch, which got
merged during my vacation) are just pampering over the real problem
instead of fixing it.

> As a matter of fact I think about still another possibility, which
> wasn't tested at all: let's say there is this "new" (retriggered)
> interrupt possible instantly after enable_irq in a place, which
> earlier wasn't affected with this. So, e.g. network _xmit or
> _timeout code for some drivers can be interrupted in a place which
> was always "wrong" for this, but for some reasons, not very probable
> to hit (before this resending patch). Then, maybe it's all wrong
> only because this level resending works OK here, but uncovers weak,
> not irq-safe  places? In such a case skipping resend and software
> resend should be OK: sw resend could be blocked here by softirqs off.
> Of course, this can be false idea as well, but since it wasn't checked
> yet (plus maybe several other possibilities) - we should be rather
> cautious here.

If there is code which gets affected by the removal of the useless
resend of level type interrupts, then this code needs to be fixed and
not a wrong behavior preserved for no good reason.

	tglx


