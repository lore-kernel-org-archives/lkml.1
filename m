Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbXEXVJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbXEXVJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbXEXVJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:09:40 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58178 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbXEXVJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:09:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tom.l.nguyen@intel.com, iss_storagedev@hp.com, jens.axboe@oracle.com,
       Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH] msi: Fix the ordering of msix irqs.
References: <20070524160756.GA14083@beardog.cca.cpqcorp.net>
	<20070524102702.bca37396.akpm@linux-foundation.org>
	<m1r6p6dn3x.fsf@ebiederm.dsl.xmission.com>
	<20070524205900.GC14083@beardog.cca.cpqcorp.net>
Date: Thu, 24 May 2007 15:08:21 -0600
In-Reply-To: <20070524205900.GC14083@beardog.cca.cpqcorp.net> (Mike Miller's
	message of "Thu, 24 May 2007 15:59:00 -0500")
Message-ID: <m1hcq2dj5m.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yours looks more complete then my test patch so:

From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> writes:

Found what seems the problem with our vectors being listed backward. In
drivers/pci/msi.c we should be using list_add_tail rather than list_add to
preserve the ordering across various kernels. Please consider this for
inclusion.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 0e67723..d74975d 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -333,7 +333,7 @@ static int msi_capability_init(struct pci_dev *dev)
 			msi_mask_bits_reg(pos, is_64bit_address(control)),
 			maskbits);
 	}
-	list_add(&entry->list, &dev->msi_list);
+	list_add_tail(&entry->list, &dev->msi_list);
 
 	/* Configure MSI capability structure */
 	ret = arch_setup_msi_irqs(dev, 1, PCI_CAP_ID_MSI);
@@ -404,7 +404,7 @@ static int msix_capability_init(struct pci_dev *dev,
 		entry->dev = dev;
 		entry->mask_base = base;
 
-		list_add(&entry->list, &dev->msi_list);
+		list_add_tail(&entry->list, &dev->msi_list);
 	}
 
 	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
