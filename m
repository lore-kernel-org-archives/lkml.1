Return-Path: <linux-kernel-owner+w=401wt.eu-S1030259AbXDKUk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030259AbXDKUk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 16:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030735AbXDKUk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 16:40:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:50094 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030259AbXDKUk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 16:40:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=i5GVqBnoebafnq/j43Vi7xaMSSGjjXlOXmvr5ckOEiSa7hf2MKVtPsWjI1EII4keq3J3XJ1XTbegFIaaqHRkRle240BZK3If7JjOCxE4mwdBu13AHhlmhIK+A23HMuPzhgYzUqH0/eNws+/dWfuaOYPxbLfAQXcmtkVNnYQ6Ha0=
Date: Thu, 12 Apr 2007 02:12:17 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: [KJ][RFC][PATCH]SPIN_LOCK_UNLOCKED cleanup in arch/arm
Message-ID: <20070411204217.GB10121@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

for arch/arm/kernel/smp.c

 static DEFINE_PER_CPU(struct ipi_data, ipi_data) = {

will give a struct with name  per_cpu__ipi_data 
 
so I did
-       .lock   = SPIN_LOCK_UNLOCKED,
+       .lock   = __SPIN_LOCK_UNLOCKED(per_cpu__ipi_data.lock),

but this dosen't seem to be the right thing to do..
the DEFINE_PER_CPU macro internally creates an instance of 
the type passed with name as "per_cpu__##name"

the prefix should not be assumed i think
.if the DEFINE_PER_CPU changes ,this code will break..

how do we go about it?
thoughts!

plz CMIIW
---

 kernel/irq.c       |    2 +-
 kernel/smp.c       |    2 +-
 kernel/time.c      |    2 +-
 mach-omap2/gpmc.c  |    2 +-
 mach-pnx4008/dma.c |    4 ++--
 5 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index e101846..0cbd51c 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -101,7 +101,7 @@ unlock:
 /* Handle bad interrupts */
 static struct irq_desc bad_irq_desc = {
 	.handle_irq = handle_bad_irq,
-	.lock = SPIN_LOCK_UNLOCKED
+	.lock = __SPIN_LOCK_UNLOCKED(bad_irq_desc.lock)
 };
 
 /*
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 070bcb7..cf8341d 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -60,7 +60,7 @@ struct ipi_data {
 };
 
 static DEFINE_PER_CPU(struct ipi_data, ipi_data) = {
-	.lock	= SPIN_LOCK_UNLOCKED,
+	.lock	= __SPIN_LOCK_UNLOCKED(per_cpu__ipi_data.lock),
 };
 
 enum ipi_msg_type {
diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index d8f5782..d2b08b4 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -54,7 +54,7 @@
 
 static struct resource	gpmc_mem_root;
 static struct resource	gpmc_cs_mem[GPMC_CS_NUM];
-static spinlock_t	gpmc_mem_lock = SPIN_LOCK_UNLOCKED;
+static 	DEFINE_SPINLOCK(gpmc_mem_lock);
 static unsigned		gpmc_cs_map;
 
 static void __iomem *gpmc_base =
diff --git a/arch/arm/mach-pnx4008/dma.c b/arch/arm/mach-pnx4008/dma.c
index d6a279e..f7009d8 100644
--- a/arch/arm/mach-pnx4008/dma.c
+++ b/arch/arm/mach-pnx4008/dma.c
@@ -47,7 +47,7 @@ static struct ll_pool {
 	int count;
 } ll_pool;
 
-static spinlock_t ll_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(ll_lock);
 
 struct pnx4008_dma_ll *pnx4008_alloc_ll_entry(dma_addr_t * ll_dma)
 {
@@ -135,7 +135,7 @@ static inline void dma_decrement_usage(void)
 	}
 }
 
-static spinlock_t dma_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(dma_lock);
 
 static inline void pnx4008_dma_lock(void)
 {
diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index f61decb..77e7f20 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -510,7 +510,7 @@ void __init time_init(void)
 
 #ifdef CONFIG_NO_IDLE_HZ
 	if (system_timer->dyn_tick)
-		system_timer->dyn_tick->lock = SPIN_LOCK_UNLOCKED;
+		spin_lock_init(&system_timer->dyn_tick->lock);
 #endif
 }
 
-- 
Milind Arun Choudhary
