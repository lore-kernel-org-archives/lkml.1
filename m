Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab0BNFqX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 00:46:23 -0500
Received: from xenotime.net ([72.52.64.118]:48173 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750993Ab0BNFqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 00:46:21 -0500
Date: Sat, 13 Feb 2010 21:46:20 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org, Dimitri Sivanich <sivanich@sgi.com>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] x86/uv: fix sparse warnings
Message-Id: <20100213214620.d9def006.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix all sparse warnings in building uv_irq.c.

arch/x86/kernel/uv_irq.c:46:17: warning: symbol 'uv_irq_chip' was not declared. Should it be static?
arch/x86/kernel/uv_irq.c:143:50: error: no identifier for function argument
arch/x86/kernel/uv_irq.c:162:13: error: typename in expression
arch/x86/kernel/uv_irq.c:162:13: error: undefined identifier 'restrict'
arch/x86/kernel/uv_irq.c:250:44: error: no identifier for function argument
arch/x86/kernel/uv_irq.c:260:17: error: typename in expression
arch/x86/kernel/uv_irq.c:260:17: error: undefined identifier 'restrict'
arch/x86/kernel/uv_irq.c:233:50: warning: incorrect type in argument 3 (different signedness)
arch/x86/kernel/uv_irq.c:233:50:    expected int *pnode
arch/x86/kernel/uv_irq.c:233:50:    got unsigned int *<noident>
arch/x86/include/asm/uv/uv_hub.h:318:44: warning: incorrect type in argument 2 (different address spaces)
arch/x86/include/asm/uv/uv_hub.h:318:44:    expected void volatile [noderef] <asn:2>*addr
arch/x86/include/asm/uv/uv_hub.h:318:44:    got unsigned long *

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
---
 arch/x86/include/asm/uv/uv_hub.h |    2 +-
 arch/x86/kernel/uv_irq.c         |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

--- linux-2.6.33-rc8.orig/arch/x86/kernel/uv_irq.c
+++ linux-2.6.33-rc8/arch/x86/kernel/uv_irq.c
@@ -43,7 +43,7 @@ static void uv_ack_apic(unsigned int irq
 	ack_APIC_irq();
 }
 
-struct irq_chip uv_irq_chip = {
+static struct irq_chip uv_irq_chip = {
 	.name		= "UV-CORE",
 	.startup	= uv_noop_ret,
 	.shutdown	= uv_noop,
@@ -140,7 +140,7 @@ int uv_irq_2_mmr_info(int irq, unsigned 
  */
 static int
 arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
-		       unsigned long mmr_offset, int restrict)
+		       unsigned long mmr_offset, int limit)
 {
 	const struct cpumask *eligible_cpu = cpumask_of(cpu);
 	struct irq_desc *desc = irq_to_desc(irq);
@@ -159,7 +159,7 @@ arch_enable_uv_irq(char *irq_name, unsig
 	if (err != 0)
 		return err;
 
-	if (restrict == UV_AFFINITY_CPU)
+	if (limit == UV_AFFINITY_CPU)
 		desc->status |= IRQ_NO_BALANCING;
 	else
 		desc->status |= IRQ_MOVE_PCNTXT;
@@ -213,7 +213,7 @@ static int uv_set_irq_affinity(unsigned 
 	unsigned long mmr_value;
 	struct uv_IO_APIC_route_entry *entry;
 	unsigned long mmr_offset;
-	unsigned mmr_pnode;
+	int mmr_pnode;
 
 	if (set_desc_affinity(desc, mask, &dest))
 		return -1;
@@ -247,7 +247,7 @@ static int uv_set_irq_affinity(unsigned 
  * interrupt is raised.
  */
 int uv_setup_irq(char *irq_name, int cpu, int mmr_blade,
-		 unsigned long mmr_offset, int restrict)
+		 unsigned long mmr_offset, int limit)
 {
 	int irq, ret;
 
@@ -257,7 +257,7 @@ int uv_setup_irq(char *irq_name, int cpu
 		return -EBUSY;
 
 	ret = arch_enable_uv_irq(irq_name, irq, cpu, mmr_blade, mmr_offset,
-		restrict);
+		limit);
 	if (ret == irq)
 		uv_set_irq_2_mmr_info(irq, mmr_offset, mmr_blade);
 	else
--- linux-2.6.33-rc8.orig/arch/x86/include/asm/uv/uv_hub.h
+++ linux-2.6.33-rc8/arch/x86/include/asm/uv/uv_hub.h
@@ -307,7 +307,7 @@ static inline unsigned long uv_read_glob
  * Access Global MMR space using the MMR space located at the top of physical
  * memory.
  */
-static inline unsigned long *uv_global_mmr64_address(int pnode, unsigned long offset)
+static inline volatile void __iomem *uv_global_mmr64_address(int pnode, unsigned long offset)
 {
 	return __va(UV_GLOBAL_MMR64_BASE |
 		    UV_GLOBAL_MMR64_PNODE_BITS(pnode) | offset);
