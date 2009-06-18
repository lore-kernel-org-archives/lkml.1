Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbZFRRXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbZFRRXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbZFRRXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:23:15 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:51777 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbZFRRXO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:23:14 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Organization: Mandriva
To: fmhess@users.sourceforge.net
Subject: Re: staging driver s626 clashes with philips SAA7146 media/dvb based cards
Date: Thu, 18 Jun 2009 14:23:09 -0300
User-Agent: KMail/1.11.90 (Linux/2.6.30-desktop-1mnb; KDE/4.2.90; i686; ; )
Cc: Ian Abbott <abbotti@mev.co.uk>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Gianluca Palli <gpalli@deis.unibo.it>, David Schleef <ds@schleef.org>
References: <200906161701.45234.herton@mandriva.com.br> <200906172137.43870.herton@mandriva.com.br> <200906180328.07976.fmhess@speakeasy.net>
In-Reply-To: <200906180328.07976.fmhess@speakeasy.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200906181423.11245.herton@mandriva.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Quinta-feira 18 Junho 2009, às 04:28:04, Frank Mori Hess escreveu:
> On Wednesday 17 June 2009, Herton Ronaldo Krzesinski wrote:
> > >
> > > Your patch breaks configuration of the board unless the bus and slot
> > > are explicitly specified.  Just make a minimal patch that replaces
> > > pci_get_device with pci_get_subsys and fixes the problem that was
> > > reported.
> >
> > Hmm that's not what the patch does, it doesn't break configuration,
> > keeps the same logic as before (I was wrong in my last email replying to
> > myself), check it, if it->options[0] and it->options[1] isn't specified,
> > the pdev is valid so the for loop exits (see !pdev check).
> 
> Your right.  However, it also turns a loop over pci devices into a loop 
> over pci ids, which appears to break the case of multiple s626 boards 
> where the bus/slot of the second s626 board is specified.  If you're not 
> willing to provide a minimal patch that just fixes the reported problem, 
> just say so.  It would have been less effort for me to do it myself than 
> analyze what your changes are breaking.

That's part of reviewing process, I just wanted to enhance it in case more pci
ids are added in the future along with the switch to pci_get_subsys, I don't
know why you act like that, you don't want the code to be enhanced? Other
comedi driver loop over ids, for example gsc_hpdi

And indeed what you say it's true, there is a bug in the patch now that you
checked it out properly, it has a problem with this multiple s626 case, fixed
that now. Pointing out the problem instead just saying it's broken helps :)

I also removed the obligation to add sub ids and re-factored the patch, that
was too much and not good, just a simpler loop over pci id array is used now,
and a comment was added in pci id list telling people that they should add
subvendor:subdevice ids for boards with vendor:device == 0x1131:0x7146,
in case new boards with this id appear.

Let me know if there is any problem remaining with this version:

Staging: comedi: s626: use subvendor:subdevice ids for SAA7146 board

The current s626 comedi driver in staging conflicts with philips SAA7146
media/dvb based cards, because it claims the same vendor:device pci id
for all subdevice/subvendor ids. What happens is that for people that have a
philips SAA7146 media/dvb based card, s626 if available gets loaded by udev
and makes system freeze (https://qa.mandriva.com/show_bug.cgi?id=51445).

The s626 driver shouldn't claim all 1131:7146 devices. Fix this by
specifying specific known subvendor:subdevice ids in its pci id table
list.

Also s626_attach is modified to use now pci_get_subsys instead of
pci_get_device as reported by Ian Abbott, and now we loop over pci id
table entries in case more ids are added in the future.

Reference: http://lkml.org/lkml/2009/6/16/552

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 30dec9d..4210590 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -110,9 +110,13 @@ static const struct s626_board s626_boards[] = {
 #define PCI_VENDOR_ID_S626 0x1131
 #define PCI_DEVICE_ID_S626 0x7146
 
+/*
+ * For devices with vendor:device id == 0x1131:0x7146 you must specify
+ * also subvendor:subdevice ids, because otherwise it will conflict with
+ * Philips SAA7146 media/dvb based cards.
+ */
 static DEFINE_PCI_DEVICE_TABLE(s626_pci_table) = {
-	{PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		0},
+	{PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626, 0x6000, 0x0272, 0, 0, 0},
 	{0}
 };
 
@@ -498,25 +502,26 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
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
-		if (it->options[0] || it->options[1]) {
-			if (pdev->bus->number == it->options[0] &&
-				PCI_SLOT(pdev->devfn) == it->options[1]) {
+	for (i = 0; i < ARRAY_SIZE(s626_pci_table) && !pdev; i++) {
+		ids = &s626_pci_table[i];
+		do {
+			pdev = pci_get_subsys(ids->vendor, ids->device, ids->subvendor,
+					      ids->subdevice, pdev);
+
+			if ((it->options[0] || it->options[1]) && pdev) {
 				/* matches requested bus/slot */
+				if (pdev->bus->number == it->options[0] &&
+				    PCI_SLOT(pdev->devfn) == it->options[1])
+					break;
+			} else
 				break;
-			}
-		} else {
-			/* no bus/slot specified */
-			break;
-		}
+		} while (1);
 	}
 	devpriv->pdev = pdev;
 


-- 
[]'s
Herton
