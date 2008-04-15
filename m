Return-Path: <linux-kernel-owner+w=401wt.eu-S932795AbYDOVxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795AbYDOVxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759749AbYDOVxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:53:38 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:57683 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231AbYDOVxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:53:35 -0400
Date: Wed, 16 Apr 2008 00:52:23 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: [2.6 patch] PCMCIA mustn't select HAVE_IDE
Message-ID: <20080415215223.GK1677@cs181133002.pp.htv.fi>
References: <20080414141659.GF6695@cs181133002.pp.htv.fi> <20080414175344.GA15028@uranus.ravnborg.org> <200804152215.34904.bzolnier@gmail.com> <20080415212326.GF1677@cs181133002.pp.htv.fi> <20080415212822.GE5676@flint.arm.linux.org.uk> <20080415214203.GF5676@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080415214203.GF5676@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 10:42:03PM +0100, Russell King wrote:
> On Tue, Apr 15, 2008 at 10:28:22PM +0100, Russell King wrote:
> > On Wed, Apr 16, 2008 at 12:23:26AM +0300, Adrian Bunk wrote:
> > > On Tue, Apr 15, 2008 at 10:15:34PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > > On Monday 14 April 2008, Sam Ravnborg wrote:
> > > > > On Mon, Apr 14, 2008 at 05:16:59PM +0300, Adrian Bunk wrote:
> > > > > > It's plain wrong for PCMCIA to select HAVE_IDE that implies e.g. the 
> > > > > > availability of an asm/ide.h
> > > > > > 
> > > > > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > > > > > 
> > > > > > ---
> > > > > > 9cdb66112488bc0c6e1d528444d3ba30d5b0487f diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
> > > > > > index 8b22281..519b4ff 100644
> > > > > > --- a/drivers/pcmcia/Kconfig
> > > > > > +++ b/drivers/pcmcia/Kconfig
> > > > > > @@ -38,7 +38,6 @@ config PCMCIA_DEBUG
> > > > > >  config PCMCIA
> > > > > >  	tristate "16-bit PCMCIA support"
> > > > > >  	select CRC32
> > > > > > -	select HAVE_IDE
> > > > > >  	default y
> > > > > 
> > > > > I did this when introducing HAVE_IDE.
> > > > > But I do not recall why and the rationale for removing it
> > > > > seems fine to me.
> > > > 
> > > > IIRC it was needed for some arm platforms which don't select HAVE_IDE
> > > > explicetely but I don't know if this is still the case, pinging Russell.
> > > 
> > > It's definitely bogus since it can cause compile breakage on 
> > > architectures like avr32.
> > > 
> > > And whatever it should have fixed should be fixed properly.
> > 
> > I'd suggest backing out the entire change which introduced HAVE_IDE then -
> > rather than doing it piecemeal and bringing up questions about it which
> > are unanswerable (which is the case of Bart's question of me.)
> 
> Looking back at the original change:
> 
> -if PCMCIA || ARCH_CLPS7500 || ARCH_IOP32X || ARCH_IOP33X || ARCH_IXP4XX \
> -       || ARCH_L7200 || ARCH_LH7A40X || ARCH_PXA || ARCH_RPC \
> -       || ARCH_S3C2410 || ARCH_SA1100 || ARCH_SHARK || FOOTBRIDGE \
> -       || ARCH_IXP23XX
>  source "drivers/ide/Kconfig"
> -endif
> 
> was what was done to ARM's Kconfig.  So, if we're going to be doing
> anything with the 'select HAVE_IDE', it should be:
> 
>  config PCMCIA
>         tristate "16-bit PCMCIA support"
>         select CRC32
> -	select HAVE_IDE
> +	select HAVE_IDE if ARM
>...

The commit that added the PCMCIA dependency was:

commit bb011b8e8eded247cb71cb6d10e47517aacbd542
Author: David Brownell <david-b@net.rmk.(none)>
Date:   Sun Jun 12 23:26:05 2005 +0100

    [PATCH] ARM: 2709/1: Systems with PCMCIA should also see IDE options (for CompactFlash memories)
    
    Patch from David Brownell
    
    The ARM generic Kconfig filters out IDE options ... except for
    an error prone ARMload of special cases.
    This adds one general case to the systems that will offer IDE options:
    kernels with PCMCIA support, which probably want to use IDE to access
    CompactFlash cards.  This might allow many (most?) of the other cases
    to disappear, for systems that only see IDE hardware through CF cards.
    Right now this one patch is used to gate access to CF cards, including
    MicroDrives, for both omap_cf and at91_cf drivers.
    
    Signed-off-by: David Brownell
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>



We could simply always select HAVE_IDE on arm instead of manually 
setting which platforms could possibly get IDE support (e.g. are there
any boards with PCI slots for which HAVE_IDE is currently not 
selected?).

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

