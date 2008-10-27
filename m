Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbYJ0ISZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbYJ0ISZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 04:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbYJ0ISR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 04:18:17 -0400
Received: from aun.it.uu.se ([130.238.12.36]:35785 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbYJ0ISQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 04:18:16 -0400
Date: Mon, 27 Oct 2008 09:17:54 +0100 (MET)
Message-Id: <200810270817.m9R8HsJu029399@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: mingo@redhat.com
Subject: [PATCH 2.6.28-rc2] i386: fix forbid_dac linkage error when CONFIG_PCI=n
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix 2.6.28-rc2 build failure on i386 with CONFIG_PCI=n:

  ld -m elf_i386  -o .tmp_vmlinux1 -T arch/x86/kernel/vmlinux.lds arch/x86/kernel/head_32.o arch/x86/kernel/head32.o arch/x86/kernel/head.o arch/x86/kernel/init_task.o  init/built-in.o --start-group  usr/built-in.o  arch/x86/kernel/built-in.o  arch/x86/mm/built-in.o  arch/x86/mach-default/built-in.o  arch/x86/crypto/built-in.o  arch/x86/vdso/built-in.o  kernel/built-in.o  mm/built-in.o  fs/built-in.o  ipc/built-in.o  security/built-in.o  crypto/built-in.o  block/built-in.o  lib/lib.a  arch/x86/lib/lib.a  lib/built-in.o  arch/x86/lib/built-in.o  drivers/built-in.o  sound/built-in.o  firmware/built-in.o  net/built-in.o --end-group 
arch/x86/kernel/built-in.o: In function `iommu_setup':
pci-dma.c:(.init.text+0x3120): undefined reference to `forbid_dac'
pci-dma.c:(.init.text+0x313f): undefined reference to `forbid_dac'
pci-dma.c:(.init.text+0x3187): undefined reference to `forbid_dac'
make: *** [.tmp_vmlinux1] Error 1

The variable forbid_dac was moved from arch/x86/kernel/pci-dma.c
to drivers/pci/quirks.c. When CONFIG_PCI=n pci-dma.c now refers to
a variable that's never defined, causing a linkage error.

Fixed by bracketing the forbid_dac accesses (command-line options
parsing) with #ifdef CONFIG_PCI ... #endif.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---
 arch/x86/kernel/pci-dma.c |    2 ++
 1 file changed, 2 insertions(+)

diff -rupN linux-2.6.28-rc2/arch/x86/kernel/pci-dma.c linux-2.6.28-rc2.x86-forbid_dac-is-pci-only/arch/x86/kernel/pci-dma.c
--- linux-2.6.28-rc2/arch/x86/kernel/pci-dma.c	2008-10-26 21:35:33.000000000 +0100
+++ linux-2.6.28-rc2.x86-forbid_dac-is-pci-only/arch/x86/kernel/pci-dma.c	2008-10-27 08:55:10.000000000 +0100
@@ -202,6 +202,7 @@ static __init int iommu_setup(char *p)
 			iommu_merge = 0;
 		if (!strncmp(p, "forcesac", 8))
 			iommu_sac_force = 1;
+#ifdef CONFIG_PCI
 		if (!strncmp(p, "allowdac", 8))
 			forbid_dac = 0;
 		if (!strncmp(p, "nodac", 5))
@@ -210,6 +211,7 @@ static __init int iommu_setup(char *p)
 			forbid_dac = -1;
 			return 1;
 		}
+#endif /* CONFIG_PCI */
 #ifdef CONFIG_SWIOTLB
 		if (!strncmp(p, "soft", 4))
 			swiotlb = 1;
