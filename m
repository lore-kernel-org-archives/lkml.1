Return-Path: <linux-kernel-owner+w=401wt.eu-S1758904AbZDCGOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904AbZDCGOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 02:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbZDCGNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 02:13:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:34353 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759423AbZDCGNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 02:13:38 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: norsk5@yahoo.com, bluesmoke-devel@lists.sourceforge.net,
       linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [v1 PATCH 3/3] EDAC: CPC925 MC platform device setup
Date: Fri,  3 Apr 2009 14:10:44 +0800
Message-Id: <1238739044-19926-2-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1238739044-19926-1-git-send-email-qingtao.cao@windriver.com>
References: <1238739044-19926-1-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 03 Apr 2009 06:13:24.0883 (UTC) FILETIME=[4C021630:01C9B423]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setup a platform device for the CPC925 Memory Controller during system
booting up, against which CPC925 MC EDAC driver would be matched.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
---
 arch/powerpc/platforms/maple/setup.c |   47 ++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/maple/setup.c b/arch/powerpc/platforms/maple/setup.c
index bfd60e4..ca8a3ff 100644
--- a/arch/powerpc/platforms/maple/setup.c
+++ b/arch/powerpc/platforms/maple/setup.c
@@ -335,3 +335,50 @@ define_machine(maple) {
 	.progress		= maple_progress,
 	.power_save		= power4_idle,
 };
+
+#ifdef CONFIG_EDAC
+#define CPC925_MC_START		0xf8000000
+#define CPC925_MC_END		0xf8ffffff /* sizeof 16MB */
+/* Register a platform device for CPC925 memory controller */
+static int __init maple_cpc925_edac_setup(void)
+{
+	struct platform_device *pdev;
+	struct device_node *np = NULL;
+	struct resource r;
+
+	np = of_find_node_by_name(NULL, "hostbridge");
+	if (!np) {
+		printk(KERN_ERR "%s: Unable to find hostbridge node\n",
+			__func__);
+		return -ENODEV;
+	}
+
+	if (of_address_to_resource(np, 0, &r)) {
+		/*
+		 * of_address_to_resource() would get the #address-cells
+		 * and #size-cells properties for a node from its parent.
+		 * On Maple 64bit target hostbridge parent node has specified
+		 * both of these two properties to be 2. However, the actual
+		 * "cell" value for host bridge node is 1. Since we can't
+		 * fix this firmware-generated DTB, we have to setup a
+		 * resource structure manually.
+		 */
+		memset(&r, 0, sizeof(r));
+		r.start = CPC925_MC_START;
+		r.end = CPC925_MC_END;
+		r.name = "hostbridge";
+		r.flags = IORESOURCE_MEM;
+	}
+
+	of_node_put(np);
+
+	pdev = platform_device_register_simple("cpc925_edac", 0, &r, 1);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
+	printk(KERN_INFO "%s: CPC925 platform device created\n", __func__);
+
+	return 0;
+}
+arch_initcall(maple_cpc925_edac_setup);
+#endif
-- 
1.5.6.2

