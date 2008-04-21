Return-Path: <linux-kernel-owner+w=401wt.eu-S1758861AbYDUTWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbYDUTWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbYDUTVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:21:55 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:48232 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbYDUTVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:21:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=l+Pa0C7/Gl9Hr+lwByY+bsYLNB0iZE0Nx7RBEPOhNe453ab79hseY78P654mfPy6ezzgjKRgQP6rBT9x7DfOtitEzOZkJYlOsh7Wp5YqKCwHip4HueRetLTBDCQZmA/seHo5i0GTGIpL0zWFz2ZZ+mariF8Be8ecYzv/k6aAMfA=
Reply-To: yhlu.kernel@gmail.com
To: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] x86_64: restore mask_bits in msi shutdown
Date: Mon, 21 Apr 2008 12:21:21 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, tglx@linutronix.de,
       aabdulla@nvidia.com, jeff@garzik.org
References: <200804182028.m3IKSKHY013602@imap1.linux-foundation.org> <86802c440804182315y5f7e4d80j678e7f510a8f0763@mail.gmail.com> <m163udu5by.fsf@frodo.ebiederm.org>
In-Reply-To: <m163udu5by.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804211221.22207.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

We should use this one.

YH

---

[PATCH] irq: restore mask_bits in msi shutdown -v2

From: "Eric W. Biederman" <ebiederm@xmission.com>

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

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Yinghai Lu <yhlu.kernel@gmail.com>
Tested-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 26938da..b9ff895 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -583,6 +583,9 @@ void pci_disable_msi(struct pci_dev* dev)
 
 	BUG_ON(list_empty(&dev->msi_list));
 	entry = list_entry(dev->msi_list.next, struct msi_desc, list);
+	/* Return the the pci reset with msi irqs unmasked */
+	if (entry->msi_attrib.maskbit)
+		msi_set_mask_bit(dev->irq, 0);
 	if (!entry->dev || entry->msi_attrib.type != PCI_CAP_ID_MSI) {
 		return;
 	}
