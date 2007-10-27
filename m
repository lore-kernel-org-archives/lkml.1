Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbXJ0RVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbXJ0RVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 13:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbXJ0RVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 13:21:08 -0400
Received: from lixom.net ([66.141.50.11]:39064 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591AbXJ0RVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 13:21:07 -0400
Date: Sat, 27 Oct 2007 12:28:51 -0500
From: Olof Johansson <olof@lixom.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] [POWERPC] Fix CONFIG_SMP=n build break
Message-ID: <20071027172851.GA11930@lixom.net>
References: <20071026165510.GA2323@lixom.net> <200710262019.12094.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710262019.12094.arnd@arndb.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix two build errors on powerpc allyesconfig + CONFIG_SMP=n:

arch/powerpc/platforms/built-in.o: In function `cpu_affinity_set':
arch/powerpc/platforms/cell/spu_priv1_mmio.c:78: undefined reference to `.iic_get_target_id'
arch/powerpc/platforms/built-in.o: In function `iic_init_IRQ':
arch/powerpc/platforms/cell/interrupt.c:397: undefined reference to `.iic_setup_cpu'

Signed-off-by: Olof Johansson <olof@lixom.net>

---

On Fri, Oct 26, 2007 at 08:19:10PM +0200, Arnd Bergmann wrote:

> I think here it would be better to move iic_get_target_id out of
> CONFIG_SMP as well. We might want to kexec from an SMP kernel into
> a UP kernel, and in that case, cpu_affinity_set() should better
> reset the routing to CPU 0.

Makes sense. New patch.


-Olof

diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index 151fd8b..04f74f9 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -158,6 +158,18 @@ static unsigned int iic_get_irq(void)
 	return virq;
 }
 
+void iic_setup_cpu(void)
+{
+	out_be64(&__get_cpu_var(iic).regs->prio, 0xff);
+}
+
+u8 iic_get_target_id(int cpu)
+{
+	return per_cpu(iic, cpu).target_id;
+}
+
+EXPORT_SYMBOL_GPL(iic_get_target_id);
+
 #ifdef CONFIG_SMP
 
 /* Use the highest interrupt priorities for IPI */
@@ -166,29 +178,17 @@ static inline int iic_ipi_to_irq(int ipi)
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
 }
 
-u8 iic_get_target_id(int cpu)
-{
-	return per_cpu(iic, cpu).target_id;
-}
-EXPORT_SYMBOL_GPL(iic_get_target_id);
-
 struct irq_host *iic_get_irq_host(int node)
 {
 	return iic_host;
 }
 EXPORT_SYMBOL_GPL(iic_get_irq_host);
 
-
 static irqreturn_t iic_ipi_action(int irq, void *dev_id)
 {
 	int ipi = (int)(long)dev_id;
