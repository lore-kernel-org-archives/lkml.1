Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbYDRX0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbYDRX0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 19:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbYDRXXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 19:23:18 -0400
Received: from havoc.gtf.org ([69.61.125.42]:58503 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802AbYDRXXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 19:23:03 -0400
Message-Id: <7e9615f84364be0015a808a30fc0b39a20d650de.1208559659.git.jgarzik@redhat.com>
In-Reply-To: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
To: tony.luck@intel.com, linux-ia64@vger.kernel.org
From: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/15] [IA64] minor irq handler cleanups
Date: Fri, 18 Apr 2008 19:22:58 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove unused 'irq' argument from pfm_do_interrupt_handler()

- remove pointless cast to void*

- add KERN_xxx prefix to printk()

- remove braces around singleton C statement

- in tioce_provider.c, start tioce_dma_consistent() and
  tioce_error_intr_handler() function declarations in column 0

This change's main purpose is to prepare for the patchset in
jgarzik/misc-2.6.git#irq-remove, that explores removal of the
never-used 'irq' argument in each interrupt handler.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 arch/ia64/kernel/perfmon.c        |    4 ++--
 arch/ia64/sn/kernel/huberror.c    |    4 ++--
 arch/ia64/sn/pci/tioce_provider.c |    6 ++++--
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index d1d24f4..c8e4037 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -5511,7 +5511,7 @@ stop_monitoring:
 }
 
 static int
-pfm_do_interrupt_handler(int irq, void *arg, struct pt_regs *regs)
+pfm_do_interrupt_handler(void *arg, struct pt_regs *regs)
 {
 	struct task_struct *task;
 	pfm_context_t *ctx;
@@ -5591,7 +5591,7 @@ pfm_interrupt_handler(int irq, void *arg)
 
 		start_cycles = ia64_get_itc();
 
-		ret = pfm_do_interrupt_handler(irq, arg, regs);
+		ret = pfm_do_interrupt_handler(arg, regs);
 
 		total_cycles = ia64_get_itc();
 
diff --git a/arch/ia64/sn/kernel/huberror.c b/arch/ia64/sn/kernel/huberror.c
index 0101c79..08b0d9b 100644
--- a/arch/ia64/sn/kernel/huberror.c
+++ b/arch/ia64/sn/kernel/huberror.c
@@ -187,8 +187,8 @@ void hub_error_init(struct hubdev_info *hubdev_info)
 {
 
 	if (request_irq(SGI_II_ERROR, hub_eint_handler, IRQF_SHARED,
-			"SN_hub_error", (void *)hubdev_info)) {
-		printk("hub_error_init: Failed to request_irq for 0x%p\n",
+			"SN_hub_error", hubdev_info)) {
+		printk(KERN_ERR "hub_error_init: Failed to request_irq for 0x%p\n",
 		    hubdev_info);
 		return;
 	}
diff --git a/arch/ia64/sn/pci/tioce_provider.c b/arch/ia64/sn/pci/tioce_provider.c
index 9b3c113..94e5845 100644
--- a/arch/ia64/sn/pci/tioce_provider.c
+++ b/arch/ia64/sn/pci/tioce_provider.c
@@ -655,7 +655,8 @@ tioce_dma(struct pci_dev *pdev, u64 paddr, size_t byte_count, int dma_flags)
  *
  * Simply call tioce_do_dma_map() to create a map with the barrier bit set
  * in the address.
- */ static u64
+ */
+static u64
 tioce_dma_consistent(struct pci_dev *pdev, u64 paddr, size_t byte_count, int dma_flags)
 {
 	return tioce_do_dma_map(pdev, paddr, byte_count, 1, dma_flags);
@@ -668,7 +669,8 @@ tioce_dma_consistent(struct pci_dev *pdev, u64 paddr, size_t byte_count, int dma
  *
  * Handle a CE error interrupt.  Simply a wrapper around a SAL call which
  * defers processing to the SGI prom.
- */ static irqreturn_t
+ */
+static irqreturn_t
 tioce_error_intr_handler(int irq, void *arg)
 {
 	struct tioce_common *soft = arg;
-- 
1.5.4.1

