Return-Path: <linux-kernel-owner+w=401wt.eu-S1763138AbYCAUsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763138AbYCAUsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 15:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759167AbYCAUn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 15:43:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:27483 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760148AbYCAUnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 15:43:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=gJBaXRRp8Yos9lyRJFdfXyQsaGuNAr04oaZosn/9F2Mlyd/A2kd1dSJC2e0FHp1CE93WUpKZIazLg37X1IHxxZcu2nYYTcPj2aTtDMy/mEtKRI+Ys33Bm0qPuOjmm1ZgatO8PshzYex3X+gpGQiX+DaguTlJEI3eA7O8jlUNhpM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 5/9] ide: manage I/O resources in ide_legacy_init_one()
Date: Sat, 1 Mar 2008 19:47:59 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803011948.00032.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tell IDE layer to not manage resources by setting hwif->mmio flag.

* Use {request,release}_region() for resources management.

* Set ->name field of 'struct ide_port_info' instances in legacy VLB
  host drivers and use driver name for resources management.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c      |   14 ++++++++++++++
 drivers/ide/legacy/ali14xx.c |    3 +++
 drivers/ide/legacy/dtc2278.c |    3 +++
 drivers/ide/legacy/ht6560b.c |    1 +
 drivers/ide/legacy/qd65xx.c  |    3 +++
 drivers/ide/legacy/umc8672.c |    3 +++
 6 files changed, 27 insertions(+)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1644,12 +1644,26 @@ static void ide_legacy_init_one(u8 *idx,
 		irq  = 15;
 	}
 
+	if (!request_region(base, 8, d->name)) {
+		printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
+				d->name, base, base + 7);
+		return;
+	}
+
+	if (!request_region(ctl, 1, d->name)) {
+		printk(KERN_ERR "%s: I/O resource 0x%lX not free.\n",
+				d->name, ctl);
+		release_region(base, 8);
+		return;
+	}
+
 	ide_std_init_ports(hw, base, ctl);
 	hw->irq = irq;
 
 	hwif = ide_find_port_slot(d);
 	if (hwif) {
 		ide_init_port_hw(hwif, hw);
+		hwif->mmio = 1;
 		if (config)
 			hwif->config_data = config;
 		idx[port_no] = hwif->index;
Index: b/drivers/ide/legacy/ali14xx.c
===================================================================
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -49,6 +49,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "ali14xx"
+
 /* port addresses for auto-detection */
 #define ALI_NUM_PORTS 4
 static const int ports[ALI_NUM_PORTS] __initdata =
@@ -197,6 +199,7 @@ static const struct ide_port_ops ali14xx
 };
 
 static const struct ide_port_info ali14xx_port_info = {
+	.name			= DRV_NAME,
 	.chipset		= ide_ali14xx,
 	.port_ops		= &ali14xx_port_ops,
 	.host_flags		= IDE_HFLAG_NO_DMA | IDE_HFLAG_NO_AUTOTUNE,
Index: b/drivers/ide/legacy/dtc2278.c
===================================================================
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -16,6 +16,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "dtc2278"
+
 /*
  * Changing this #undef to #define may solve start up problems in some systems.
  */
@@ -91,6 +93,7 @@ static const struct ide_port_ops dtc2278
 };
 
 static const struct ide_port_info dtc2278_port_info __initdata = {
+	.name			= DRV_NAME,
 	.chipset		= ide_dtc2278,
 	.port_ops		= &dtc2278_port_ops,
 	.host_flags		= IDE_HFLAG_SERIALIZE |
Index: b/drivers/ide/legacy/ht6560b.c
===================================================================
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -335,6 +335,7 @@ static const struct ide_port_ops ht6560b
 };
 
 static const struct ide_port_info ht6560b_port_info __initdata = {
+	.name			= DRV_NAME,
 	.chipset		= ide_ht6560b,
 	.port_ops		= &ht6560b_port_ops,
 	.host_flags		= IDE_HFLAG_SERIALIZE | /* is this needed? */
Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -37,6 +37,8 @@
 #include <asm/system.h>
 #include <asm/io.h>
 
+#define DRV_NAME "qd65xx"
+
 #include "qd65xx.h"
 
 /*
@@ -317,6 +319,7 @@ static const struct ide_port_ops qd6580_
 };
 
 static const struct ide_port_info qd65xx_port_info __initdata = {
+	.name			= DRV_NAME,
 	.chipset		= ide_qd65xx,
 	.host_flags		= IDE_HFLAG_IO_32BIT |
 				  IDE_HFLAG_NO_DMA |
Index: b/drivers/ide/legacy/umc8672.c
===================================================================
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -51,6 +51,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "umc8672"
+
 /*
  * Default speeds.  These can be changed with "auto-tune" and/or hdparm.
  */
@@ -125,6 +127,7 @@ static const struct ide_port_ops umc8672
 };
 
 static const struct ide_port_info umc8672_port_info __initdata = {
+	.name			= DRV_NAME,
 	.chipset		= ide_umc8672,
 	.port_ops		= &umc8672_port_ops,
 	.host_flags		= IDE_HFLAG_NO_DMA | IDE_HFLAG_NO_AUTOTUNE,
