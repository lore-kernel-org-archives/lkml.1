Return-Path: <linux-kernel-owner+w=401wt.eu-S1757170AbYGRKdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170AbYGRKdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 06:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbYGRKdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 06:33:31 -0400
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:49294 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbYGRKda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 06:33:30 -0400
Message-ID: <48807166.9010006@csr.com>
Date: Fri, 18 Jul 2008 11:33:10 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PCI: MSI interrupts masked using prohibited method
References: <4860D09D.4060801@csr.com> <4864DA54.6000205@csr.com> <200806271007.26248.jbarnes@virtuousgeek.org> <200807161243.03360.jbarnes@virtuousgeek.org> <20080716195853.GL25255@parisc-linux.org> <487F45C0.2080201@csr.com> <20080717153917.GR25255@parisc-linux.org> <alpine.LFD.1.10.0807171745270.4316@apollo.tec.linutronix.de> <20080717165630.GT25255@parisc-linux.org> <487F7DFA.10101@csr.com> <20080717194846.GU25255@parisc-linux.org>
In-Reply-To: <20080717194846.GU25255@parisc-linux.org>
Content-Type: multipart/mixed;
 boundary="------------050603020401000207060205"
X-OriginalArrivalTime: 18 Jul 2008 10:33:09.0916 (UTC) FILETIME=[AC6C25C0:01C8E8C1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050603020401000207060205
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Matthew Wilcox wrote:
> 
> I think David's original patch (just declining to mask the interrupt)
> is the best approach to take.  Perhaps architectures with saner
> interrupt hardware would like to try the approach I've mentioned here.
> 
> I don't like the comment in http://lkml.org/lkml/2008/6/27/199 as it's
> not prohibited ... just a bad idea.  How about this patch?

The PCI specification is quite clear that it's prohibited.  The problem
also is more severe than simply having spurious interrupts -- with some
devices if a line interrupt is generated (regardless of whether it ends
up on the bus) then no more interrupts are generated.

I also think that the change requires a comment in the code.  It odd to
have a mask function that doesn't really mask so a comment is necessary
to explain why this is.

Please apply this instead.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/

--------------050603020401000207060205
Content-Type: text/x-diff;
 name="pci-dont-mask-msi-with-msi-enable-bit.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="pci-dont-mask-msi-with-msi-enable-bit.patch"

PCI: don't mask MSIs with MSI Enable bit

Trying to mask MSIs with the MSI Enable results in some devices
generating a line interrupt (which may not appear on the bus if the
INTX# Disable bit is set).  This interrupt will be lost and some
devices will generate no further interrupts (even after MSI Enable is
set again).

The PCI Local Bus Specification Revision 3.0, section 6.8.1.3. Message
Control for MSI on page 236, prohibits the use of the MSI Enable bit for
masking and unmasking the interrupt.

    "MSI Enable:  If 1 and the MSI-X Enable bit in the MSI-X Message
     Control register (see Section 6.8.2.3) is 0, the
     function is permitted to use MSI to request service
     and is prohibited from using its INTx# pin (if
     implemented; see Section 6.2.4 Interrupt pin register).
     System configuration software sets this bit to enable
     MSI. A device driver is prohibited from writing this bit
     to mask a function’s service request."

There is no alternative method for mask/unmask on PCI devices with MSI
and no specific mask bit.  In this case, the device driver will have
to ensure that MSIs are only generated when the device driver can
handle them (via some hardware specific mechanism such as
acknowledging the interrupt at the end of the interrupt handler) .

Signed-off-by: David Vrabel <david.vrabel@csr.com>
---
 drivers/pci/msi.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: linux-2.6-working/drivers/pci/msi.c
===================================================================
--- linux-2.6-working.orig/drivers/pci/msi.c	2008-06-27 12:24:17.000000000 +0100
+++ linux-2.6-working/drivers/pci/msi.c	2008-06-27 12:25:05.000000000 +0100
@@ -141,7 +141,18 @@
 			mask_bits |= flag & mask;
 			pci_write_config_dword(entry->dev, pos, mask_bits);
 		} else {
-			msi_set_enable(entry->dev, !flag);
+			/*
+			 * If there is no mask bit, this irq cannot be
+			 * masked and the driver will have to use
+			 * whatever hardware specific mechanisms are
+			 * available to control the sending of MSI
+			 * messages.
+			 *
+			 * Note: cannot attempt to mask via the MSI
+			 * enable bit as that is prohibited by the PCI
+			 * specification.
+			 */
+			return;
 		}
 		break;
 	case PCI_CAP_ID_MSIX:

--------------050603020401000207060205--
