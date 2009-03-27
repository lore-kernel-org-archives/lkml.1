Return-Path: <linux-kernel-owner+w=401wt.eu-S1757706AbZC0Ljj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706AbZC0Ljj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 07:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbZC0Lj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 07:39:28 -0400
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:35754 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbZC0Lj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 07:39:27 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Subject: [PATCH 1/1] [MIPS] ip22: use a generic method for irq statistics
Date: Fri, 27 Mar 2009 13:39:11 +0200
Message-Id: <1238153951-18307-1-git-send-email-dmitri.vorobiev@movial.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The structure 'struct kernel_stat' defines the 'irqs' array as its
field only when CONFIG_GENERIC_HARDIRQS is not set. However, the ip22
code makes use of this field unconditionally. As the result, the
following build error is produced:

  CC      arch/mips/sgi-ip22/ip22-int.o
arch/mips/sgi-ip22/ip22-int.c: In function 'indy_buserror_irq':
arch/mips/sgi-ip22/ip22-int.c:158: error: 'struct kernel_stat' has no
member named 'irqs'
make[1]: *** [arch/mips/sgi-ip22/ip22-int.o] Error 1
make: *** [arch/mips/sgi-ip22] Error 2

This patch fixes the build error by using the generic method for the irq
statistics.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
---
 arch/mips/sgi-ip22/ip22-int.c  |    3 ++-
 arch/mips/sgi-ip22/ip22-time.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/mips/sgi-ip22/ip22-int.c b/arch/mips/sgi-ip22/ip22-int.c
index f8b18af..e359ee8 100644
--- a/arch/mips/sgi-ip22/ip22-int.c
+++ b/arch/mips/sgi-ip22/ip22-int.c
@@ -153,9 +153,10 @@ extern void ip22_be_interrupt(int irq);
 static void indy_buserror_irq(void)
 {
 	int irq = SGI_BUSERR_IRQ;
+	struct irq_desc *desc = irq_to_desc(irq);
 
 	irq_enter();
-	kstat_this_cpu.irqs[irq]++;
+	kstat_incr_irqs_this_cpu(irq, desc);
 	ip22_be_interrupt(irq);
 	irq_exit();
 }
diff --git a/arch/mips/sgi-ip22/ip22-time.c b/arch/mips/sgi-ip22/ip22-time.c
index 3dcb27e..2536d78 100644
--- a/arch/mips/sgi-ip22/ip22-time.c
+++ b/arch/mips/sgi-ip22/ip22-time.c
@@ -118,11 +118,12 @@ __init void plat_time_init(void)
 void indy_8254timer_irq(void)
 {
 	int irq = SGI_8254_0_IRQ;
+	struct irq_desc *desc = irq_to_desc(irq);
 	ULONG cnt;
 	char c;
 
 	irq_enter();
-	kstat_this_cpu.irqs[irq]++;
+	kstat_incr_irqs_this_cpu(irq, desc);
 	printk(KERN_ALERT "Oops, got 8254 interrupt.\n");
 	ArcRead(0, &c, 1, &cnt);
 	ArcEnterInteractiveMode();
-- 
1.5.6.3

