Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbXF0PXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbXF0PXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 11:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbXF0PXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 11:23:47 -0400
Received: from sperry-02.control.lth.se ([130.235.83.189]:55550 "EHLO
	sperry-02.control.lth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbXF0PXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 11:23:46 -0400
X-Greylist: delayed 1498 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jun 2007 11:23:46 EDT
Message-ID: <46827B20.6000501@control.lth.se>
Date: Wed, 27 Jun 2007 16:58:40 +0200
From: Anders Blomdell <anders.blomdell@control.lth.se>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Manuel Estrada Sainz <ranty@debian.org>
Subject: [PATCH] Documentation/firmware_class/firmware_sample_driver.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anders Blomdell <anders.blomdell@control.lth.se>

Minor modifications to make the example load and unload without Oops

This is what unpatched version generates with 2.6.21.3

kernel: Oops: 0000 [#2]
...
kernel: Call Trace:
kernel:  [<c04ae541>] sysfs_create_dir+0x49/0x63
kernel:  [<c04e76ae>] kobject_shadow_add+0xd5/0x17d
kernel:  [<c04e7908>] kobject_set_name+0x2b/0x92
kernel:  [<c0556444>] device_add+0x9a/0x58e
kernel:  [<c0620b65>] klist_init+0x23/0x2e
kernel:  [<c055bfee>] _request_firmware+0x116/0x29f
kernel:  [<c062149f>] wait_for_completion+0x8b/0x93
kernel:  [<c055c20b>] request_firmware+0xf/0x11
kernel:  [<e09420d9>] sample_init+0x59/0xc0 [firmware_sample_driver]
kernel:  [<c0446c92>] sys_init_module+0x16b7/0x17ee
kernel:  [<c04294de>] printk+0x0/0x1f
kernel:  [<c0488436>] mntput_no_expire+0x11/0x6e
kernel:  [<c0404fa8>] syscall_call+0x7/0xb



diff -u Documentation/firmware_class/firmware_sample_driver.c
/tmp/fw/firmware_sample_driver.c
--- Documentation/firmware_class/firmware_sample_driver.c       2007-05-24
23:22:47.000000000 +0200
+++ /tmp/fw/firmware_sample_driver.c    2007-06-27 16:51:16.000000000 +0200
@@ -15,11 +15,16 @@

 #include "linux/firmware.h"

+static void ghost_release(struct device *dev)
+{
+       printk(KERN_DEBUG "firmware_sample_driver: ghost_release\n");
+}
+
 static struct device ghost_device = {
        .bus_id    = "ghost0",
+       .release   = ghost_release
 };

-
 static void sample_firmware_load(char *firmware, int size)
 {
        u8 buf[size+1];
@@ -97,16 +102,17 @@

 static int sample_init(void)
 {
-       device_initialize(&ghost_device);
+       device_register(&ghost_device);
        /* since there is no real hardware insertion I just call the
         * sample probe functions here */
-       sample_probe_specific();
+       /* sample_probe_specific(); */
        sample_probe_default();
-       sample_probe_async();
+       /*sample_probe_async();*/
        return 0;
 }
 static void __exit sample_exit(void)
 {
+       device_unregister(&ghost_device);
 }

 module_init (sample_init);

-- 
Anders Blomdell                  Email: anders.blomdell@control.lth.se
Department of Automatic Control
Lund University                  Phone:    +46 46 222 4625
P.O. Box 118                     Fax:      +46 46 138118
SE-221 00 Lund, Sweden
