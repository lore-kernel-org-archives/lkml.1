Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbXGZBfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbXGZBfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 21:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbXGZBe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 21:34:58 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:49832 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbXGZBe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 21:34:58 -0400
Subject: Re: [PATCH RFC] e1000: clear ICR before requesting an IRQ line
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: e1000-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       john.ronciak@intel.com, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com
In-Reply-To: <46A76BEC.1040309@intel.com>
References: <1184666997.5271.5.camel@sebastian.kern.oss.ntt.co.jp>
	 <20070718154659.c8b5ffea.akpm@linux-foundation.org>
	 <1184896459.27369.36.camel@sebastian.kern.oss.ntt.co.jp>
	 <1184896944.27369.50.camel@sebastian.kern.oss.ntt.co.jp>
	 <1184898043.28418.3.camel@sebastian.kern.oss.ntt.co.jp>
	 <1185355137.15252.82.camel@sebastian.kern.oss.ntt.co.jp>
	 <46A76BEC.1040309@intel.com>
Content-Type: text/plain; charset=utf-8
Organization: NTT Open Source Software Center
Date: Thu, 26 Jul 2007 10:34:54 +0900
Message-Id: <1185413694.31024.26.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-25 at 08:27 -0700, Kok, Auke wrote:
> Fernando Luis Vázquez Cao wrote:
> > I made an interesting finding while testing the two patches below.
> > 
> > http://lkml.org/lkml/2007/7/19/685
> > http://lkml.org/lkml/2007/7/19/687
> > 
> > These patches modify the traditional CONFIG_DEBUG_KERNEL in such a way
> > that the request_irq prints a warning if after calling the handler it
> > returned IRQ_HANDLED .
> > 
> > The code looks like this:
> > 
> > int request_irq(unsigned int irq, irq_handler_t handler,
> >                 unsigned long irqflags, const char *devname, void *dev_id)
> > .....
> >         if (irqflags & IRQF_DISABLED) {
> >                 unsigned long flags;
> > 
> >                 local_irq_save(flags);
> >                 retval = handler(irq, dev_id);
> >                 local_irq_restore(flags);
> >         } else
> >                 retval = handler(irq, dev_id);
> >         if (retval == IRQ_HANDLED) {
> >                 printk(KERN_WARNING
> >                        "%s (IRQ %d) handled a spurious interrupt\n",
> >                        devname, irq);
> >         }
> > .....
> > 
> > I discovered that the e1000 driver handles the "fake" interrupt, which,
> > in principle, is not correct because it obviously isn't a real interrupt
> > and it could have been an interrupt coming from another device that is
> > sharing the IRQ line.
> > 
> > The problem is that the interrupt handler assumes that if ICR!=0 it was
> > its device who generated the interrupt and, consequently, it should be
> > handled. But, unfortunately, that is not always the case. If the network
> > link is active when we open the device (e1000_open) the ICR will have
> > the E1000_ICR_LSC bit set (by the way, is this the expected behavior?).
> 
> yes. is it really a problem though?
It seems we may end up handling spurious interrupts or interrupts coming
from another devices.

> > This means that _any_ interrupt coming in after allocating our interrupt
> > (e1000_request_irq) will be handled, no matter where it came from.
> 
> we actually generate this LSC interrupt ourselves in the driver, to make sure 
> that we cascade into the watchdog which then enables or disables the link code 
> based on the link status change. This allows us to _not_ do any link checking in 
> _open and makes things a bit more simple.
I am not referring to the LSC interrupt the driver itself generates in
e1000_open just before returning. The ICR is masked (ICR==0) after
executing the driver probe (e1000_probe), but when we enter e1000_open
the E1000_ICR_LSC bit will already be set, before the function even
starts executing. I also observed that when the link is active the line

  /* fire a link status change interrupt to start the watchdog */
  E1000_WRITE_REG(&adapter->hw, ICS, E1000_ICS_LSC);

is redundant because the E1000_ICS_LSC bit is already set. In fact, the
irq handler gets invoked twice in a row with the interrupt cause being a
link status change.

> > The solution I came up with is clearing the ICR before calling
> > request_irq. I have to admit that I am not familiar enough with this
> > driver, so it is quite likely that this is not the right fix. I would
> > appreciate your comments on this.
> 
> Clearing the ICR before requesting an irq might not work - at the same time the 
> device could generate another LSC irq...
Is it not possible to prevent the device from generating interrupts until we call request_irq?

Thank you for your feedback!

  - Fernando

> Of course, we probably should just schedule some delayed work to run our 
> watchdog in e1000_open, but I haven't checked if that actually works.
> 
> 
> Auke
> 
> > Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> > ---
> > 
> > diff -urNp linux-2.6.22-orig/drivers/net/e1000/e1000_main.c linux-2.6.22-pendirq/drivers/net/e1000/e1000_main.c
> > --- linux-2.6.22-orig/drivers/net/e1000/e1000_main.c	2007-07-19 18:18:53.000000000 +0900
> > +++ linux-2.6.22-pendirq/drivers/net/e1000/e1000_main.c	2007-07-25 17:22:54.000000000 +0900
> > @@ -1378,6 +1378,17 @@ e1000_alloc_queues(struct e1000_adapter 
> >  }
> >  
> >  /**
> > + * e1000_clear_interrupts
> > + * @adapter: address of board private structure
> > + *
> > + * Mask interrupts
> > + **/
> > +static void
> > +e1000_clear_interrupts(struct e1000_adapter *adapter) {
> > +	E1000_READ_REG(&adapter->hw, ICR);
> > +}
> > +
> > +/**
> >   * e1000_open - Called when a network interface is made active
> >   * @netdev: network interface device structure
> >   *
> > @@ -1431,6 +1442,9 @@ e1000_open(struct net_device *netdev)
> >  	 * so we have to setup our clean_rx handler before we do so.  */
> >  	e1000_configure(adapter);
> >  
> > +	/* Discard any possible pending interrupts. */
> > +	e1000_clear_interrupts(adapter);
> > +
> >  	err = e1000_request_irq(adapter);
> >  	if (err)
> >  		goto err_req_irq;

