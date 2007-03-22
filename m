Return-Path: <linux-kernel-owner+w=401wt.eu-S932418AbXCVWCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbXCVWCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 18:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932431AbXCVWCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 18:02:23 -0400
Received: from smtp.osdl.org ([65.172.181.24]:53721 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932418AbXCVWCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 18:02:22 -0400
Date: Thu, 22 Mar 2007 15:02:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tglx@linutronix.de
Cc: Bernhard Walle <bwalle@suse.de>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Fix irqpoll on IA64 (timer interrupt != 0)
Message-Id: <20070322150207.a35d3f15.akpm@linux-foundation.org>
In-Reply-To: <1174598601.10840.231.camel@localhost.localdomain>
References: <20070320150027.GA18143@strauss.suse.de>
	<20070322140922.a59bea5c.akpm@linux-foundation.org>
	<1174598601.10840.231.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 22:23:21 +0100
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 2007-03-22 at 14:09 -0700, Andrew Morton wrote:
> > I think the term 'timer_interrupt' is a bit generic-sounding.  Would it be
> > better to call it irqpoll_interrupt?  After all, some architecture might
> > want to use, umm, the keyboard interrupt to trigger IRQ polling ;)  
> 
> Interesting thought, but in general I have to agree.
> 
> > Also, the code presently passes the magic IRQ number into the generic IRQ
> > code.  I wonder if we'd get a more pleasing result if we were to make the
> > generic IRQ code call _out_ to the architecture:
> 
> > Then, ia64 can implement arch_is_irqpoll_irq() and it can do whatever it
> > wants in there.
> > 
> > The __attribute__((weak)) thing adds a little bit of overhead, but I don't
> > think this is a fastpath?
> 
> Well, depends what you consider a fastpath. When noirqdebug == 0, it is
> called on every interrupt.
> 

OK, well the alternative is to do

extern bool __arch_irqpoll_irq(unsigned int irq);
#define arch_is_irqpoll_irq(irq)	__arch_is_irqpoll_irq(irq)

in an ia64 header file and then do

#ifndef arch_is_irqpoll_irq
static inline bool arch_is_irqpoll_irq(unsigned irq)
{
	return irq == 0;
}
#endif

in spurious.c

