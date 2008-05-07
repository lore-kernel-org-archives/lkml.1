Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYEGAnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYEGAnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 20:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbYEGAmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 20:42:52 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62961 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751318AbYEGAmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 20:42:51 -0400
Date: Wed, 7 May 2008 01:40:27 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Alessandro Zummo <a.zummo@towertech.it>, Jean Delvare <khali@linux-fr.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
cc: rtc-linux@googlegroups.com, i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 2/4] RTC: SWARM I2C board initialization
Message-ID: <Pine.LNX.4.55.0805070031410.16173@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The standard rtc-m41t80.c driver cannot be used with the SWARM as it is,
because the board does not provide setup information for the I2C core.  
As a result the bus and the address to probe for the M41T80 chip is not
known.

 Here is a set of changes that fix the problem:

1. i2c-swarm.c -- SWARM I2C board setup, currently for the M41T80 chip on 
   the bus #1 only.

2. The i2c-sibyte.c BCM1250A SMBus controller driver now registers its 
   buses as numbered so that board setup is correctly applied.  Plus minor 
   corrections.

3. SWARM platform library is now built as an object to include i2c-swarm.c 
   which is only used as an initcall and does not provide any symbols that 
   would pull the file from an archive.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-swarm-i2c-15
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/mips/Makefile linux-2.6.26-rc1-20080505/arch/mips/Makefile
--- linux-2.6.26-rc1-20080505.macro/arch/mips/Makefile	2008-05-05 02:55:23.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/mips/Makefile	2008-05-05 21:10:50.000000000 +0000
@@ -538,19 +538,19 @@ cflags-$(CONFIG_SIBYTE_BCM1x80)	+= -Iinc
 # Sibyte SWARM board
 # Sibyte BCM91x80 (BigSur) board
 #
-libs-$(CONFIG_SIBYTE_CARMEL)	+= arch/mips/sibyte/swarm/
+core-$(CONFIG_SIBYTE_CARMEL)	+= arch/mips/sibyte/swarm/
 load-$(CONFIG_SIBYTE_CARMEL)	:= 0xffffffff80100000
-libs-$(CONFIG_SIBYTE_CRHINE)	+= arch/mips/sibyte/swarm/
+core-$(CONFIG_SIBYTE_CRHINE)	+= arch/mips/sibyte/swarm/
 load-$(CONFIG_SIBYTE_CRHINE)	:= 0xffffffff80100000
-libs-$(CONFIG_SIBYTE_CRHONE)	+= arch/mips/sibyte/swarm/
+core-$(CONFIG_SIBYTE_CRHONE)	+= arch/mips/sibyte/swarm/
 load-$(CONFIG_SIBYTE_CRHONE)	:= 0xffffffff80100000
-libs-$(CONFIG_SIBYTE_RHONE)	+= arch/mips/sibyte/swarm/
+core-$(CONFIG_SIBYTE_RHONE)	+= arch/mips/sibyte/swarm/
 load-$(CONFIG_SIBYTE_RHONE)	:= 0xffffffff80100000
-libs-$(CONFIG_SIBYTE_SENTOSA)	+= arch/mips/sibyte/swarm/
+core-$(CONFIG_SIBYTE_SENTOSA)	+= arch/mips/sibyte/swarm/
 load-$(CONFIG_SIBYTE_SENTOSA)	:= 0xffffffff80100000
-libs-$(CONFIG_SIBYTE_SWARM)	+= arch/mips/sibyte/swarm/
+core-$(CONFIG_SIBYTE_SWARM)	+= arch/mips/sibyte/swarm/
 load-$(CONFIG_SIBYTE_SWARM)	:= 0xffffffff80100000
-libs-$(CONFIG_SIBYTE_BIGSUR)	+= arch/mips/sibyte/swarm/
+core-$(CONFIG_SIBYTE_BIGSUR)	+= arch/mips/sibyte/swarm/
 load-$(CONFIG_SIBYTE_BIGSUR)	:= 0xffffffff80100000
 
 #
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/mips/sibyte/swarm/Makefile linux-2.6.26-rc1-20080505/arch/mips/sibyte/swarm/Makefile
--- linux-2.6.26-rc1-20080505.macro/arch/mips/sibyte/swarm/Makefile	2004-01-29 04:57:05.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/mips/sibyte/swarm/Makefile	2008-05-06 01:18:21.000000000 +0000
@@ -1,3 +1,4 @@
-lib-y				= setup.o rtc_xicor1241.o rtc_m41t81.o
+obj-y				:= setup.o rtc_xicor1241.o rtc_m41t81.o
 
