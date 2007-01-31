Return-Path: <linux-kernel-owner+w=401wt.eu-S933200AbXAaMqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200AbXAaMqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 07:46:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933201AbXAaMo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 07:44:26 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:41278 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933199AbXAaMoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 07:44:20 -0500
Date: Wed, 31 Jan 2007 13:44:19 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: James Simmons <jsimmons@infradead.org>
cc: Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] Cell: Draw SPE helper penguin logos
In-Reply-To: <Pine.LNX.4.62.0701311325480.14996@pademelon.sonytel.be>
Message-ID: <Pine.LNX.4.62.0701311341480.15066@pademelon.sonytel.be>
References: <Pine.LNX.4.62.0701311325480.14996@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Let spu_management_ops.enumerate_spus() return the number of found SPEs
and use that information to draw some little helper penguin logos.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
---
 arch/powerpc/platforms/cell/spu_base.c       |    7 +++++--
 arch/powerpc/platforms/cell/spu_priv1_mmio.c |    4 +++-
 arch/powerpc/platforms/ps3/spu.c             |    6 ++++--
 3 files changed, 12 insertions(+), 5 deletions(-)

--- ps3-linux-2.6.20-rc7.orig/arch/powerpc/platforms/cell/spu_base.c
+++ ps3-linux-2.6.20-rc7/arch/powerpc/platforms/cell/spu_base.c
@@ -31,6 +31,7 @@
 #include <linux/mm.h>
 #include <linux/io.h>
 #include <linux/mutex.h>
+#include <linux/linux_logo.h>
 #include <asm/spu.h>
 #include <asm/spu_priv1.h>
 #include <asm/xmon.h>
@@ -676,16 +677,18 @@ static int __init init_spu_base(void)
 
 	ret = spu_enumerate_spus(create_spu);
 
-	if (ret) {
+	if (ret < 0) {
 		printk(KERN_WARNING "%s: Error initializing spus\n",
 			__FUNCTION__);
 		cleanup_spu_base();
 		return ret;
 	}
+	if (ret > 0)
+		fb_append_extra_logo(&logo_spe_clut224, ret);
 
 	xmon_register_spus(&spu_full_list);
 
-	return ret;
+	return 0;
 }
 module_init(init_spu_base);
 
--- ps3-linux-2.6.20-rc7.orig/arch/powerpc/platforms/cell/spu_priv1_mmio.c
+++ ps3-linux-2.6.20-rc7/arch/powerpc/platforms/cell/spu_priv1_mmio.c
@@ -331,6 +331,7 @@ static int __init of_enumerate_spus(int 
 {
 	int ret;
 	struct device_node *node;
+	unsigned int n = 0;
 
 	ret = -ENODEV;
 	for (node = of_find_node_by_type(NULL, "spe");
@@ -341,8 +342,9 @@ static int __init of_enumerate_spus(int 
 				__FUNCTION__, node->name);
 			break;
 		}
+		n++;
 	}
-	return ret;
+	return ret ? ret : n;
 }
 
 static int __init of_create_spu(struct spu *spu, void *data)
--- ps3-linux-2.6.20-rc7.orig/arch/powerpc/platforms/ps3/spu.c
+++ ps3-linux-2.6.20-rc7/arch/powerpc/platforms/ps3/spu.c
@@ -438,11 +438,13 @@ static int __init ps3_enumerate_spus(int
 		}
 	}
 
-	if (result)
+	if (result) {
 		printk(KERN_WARNING "%s:%d: Error initializing spus\n",
 			__func__, __LINE__);
+		return result;
+	}
 
-	return result;
+	return num_resource_id;
 }
 
 const struct spu_management_ops spu_management_ps3_ops = {

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
