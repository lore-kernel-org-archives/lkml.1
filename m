Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbYHYH5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbYHYH5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 03:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbYHYH5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 03:57:09 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:7392 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbYHYH5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 03:57:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Z04N0AQr3yMMqnitqYKjQCxhL7i3oqusDndqHWhnhCN12H3smwfCsVWv6iZyVnc+F9
         eO5nkdHHZO14uVAKdaKuqiBRNmoc7ElFdK4nevrGbulffihoUHIQqjO3LpRPB0omlfiN
         0YlURvbdhs6KptcQnUFVUILI1At85xvK5hbDw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: check hpet with BAR v3
Date: Mon, 25 Aug 2008 00:56:08 -0700
Message-Id: <1219650968-3534-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

insert some resources to resource tree forcily, so could avoid kernel update the
resources in pci device.

should check in device too.

add check for ioapic and mmconfig

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/pci/i386.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

Index: linux-2.6/arch/x86/pci/i386.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/i386.c
+++ linux-2.6/arch/x86/pci/i386.c
@@ -31,8 +31,11 @@
 #include <linux/ioport.h>
 #include <linux/errno.h>
 #include <linux/bootmem.h>
+#include <linux/acpi.h>
 
 #include <asm/pat.h>
+#include <asm/hpet.h>
+#include <asm/io_apic.h>
 
 #include "pci.h"
 
@@ -77,6 +80,77 @@ pcibios_align_resource(void *data, struc
 }
 EXPORT_SYMBOL(pcibios_align_resource);
 
+static int check_res_with_valid(struct pci_dev *dev, struct resource *res)
+{
+	unsigned long base;
+	unsigned long size;
+	int i;
+
+	base = res->start;
+	size = (res->start == 0 && res->end == res->start) ? 0 :
+		 (res->end - res->start + 1);
+
+	if (!base || !size)
+		return 0;
+
+#ifdef CONFIG_HPET_TIMER
+	/* for hpet */
+	if (base == hpet_address && (res->flags & IORESOURCE_MEM)) {
+		dev_info(&dev->dev, "BAR has HPET at %08lx-%08lx\n",
+				 base, base + size - 1);
+		return 1;
+	}
+#endif
+
+#ifdef CONFIG_X86_IO_APIC
+	for (i = 0; i < nr_ioapics; i++) {
+		unsigned long ioapic_phys = mp_ioapics[i].mp_apicaddr;
+
+		if (base == ioapic_phys && (res->flags & IORESOURCE_MEM)) {
+			dev_info(&dev->dev, "BAR has ioapic at %08lx-%08lx\n",
+					 base, base + size - 1);
+			return 1;
+		}
+	}
+#endif
+
+#ifdef CONFIG_PCI_MMCONFIG
+	for (i = 0; i < pci_mmcfg_config_num; i++) {
+		unsigned long addr;
+
+		addr = pci_mmcfg_config[i].address;
+		if (base == addr && (res->flags & IORESOURCE_MEM)) {
+			dev_info(&dev->dev, "BAR has MMCONFIG at %08lx-%08lx\n",
+					 base, base + size - 1);
+			return 1;
+		}
+	}
+#endif
+
+	return 0;
+}
+
+static int check_platform(struct pci_dev *dev, struct resource *res)
+{
+	struct resource *root = NULL;
+
+	/*
+	 * forcibly insert it into the
+	 * resource tree
+	 */
+	if (res->flags & IORESOURCE_MEM)
+		root = &iomem_resource;
+	else if (res->flags & IORESOURCE_IO)
+		root = &ioport_resource;
+
+	if (root && check_res_with_valid(dev, res)) {
+		insert_resource(root, res);
+
+		return 1;
+	}
+
+	return 0;
+}
 /*
  *  Handle resources of PCI devices.  If the world were perfect, we could
  *  just allocate all the resource regions and do nothing more.  It isn't.
@@ -128,6 +202,8 @@ static void __init pcibios_allocate_bus_
 				pr = pci_find_parent_resource(dev, r);
 				if (!r->start || !pr ||
 				    request_resource(pr, r) < 0) {
+					if (check_platform(dev, r))
+						continue;
 					dev_err(&dev->dev, "BAR %d: can't "
 						"allocate resource\n", idx);
 					/*
@@ -171,6 +247,8 @@ static void __init pcibios_allocate_reso
 					r->flags, disabled, pass);
 				pr = pci_find_parent_resource(dev, r);
 				if (!pr || request_resource(pr, r) < 0) {
+					if (check_platform(dev, r))
+						continue;
 					dev_err(&dev->dev, "BAR %d: can't "
 						"allocate resource\n", idx);
 					/* We'll assign a new address later */
