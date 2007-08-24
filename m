Return-Path: <linux-kernel-owner+w=401wt.eu-S932544AbXHXSe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544AbXHXSe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759151AbXHXSeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:34:20 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:57541 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756732AbXHXSeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:34:18 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [2.6.23-rc3 possible regression] 8250 claims nonexisting device blocking IO port
Date: Fri, 24 Aug 2007 12:33:55 -0600
User-Agent: KMail/1.9.6
Cc: linux-serial@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
References: <200708181107.56087.arvidjaar@mail.ru> <200708211334.58157.bjorn.helgaas@hp.com> <200708242142.37001.arvidjaar@mail.ru>
In-Reply-To: <200708242142.37001.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708241233.55698.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 August 2007 11:42:36 am Andrey Borzenkov wrote:
> On Tuesday 21 August 2007, Bjorn Helgaas wrote:
> > On Tuesday 21 August 2007 12:28:49 pm Andrey Borzenkov wrote:
> > > On Monday 20 August 2007, Bjorn Helgaas wrote:
> > > > On Monday 20 August 2007 10:28:22 am Andrey Borzenkov wrote:
> > > > > This worked in 2.6.22 with the same quirks. I will test without later
> > > > > but I fail to see how they are related.
> > > >
> > > > OK, let me know what happens.  The way it's related is that the quirk
> > > > fiddles with the IRDA device, and it probably changes the SIR config
> > > > so that it starts responding at the ttyS3 address.
> > >
> > > You are probably right. Disabling quirk makes it work again (with pnp off
> > > in smsc-ircc2 of course).
> >
> > I think pnp is off in smsc-ircc2 by default, right?
> >
> > > Hmm ... is there any reason why this quirk is in PnP core in the first
> > > place? Would not it be more logical to have it in (PnP) part of
> > > smsc-ircc2? This way it could share code with legacy detection; and it
> > > even may have chance to work - assuming BIOS is aware that 0x100 is
> > > claimed by PCMCIA it could allocate different port when we try to
> > > activate device after that ... should I give it a try?
> >
> > I agree it would make sense to put the quirk in smsc-ircc2, since
> > we only need it if we want to use the smsc-ircc2 driver.  But I don't
> > think we have a mechanism for calling quirks at module load-time, so
> > it has to be part of the static kernel.  And we don't have anything
> > like DECLARE_PCI_FIXUP_SECTION, so it really has to be in quirks.c for
> > now.
> >
> > How does the following patch look?
> >
> I am fine with any patch that works. Of course, it would be better to fix 8250 
> to respect PnP (it does load 8250_pnp in the first place).

I agree.  8250_pnp is actually fine -- it won't claim SMCf010 devices.
The problem is that we have the legacy addresses (including the SMCf010
SIR range) in SERIAL_PORT_DFNS, so 8250.c claims the SIR range in
serial8250_isa_init_ports().

I'm still hoping to fix that bit of 8250, but it's going to take some
work.

I'll post the SMCf010 quirk removal as a fix for the 2.6.23-rc3
regression.

Bjorn


