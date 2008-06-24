Return-Path: <linux-kernel-owner+w=401wt.eu-S1757159AbYFXIYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159AbYFXIYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbYFXIYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:24:04 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:43998 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572AbYFXIYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:24:00 -0400
Date: Tue, 24 Jun 2008 10:23:57 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: akinobu.mita@gmail.com, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 7/14] arch/powerpc: Eliminate NULL test and memset after
 alloc_bootmem
Message-ID: <Pine.LNX.4.64.0806241023330.26777@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

As noted by Akinobu Mita in patch b1fceac2b9e04d278316b2faddf276015fc06e3b,
alloc_bootmem and related functions never return NULL and always return a
zeroed region of memory.  Thus a NULL test or memset after calls to these
functions is unnecessary.

A double use of sizeof is also converted to a single use of sizeof in
arch/powerpc/platforms/82xx/pq2ads-pci-pic.c

 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c |    8 +-------
 arch/powerpc/platforms/iseries/lpevents.c    |    1 -
 arch/powerpc/platforms/powermac/nvram.c      |    4 ----
 arch/powerpc/sysdev/ipic.c                   |    4 ----
 arch/powerpc/sysdev/mpic.c                   |   11 ++---------
 arch/powerpc/sysdev/qe_lib/qe_ic.c           |    4 ----
 arch/powerpc/sysdev/uic.c                    |    3 ---
 7 files changed, 3 insertions(+), 32 deletions(-)

This was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E;
statement S;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
... when != E
(
- BUG_ON (E == NULL);
|
- if (E == NULL) S
)

@@
expression E,E1;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
... when != E
- memset(E,0,E1);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c b/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
--- a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
+++ b/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
@@ -148,11 +148,6 @@ int __init pq2ads_pci_init_irq(void)
 	}
 
 	priv = alloc_bootmem(sizeof(struct pq2ads_pci_pic));
-	if (!priv) {
-		of_node_put(np);
-		ret = -ENOMEM;
-		goto out_unmap_irq;
-	}
 
 	/* PCI interrupt controller registers: status and mask */
 	priv->regs = of_iomap(np, 0);
@@ -186,9 +181,8 @@ out_unmap_regs:
 	iounmap(priv->regs);
 out_free_bootmem:
 	free_bootmem((unsigned long)priv,
-	             sizeof(sizeof(struct pq2ads_pci_pic)));
+			sizeof(struct pq2ads_pci_pic));
 	of_node_put(np);
-out_unmap_irq:
 	irq_dispose_mapping(irq);
 out:
 	return ret;
diff -u -p a/arch/powerpc/platforms/iseries/lpevents.c b/arch/powerpc/platforms/iseries/lpevents.c
--- a/arch/powerpc/platforms/iseries/lpevents.c
+++ b/arch/powerpc/platforms/iseries/lpevents.c
@@ -203,7 +203,6 @@ void __init setup_hvlpevent_queue(void)
 
 	/* Allocate a page for the Event Stack. */
 	eventStack = alloc_bootmem_pages(IT_LP_EVENT_STACK_SIZE);
-	memset(eventStack, 0, IT_LP_EVENT_STACK_SIZE);
 
 	/* Invoke the hypervisor to initialize the event stack */
 	HvCallEvent_setLpEventStack(0, eventStack, IT_LP_EVENT_STACK_SIZE);
diff -u -p a/arch/powerpc/platforms/powermac/nvram.c b/arch/powerpc/platforms/powermac/nvram.c
--- a/arch/powerpc/platforms/powermac/nvram.c
+++ b/arch/powerpc/platforms/powermac/nvram.c
@@ -520,10 +520,6 @@ static int __init core99_nvram_setup(str
 		return -EINVAL;
 	}
 	nvram_image = alloc_bootmem(NVRAM_SIZE);
-	if (nvram_image == NULL) {
-		printk(KERN_ERR "nvram: can't allocate ram image\n");
-		return -ENOMEM;
-	}
 	nvram_data = ioremap(addr, NVRAM_SIZE*2);
 	nvram_naddrs = 1; /* Make sure we get the correct case */
 
