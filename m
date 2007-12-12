Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbXLLRFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbXLLRFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 12:05:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbXLLREx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 12:04:53 -0500
Received: from nic2.axis.se ([193.13.178.10]:47403 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbXLLREx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 12:04:53 -0500
Date: Wed, 12 Dec 2007 18:04:40 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 44/47] Minor fixes for CRISv32 io.h
Message-ID: <20071212170440.GF3689@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com> <cdda065141073e183216982b6faf7e1aee17b215.1196848533.git.jesper.nilsson@axis.com> <20071212032939.380d15dc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212032939.380d15dc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 03:29:39AM -0800, Andrew Morton wrote:
> On Mon, 3 Dec 2007 11:16:25 +0100 Jesper Nilsson <jesper.nilsson@axis.com> wrote:
> >  struct crisv32_ioport
> >  {
> > -  unsigned long* oe;
> > -  unsigned long* data;
> > -  unsigned long* data_in;
> > +  volatile unsigned long *oe;
> > +  volatile unsigned long *data;
> > +  volatile unsigned long *data_in;
> >    unsigned int pin_count;
> > +  spinlock_t lock;
> >  };
> 
> tabs.

Will fix.

> >  static inline void crisv32_io_set(struct crisv32_iopin* iopin,
> >  			   int val)
> >  {
> > +	long flags;
> > +	spin_lock_irqsave(&iopin->port->lock, flags);
> > +
> >  	if (val)
> >  		*iopin->port->data |= iopin->bit;
> >  	else
> >  		*iopin->port->data &= ~iopin->bit;
> > +
> > +	spin_unlock_irqrestore(&iopin->port->lock, flags);
> >  }
> >  
> >  static inline void crisv32_io_set_dir(struct crisv32_iopin* iopin,
> >  			       enum crisv32_io_dir dir)
> >  {
> > +	long flags;
> > +	spin_lock_irqsave(&iopin->port->lock, flags);
> > +
> >  	if (dir == crisv32_io_dir_in)
> >  		*iopin->port->oe &= ~iopin->bit;
> >  	else
> >  		*iopin->port->oe |= iopin->bit;
> > +
> > +	spin_unlock_irqrestore(&iopin->port->lock, flags);
> >  }
> 
> These surely are far too large to be inlined.

Actually not, since the CRISv32 is UP, these should be ok to inline,
and since we most often call them with a constant argument,
the compiler is free to optimize away the if statement...

> > +#define LED_NETWORK_GRP0_SET(x)                          \
> > +	do {                                             \
> > +		LED_NETWORK_GRP0_SET_G((x) & LED_GREEN); \
> > +		LED_NETWORK_GRP0_SET_R((x) & LED_RED);   \
> >  	} while (0)
> > +#else
> > +#define LED_NETWORK_GRP0_SET(x) while (0) {}
> > +#endif
> > +
> > +#define LED_NETWORK_GRP0_SET_G(x) \
> > +	crisv32_io_set(&crisv32_led_net0_green, !(x));
> > +
> > +#define LED_NETWORK_GRP0_SET_R(x) \
> > +	crisv32_io_set(&crisv32_led_net0_red, !(x));
> > +
> > +#if defined(CONFIG_ETRAX_NBR_LED_GRP_TWO)
> > +#define LED_NETWORK_GRP1_SET(x)                          \
> > +	do {                                             \
> > +		LED_NETWORK_GRP1_SET_G((x) & LED_GREEN); \
> > +		LED_NETWORK_GRP1_SET_R((x) & LED_RED);   \
> > +	} while (0)
> > +#else
> > +#define LED_NETWORK_GRP1_SET(x) while (0) {}
> > +#endif
> > +
> > +#define LED_NETWORK_GRP1_SET_G(x) \
> > +	crisv32_io_set(&crisv32_led_net1_green, !(x));
> > +
> > +#define LED_NETWORK_GRP1_SET_R(x) \
> > +	crisv32_io_set(&crisv32_led_net1_red, !(x));
> > +
> >  #define LED_ACTIVE_SET(x)                           \
> >  	do {                                        \
> >  		LED_ACTIVE_SET_G((x) & LED_GREEN);  \
> >  		LED_ACTIVE_SET_R((x) & LED_RED);    \
> >  	} while (0)
> >  
> 
> PLease generally prefer (lower-case) inlined functions over macros.  They
> are cleaner, clearer, safer and have better typechecking.

Yes, you are right, I'll have to check where this is used, but hopefully
I can pare this down to a few inlines instead.

> Several of the above macros reference their argument more than once and
> hence cannot be used as, for example,
> 
> 	LED_ACTIVE_SET(foo++);

Also true, although the argument should never be such a statement,
it is still bad form.

Thanks again for commenting, it is enormously helpful!

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
