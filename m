Return-Path: <linux-kernel-owner+w=401wt.eu-S932733AbYDOWE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733AbYDOWE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 18:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760403AbYDOWES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 18:04:18 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42859 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759902AbYDOWER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 18:04:17 -0400
Date: Tue, 15 Apr 2008 23:03:45 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: [2.6 patch] PCMCIA mustn't select HAVE_IDE
Message-ID: <20080415220344.GG5676@flint.arm.linux.org.uk>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Sam Ravnborg <sam@ravnborg.org>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
References: <20080414141659.GF6695@cs181133002.pp.htv.fi> <20080414175344.GA15028@uranus.ravnborg.org> <200804152215.34904.bzolnier@gmail.com> <20080415212326.GF1677@cs181133002.pp.htv.fi> <20080415212822.GE5676@flint.arm.linux.org.uk> <20080415214203.GF5676@flint.arm.linux.org.uk> <20080415215223.GK1677@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415215223.GK1677@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 12:52:23AM +0300, Adrian Bunk wrote:
> On Tue, Apr 15, 2008 at 10:42:03PM +0100, Russell King wrote:
> > On Tue, Apr 15, 2008 at 10:28:22PM +0100, Russell King wrote:
> > > On Wed, Apr 16, 2008 at 12:23:26AM +0300, Adrian Bunk wrote:
> > > > On Tue, Apr 15, 2008 at 10:15:34PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > > > On Monday 14 April 2008, Sam Ravnborg wrote:
> > > > > > On Mon, Apr 14, 2008 at 05:16:59PM +0300, Adrian Bunk wrote:
> > > > > > > It's plain wrong for PCMCIA to select HAVE_IDE that implies e.g. the 
> > > > > > > availability of an asm/ide.h
> > > > > > > 
> > > > > > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > > > > > > 
> > > > > > > ---
> > > > > > > 9cdb66112488bc0c6e1d528444d3ba30d5b0487f diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
> > > > > > > index 8b22281..519b4ff 100644
> > > > > > > --- a/drivers/pcmcia/Kconfig
> > > > > > > +++ b/drivers/pcmcia/Kconfig
> > > > > > > @@ -38,7 +38,6 @@ config PCMCIA_DEBUG
> > > > > > >  config PCMCIA
> > > > > > >  	tristate "16-bit PCMCIA support"
> > > > > > >  	select CRC32
> > > > > > > -	select HAVE_IDE
> > > > > > >  	default y
> > > > > > 
> > > > > > I did this when introducing HAVE_IDE.
> > > > > > But I do not recall why and the rationale for removing it
> > > > > > seems fine to me.
> > > > > 
> > > > > IIRC it was needed for some arm platforms which don't select HAVE_IDE
> > > > > explicetely but I don't know if this is still the case, pinging Russell.
> > > > 
> > > > It's definitely bogus since it can cause compile breakage on 
> > > > architectures like avr32.
> > > > 
> > > > And whatever it should have fixed should be fixed properly.
> > > 
> > > I'd suggest backing out the entire change which introduced HAVE_IDE then -
> > > rather than doing it piecemeal and bringing up questions about it which
> > > are unanswerable (which is the case of Bart's question of me.)
> > 
> > Looking back at the original change:
> > 
> > -if PCMCIA || ARCH_CLPS7500 || ARCH_IOP32X || ARCH_IOP33X || ARCH_IXP4XX \
> > -       || ARCH_L7200 || ARCH_LH7A40X || ARCH_PXA || ARCH_RPC \
> > -       || ARCH_S3C2410 || ARCH_SA1100 || ARCH_SHARK || FOOTBRIDGE \
> > -       || ARCH_IXP23XX
> >  source "drivers/ide/Kconfig"
> > -endif
> > 
> > was what was done to ARM's Kconfig.  So, if we're going to be doing
> > anything with the 'select HAVE_IDE', it should be:
> > 
> >  config PCMCIA
> >         tristate "16-bit PCMCIA support"
> >         select CRC32
> > -	select HAVE_IDE
> > +	select HAVE_IDE if ARM
> >...
> 
> The commit that added the PCMCIA dependency was:
> 
> commit bb011b8e8eded247cb71cb6d10e47517aacbd542
> Author: David Brownell <david-b@net.rmk.(none)>
> Date:   Sun Jun 12 23:26:05 2005 +0100

Did you look at the patch?

-if ARCH_CLPS7500 || ARCH_IOP3XX || ARCH_IXP4XX || ARCH_L7200 || ARCH_LH7A40X || ARCH_PXA || ARCH_RPC || ARCH_S3C2410 || ARCH_SA1100 || ARCH_SHARK || FOOTBRIDGE
+if PCMCIA || ARCH_CLPS7500 || ARCH_IOP3XX || ARCH_IXP4XX \
+       || ARCH_L7200 || ARCH_LH7A40X || ARCH_PXA || ARCH_RPC \
+       || ARCH_S3C2410 || ARCH_SA1100 || ARCH_SHARK || FOOTBRIDGE
 source "drivers/ide/Kconfig"
 endif

So this is a only impacting ARM wrt. PCMCIA, and given that ARM supplies
an asm/ide.h, it's _entirely_ reasonable that if a platform has PCMCIA
then it supports IDE.

> We could simply always select HAVE_IDE on arm instead of manually 
> setting which platforms could possibly get IDE support (e.g. are there
> any boards with PCI slots for which HAVE_IDE is currently not 
> selected?).

You could, if there was a demand for it.  As no one has added that,
I conclude that its less common for people to stick an IDE controller
into a PCI backplane.

In fact, there are only three classes of ARM platforms which have PCI
selected but not HAVE_IDE - IOP13xx, IXP2000, and Orion.  I suspect
the only reason they don't select it because they now use the ATA code
rather than the old IDE code - that's certainly true of Orion.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
