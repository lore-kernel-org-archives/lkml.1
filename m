Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbYDWV6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbYDWV6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 17:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYDWV6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 17:58:32 -0400
Received: from rv-out-0708.google.com ([209.85.198.242]:15763 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752120AbYDWV6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 17:58:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding:from;
        b=YaBxhxEktEgFOIC4IKnOCxDr5TKiRUTt7UEA96ZSOu9XSd1zrLeMYgrU/oT241+905BfkuRcEJlSKUCjdquBmAaE5+W9BlaNNOqTtz6/niUVgmZSZbsapwNNhBboaEWC6gLTQLAFDjlS/LChqI+1hBPpGUx7Tt5SS54rIiBpSJ0=
Reply-To: yhlu.kernel@gmail.com
To: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "David Miller" <davem@davemloft.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>, tglx@linutronix.de
Subject: [PATCH 1/2] pci/irq: restore mask_bits in msi shutdown -v3
Date: Wed, 23 Apr 2008 14:56:30 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Greg KH" <greg@kroah.com>, "Jeff Garzik" <jeff@garzik.org>,
       "linux-pci" <linux-pci@atrey.karlin.mff.cuni.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Sathya Prakash <sathya.prakash@lsi.com>
References: <200804222148.17530.yhlu.kernel@gmail.com>
In-Reply-To: <200804222148.17530.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804231456.30786.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Yinghai found after using 2.6.25-rc3 later to kexec RHEL 5.1,
NIC can not be used.

bisected to

| commit 89d694b9dbe769ca1004e01db0ca43964806a611
| Author: Thomas Gleixner <tglx@linutronix.de>
| Date:   Mon Feb 18 18:25:17 2008 +0100
|
|   genirq: do not leave interupts enabled on free_irq
|
|   The default_disable() function was changed in commit:
|
|    76d2160147f43f982dfe881404cfde9fd0a9da21
|    genirq: do not mask interrupts by default
|
|   It removed the mask function in favour of the default delayed
|   interrupt disabling. Unfortunately this also broke the shutdown in
|   free_irq() when the last handler is removed from the interrupt for
|   those architectures which rely on the default implementations. Now we
|   can end up with a enabled interrupt line after the last handler was
|   removed, which can result in spurious interrupts.
|
|   Fix this by adding a default_shutdown function, which is only
|   installed, when the irqchip implementation does provide neither a
|   shutdown nor a disable function.
|
|   [@stable: affected versions: .21 - .24 ]

for MSI, default_shutdown will call mask_bit for msi device.  so all mask bits
will left disabled after free_irq.  then if kexec next kernel that only can
use msi_enable bit.  all device's MSI can not be used.

want to try to restore MSI mask bits that is saved before using msi in first
kernel.

Eric said:
This is over complicated and for hardware that erroneously triggers
a msi irq after free_irq may have potential problems.

So lets do the much simpler, much safer, and more general method of
restoring the mask bit to it's pci reset defined value (enabled) when
we disable the kernels use of msi.

it will work, because pci_diable_msi is called after free_irq is called.

v3: extend msi_set_mask_bit to msi_set_mask_bits to take mask, so we can fully
restore that to 0x00 instead of 0xfe.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/drivers/pci/msi.c
===================================================================
--- linux-2.6.orig/drivers/pci/msi.c
+++ linux-2.6/drivers/pci/msi.c
@@ -123,7 +123,7 @@ static void msix_flush_writes(unsigned i
 	}
 }
 
-static void msi_set_mask_bit(unsigned int irq, int flag)
+static void msi_set_mask_bits(unsigned int irq, u32 mask, u32 flag)
 {
 	struct msi_desc *entry;
 
@@ -137,8 +137,8 @@ static void msi_set_mask_bit(unsigned in
 
 			pos = (long)entry->mask_base;
 			pci_read_config_dword(entry->dev, pos, &mask_bits);
-			mask_bits &= ~(1);
-			mask_bits |= flag;
+			mask_bits &= ~(mask);
+			mask_bits |= flag & mask;
 			pci_write_config_dword(entry->dev, pos, mask_bits);
 		} else {
 			msi_set_enable(entry->dev, !flag);
@@ -241,13 +241,13 @@ void write_msi_msg(unsigned int irq, str
 
 void mask_msi_irq(unsigned int irq)
 {
-	msi_set_mask_bit(irq, 1);
+	msi_set_mask_bits(irq, 1, 1);
 	msix_flush_writes(irq);
 }
 
 void unmask_msi_irq(unsigned int irq)
 {
-	msi_set_mask_bit(irq, 0);
+	msi_set_mask_bits(irq, 1, 0);
 	msix_flush_writes(irq);
 }
 
@@ -291,7 +291,8 @@ static void __pci_restore_msi_state(stru
 	msi_set_enable(dev, 0);
 	write_msi_msg(dev->irq, &entry->msg);
 	if (entry->msi_attrib.maskbit)
-		msi_set_mask_bit(dev->irq, entry->msi_attrib.masked);
+		msi_set_mask_bits(dev->irq, entry->msi_attrib.maskbits_mask,
+				  entry->msi_attrib.masked);
 
 	pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &control);
 	control &= ~(PCI_MSI_FLAGS_QSIZE | PCI_MSI_FLAGS_ENABLE);
@@ -315,7 +316,7 @@ static void __pci_restore_msix_state(str
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
 		write_msi_msg(entry->irq, &entry->msg);
-		msi_set_mask_bit(entry->irq, entry->msi_attrib.masked);
+		msi_set_mask_bits(entry->irq, 1, entry->msi_attrib.masked);
 	}
 
 	BUG_ON(list_empty(&dev->msi_list));
@@ -382,6 +383,7 @@ static int msi_capability_init(struct pc
 		pci_write_config_dword(dev,
 			msi_mask_bits_reg(pos, is_64bit_address(control)),
 			maskbits);
+		entry->msi_attrib.maskbits_mask = temp;
 	}
 	list_add_tail(&entry->list, &dev->msi_list);
 
@@ -583,6 +585,11 @@ void pci_disable_msi(struct pci_dev* dev
 
 	BUG_ON(list_empty(&dev->msi_list));
 	entry = list_entry(dev->msi_list.next, struct msi_desc, list);
+	/* Return the the pci reset with msi irqs unmasked */
+	if (entry->msi_attrib.maskbit) {
+		u32 mask = entry->msi_attrib.maskbits_mask;
+		msi_set_mask_bits(dev->irq, mask, ~mask);
+	}
 	if (!entry->dev || entry->msi_attrib.type != PCI_CAP_ID_MSI) {
 		return;
 	}
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 94bb46d..8f29392 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -22,6 +22,7 @@ struct msi_desc {
 		__u8	masked	: 1;
 		__u8	is_64	: 1;	/* Address size: 0=32bit 1=64bit  */
 		__u8	pos;	 	/* Location of the msi capability */
+		__u32	maskbits_mask;  /* mask bits mask */
 		__u16	entry_nr;    	/* specific enabled entry 	  */
 		unsigned default_irq;	/* default pre-assigned irq	  */
 	}msi_attrib;
