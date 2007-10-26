Return-Path: <linux-kernel-owner+w=401wt.eu-S1763663AbXJZQrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763663AbXJZQrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbXJZQre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:47:34 -0400
Received: from lixom.net ([66.141.50.11]:40108 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940AbXJZQre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:47:34 -0400
Date: Fri, 26 Oct 2007 11:55:10 -0500
From: Olof Johansson <olof@lixom.net>
To: paulus@samba.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: [PATCH] [POWERPC] Fix CONFIG_SMP=n build breaks
Message-ID: <20071026165510.GA2323@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix two build errors on powerpc allyesconfig + CONFIG_SMP=n:

arch/powerpc/platforms/built-in.o: In function `cpu_affinity_set':
arch/powerpc/platforms/cell/spu_priv1_mmio.c:78: undefined reference to `.iic_get_target_id'
arch/powerpc/platforms/built-in.o: In function `iic_init_IRQ':
arch/powerpc/platforms/cell/interrupt.c:397: undefined reference to `.iic_setup_cpu'


Signed-off-by: Olof Johansson <olof@lixom.net>

diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index 151fd8b..222678f 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -158,6 +158,11 @@ static unsigned int iic_get_irq(void)
 	return virq;
 }
 
+void iic_setup_cpu(void)
+{
+	out_be64(&__get_cpu_var(iic).regs->prio, 0xff);
+}
+
 #ifdef CONFIG_SMP
 
 /* Use the highest interrupt priorities for IPI */
@@ -166,11 +171,6 @@ static inline int iic_ipi_to_irq(int ipi)
 	return IIC_IRQ_TYPE_IPI + 0xf - ipi;
 }
 
-void iic_setup_cpu(void)
-{
-	out_be64(&__get_cpu_var(iic).regs->prio, 0xff);
-}
-
 void iic_cause_IPI(int cpu, int mesg)
 {
 	out_be64(&per_cpu(iic, cpu).regs->generate, (0xf - mesg) << 4);
diff --git a/arch/powerpc/platforms/cell/spu_priv1_mmio.c b/arch/powerpc/platforms/cell/spu_priv1_mmio.c
index 67fa724..e5e08ac 100644
--- a/arch/powerpc/platforms/cell/spu_priv1_mmio.c
+++ b/arch/powerpc/platforms/cell/spu_priv1_mmio.c
@@ -75,9 +75,11 @@ static u64 int_stat_get(struct spu *spu, int class)
 
 static void cpu_affinity_set(struct spu *spu, int cpu)
 {
+#ifdef CONFIG_SMP
 	u64 target = iic_get_target_id(cpu);
 	u64 route = target << 48 | target << 32 | target << 16;
 	out_be64(&spu->priv1->int_route_RW, route);
+#endif
 }
 
 static u64 mfc_dar_get(struct spu *spu)
