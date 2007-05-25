Return-Path: <linux-kernel-owner+w=401wt.eu-S1761053AbXEYIiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761053AbXEYIiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbXEYIhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:37:33 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:40496 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758432AbXEYIha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:37:30 -0400
Message-Id: <20070525083632.177254000@sonycom.com>
References: <20070525083607.784351000@sonycom.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 May 2007 10:36:08 +0200
From: Geert.Uytterhoeven@sonycom.com
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: [patch 1/7] ps3: Preallocate bootmem memory for the PS3 FLASH ROM storage driver
Content-Disposition: inline; filename=ps3stor_flash_bootmem.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Preallocate 256 KiB of bootmem memory for the PS3 FLASH ROM storage driver.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
---
 arch/powerpc/platforms/ps3/setup.c |   19 ++++++++++++++++++-
 include/asm-powerpc/ps3.h          |    1 +
 2 files changed, 19 insertions(+), 1 deletion(-)

--- a/arch/powerpc/platforms/ps3/setup.c
+++ b/arch/powerpc/platforms/ps3/setup.c
@@ -99,7 +99,8 @@ static void ps3_panic(char *str)
 	while(1);
 }
 
-#if defined(CONFIG_FB_PS3) || defined(CONFIG_FB_PS3_MODULE)
+#if defined(CONFIG_FB_PS3) || defined(CONFIG_FB_PS3_MODULE) || \
+    defined(CONFIG_PS3_FLASH_MODULE) || defined(CONFIG_PS3_FLASH_MODULE)
 static void prealloc(struct ps3_prealloc *p)
 {
 	if (!p->size)
@@ -115,7 +116,9 @@ static void prealloc(struct ps3_prealloc
 	printk(KERN_INFO "%s: %lu bytes at %p\n", p->name, p->size,
 	       p->address);
 }
+#endif
 
+#if defined(CONFIG_FB_PS3) || defined(CONFIG_FB_PS3_MODULE)
 struct ps3_prealloc ps3fb_videomemory = {
 	.name = "ps3fb videomemory",
 	.size = CONFIG_FB_PS3_DEFAULT_SIZE_M*1024*1024,
@@ -138,6 +141,18 @@ early_param("ps3fb", early_parse_ps3fb);
 #define prealloc_ps3fb_videomemory()	do { } while (0)
 #endif
 
+#if defined(CONFIG_PS3_FLASH) || defined(CONFIG_PS3_FLASH_MODULE)
+struct ps3_prealloc ps3flash_bounce_buffer = {
+	.name = "ps3flash bounce buffer",
+	.size = 256*1024,
+	.align = 256*1024
+};
+EXPORT_SYMBOL_GPL(ps3flash_bounce_buffer);
+#define prealloc_ps3flash_bounce_buffer()	prealloc(&ps3flash_bounce_buffer)
+#else
+#define prealloc_ps3flash_bounce_buffer()	do { } while (0)
+#endif
+
 static int ps3_set_dabr(u64 dabr)
 {
 	enum {DABR_USER = 1, DABR_KERNEL = 2,};
@@ -167,6 +182,8 @@ static void __init ps3_setup_arch(void)
 #endif
 
 	prealloc_ps3fb_videomemory();
+	prealloc_ps3flash_bounce_buffer();
+
 	ppc_md.power_save = ps3_power_save;
 
 	DBG(" <- %s:%d\n", __func__, __LINE__);
--- a/include/asm-powerpc/ps3.h
+++ b/include/asm-powerpc/ps3.h
@@ -442,6 +442,7 @@ struct ps3_prealloc {
 };
 
 extern struct ps3_prealloc ps3fb_videomemory;
+extern struct ps3_prealloc ps3flash_bounce_buffer;
 
 
 #endif

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium

