Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYC1Nuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYC1Nuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 09:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYC1Nur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 09:50:47 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1390 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752541AbYC1Nuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 09:50:46 -0400
Date: Fri, 28 Mar 2008 14:50:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: iommu breaks usb after resume
Message-ID: <20080328135038.GD4544@ucw.cz>
References: <20080320111429.GA14764@elf.ucw.cz> <200803272130.38375.rjw@sisk.pl> <20080327234055.GB32617@elf.ucw.cz> <200803280052.01250.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803280052.01250.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
> > > > index d8200ac..4e85178 100644
> > > > --- a/drivers/char/agp/amd64-agp.c
> > > > +++ b/drivers/char/agp/amd64-agp.c
> > > > @@ -594,12 +594,14 @@ static int agp_amd64_suspend(struct pci_
> > > >  
> > > >  static int agp_amd64_resume(struct pci_dev *pdev)
> > > >  {
> > > > +	printk("agp_amd64: resume\n");
> > > >  	pci_set_power_state(pdev, PCI_D0);
> > > >  	pci_restore_state(pdev);
> > > >  
> > > >  	if (pdev->vendor == PCI_VENDOR_ID_NVIDIA)
> > > >  		nforce3_agp_init(pdev);
> > > >  
> > > > +	printk("agp_amd64: 8151 configure\n");
> > > >  	return amd_8151_configure();
> > > >  }
> > > >  
> > > > @@ -733,8 +735,8 @@ static struct pci_driver agp_amd64_pci_d
> > > >  	.probe		= agp_amd64_probe,
> > > >  	.remove		= agp_amd64_remove,
> > > >  #ifdef CONFIG_PM
> > > > -	.suspend	= agp_amd64_suspend,
> > > > -	.resume		= agp_amd64_resume,
> > > > +	.suspend_late	= agp_amd64_suspend,
> > > > +	.resume_early	= agp_amd64_resume,
> > > >  #endif
> > > >  };
> > > 
> > > Okay, a couple of questions:
> > > 
> > > (1) Are you sure that the .suspend() and .resume() callbacks will just work
> > >     with interrupts disabled?
> > 
> > I have not really checked -- it turned out this is not "my" problem
> > after all. My machine (called leet) uses different setup. If they will
> > not, I guess lockdep will tell us ;-).
> 
> Lockdep need not tell us about it, I think.  OTOH, I don't really see a
> scenario in which having interrupts disabled while executing ->suspend() and
> ->resume() might hurt.

Ok.

> > > (2) Even if they work, is it sufficient to just move them to the "late" and
> > >     "early" parts?  That is, isn't there anything using the iommu in the
> > >     "early" and "late" callbacks of the other devices?
> > 
> > We definitely have iommu users in "normal" callbacks: USB.
> 
> Oh, there may be more.  You never know what appears in future systems. :-)

Well, we'll catch them during code review, right?

> > I do not think we have iommu users in early/late callbacks...
> 
> Perhaps not at the moment, but what's the guarantee there won't be any in the
> future?

That's why we review changes... ok, maybe documenting it somewhere
would be nice...?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
