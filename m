Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbZJFAAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbZJFAAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 20:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941AbZJFAAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 20:00:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49599 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463AbZJFAAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 20:00:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH] ACPI / PCI: Fix NULL pointer dereference in acpi_get_pci_dev()
Date: Tue, 6 Oct 2009 02:01:42 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-rjw; KDE/4.3.1; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Danny Feng <dfeng@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>, chepioq@gmail.com
References: <200910060130.43246.rjw@sisk.pl> <20091005233759.GB14394@ldl.fc.hp.com>
In-Reply-To: <20091005233759.GB14394@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910060201.42519.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 October 2009, Alex Chiang wrote:
> * Rafael J. Wysocki <rjw@sisk.pl>:
> > 
> > Fixes http://bugzilla.kernel.org/show_bug.cgi?id=14129, which is a
> > regression from 2.6.30.
> 
> Thanks for doing this.
> 
> One small comment below (not major), but other than that:
> 
> Reviewed-by: Alex Chiang <achiang@hp.com>
> 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > Reported-by: Danny Feng <dfeng@redhat.com>
> > Tested-by: chepioq <chepioq@gmail.com>
> > ---
> >  drivers/acpi/pci_root.c |   12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > Index: linux-2.6/drivers/acpi/pci_root.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/acpi/pci_root.c
> > +++ linux-2.6/drivers/acpi/pci_root.c
> > @@ -389,6 +389,18 @@ struct pci_dev *acpi_get_pci_dev(acpi_ha
> >  
> >  		pbus = pdev->subordinate;
> >  		pci_dev_put(pdev);
> > +
> > +		/*
> > +		 * During resume from a sleep state we can get a dock
> > +		 * notification for a device that is present in ACPI tables,
> > +		 * but not physically accessible at the moment, so tell the
> > +		 * caller it's not present in that case.
> > +		 */
> > +		if (!pbus) {
> > +			dev_info(&pdev->dev, "Secondary bus not present\n");
> 
> Should this be dev_dbg() or maybe even strike it completely?

I thought about that, but I decided not to just in order to get some idea about
how many affected systems are out there.  If that happens to be a problem for
anyone, we can simply remove the message in the future.

> 
> > +			pdev = NULL;
> > +			break;
> > +		}
> >  	}
> >  out:
> >  	list_for_each_entry_safe(node, tmp, &device_list, node)
> > 

Thanks,
Rafael
