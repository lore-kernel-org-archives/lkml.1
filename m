Return-Path: <linux-kernel-owner+w=401wt.eu-S932256AbYGQTtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256AbYGQTtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757815AbYGQTtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:49:05 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:58241 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757721AbYGQTtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:49:04 -0400
Date: Thu, 17 Jul 2008 13:48:46 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PCI: MSI interrupts masked using prohibited method
Message-ID: <20080717194846.GU25255@parisc-linux.org>
References: <4860D09D.4060801@csr.com> <4864DA54.6000205@csr.com> <200806271007.26248.jbarnes@virtuousgeek.org> <200807161243.03360.jbarnes@virtuousgeek.org> <20080716195853.GL25255@parisc-linux.org> <487F45C0.2080201@csr.com> <20080717153917.GR25255@parisc-linux.org> <alpine.LFD.1.10.0807171745270.4316@apollo.tec.linutronix.de> <20080717165630.GT25255@parisc-linux.org> <487F7DFA.10101@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487F7DFA.10101@csr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 06:14:34PM +0100, David Vrabel wrote:
> Obviously io_apic_32.c will also need a similar change, and are there
> other architectures that will also need fixing similarly?

Yes, several.

> >  		} else {
> > -			msi_set_enable(entry->dev, !flag);
> > +			return 0;
[...]
> >  	entry->msi_attrib.masked = !!flag;
> > +	return 1;
> >  }
[...]
> > +/*
> > + * If we can't mask the MSI, decline to ack it.  This has the same
> > + * effect, only masking in the interrupt controller instead of the
> > + * device.  In order to unmask it, we have to ack the interrupt.
> > + */
> > +void mask_ack_msi_irq(unsigned int irq)
> > +{
> > +	struct irq_desc *desc = irq_desc + irq;
> > +	if (msi_set_mask_bits(irq, 1, 1))
> > +		return;
> > +	desc->chip->ack(irq);
> > +}
> 
> This code doesn't match the comment. Since msi_set_mask_bits() returns
> true if it masked.
> 
> I think you want
> 
> 	if (!msi_set_mask_bits(irq, 1, 1))
> 		return;
> 	desc->chip->ack(irq);

Quite right.  Somehow I managed to test and then send out an earlier
version of this patch.

Unfortunately, testing the right patch results in my machine locking up.
The Intel System Programming Guide, volume 3A points out that x86
interrupts really do have priorities associated with them.  And since
EOI simply clears the highest priority bit, delaying calling ->ack()
just isn't possible.

I've also found some other distressing facts about LAPICs in the guide:

  If more than one interrupt is generated with the same vector number,
  the local APIC can set the bit for the vector both in the IRR and
  the ISR. This means that for the Pentium 4 and Intel Xeon processors,
  the IRR and ISR can queue two interrupts for each interrupt vector:
  one in the IRR and one in the ISR. Any additional interrupts issued for
  the same interrupt vector are collapsed into the single bit in the IRR.

  For the P6 family and Pentium processors, the IRR and ISR registers can
  queue no more than two interrupts per priority level, and will reject
  other interrupts that are received within the same priority level.

So I think I'll disable multiple MSI for processors predating the P4.

I think David's original patch (just declining to mask the interrupt)
is the best approach to take.  Perhaps architectures with saner
interrupt hardware would like to try the approach I've mentioned here.

I don't like the comment in http://lkml.org/lkml/2008/6/27/199 as it's
not prohibited ... just a bad idea.  How about this patch?

---

David Vrabel points out that using the MSI Enable bit to disable
interrupts is a bad idea when the PCI device doesn't implement the INTx
disable bit.  It will cause spurious interrupts to be generated on the
INTx pin.

Masking the interrupt is simply a performance optimisation; we can
happily let the device continue to interrupt us.  In order to support
future optimisations, report success / failure from msi_set_mask_bits().

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 8c61304..ba0fd05 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -123,7 +123,7 @@ static void msix_flush_writes(unsigned int irq)
 	}
 }
 
-static void msi_set_mask_bits(unsigned int irq, u32 mask, u32 flag)
+static int msi_set_mask_bits(unsigned int irq, u32 mask, u32 flag)
 {
 	struct msi_desc *entry;
 
@@ -141,7 +141,7 @@ static void msi_set_mask_bits(unsigned int irq, u32 mask, u32 flag)
 			mask_bits |= flag & mask;
 			pci_write_config_dword(entry->dev, pos, mask_bits);
 		} else {
-			msi_set_enable(entry->dev, !flag);
+			return 0;
 		}
 		break;
 	case PCI_CAP_ID_MSIX:
@@ -157,6 +157,7 @@ static void msi_set_mask_bits(unsigned int irq, u32 mask, u32 flag)
 		break;
 	}
 	entry->msi_attrib.masked = !!flag;
+	return 1;
 }
 
 void read_msi_msg(unsigned int irq, struct msi_msg *msg)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
