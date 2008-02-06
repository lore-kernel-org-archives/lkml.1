Return-Path: <linux-kernel-owner+w=401wt.eu-S1765669AbYBGAJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765669AbYBGAJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764244AbYBFX51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:57:27 -0500
Received: from mx1.suse.de ([195.135.220.2]:45969 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762388AbYBFX50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:57:26 -0500
Date: Wed, 6 Feb 2008 15:52:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 32/73] SPARC64: Implement pci_resource_to_user()
Message-ID: <20080206235250.GG13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sparc64-implement-pci_resource_to_user.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: David Miller <davem@davemloft.net>

[SPARC64]: Implement pci_resource_to_user()

[ Upstream commit: bcea1db16ba1c45ccebb3bfb8441642d1342c4d5 ]

This makes libpciaccess able to mmap() resources of the
device properly.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/pci.c |   16 ++++++++++++++++
 include/asm-sparc64/pci.h |    4 ++++
 2 files changed, 20 insertions(+)

--- a/arch/sparc64/kernel/pci.c
+++ b/arch/sparc64/kernel/pci.c
@@ -1276,4 +1276,20 @@ int pci_dma_supported(struct pci_dev *pd
 	return (device_mask & dma_addr_mask) == dma_addr_mask;
 }
 
+void pci_resource_to_user(const struct pci_dev *pdev, int bar,
+			  const struct resource *rp, resource_size_t *start,
+			  resource_size_t *end)
+{
+	struct pci_pbm_info *pbm = pdev->dev.archdata.host_controller;
+	unsigned long offset;
+
+	if (rp->flags & IORESOURCE_IO)
+		offset = pbm->io_space.start;
+	else
+		offset = pbm->mem_space.start;
+
+	*start = rp->start - offset;
+	*end = rp->end - offset;
+}
+
 #endif /* !(CONFIG_PCI) */
--- a/include/asm-sparc64/pci.h
+++ b/include/asm-sparc64/pci.h
@@ -200,6 +200,10 @@ static inline int pci_get_legacy_ide_irq
 struct device_node;
 extern struct device_node *pci_device_to_OF_node(struct pci_dev *pdev);
 
+#define HAVE_ARCH_PCI_RESOURCE_TO_USER
+extern void pci_resource_to_user(const struct pci_dev *dev, int bar,
+				 const struct resource *rsrc,
+				 resource_size_t *start, resource_size_t *end);
 #endif /* __KERNEL__ */
 
 #endif /* __SPARC64_PCI_H */

-- 
