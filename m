Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbYAPTrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbYAPTrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 14:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbYAPTrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 14:47:10 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:47370 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbYAPTrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 14:47:08 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 2/2] 8250_pnp: register x86 COM ports at the conventional ttyS names
Date: Wed, 16 Jan 2008 12:47:33 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org,
       Russell King <rmk+serial@arm.linux.org.uk>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080116170541.511233227@ldl.fc.hp.com> <20080116170914.959390017@ldl.fc.hp.com> <478E5095.2020803@zytor.com>
In-Reply-To: <478E5095.2020803@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801161247.34821.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 January 2008 11:44:37 am H. Peter Anvin wrote:
> Bjorn Helgaas wrote:
> > x86 users expect COM1-COM4 ports at the conventional ioport addresses
> > to be named ttyS0-ttyS3.  For PNP devices, the BIOS determines the
> > order we discover them, so we might discover COM2 before COM1.
> > 
> > We currently always get the correct names, even without this patch.
> > But that's only because serial8250_isa_init_ports() first registers
> > the hard-coded list of COM port addresses from SERIAL_PORT_DFNS.  When
> > PNP rediscovers one of those ports, it gets the already-established
> > line.
> > 
> > This patch removes the implicit dependency on SERIAL_PORT_DFNS by
> > requesting the names we desire.
> >  
> >  static int __devinit
> > +serial_pnp_line(struct uart_port *port)
> > +{
> > +#ifdef CONFIG_X86
> > +	switch (port->iobase) {
> > +	case 0x3f8:	return 0;	/* COM1 -> ttyS0 */
> > +	case 0x2f8:	return 1;	/* COM2 -> ttyS1 */
> > +	case 0x3e8:	return 2;	/* COM3 -> ttyS2 */
> > +	case 0x2e8:	return 3;	/* COM4 -> ttyS3 */
> > +	}
> > +#endif
> > +
> 
> Arguably, the right thing is to use the addresses present in the array 
> at address 0x400.  In particular, COM3 and COM4 aren't always at those 
> addresses.

Wow.  I bow before your storehouse of x86 arcana :-)

I guess you're referring to the "BIOS data area," which I'd never
heard of before (but fortunately, Google knows).

What would you think about doing this only for COM1 and COM2?  The
only real value for doing this in the first place is so "console=ttyS0"
always goes to COM1, even if we don't have SERIAL_PORT_DFNS.  User-
space ought to use some sort of udev magic if it cares about persistent
naming.

Bjorn
