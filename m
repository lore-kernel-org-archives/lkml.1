Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbXGASHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbXGASHb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 14:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbXGASHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 14:07:23 -0400
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:20977 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753822AbXGASHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 14:07:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=igAc/mujQVCIo8+TSmmx8X62jUDJTtS9xjI9wm8rkIlIxdOr7O/GKUiFWYg5M8lv8iIF2vMENilp9aU42vR3SrpvU5jnQqLHccHo2J+5bcieI1WbxmamTq/yv45hgqxVEmz/5zeS+JLuXtw6SiVytBu/hr5CLpHALBfCgWhVTTE=  ;
X-YMail-OSG: jy0KDLIVM1nX0lYPq2vbPBzJ9tmnlRfufe4xW5DIr8I2DIKK
From: David Brownell <david-b@pacbell.net>
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] PXA27x UDC driver.
Date: Sun, 1 Jul 2007 10:49:41 -0700
User-Agent: KMail/1.9.6
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070628103619.GW13886@enneenne.com> <20070701150036.GA20518@flint.arm.linux.org.uk>
In-Reply-To: <20070701150036.GA20518@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707011049.42333.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 July 2007, Russell King - ARM Linux wrote:
> >  
> > +#ifdef CONFIG_USB_GADGET_PXA27X
> > +#define DEV_CONFIG_SUBSET
> > +#endif
> > +
> 
> Bad - can we not make this runtime dependent?

The #define controls which descriptors are statically linked
into every object.  I suppose someone could submit a patch which
does that differently ... I'm not keen on having lots of "will
never use" data bloating any driver, but it could be moved to
__initdata, at the cost of adding code to kmalloc (and kfree)
all the individual descriptors.  Restricting code bloat to init
sections would still be worse than no bloat...


> > +static void *pxa27x_ep_alloc_buffer(struct usb_ep *_ep, unsigned bytes,
> > +				    dma_addr_t * dma, unsigned int gfp_flags)
> > +{
> > +	...
> 
> Err, no.  There's a perfectly good replacement.  DMA pools.  Please use
> the provided infrastructure instead of inventing your own solution.

This was cloned from code which predates dma pools.  :)

Regardless, I'm planning to remove that interface from the gadget stack.
It's utility is far exceeded by the number of controller driver bugs
in that area.  Plus, if any gadget driver needs such a mechanism, the
dma_pool stuff that now exists could be called directly.


> Pointers which are cleared are set to NULL not zero.  Zero is an integer.
> NULL is a pointer.  Don't confuse the two.

ISTR this class of error would be reported by sparse ("make check").

- Dave
