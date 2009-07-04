Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbZGDBof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbZGDBof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 21:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758640AbZGDBoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 21:44:07 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1657 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758648AbZGDBoG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 21:44:06 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Leo (Hao) Chen" <leochen@broadcom.com>
To: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
       "Scott Branden" <sbranden@broadcom.com>,
       "Leo (Hao) Chen" <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 18:43:40 -0700
Subject: [PATCH v2 7/18] new ARM SoC support: BCMRing
Thread-Topic: [PATCH v2 7/18] new ARM SoC support: BCMRing
Thread-Index: Acn8SNt2QVw0f5/QQveyE8Iix49A0A==
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25BA6C14@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 66506C4760020616389-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 1fd568d97729a0e174508593c04381966347c439 Mon Sep 17 00:00:00 2001
From: Leo Chen <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 16:24:22 -0700
Subject: [PATCH 07/18] add mach-bcmring/mm.c

memory map description and init function for bcmring

Signed-off-by: Leo Chen <leochen@broadcom.com>
---
 arch/arm/mach-bcmring/mm.c |   71 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 71 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-bcmring/mm.c

diff --git a/arch/arm/mach-bcmring/mm.c b/arch/arm/mach-bcmring/mm.c
new file mode 100644
index 0000000..9f4180b
--- /dev/null
+++ b/arch/arm/mach-bcmring/mm.c
@@ -0,0 +1,71 @@
+/*****************************************************************************
+* Copyright 2003 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/ioport.h>
+#include <linux/platform_device.h>
+#include <linux/serial_8250.h>
+
+#include <asm/io.h>
+#include <asm/pgtable.h>
+#include <asm/page.h>
+
+#include <asm/mach/map.h>
+#include <asm/pgalloc.h>
+
+#include <linux/serial.h>
+#include <linux/serial_core.h>
+
+#include <mach/hardware.h>
+#include <mach/csp/mm_io.h>
+
+#define IO_DESC(va, sz) { .virtual = va, \
+       .pfn = __phys_to_pfn(HW_IO_VIRT_TO_PHYS(va)), \
+       .length = sz, \
+       .type = MT_DEVICE }
+
+#define MEM_DESC(va, sz) { .virtual = va, \
+       .pfn = __phys_to_pfn(HW_IO_VIRT_TO_PHYS(va)), \
+       .length = sz, \
+       .type = MT_MEMORY }
+
+static struct map_desc bcmring_io_desc[] __initdata = {
+       IO_DESC(MM_IO_BASE_NAND, SZ_64K),       /* phys:0x28000000-0x28000FFF  virt:0xE8000000-0xE8000FFF  size:0x00010000 */
+       IO_DESC(MM_IO_BASE_UMI, SZ_64K),        /* phys:0x2C000000-0x2C000FFF  virt:0xEC000000-0xEC000FFF  size:0x00010000 */
+
+       IO_DESC(MM_IO_BASE_BROM, SZ_64K),       /* phys:0x30000000-0x3000FFFF  virt:0xF3000000-0xF300FFFF  size:0x00010000 */
+       MEM_DESC(MM_IO_BASE_ARAM, SZ_1M),       /* phys:0x31000000-0x31FFFFFF  virt:0xF3100000-0xF31FFFFF  size:0x01000000 */
+       IO_DESC(MM_IO_BASE_DMA0, SZ_1M),        /* phys:0x32000000-0x32FFFFFF  virt:0xF3200000-0xF32FFFFF  size:0x01000000 */
+       IO_DESC(MM_IO_BASE_DMA1, SZ_1M),        /* phys:0x33000000-0x33FFFFFF  virt:0xF3300000-0xF33FFFFF  size:0x01000000 */
+       IO_DESC(MM_IO_BASE_ESW, SZ_1M), /* phys:0x34000000-0x34FFFFFF  virt:0xF3400000-0xF34FFFFF  size:0x01000000 */
+       IO_DESC(MM_IO_BASE_CLCD, SZ_1M),        /* phys:0x35000000-0x35FFFFFF  virt:0xF3500000-0xF35FFFFF  size:0x01000000 */
+       IO_DESC(MM_IO_BASE_APM, SZ_1M), /* phys:0x36000000-0x36FFFFFF  virt:0xF3600000-0xF36FFFFF  size:0x01000000 */
+       IO_DESC(MM_IO_BASE_SPUM, SZ_1M),        /* phys:0x37000000-0x37FFFFFF  virt:0xF3700000-0xF37FFFFF  size:0x01000000 */
+       IO_DESC(MM_IO_BASE_VPM_PROG, SZ_1M),    /* phys:0x38000000-0x38FFFFFF  virt:0xF3800000-0xF38FFFFF  size:0x01000000 */
+       IO_DESC(MM_IO_BASE_VPM_DATA, SZ_1M),    /* phys:0x3A000000-0x3AFFFFFF  virt:0xF3A00000-0xF3AFFFFF  size:0x01000000 */
+
+       IO_DESC(MM_IO_BASE_VRAM, SZ_64K),       /* phys:0x40000000-0x4000FFFF  virt:0xF4000000-0xF400FFFF  size:0x00010000 */
+       IO_DESC(MM_IO_BASE_CHIPC, SZ_16M),      /* phys:0x80000000-0x80FFFFFF  virt:0xF8000000-0xF8FFFFFF  size:0x01000000 */
+       IO_DESC(MM_IO_BASE_VPM_EXTMEM_RSVD,
+               SZ_16M),        /* phys:0x0F000000-0x0FFFFFFF  virt:0xF0000000-0xF0FFFFFF  size:0x01000000 */
+};
+
+void __init bcmring_map_io(void)
+{
+
+       iotable_init(bcmring_io_desc, ARRAY_SIZE(bcmring_io_desc));
+}
--
1.6.0.6



Leo Hao Chen
Software Engineer
Broadcom Canada Inc.


