Return-Path: <linux-kernel-owner+w=401wt.eu-S1763170AbXHMOs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763170AbXHMOs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758325AbXHMMHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 08:07:24 -0400
Received: from www.osadl.org ([213.239.205.134]:46048 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S945008AbXHMMHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 08:07:18 -0400
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
In-Reply-To: <20070813112821.GA2863@ff.dom.local>
References: <20070812152213.551812576@inhelltoy.tec.linutronix.de>
	 <20070812152303.177006193@inhelltoy.tec.linutronix.de>
	 <20070813112821.GA2863@ff.dom.local>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 14:07:15 +0200
Message-Id: <1187006835.12828.112.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 13:28 +0200, Jarek Poplawski wrote:
> Maybe I miss something, but:
> - why it's not done in other places with handle_level_irq or

I removed the PENDING bit magic in handle_level_irq, which was put there
by a mismerge.

> handle_fasteoi_irq. Are we sure they can never get IRQ_PENDING flag
> or we take the risk?

handle_fasteoi_irq is special. It is used by ioapic and weird Powerpc
hardware. We marked the ioapic level interrupts IRQ_LEVEL, so we wont
get a resend on them (see kernel/irq/resend.c)

> - what about e.g. handle_simple_irq: do we think it needs resending
> or simply going to wait for good bug reports?

Oops. I missed that one. I'll have a look at that as well.

> - is this .status cleared enough on free_irq or during request_irq?

AFAICT, there is no danger.

> BTW, of course something like this set of patches was needed here,
> but I still think this shouldn't be done this way: the bug wasn't
> diagnosed nor tested enough, some chips are suspected, and
> nevertheless the change is done for everybody, whithout any
> possibility to set this back for people who had no problems with
> 2.6.21 and 2.6.22 (at least for some transition time). 

It is quite clear what happened:

1. The retrigger/resend mechanism was never meant to be used for level
type interrupts and it makes absolutely no sense. When a level type
interrupt is masked while active it is resent by hardware on unmask when
it is still active. The resend / retrigger mechanism is only useful for
edge type interrupts, because we would lose an interrupt when we mask it
delayed without triggering a resend on unmask.

2. I found a box similar to Marcins which gets confused when level type
interrupts are resent.

> Maybe some
> other chips get confused now, and we get some notice of this maybe
> only in 2.6.25, if we'are lucky enough to have somebody like Marcin
> around to do the next git bisection?

There is nothing to confuse anymore. The resend for level type
interrupts is not happening, which is the same behavior as we had before
the delayed disable. The edge type interrupts resend is there since we
did the big genirq changes (2.6.18) and it was tested on various boxen
(including the above one) quite extensive.

The delayed disable was added later and unfortunately introduced the
problems we've seen.

	tglx


