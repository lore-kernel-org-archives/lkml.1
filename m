Return-Path: <linux-kernel-owner+w=401wt.eu-S1752129AbYJ0SeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbYJ0SeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 14:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbYJ0Sds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 14:33:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:53167 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbYJ0Sdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 14:33:47 -0400
Date: Mon, 27 Oct 2008 13:31:49 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
       tglx@linutronix.de, csnook@redhat.com
Subject: [PATCH][for 2.6.28] powerpc/mpic: Add support for MPICs that only
 support a single CPU destination
Message-ID: <Pine.LNX.4.64.0810271327170.4693@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 20a2290553a1921a13449f9b7c597bcc76ec2c03 Mon Sep 17 00:00:00 2001
From: Kumar Gala <galak@kernel.crashing.org>
Date: Mon, 27 Oct 2008 09:08:11 -0500
Subject: [PATCH] powerpc/mpic: Add support for MPICs that only support a single CPU destination

The Freescale implementation of MPIC only allows a single CPU destination
for non-IPI interrupts.  We add a flag to the mpic_init to distinquish
these variants of MPIC.  Additionally, we will flag a warning if the
user tries to set the affinity on such an interrupts to more than one
CPU.

This is to deal with the fact that the default smp affinity was
changed by commit 18404756765c713a0be4eb1082920c04822ce588.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---

Ben, please review and see if this is an acceptable solution to the fact
that FSL mpic's can't deal with more than one CPU destination bit being
set.  If so please queue up and forward onto linus for 2.6.28.

- k

 arch/powerpc/include/asm/mpic.h          |    2 ++
 arch/powerpc/platforms/85xx/mpc85xx_ds.c |    3 ++-
 arch/powerpc/platforms/86xx/pic.c        |    3 ++-
 arch/powerpc/sysdev/mpic.c               |   15 +++++++++++++++
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/mpic.h b/arch/powerpc/include/asm/mpic.h
index 34d9ac4..c2ccca5 100644
--- a/arch/powerpc/include/asm/mpic.h
+++ b/arch/powerpc/include/asm/mpic.h
@@ -355,6 +355,8 @@ struct mpic
 #define MPIC_NO_BIAS			0x00000400
 /* Ignore NIRQS as reported by FRR */
 #define MPIC_BROKEN_FRR_NIRQS		0x00000800
+/* Destination only supports a single CPU at a time */
+#define MPIC_SINGLE_DEST_CPU		0x00001000

 /* MPIC HW modification ID */
 #define MPIC_REGSET_MASK		0xf0000000
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ds.c b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
index 483b65c..613bf8c 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
@@ -78,7 +78,8 @@ void __init mpc85xx_ds_pic_init(void)

 	mpic = mpic_alloc(np, r.start,
 			  MPIC_PRIMARY | MPIC_WANTS_RESET |
-			  MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS,
+			  MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
+			  MPIC_SINGLE_DEST_CPU,
 			0, 256, " OpenPIC  ");
 	BUG_ON(mpic == NULL);
 	of_node_put(np);
diff --git a/arch/powerpc/platforms/86xx/pic.c b/arch/powerpc/platforms/86xx/pic.c
index 8881c5d..668275d 100644
--- a/arch/powerpc/platforms/86xx/pic.c
+++ b/arch/powerpc/platforms/86xx/pic.c
@@ -44,7 +44,8 @@ void __init mpc86xx_init_irq(void)

 	mpic = mpic_alloc(np, res.start,
 			MPIC_PRIMARY | MPIC_WANTS_RESET |
-			MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS,
+			MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
+			MPIC_SINGLE_DEST_CPU,
 			0, 256, " MPIC     ");
 	of_node_put(np);
 	BUG_ON(mpic == NULL);
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 8e3478c..b91a736 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -781,6 +781,16 @@ void mpic_set_affinity(unsigned int irq, cpumask_t cpumask)

 	cpus_and(tmp, cpumask, cpu_online_map);

+	if ((mpic->flags & MPIC_SINGLE_DEST_CPU) && (cpus_weight(tmp) != 1)) {
+		int first_cpu = first_cpu(tmp);
+
+		printk(KERN_WARNING "mpic: attempting to set cpu affinity to "
+			"more than one cpu, setting to CPU %d\n", first_cpu);
+		cpus_clear(tmp);
+		cpu_set(first_cpu, tmp);
+		irq_desc[irq].affinity = tmp;
+	}
+
 	mpic_irq_write(src, MPIC_INFO(IRQ_DESTINATION),
 		       mpic_physmask(cpus_addr(tmp)[0]));
 }
@@ -920,6 +930,8 @@ static int mpic_host_map(struct irq_host *h, unsigned int virq,
 					 handle_percpu_irq);
 		return 0;
 	}
+	if (mpic->flags & MPIC_SINGLE_DEST_CPU)
+		irq_set_affinity(virq, irq_default_affinity);
 #endif /* CONFIG_SMP */

 	if (hw >= mpic->irq_count)
@@ -1037,6 +1049,9 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 #ifdef CONFIG_SMP
 	mpic->hc_ipi = mpic_ipi_chip;
 	mpic->hc_ipi.typename = name;
+
+	if (flags & MPIC_SINGLE_DEST_CPU)
+		irq_default_affinity = CPU_MASK_CPU0;
 #endif /* CONFIG_SMP */

 	mpic->flags = flags;
-- 
1.5.5.1

