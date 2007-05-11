Return-Path: <linux-kernel-owner+w=401wt.eu-S1762023AbXEKU0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762023AbXEKU0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758519AbXEKU0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:26:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57248
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758379AbXEKU0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:26:40 -0400
Date: Fri, 11 May 2007 13:26:44 -0700 (PDT)
Message-Id: <20070511.132644.78708151.davem@davemloft.net>
To: michael@ellerman.id.au
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH]: Fix assertion failure with MSI on sparc64
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Michael, I'm still working through the various regressions on
sparc64 added by your MSI changes :-)

The one I fixed the other day was a missed switch over to
alloc_pci_dev() in the sparc64 PCI probing code which caused an OOPS
in pci_enable_msi() because the list head of the pci dev was not
initialized.  PowerPC's OBP firmware tree based PCI probing code
was updated, sparc64's wasnt.

Today's find is a triggered assertion in msi_free_irqs() when the
system doesn't support MSI, in which case arch_setup_msi_irqs() always
returns an error.

The problem is that when this happens we branch into msi_free_irqs(),
to which you added the following assertion loop:

	list_for_each_entry(entry, &dev->msi_list, list)
		BUG_ON(irq_has_action(entry->irq));

Well, if arch_setup_msi_irqs() fails, entry->irq will be zero and
although that's never assigned to any normal devices we use that IRQ
number for the timer interrupt on sparc64 so this assertion triggers.

Better to test for zero before doing the irq_has_action() assertion
thing.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index e6740d1..d9cbd58 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -549,8 +549,10 @@ static int msi_free_irqs(struct pci_dev* dev)
 {
 	struct msi_desc *entry, *tmp;
 
-	list_for_each_entry(entry, &dev->msi_list, list)
-		BUG_ON(irq_has_action(entry->irq));
+	list_for_each_entry(entry, &dev->msi_list, list) {
+		if (entry->irq)
+			BUG_ON(irq_has_action(entry->irq));
+	}
 
 	arch_teardown_msi_irqs(dev);
 
