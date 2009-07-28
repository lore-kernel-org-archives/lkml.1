Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbZG1XyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbZG1XyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932192AbZG1Xx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:53:59 -0400
Received: from kroah.org ([198.145.64.141]:35927 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859AbZG1XuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:24 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:42:00 2009
Message-Id: <20090728234200.126587932@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Akira Tsukamoto <akirat@rd.scei.sony.co.jp>
Subject: [patch 56/71] powerpc/mpic: Fix mapping of "DCR" based MPIC variants
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=powerpc-mpic-fix-mapping-of-dcr-based-mpic-variants.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 5a2642f620eb6e40792822fa0eafe23046fbb55e upstream.

Commit 31207dab7d2e63795eb15823947bd2f7025b08e2
"Fix incorrect allocation of interrupt rev-map"
introduced a regression crashing on boot on machines using
a "DCR" based MPIC, such as the Cell blades.

The reason is that the irq host data structure is initialized
much later as a result of that patch, causing our calls to
mpic_map() do be done before we have a host setup.

Unfortunately, this breaks _mpic_map_dcr() which uses the
mpic->irqhost to get to the device node.

This fixes it by, instead, passing the device node explicitely
to mpic_map().

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Akira Tsukamoto <akirat@rd.scei.sony.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/sysdev/mpic.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -279,28 +279,29 @@ static void _mpic_map_mmio(struct mpic *
 }
 
 #ifdef CONFIG_PPC_DCR
-static void _mpic_map_dcr(struct mpic *mpic, struct mpic_reg_bank *rb,
+static void _mpic_map_dcr(struct mpic *mpic, struct device_node *node,
+			  struct mpic_reg_bank *rb,
 			  unsigned int offset, unsigned int size)
 {
 	const u32 *dbasep;
 
-	dbasep = of_get_property(mpic->irqhost->of_node, "dcr-reg", NULL);
+	dbasep = of_get_property(node, "dcr-reg", NULL);
 
-	rb->dhost = dcr_map(mpic->irqhost->of_node, *dbasep + offset, size);
+	rb->dhost = dcr_map(node, *dbasep + offset, size);
 	BUG_ON(!DCR_MAP_OK(rb->dhost));
 }
 
-static inline void mpic_map(struct mpic *mpic, phys_addr_t phys_addr,
-			    struct mpic_reg_bank *rb, unsigned int offset,
-			    unsigned int size)
+static inline void mpic_map(struct mpic *mpic, struct device_node *node,
+			    phys_addr_t phys_addr, struct mpic_reg_bank *rb,
+			    unsigned int offset, unsigned int size)
 {
 	if (mpic->flags & MPIC_USES_DCR)
-		_mpic_map_dcr(mpic, rb, offset, size);
+		_mpic_map_dcr(mpic, node, rb, offset, size);
 	else
 		_mpic_map_mmio(mpic, phys_addr, rb, offset, size);
 }
 #else /* CONFIG_PPC_DCR */
-#define mpic_map(m,p,b,o,s)	_mpic_map_mmio(m,p,b,o,s)
+#define mpic_map(m,n,p,b,o,s)	_mpic_map_mmio(m,p,b,o,s)
 #endif /* !CONFIG_PPC_DCR */
 
 
@@ -1150,8 +1151,8 @@ struct mpic * __init mpic_alloc(struct d
 	}
 
 	/* Map the global registers */
-	mpic_map(mpic, paddr, &mpic->gregs, MPIC_INFO(GREG_BASE), 0x1000);
-	mpic_map(mpic, paddr, &mpic->tmregs, MPIC_INFO(TIMER_BASE), 0x1000);
+	mpic_map(mpic, node, paddr, &mpic->gregs, MPIC_INFO(GREG_BASE), 0x1000);
+	mpic_map(mpic, node, paddr, &mpic->tmregs, MPIC_INFO(TIMER_BASE), 0x1000);
 
 	/* Reset */
 	if (flags & MPIC_WANTS_RESET) {
@@ -1192,7 +1193,7 @@ struct mpic * __init mpic_alloc(struct d
 
 	/* Map the per-CPU registers */
 	for (i = 0; i < mpic->num_cpus; i++) {
-		mpic_map(mpic, paddr, &mpic->cpuregs[i],
+		mpic_map(mpic, node, paddr, &mpic->cpuregs[i],
 			 MPIC_INFO(CPU_BASE) + i * MPIC_INFO(CPU_STRIDE),
 			 0x1000);
 	}
@@ -1200,7 +1201,7 @@ struct mpic * __init mpic_alloc(struct d
 	/* Initialize main ISU if none provided */
 	if (mpic->isu_size == 0) {
 		mpic->isu_size = mpic->num_sources;
-		mpic_map(mpic, paddr, &mpic->isus[0],
+		mpic_map(mpic, node, paddr, &mpic->isus[0],
 			 MPIC_INFO(IRQ_BASE), MPIC_INFO(IRQ_STRIDE) * mpic->isu_size);
 	}
 	mpic->isu_shift = 1 + __ilog2(mpic->isu_size - 1);
@@ -1254,8 +1255,10 @@ void __init mpic_assign_isu(struct mpic 
 
 	BUG_ON(isu_num >= MPIC_MAX_ISU);
 
-	mpic_map(mpic, paddr, &mpic->isus[isu_num], 0,
+	mpic_map(mpic, mpic->irqhost->of_node,
+		 paddr, &mpic->isus[isu_num], 0,
 		 MPIC_INFO(IRQ_STRIDE) * mpic->isu_size);
+
 	if ((isu_first + mpic->isu_size) > mpic->num_sources)
 		mpic->num_sources = isu_first + mpic->isu_size;
 }


