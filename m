Return-Path: <linux-kernel-owner+w=401wt.eu-S1760461AbYFETX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760461AbYFETX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 15:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbYFETXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 15:23:16 -0400
Received: from mail.queued.net ([207.210.101.209]:1699 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbYFETXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 15:23:15 -0400
Date: Thu, 5 Jun 2008 15:29:14 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de, rmh@aybabtu.com
Subject: [PATCH] OLPC: pci: fix up PCI stuff so that PCI_GOANY supports OLPC
Message-ID: <20080605152914.6f4ca839@ephemeral>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, one would have to specifically choose CONFIG_OLPC and
CONFIG_PCI_GOOLPC in order to enable PCI_OLPC.  That doesn't really
work for distro kernels, so this patch allows one to choose
CONFIG_OLPC and CONFIG_PCI_GOANY in order to build in OLPC support in
a generic kernel (as requested by Robert Millan).

This also moves GOOLPC before GOANY in the menuconfig list.

Finally, make pci_access_init return early if we detect OLPC hardware.
There's no need to continue probing stuff, and pci_pcbios_init
specifically trashes our settings (we didn't run into that before
because PCI_GOANY wasn't supported).

It would be great if we could sneak this in for 2.6.26..  *cough*  :)

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 arch/x86/Kconfig    |   11 +++++------
 arch/x86/pci/init.c |    3 ++-
 arch/x86/pci/olpc.c |    5 +++--
 arch/x86/pci/pci.h  |    2 +-
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index dcbec34..52e18e6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1508,13 +1508,13 @@ config PCI_GOMMCONFIG
 config PCI_GODIRECT
 	bool "Direct"
 
-config PCI_GOANY
-	bool "Any"
-
 config PCI_GOOLPC
 	bool "OLPC"
 	depends on OLPC
 
+config PCI_GOANY
+	bool "Any"
+
 endchoice
 
 config PCI_BIOS
@@ -1531,9 +1531,8 @@ config PCI_MMCONFIG
 	depends on X86_32 && PCI && ACPI && (PCI_GOMMCONFIG || PCI_GOANY)
 
 config PCI_OLPC
-	bool
-	depends on PCI && PCI_GOOLPC
-	default y
+	def_bool y
+	depends on PCI && OLPC && (PCI_GOOLPC || PCI_GOANY)
 
 config PCI_DOMAINS
 	def_bool y
diff --git a/arch/x86/pci/init.c b/arch/x86/pci/init.c
index e70b9c5..b821f44 100644
--- a/arch/x86/pci/init.c
+++ b/arch/x86/pci/init.c
@@ -15,7 +15,8 @@ static __init int pci_access_init(void)
 	pci_mmcfg_early_init();
 
 #ifdef CONFIG_PCI_OLPC
-	pci_olpc_init();
+	if (!pci_olpc_init())
+		return 0;	/* skip additional checks if it's an XO */
 #endif
 #ifdef CONFIG_PCI_BIOS
 	pci_pcbios_init();
diff --git a/arch/x86/pci/olpc.c b/arch/x86/pci/olpc.c
index 5e76365..e11e9e8 100644
--- a/arch/x86/pci/olpc.c
+++ b/arch/x86/pci/olpc.c
@@ -302,12 +302,13 @@ static struct pci_raw_ops pci_olpc_conf = {
 	.write = pci_olpc_write,
 };
 
-void __init pci_olpc_init(void)
+int __init pci_olpc_init(void)
 {
 	if (!machine_is_olpc() || olpc_has_vsa())
-		return;
+		return -ENODEV;
 
 	printk(KERN_INFO "PCI: Using configuration type OLPC\n");
 	raw_pci_ops = &pci_olpc_conf;
 	is_lx = is_geode_lx();
+	return 0;
 }
diff --git a/arch/x86/pci/pci.h b/arch/x86/pci/pci.h
index f3972b1..720c4c5 100644
--- a/arch/x86/pci/pci.h
+++ b/arch/x86/pci/pci.h
@@ -101,7 +101,7 @@ extern struct pci_raw_ops pci_direct_conf1;
 extern int pci_direct_probe(void);
 extern void pci_direct_init(int type);
 extern void pci_pcbios_init(void);
-extern void pci_olpc_init(void);
+extern int pci_olpc_init(void);
 
 /* pci-mmconfig.c */
 
-- 
1.5.5.1

