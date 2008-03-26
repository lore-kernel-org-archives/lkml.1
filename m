Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbYCZX1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbYCZX1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbYCZX1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:27:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:43646 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbYCZX1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:27:22 -0400
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
	regressions from 2.6.24)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Meyer <thomas@m3y3r.de>, Ingo Molnar <mingo@elte.hu>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
In-Reply-To: <1206502750.10573.12.camel@pasglop>
References: <200803220259.48534.rjw@sisk.pl>
	 <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de>
	 <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de>
	 <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org>
	 <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org>
	 <47E59B39.90306@s5r6.in-berlin.de> <20080323063524.GA13018@elte.hu>
	 <47E80247.8090702@m3y3r.de> <20080324194706.GA1391@elte.hu>
	 <47E80C64.7020907@m3y3r.de>
	 <alpine.LFD.1.00.0803241343350.2775@woody.linux-foundation.org>
	 <1206502750.10573.12.camel@pasglop>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 10:25:46 +1100
Message-Id: <1206573946.6926.51.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it, here's an updated version of my patch that applies on top
of yesterday git. I also turned "len" into a resource_size_t as it's
technically the right type to use in the generic code, even if it makes
little sense to try to map more than 32 bits on a 32 bits arch :-) Maybe
we should actually add some kind of warning here or error checking
though rather than just cropping the value.

I "fixed" all archs even those that don't technically need it (like real
64 bits one) for consistency (and who knows if they ever want to make
resource_size_t even bigger ...). The patch actually fixes at least one
bug in the case of arch/ppc which needs that change.
---

iomap: Fix 64 bits resources on 32 bits

Almost all implementations of pci_iomap() in the kernel, including
the generic lib/iomap.c one, copies the content of a struct resource
into unsigned long's which will break on 32 bits platforms with 64
bits resources.

This fixes all definitions of pci_iomap() to use resource_size_t. I
also "fixed" the 64bits arch for consistency.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Index: linux-work/lib/iomap.c
===================================================================
--- linux-work.orig/lib/iomap.c	2008-03-26 10:39:25.000000000 +1100
+++ linux-work/lib/iomap.c	2008-03-27 10:20:14.000000000 +1100
@@ -257,7 +257,7 @@ EXPORT_SYMBOL(ioport_unmap);
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
 	resource_size_t start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
Index: linux-work/arch/alpha/kernel/pci.c
===================================================================
--- linux-work.orig/arch/alpha/kernel/pci.c	2007-09-28 11:42:04.000000000 +1000
+++ linux-work/arch/alpha/kernel/pci.c	2008-03-27 10:19:59.000000000 +1100
@@ -547,8 +547,8 @@ sys_pciconfig_iobase(long which, unsigne
 
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
Index: linux-work/arch/arm/mm/iomap.c
===================================================================
--- linux-work.orig/arch/arm/mm/iomap.c	2007-07-27 13:44:41.000000000 +1000
+++ linux-work/arch/arm/mm/iomap.c	2008-03-27 10:19:59.000000000 +1100
@@ -26,8 +26,8 @@ EXPORT_SYMBOL(ioport_unmap);
 #ifdef CONFIG_PCI
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len   = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len   = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
Index: linux-work/arch/frv/mb93090-mb00/pci-iomap.c
===================================================================
--- linux-work.orig/arch/frv/mb93090-mb00/pci-iomap.c	2007-07-27 13:44:41.000000000 +1000
+++ linux-work/arch/frv/mb93090-mb00/pci-iomap.c	2008-03-27 10:19:59.000000000 +1100
@@ -13,8 +13,8 @@
 
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
Index: linux-work/arch/mips/lib/iomap-pci.c
===================================================================
--- linux-work.orig/arch/mips/lib/iomap-pci.c	2007-09-28 11:42:05.000000000 +1000
+++ linux-work/arch/mips/lib/iomap-pci.c	2008-03-27 10:19:59.000000000 +1100
@@ -45,8 +45,8 @@ static void __iomem *ioport_map_pci(stru
  */
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
Index: linux-work/arch/parisc/lib/iomap.c
===================================================================
--- linux-work.orig/arch/parisc/lib/iomap.c	2007-07-27 13:44:42.000000000 +1000
+++ linux-work/arch/parisc/lib/iomap.c	2008-03-27 10:19:59.000000000 +1100
@@ -438,8 +438,8 @@ void ioport_unmap(void __iomem *addr)
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
Index: linux-work/arch/sh/drivers/pci/pci.c
===================================================================
--- linux-work.orig/arch/sh/drivers/pci/pci.c	2008-03-19 13:52:27.000000000 +1100
+++ linux-work/arch/sh/drivers/pci/pci.c	2008-03-27 10:19:59.000000000 +1100
@@ -191,8 +191,8 @@ void __init pcibios_update_irq(struct pc
 
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (unlikely(!len || !start))
Index: linux-work/arch/mn10300/unit-asb2305/pci-iomap.c
===================================================================
--- linux-work.orig/arch/mn10300/unit-asb2305/pci-iomap.c	2008-03-19 13:52:26.000000000 +1100
+++ linux-work/arch/mn10300/unit-asb2305/pci-iomap.c	2008-03-27 10:19:59.000000000 +1100
@@ -16,8 +16,8 @@
  */
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
Index: linux-work/arch/ppc/kernel/pci.c
===================================================================
--- linux-work.orig/arch/ppc/kernel/pci.c	2007-09-28 11:42:05.000000000 +1000
+++ linux-work/arch/ppc/kernel/pci.c	2008-03-27 10:19:59.000000000 +1100
@@ -1176,8 +1176,8 @@ void __init pci_init_resource(struct res
 
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len)
Index: linux-work/arch/sparc/lib/iomap.c
===================================================================
--- linux-work.orig/arch/sparc/lib/iomap.c	2007-07-27 13:44:42.000000000 +1000
+++ linux-work/arch/sparc/lib/iomap.c	2008-03-27 10:19:59.000000000 +1100
@@ -21,8 +21,8 @@ EXPORT_SYMBOL(ioport_unmap);
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
Index: linux-work/arch/sparc64/lib/iomap.c
===================================================================
--- linux-work.orig/arch/sparc64/lib/iomap.c	2007-07-27 13:44:42.000000000 +1000
+++ linux-work/arch/sparc64/lib/iomap.c	2008-03-27 10:19:59.000000000 +1100
@@ -21,8 +21,8 @@ EXPORT_SYMBOL(ioport_unmap);
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
Index: linux-work/arch/v850/kernel/rte_mb_a_pci.c
===================================================================
--- linux-work.orig/arch/v850/kernel/rte_mb_a_pci.c	2008-03-03 11:58:41.000000000 +1100
+++ linux-work/arch/v850/kernel/rte_mb_a_pci.c	2008-03-27 10:19:59.000000000 +1100
@@ -790,8 +790,8 @@ pci_free_consistent (struct pci_dev *pde
 
 void __iomem *pci_iomap (struct pci_dev *dev, int bar, unsigned long max)
 {
-	unsigned long start = pci_resource_start (dev, bar);
-	unsigned long len = pci_resource_len (dev, bar);
+	resource_size_t start = pci_resource_start (dev, bar);
+	resource_size_t len = pci_resource_len (dev, bar);
 
 	if (!start || len == 0)
 		return 0;


