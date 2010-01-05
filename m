Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199Ab0AEWyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab0AEWyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755170Ab0AEWyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:54:15 -0500
Received: from mail.gmx.net ([213.165.64.20]:45590 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754497Ab0AEWyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:54:14 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX192GchPTgh2YRH9qeifXBqUMthJXG/4dDGtoVnj5c
	mQFdi4TxViofvi
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/4] viafb: yet another dead code removal
Date: Tue,  5 Jan 2010 22:59:56 +0000
Message-Id: <1262732399-3416-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: yet another dead code removal

Remove some functions that were never executed and a related
undocumented module paramater.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/Makefile   |    2 +-
 drivers/video/via/global.c   |    1 -
 drivers/video/via/global.h   |    1 -
 drivers/video/via/iface.c    |   78 ------------------------------------------
 drivers/video/via/iface.h    |   38 --------------------
 drivers/video/via/viafbdev.c |    2 -
 drivers/video/via/viafbdev.h |    1 -
 7 files changed, 1 insertions(+), 122 deletions(-)
 delete mode 100644 drivers/video/via/iface.c
 delete mode 100644 drivers/video/via/iface.h

diff --git a/drivers/video/via/Makefile b/drivers/video/via/Makefile
index e533b4b..eeed238 100644
--- a/drivers/video/via/Makefile
+++ b/drivers/video/via/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_FB_VIA) += viafb.o
 
-viafb-y	:=viafbdev.o hw.o iface.o  via_i2c.o dvi.o lcd.o ioctl.o accel.o via_utility.o vt1636.o global.o tblDPASetting.o viamode.o tbl1636.o
+viafb-y	:=viafbdev.o hw.o via_i2c.o dvi.o lcd.o ioctl.o accel.o via_utility.o vt1636.o global.o tblDPASetting.o viamode.o tbl1636.o
diff --git a/drivers/video/via/global.c b/drivers/video/via/global.c
index b675cdb..7fbc618 100644
--- a/drivers/video/via/global.c
+++ b/drivers/video/via/global.c
@@ -23,7 +23,6 @@ int viafb_platform_epia_dvi = STATE_OFF;
 int viafb_device_lcd_dualedge = STATE_OFF;
 int viafb_bus_width = 12;
 int viafb_display_hardware_layout = HW_LAYOUT_LCD_DVI;
-int viafb_memsize;
 int viafb_DeviceStatus = CRT_Device;
 int viafb_hotplug;
 int viafb_refresh = 60;
diff --git a/drivers/video/via/global.h b/drivers/video/via/global.h
index d69d0ca..865b050 100644
--- a/drivers/video/via/global.h
+++ b/drivers/video/via/global.h
@@ -35,7 +35,6 @@
 
 #include "debug.h"
 
-#include "iface.h"
 #include "viafbdev.h"
 #include "chip.h"
 #include "accel.h"
diff --git a/drivers/video/via/iface.c b/drivers/video/via/iface.c
deleted file mode 100644
index 1570636..0000000
--- a/drivers/video/via/iface.c
+++ /dev/null
@@ -1,78 +0,0 @@
-/*
- * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
- * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
-
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation;
- * either version 2, or (at your option) any later version.
-
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
- * the implied warranty of MERCHANTABILITY or FITNESS FOR
- * A PARTICULAR PURPOSE.See the GNU General Public License
- * for more details.
-
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-#include "global.h"
-
-/* Get frame buffer size from VGA BIOS */
-
-unsigned int viafb_get_memsize(void)
-{
-	unsigned int m;
-
-	/* If memory size provided by user */
-	if (viafb_memsize)
-		m = viafb_memsize * Mb;
-	else {
-		m = (unsigned int)viafb_read_reg(VIASR, SR39);
-		m = m * (4 * Mb);
-
-		if ((m < (16 * Mb)) || (m > (64 * Mb)))
-			m = 16 * Mb;
-	}
-	DEBUG_MSG(KERN_INFO "framebuffer size = %d Mb\n", m / Mb);
-	return m;
-}
-
-/* Get Video Buffer Starting Physical Address(back door)*/
-
-unsigned long viafb_get_videobuf_addr(void)
-{
-	struct pci_dev *pdev = NULL;
-	unsigned char sys_mem;
-	unsigned char video_mem;
-	unsigned long sys_mem_size;
-	unsigned long video_mem_size;
-	/*system memory = 256 MB, video memory 64 MB */
-	unsigned long vmem_starting_adr = 0x0C000000;
-
-	pdev =
-	    (struct pci_dev *)pci_get_device(VIA_K800_BRIDGE_VID,
-					     VIA_K800_BRIDGE_DID, NULL);
-	if (pdev != NULL) {
-		pci_read_config_byte(pdev, VIA_K800_SYSTEM_MEMORY_REG,
-				     &sys_mem);
-		pci_read_config_byte(pdev, VIA_K800_VIDEO_MEMORY_REG,
-				     &video_mem);
-		video_mem = (video_mem & 0x70) >> 4;
-		sys_mem_size = ((unsigned long)sys_mem) << 24;
-		if (video_mem != 0)
-			video_mem_size = (1 << (video_mem)) * 1024 * 1024;
-		else
-			video_mem_size = 0;
-
-		vmem_starting_adr = sys_mem_size - video_mem_size;
-		pci_dev_put(pdev);
-	}
-
-	DEBUG_MSG(KERN_INFO "Video Memory Starting Address = %lx \n",
-		  vmem_starting_adr);
-	return vmem_starting_adr;
-}
diff --git a/drivers/video/via/iface.h b/drivers/video/via/iface.h
deleted file mode 100644
index 790ec3e..0000000
--- a/drivers/video/via/iface.h
+++ /dev/null
@@ -1,38 +0,0 @@
-/*
- * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
- * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
-
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation;
- * either version 2, or (at your option) any later version.
-
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
- * the implied warranty of MERCHANTABILITY or FITNESS FOR
- * A PARTICULAR PURPOSE.See the GNU General Public License
- * for more details.
-
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-#ifndef __IFACE_H__
-#define __IFACE_H__
-
-#define Kb  (1024)
-#define Mb  (Kb*Kb)
-
-#define VIA_K800_BRIDGE_VID         0x1106
-#define VIA_K800_BRIDGE_DID         0x3204
-
-#define VIA_K800_SYSTEM_MEMORY_REG  0x47
-#define VIA_K800_VIDEO_MEMORY_REG   0xA1
-
-extern int viafb_memsize;
-unsigned int viafb_get_memsize(void);
-unsigned long viafb_get_videobuf_addr(void);
-
-#endif /* __IFACE_H__ */
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 6e1955f..02ed2f6 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -2214,8 +2214,6 @@ module_init(viafb_init);
 module_exit(viafb_exit);
 
 #ifdef MODULE
-module_param(viafb_memsize, int, S_IRUSR);
-
 module_param(viafb_mode, charp, S_IRUSR);
 MODULE_PARM_DESC(viafb_mode, "Set resolution (default=640x480)");
 
diff --git a/drivers/video/via/viafbdev.h b/drivers/video/via/viafbdev.h
index 85aa20e..ecdaed8 100644
--- a/drivers/video/via/viafbdev.h
+++ b/drivers/video/via/viafbdev.h
@@ -91,7 +91,6 @@ extern int viafb_LCD2_ON;
 extern int viafb_LCD_ON;
 extern int viafb_DVI_ON;
 extern int viafb_hotplug;
-extern int viafb_memsize;
 
 extern int strict_strtoul(const char *cp, unsigned int base,
 	unsigned long *res);
-- 
1.6.3.2

