Return-Path: <linux-kernel-owner+w=401wt.eu-S935923AbXGLDJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935923AbXGLDJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 23:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759339AbXGLDJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 23:09:31 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:52701 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304AbXGLDJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 23:09:30 -0400
Date: Wed, 11 Jul 2007 20:12:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Greg Kroah-Hartman <gregkh@suse.de>,
       James.Smart@Emulex.Com, pcihpd-discuss@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Pcihpd-discuss] [PATCH 26/34] PCI: add pci_try_set_mwi
Message-Id: <20070711201229.43b71681.randy.dunlap@oracle.com>
In-Reply-To: <20070712003731.GA8126@kroah.com>
References: <11841968092270-git-send-email-gregkh@suse.de>
	<11841968133805-git-send-email-gregkh@suse.de>
	<11841968172168-git-send-email-gregkh@suse.de>
	<11841968221388-git-send-email-gregkh@suse.de>
	<11841968302709-git-send-email-gregkh@suse.de>
	<11841968341206-git-send-email-gregkh@suse.de>
	<11841968561560-git-send-email-gregkh@suse.de>
	<11841968591561-git-send-email-gregkh@suse.de>
	<11841968633587-git-send-email-gregkh@suse.de>
	<20070712000149.GX9704@parisc-linux.org>
	<20070712003731.GA8126@kroah.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 17:37:31 -0700 Greg KH wrote:

> On Wed, Jul 11, 2007 at 06:01:49PM -0600, Matthew Wilcox wrote:
> > On Wed, Jul 11, 2007 at 04:31:40PM -0700, Greg Kroah-Hartman wrote:
> > > As suggested by Andrew, add pci_try_set_mwi(), which does not require
> > > return-value checking.
> > 
> > Seems like a daft suggestion.  What's wrong with just removing the
> > __must_check from pci_set_mwi()?  Did it find any bugs?

(a) Alan suggested just dropping __must_check IIRC.
And David Brownell even sent a patch to do that (which Alan acked).

(b) not that I know of.

> > > --- a/drivers/scsi/lpfc/lpfc_init.c
> > > +++ b/drivers/scsi/lpfc/lpfc_init.c
> > > @@ -1578,10 +1578,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
> > >  	INIT_LIST_HEAD(&phba->fc_nodes);
> > >  
> > >  	pci_set_master(pdev);
> > > -	retval = pci_set_mwi(pdev);
> > > -	if (retval)
> > > -		dev_printk(KERN_WARNING, &pdev->dev,
> > > -			   "Warning: pci_set_mwi returned %d\n", retval);
> > > +	pci_try_set_mwi(pdev);
> > 
> > Why remove the warning?  Presumably people want to know if pci_set_mwi
> > failed.
> 
> Randy, this was your change, right?

Uh, I think that my thinking was like this:

pci_try_set_mwi() and pci_set_mwi() are both "try best effort"
functions.  Neither of them guarantees that pci_set_cacheline_size()
will succeed.  And in case of serious problems, pci_set_cacheline_size()
will print a (KERN_DEBUG) message.


Anyway, I don't mind restoring the former lpfc code if that is what
should be done.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
