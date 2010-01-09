Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664Ab0AIORb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab0AIORb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 09:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469Ab0AIORa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 09:17:30 -0500
Received: from bamako.nerim.net ([62.4.17.28]:62191 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186Ab0AIOR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 09:17:29 -0500
Date: Sat, 9 Jan 2010 15:17:24 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] set_irq_noprobe shouldn't be __init
Message-ID: <20100109151724.128487db@hyperion.delvare>
In-Reply-To: <20100108163910.ed49b5f4.akpm@linux-foundation.org>
References: <20100105203842.04a1a523@hyperion.delvare>
	<20100108163910.ed49b5f4.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Fri, 8 Jan 2010 16:39:10 -0800, Andrew Morton wrote:
> On Tue, 5 Jan 2010 20:38:42 +0100
> Jean Delvare <khali@linux-fr.org> wrote:
> 
> > Non-__init functions need to call set_irq_noprobe() so this function
> > shouldn't be marked __init. Also remove __init from set_irq_probe()
> > for consistency.
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > Cc: Ralf Baechle <ralf@linux-mips.org>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > ---
> >  kernel/irq/chip.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > --- linux-2.6.33-rc2.orig/kernel/irq/chip.c	2009-12-18 08:34:52.000000000 +0100
> > +++ linux-2.6.33-rc2/kernel/irq/chip.c	2010-01-05 17:21:38.000000000 +0100
> > @@ -682,7 +682,7 @@ set_irq_chip_and_handler_name(unsigned i
> >  	__set_irq_handler(irq, handle, 0, name);
> >  }
> >  
> > -void __init set_irq_noprobe(unsigned int irq)
> > +void set_irq_noprobe(unsigned int irq)
> >  {
> >  	struct irq_desc *desc = irq_to_desc(irq);
> >  	unsigned long flags;
> > @@ -697,7 +697,7 @@ void __init set_irq_noprobe(unsigned int
> >  	raw_spin_unlock_irqrestore(&desc->lock, flags);
> >  }
> >  
> > -void __init set_irq_probe(unsigned int irq)
> > +void set_irq_probe(unsigned int irq)
> >  {
> >  	struct irq_desc *desc = irq_to_desc(irq);
> >  	unsigned long flags;
> 
> These non-__init callers will instantly crash, surely?  Are there any
> reports of such crashes?

I am not aware of such crashes being reported, but I am not the
maintainer of the affected drivers (these are mfd drivers.) I suppose
that the crash would only happen if these drivers were built as
modules: if built into the kernel (and they always are, being boolean
options in Kconfig), maybe they have time to initialize before the
__init code is removed? I'm not familiar enough with this mechanism to
tell.

The only thing I'm sure of is that 'make
CONFIG_DEBUG_SECTION_MISMATCH=y' complains.

I initially proposed the most immediate fix, but it might as well be
that it is reasonable to leave set_irq_probe() in __init and fix all
callers, under the assumption that all drivers which need it will be
for specific chips which require built-in support and can't be
hot-plugged by design.

What I don't quite get is how to guarantee that the devices in question
will be reachable early. These are SPI and I2C devices, so they
require the right bus driver to be loaded first. But this cannot happen
if they are built as modules (which nothing prevents as far as I can
see.) So I suspect that, if everything in the drivers was tagged __init
as it would have to if we want set_irq_probe() in __init, but the
relevant SPI or I2C bus driver was built as a module, bad things would
happen.

The proper fix in that case is somewhat beyond me. This might be one of
these cases where I should have refrained from sending a patch when I
finally did not know what the best solution to the problem would be.
Feel free to ignore me.

> If you're talking about new code then what is the status of that code?
> 
> Right now I don't know if this patch is needed in 2.6.34, 2.6.33 or
> 2.6.32.x and earlier.
> 
> IOW: the changelog sucks :)

You're right, sorry about that. The affected drivers are
twl4030/twl6030, ezx-pcap and wm831x (all mfd drivers), offending lines
are in the kernel tree since 2.6.28/2.6.33, 2.6.31 and 2.6.33,
respectively.

-- 
Jean Delvare
