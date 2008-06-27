Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbYF0MWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbYF0MWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761645AbYF0MRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:17:53 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:53975 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762419AbYF0MRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:17:51 -0400
Message-ID: <4864DA54.6000205@csr.com>
Date: Fri, 27 Jun 2008 13:17:24 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: PCI: MSI interrupts masked using prohibited method
References: <4860D09D.4060801@csr.com> <200806251420.51751.jbarnes@virtuousgeek.org>
In-Reply-To: <200806251420.51751.jbarnes@virtuousgeek.org>
Content-Type: multipart/mixed;
 boundary="------------090402020203030401020800"
X-OriginalArrivalTime: 27 Jun 2008 12:17:24.0344 (UTC) FILETIME=[C1AD5F80:01C8D84F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090402020203030401020800
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

Jesse Barnes wrote:
> On Tuesday, June 24, 2008 3:46 am David Vrabel wrote:
>> PCI MSI interrupts are masked and unmasked using a method (by writing
>> the MSI Enable capability bit) that is prohibited by the PCI specification.
> 
> Yeah, it's probably quite a bit slower too (I assume you're talking about 
> io_apic_64's msi_mask_irq).  Seems like masking this at the ioapic level 
> would make more sense anyway...
> 
>> This behaviour can cause missed interrupts with some devices if the
>> interrupt is asserted by the hardware while MSI is disabled.
>>
>> I believe the interrupt should be masked/unmasked on the interrupt
>> controller (the APIC on x86, for example).   I'm going to test this now
>> and see if it works.

After further research it seems that MSI interrupts aren't routed via
the IO-APIC, so this cannot be done.

I think the only solution is to not perform any sort of masking and rely
on the device driver being able to handle this.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/

--------------090402020203030401020800
Content-Type: text/x-diff;
 name="pci-dont-mask-msi-with-msi-enable-bit.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="pci-dont-mask-msi-with-msi-enable-bit.patch"

PCI: don't mask MSI's with MSI Enable bit

The PCI Local Bus Specification Revision 3.0, section 6.8.1.3. Message
Control for MSI on page 236, prohibited the use of the MSI Enable bit for
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
to ensure (via some hardware specific mechanism) that MSI's are only
generated when the device driver can handle them.

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

--------------090402020203030401020800--
