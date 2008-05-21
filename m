Return-Path: <linux-kernel-owner+w=401wt.eu-S1764204AbYEUHMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764204AbYEUHMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 03:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbYEUHLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 03:11:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:12644 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbYEUHLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 03:11:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=bDMpMPFgbqY9kHwlmMWCXwZdy6NDUqO3mIuxZzI7V9UYftUMvlFhYVYtSqqy7EgBmUwRtuBuayk9fVEiTdo1dUVoXu1aeY5hlgXhOeUDiZUqT38dNS2CD+mgbjLlfVZ5jionACgdkvRgzwsc8j8Q5xENAcwaerVsustS1FNJ3N4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: early dump pci conf space
Date: Wed, 21 May 2008 00:12:35 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805210012.35939.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so we can printout pci config before kernel touch it

also fix write_pci_config_byte with offset
and add write_pci_config_16

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -350,6 +350,11 @@ void __init setup_arch(char **cmdline_p)
 
 	parse_early_param();
 
+#ifdef CONFIG_PCI
+	if (pci_early_dump_regs)
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
 
+unsigned int pci_early_dump_regs;
 static int pci_bf_sort;
 int pci_routeirq;
 int pcibios_last_bus = -1;
@@ -489,6 +490,9 @@ char * __devinit  pcibios_setup(char *st
 	} else if (!strcmp(str, "use_crs")) {
 		pci_probe |= PCI_USE__CRS;
 		return NULL;
+	} else if (!strcmp(str, "earlydump")) {
+		pci_early_dump_regs = 1;
+		return NULL;
 	} else if (!strcmp(str, "routeirq")) {
 		pci_routeirq = 1;
 		return NULL;
Index: linux-2.6/arch/x86/pci/early.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/early.c
+++ linux-2.6/arch/x86/pci/early.c
@@ -49,7 +49,14 @@ void write_pci_config_byte(u8 bus, u8 sl
 {
 	PDprintk("%x writing to %x: %x\n", slot, offset, val);
 	outl(0x80000000 | (bus<<16) | (slot<<11) | (func<<8) | offset, 0xcf8);
-	outb(val, 0xcfc);
+	outb(val, 0xcfc + (offset&3));
+}
+
+void write_pci_config_16(u8 bus, u8 slot, u8 func, u8 offset, u16 val)
+{
+	PDprintk("%x writing to %x: %x\n", slot, offset, val);
+	outl(0x80000000 | (bus<<16) | (slot<<11) | (func<<8) | offset, 0xcf8);
+	outw(val, 0xcfc + (offset&2));
 }
 
 int early_pci_allowed(void)
@@ -57,3 +64,54 @@ int early_pci_allowed(void)
 	return (pci_probe & (PCI_PROBE_CONF1|PCI_PROBE_NOEARLY)) ==
 			PCI_PROBE_CONF1;
 }
+
+void early_dump_pci_device(u8 bus, u8 slot, u8 func)
+{
+        int i;
+        int j;
+	u32 val;
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
@@ -11,7 +11,11 @@ extern u8 read_pci_config_byte(u8 bus, u
 extern u16 read_pci_config_16(u8 bus, u8 slot, u8 func, u8 offset);
 extern void write_pci_config(u8 bus, u8 slot, u8 func, u8 offset, u32 val);
 extern void write_pci_config_byte(u8 bus, u8 slot, u8 func, u8 offset, u8 val);
+extern void write_pci_config_16(u8 bus, u8 slot, u8 func, u8 offset, u16 val);
 
 extern int early_pci_allowed(void);
 
+extern unsigned int pci_early_dump_regs;
+extern void early_dump_pci_device(u8 bus, u8 slot, u8 func);
+extern void early_dump_pci_devices(void);
 #endif
