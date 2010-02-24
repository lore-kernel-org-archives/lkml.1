Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab0BXPe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 10:34:56 -0500
Received: from mail2.tundra.com ([142.46.200.162]:44233 "EHLO mx2.tundra.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755008Ab0BXPex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 10:34:53 -0500
X-ASG-Debug-ID: 1267024547-555c00d20000-xx1T2L
X-Barracuda-URL: http://142.46.200.162:8000/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: alexb@tundra.com
Date: Wed, 24 Feb 2010 10:14:47 -0500
From: Alexandre Bounine <alexb@tundra.com>
To: mporter@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       thomas.moll@sysgo.com, thomas.moll.ext@nsn.com, alexandreb@tundra.com
X-ASG-Orig-Subj: [PATCH 1/7] RapidIO: Add IDT CPS/TSI switches
Subject: [PATCH 1/7] RapidIO: Add IDT CPS/TSI switches
Message-ID: <20100224151447.GA13661@kaneng01.tundra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
X-Barracuda-Connect: UNKNOWN[142.46.200.189]
X-Barracuda-Start-Time: 1267024547
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at tundra.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Alexandre Bounine <alexandre.bounine@idt.com>

Extentions to RapidIO switch support:
1. modify switch route operation declarations to allow using single
   switch-specific file for family of switches that share the same route
   table operations.
2. add standard route table operations for switches that that support
   route table manipulation registers as defined in the Rev.1.3 of RapidIO
   specification.
3. add clear-route-table operation for switches
4. add CPSxx and TSIxxx families of RapidIO switches 

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Tested-by: Thomas Moll <thomas.moll@sysgo.com>
---

 drivers/rapidio/rio-scan.c        |   17 +++++-
 drivers/rapidio/rio.c             |  104 +++++++++++++++++++++++++++++++++++++
 drivers/rapidio/rio.h             |   20 +++++--
 drivers/rapidio/switches/Makefile |    2 
 drivers/rapidio/switches/idtcps.c |   84 ++++++++++++++++++++++++++++++
 drivers/rapidio/switches/tsi500.c |    2 
 drivers/rapidio/switches/tsi568.c |  106 ++++++++++++++++++++++++++++++++++++++
 drivers/rapidio/switches/tsi57x.c |  106 ++++++++++++++++++++++++++++++++++++++
 include/linux/rio.h               |    6 ++
 include/linux/rio_ids.h           |   14 +++++
 include/linux/rio_regs.h          |   14 ++++-
 11 files changed, 464 insertions(+), 11 deletions(-)

diff -x '*.pj' -X dontdiff_2.6.32-rc5 -pNur w33r7c/drivers/rapidio/rio-scan.c w33r7d/drivers/rapidio/rio-scan.c
--- w33r7c/drivers/rapidio/rio-scan.c	2010-02-06 17:17:12.000000000 -0500
+++ w33r7d/drivers/rapidio/rio-scan.c	2010-02-22 11:06:23.913470000 -0500
@@ -55,6 +55,7 @@ static int rio_mport_phys_table[] = {
 static int rio_sport_phys_table[] = {
 	RIO_EFB_PAR_EP_FREE_ID,
 	RIO_EFB_SER_EP_FREE_ID,
+	RIO_EFB_SER_EP_FREC_ID,
 	-1,
 };
 
@@ -246,10 +247,20 @@ static void rio_route_set_ops(struct rio
 			pr_debug("RIO: adding routing ops for %s\n", rio_name(rdev));
 			rdev->rswitch->add_entry = cur->add_hook;
 			rdev->rswitch->get_entry = cur->get_hook;
+			rdev->rswitch->clr_table = cur->clr_hook;
+			break;
 		}
 		cur++;
 	}
 
+	if ((cur >= end) && (rdev->pef & RIO_PEF_STD_RT)) {
+		pr_debug("RIO: adding STD routing ops for %s\n",
+			rio_name(rdev));
+		rdev->rswitch->add_entry = rio_std_route_add_entry;
+		rdev->rswitch->get_entry = rio_std_route_get_entry;
+		rdev->rswitch->clr_table = rio_std_route_clr_table;
+	}
+
 	if (!rdev->rswitch->add_entry || !rdev->rswitch->get_entry)
 		printk(KERN_ERR "RIO: missing routing ops for %s\n",
 		       rio_name(rdev));
@@ -349,7 +360,7 @@ static struct rio_dev __devinit *rio_set
 	if (rio_is_switch(rdev)) {
 		rio_mport_read_config_32(port, destid, hopcount,
 					 RIO_SWP_INFO_CAR, &rdev->swpinfo);
-		rswitch = kmalloc(sizeof(struct rio_switch), GFP_KERNEL);
+		rswitch = kzalloc(sizeof(struct rio_switch), GFP_KERNEL);
 		if (!rswitch)
 			goto cleanup;
 		rswitch->switchid = next_switchid;
@@ -369,6 +380,10 @@ static struct rio_dev __devinit *rio_set
 			     rdev->rswitch->switchid);
 		rio_route_set_ops(rdev);
 
+		if (do_enum && rdev->rswitch->clr_table)
+			rdev->rswitch->clr_table(port, destid, hopcount,
+						 RIO_GLOBAL_TABLE);
+
 		list_add_tail(&rswitch->node, &rio_switches);
 
 	} else
