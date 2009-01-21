Return-Path: <linux-kernel-owner+w=401wt.eu-S1764154AbZAUPyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764154AbZAUPyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 10:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760696AbZAUPxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 10:53:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52734 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760151AbZAUPxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 10:53:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: michael@ellerman.id.au
Subject: Re: [PATCH 1/2] PCI/MSI: Introduce pci_msix_table_size()
Date: Wed, 21 Jan 2009 16:52:38 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>
References: <200901131457.58164.rjw@sisk.pl> <200901210118.44162.rjw@sisk.pl> <1232505015.11241.51.camel@localhost>
In-Reply-To: <1232505015.11241.51.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901211652.39584.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 January 2009, Michael Ellerman wrote:
> On Wed, 2009-01-21 at 01:18 +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Introduce new function pci_msix_table_size() returning the size of
> > the MSI-X table of given PCI device or 0 if the device doesn't
> > support MSI-X.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  drivers/pci/msi.c   |   24 +++++++++++++++++++-----
> >  include/linux/pci.h |    5 +++++
> >  2 files changed, 24 insertions(+), 5 deletions(-)
> > 
> > Index: linux-2.6/drivers/pci/msi.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/pci/msi.c
> > +++ linux-2.6/drivers/pci/msi.c
> > @@ -670,6 +670,23 @@ static int msi_free_irqs(struct pci_dev*
> >  }
> >  
> >  /**
> > + * pci_msix_table_size - return the number of device's MSI-X table entries
> > + * @dev: pointer to the pci_dev data structure of MSI-X device function
> > + */
> > +int pci_msix_table_size(struct pci_dev *dev)
> > +{
> > +	int pos;
> > +	u16 control;
> > +
> > +	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
> > +	if (!pos)
> > +		return 0;
> > +
> > +	pci_read_config_word(dev, msi_control_reg(pos), &control);
> > +	return multi_msix_capable(control);
> > +}
> > +
> > +/**
> >   * pci_enable_msix - configure device's MSI-X capability structure
> >   * @dev: pointer to the pci_dev data structure of MSI-X device function
> >   * @entries: pointer to an array of MSI-X entries
> > @@ -686,9 +703,8 @@ static int msi_free_irqs(struct pci_dev*
> >   **/
> >  int pci_enable_msix(struct pci_dev* dev, struct msix_entry *entries, int nvec)
> >  {
> > -	int status, pos, nr_entries;
> > +	int status, nr_entries;
> >  	int i, j;
> > -	u16 control;
> >  
> >  	if (!entries)
> >   		return -EINVAL;
> > @@ -697,9 +713,7 @@ int pci_enable_msix(struct pci_dev* dev,
> >  	if (status)
> >  		return status;
> >  
> > -	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
> > -	pci_read_config_word(dev, msi_control_reg(pos), &control);
> > -	nr_entries = multi_msix_capable(control);
> > +	nr_entries = pci_msix_table_size(dev);
> >  	if (nvec > nr_entries)
> >  		return -EINVAL;
> 
> I see similar code in msix_capability_init(), although it still needs
> pos. Did you deliberately not replace that, or just miss it?

I didn't replace it exactly because it required the pos anyway.

Thanks,
Rafael
