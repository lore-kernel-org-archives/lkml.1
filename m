Return-Path: <linux-kernel-owner+w=401wt.eu-S1752922AbZGDFIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbZGDFIV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 01:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbZGDFIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 01:08:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:39426 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbZGDFIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 01:08:04 -0400
Message-ID: <4A4EE410.4080001@kernel.org>
Date: Sat, 04 Jul 2009 14:09:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Robert Hancock <hancockr@shaw.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-pci@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Ritz <daniel.ritz@gmx.ch>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Axel Birndt <towerlexa@gmx.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/3] pci,sparc64: drop PCI_CACHE_LINE_BYTES
References: <4A4EE3E9.7090205@kernel.org>
In-Reply-To: <4A4EE3E9.7090205@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 04 Jul 2009 05:07:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparc64 is now the only user of PCI_CACHE_LINE_BYTES.  Drop it and set
pci_dfl_cache_line_size from pcibios_init() instead and drop
PCI_CACHE_LINE_BYTES handling from generic pci code.

Orignally-From: David Miller <davem@davemloft.net>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/sparc/include/asm/pci_64.h |    2 --
 arch/sparc/kernel/pci.c         |    7 +++++++
 drivers/pci/pci.c               |    6 +-----
 3 files changed, 8 insertions(+), 7 deletions(-)

Index: work/arch/sparc/kernel/pci.c
===================================================================
--- work.orig/arch/sparc/kernel/pci.c
+++ work/arch/sparc/kernel/pci.c
@@ -1081,3 +1081,10 @@ void pci_resource_to_user(const struct p
 	*start = rp->start - offset;
 	*end = rp->end - offset;
 }
+
+static int __init pcibios_init(void)
+{
+	pci_dfl_cache_line_size = 64 >> 2;
+	return 0;
+}
+subsys_initcall(pcibios_init);
Index: work/arch/sparc/include/asm/pci_64.h
===================================================================
--- work.orig/arch/sparc/include/asm/pci_64.h
+++ work/arch/sparc/include/asm/pci_64.h
@@ -17,8 +17,6 @@
 
 #define PCI_IRQ_NONE		0xffffffff
 
-#define PCI_CACHE_LINE_BYTES	64
-
 static inline void pcibios_set_master(struct pci_dev *dev)
 {
 	/* No special bus mastering setup handling */
Index: work/drivers/pci/pci.c
===================================================================
--- work.orig/drivers/pci/pci.c
+++ work/drivers/pci/pci.c
@@ -41,17 +41,13 @@ int pci_domains_supported = 1;
 unsigned long pci_cardbus_io_size = DEFAULT_CARDBUS_IO_SIZE;
 unsigned long pci_cardbus_mem_size = DEFAULT_CARDBUS_MEM_SIZE;
 
-#ifndef PCI_CACHE_LINE_BYTES
-#define PCI_CACHE_LINE_BYTES L1_CACHE_BYTES
-#endif
-
 /*
  * The default CLS is used if arch didn't set CLS explicitly and not
  * all pci devices agree on the same value.  Arch can override either
  * the dfl or actual value as it sees fit.  Don't forget this is
  * measured in 32-bit words, not bytes.
  */
-u8 pci_dfl_cache_line_size __initdata = PCI_CACHE_LINE_BYTES >> 2;
+u8 pci_dfl_cache_line_size __initdata = L1_CACHE_BYTES >> 2;
 u8 pci_cache_line_size;
 
 /**
