Return-Path: <linux-kernel-owner+w=401wt.eu-S1764822AbXHFKs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764822AbXHFKs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763771AbXHFKsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:48:20 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:40553 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755671AbXHFKsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:48:17 -0400
Date: Mon, 6 Aug 2007 19:46:44 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] genirq: support multiple interrupt priorities
Message-ID: <20070806104644.GA4815@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel@vger.kernel.org
References: <20070806103027.GA4624@linux-sh.org> <20070806103609.GA17495@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806103609.GA17495@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2007 at 12:36:09PM +0200, Ingo Molnar wrote:
> * Paul Mundt <lethal@linux-sh.org> wrote:
> > This is a simple patch for adding trivial interrupt priority support.
> > 
> > I've added a ->set_prio() to the irq_chip which is implemented 
> > effectively the same way as ->set_type(), it's an optional component 
> > for those that really care about it.
> 
> i have no fundamental objections but it would be nice to actually 
> prototype this by implementing real priority support in the hardware: 
> both the i8259A and the IO-APIC/local-apic has such IRQ prioritization 
> features.
> 
I would not have written the patch if I did not have hardware that
supported it. I suppose I can start with interfacing the x86 PICs if that
makes it easier to swallow, though ;-)

> > + * IRQF_PRIO_HIGH - Give IRQ a high priority
> > + * IRQF_PRIO_LOW - Give IRQ a low priority
> 
> this should be a numeric scale. (Preferably in the 1-99 range (the 
> hardware can then do a lower-resolution thing out of it), so that we can 
> directly map this to IRQ threads and SCHED_FIFO priorities in -rt.)
> 
I don't disagree with that, but that makes it a little hard to pass in a
priority at request_irq() time. These IRQF_PRIO_HIGH/LOW are only for
such usage, the intent is to have a numeric value that's more meaningful
to the underlying hardware passed on to set_irq_prio() otherwise.

In any event, there's no problem with doing that anyways, both
IRQF_PRIO_HIGH and IRQF_PRIO_LOW are substantially above the 1-99 range
that the mask can be tested for if the underlying controller isn't
interested in mapping the 1-99 range to its own view of priorities.
Presumably you want this numeric range also reflected in the irq_desc for
-rt? If so, I'll start hacking something up.
