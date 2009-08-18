Return-Path: <linux-kernel-owner+w=401wt.eu-S1751386AbZHRSSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbZHRSSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 14:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbZHRSSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 14:18:17 -0400
Received: from mail26.extendcp.co.uk ([79.170.40.26]:53491 "EHLO
	mail26.extendcp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbZHRSSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 14:18:17 -0400
Date: Tue, 18 Aug 2009 03:56:20 +0100 (BST)
From: Mark Kelly <mark@bifferos.com>
X-X-Sender: mark@cent.localnet
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch, v3] x86: CPU detection for RDC
In-Reply-To: <20090818101525.GB14374@elte.hu>
Message-ID: <alpine.LNX.2.00.0908180349550.14160@cent.localnet>
References: <20090816175204.GA28553@elte.hu> <alpine.LNX.2.00.0908160404300.20653@cent.localnet> <4A899A1D.8060808@zytor.com> <20090817180825.GA5558@elte.hu> <4A899FEA.9020707@zytor.com> <871vnas2gn.fsf@basil.nowhere.org> <4A89A724.406@zytor.com>
 <20090817213118.GA24747@one.firstfloor.org> <4A89D300.5030509@zytor.com> <alpine.LNX.2.00.0908170746040.28730@cent.localnet> <20090818101525.GB14374@elte.hu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 18 Aug 2009, Ingo Molnar wrote:

> PCI is a complex interactive Kconfig switch and we dont select it
> in x86 code. Please add a 'depends on PCI' line instead, as i
> suggested in my mail.

Here you go.  That's the only change over v2.


