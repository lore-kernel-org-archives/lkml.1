Return-Path: <linux-kernel-owner+w=401wt.eu-S932606AbXJPLyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606AbXJPLyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 07:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760292AbXJPLyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 07:54:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35085 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760182AbXJPLyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 07:54:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Common .suspend()/.resume() template for PCI devices (was: Re: [PATCH 1/3] Misc: phantom, synchronize_irq() on suspend)
Date: Tue, 16 Oct 2007 14:09:38 +0200
User-Agent: KMail/1.9.5
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <3012721321185026886@pripojeni.net> <20071015162344.dca7023c.akpm@linux-foundation.org>
In-Reply-To: <20071015162344.dca7023c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710161409.39323.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 16 October 2007 01:23, Andrew Morton wrote:
> On Mon, 15 Oct 2007 09:32:28 -0700
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
> > phantom, synchronize_irq() on suspend
> > 
> > Wait after disabling device's interrupt until the handler finishes its
> > work if still in progress.
> > 
> > Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> > 
> > ---
> > commit 7e792ef384190b517f2fb27cd0237fa30dbe0775
> > tree 17b15e5ab7c90eef0e7ae57e532839e81b831d58
> > parent 5c008a5651ee92ebe020dd5108a66a7db74fe41d
> > author Jiri Slaby <jirislaby@gmail.com> Mon, 15 Oct 2007 15:52:21 +0200
> > committer Jiri Slaby <jirislaby@gmail.com> Mon, 15 Oct 2007 15:52:21 +0200
> > 
> >  drivers/misc/phantom.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
> > index 5108b7c..6e61a79 100644
> > --- a/drivers/misc/phantom.c
> > +++ b/drivers/misc/phantom.c
> > @@ -378,6 +378,8 @@ static int phantom_suspend(struct pci_dev *pdev, pm_message_t state)
> >  	iowrite32(0, dev->caddr + PHN_IRQCTL);
> >  	ioread32(dev->caddr + PHN_IRQCTL); /* PCI posting */
> >  
> > +	synchronize_irq(pdev->irq);
> > +
> >  	return 0;
> >  }
> >  
> 
> What inspired this change?  Some bug report, or does it just seem the right
> thing to do?

Probably this thread: http://lkml.org/lkml/2007/10/10/261

> Would it be logical to do this operation from the PCI core somewhere, on
> behalf of all PCI drivers?

Yes, it would.

The problem is that we don't have a common template for PCI devices' .suspend()
and .resume() callbacks and I don't feel confident enough to propose one.
