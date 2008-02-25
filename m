Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbYBYJOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbYBYJOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 04:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbYBYJN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 04:13:58 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:49071 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752019AbYBYJN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 04:13:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=N/pMcBrGf9+1aycMUDUFlvm2CBXMZJfUDUajVv65C0qJcYkTEdwkoTNLywPdf0RwF2ZYEA1MjcnPvlPvlEhYCQ5epDEFM7RMKbr/LCNgKdXrbNX2qkJRCRiPwbhDegGKFyX92abEuHANmHSbEOGV9kR9oTkq1vdCb+MKSTP00Lg=  ;
X-YMail-OSG: U_OXxlgVM1lUqFc8dKwJ9XKBP86u1hPGxJHKTh7b4yPBDxDsp4Wdb_PEE2iGWlrnivzjIIID2g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: USB OOPS 2.6.25-rc2-git1
Date: Mon, 25 Feb 2008 01:13:51 -0800
User-Agent: KMail/1.9.6
Cc: Andre Tomt <andre@tomt.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0802211054550.4528-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802211054550.4528-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802250113.51334.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 February 2008, Alan Stern wrote:
> > ========= CUT HERE
> > Modify EHCI irq handling on the theory that at least some of the
> > "lost" IRQs are caused by goofage between multiple lowlevel IRQ
> > acking mechanisms:  try rescanning before we exit the handler, in
> > case the EHCI-internal ack (by clearing the irq status) doesn't
> > always suffice for IRQs triggered nearly back-to-back.
> > 
> > ---
> >  drivers/usb/host/ehci-hcd.c |    8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > --- g26.orig/drivers/usb/host/ehci-hcd.c      2008-02-20 13:26:00.000000000 -0800
> > +++ g26/drivers/usb/host/ehci-hcd.c   2008-02-20 13:54:37.000000000 -0800
> > @@ -638,6 +638,8 @@ static irqreturn_t ehci_irq (struct usb_
> >               return IRQ_NONE;
> >       }
> >  
> > +retrigger:
> > +
> >       /* clear (just) interrupts */
> >       ehci_writel(ehci, status, &ehci->regs->status);
> >       cmd = ehci_readl(ehci, &ehci->regs->command);
> > @@ -725,6 +727,12 @@ dead:
> >  
> >       if (bh)
> >               ehci_work (ehci);
> > +
> > +     status = ehci_readl(ehci, &ehci->regs->status);
> > +     status &= INTR_MASK;
> > +     if (status)
> > +             goto retrigger;
> > +
> >       spin_unlock (&ehci->lock);
> >       if (pcd_status & STS_PCD)
> >               usb_hcd_poll_rh_status(hcd);
> 
> There's one little problem here.  As a result of this change, the line 
> where pcd_status gets set (not shown in this patch) needs to be changed 
> to:
> 
>                 pcd_status |= (status & STS_PCD);

Actually, no change is needed.  It's initialized to zero, then
set to "status" given "if (status & STS_PCD)", and never cleared.
So if it's ever set, it stays set...

> 
> Then the test shown above can be simplified to:
> 
>         if (pcd_status)

True with the current code too ...