-lib-$(CONFIG_KGDB)		+= dbg_io.o
+obj-$(CONFIG_I2C_BOARDINFO)	+= i2c-swarm.o
+obj-$(CONFIG_KGDB)		+= dbg_io.o
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/mips/sibyte/swarm/i2c-swarm.c linux-2.6.26-rc1-20080505/arch/mips/sibyte/swarm/i2c-swarm.c
--- linux-2.6.26-rc1-20080505.macro/arch/mips/sibyte/swarm/i2c-swarm.c	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/mips/sibyte/swarm/i2c-swarm.c	2008-05-06 23:51:34.000000000 +0000
@@ -0,0 +1,37 @@
+/*
+ *	arch/mips/sibyte/swarm/i2c-swarm.c
+ *
+ *	Broadcom BCM91250A (SWARM), etc. I2C platform setup.
+ *
+ *	Copyright (c) 2008  Maciej W. Rozycki
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+
+
+static struct i2c_board_info swarm_i2c_info1[] __initdata = {
+	{
+		I2C_BOARD_INFO("m41t81", 0x68),
+	},
+};
+
+static int __init swarm_i2c_init(void)
+{
+	int err;
+
+	err = i2c_register_board_info(1, swarm_i2c_info1,
+				      ARRAY_SIZE(swarm_i2c_info1));
+	if (err < 0)
+		printk(KERN_ERR
+		       "i2c-swarm: cannot register board I2C devices\n");
+	return err;
+}
+
+arch_initcall(swarm_i2c_init);
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/drivers/i2c/busses/i2c-sibyte.c linux-2.6.26-rc1-20080505/drivers/i2c/busses/i2c-sibyte.c
--- linux-2.6.26-rc1-20080505.macro/drivers/i2c/busses/i2c-sibyte.c	2008-05-05 02:55:25.000000000 +0000
+++ linux-2.6.26-rc1-20080505/drivers/i2c/busses/i2c-sibyte.c	2008-05-06 23:45:32.000000000 +0000
@@ -2,6 +2,7 @@
  * Copyright (C) 2004 Steven J. Hill
  * Copyright (C) 2001,2002,2003 Broadcom Corporation
  * Copyright (C) 1995-2000 Simon G. Vogl
+ * Copyright (C) 2008  Maciej W. Rozycki
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -132,18 +133,18 @@ static const struct i2c_algorithm i2c_si
 /*
  * registering functions to load algorithms at runtime
  */
-int __init i2c_sibyte_add_bus(struct i2c_adapter *i2c_adap, int speed)
+static int __init i2c_sibyte_add_bus(struct i2c_adapter *i2c_adap, int speed)
 {
 	struct i2c_algo_sibyte_data *adap = i2c_adap->algo_data;
 
-	/* register new adapter to i2c module... */
+	/* Register new adapter to i2c module...  */
 	i2c_adap->algo = &i2c_sibyte_algo;
 
-	/* Set the frequency to 100 kHz */
+	/* Set the requested frequency.  */
 	csr_out32(speed, SMB_CSR(adap,R_SMB_FREQ));
 	csr_out32(0, SMB_CSR(adap,R_SMB_CONTROL));
 
-	return i2c_add_adapter(i2c_adap);
+	return i2c_add_numbered_adapter(i2c_adap);
 }
 
 
@@ -159,6 +160,7 @@ static struct i2c_adapter sibyte_board_a
 		.class		= I2C_CLASS_HWMON,
 		.algo		= NULL,
 		.algo_data	= &sibyte_board_data[0],
+		.nr		= 0,
 		.name		= "SiByte SMBus 0",
 	},
 	{
@@ -167,6 +169,7 @@ static struct i2c_adapter sibyte_board_a
 		.class		= I2C_CLASS_HWMON,
 		.algo		= NULL,
 		.algo_data	= &sibyte_board_data[1],
+		.nr		= 1,
 		.name		= "SiByte SMBus 1",
 	},
 };
