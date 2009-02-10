Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbZBJCBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbZBJCBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 21:01:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbZBJCBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 21:01:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:37006 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbZBJCBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 21:01:01 -0500
Message-ID: <4990DFBA.1050401@kernel.org>
Date: Mon, 09 Feb 2009 18:00:26 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: jbarnes@virtuousgeek.org
CC: Ingo Molnar <mingo@elte.hu>, Ed Swierk <eswierk@aristanetworks.com>,
       hpa@zytor.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Subject: [PATCH] x86/pci: Detect mmconfig on nVidia MCP55 -v2
References: <1233765552.16414.6.camel@localhost.localdomain> <86802c440902041212q51f2a444l84e1ac29ee6f702e@mail.gmail.com> <20090204212517.GM22608@elte.hu> <498A206A.2070309@kernel.org> <4990DF7C.1090701@kernel.org>
In-Reply-To: <4990DF7C.1090701@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ed Swierk <eswierk@aristanetworks.com>

Detect and enable memory-mapped PCI configuration space on the nVidia
MCP55 southbridge.  Tested against 2.6.27.4 on an Arista Networks
development board with one MCP55, Coreboot firmware, no ACPI.

v2: add multi mcp55 support, and conexist with amd quad core system by Yinghai
    also only enable it only when acpi=off or acpi is not built-in

Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/mmconfig-shared.c |   64 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
+++ linux-2.6/arch/x86/pci/mmconfig-shared.c
@@ -166,6 +166,68 @@ static const char __init *pci_mmcfg_amd_
 	return "AMD Family 10h NB";
 }
 
+static bool __initdata mcp55_checked;
+static const char __init *pci_mmcfg_nvidia_mcp55(void)
+{
+	int bus;
+	int mcp55_mmconf_found = 0;
+
+	static const u32 extcfg_regnum		= 0x90;
+	static const u32 extcfg_regsize		= 4;
+	static const u32 extcfg_enable_mask	= 1<<31;
+	static const u32 extcfg_start_mask	= 0xff<<16;
+	static const int extcfg_start_shift	= 16;
+	static const u32 extcfg_size_mask	= 0x3<<28;
+	static const int extcfg_size_shift	= 28;
+	static const int extcfg_sizebus[]	= {0x100, 0x80, 0x40, 0x20};
+	static const u32 extcfg_base_mask[]	= {0x7ff8, 0x7ffc, 0x7ffe, 0x7fff};
+	static const int extcfg_base_lshift	= 25;
+
+	/*
+	 * do check if amd fam10h already took over
+	 */
+	if (!acpi_disabled || pci_mmcfg_config_num || mcp55_checked)
+		return NULL;
+
+	mcp55_checked = true;
+	for (bus = 0; bus < 256; bus++) {
+		u64 base;
+		u32 l, extcfg;
+		u16 vendor, device;
+		int start, size_index, end;
+
+		raw_pci_ops->read(0, bus, PCI_DEVFN(0, 0), 0, 4, &l);
+		vendor = l & 0xffff;
+		device = (l >> 16) & 0xffff;
+
+		if (PCI_VENDOR_ID_NVIDIA != vendor || 0x0369 != device)
+			continue;
+
+		raw_pci_ops->read(0, bus, PCI_DEVFN(0, 0), extcfg_regnum,
+				  extcfg_regsize, &extcfg);
+
+		if (!(extcfg & extcfg_enable_mask))
+			continue;
+
+		if (extend_mmcfg(1) == -1)
+			continue;
+
+		size_index = (extcfg & extcfg_size_mask) >> extcfg_size_shift;
+		base = extcfg & extcfg_base_mask[size_index];
+		/* base could > 4G */
+		base <<= extcfg_base_lshift;
+		start = (extcfg & extcfg_start_mask) >> extcfg_start_shift;
+		end = start + extcfg_sizebus[size_index] - 1;
+		fill_one_mmcfg(base, 0, start, end);
+		mcp55_mmconf_found++;
+	}
+
+	if (!mcp55_mmconf_found)
+		return NULL;
+
+	return "nVidia MCP55";
+}
+
 struct pci_mmcfg_hostbridge_probe {
 	u32 bus;
 	u32 devfn;
@@ -183,6 +245,8 @@ static struct pci_mmcfg_hostbridge_probe
 	  0x1200, pci_mmcfg_amd_fam10h },
 	{ 0xff, PCI_DEVFN(0, 0), PCI_VENDOR_ID_AMD,
 	  0x1200, pci_mmcfg_amd_fam10h },
+	{ 0, PCI_DEVFN(0, 0), PCI_VENDOR_ID_NVIDIA,
+	  0x0369, pci_mmcfg_nvidia_mcp55 },
 };
 
 static int __init cmp_mmcfg(const void *x1, const void *x2)
