Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbYKPOsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbYKPOsl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 09:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbYKPOr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 09:47:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47491 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbYKPOrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 09:47:53 -0500
From: Bernhard Walle <bwalle@suse.de>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       crash-utility@redhat.com, Bernhard Walle <bwalle@suse.de>
Subject: [PATCH 3/3] Remove CONFIG_STRICT_DEVMEM
Date: Sun, 16 Nov 2008 15:47:48 +0100
Message-Id: <1226846868-9595-4-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1226846868-9595-1-git-send-email-bwalle@suse.de>
References: <1226846868-9595-1-git-send-email-bwalle@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the behaviour of /dev/mem can now be controlled via sysctl, we don't need
CONFIG_STRICT_DEVMEM any more. With SELinux or Apparmor, the sysctl can be
prohibited to be turned on. Without SELinux or Apparmor, you can circumvent
the restriction anyways by loading a kernel module that installs a kretprobe
that just ignores the check and always returns true.

The increase of code size is neglecatble and the code becomes more readable
with less CONFIG options and #ifdef's.


Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 arch/x86/Kconfig.debug            |   17 -----------------
 arch/x86/configs/i386_defconfig   |    1 -
 arch/x86/configs/x86_64_defconfig |    1 -
 arch/x86/include/asm/page.h       |    4 ----
 drivers/char/mem.c                |    7 +------
 5 files changed, 1 insertions(+), 29 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 2a3dfbd..28b7c26 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -5,23 +5,6 @@ config TRACE_IRQFLAGS_SUPPORT
 
 source "lib/Kconfig.debug"
 
-config STRICT_DEVMEM
-	bool "Filter access to /dev/mem"
-	help
-	  If this option is disabled, you allow userspace (root) access to all
-	  of memory, including kernel and userspace memory. Accidental
-	  access to this is obviously disastrous, but specific access can
-	  be used by people debugging the kernel. Note that with PAT support
-	  enabled, even in this case there are restrictions on /dev/mem
-	  use due to the cache aliasing requirements.
-
-	  If this option is switched on, the /dev/mem file only allows
-	  userspace access to PCI space and the BIOS code and data regions.
-	  This is sufficient for dosemu and X and all common users of
-	  /dev/mem.
-
-	  If in doubt, say Y.
-
 config X86_VERBOSE_BOOTUP
 	bool "Enable verbose x86 bootup info messages"
 	default y
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 13b8c86..93e8696 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -2090,7 +2090,6 @@ CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
 # CONFIG_SAMPLES is not set
 CONFIG_HAVE_ARCH_KGDB=y
 # CONFIG_KGDB is not set
-# CONFIG_STRICT_DEVMEM is not set
 CONFIG_X86_VERBOSE_BOOTUP=y
 CONFIG_EARLY_PRINTK=y
 CONFIG_DEBUG_STACKOVERFLOW=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index f0a03d7..8b162ea 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -2059,7 +2059,6 @@ CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
 # CONFIG_SAMPLES is not set
 CONFIG_HAVE_ARCH_KGDB=y
 # CONFIG_KGDB is not set
-# CONFIG_STRICT_DEVMEM is not set
 CONFIG_X86_VERBOSE_BOOTUP=y
 CONFIG_EARLY_PRINTK=y
 CONFIG_DEBUG_STACKOVERFLOW=y
diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index e5fe778..90dfcf2 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -66,11 +66,7 @@ extern void unmap_devmem(unsigned long pfn, unsigned long size,
 #define __HAVE_ARCH_RANGE_IS_ALLOWED 1
 
 
-#ifdef CONFIG_STRICT_DEVMEM
 extern int devmem_restricted;
-#else
-#define devmem_restricted 0
-#endif
 
 extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 43b70b8..b4bbf80 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -37,8 +37,6 @@
 #endif
 
 
-#ifdef CONFIG_STRICT_DEVMEM
-
 int devmem_restricted = 1;
 
 #ifdef CONFIG_SYSCTL
@@ -74,9 +72,6 @@ struct ctl_table dev_sysctl_table[] = {
 
 #endif
 
-#endif /* CONFIG_STRICT_DEVMEM */
-
-
 /*
  * Architectures vary in how they handle caching for addresses
  * outside of main memory.
@@ -1034,7 +1029,7 @@ static int __init chr_dev_init(void)
 			      MKDEV(MEM_MAJOR, devlist[i].minor), NULL,
 			      devlist[i].name);
 
-#if defined(CONFIG_SYSCTL) && defined(CONFIG_STRICT_DEVMEM)
+#if defined(CONFIG_SYSCTL)
 	/*
 	 * since there is no unload function, we don't have to deregister that
 	 * the whole lifetime of the kernel and can ignore the return value
-- 
1.6.0.4