diff -u -p a/arch/powerpc/sysdev/ipic.c b/arch/powerpc/sysdev/ipic.c
--- a/arch/powerpc/sysdev/ipic.c
+++ b/arch/powerpc/sysdev/ipic.c
@@ -726,10 +726,6 @@ struct ipic * __init ipic_init(struct de
 	u32 temp = 0, ret;
 
 	ipic = alloc_bootmem(sizeof(struct ipic));
-	if (ipic == NULL)
-		return NULL;
-
-	memset(ipic, 0, sizeof(struct ipic));
 
 	ipic->irqhost = irq_alloc_host(of_node_get(node), IRQ_HOST_MAP_LINEAR,
 				       NR_IPIC_INTS,
diff -u -p a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -508,8 +508,6 @@ static void __init mpic_scan_ht_pics(str
 
 	/* Allocate fixups array */
 	mpic->fixups = alloc_bootmem(128 * sizeof(struct mpic_irq_fixup));
-	BUG_ON(mpic->fixups == NULL);
-	memset(mpic->fixups, 0, 128 * sizeof(struct mpic_irq_fixup));
 
 	/* Init spinlock */
 	spin_lock_init(&mpic->fixup_lock);
@@ -1010,10 +1008,7 @@ struct mpic * __init mpic_alloc(struct d
 	u64		paddr = phys_addr;
 
 	mpic = alloc_bootmem(sizeof(struct mpic));
-	if (mpic == NULL)
-		return NULL;
 	
-	memset(mpic, 0, sizeof(struct mpic));
 	mpic->name = name;
 
 	mpic->irqhost = irq_alloc_host(of_node_get(node), IRQ_HOST_MAP_LINEAR,
@@ -1076,8 +1071,6 @@ struct mpic * __init mpic_alloc(struct d
 			bits = intvec_top + 1;
 			mapsize = BITS_TO_LONGS(bits) * sizeof(unsigned long);
 			mpic->protected = alloc_bootmem(mapsize);
-			BUG_ON(mpic->protected == NULL);
-			memset(mpic->protected, 0, mapsize);
 			for (i = 0; i < psize; i++) {
 				if (psrc[i] > intvec_top)
 					continue;
@@ -1293,8 +1286,8 @@ void __init mpic_init(struct mpic *mpic)
 
 #ifdef CONFIG_PM
 	/* allocate memory to save mpic state */
-	mpic->save_data = alloc_bootmem(mpic->num_sources * sizeof(struct mpic_irq_save));
-	BUG_ON(mpic->save_data == NULL);
+	mpic->save_data =
+		alloc_bootmem(mpic->num_sources*sizeof(struct mpic_irq_save));
 #endif
 }
 
diff -u -p a/arch/powerpc/sysdev/qe_lib/qe_ic.c b/arch/powerpc/sysdev/qe_lib/qe_ic.c
--- a/arch/powerpc/sysdev/qe_lib/qe_ic.c
+++ b/arch/powerpc/sysdev/qe_lib/qe_ic.c
@@ -330,10 +330,6 @@ void __init qe_ic_init(struct device_nod
 	u32 temp = 0, ret, high_active = 0;
 
 	qe_ic = alloc_bootmem(sizeof(struct qe_ic));
-	if (qe_ic == NULL)
-		return;
-
-	memset(qe_ic, 0, sizeof(struct qe_ic));
 
 	qe_ic->irqhost = irq_alloc_host(of_node_get(node), IRQ_HOST_MAP_LINEAR,
 					NR_QE_IC_INTS, &qe_ic_host_ops, 0);
diff -u -p a/arch/powerpc/sysdev/uic.c b/arch/powerpc/sysdev/uic.c
--- a/arch/powerpc/sysdev/uic.c
+++ b/arch/powerpc/sysdev/uic.c
@@ -259,10 +259,7 @@ static struct uic * __init uic_init_one(
 	BUG_ON(! of_device_is_compatible(node, "ibm,uic"));
 
 	uic = alloc_bootmem(sizeof(*uic));
-	if (! uic)
-		return NULL; /* FIXME: panic? */
 
-	memset(uic, 0, sizeof(*uic));
 	spin_lock_init(&uic->lock);
 	indexp = of_get_property(node, "cell-index", &len);
 	if (!indexp || (len != sizeof(u32))) {
