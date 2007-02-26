Return-Path: <linux-kernel-owner+w=401wt.eu-S1030449AbXBZSyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030449AbXBZSyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 13:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030452AbXBZSyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 13:54:17 -0500
Received: from aun.it.uu.se ([130.238.12.36]:49882 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030449AbXBZSyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 13:54:16 -0500
Date: Mon, 26 Feb 2007 19:54:08 +0100 (MET)
Message-Id: <200702261854.l1QIs8D9013016@alkaid.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: davem@davemloft.net
Subject: [PATCH 2.6.21-rc1] sparc64: fix CONFIG_PCI_MSI=n compile failure
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.21-rc1 fails to build on sparc64 when CONFIG_PCI_MSI=n:

  gcc -Wp,-MD,arch/sparc64/kernel/.irq.o.d  -nostdinc -isystem /home/mikpe/pkgs/linux-sparc64/gcc-4.1.2/lib/gcc/sparc64-unknown-linux-gnu/4.1.2/include -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Os -m64 -pipe -mno-fpu -mcpu=ultrasparc -mcmodel=medlow -ffixed-g4 -ffixed-g5 -fcall-used-g7 -Wno-sign-compare -Wa,--undeclared-regs -fomit-frame-pointer  -fno-stack-protector -Wdeclaration-after-statement -Wno-pointer-sign -Werror   -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(irq)"  -D"KBUILD_MODNAME=KBUILD_STR(irq)" -c -o arch/sparc64/kernel/irq.o arch/sparc64/kernel/irq.c
cc1: warnings being treated as errors
arch/sparc64/kernel/irq.c:113: warning: 'virt_irq_free' defined but not used
make[1]: *** [arch/sparc64/kernel/irq.o] Error 1
make: *** [arch/sparc64/kernel] Error 2

Most other MSI stuff in irq.c is #ifdef CONFIG_PCI_MSI.
So do the same for virt_irq_free() to fix this problem.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>

--- linux-2.6.21-rc1/arch/sparc64/kernel/irq.c.~1~	2007-02-26 17:47:54.000000000 +0100
+++ linux-2.6.21-rc1/arch/sparc64/kernel/irq.c	2007-02-26 18:01:55.000000000 +0100
@@ -109,6 +109,7 @@ static unsigned char virt_irq_alloc(unsi
 	return ent;
 }
 
+#ifdef CONFIG_PCI_MSI
 static void virt_irq_free(unsigned int virt_irq)
 {
 	unsigned int real_irq;
@@ -121,6 +122,7 @@ static void virt_irq_free(unsigned int v
 
 	__bucket(real_irq)->virt_irq = 0;
 }
+#endif
 
 static unsigned int virt_to_real_irq(unsigned char virt_irq)
 {
