Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab0BJBkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:40:52 -0500
Received: from sh.osrg.net ([192.16.179.4]:54848 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034Ab0BJBkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:40:49 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp, x86@kernel.org,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matt Turner <mattst88@gmail.com>, Russell King <linux@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
       Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       Helge Deller <deller@gmx.de>, James Bottomley <James.Bottomley@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Zankel <chris@zankel.net>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 -mm 01/14] adds include/linux/pci-dma.h
Date: Wed, 10 Feb 2010 10:34:34 +0900
Message-Id: <1265765687-14121-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 10 Feb 2010 10:38:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds include/linux/pci-dma.h that defines the pci_unmap
state API:

DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
DECLARE_PCI_UNMAP_LEN(LEN_NAME)
pci_unmap_addr(PTR, ADDR_NAME)
pci_unmap_addr_set(PTR, ADDR_NAME, VAL)
pci_unmap_len(PTR, LEN_NAME)
pci_unmap_len_set(PTR, LEN_NAME, VAL)

This enables us to remove lots of the duplication in architecture
implementations since there are only two ways to define the API.

If architectures define CONFIG_NEED_DMA_MAP_STATE, they get the real
definition of pci_unmap state API. If not, they get the noop
definition.

In the long term, it's better to replace the API with the generic
device model API such as DECLARE_DMA_UNMAP_ADDR. We can map the API to
the generic one (like dma-mapping-compat.h does). This patch also
makes the migration process easier. We can remove this file after the
migration.

It might be simpler to add the API to include/linux/pci.h but looks
it's already too large. We'll remove pci-dma.h after finishing moving
to the generic device model. So I put the API to a separate file.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: x86@kernel.org
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: James Bottomley <James.Bottomley@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Chris Zankel <chris@zankel.net>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/pci-dma.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/pci-dma.h

diff --git a/include/linux/pci-dma.h b/include/linux/pci-dma.h
new file mode 100644
index 0000000..cfd63ab
--- /dev/null
+++ b/include/linux/pci-dma.h
@@ -0,0 +1,20 @@
+#ifndef _LINUX_PCI_DMA_H
+#define _LINUX_PCI_DMA_H
+
+#ifdef CONFIG_NEED_DMA_MAP_STATE
+#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)        dma_addr_t ADDR_NAME;
+#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)          __u32 LEN_NAME;
+#define pci_unmap_addr(PTR, ADDR_NAME)           ((PTR)->ADDR_NAME)
+#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)  (((PTR)->ADDR_NAME) = (VAL))
+#define pci_unmap_len(PTR, LEN_NAME)             ((PTR)->LEN_NAME)
+#define pci_unmap_len_set(PTR, LEN_NAME, VAL)    (((PTR)->LEN_NAME) = (VAL))
+#else
+#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
+#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
+#define pci_unmap_addr(PTR, ADDR_NAME)           (0)
+#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)  do { } while (0)
+#define pci_unmap_len(PTR, LEN_NAME)             (0)
+#define pci_unmap_len_set(PTR, LEN_NAME, VAL)    do { } while (0)
+#endif
+
+#endif
-- 
1.5.6.5

