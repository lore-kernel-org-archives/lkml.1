Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624Ab0AZW6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab0AZW6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 17:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217Ab0AZW6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 17:58:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:58625 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab0AZW6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 17:58:40 -0500
Message-ID: <4B5F735B.2040308@kernel.org>
Date: Tue, 26 Jan 2010 14:57:31 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Jeff Garrett <jeff@jgarrett.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Myron Stowe <myron.stowe@hp.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with pci=use_crs)
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>	<201001261348.59508.rjw@sisk.pl>	<201001261032.37053.bjorn.helgaas@hp.com>	<201001261902.13911.rjw@sisk.pl> <20100126101752.78196900@jbarnes-piketon>
In-Reply-To: <20100126101752.78196900@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2010 10:17 AM, Jesse Barnes wrote:

> 
> For 2.6.33 I'd like a minimal fix though, can you disable it for all
> but the multi-IOH case perhaps?
> 
please check,

[PATCH] x86/pci: don't use ioh resource if only have one ioh

some system could use reosurce out of IOH resources when only one ioh is there.

could be BIOS have wrong IOH resources and not enable them.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/intel_bus.c |   86 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

Index: linux-2.6/arch/x86/pci/intel_bus.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/intel_bus.c
+++ linux-2.6/arch/x86/pci/intel_bus.c
@@ -7,9 +7,11 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <asm/pci_x86.h>
+#include <asm/pci-direct.h>
 
 #include "bus_numa.h"
 
+static int nr_ioh;
 static inline void print_ioh_resources(struct pci_root_info *info)
 {
 	int res_num;
@@ -49,6 +51,9 @@ static void __devinit pci_root_bus_res(s
 	u64 mmioh_base, mmioh_end;
 	int bus_base, bus_end;
 
+	if (nr_ioh < 2)
+		return;
+
 	/* some sys doesn't get mmconf enabled */
 	if (dev->cfg_size < 0x120)
 		return;
@@ -92,3 +97,84 @@ static void __devinit pci_root_bus_res(s
 
 /* intel IOH */
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x342e, pci_root_bus_res);
+
+static void __init count_ioh(int num, int slot, int func)
+{
+	nr_ioh++;
+}
+
+struct pci_check_probe {
+	u32 vendor;
+	u32 device;
+	void (*f)(int num, int slot, int func);
+};
+
+static struct pci_check_probe early_qrk[] __initdata = {
+	{ PCI_VENDOR_ID_INTEL, 0x342e, count_ioh },
+	{}
+};
+
+static void __init early_check_pci_dev(int num, int slot, int func)
+{
+	u16 vendor;
+	u16 device;
+	int i;
+
+	vendor = read_pci_config_16(num, slot, func, PCI_VENDOR_ID);
+	device = read_pci_config_16(num, slot, func, PCI_DEVICE_ID);
+
+	for (i = 0; early_qrk[i].f != NULL; i++) {
+		if (((early_qrk[i].vendor == PCI_ANY_ID) ||
+			(early_qrk[i].vendor == vendor)) &&
+			((early_qrk[i].device == PCI_ANY_ID) ||
+			(early_qrk[i].device == device)))
+				early_qrk[i].f(num, slot, func);
+	}
+}
+
+static void __init early_check_pci_devs(void)
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
+
+				class = read_pci_config(bus, slot, func,
+							PCI_CLASS_REVISION);
+				if (class == 0xffffffff)
+					continue;
+
+				early_check_pci_dev(bus, slot, func);
+
+				if (func == 0) {
+					type = read_pci_config_byte(bus, slot,
+								    func,
+							       PCI_HEADER_TYPE);
+					if (!(type & 0x80))
+						break;
+				}
+			}
+		}
+	}
+}
+
+static int __init intel_postcore_init(void)
+{
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return 0;
+
+	early_check_pci_devs();
+
+	if (nr_ioh)
+		printk(KERN_DEBUG "pci: found %d IOH\n", nr_ioh);
+
+	return 0;
+}
+postcore_initcall(intel_postcore_init);
+
