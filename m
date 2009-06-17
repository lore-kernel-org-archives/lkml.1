Return-Path: <linux-kernel-owner+w=401wt.eu-S1761315AbZFQXKC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761315AbZFQXKC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 19:10:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbZFQXJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 19:09:53 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:51837 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbZFQXJw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 19:09:52 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Organization: Mandriva
To: Ian Abbott <abbotti@mev.co.uk>
Subject: Re: staging driver s626 clashes with philips SAA7146 media/dvb based cards
Date: Wed, 17 Jun 2009 20:09:50 -0300
User-Agent: KMail/1.11.90 (Linux/2.6.30-desktop-1mnb; KDE/4.2.90; i686; ; )
Cc: Ian Abbott <ian.abbott@mev.co.uk>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Gianluca Palli <gpalli@deis.unibo.it>, David Schleef <ds@schleef.org>,
       Frank Mori Hess <fmhess@users.sourceforge.net>
References: <200906161701.45234.herton@mandriva.com.br> <200906171345.19815.herton@mandriva.com.br> <4A39343C.7030908@mev.co.uk>
In-Reply-To: <4A39343C.7030908@mev.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200906172009.50798.herton@mandriva.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Qua 17 Jun 2009, às 15:21:48, Ian Abbott escreveu:
> Herton Ronaldo Krzesinski wrote:
> > Em Quarta-feira 17 Junho 2009, às 09:26:00, Ian Abbott escreveu:
> >> Herton Ronaldo Krzesinski wrote:
> >>> Em Terça-feira 16 Junho 2009, às 17:51:21, Greg KH escreveu:
> >>>> On Tue, Jun 16, 2009 at 05:01:44PM -0300, Herton Ronaldo Krzesinski wrote:
> >>>>> Hi,
> >>>>>
> >>>>> The s626 (comedi) driver in staging conflicts with philips SAA7146
> >>>>> media/dvb based cards, because it claims the same vendor:device pci id
> >>>>> for all subdevice/subvendor ids. What happens is that for people that
> >>>>> have a philips SAA7146 based card, s626 if available gets loaded by udev
> >>>>> and makes system freeze (https://qa.mandriva.com/show_bug.cgi?id=51445).
> >>>> So a PCI device that does different things has the same device ids?
> >>>> ick, stupid vendors...
> >>>>
> >>>>> Looks like s626 shouldn't claim all 1131:7146 devices, either by
> >>>>> specifying specific subdevice/subvendor ids specific to s626 devices or
> >>>>> doing additional checks in its probe/attach function.
> >>>> If you can propose the proper sub ids, or the needed checks, please send
> >>>> a patch.
> >>> Can't propose proper sub ids here etc., as I don't know about/don't have s626
> >>> device, s626 author is CC'ed here to check this. But I could send a patch to
> >>> disable just the build of s626 if acceptable/desired for the moment.
> >> The Windows driver (<http://www.sensoray.com/downloads/sdk626.zip>) has
> >> this in the models section of the INF file:
> >>
> >> %sx26.DeviceDesc%=sxdrv.Device,PCI\VEN_1131&DEV_7146&SUBSYS_02726000
> >>
> >> And it looks like the correct device because this the strings section
> >> contains:
> >>
> >> sx26.DeviceDesc=   "Sensoray Model 626 Analog/Digital I/O"
> >>
> >> Interpreting the above information gives us:
> >>
> >> PCI Vendor ID = 0x1131
> >> PCI Device ID = 0x7146
> >> PCI Subvendor ID = 0x6000
> >> PCI Subdevice ID = 0x0272 (626)
> >>
> >> The Linux SDK for this board
> >> (<http://www.sensoray.com/downloads/s626-1.0.1.tar.gz> has the same info
> >> in the s626core.h file.
> >
> > Ok thanks. So lets limit s626 by its subvendor:subdevice id, patch follows:
> >
> > From 6f4d2430959a378ab754c5dbd3903fdcf33abe36 Mon Sep 17 00:00:00 2001
> > From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> > Date: Wed, 17 Jun 2009 13:31:15 -0300
> > Subject: [PATCH] Staging: comedi: use subvendor:subdevice ids for its pci id device table
> >
> > The current s626 comedi driver in staging conflicts with philips SAA7146
> > media/dvb based cards, because it claims the same vendor:device pci id
> > for all subdevice/subvendor ids. What happens is that for people that
> > have a philips SAA7146 based card, s626 if available gets loaded by udev
> > and makes system freeze (https://qa.mandriva.com/show_bug.cgi?id=51445).
> >
> > The s626 driver shouldn't claim all 1131:7146 devices. Fix this by
> > specifying specific known subvendor:subdevice ids in its pci id table
> > list.
> >
> > Reference: http://lkml.org/lkml/2009/6/16/552
> >
> > Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> > ---
> >  drivers/staging/comedi/drivers/s626.c |    8 ++++++--
> >  1 files changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
> > index 30dec9d..b4b7713 100644
> > --- a/drivers/staging/comedi/drivers/s626.c
> > +++ b/drivers/staging/comedi/drivers/s626.c
> > @@ -110,9 +110,13 @@ static const struct s626_board s626_boards[] = {
> >  #define PCI_VENDOR_ID_S626 0x1131
> >  #define PCI_DEVICE_ID_S626 0x7146
> >
> > +/*
> > + * Note: always specify subvendor:subdevice ids in table below, to avoid
> > + * clash with Philips SAA7146 media/dvb based cards which have same
> > + * vendor:device ids as S626
> > + */
> >  static DEFINE_PCI_DEVICE_TABLE(s626_pci_table) = {
> > -       {PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> > -               0},
> > +       {PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626, 0x6000, 0x0272, 0, 0, 0},
> >         {0}
> >  };
> >
> > --
> > 1.6.3.2
> 
> There are also a couple of calls to pci_get_device() that need changing
> to pci_get_subsys() in the s626_attach() function (so it also might be
> worth #define'ing the subsys numbers to avoid repeating these magic
> numbers).

Indeed, using pci_get_device() would still cause problems if s626 is manually
modprobed. Check new patch below, it now uses pci_get_subsys and ensures we use
subvendor or subdevice. I didn't removed the define, may be there could be more
s626 cards available in future with same id? If not, it could be cleaned up
and may be logic at s626_attach() simplified.

>From 6c83b8665da770c2d60fe692819107e3d0bc329d Mon Sep 17 00:00:00 2001
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Date: Wed, 17 Jun 2009 19:56:33 -0300
Subject: [PATCH v2] Staging: comedi (s626): always use subvendor:subdevice ids in pci id table

The current s626 comedi driver in staging conflicts with philips SAA7146
media/dvb based cards, because it claims the same vendor:device pci id
for all subdevice/subvendor ids. What happens is that for people that
have a philips SAA7146 based card, s626 if available gets loaded by udev
and makes system freeze (https://qa.mandriva.com/show_bug.cgi?id=51445).

The s626 driver shouldn't claim all 1131:7146 devices. Fix this by
specifying specific known subvendor:subdevice ids in its pci id table
list.

Also s626_attach is modified to use now pci_get_subsys instead of
pci_get_device as reported by Ian Abbott, additionaly ensuring that
subvendor or subdevice id is set in pci id table entries.

Reference: http://lkml.org/lkml/2009/6/16/552
---
 drivers/staging/comedi/drivers/s626.c |   35 ++++++++++++++++++++------------
 1 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 30dec9d..3ec4407 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -110,9 +110,9 @@ static const struct s626_board s626_boards[] = {
 #define PCI_VENDOR_ID_S626 0x1131
 #define PCI_DEVICE_ID_S626 0x7146
 
+/* sub pci id must be specified, see s626_attach for more details */
 static DEFINE_PCI_DEVICE_TABLE(s626_pci_table) = {
-	{PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		0},
+	{PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626, 0x6000, 0x0272, 0, 0, 0},
 	{0}
 };
 
@@ -498,24 +498,33 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	resource_size_t resourceStart;
 	dma_addr_t appdma;
 	struct comedi_subdevice *s;
-	struct pci_dev *pdev;
+	const struct pci_device_id *ids;
+	struct pci_dev *pdev = NULL;
 
 	if (alloc_private(dev, sizeof(struct s626_private)) < 0)
 		return -ENOMEM;
 
-	for (pdev = pci_get_device(PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626,
-			NULL); pdev != NULL;
-		pdev = pci_get_device(PCI_VENDOR_ID_S626,
-			PCI_DEVICE_ID_S626, pdev)) {
+	/*
+	 * Require also one of sub pci ids to be defined (see check below),
+	 * otherwise there will be a clash with Philips SAA7146 media/dvb
+	 * based cards (they have same vendor:device == 0x1131:0x7146 pair
+	 * as main S626 cards)
+	 */
+	for (ids = s626_pci_table;
+	     (ids->vendor && (ids->subvendor || ids->subdevice)) && !pdev;
+	     ids++) {
+		pdev = pci_get_subsys(ids->vendor, ids->device, ids->subvendor,
+				      ids->subdevice, NULL);
+		if (!pdev)
+			continue;
+
 		if (it->options[0] || it->options[1]) {
+			/* matches requested bus/slot */
 			if (pdev->bus->number == it->options[0] &&
-				PCI_SLOT(pdev->devfn) == it->options[1]) {
-				/* matches requested bus/slot */
+			    PCI_SLOT(pdev->devfn) == it->options[1])
 				break;
-			}
-		} else {
-			/* no bus/slot specified */
-			break;
+			pci_dev_put(pdev);
+			pdev = NULL;
 		}
 	}
 	devpriv->pdev = pdev;
-- 
1.6.3.2

> 
> --
> -=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>             )=-
> -=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587              )=-
> 
> 
> 

--
[]'s
Herton