Signed-off-by: Mark Kelly <mark@bifferos.com>
diff --git a/Documentation/x86/rdc.txt b/Documentation/x86/rdc.txt
new file mode 100644
index 0000000..f9591af
--- /dev/null
+++ b/Documentation/x86/rdc.txt
@@ -0,0 +1,69 @@
+
+Introduction
+============
+
+RDC (http://www.rdc.com.tw) have been manufacturing x86-compatible SoC
+(system-on-chips) for a number of years.  They are not the fastest of
+CPUs (clock speeds ranging from 133-150MHz) but 486SX compatibility
+coupled with very low power consumption[1] and low cost make them ideal
+for embedded applications.
+
+
+Where to find
+=============
+
+RDC chips show up in numerous embedded devices, but be careful since
+many of them will not run Linux 2.6 without significant expertise.
+
+There are several variants of what the linux kernel refers to generically
+as RDC321X:  R8610, R321x, S3282 and AMRISC20000.
+
+R321x: Found in various routers, see the OpenWrt project for details,
+   http://wiki.openwrt.org/oldwiki/rdcport
+
+R8610: Found on the RDC evaluation board
+   http://www.ivankuten.com/system-on-chip-soc/rdc-r8610/
+
+AMRISC20000: Found in the MGB-100 wireless hard disk
+   http://tintuc.no-ip.com/linux/tipps/mgb100/
+
+S3282: Found in various NAS devices, including the Bifferboard
+   http://www.bifferos.com
+
+
+Kernel Configuration
+====================
+
+Add support for this CPU with CONFIG_X86_RDC321X.  Ensure that maths
+emulation is included (CONFIG_MATH_EMULATION selected) and avoid MCE
+(CONFIG_X86_MCE not selected).
+
+
+CPU detection
+=============
+
+None of these chips support the cpuid instruction, so as with some
+other x86 compatible SoCs, we must check the north bridge and look
+for specific 'signature' PCI device config.
+
+The current detection code has been tested only on the Bifferboard
+(S3282 CPU), please send bug reports or success stories with
+other devices to bifferos@yahoo.co.uk.
+
+
+Credits
+=======
+
+Many thanks to RDC for providing the customer codes to allow
+detection of all known variants, without which this detection code
+would have been very hard to ascertain.
+
+
+References
+==========
+
+[1] S3282 in certain NAS solutions consumes less than 1W
+
+
+mark@bifferos.com 2009
+
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1655b77..c4ebc76 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -382,6 +382,7 @@ config X86_RDC321X
 	bool "RDC R-321x SoC"
 	depends on X86_32
 	depends on X86_EXTENDED_PLATFORM
+	depends on PCI
 	select M486
 	select X86_REBOOTFIXUPS
 	---help---
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 2b03f70..75b96e9 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -122,7 +122,8 @@ struct cpuinfo_x86 {
 #define X86_VENDOR_CENTAUR	5
 #define X86_VENDOR_TRANSMETA	7
 #define X86_VENDOR_NSC		8
-#define X86_VENDOR_NUM		9
+#define X86_VENDOR_RDC		9
+#define X86_VENDOR_NUM		10

 #define X86_VENDOR_UNKNOWN	0xff

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 3efcb2b..55ba09a 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_CPU_SUP_CYRIX_32)		+= cyrix.o
 obj-$(CONFIG_CPU_SUP_CENTAUR)		+= centaur.o
 obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
 obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
+obj-$(CONFIG_X86_RDC321X)		+= rdc.o

 obj-$(CONFIG_PERF_COUNTERS)		+= perf_counter.o

diff --git a/arch/x86/kernel/cpu/rdc.c b/arch/x86/kernel/cpu/rdc.c
new file mode 100644
index 0000000..369a671
--- /dev/null
+++ b/arch/x86/kernel/cpu/rdc.c
@@ -0,0 +1,69 @@
+/*
+ * See Documentation/x86/rdc.txt
+ *
+ * mark@bifferos.com
+ */
+
+#include <linux/pci.h>
+#include <asm/pci-direct.h>
+#include "cpu.h"
+
+
+static void __cpuinit rdc_identify(struct cpuinfo_x86 *c)
+{
+	u16 vendor, device;
+	u32 customer_id;
+
+	if (!early_pci_allowed())
+		return;
+
+	/* RDC CPU is SoC (system-on-chip), Northbridge is always present */
+	vendor = read_pci_config_16(0, 0, 0, PCI_VENDOR_ID);
+	device = read_pci_config_16(0, 0, 0, PCI_DEVICE_ID);
+
+	if (vendor != PCI_VENDOR_ID_RDC || device != PCI_DEVICE_ID_RDC_R6020)
+		return;  /* not RDC */
+	/*
+	 * NB: We could go on and check other devices, e.g. r6040 NIC, but
+	 * that's probably overkill
+	 */
+
+	customer_id = read_pci_config(0, 0, 0, 0x90);
+
+	switch (customer_id) {
+		/* id names are from RDC */
+	case 0x00321000:
+		strcpy(c->x86_model_id, "R3210/R3211");
+		break;
+	case 0x00321001:
+		strcpy(c->x86_model_id, "AMITRISC20000/20010");
+		break;
+	case 0x00321002:
+		strcpy(c->x86_model_id, "R3210X/Edimax");
+		break;
+	case 0x00321003:
+		strcpy(c->x86_model_id, "R3210/Kcodes");
+		break;
+	case 0x00321004:  /* tested */
+		strcpy(c->x86_model_id, "S3282/CodeTek");
+		break;
+	case 0x00321007:
+		strcpy(c->x86_model_id, "R8610");
+		break;
+	default:
+		pr_info("RDC CPU: Unrecognised Customer ID (0x%x) please report to linux-kernel@vger.kernel.org\n", customer_id);
+		return;
+	}
+
+	strcpy(c->x86_vendor_id, "RDC");
+	c->x86_vendor = X86_VENDOR_RDC;
+}
+
+static const struct cpu_dev __cpuinitconst rdc_cpu_dev = {
+	.c_vendor	= "RDC",
+	.c_ident	= { "RDC" },
+	.c_identify	= rdc_identify,
+	.c_x86_vendor	= X86_VENDOR_RDC,
+};
+
+cpu_dev_register(rdc_cpu_dev);
