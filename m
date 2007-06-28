Return-Path: <linux-kernel-owner+w=401wt.eu-S932466AbXF1XCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466AbXF1XCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 19:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765928AbXF1XCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 19:02:21 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:43545 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765360AbXF1XCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 19:02:17 -0400
Date: Thu, 28 Jun 2007 16:04:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Wilcox <matthew@wil.cx>,
       Matt Domsch <Matt_Domsch@dell.com>, lkml <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz
Subject: [PATCH] PCI: limit pci_get_bus_and_slot to domain 0
Message-Id: <20070628160421.141c4178.randy.dunlap@oracle.com>
In-Reply-To: <4682AD9B.9060105@zytor.com>
References: <20070626132622.3226261a.randy.dunlap@oracle.com>
	<20070627024505.GA30197@humbolt.us.dell.com>
	<20070627113048.GU22063@parisc-linux.org>
	<20070627145500.2e66fd49@the-village.bc.nu>
	<46829345.1000607@zytor.com>
	<20070627165429.GY22063@parisc-linux.org>
	<20070627182518.50423241@the-village.bc.nu>
	<4682AD9B.9060105@zytor.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 14:34:03 -0400 H. Peter Anvin wrote:

> Alan Cox wrote:
> > On Wed, 27 Jun 2007 10:54:30 -0600
> > Matthew Wilcox <matthew@wil.cx> wrote:
> > 
> >> On Wed, Jun 27, 2007 at 12:41:41PM -0400, H. Peter Anvin wrote:
> >>> Note that EDD has no way of referencing anything but the zero domain 
> >>> (which is presumably the one which is addressed by I/O ports CF8/CFC on 
> >>> the BSP.)  So in this particular case I would say pci_get_bus_and_slot() 
> >>> is fine.
> >> Except that you're not guaranteed to get the bus that's in domain zero.
> > 
> > Which is trivial to fix
> 
> Yes, and that's probably the only sane definition of that API.

Is this what you mean?
---

From: Randy Dunlap <randy.dunlap@oracle.com>

Limit pci_get_bus_and_slot() to domain (segment) 0 since domain is not
specified in the function call and defaulting to domain 0 is the only
reasonable thing to do (rather than returning a device from some other
unknown domain).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/pci/search.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- linux-2622-rc6mm1.orig/drivers/pci/search.c
+++ linux-2622-rc6mm1/drivers/pci/search.c
@@ -173,12 +173,14 @@ struct pci_dev * pci_get_slot(struct pci
 }
 
 /**
- * pci_get_bus_and_slot - locate PCI device from a given PCI slot
+ * pci_get_bus_and_slot - locate PCI device from a given PCI bus & slot
  * @bus: number of PCI bus on which desired PCI device resides
  * @devfn: encodes number of PCI slot in which the desired PCI
  * device resides and the logical device number within that slot
  * in case of multi-function devices.
  *
+ * Note: the bus/slot search is limited to PCI domain (segment) 0.
+ *
  * Given a PCI bus and slot/function number, the desired PCI device
  * is located in system global list of PCI devices.  If the device
  * is found, a pointer to its data structure is returned.  If no
@@ -191,7 +193,8 @@ struct pci_dev * pci_get_bus_and_slot(un
 	struct pci_dev *dev = NULL;
 
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
-		if (dev->bus->number == bus && dev->devfn == devfn)
+		if (pci_domain_nr(dev->bus) == 0 &&
+		   (dev->bus->number == bus && dev->devfn == devfn))
 			return dev;
 	}
 	return NULL;
