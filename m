Return-Path: <linux-kernel-owner+w=401wt.eu-S1760756AbYDKXWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756AbYDKXWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 19:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbYDKXWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 19:22:38 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:39408 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946AbYDKXWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 19:22:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=LfFlwo/ADC+BZ2FtlS7wFfBlb8XV+5Srxkn4iooqUpvFAZXYU2YPPt/efZCYjqoePmK9RW40MLGcKBzHQN5k6NJ17vrKQPY95r8kjP+RKJbOpd72UbEpNc9WoDBlLcENWE+343yfB1a3UmttOWD9A5rnfsJyRprpHWqjshWI0MY=
Reply-To: yhlu.kernel@gmail.com
To: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] x86_64: restore mask_bits in msi shutdown
Date: Fri, 11 Apr 2008 16:26:11 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jeff Garzik <jeff@garzik.org>, Ayaz Abdulla <aabdulla@nvidia.com>,
       kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804111626.11232.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can not kexec RHEL 5.1 from 2.6.25-rc3 later

caused by:
commit 89d694b9dbe769ca1004e01db0ca43964806a611
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon Feb 18 18:25:17 2008 +0100

    genirq: do not leave interupts enabled on free_irq

    The default_disable() function was changed in commit:

     76d2160147f43f982dfe881404cfde9fd0a9da21
     genirq: do not mask interrupts by default

    It removed the mask function in favour of the default delayed
    interrupt disabling. Unfortunately this also broke the shutdown in
    free_irq() when the last handler is removed from the interrupt for
    those architectures which rely on the default implementations. Now we
    can end up with a enabled interrupt line after the last handler was
    removed, which can result in spurious interrupts.

    Fix this by adding a default_shutdown function, which is only
    installed, when the irqchip implementation does provide neither a
    shutdown nor a disable function.

    [@stable: affected versions: .21 - .24 ]



for MSI, default_shutdown will call mask_bit for msi device. so all mask bits will
left disabled after free_irq.
then if kexec next kernel that only can use msi_enable bit.
all device's MSI can not be used.

So try to restore MSI mask bits that is saved before using msi in first kernel.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/io_apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_64.c
+++ linux-2.6/arch/x86/kernel/io_apic_64.c
@@ -2003,6 +2003,14 @@ static void set_msi_irq_affinity(unsigne
 }
 #endif /* CONFIG_SMP */
 
+static void msi_shutdown(unsigned int irq)
+{
+	struct irq_desc *desc = irq_desc + irq;
+
+	msi_restore_mask_bits(irq);
+	desc->status |= IRQ_MASKED;
+}
+
 /*
  * IRQ Chip for MSI PCI/PCI-X/PCI-Express Devices,
  * which implement the MSI or MSI-X Capability Structure.
@@ -2012,6 +2020,7 @@ static struct irq_chip msi_chip = {
 	.unmask		= unmask_msi_irq,
 	.mask		= mask_msi_irq,
 	.ack		= ack_apic_edge,
+	.shutdown	= msi_shutdown,
 #ifdef CONFIG_SMP
 	.set_affinity	= set_msi_irq_affinity,
 #endif
Index: linux-2.6/drivers/pci/msi.c
===================================================================
--- linux-2.6.orig/drivers/pci/msi.c
+++ linux-2.6/drivers/pci/msi.c
@@ -123,6 +123,31 @@ static void msix_flush_writes(unsigned i
 	}
 }
 
+void msi_restore_mask_bits(unsigned int irq)
+{
+	struct msi_desc *entry;
+
+	entry = get_irq_msi(irq);
+	BUG_ON(!entry || !entry->dev);
+	switch (entry->msi_attrib.type) {
+	case PCI_CAP_ID_MSI:
+		if (entry->msi_attrib.maskbit) {
+			int pos;
+			u32 mask_bits;
+
+			pos = (long)entry->mask_base;
+			mask_bits = entry->orig_mask_bits;
+			pci_write_config_dword(entry->dev, pos, mask_bits);
+		}
+		break;
+	case PCI_CAP_ID_MSIX:
+		break;
+	default:
+		BUG();
+		break;
+	}
+}
+
 static void msi_set_mask_bit(unsigned int irq, int flag)
 {
 	struct msi_desc *entry;
@@ -376,6 +401,7 @@ static int msi_capability_init(struct pc
 		pci_read_config_dword(dev,
 			msi_mask_bits_reg(pos, is_64bit_address(control)),
 			&maskbits);
+		entry->orig_mask_bits = maskbits;
 		temp = (1 << multi_msi_capable(control));
 		temp = ((temp - 1) & ~temp);
 		maskbits |= temp;
Index: linux-2.6/include/linux/msi.h
===================================================================
--- linux-2.6.orig/include/linux/msi.h
+++ linux-2.6/include/linux/msi.h
@@ -14,6 +14,7 @@ extern void mask_msi_irq(unsigned int ir
 extern void unmask_msi_irq(unsigned int irq);
 extern void read_msi_msg(unsigned int irq, struct msi_msg *msg);
 extern void write_msi_msg(unsigned int irq, struct msi_msg *msg);
+extern void msi_restore_mask_bits(unsigned int irq);
 
 struct msi_desc {
 	struct {
@@ -30,6 +31,7 @@ struct msi_desc {
 	struct list_head list;
 
 	void __iomem *mask_base;
+	u32 orig_mask_bits;  /* restoring it for freeing */
 	struct pci_dev *dev;
 
 	/* Last set MSI message */
