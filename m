Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856AbZDPFwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbZDPFwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 01:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbZDPFv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 01:51:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:63034 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbZDPFv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 01:51:58 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: akpm@linux-foundation.org, michael@ellerman.id.au, galak@gate.crashing.org,
       bluesmoke-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org, Harry Ciao <qingtao.cao@windriver.com>
Subject: [v3 PATCH 3/3] EDAC: CPC925 MC platform device setup
Date: Thu, 16 Apr 2009 13:51:03 +0800
Message-Id: <1239861063-22837-2-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239861063-22837-1-git-send-email-qingtao.cao@windriver.com>
References: <>
 <1239861063-22837-1-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 16 Apr 2009 05:51:04.0547 (UTC) FILETIME=[5479CB30:01C9BE57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixup the number of cells for the values of CPC925 Memory Controller,
and setup related platform device during system booting up, against 
which CPC925 Memory Controller EDAC driver would be matched.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
---
 arch/powerpc/kernel/prom_init.c      |   40 +++++++++++++++++++++++
 arch/powerpc/platforms/maple/setup.c |   59 +++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+)

--- a/arch/powerpc/platforms/maple/setup.c
+++ b/arch/powerpc/platforms/maple/setup.c
@@ -335,3 +335,62 @@ define_machine(maple) {
 	.progress		= maple_progress,
 	.power_save		= power4_idle,
 };
+
+#ifdef CONFIG_EDAC
+/*
+ * Register a platform device for CPC925 memory controller on
+ * Motorola ATCA-6101 blade.
+ */
+#define MAPLE_CPC925_MODEL	"Motorola,ATCA-6101"
+static int __init maple_cpc925_edac_setup(void)
+{
+	struct platform_device *pdev;
+	struct device_node *np = NULL;
+	struct resource r;
+	const unsigned char *model;
+	int ret;
+
+	np = of_find_node_by_path("/");
+	if (!np) {
+		printk(KERN_ERR "%s: Unable to get root node\n", __func__);
+		return -ENODEV;
+	}
+
+	model = (const unsigned char *)of_get_property(np, "model", NULL);
+	if (!model) {
+		printk(KERN_ERR "%s: Unabel to get model info\n", __func__);
+		return -ENODEV;
+	}
+
+	ret = strcmp(model, MAPLE_CPC925_MODEL);
+	of_node_put(np);
+
+	if (ret != 0)
+		return 0;
+
+	np = of_find_node_by_type(NULL, "memory-controller");
+	if (!np) {
+		printk(KERN_ERR "%s: Unable to find memory-controller node\n",
+			__func__);
+		return -ENODEV;
+	}
+
+	ret = of_address_to_resource(np, 0, &r);
+	of_node_put(np);
+
+	if (ret < 0) {
+		printk(KERN_ERR "%s: Unable to get memory-controller reg\n",
+			__func__);
+		return -ENODEV;
+	}
+
+	pdev = platform_device_register_simple("cpc925_edac", 0, &r, 1);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
+	printk(KERN_INFO "%s: CPC925 platform device created\n", __func__);
+
+	return 0;
+}
+machine_device_initcall(maple, maple_cpc925_edac_setup);
+#endif
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -1948,8 +1948,47 @@ static void __init fixup_device_tree_map
 	prom_setprop(isa, name, "ranges",
 			isa_ranges, sizeof(isa_ranges));
 }
+
+#define CPC925_MC_START		0xf8000000
+#define CPC925_MC_LENGTH	0x1000000
+/* The values for memory-controller don't have right number of cells */
+static void __init fixup_device_tree_maple_memory_controller(void)
+{
+	phandle mc;
+	u32 mc_reg[4];
+	char *name = "/hostbridge@f8000000";
+	struct prom_t *_prom = &RELOC(prom);
+	u32 ac, sc;
+
+	mc = call_prom("finddevice", 1, 1, ADDR(name));
+	if (!PHANDLE_VALID(mc))
+		return;
+
+	if (prom_getproplen(mc, "reg") != 8)
+		return;
+
+	prom_getprop(_prom->root, "#address-cells", &ac, sizeof(ac));
+	prom_getprop(_prom->root, "#size-cells", &sc, sizeof(sc));
+	if ((ac != 2) || (sc != 2))
+		return;
+
+	if (prom_getprop(mc, "reg", mc_reg, sizeof(mc_reg)) == PROM_ERROR)
+		return;
+
+	if (mc_reg[0] != CPC925_MC_START || mc_reg[1] != CPC925_MC_LENGTH)
+		return;
+
+	prom_printf("Fixing up bogus hostbridge on Maple...\n");
+
+	mc_reg[0] = 0x0;
+	mc_reg[1] = CPC925_MC_START;
+	mc_reg[2] = 0x0;
+	mc_reg[3] = CPC925_MC_LENGTH;
+	prom_setprop(mc, name, "reg", mc_reg, sizeof(mc_reg));
+}
 #else
 #define fixup_device_tree_maple()
+#define fixup_device_tree_maple_memory_controller()
 #endif
 
 #ifdef CONFIG_PPC_CHRP
@@ -2190,6 +2229,7 @@ static void __init fixup_device_tree_efi
 static void __init fixup_device_tree(void)
 {
 	fixup_device_tree_maple();
+	fixup_device_tree_maple_memory_controller();
 	fixup_device_tree_chrp();
 	fixup_device_tree_pmac();
 	fixup_device_tree_efika();