diff -x '*.pj' -X dontdiff_2.6.32-rc5 -pNur w33r7c/drivers/rapidio/rio.c w33r7d/drivers/rapidio/rio.c
--- w33r7c/drivers/rapidio/rio.c	2010-02-06 17:17:12.000000000 -0500
+++ w33r7d/drivers/rapidio/rio.c	2010-02-22 11:06:23.937564000 -0500
@@ -451,6 +451,110 @@ struct rio_dev *rio_get_device(u16 vid, 
 	return rio_get_asm(vid, did, RIO_ANY_ID, RIO_ANY_ID, from);
 }
 
+/**
+ * rio_std_route_add_entry - Add switch route table entry using standard
+ *   registers defined in RIO specification rev.1.3
+ * @mport: Master port to issue transaction
+ * @destid: Destination ID of the device
+ * @hopcount: Number of switch hops to the device
+ * @table: routing table ID (global or port-specific)
+ * @route_destid: destID entry in the RT
+ * @route_port: destination port for specified destID
+ */
+int rio_std_route_add_entry(struct rio_mport *mport, u16 destid, u8 hopcount,
+		       u16 table, u16 route_destid, u8 route_port)
+{
+	if (table == RIO_GLOBAL_TABLE) {
+		rio_mport_write_config_32(mport, destid, hopcount,
+				RIO_STD_RTE_CONF_DESTID_SEL_CSR,
+				(u32)route_destid);
+		rio_mport_write_config_32(mport, destid, hopcount,
+				RIO_STD_RTE_CONF_PORT_SEL_CSR,
+				(u32)route_port);
+	}
+	udelay(10);
+	return 0;
+}
+
+/**
+ * rio_std_route_get_entry - Read switch route table entry (port number)
+ *   assosiated with specified destID using standard registers defined in RIO
+ *   specification rev.1.3
+ * @mport: Master port to issue transaction
+ * @destid: Destination ID of the device
+ * @hopcount: Number of switch hops to the device
+ * @table: routing table ID (global or port-specific)
+ * @route_destid: destID entry in the RT
+ * @route_port: returned destination port for specified destID
+ */
+int rio_std_route_get_entry(struct rio_mport *mport, u16 destid, u8 hopcount,
+		       u16 table, u16 route_destid, u8 *route_port)
+{
+	u32 result;
+
+	if (table == RIO_GLOBAL_TABLE) {
+		rio_mport_write_config_32(mport, destid, hopcount,
+				RIO_STD_RTE_CONF_DESTID_SEL_CSR, route_destid);
+		rio_mport_read_config_32(mport, destid, hopcount,
+				RIO_STD_RTE_CONF_PORT_SEL_CSR, &result);
+
+		*route_port = (u8)result;
+	}
+
+	return 0;
+}
+
+/**
+ * rio_std_route_clr_table - Clear swotch route table using standard registers
+ *   defined in RIO specification rev.1.3.
+ * @mport: Master port to issue transaction
+ * @local: Indicate a local master port or remote device access
+ * @destid: Destination ID of the device
+ * @hopcount: Number of switch hops to the device
+ * @table: routing table ID (global or port-specific)
+ */
+int rio_std_route_clr_table(struct rio_mport *mport, u16 destid, u8 hopcount,
+		       u16 table)
+{
+	u32 max_destid = 0xff;
+	u32 i, pef, id_inc = 1, ext_cfg = 0;
+	u32 port_sel = RIO_INVALID_ROUTE;
+
+	if (table == RIO_GLOBAL_TABLE) {
+		rio_mport_read_config_32(mport, destid, hopcount,
+					 RIO_PEF_CAR, &pef);
+
+		if (mport->sys_size) {
+			rio_mport_read_config_32(mport, destid, hopcount,
+						 RIO_SWITCH_RT_LIMIT,
+						 &max_destid);
+			max_destid &= RIO_RT_MAX_DESTID;
+		}
+
+		if (pef & RIO_PEF_EXT_RT) {
+			ext_cfg = 0x80000000;
+			id_inc = 4;
+			port_sel = (RIO_INVALID_ROUTE << 24) |
+				   (RIO_INVALID_ROUTE << 16) |
+				   (RIO_INVALID_ROUTE << 8) |
+				   RIO_INVALID_ROUTE;
+		}
+
+		for (i = 0; i <= max_destid;) {
+			rio_mport_write_config_32(mport, destid, hopcount,
+					RIO_STD_RTE_CONF_DESTID_SEL_CSR,
+					ext_cfg | i);
+			rio_mport_write_config_32(mport, destid, hopcount,
+					RIO_STD_RTE_CONF_PORT_SEL_CSR,
+					port_sel);
+			i += id_inc;
+		}
+	}
+
+	udelay(10);
+	return 0;
+}
+
 static void rio_fixup_device(struct rio_dev *dev)
 {
 }
