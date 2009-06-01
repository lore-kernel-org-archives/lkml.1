Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbZFAHlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbZFAHlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 03:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbZFAHlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 03:41:36 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:38073 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbZFAHle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 03:41:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=F+A1LvlnXPi/R/kUBKS1UPklQFmKFiKYiUIcEkYs3J145cu50hs4idMCmO/TizhU77
         yk6ApEY8DT7ckJoQTcmqG89dBzs37XwbjuynhBFGGtEGqIh5Wc+sVi4jJLsKkjXMJNx3
         pTjjIVprL1/V0FcrMqDHOuvolmFf6lnrHWk10=
Subject: Re: [loongson-PATCH-v1 16/27] Add Siliconmotion 712 framebuffer
 driver
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Simon Braunschmidt <sb@emlix.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
In-Reply-To: <4A1FE338.5010802@emlix.com>
References: <cover.1242855716.git.wuzhangjin@gmail.com>
	 <ad533255eec0400e4fed72671c0865472dd68d02.1242855716.git.wuzhangjin@gmail.com>
	 <4A1FE338.5010802@emlix.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Mon, 01 Jun 2009 15:41:30 +0800
Message-Id: <1243842090.5760.175.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, 

> As i have seen lots of functionality are guarded by
> #ifdef __BIG_ENDIAN
> 
> Is there a way to setup a different mode than 1024x600 on 
> kernel-commandline or from userspace, e.g. with fbset?
> 

I just removed some of #ifdef __BIG_ENDIAN ... #endif, and tuned the
vesa_mode values, now, we can pass it in kernel-commandline like this:

vga=1024x600x24

the latest SMI video driver patch with this modification will be sent
out later, but you can get this one if you need it immediately:

>From 34e4afa8b64f794e4fef0dd622ef576dbfecc851 Mon Sep 17 00:00:00 2001
From: Wu Zhangjin <wuzj@lemote.com>
Date: Mon, 1 Jun 2009 15:31:26 +0800
Subject: [PATCH] enable the vga command line in SMI video driver

there is no need to define a screen_info again so remove it, because it
is defined in arch/mips/kernel/setup.c and not relative to big endian or
little endian, and here I think its better use something like
1024x600x24 than 0x318, so replace all of the magic numbers to an
understandable one.

Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 drivers/video/smi/smtcfb.c |   42
++++++++++++++++++------------------------
 1 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/drivers/video/smi/smtcfb.c b/drivers/video/smi/smtcfb.c
index ebc6371..4fe940b 100644
--- a/drivers/video/smi/smtcfb.c
+++ b/drivers/video/smi/smtcfb.c
@@ -52,10 +52,6 @@
 #define smdbg(format, arg...)
 #endif
 
-#ifdef __BIG_ENDIAN
-struct screen_info screen_info;
-#endif
-
 /*
 * Private structure
 */
@@ -96,32 +92,32 @@ struct par_info {
 	u8 chipRevID;
 };
 
-#ifdef __BIG_ENDIAN
 struct vesa_mode_table {
-	char mode_index[6];
+	char mode_index[15];
 	u16 lfb_width;
 	u16 lfb_height;
 	u16 lfb_depth;
 };
 
 static struct vesa_mode_table vesa_mode[] = {
-	{"0x301", 640, 480, 8},
-	{"0x303", 800, 600, 8},
-	{"0x305", 1024, 768, 8},
-	{"0x307", 1280, 1024, 8},
-
-	{"0x311", 640, 480, 16},
-	{"0x314", 800, 600, 16},
-	{"0x317", 1024, 768, 16},
-	{"0x31A", 1280, 1024, 16},
-
-	{"0x312", 640, 480, 24},
-	{"0x315", 800, 600, 24},
-	{"0x318", 1024, 768, 24},
-	{"0x31B", 1280, 1024, 24},
-
+	{"640x480x8", 640, 480, 8},
+	{"800x480x8", 800, 480, 8},
+	{"800x600x8", 800, 600, 8},
+	{"1024x768x8", 1024, 768, 8},
+	{"1280x1024x8", 1280, 1024, 8},
+
+	{"640x480x16", 640, 480, 16},
+	{"800x480x16", 800, 480, 16},
+	{"800x600x16", 800, 600, 16},
+	{"1024x768x16", 1024, 768, 16},
+	{"1280x1024x16", 1280, 1024, 16},
+
+	{"640x480x24", 640, 480, 24},
+	{"800x480x24", 800, 480, 24},
+	{"800x600x24", 800, 600, 24},
+	{"1024x768x24", 1024, 768, 24},
+	{"1280x1024x24", 1280, 1024, 24},
 };
-#endif
 
 char __iomem *smtc_RegBaseAddress;	/* Memory Map IO starting address */
 char __iomem *smtc_VRAMBaseAddress;	/* video memory starting address */
@@ -1100,7 +1096,6 @@ static int __init sm712be_setup(char *options)
 
 __setup("sm712be=", sm712be_setup);
 
-#ifdef __BIG_ENDIAN
 /*
  *	sm712vga_setup - process command line options, get vga parameter
  *	@options: string of options
@@ -1136,7 +1131,6 @@ static int __init sm712vga_setup(char *options)
 }
 
 __setup("vga=", sm712vga_setup);
-#endif
 
 MODULE_AUTHOR("Siliconmotion ");
 MODULE_DESCRIPTION("Framebuffer driver for SMI Graphic Cards");
-- 
1.6.0.4


with the support of this patch, the users of 7inch yeeloong and 8.9inch
yeeloong can use the same kernel(not totally, the shutdown logic is a
little different, a patch is also ready for it).

there is only a need to add such kernel command line for 7inch yeeloong:

vga=800x480x24

> What I currently do is
> picking appropriate values form the table VGAMode in smtcfb.h and 
> hardcoding them.
> 
> I tried 800x600x16bit@60hz, which worked also, but 1024x768x24bit@60hz 
> left me with a corrupted display output (distored colors, missing 
> regions), i did not check further wheter it also crashed.
> 

no all of the Vesa mode is suitable to your screen, you should choose
one for you, for example, only 800x480 is suitable to yeeloong 7inch
screen, but the 8.9 inch yeeloong, need 1024x600.

best regards,
Wu Zhangjin

