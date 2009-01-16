Return-Path: <linux-kernel-owner+w=401wt.eu-S1761958AbZAPIa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761958AbZAPIa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761858AbZAPI1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:27:50 -0500
Received: from smtp.nokia.com ([192.100.105.134]:28179 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761871AbZAPI1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:27:47 -0500
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [PATCH 06/10] omap mailbox: fix empty struct device for omap2
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org
Date: Fri, 16 Jan 2009 10:27:32 +0200
Message-ID: <20090116082732.17571.30232.stgit@oreo.research.nokia.com>
In-Reply-To: <20090116081919.17571.34378.stgit@oreo.research.nokia.com>
References: <20090116081919.17571.34378.stgit@oreo.research.nokia.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 08:27:33.0815 (UTC) FILETIME=[47BCE470:01C977B4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---

 arch/arm/mach-omap2/devices.c |    2 +-
 arch/arm/mach-omap2/mailbox.c |   15 +++++++++------
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 05baccd..698dd13 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -61,7 +61,7 @@ static struct resource omap3_mbox_resources[] = {
 };
 
 static struct platform_device mbox_device = {
-	.name		= "mailbox",
+	.name		= "omap2-mailbox",
 	.id		= -1,
 };
 
diff --git a/arch/arm/mach-omap2/mailbox.c b/arch/arm/mach-omap2/mailbox.c
index c73fa89..a877305 100644
--- a/arch/arm/mach-omap2/mailbox.c
+++ b/arch/arm/mach-omap2/mailbox.c
@@ -18,6 +18,8 @@
 #include <mach/mailbox.h>
 #include <mach/irqs.h>
 
+#define DRV_NAME "omap2-mailbox"
+
 #define MAILBOX_REVISION		0x000
 #define MAILBOX_SYSCONFIG		0x010
 #define MAILBOX_SYSSTATUS		0x014
@@ -234,7 +236,7 @@ static struct omap_mbox mbox_iva_info = {
 };
 #endif
 
-static int __init omap2_mbox_probe(struct platform_device *pdev)
+static int __devinit omap2_mbox_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	int ret;
@@ -258,7 +260,7 @@ static int __init omap2_mbox_probe(struct platform_device *pdev)
 	}
 	mbox_dsp_info.irq = res->start;
 
-	ret = omap_mbox_register(&mbox_dsp_info);
+	ret = omap_mbox_register(&pdev->dev, &mbox_dsp_info);
 	if (ret)
 		goto err_dsp;
 
@@ -272,7 +274,7 @@ static int __init omap2_mbox_probe(struct platform_device *pdev)
 			goto err_iva1;
 		}
 		mbox_iva_info.irq = res->start;
-		ret = omap_mbox_register(&mbox_iva_info);
+		ret = omap_mbox_register(&pdev->dev, &mbox_iva_info);
 		if (ret)
 			goto err_iva1;
 	}
@@ -286,7 +288,7 @@ err_dsp:
 	return ret;
 }
 
-static int omap2_mbox_remove(struct platform_device *pdev)
+static int __devexit omap2_mbox_remove(struct platform_device *pdev)
 {
 #if defined(CONFIG_ARCH_OMAP2420)
 	omap_mbox_unregister(&mbox_iva_info);
@@ -298,9 +300,9 @@ static int omap2_mbox_remove(struct platform_device *pdev)
 
 static struct platform_driver omap2_mbox_driver = {
 	.probe = omap2_mbox_probe,
-	.remove = omap2_mbox_remove,
+	.remove = __devexit_p(omap2_mbox_remove),
 	.driver = {
-		.name = "mailbox",
+		.name = DRV_NAME,
 	},
 };
 
@@ -320,3 +322,4 @@ module_exit(omap2_mbox_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("omap mailbox: omap2/3 architecture specific functions");
 MODULE_AUTHOR("Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, Paul Mundt");
+MODULE_ALIAS("platform:"DRV_NAME);

