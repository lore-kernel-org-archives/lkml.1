Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbYEWTso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbYEWTso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 15:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755349AbYEWTsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 15:48:36 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:36990 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbYEWTsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 15:48:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=G5l/vv/WI5RyBDfsbiOsUvUofZNm6jfyrlgRLp4FKNzyTfJ9Qk/JE0DdaJ8zaD9CSglR88YaC7/EP3LJ4HZmuApGjOAVct6ssuL5EDv8xLiD9RcGBHqsbSH+Xwi+ZySanGa+BnNfcf2VchQQhkd8GA2avlRUjMmNnXKYEhwxmSw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Grant Grundler <grundler@parisc-linux.org>
Subject: [PATCH] x86: early dump pci conf space v3
Date: Fri, 23 May 2008 12:48:54 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805210012.35939.yhlu.kernel@gmail.com> <200805221435.11734.yhlu.kernel@gmail.com>
In-Reply-To: <200805221435.11734.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805231248.55345.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so we can printout pci config before kernel touch it
v3: change to pci=early_config_dump

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -350,6 +350,11 @@ void __init setup_arch(char **cmdline_p)
 
 	parse_early_param();
 
+#ifdef CONFIG_PCI
+	if (pci_early_config_dump)
+		early_dump_pci_devices();
+#endif
+
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	if (init_ohci1394_dma_early)
 		init_ohci1394_dma_on_all_controllers();
Index: linux-2.6/arch/x86/pci/common.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/common.c
+++ linux-2.6/arch/x86/pci/common.c
@@ -20,6 +20,7 @@
 unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2 |
 				PCI_PROBE_MMCONF;
 
+unsigned int pci_early_config_dump;
 static int pci_bf_sort;
 int pci_routeirq;
 int pcibios_last_bus = -1;
@@ -489,6 +490,9 @@ char * __devinit  pcibios_setup(char *st
 	} else if (!strcmp(str, "use_crs")) {
 		pci_probe |= PCI_USE__CRS;
 		return NULL;
+	} else if (!strcmp(str, "early_config_dump")) {
+		pci_early_config_dump = 1;
+		return NULL;
 	} else if (!strcmp(str, "routeirq")) {
 		pci_routeirq = 1;
 		return NULL;
Index: linux-2.6/arch/x86/pci/early.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/early.c
+++ linux-2.6/arch/x86/pci/early.c
@@ -57,3 +57,57 @@ int early_pci_allowed(void)
 	return (pci_probe & (PCI_PROBE_CONF1|PCI_PROBE_NOEARLY)) ==
 			PCI_PROBE_CONF1;
 }
+
+void early_dump_pci_device(u8 bus, u8 slot, u8 func)
+{
+	int i;
+	int j;
+	u32 val;
+
+	if (!early_pci_allowed())
+		return;
+
+	printk("PCI: %02x:%02x:%02x", bus, slot, func);
+
+	for (i = 0; i < 256; i += 4) {
+		if (!(i & 0x0f))
+			printk("\n%04x:",i);
+
+		val = read_pci_config(bus, slot, func, i);
+		for (j = 0; j < 4; j++) {
+			printk(" %02x", val & 0xff);
+			val >>= 8;
+		}
+	}
+	printk("\n");
+}
+
+void early_dump_pci_devices(void)
+{
+	unsigned bus, slot, func;
+
+	if (!early_pci_allowed())
+		return;
+
+	for (bus = 0; bus < 256; bus++) {
+		for (slot = 0; slot < 32; slot++) {
+			for (func = 0; func < 8; func++) {
+				u32 class;
+				u8 type;
+				class = read_pci_config(bus, slot, func,
+							PCI_CLASS_REVISION);
+				if (class == 0xffffffff)
+					break;
+
+				early_dump_pci_device(bus, slot, func);
+
+				/* No multi-function device? */
+				type = read_pci_config_byte(bus, slot, func,
+							       PCI_HEADER_TYPE);
+				if (!(type & 0x80))
+					break;
+			}
+		}
+	}
+}
+
Index: linux-2.6/include/asm-x86/pci-direct.h
===================================================================
--- linux-2.6.orig/include/asm-x86/pci-direct.h
+++ linux-2.6/include/asm-x86/pci-direct.h
@@ -14,4 +14,7 @@ extern void write_pci_config_byte(u8 bus
 
 extern int early_pci_allowed(void);
 
+extern unsigned int pci_early_config_dump;
+extern void early_dump_pci_device(u8 bus, u8 slot, u8 func);
+extern void early_dump_pci_devices(void);
 #endif
Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -1570,6 +1570,8 @@ and is between 256 and 4096 characters. 
 		cbmemsize=nn[KMG]	The fixed amount of bus space which is
 				reserved for the CardBus bridge's memory
 				window. The default value is 64 megabytes.
+		early_config_dump	[X86] print out pci config space
+				registers early before kernel touch any
 
 	pcmv=		[HW,PCMCIA] BadgePAD 4
 
Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -46,6 +46,7 @@
 #include <linux/dmi.h>
 #include <linux/pfn.h>
 #include <linux/pci.h>
+#include <asm/pci-direct.h>
 #include <linux/init_ohci1394_dma.h>
 #include <linux/kvm_para.h>
 
@@ -692,6 +693,11 @@ void __init setup_arch(char **cmdline_p)
 
 	parse_early_param();
 
+#ifdef CONFIG_PCI
+	if (pci_early_config_dump)
+		early_dump_pci_devices();
+#endif
+
 	finish_e820_parsing();
 
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
