Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbYI1XgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbYI1XgG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 19:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYI1Xf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 19:35:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:47021 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbYI1Xf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 19:35:57 -0400
Date: Sun, 28 Sep 2008 16:36:11 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 01/19] pci: introduce an pci_ioremap(pdev, barnr) function
Message-ID: <20080928163611.3df8a9e0@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below introduces a pci_ioremap() function that should make it easier for
driver authors to do the right thing for the simple, common case.

There's also 18 patches that introduce users of this; to reduce lkml noise I've only
stuck them in a git tree at
git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-pci_ioremap.git
(http://git.kernel.org/?p=linux/kernel/git/arjan/linux-2.6-pci_ioremap.git;a=summary)


>From fef1dd836bc7dc07962a0ae4019af9efd373c76f Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 26 Sep 2008 16:34:52 -0700
Subject: [PATCH 01/19] pci: introduce an pci_ioremap(pdev, barnr) function

A common thing in many PCI drivers is to ioremap() an entire bar.
This is a slightly fragile thing right now, needing both an address and a size,
and many driver writers do.. various things there.

This patch introduces an pci_ioremap() function taking just a PCI device struct
and the bar number as arguments, and figures this all out itself, in one place.
In addition, we can add various sanity checks to this function (the patch already
checks to make sure that the bar in question really is a MEM bar; few to no drivers
do that sort of thing).

Hopefully with this type of API we get less chance of mistakes in drivers with
ioremap() operations.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/pci.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 709b8d4..3f8ce81 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1127,5 +1127,18 @@ static inline void pci_mmcfg_early_init(void) { }
 static inline void pci_mmcfg_late_init(void) { }
 #endif
 
+static inline void * pci_ioremap_bar(struct pci_dev *pdev, int bar)
+{
+	/*
+	 * Make sure the BAR is actually a memory resource, not an IO resource
+	 */
+	if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM)) {
+		WARN_ON(1);
+		return NULL;
+	}
+	return ioremap_nocache(pci_resource_start(pdev, bar),
+				     pci_resource_len(pdev, bar));
+}
+
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
