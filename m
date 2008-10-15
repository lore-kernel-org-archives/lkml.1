Return-Path: <linux-kernel-owner+w=401wt.eu-S1753799AbYJOKwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbYJOKwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 06:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYJOKv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 06:51:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:51945 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751655AbYJOKvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 06:51:55 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+7oNwAfH67gH+tl2uucJpCvzSTDekWLxL/b2yLDw
	6x+I8SNDaVYF9W
Date: Wed, 15 Oct 2008 12:52:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: Adrian Bunk <bunk@kernel.org>,
       Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>, lethal@linux-sh.org,
       linux-sh@vger.kernel.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2] soc-camera: fix compile breakage on SH
In-Reply-To: <aec7e5c30810150155q244834c0i65b2f3b927ba2d37@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0810151247230.5361@axis700.grange>
References: <20081014183936.GB4710@cs181140183.pp.htv.fi> 
 <Pine.LNX.4.64.0810142335400.10458@axis700.grange> 
 <20081015033303.GC4710@cs181140183.pp.htv.fi>  <20081015052026.GC20183@cs181140183.pp.htv.fi>
  <aec7e5c30810142328n1563163bw636b8baf1a47ad8b@mail.gmail.com> 
 <Pine.LNX.4.64.0810150836100.3896@axis700.grange> 
 <aec7e5c30810150103p7ed810ccyc815ad578d64feac@mail.gmail.com> 
 <Pine.LNX.4.64.0810151011450.3896@axis700.grange>
 <aec7e5c30810150155q244834c0i65b2f3b927ba2d37@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix Migo-R compile breakage caused by incomplete merge. Also remove 
redundant soc_camera_platform_info struct definition from 
drivers/media/video/soc_camera_platform.c

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Tested-by: Magnus Damm <damm@igel.co.jp>

---

Paul, Mauro, as this patch closes a compile-breakage, I'd like to get it 
upstream asap. What would be the fastest way: get your both Acked-by and 
send it directly to Andrew / Linus, or an Acked-by from one of you and 
let the other one merge (you can decide who does what:-)) Splitting it 
into two patches and merging separately seems suboptimal to me in this 
case.

Thanks
Guennadi

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
 