diff -x '*.pj' -X dontdiff_2.6.32-rc5 -pNur w33r7c/drivers/rapidio/rio.h w33r7d/drivers/rapidio/rio.h
--- w33r7c/drivers/rapidio/rio.h	2010-02-06 17:17:12.000000000 -0500
+++ w33r7d/drivers/rapidio/rio.h	2010-02-22 11:06:24.035348000 -0500
@@ -21,6 +21,14 @@ extern u32 rio_mport_get_feature(struct 
 extern int rio_create_sysfs_dev_files(struct rio_dev *rdev);
 extern int rio_enum_mport(struct rio_mport *mport);
 extern int rio_disc_mport(struct rio_mport *mport);
+extern int rio_std_route_add_entry(struct rio_mport *mport, u16 destid,
+				   u8 hopcount, u16 table, u16 route_destid,
+				   u8 route_port);
+extern int rio_std_route_get_entry(struct rio_mport *mport, u16 destid,
+				   u8 hopcount, u16 table, u16 route_destid,
+				   u8 *route_port);
+extern int rio_std_route_clr_table(struct rio_mport *mport, u16 destid,
+				   u8 hopcount, u16 table);
 
 /* Structures internal to the RIO core code */
 extern struct device_attribute rio_dev_attrs[];
@@ -30,9 +38,9 @@ extern struct rio_route_ops __start_rio_
 extern struct rio_route_ops __end_rio_route_ops[];
 
 /* Helpers internal to the RIO core code */
-#define DECLARE_RIO_ROUTE_SECTION(section, vid, did, add_hook, get_hook)  \
-	static struct rio_route_ops __rio_route_ops __used   \
-	__section(section)= { vid, did, add_hook, get_hook };
+#define DECLARE_RIO_ROUTE_SECTION(section, name, vid, did, add_hook, get_hook, clr_hook) \
+	static const struct rio_route_ops __rio_route_##name __used \
+	__section(section) = { vid, did, add_hook, get_hook, clr_hook };
 
 /**
  * DECLARE_RIO_ROUTE_OPS - Registers switch routing operations
@@ -47,9 +55,9 @@ extern struct rio_route_ops __end_rio_ro
  * rio_route_ops is initialized with the ops and placed into a
  * RIO-specific kernel section.
  */
-#define DECLARE_RIO_ROUTE_OPS(vid, did, add_hook, get_hook)		\
-	DECLARE_RIO_ROUTE_SECTION(.rio_route_ops,			\
-			vid, did, add_hook, get_hook)
+#define DECLARE_RIO_ROUTE_OPS(vid, did, add_hook, get_hook, clr_hook)	\
+	DECLARE_RIO_ROUTE_SECTION(.rio_route_ops, vid##did,		\
+			vid, did, add_hook, get_hook, clr_hook)
 
 #define RIO_GET_DID(size, x)	(size ? (x & 0xffff) : ((x & 0x00ff0000) >> 16))
 #define RIO_SET_DID(size, x)	(size ? (x & 0xffff) : ((x & 0x000000ff) << 16))
diff -x '*.pj' -X dontdiff_2.6.32-rc5 -pNur w33r7c/drivers/rapidio/switches/Makefile w33r7d/drivers/rapidio/switches/Makefile
--- w33r7c/drivers/rapidio/switches/Makefile	2010-02-06 17:17:12.000000000 -0500
+++ w33r7d/drivers/rapidio/switches/Makefile	2010-02-22 11:06:24.065326000 -0500
@@ -2,4 +2,4 @@
 # Makefile for RIO switches
 #
 
-obj-$(CONFIG_RAPIDIO)	+= tsi500.o
+obj-$(CONFIG_RAPIDIO)	+= tsi500.o tsi568.o tsi57x.o idtcps.o
diff -x '*.pj' -X dontdiff_2.6.32-rc5 -pNur w33r7c/drivers/rapidio/switches/idtcps.c w33r7d/drivers/rapidio/switches/idtcps.c
--- w33r7c/drivers/rapidio/switches/idtcps.c	1969-12-31 19:00:00.000000000 -0500
+++ w33r7d/drivers/rapidio/switches/idtcps.c	2010-02-22 11:06:24.069310000 -0500
@@ -0,0 +1,84 @@
+/*
+ * IDT CPS RapidIO switches support
+ *
+ * Copyright 2009 Integrated Device Technology, Inc.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/rio.h>
+#include <linux/rio_drv.h>
+#include <linux/rio_ids.h>
+#include "../rio.h"
+
+static int
+idtcps_route_add_entry(struct rio_mport *mport, u16 destid, u8 hopcount,
+		       u16 table, u16 route_destid, u8 route_port)
+{
+	u32 result;
+
+	if (table == RIO_GLOBAL_TABLE) {
+		rio_mport_write_config_32(mport, destid, hopcount,
+				RIO_STD_RTE_CONF_DESTID_SEL_CSR, route_destid);
+
+		rio_mport_read_config_32(mport, destid, hopcount,
+				RIO_STD_RTE_CONF_PORT_SEL_CSR, &result);
+
+		result = (0xffffff00 & result) | (u32)route_port;
+		rio_mport_write_config_32(mport, destid, hopcount,
+				RIO_STD_RTE_CONF_PORT_SEL_CSR, result);
+	}
+
+	return 0;
+}
+
+static int
+idtcps_route_get_entry(struct rio_mport *mport, u16 destid, u8 hopcount,
+		       u16 table, u16 route_destid, u8 *route_port)
+{
+	u32 result;
+
+	if (table == RIO_GLOBAL_TABLE) {
+		rio_mport_write_config_32(mport, destid, hopcount,
+				RIO_STD_RTE_CONF_DESTID_SEL_CSR, route_destid);
+
+		rio_mport_read_config_32(mport, destid, hopcount,
+				RIO_STD_RTE_CONF_PORT_SEL_CSR, &result);
+
+		*route_port = (u8)result;
+	}
+
+	return 0;
+}
+
+static int
+idtcps_route_clr_table(struct rio_mport *mport, u16 destid, u8 hopcount,
+		       u16 table)
+{
+	u32 i;
+
+	if (table == RIO_GLOBAL_TABLE) {
+		for (i = 0x80000000; i <= 0x800000ff;) {
+			rio_mport_write_config_32(mport, destid, hopcount,
+				RIO_STD_RTE_CONF_DESTID_SEL_CSR, i);
+			rio_mport_write_config_32(mport, destid, hopcount,
+				RIO_STD_RTE_CONF_PORT_SEL_CSR,
+				(RIO_INVALID_ROUTE << 24) |
+				(RIO_INVALID_ROUTE << 16) |
+				(RIO_INVALID_ROUTE << 8) | RIO_INVALID_ROUTE);
+			i += 4;
+		}
+	}
+
+	return 0;
+}
+
+DECLARE_RIO_ROUTE_OPS(RIO_VID_IDT, RIO_DID_IDTCPS6Q, idtcps_route_add_entry, idtcps_route_get_entry, idtcps_route_clr_table);
+DECLARE_RIO_ROUTE_OPS(RIO_VID_IDT, RIO_DID_IDTCPS8, idtcps_route_add_entry, idtcps_route_get_entry, idtcps_route_clr_table);
+DECLARE_RIO_ROUTE_OPS(RIO_VID_IDT, RIO_DID_IDTCPS10Q, idtcps_route_add_entry, idtcps_route_get_entry, idtcps_route_clr_table);
+DECLARE_RIO_ROUTE_OPS(RIO_VID_IDT, RIO_DID_IDTCPS12, idtcps_route_add_entry, idtcps_route_get_entry, idtcps_route_clr_table);
+DECLARE_RIO_ROUTE_OPS(RIO_VID_IDT, RIO_DID_IDTCPS16, idtcps_route_add_entry, idtcps_route_get_entry, idtcps_route_clr_table);
+DECLARE_RIO_ROUTE_OPS(RIO_VID_IDT, RIO_DID_IDT70K200, idtcps_route_add_entry, idtcps_route_get_entry, idtcps_route_clr_table);
diff -x '*.pj' -X dontdiff_2.6.32-rc5 -pNur w33r7c/drivers/rapidio/switches/tsi500.c w33r7d/drivers/rapidio/switches/tsi500.c
--- w33r7c/drivers/rapidio/switches/tsi500.c	2010-02-06 17:17:12.000000000 -0500
+++ w33r7d/drivers/rapidio/switches/tsi500.c	2010-02-22 11:06:24.070325000 -0500
@@ -57,4 +57,4 @@ tsi500_route_get_entry(struct rio_mport 
 	return ret;
 }
 
-DECLARE_RIO_ROUTE_OPS(RIO_VID_TUNDRA, RIO_DID_TSI500, tsi500_route_add_entry, tsi500_route_get_entry);
+DECLARE_RIO_ROUTE_OPS(RIO_VID_TUNDRA, RIO_DID_TSI500, tsi500_route_add_entry, tsi500_route_get_entry, NULL);
diff -x '*.pj' -X dontdiff_2.6.32-rc5 -pNur w33r7c/drivers/rapidio/switches/tsi568.c w33r7d/drivers/rapidio/switches/tsi568.c
--- w33r7c/drivers/rapidio/switches/tsi568.c	1969-12-31 19:00:00.000000000 -0500
+++ w33r7d/drivers/rapidio/switches/tsi568.c	2010-02-22 11:06:24.072314000 -0500
@@ -0,0 +1,106 @@
+/*
+ * RapidIO Tsi568 switch support
+ *
+ * Copyright 2009-2010 Integrated Device Technology, Inc.
+ * Copyright 2005 MontaVista Software, Inc.
+ * Matt Porter <mporter@kernel.crashing.org>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/rio.h>
+#include <linux/rio_drv.h>
+#include <linux/rio_ids.h>
+#include <linux/delay.h>
+#include "../rio.h"
+
+/* Global (broadcast) route registers */
+#define SPBC_ROUTE_CFG_DESTID	0x10070
+#define SPBC_ROUTE_CFG_PORT	0x10074
+
+/* Per port route registers */
+#define SPP_ROUTE_CFG_DESTID(n)	(0x11070 + 0x100*n)
+#define SPP_ROUTE_CFG_PORT(n)	(0x11074 + 0x100*n)
+
+static int
+tsi568_route_add_entry(struct rio_mport *mport, u16 destid, u8 hopcount,
+		       u16 table, u16 route_destid, u8 route_port)
+{
+	if (table == RIO_GLOBAL_TABLE) {
+		rio_mport_write_config_32(mport, destid, hopcount,
+					SPBC_ROUTE_CFG_DESTID, route_destid);
+		rio_mport_write_config_32(mport, destid, hopcount,
+					SPBC_ROUTE_CFG_PORT, route_port);
+	} else {
+		rio_mport_write_config_32(mport, destid, hopcount,
+					SPP_ROUTE_CFG_DESTID(table),
+					route_destid);
+		rio_mport_write_config_32(mport, destid, hopcount,
+					SPP_ROUTE_CFG_PORT(table), route_port);
+	}
+
+	udelay(10);
+
+	return 0;
+}
+
+static int
+tsi568_route_get_entry(struct rio_mport *mport, u16 destid, u8 hopcount,
+		       u16 table, u16 route_destid, u8 *route_port)
+{
+	int ret = 0;
+	u32 result;
+
+	if (table == RIO_GLOBAL_TABLE) {
+		rio_mport_write_config_32(mport, destid, hopcount,
+					SPBC_ROUTE_CFG_DESTID, route_destid);
+		rio_mport_read_config_32(mport, destid, hopcount,
+					SPBC_ROUTE_CFG_PORT, &result);
+	} else {
+		rio_mport_write_config_32(mport, destid, hopcount,
+					SPP_ROUTE_CFG_DESTID(table),
+					route_destid);
+		rio_mport_read_config_32(mport, destid, hopcount,
+					SPP_ROUTE_CFG_PORT(table), &result);
+	}
+
+	*route_port = result;
+	if (*route_port > 15)
+		ret = -1;
+
+	return ret;
+}
+
+static int
+tsi568_route_clr_table(struct rio_mport *mport, u16 destid, u8 hopcount,
+		       u16 table)
+{
+	u32 route_idx;
+	u32 lut_size;
+
+	lut_size = (mport->sys_size) ? 0x1ff : 0xff;
+
+	if (table == RIO_GLOBAL_TABLE) {
+		rio_mport_write_config_32(mport, destid, hopcount,
+					SPBC_ROUTE_CFG_DESTID, 0x80000000);
+		for (route_idx = 0; route_idx <= lut_size; route_idx++)
+			rio_mport_write_config_32(mport, destid, hopcount,
+						SPBC_ROUTE_CFG_PORT,
+						RIO_INVALID_ROUTE);
+	} else {
+		rio_mport_write_config_32(mport, destid, hopcount,
+					SPP_ROUTE_CFG_DESTID(table),
+					0x80000000);
+		for (route_idx = 0; route_idx <= lut_size; route_idx++)
+			rio_mport_write_config_32(mport, destid, hopcount,
+						SPP_ROUTE_CFG_PORT(table),
+						RIO_INVALID_ROUTE);
+	}
+
+	return 0;
+}
+
+DECLARE_RIO_ROUTE_OPS(RIO_VID_TUNDRA, RIO_DID_TSI568, tsi568_route_add_entry, tsi568_route_get_entry, tsi568_route_clr_table);
diff -x '*.pj' -X dontdiff_2.6.32-rc5 -pNur w33r7c/drivers/rapidio/switches/tsi57x.c w33r7d/drivers/rapidio/switches/tsi57x.c
--- w33r7c/drivers/rapidio/switches/tsi57x.c	1969-12-31 19:00:00.000000000 -0500
+++ w33r7d/drivers/rapidio/switches/tsi57x.c	2010-02-22 11:06:24.074316000 -0500
@@ -0,0 +1,106 @@
+/*
+ * RapidIO Tsi57x switch family support
+ *
+ * Copyright 2009 Integrated Device Technology, Inc.
+ * Copyright 2005 MontaVista Software, Inc.
+ * Matt Porter <mporter@kernel.crashing.org>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/rio.h>
+#include <linux/rio_drv.h>
+#include <linux/rio_ids.h>
+#include <linux/delay.h>
+#include "../rio.h"
+
+/* Global (broadcast) route registers */
+#define SPBC_ROUTE_CFG_DESTID	0x10070
+#define SPBC_ROUTE_CFG_PORT	0x10074
+
+/* Per port route registers */
+#define SPP_ROUTE_CFG_DESTID(n)	(0x11070 + 0x100*n)
+#define SPP_ROUTE_CFG_PORT(n)	(0x11074 + 0x100*n)
+
+static int
+tsi57x_route_add_entry(struct rio_mport *mport, u16 destid, u8 hopcount,
+		       u16 table, u16 route_destid, u8 route_port)
+{
+	if (table == RIO_GLOBAL_TABLE) {
+		rio_mport_write_config_32(mport, destid, hopcount,
+					  SPBC_ROUTE_CFG_DESTID, route_destid);
+		rio_mport_write_config_32(mport, destid, hopcount,
+					  SPBC_ROUTE_CFG_PORT, route_port);
+	} else {
+		rio_mport_write_config_32(mport, destid, hopcount,
+				SPP_ROUTE_CFG_DESTID(table), route_destid);
+		rio_mport_write_config_32(mport, destid, hopcount,
+				SPP_ROUTE_CFG_PORT(table), route_port);
+	}
+
+	udelay(10);
+
+	return 0;
+}
+
+static int
+tsi57x_route_get_entry(struct rio_mport *mport, u16 destid, u8 hopcount,
+		       u16 table, u16 route_destid, u8 *route_port)
+{
+	int ret = 0;
+	u32 result;
+
+	if (table == RIO_GLOBAL_TABLE) {
+		/* Use local RT of the ingress port to avoid possible
+		   race condition */
+		rio_mport_read_config_32(mport, destid, hopcount,
+			RIO_SWP_INFO_CAR, &result);
+		table = (result & RIO_SWP_INFO_PORT_NUM_MASK);
+	}
+
+	rio_mport_write_config_32(mport, destid, hopcount,
+				SPP_ROUTE_CFG_DESTID(table), route_destid);
+	rio_mport_read_config_32(mport, destid, hopcount,
+				SPP_ROUTE_CFG_PORT(table), &result);
+
+	*route_port = (u8)result;
+	if (*route_port > 15)
+		ret = -1;
+
+	return ret;
+}
+
+static int
+tsi57x_route_clr_table(struct rio_mport *mport, u16 destid, u8 hopcount,
+		       u16 table)
+{
+	u32 route_idx;
+	u32 lut_size;
+
+	lut_size = (mport->sys_size) ? 0x1ff : 0xff;
+
+	if (table == RIO_GLOBAL_TABLE) {
+		rio_mport_write_config_32(mport, destid, hopcount,
+					  SPBC_ROUTE_CFG_DESTID, 0x80000000);
+		for (route_idx = 0; route_idx <= lut_size; route_idx++)
+			rio_mport_write_config_32(mport, destid, hopcount,
+						  SPBC_ROUTE_CFG_PORT,
+						  RIO_INVALID_ROUTE);
+	} else {
+		rio_mport_write_config_32(mport, destid, hopcount,
+				SPP_ROUTE_CFG_DESTID(table), 0x80000000);
+		for (route_idx = 0; route_idx <= lut_size; route_idx++)
+			rio_mport_write_config_32(mport, destid, hopcount,
+				SPP_ROUTE_CFG_PORT(table) , RIO_INVALID_ROUTE);
+	}
+
+	return 0;
+}
+
+DECLARE_RIO_ROUTE_OPS(RIO_VID_TUNDRA, RIO_DID_TSI572, tsi57x_route_add_entry, tsi57x_route_get_entry, tsi57x_route_clr_table);
+DECLARE_RIO_ROUTE_OPS(RIO_VID_TUNDRA, RIO_DID_TSI574, tsi57x_route_add_entry, tsi57x_route_get_entry, tsi57x_route_clr_table);
+DECLARE_RIO_ROUTE_OPS(RIO_VID_TUNDRA, RIO_DID_TSI577, tsi57x_route_add_entry, tsi57x_route_get_entry, tsi57x_route_clr_table);
+DECLARE_RIO_ROUTE_OPS(RIO_VID_TUNDRA, RIO_DID_TSI578, tsi57x_route_add_entry, tsi57x_route_get_entry, tsi57x_route_clr_table);
diff -x '*.pj' -X dontdiff_2.6.32-rc5 -pNur w33r7c/include/linux/rio.h w33r7d/include/linux/rio.h
--- w33r7c/include/linux/rio.h	2010-02-06 17:17:12.000000000 -0500
+++ w33r7d/include/linux/rio.h	2010-02-22 11:06:24.105282000 -0500
@@ -213,6 +213,7 @@ struct rio_net {
  * @route_table: Copy of switch routing table
  * @add_entry: Callback for switch-specific route add function
  * @get_entry: Callback for switch-specific route get function
+ * @clr_table: Callback for switch-specific clear route table function
  */
 struct rio_switch {
 	struct list_head node;
@@ -224,6 +225,8 @@ struct rio_switch {
 			  u16 table, u16 route_destid, u8 route_port);
 	int (*get_entry) (struct rio_mport * mport, u16 destid, u8 hopcount,
 			  u16 table, u16 route_destid, u8 * route_port);
+	int (*clr_table) (struct rio_mport *mport, u16 destid, u8 hopcount,
+			  u16 table);
 };
 
 /* Low-level architecture-dependent routines */
@@ -307,6 +310,7 @@ struct rio_device_id {
  * @did: RIO device ID
  * @add_hook: Callback that adds a route entry
  * @get_hook: Callback that gets a route entry
+ * @clr_hook: Callback that clears a switch route table (may be NULL)
  *
  * Defines the operations that are necessary to manipulate the route
  * tables for a particular RIO switch device.
@@ -317,6 +321,8 @@ struct rio_route_ops {
 			 u16 table, u16 route_destid, u8 route_port);
 	int (*get_hook) (struct rio_mport * mport, u16 destid, u8 hopcount,
 			 u16 table, u16 route_destid, u8 * route_port);
+	int (*clr_hook) (struct rio_mport *mport, u16 destid, u8 hopcount,
+			 u16 table);
 };
 
 /* Architecture and hardware-specific functions */
diff -x '*.pj' -X dontdiff_2.6.32-rc5 -pNur w33r7c/include/linux/rio_ids.h w33r7d/include/linux/rio_ids.h
--- w33r7c/include/linux/rio_ids.h	2010-02-06 17:17:12.000000000 -0500
+++ w33r7d/include/linux/rio_ids.h	2010-02-22 11:06:24.241142000 -0500
@@ -20,5 +20,19 @@
 
 #define RIO_VID_TUNDRA			0x000d
 #define RIO_DID_TSI500			0x0500
+#define RIO_DID_TSI568			0x0568
+#define RIO_DID_TSI572			0x0572
+#define RIO_DID_TSI574			0x0574
+#define RIO_DID_TSI576			0x0578 /* Same ID as Tsi578 */
+#define RIO_DID_TSI577			0x0577
+#define RIO_DID_TSI578			0x0578
+
+#define RIO_VID_IDT			0x0038
+#define RIO_DID_IDT70K200		0x0310
+#define RIO_DID_IDTCPS8			0x035c
+#define RIO_DID_IDTCPS12		0x035d
+#define RIO_DID_IDTCPS16		0x035b
+#define RIO_DID_IDTCPS6Q		0x035f
+#define RIO_DID_IDTCPS10Q		0x035e
 
 #endif				/* LINUX_RIO_IDS_H */
diff -x '*.pj' -X dontdiff_2.6.32-rc5 -pNur w33r7c/include/linux/rio_regs.h w33r7d/include/linux/rio_regs.h
--- w33r7c/include/linux/rio_regs.h	2010-02-06 17:17:12.000000000 -0500
+++ w33r7d/include/linux/rio_regs.h	2010-02-22 11:06:24.248134000 -0500
@@ -39,6 +39,8 @@
 #define  RIO_PEF_INB_MBOX2		0x00200000	/* [II] Mailbox 2 */
 #define  RIO_PEF_INB_MBOX3		0x00100000	/* [II] Mailbox 3 */
 #define  RIO_PEF_INB_DOORBELL		0x00080000	/* [II] Doorbells */
+#define  RIO_PEF_EXT_RT			0x00000200	/* [III, 1.3] Extended route table support */
+#define  RIO_PEF_STD_RT			0x00000100	/* [III, 1.3] Standard route table support */
 #define  RIO_PEF_CTLS			0x00000010	/* [III] CTLS */
 #define  RIO_PEF_EXT_FEATURES		0x00000008	/* [I] EFT_PTR valid */
 #define  RIO_PEF_ADDR_66		0x00000004	/* [I] 66 bits */
@@ -91,7 +93,10 @@
 #define  RIO_OPS_ATOMIC_CLR		0x00000010	/* [I] Atomic clr op */
 #define  RIO_OPS_PORT_WRITE		0x00000004	/* [I] Port-write op */
 
-					/* 0x20-0x3c *//* Reserved */
+					/* 0x20-0x30 *//* Reserved */
+
+#define	RIO_SWITCH_RT_LIMIT	0x34	/* [III, 1.3] Switch Route Table Destination ID Limit CAR */
+#define	 RIO_RT_MAX_DESTID		0x0000ffff
 
 #define RIO_MBOX_CSR		0x40	/* [II] Mailbox CSR */
 #define  RIO_MBOX0_AVAIL		0x80000000	/* [II] Mbox 0 avail */
@@ -153,7 +158,11 @@
 #define RIO_HOST_DID_LOCK_CSR	0x68	/* [III] Host Base Device ID Lock CSR */
 #define RIO_COMPONENT_TAG_CSR	0x6c	/* [III] Component Tag CSR */
 
-					/* 0x70-0xf8 *//* Reserved */
+#define RIO_STD_RTE_CONF_DESTID_SEL_CSR	0x70
+#define RIO_STD_RTE_CONF_PORT_SEL_CSR	0x74
+#define RIO_STD_RTE_DEFAULT_PORT	0x78
+
+					/* 0x7c-0xf8 *//* Reserved */
 					/* 0x100-0xfff8 *//* [I] Extended Features Space */
 					/* 0x10000-0xfffff8 *//* [I] Implementation-defined Space */
 
@@ -186,6 +195,7 @@
 #define RIO_EFB_SER_EP_ID	0x0004	/* [VI] LP/Serial EP Devices */
 #define RIO_EFB_SER_EP_REC_ID	0x0005	/* [VI] LP/Serial EP Recovery Devices */
 #define RIO_EFB_SER_EP_FREE_ID	0x0006	/* [VI] LP/Serial EP Free Devices */
+#define RIO_EFB_SER_EP_FREC_ID	0x0009  /* [VI] LP/Serial EP Free Recovery Devices */
 
 /*
  * Physical 8/16 LP-LVDS

---

Important Notice: This message is intended for the use of the individual to whom it is addressed and may contain information which is privileged, confidential and/or exempt from disclosure under applicable law. If the reader of this message is not the intended recipient, or is not the employee or agent responsible for delivering the message to the intended recipient, you are hereby notified that any dissemination, distribution, or copying of this communication is strictly prohibited. If you have received this communication in error, please notify the sender immediately by telephone or return e-mail and delete the original message from your systems. Thank you. 

