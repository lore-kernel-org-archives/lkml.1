Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744AbYJOGll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbYJOGll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 02:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYJOGlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 02:41:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:46449 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751024AbYJOGlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 02:41:31 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18L/dYCVwMLLVEQb7T4QKa/+kDvmBUEheO3wh7uRZ
	+kMXzK21byvzez
Date: Wed, 15 Oct 2008 08:41:31 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: Adrian Bunk <bunk@kernel.org>,
       Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>, lethal@linux-sh.org,
       linux-sh@vger.kernel.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Magnus Damm <damm@igel.co.jp>
Subject: Re: [PATCH] soc-camera: fix compile breakage on SH
In-Reply-To: <aec7e5c30810142328n1563163bw636b8baf1a47ad8b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0810150836100.3896@axis700.grange>
References: <20081014183936.GB4710@cs181140183.pp.htv.fi> 
 <Pine.LNX.4.64.0810142335400.10458@axis700.grange> 
 <20081015033303.GC4710@cs181140183.pp.htv.fi>  <20081015052026.GC20183@cs181140183.pp.htv.fi>
 <aec7e5c30810142328n1563163bw636b8baf1a47ad8b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus

On Wed, 15 Oct 2008, Magnus Damm wrote:

> Thanks for working on fixing the breakage. I'd prefer to wait a bit
> since there are quite a few pinmux patches queued up that may break if
> we merge a fix right now. I can fix it up later on.

no, I would not leave the kernel in a non-compilable state even if just 
for one board. Please, test a new version of the patch below. And yes, You 
will have to rebase your patches, sorry. Another thing, could you also, 
please, add a license / copyright header to 
include/media/soc_camera_platform.h?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v2] soc-camera: fix compile breakage on SH

Fix Migo-R compile breakage caused by incomplete merge. Also remove 
redundant soc_camera_platform_info struct definition from 
drivers/media/video/soc_camera_platform.c

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

---

diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index 714dce9..95459f3 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -312,6 +312,14 @@ static void camera_power_off(void)
 	ctrl_outb(ctrl_inb(PORT_PTDR) & ~0x08, PORT_PTDR);
 }
 
+static void camera_power(int mode)
+{
+	if (mode)
+		camera_power_on();
+	else
+		camera_power_off();
+}
+
 #ifdef CONFIG_I2C
 static unsigned char camera_ov772x_magic[] =
 {
@@ -391,6 +399,7 @@ static struct soc_camera_platform_info ov772x_info = {
 	},
 	.bus_param =  SOCAM_PCLK_SAMPLE_RISING | SOCAM_HSYNC_ACTIVE_HIGH |
 	SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_MASTER | SOCAM_DATAWIDTH_8,
+	.power = camera_power,
 	.set_capture = ov772x_set_capture,
 };
 
@@ -405,8 +414,6 @@ static struct platform_device migor_camera_device = {
 static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
 	.flags = SOCAM_MASTER | SOCAM_DATAWIDTH_8 | SOCAM_PCLK_SAMPLE_RISING \
 	| SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH,
-	.enable_camera = camera_power_on,
-	.disable_camera = camera_power_off,
 };
 
 static struct resource migor_ceu_resources[] = {
diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
index 1adc257..bb7a9d4 100644
--- a/drivers/media/video/soc_camera_platform.c
+++ b/drivers/media/video/soc_camera_platform.c
@@ -18,15 +18,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <media/soc_camera.h>
-
-struct soc_camera_platform_info {
-	int iface;
-	char *format_name;
-	unsigned long format_depth;
-	struct v4l2_pix_format format;
-	unsigned long bus_param;
-	int (*set_capture)(struct soc_camera_platform_info *info, int enable);
-};
+#include <media/soc_camera_platform.h>
 
 struct soc_camera_platform_priv {
 	struct soc_camera_platform_info *info;
@@ -44,11 +36,21 @@ soc_camera_platform_get_info(struct soc_camera_device *icd)
 
 static int soc_camera_platform_init(struct soc_camera_device *icd)
 {
+	struct soc_camera_platform_info *p = soc_camera_platform_get_info(icd);
+
+	if (p->power)
+		p->power(1);
+
 	return 0;
 }
 
 static int soc_camera_platform_release(struct soc_camera_device *icd)
 {
+	struct soc_camera_platform_info *p = soc_camera_platform_get_info(icd);
+
+	if (p->power)
+		p->power(0);
+
 	return 0;
 }
 
diff --git a/include/media/soc_camera_platform.h b/include/media/soc_camera_platform.h
index 851f182..7c81ad3 100644
--- a/include/media/soc_camera_platform.h
+++ b/include/media/soc_camera_platform.h
@@ -9,6 +9,7 @@ struct soc_camera_platform_info {
 	unsigned long format_depth;
 	struct v4l2_pix_format format;
 	unsigned long bus_param;
+	void (*power)(int);
 	int (*set_capture)(struct soc_camera_platform_info *info, int enable);
 };
 
