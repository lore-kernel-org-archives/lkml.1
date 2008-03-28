Return-Path: <linux-kernel-owner+w=401wt.eu-S1755724AbYC1QW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbYC1QW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 12:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbYC1QWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 12:22:16 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:7734 "EHLO
	outbound8-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754041AbYC1QWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 12:22:15 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
To: linuxppc-dev@xilinx.com, benh@kernel.crashing.org,
       jwboyer@linux.vnet.ibm.com, sfr@canb.auug.org.au,
       grant.likely@secretlab.ca, git-dev@xilinx.com,
       linux-kernel@vger.kernel.org
Cc: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Subject: [PATCH 5/5] [RFC][PPC] Use DCR for arch ppc, and enable MMIO and NATIVE for virtex.
Date: Fri, 28 Mar 2008 09:20:37 -0700
X-Mailer: git-send-email 1.5.3.4-dirty
In-Reply-To: <1206721237-17982-4-git-send-email-stephen.neuendorffer@xilinx.com>
References: <1206401313-1625-1-git-send-email-stephen.neuendorffer@xilinx.com>
 <1206721237-17982-1-git-send-email-stephen.neuendorffer@xilinx.com>
 <1206721237-17982-2-git-send-email-stephen.neuendorffer@xilinx.com>
 <1206721237-17982-3-git-send-email-stephen.neuendorffer@xilinx.com>
 <1206721237-17982-4-git-send-email-stephen.neuendorffer@xilinx.com>
Message-Id: <20080328162211.6644F13D006A@mail49-sin.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generally speaking, I'm not sure about the validity of this patch.  In
particular:

1) I'm not sure what architecture code relies on including
dcr support through ibm4xx.h.

2) I'm not sure how temporary the ifdef in
arch/powerpc/sysdev/Makefile really is.  Is it still needed or not?

However, this appears to work at least for the Virtex systems I've
tried.  In any event, I don't expect this to actually be sent to
mainline, since it's ARCH=ppc related, at least not in this form.

Unfortunately, the framebuffer driver won't work under ARCH=ppc
without this patch.
---
 arch/powerpc/sysdev/Makefile   |    2 --
 arch/ppc/Kconfig               |    6 +++++-
 arch/ppc/platforms/4xx/Kconfig |    2 ++
 include/asm-ppc/ibm4xx.h       |    1 -
 4 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/sysdev/Makefile b/arch/powerpc/sysdev/Makefile
index 15f3e85..c85525b 100644
--- a/arch/powerpc/sysdev/Makefile
+++ b/arch/powerpc/sysdev/Makefile
@@ -35,10 +35,8 @@ endif
 endif
 
 # Temporary hack until we have migrated to asm-powerpc
-ifeq ($(ARCH),powerpc)
 obj-$(CONFIG_CPM)		+= cpm_common.o
 obj-$(CONFIG_CPM2)		+= cpm2.o cpm2_pic.o
 obj-$(CONFIG_PPC_DCR)		+= dcr.o
 obj-$(CONFIG_8xx)		+= mpc8xx_pic.o cpm1.o
 obj-$(CONFIG_UCODE_PATCH)	+= micropatch.o
-endif
diff --git a/arch/ppc/Kconfig b/arch/ppc/Kconfig
index abc877f..81d6748 100644
--- a/arch/ppc/Kconfig
+++ b/arch/ppc/Kconfig
@@ -116,9 +116,13 @@ config PPC_DCR_NATIVE
 	bool
 	default n
 
+config PPC_DCR_MMIO
+	bool
+	default n
+
 config PPC_DCR
 	bool
-	depends on PPC_DCR_NATIVE
+	depends on PPC_DCR_NATIVE || PPC_DCR_MMIO
 	default y
 
 config PTE_64BIT
diff --git a/arch/ppc/platforms/4xx/Kconfig b/arch/ppc/platforms/4xx/Kconfig
index 76551b6..0430fc2 100644
--- a/arch/ppc/platforms/4xx/Kconfig
+++ b/arch/ppc/platforms/4xx/Kconfig
@@ -228,6 +228,8 @@ config XILINX_VIRTEX_4_FX
 
 config XILINX_VIRTEX
 	bool
+	select PPC_DCR_NATIVE
+	select PPC_DCR_MMIO
 
 config STB03xxx
 	bool
diff --git a/include/asm-ppc/ibm4xx.h b/include/asm-ppc/ibm4xx.h
index ed6891a..053a86b 100644
--- a/include/asm-ppc/ibm4xx.h
+++ b/include/asm-ppc/ibm4xx.h
@@ -15,7 +15,6 @@
 #define __ASM_IBM4XX_H__
 
 #include <asm/types.h>
-#include <asm/dcr.h>
 
 #ifdef CONFIG_40x
 
-- 
1.5.3.4-dirty


