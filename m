Return-Path: <linux-kernel-owner+w=401wt.eu-S1759867AbYGQQ45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759867AbYGQQ45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbYGQQ4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:56:48 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52133 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbYGQQ4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:56:47 -0400
Date: Thu, 17 Jul 2008 10:56:31 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Vrabel <david.vrabel@csr.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, linux-pci@vger.kernel.org
Subject: Re: PCI: MSI interrupts masked using prohibited method
Message-ID: <20080717165630.GT25255@parisc-linux.org>
References: <4860D09D.4060801@csr.com> <4864DA54.6000205@csr.com> <200806271007.26248.jbarnes@virtuousgeek.org> <200807161243.03360.jbarnes@virtuousgeek.org> <20080716195853.GL25255@parisc-linux.org> <487F45C0.2080201@csr.com> <20080717153917.GR25255@parisc-linux.org> <alpine.LFD.1.10.0807171745270.4316@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807171745270.4316@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK, here's a patch which does the trick for me.  I put a printk_ratelimit
into the new mask_ack_msi_irq() function, then hammered my AHCI controller
with 16 threads doing directio reads to the same track of a disc.  It came
up pretty reliably, so I would say it's at least minmally tested.  David,
does this solve your problem?

diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 6510cde..693de6c 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -2051,6 +2051,7 @@ static struct irq_chip msi_chip = {
 	.name		= "PCI-MSI",
 	.unmask		= unmask_msi_irq,
 	.mask		= mask_msi_irq,
+	.mask_ack	= mask_ack_msi_irq,
 	.ack		= ack_apic_edge,
 #ifdef CONFIG_SMP
 	.set_affinity	= set_msi_irq_affinity,
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 8c61304..81c9bc6 100644
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
@@ -245,10 +246,27 @@ void mask_msi_irq(unsigned int irq)
 	msix_flush_writes(irq);
 }
 
+/*
+ * If we can't mask the MSI, decline to ack it.  This has the same
+ * effect, only masking in the interrupt controller instead of the
+ * device.  In order to unmask it, we have to ack the interrupt.
+ */
+void mask_ack_msi_irq(unsigned int irq)
+{
+	struct irq_desc *desc = irq_desc + irq;
+	if (msi_set_mask_bits(irq, 1, 1))
+		return;
+	desc->chip->ack(irq);
+}
+
 void unmask_msi_irq(unsigned int irq)
 {
-	msi_set_mask_bits(irq, 1, 0);
-	msix_flush_writes(irq);
+	struct irq_desc *desc = irq_desc + irq;
+	if (!msi_set_mask_bits(irq, 1, 0)) {
+		msix_flush_writes(irq);
+		return;
+	}
+	desc->chip->ack(irq);
 }
 
 static int msi_free_irqs(struct pci_dev* dev);
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 8f29392..316598b 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -11,6 +11,7 @@ struct msi_msg {
 
 /* Helper functions */
 extern void mask_msi_irq(unsigned int irq);
+extern void mask_ack_msi_irq(unsigned int irq);
 extern void unmask_msi_irq(unsigned int irq);
 extern void read_msi_msg(unsigned int irq, struct msi_msg *msg);
 extern void write_msi_msg(unsigned int irq, struct msi_msg *msg);

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
