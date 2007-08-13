Return-Path: <linux-kernel-owner+w=401wt.eu-S1760460AbXHMPk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760460AbXHMPk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S941824AbXHMNwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 09:52:32 -0400
Received: from mx10.go2.pl ([193.17.41.74]:43207 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S941961AbXHMNw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 09:52:28 -0400
Date: Mon, 13 Aug 2007 15:53:11 +0200
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
Message-ID: <20070813135311.GB4026@ff.dom.local>
References: <20070812152213.551812576@inhelltoy.tec.linutronix.de> <20070812152303.177006193@inhelltoy.tec.linutronix.de> <20070813112821.GA2863@ff.dom.local> <1187006835.12828.112.camel@chaos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187006835.12828.112.camel@chaos>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 02:07:15PM +0200, Thomas Gleixner wrote:
> On Mon, 2007-08-13 at 13:28 +0200, Jarek Poplawski wrote:
> > Maybe I miss something, but:
> > - why it's not done in other places with handle_level_irq or
> 
> I removed the PENDING bit magic in handle_level_irq, which was put there
> by a mismerge.

But, this flag is used in many "strange" places like e.g. autoprobe,
so, on any problems with this, we have to check them all...

> 
> > handle_fasteoi_irq. Are we sure they can never get IRQ_PENDING flag
> > or we take the risk?
> 
> handle_fasteoi_irq is special. It is used by ioapic and weird Powerpc
> hardware. We marked the ioapic level interrupts IRQ_LEVEL, so we wont
> get a resend on them (see kernel/irq/resend.c)

I've thought e.g. about "fasteoi" for this "Virtual Wire" timer for
i386: I hope it's OK, but since is it any problem to add some comment
here, why it's OK with resending here (with POWERPC it's easier to
think it's something special, but here we have to similar things in
the same file)?

> 
> > - what about e.g. handle_simple_irq: do we think it needs resending
> > or simply going to wait for good bug reports?
> 
> Oops. I missed that one. I'll have a look at that as well.
> 
> > - is this .status cleared enough on free_irq or during request_irq?
> 
> AFAICT, there is no danger.

Maybe no reason to risk, too.

> 
> > BTW, of course something like this set of patches was needed here,
> > but I still think this shouldn't be done this way: the bug wasn't
> > diagnosed nor tested enough, some chips are suspected, and
> > nevertheless the change is done for everybody, whithout any
> > possibility to set this back for people who had no problems with
> > 2.6.21 and 2.6.22 (at least for some transition time). 
> 
> It is quite clear what happened:
> 
> 1. The retrigger/resend mechanism was never meant to be used for level
> type interrupts and it makes absolutely no sense. When a level type
> interrupt is masked while active it is resent by hardware on unmask when
> it is still active. The resend / retrigger mechanism is only useful for
> edge type interrupts, because we would lose an interrupt when we mask it
> delayed without triggering a resend on unmask.

Of course, I think you are right with this, but:
- this patch was active for quite a long time and, if it was so wrong
there was astonishingly small number of similar problems;
- there where many changes in drivers done around similar problems,
so how can you guarantee, they will behave resonably after such serious
change again;
- this new way with levels is different from 2.6.21/22 and 2.6.20 too;
it was tested only on 2 x86_64 boxes mainly for network; it's really
not much considering the number of various quirks.

> 
> 2. I found a box similar to Marcins which gets confused when level type
> interrupts are resent.

So, we can only be sure boxes similar to Marcin's are safe now...

> 
> > Maybe some
> > other chips get confused now, and we get some notice of this maybe
> > only in 2.6.25, if we'are lucky enough to have somebody like Marcin
> > around to do the next git bisection?
> 
> There is nothing to confuse anymore. The resend for level type
> interrupts is not happening, which is the same behavior as we had before
> the delayed disable. The edge type interrupts resend is there since we
> did the big genirq changes (2.6.18) and it was tested on various boxen
> (including the above one) quite extensive.
> 
> The delayed disable was added later and unfortunately introduced the
> problems we've seen.

See my argument above... This is not 100% guarantee, and I think,
there is no reason to endanger even a small number of users/admins
for stresses like this, done to Marcin or Jean-Baptiste, when it's
possible to do this safer without much changes.

As a matter of fact I think about still another possibility, which
wasn't tested at all: let's say there is this "new" (retriggered)
interrupt possible instantly after enable_irq in a place, which
earlier wasn't affected with this. So, e.g. network _xmit or
_timeout code for some drivers can be interrupted in a place which
was always "wrong" for this, but for some reasons, not very probable
to hit (before this resending patch). Then, maybe it's all wrong
only because this level resending works OK here, but uncovers weak,
not irq-safe  places? In such a case skipping resend and software
resend should be OK: sw resend could be blocked here by softirqs off.
Of course, this can be false idea as well, but since it wasn't checked
yet (plus maybe several other possibilities) - we should be rather
cautious here.

Cheers,
Jarek P.
