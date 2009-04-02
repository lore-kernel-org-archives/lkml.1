Return-Path: <linux-kernel-owner+w=401wt.eu-S935321AbZDBGMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935321AbZDBGMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934442AbZDBGJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:09:53 -0400
Received: from mail.windriver.com ([147.11.1.11]:41553 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439AbZDBGJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:09:51 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: norsk5@yahoo.com
Cc: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
Subject: [v0 PATCH 5/5] EDAC: CPC925 MC platform device setup
Date: Thu,  2 Apr 2009 14:07:20 +0800
Message-Id: <1238652440-9224-6-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1238652440-9224-5-git-send-email-qingtao.cao@windriver.com>
References: <1238652440-9224-1-git-send-email-qingtao.cao@windriver.com>
 <1238652440-9224-2-git-send-email-qingtao.cao@windriver.com>
 <1238652440-9224-3-git-send-email-qingtao.cao@windriver.com>
 <1238652440-9224-4-git-send-email-qingtao.cao@windriver.com>
 <1238652440-9224-5-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 02 Apr 2009 06:09:48.0571 (UTC) FILETIME=[A0A9BEB0:01C9B359]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setup a platform device for the CPC925 Memory Controller during system
booting up, against which CPC925 MC EDAC driver would be matched.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
---
 arch/powerpc/platforms/maple/setup.c |   47 +++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

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
