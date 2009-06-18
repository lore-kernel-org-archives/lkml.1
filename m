Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbZFRAZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbZFRAZD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 20:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbZFRAYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 20:24:54 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:55903 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbZFRAYx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 20:24:53 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Organization: Mandriva
To: fmhess@users.sourceforge.net
Subject: Re: staging driver s626 clashes with philips SAA7146 media/dvb based cards
Date: Wed, 17 Jun 2009 21:24:53 -0300
User-Agent: KMail/1.11.90 (Linux/2.6.30-desktop-1mnb; KDE/4.2.90; i686; ; )
Cc: Ian Abbott <abbotti@mev.co.uk>, Ian Abbott <ian.abbott@mev.co.uk>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Gianluca Palli <gpalli@deis.unibo.it>, David Schleef <ds@schleef.org>
References: <200906161701.45234.herton@mandriva.com.br> <200906171935.14341.fmhess@speakeasy.net> <200906172105.57000.herton@mandriva.com.br>
In-Reply-To: <200906172105.57000.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200906172124.53451.herton@mandriva.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Qua 17 Jun 2009, às 21:05:56, Herton Ronaldo Krzesinski escreveu:
> Em Qua 17 Jun 2009, às 20:35:13, Frank Mori Hess escreveu:
> > On Wednesday 17 June 2009, Herton Ronaldo Krzesinski wrote:
> > > Also s626_attach is modified to use now pci_get_subsys instead of
> > > pci_get_device as reported by Ian Abbott, additionaly ensuring that
> > > subvendor or subdevice id is set in pci id table entries.
> > >
> > > Reference: http://lkml.org/lkml/2009/6/16/552
> > > ---
> > >  drivers/staging/comedi/drivers/s626.c |   35
> > > ++++++++++++++++++++------------ 1 files changed, 22 insertions(+), 13
> > > deletions(-)
> > >
> > > diff --git a/drivers/staging/comedi/drivers/s626.c
> > > b/drivers/staging/comedi/drivers/s626.c index 30dec9d..3ec4407 100644
> > > --- a/drivers/staging/comedi/drivers/s626.c
> > > +++ b/drivers/staging/comedi/drivers/s626.c
> > > @@ -110,9 +110,9 @@ static const struct s626_board s626_boards[] = {
> > >  #define PCI_VENDOR_ID_S626 0x1131
> > >  #define PCI_DEVICE_ID_S626 0x7146
> > >
> > > +/* sub pci id must be specified, see s626_attach for more details */
> > >  static DEFINE_PCI_DEVICE_TABLE(s626_pci_table) = {
> > > -	{PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> > > -		0},
> > > +	{PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626, 0x6000, 0x0272, 0, 0, 0},
> > >  	{0}
> > >  };
> > >
> > > @@ -498,24 +498,33 @@ static int s626_attach(struct comedi_device *dev,
> > > struct comedi_devconfig *it) resource_size_t resourceStart;
> > >  	dma_addr_t appdma;
> > >  	struct comedi_subdevice *s;
> > > -	struct pci_dev *pdev;
> > > +	const struct pci_device_id *ids;
> > > +	struct pci_dev *pdev = NULL;
> > >
> > >  	if (alloc_private(dev, sizeof(struct s626_private)) < 0)
> > >  		return -ENOMEM;
> > >
> > > -	for (pdev = pci_get_device(PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626,
> > > -			NULL); pdev != NULL;
> > > -		pdev = pci_get_device(PCI_VENDOR_ID_S626,
> > > -			PCI_DEVICE_ID_S626, pdev)) {
> > > +	/*
> > > +	 * Require also one of sub pci ids to be defined (see check below),
> > > +	 * otherwise there will be a clash with Philips SAA7146 media/dvb
> > > +	 * based cards (they have same vendor:device == 0x1131:0x7146 pair
> > > +	 * as main S626 cards)
> > > +	 */
> > > +	for (ids = s626_pci_table;
> > > +	     (ids->vendor && (ids->subvendor || ids->subdevice)) && !pdev;
> > > +	     ids++) {
> > > +		pdev = pci_get_subsys(ids->vendor, ids->device, ids->subvendor,
> > > +				      ids->subdevice, NULL);
> > > +		if (!pdev)
> > > +			continue;
> > > +
> > >  		if (it->options[0] || it->options[1]) {
> > > +			/* matches requested bus/slot */
> > >  			if (pdev->bus->number == it->options[0] &&
> > > -				PCI_SLOT(pdev->devfn) == it->options[1]) {
> > > -				/* matches requested bus/slot */
> > > +			    PCI_SLOT(pdev->devfn) == it->options[1])
> > >  				break;
> > > -			}
> > > -		} else {
> > > -			/* no bus/slot specified */
> > > -			break;
> > > +			pci_dev_put(pdev);
> > > +			pdev = NULL;
> > >  		}
> > >  	}
> > >  	devpriv->pdev = pdev;
> > 
> > 
> > This patch looks buggy.  It's changing the logic beyond just checking for 
> > subvendor/subdevice ids.
> > 
> 
> That's the intention here, so that it avoids someone adding a new pci id
> without specifying either subvendor or subdevice id for 0x1131:0x7146 boards,
> but yes there will be a problem if boards with vendor:id not equal to
> 0x1131:0x7146 appear in future, as you will be obliged to add
> subvendor:subdevice id even if not needed.
> 
> If not wanted and it gone too far, I can revert to use the same logic as
> pci_match_id, or just simplify this in case it's unlikely more s626 boards
> appear.
> 
> The current situation is ugly, comedi subsystem could have a better way to deal
> with hotplug and probe of devices, without you having to reimplement what pci
> subsystem functions already does.

Erm... forget that, you mean the "/* no bus/slot specified */" I removed. That
previous logic to me didn't made much sense, why you must always request a
particular bus/slot?

--
[]'s
Herton
