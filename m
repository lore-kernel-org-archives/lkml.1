Return-Path: <linux-kernel-owner+w=401wt.eu-S1751311AbXCYO5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbXCYO5v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 10:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbXCYO5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 10:57:51 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34027 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751234AbXCYO5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 10:57:38 -0400
Date: Sun, 25 Mar 2007 16:57:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/media/video/cpia_pp.c: convert to module_{init,exit}
Message-ID: <20070325145742.GF16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After looking at a section bug (in the non-modular case, clearly 
non-init code referenced the __initdata parport_nr[]), I thought it was 
time to convert this driver to module_{init,exit}.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/media/video/cpia_pp.c |   46 ++++------------------------------
 1 file changed, 6 insertions(+), 40 deletions(-)

--- linux-2.6.21-rc4-mm1/drivers/media/video/cpia_pp.c.old	2007-03-24 23:35:19.000000000 +0100
+++ linux-2.6.21-rc4-mm1/drivers/media/video/cpia_pp.c	2007-03-25 00:00:16.000000000 +0100
@@ -62,7 +62,6 @@
 #define PPCPIA_PARPORT_OFF -2
 #define PPCPIA_PARPORT_NONE -1
 
-#ifdef MODULE
 static int parport_nr[PARPORT_MAX] = {[0 ... PARPORT_MAX - 1] = PPCPIA_PARPORT_UNSPEC};
 static char *parport[PARPORT_MAX] = {NULL,};
 
@@ -72,11 +71,6 @@
 
 module_param_array(parport, charp, NULL, 0);
 MODULE_PARM_DESC(parport, "'auto' or a list of parallel port numbers. Just like lp.");
-#else
-static int parport_nr[PARPORT_MAX] __initdata =
-	{[0 ... PARPORT_MAX - 1] = PPCPIA_PARPORT_UNSPEC};
-static int parport_ptr = 0;
-#endif
 
 struct pp_cam_entry {
 	struct pardevice *pdev;
@@ -819,7 +813,7 @@
 	.detach = cpia_pp_detach,
 };
 
-static int cpia_pp_init(void)
+static int __init cpia_pp_init(void)
 {
 	printk(KERN_INFO "%s v%d.%d.%d\n",ABOUT,
 	       CPIA_PP_MAJ_VER,CPIA_PP_MIN_VER,CPIA_PP_PATCH_VER);
@@ -838,8 +832,7 @@
 	return 0;
 }
 
-#ifdef MODULE
-int init_module(void)
+static int __init cpia_init(void)
 {
 	if (parport[0]) {
 		/* The user gave some parameters.  Let's see what they were. */
@@ -866,38 +859,11 @@
 	return cpia_pp_init();
 }
 
-void cleanup_module(void)
+static void __exit cpia_cleanup(void)
 {
-	parport_unregister_driver (&cpia_pp_driver);
+	parport_unregister_driver(&cpia_pp_driver);
 	return;
 }
 
-#else /* !MODULE */
-
-static int __init cpia_pp_setup(char *str)
-{
-	int err;
-
-	if (!strncmp(str, "parport", 7)) {
-		int n = simple_strtoul(str + 7, NULL, 10);
-		if (parport_ptr < PARPORT_MAX) {
-			parport_nr[parport_ptr++] = n;
-		} else {
-			LOG("too many ports, %s ignored.\n", str);
-		}
-	} else if (!strcmp(str, "auto")) {
-		parport_nr[0] = PPCPIA_PARPORT_AUTO;
-	} else if (!strcmp(str, "none")) {
-		parport_nr[parport_ptr++] = PPCPIA_PARPORT_NONE;
-	}
-
-	err=cpia_pp_init();
-	if (err)
-		return err;
-
-	return 1;
-}
-
-__setup("cpia_pp=", cpia_pp_setup);
-
-#endif /* !MODULE */
+module_init(cpia_init);
+module_exit(cpia_cleanup);

