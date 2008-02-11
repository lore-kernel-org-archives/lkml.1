Return-Path: <linux-kernel-owner+w=401wt.eu-S1760605AbYBKT3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760605AbYBKT3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760433AbYBKT3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:29:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760414AbYBKT3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:29:21 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       ak@suse.de, chrisw@sous-sol.org, kiran@scalemp.com, shai@scalemp.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 3/5] [PATCH] call vsmp_init explicitly
Date: Mon, 11 Feb 2008 17:16:03 -0200
Message-Id: <1202757365-18634-3-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1202757365-18634-2-git-send-email-gcosta@redhat.com>
References: <1202757365-18634-1-git-send-email-gcosta@redhat.com>
 <1202757365-18634-2-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It becomes to early for ioremap, so we use early_ioremap

Signed-off-by: Glauber Costa <gcosta@redhat.com>
Signed-off-by: Ravikiran Thirumalai <kiran@scalemp.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
---
 arch/x86/kernel/setup_64.c |    4 ++++
 arch/x86/kernel/vsmp_64.c  |   11 +++++------
 include/asm-x86/setup.h    |    4 ++++
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index a49f5f7..6f5571c 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -346,6 +346,10 @@ #endif
 	if (efi_enabled)
 		efi_init();
 
+#ifdef	CONFIG_PARAVIRT
+	vsmp_init();
+#endif
+
 	dmi_scan_machine();
 
 	io_delay_init();
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index 9766917..fdf9fba 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -16,10 +16,10 @@ #include <linux/pci_regs.h>
 #include <asm/pci-direct.h>
 #include <asm/io.h>
 
-static void __init vsmp_init(void)
+void __init vsmp_init(void)
 {
 	void *address;
-	unsigned int cap, ctl;
+	unsigned int cap, ctl, cfg;
 
 	if (!early_pci_allowed())
 		return;
@@ -32,7 +32,8 @@ static void __init vsmp_init(void)
 		return;
 
 	/* set vSMP magic bits to indicate vSMP capable kernel */
-	address = ioremap(read_pci_config(0, 0x1f, 0, PCI_BASE_ADDRESS_0), 8);
+	cfg = read_pci_config(0, 0x1f, 0, PCI_BASE_ADDRESS_0);
+	address = early_ioremap(cfg, 8);
 	cap = readl(address);
 	ctl = readl(address + 4);
 	printk(KERN_INFO "vSMP CTL: capabilities:0x%08x  control:0x%08x\n",
@@ -45,8 +46,6 @@ static void __init vsmp_init(void)
 		printk(KERN_INFO "vSMP CTL: control set to:0x%08x\n", ctl);
 	}
 
-	iounmap(address);
+	early_iounmap(address, 8);
 	return;
 }
-
-core_initcall(vsmp_init);
diff --git a/include/asm-x86/setup.h b/include/asm-x86/setup.h
index 071e054..f745de2 100644
--- a/include/asm-x86/setup.h
+++ b/include/asm-x86/setup.h
@@ -4,6 +4,10 @@ #define _ASM_X86_SETUP_H
 #define COMMAND_LINE_SIZE 2048
 
 #ifndef __ASSEMBLY__
+
+/* Interrupt control for vSMPowered x86_64 systems */
+void vsmp_init(void);
+
 char *machine_specific_memory_setup(void);
 #ifndef CONFIG_PARAVIRT
 #define paravirt_post_allocator_init()	do {} while (0)
-- 
1.4.2

