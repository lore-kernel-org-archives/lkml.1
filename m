Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbYHIS5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbYHIS5q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 14:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbYHIS5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 14:57:39 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:46481 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYHIS5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 14:57:38 -0400
Message-ID: <489DE890.1090103@keyaccess.nl>
Date: Sat, 09 Aug 2008 20:57:20 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       video4linux-list@redhat.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] V4L1: make PMS not auto-grab port 0x250
Content-Type: multipart/mixed;
 boundary="------------080101030105050108050407"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080101030105050108050407
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrew.

Stop Randomising Ingo's Breakconfig Builds, Part III.

Rene

--------------080101030105050108050407
Content-Type: text/plain;
 name="0001-V4L1-make-PMS-not-auto-grab-port-0x250.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-V4L1-make-PMS-not-auto-grab-port-0x250.patch"

>From cb369dfe174a66bd4d815950c23c1d30234ea8d2 Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Sat, 9 Aug 2008 20:39:19 +0200
Subject: [PATCH] V4L1: make PMS not auto-grab port 0x250

Grabbing ISA bus resources without anything or anyone telling us we
should can break boot on randconfig/allyesconfig builds by keeping
resources that are in fact owned by different hardware busy and does
as reported by Ingo Molnar.

Generally it's also dangerous to just poke at random I/O ports and
especially those in the range where other old easily confused ISA
hardware might live.

This specific V4L1 driver does probe for its hardware and releases
resources when not found but was still found to hang the boot when
booting a randconfig kernel. Just insist that the user specify the
port before going ahead and poking at it.

Users of this driver are nonexistent and/or a one time

echo "options pms io_port=0x250" >> /etc/modprobe.conf

away from the old behaviour.

This is a deprecated driver but as long as it's in the tree, might
as well fix it I guess.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
---
 drivers/media/video/pms.c |   77 +++++++++++++++++++++++++++++---------------
 1 files changed, 51 insertions(+), 26 deletions(-)

diff --git a/drivers/media/video/pms.c b/drivers/media/video/pms.c
index 00425d7..ce63205 100644
--- a/drivers/media/video/pms.c
+++ b/drivers/media/video/pms.c
@@ -27,14 +27,13 @@
 #include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
-#include <asm/io.h>
 #include <linux/videodev.h>
-#include <media/v4l2-common.h>
-#include <media/v4l2-ioctl.h>
 #include <linux/mutex.h>
-
+#include <linux/isa.h>
+#include <asm/io.h>
 #include <asm/uaccess.h>
-
+#include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
 
 #define MOTOROLA	1
 #define PHILIPS2	2
@@ -68,13 +67,12 @@ static int standard;	/* 0 - auto 1 - ntsc 2 - pal 3 - secam */
  *	I/O ports and Shared Memory
  */
 
-static int io_port		=	0x250;
-static int data_port		=	0x251;
-static int mem_base		=	0xC8000;
-static void __iomem *mem;
-static int video_nr             =       -1;
-
+static int io_port;
+static int data_port;
+static int mem_base = 0xC8000;
+static int video_nr = -1;
 
+static void __iomem *mem;
 
 static inline void mvv_write(u8 index, u8 value)
 {
@@ -1019,10 +1017,26 @@ static int init_mediavision(void)
  *	Initialization and module stuff
  */
 
-static int __init init_pms_cards(void)
+module_param(io_port, int, 0);
+module_param(mem_base, int, 0);
+module_param(video_nr, int, 0);
+MODULE_LICENSE("GPL");
+
+static int __devinit pms_isa_match(struct device *dev, unsigned int id)
 {
-	printk(KERN_INFO "Mediavision Pro Movie Studio driver 0.02\n");
+	int match = io_port != 0;
 
+	if (match)
+		dev_info(dev, "io_port = %#x, mem_base = %#x\n",
+			 io_port, mem_base);
+	else
+		dev_err(dev, "please specify io_port\n");
+
+	return match;
+}
+
+static int __devinit pms_isa_probe(struct device *dev, unsigned int id)
+{
 	data_port = io_port +1;
 
 	if(init_mediavision())
@@ -1039,25 +1053,36 @@ static int __init init_pms_cards(void)
 	return video_register_device((struct video_device *)&pms_device, VFL_TYPE_GRABBER, video_nr);
 }
 
-module_param(io_port, int, 0);
-module_param(mem_base, int, 0);
-module_param(video_nr, int, 0);
-MODULE_LICENSE("GPL");
+static int __devexit pms_isa_remove(struct device *dev, unsigned int id)
+{
+	release_region(io_port, 3);
+	release_region(0x9A01, 1);
+	video_unregister_device((struct video_device *)&pms_device);
+	iounmap(mem);
+	return 0;
+}
+
+static struct isa_driver pms_isa_driver = {
+	.match		= pms_isa_match,
+	.probe		= pms_isa_probe,
+	.remove		= __devexit_p(pms_isa_remove),
 
+	.driver		= {
+		.name	= "pms"
+	}
+};
 
-static void __exit shutdown_mediavision(void)
+static int __init pms_init(void)
 {
-	release_region(io_port,3);
-	release_region(0x9A01, 1);
+	printk(KERN_INFO "Mediavision Pro Movie Studio driver 0.02\n");
+	return isa_register_driver(&pms_isa_driver, 1);
 }
 
-static void __exit cleanup_pms_module(void)
+static void __exit pms_exit(void)
 {
-	shutdown_mediavision();
-	video_unregister_device((struct video_device *)&pms_device);
-	iounmap(mem);
+	isa_unregister_driver(&pms_isa_driver);
 }
 
-module_init(init_pms_cards);
-module_exit(cleanup_pms_module);
+module_init(pms_init);
+module_exit(pms_exit);
 
-- 
1.5.5


--------------080101030105050108050407--
