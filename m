Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbXGJMhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbXGJMhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 08:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbXGJMg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 08:36:26 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:38401 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752831AbXGJMgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 08:36:22 -0400
Message-Id: <20070710123540.877411000@pademelon.sonytel.be>
References: <20070710122702.765654000@pademelon.sonytel.be>
User-Agent: quilt/0.46-1
Date: Tue, 10 Jul 2007 14:27:06 +0200
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, James Simmons <jsimmons@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net, cbe-oss-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: [patch 4/4] Cell: Draw SPE helper penguin logos
Content-Disposition: inline; filename=spe-logo/logo-extra-spe-glue-2.6.21.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Let spu_management_ops.enumerate_spus() return the number of found SPEs
and use that information to draw some little helper penguin logos.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Acked-By: James Simmons <jsimmons@infradead.org>
---
 arch/powerpc/platforms/cell/spu_base.c   |   15 ++++++++++++++-
 arch/powerpc/platforms/cell/spu_manage.c |    4 +++-
 arch/powerpc/platforms/ps3/spu.c         |    6 ++++--
 3 files changed, 21 insertions(+), 4 deletions(-)

--- a/arch/powerpc/platforms/cell/spu_base.c
+++ b/arch/powerpc/platforms/cell/spu_base.c
@@ -31,6 +31,7 @@
 #include <linux/mm.h>
 #include <linux/io.h>
 #include <linux/mutex.h>
+#include <linux/linux_logo.h>
 #include <asm/spu.h>
 #include <asm/spu_priv1.h>
 #include <asm/xmon.h>
@@ -603,12 +604,24 @@ static int __init init_spu_base(void)
 
 	ret = spu_enumerate_spus(create_spu);
 
-	if (ret) {
+	if (ret < 0) {
 		printk(KERN_WARNING "%s: Error initializing spus\n",
 			__FUNCTION__);
 		goto out_unregister_sysdev_class;
 	}
 
+	if (ret > 0) {
+		/*
+		 * We cannot put the forward declaration in
+		 * <linux/linux_logo.h> because of conflicting session type
+		 * conflicts for const and __initdata with different compiler
+		 * versions
+		 */
+		extern const struct linux_logo logo_spe_clut224;
+
+		fb_append_extra_logo(&logo_spe_clut224, ret);
+	}
+
 	xmon_register_spus(&spu_full_list);
 
 	return 0;
--- a/arch/powerpc/platforms/cell/spu_manage.c
+++ b/arch/powerpc/platforms/cell/spu_manage.c
@@ -279,6 +279,7 @@ static int __init of_enumerate_spus(int 
 {
 	int ret;
 	struct device_node *node;
+	unsigned int n = 0;
 
 	ret = -ENODEV;
 	for (node = of_find_node_by_type(NULL, "spe");
@@ -289,8 +290,9 @@ static int __init of_enumerate_spus(int 
 				__FUNCTION__, node->name);
 			break;
 		}
+		n++;
 	}
-	return ret;
+	return ret ? ret : n;
 }
 
 static int __init of_create_spu(struct spu *spu, void *data)
--- a/arch/powerpc/platforms/ps3/spu.c
+++ b/arch/powerpc/platforms/ps3/spu.c
@@ -400,11 +400,13 @@ static int __init ps3_enumerate_spus(int
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

-- 
With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619

