Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbYKOFbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbYKOFbR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 00:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbYKOFZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 00:25:25 -0500
Received: from kroah.org ([198.145.64.141]:50672 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753936AbYKOFZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 00:25:11 -0500
Date: Fri, 14 Nov 2008 21:23:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Kumar Gala <galak@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [patch 18/22] powerpc/mpic: Fix regression caused by change of
	default IRQ affinity
Message-ID: <20081115052345.GS3710@kroah.com>
References: <20081115051732.506914008@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-mpic-fix-regression-caused-by-change-of-default-irq-affinity.patch"
In-Reply-To: <20081115052220.GA3710@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kumar Gala <galak@kernel.crashing.org>

commit 3c10c9c45e290022ca7d2aa1ad33a0b6ed767520 upstream.

The Freescale implementation of MPIC only allows a single CPU destination
for non-IPI interrupts.  We add a flag to the mpic_init to distinquish
these variants of MPIC.  We pull in the irq_choose_cpu from sparc64 to
select a single CPU as the destination of the interrupt.

This is to deal with the fact that the default smp affinity was
changed by commit 18404756765c713a0be4eb1082920c04822ce588 ("genirq
Expose default irq affinity mask (take 3)") to be all CPUs.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/include/asm/mpic.h          |    2 +
 arch/powerpc/platforms/85xx/mpc85xx_ds.c |    3 +
 arch/powerpc/platforms/86xx/pic.c        |    3 +
 arch/powerpc/sysdev/mpic.c               |   59 ++++++++++++++++++++++++++++---
 4 files changed, 61 insertions(+), 6 deletions(-)

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
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -563,6 +563,51 @@ static void __init mpic_scan_ht_pics(str
 
 #endif /* CONFIG_MPIC_U3_HT_IRQS */
 
+#ifdef CONFIG_SMP
+static int irq_choose_cpu(unsigned int virt_irq)
+{
+	cpumask_t mask = irq_desc[virt_irq].affinity;
+	int cpuid;
+
+	if (cpus_equal(mask, CPU_MASK_ALL)) {
+		static int irq_rover;
+		static DEFINE_SPINLOCK(irq_rover_lock);
+		unsigned long flags;
+
+		/* Round-robin distribution... */
+	do_round_robin
+		spin_lock_irqsave(&irq_rover_lock, flags);
+
+		while (!cpu_online(irq_rover)) {
+			if (++irq_rover >= NR_CPUS)
+				irq_rover = 0;
+		}
+		cpuid = irq_rover;
+		do {
+			if (++irq_rover >= NR_CPUS)
+				irq_rover = 0;
+		} while (!cpu_online(irq_rover));
+
+		spin_unlock_irqrestore(&irq_rover_lock, flags);
+	} else {
+		cpumask_t tmp;
+
+		cpus_and(tmp, cpu_online_map, mask);
+
+		if (cpus_empty(tmp))
+			goto do_round_robin;
+
+		cpuid = first_cpu(tmp);
+	}
+
+	return cpuid;
+}
+#else
+static int irq_choose_cpu(unsigned int virt_irq)
+{
+	return hard_smp_processor_id();
+}
+#endif
 
 #define mpic_irq_to_hw(virq)	((unsigned int)irq_map[virq].hwirq)
 
@@ -777,12 +822,18 @@ void mpic_set_affinity(unsigned int irq,
 	struct mpic *mpic = mpic_from_irq(irq);
 	unsigned int src = mpic_irq_to_hw(irq);
 
-	cpumask_t tmp;
+	if (mpic->flags & MPIC_SINGLE_DEST_CPU) {
+		int cpuid = irq_choose_cpu(irq);
+
+		mpic_irq_write(src, MPIC_INFO(IRQ_DESTINATION), 1 << cpuid);
+	} else {
+		cpumask_t tmp;
 
-	cpus_and(tmp, cpumask, cpu_online_map);
+		cpus_and(tmp, cpumask, cpu_online_map);
 
-	mpic_irq_write(src, MPIC_INFO(IRQ_DESTINATION),
-		       mpic_physmask(cpus_addr(tmp)[0]));	
+		mpic_irq_write(src, MPIC_INFO(IRQ_DESTINATION),
+			       mpic_physmask(cpus_addr(tmp)[0]));
+	}
 }
 
 static unsigned int mpic_type_to_vecpri(struct mpic *mpic, unsigned int type)

-- 
