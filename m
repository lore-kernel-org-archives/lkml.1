Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbYEGAoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbYEGAoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 20:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756001AbYEGAnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 20:43:04 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62965 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755190AbYEGAnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 20:43:00 -0400
Date: Wed, 7 May 2008 01:40:35 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Alessandro Zummo <a.zummo@towertech.it>, Jean Delvare <khali@linux-fr.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
cc: rtc-linux@googlegroups.com, i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 3/4] RTC: SWARM class device persistent clock support
Message-ID: <Pine.LNX.4.55.0805070054440.16173@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This is a set of changes removing the SWARM platform driver for the
M41T81 and "wiring" the class RTC driver for the persistent clock instead.  
The Xicor clock is unaffected as we have no class driver for this device.
Weak variations of the rtc_read_persistent_clock() and 
rtc_update_persistent_clock() calls are provided as the default -- to be 
overridden by the RTC driver.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 If there is interest and a volunteer to test changes is found, then I can
write a driver for the Xicor clock to complement this change and tidy up.  
It would however require substantial changes to the I2C core as it uses
16-bit commands and an extended SMBus mode of operation of the BCM1250A
controller would have to be used.

 Please note this patch trivially depends on
patch-2.6.26-rc1-20080505-swarm-i2c-15 -- 2/4 of this set.

  Maciej

patch-2.6.26-rc1-20080505-swarm-m41t80-11
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/mips/kernel/time.c linux-2.6.26-rc1-20080505/arch/mips/kernel/time.c
--- linux-2.6.26-rc1-20080505.macro/arch/mips/kernel/time.c	2008-05-05 02:55:23.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/mips/kernel/time.c	2008-05-05 21:10:50.000000000 +0000
@@ -44,7 +44,7 @@ int __weak rtc_mips_set_mmss(unsigned lo
 	return rtc_mips_set_time(nowtime);
 }
 
-int update_persistent_clock(struct timespec now)
+int __weak update_persistent_clock(struct timespec now)
 {
 	return rtc_mips_set_mmss(now.tv_sec);
 }
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/mips/sibyte/swarm/Makefile linux-2.6.26-rc1-20080505/arch/mips/sibyte/swarm/Makefile
--- linux-2.6.26-rc1-20080505.macro/arch/mips/sibyte/swarm/Makefile	2008-05-06 01:18:21.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/mips/sibyte/swarm/Makefile	2008-05-06 01:25:40.000000000 +0000
@@ -1,4 +1,4 @@
-obj-y				:= setup.o rtc_xicor1241.o rtc_m41t81.o
+obj-y				:= setup.o rtc_xicor1241.o
 
 obj-$(CONFIG_I2C_BOARDINFO)	+= i2c-swarm.o
 obj-$(CONFIG_KGDB)		+= dbg_io.o
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/mips/sibyte/swarm/rtc_m41t81.c linux-2.6.26-rc1-20080505/arch/mips/sibyte/swarm/rtc_m41t81.c
--- linux-2.6.26-rc1-20080505.macro/arch/mips/sibyte/swarm/rtc_m41t81.c	2007-10-11 04:56:52.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/mips/sibyte/swarm/rtc_m41t81.c	1970-01-01 00:00:00.000000000 +0000
@@ -1,233 +0,0 @@
-/*
- * Copyright (C) 2000, 2001 Broadcom Corporation
- *
- * Copyright (C) 2002 MontaVista Software Inc.
- * Author: jsun@mvista.com or jsun@junsun.net
- *
- * This program is free software; you can redistribute	it and/or modify it
- * under  the terms of	the GNU General	 Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- *
- */
-#include <linux/bcd.h>
-#include <linux/types.h>
-#include <linux/time.h>
-
-#include <asm/time.h>
-#include <asm/addrspace.h>
-#include <asm/io.h>
-
-#include <asm/sibyte/sb1250.h>
-#include <asm/sibyte/sb1250_regs.h>
-#include <asm/sibyte/sb1250_smbus.h>
-
-
-/* M41T81 definitions */
-
-/*
- * Register bits
- */
-
-#define M41T81REG_SC_ST		0x80		/* stop bit */
-#define M41T81REG_HR_CB		0x40		/* century bit */
-#define M41T81REG_HR_CEB	0x80		/* century enable bit */
-#define M41T81REG_CTL_S		0x20		/* sign bit */
-#define M41T81REG_CTL_FT	0x40		/* frequency test bit */
-#define M41T81REG_CTL_OUT	0x80		/* output level */
-#define M41T81REG_WD_RB0	0x01		/* watchdog resolution bit 0 */
-#define M41T81REG_WD_RB1	0x02		/* watchdog resolution bit 1 */
-#define M41T81REG_WD_BMB0	0x04		/* watchdog multiplier bit 0 */
-#define M41T81REG_WD_BMB1	0x08		/* watchdog multiplier bit 1 */
-#define M41T81REG_WD_BMB2	0x10		/* watchdog multiplier bit 2 */
-#define M41T81REG_WD_BMB3	0x20		/* watchdog multiplier bit 3 */
-#define M41T81REG_WD_BMB4	0x40		/* watchdog multiplier bit 4 */
-#define M41T81REG_AMO_ABE	0x20		/* alarm in "battery back-up mode" enable bit */
-#define M41T81REG_AMO_SQWE	0x40		/* square wave enable */
-#define M41T81REG_AMO_AFE	0x80		/* alarm flag enable flag */
-#define M41T81REG_ADT_RPT5	0x40		/* alarm repeat mode bit 5 */
-#define M41T81REG_ADT_RPT4	0x80		/* alarm repeat mode bit 4 */
-#define M41T81REG_AHR_RPT3	0x80		/* alarm repeat mode bit 3 */
-#define M41T81REG_AHR_HT	0x40		/* halt update bit */
-#define M41T81REG_AMN_RPT2	0x80		/* alarm repeat mode bit 2 */
-#define M41T81REG_ASC_RPT1	0x80		/* alarm repeat mode bit 1 */
-#define M41T81REG_FLG_AF	0x40		/* alarm flag (read only) */
-#define M41T81REG_FLG_WDF	0x80		/* watchdog flag (read only) */
-#define M41T81REG_SQW_RS0	0x10		/* sqw frequency bit 0 */
-#define M41T81REG_SQW_RS1	0x20		/* sqw frequency bit 1 */
-#define M41T81REG_SQW_RS2	0x40		/* sqw frequency bit 2 */
-#define M41T81REG_SQW_RS3	0x80		/* sqw frequency bit 3 */
-
-
-/*
- * Register numbers
- */
-
-#define M41T81REG_TSC	0x00		/* tenths/hundredths of second */
-#define M41T81REG_SC	0x01		/* seconds */
-#define M41T81REG_MN	0x02		/* minute */
-#define M41T81REG_HR	0x03		/* hour/century */
-#define M41T81REG_DY	0x04		/* day of week */
-#define M41T81REG_DT	0x05		/* date of month */
-#define M41T81REG_MO	0x06		/* month */
-#define M41T81REG_YR	0x07		/* year */
-#define M41T81REG_CTL	0x08		/* control */
-#define M41T81REG_WD	0x09		/* watchdog */
-#define M41T81REG_AMO	0x0A		/* alarm: month */
-#define M41T81REG_ADT	0x0B		/* alarm: date */
-#define M41T81REG_AHR	0x0C		/* alarm: hour */
-#define M41T81REG_AMN	0x0D		/* alarm: minute */
-#define M41T81REG_ASC	0x0E		/* alarm: second */
-#define M41T81REG_FLG	0x0F		/* flags */
-#define M41T81REG_SQW	0x13		/* square wave register */
-
-#define M41T81_CCR_ADDRESS	0x68
-
-#define SMB_CSR(reg)	IOADDR(A_SMB_REGISTER(1, reg))
-
-static int m41t81_read(uint8_t addr)
-{
-	while (__raw_readq(SMB_CSR(R_SMB_STATUS)) & M_SMB_BUSY)
-		;
-
-	__raw_writeq(addr & 0xff, SMB_CSR(R_SMB_CMD));
-	__raw_writeq(V_SMB_ADDR(M41T81_CCR_ADDRESS) | V_SMB_TT_WR1BYTE,
-		     SMB_CSR(R_SMB_START));
-
-	while (__raw_readq(SMB_CSR(R_SMB_STATUS)) & M_SMB_BUSY)
-		;
-
-	__raw_writeq(V_SMB_ADDR(M41T81_CCR_ADDRESS) | V_SMB_TT_RD1BYTE,
-		     SMB_CSR(R_SMB_START));
-
-	while (__raw_readq(SMB_CSR(R_SMB_STATUS)) & M_SMB_BUSY)
-		;
-
-	if (__raw_readq(SMB_CSR(R_SMB_STATUS)) & M_SMB_ERROR) {
-		/* Clear error bit by writing a 1 */
-		__raw_writeq(M_SMB_ERROR, SMB_CSR(R_SMB_STATUS));
-		return -1;
-	}
-
-	return (__raw_readq(SMB_CSR(R_SMB_DATA)) & 0xff);
-}
-
-static int m41t81_write(uint8_t addr, int b)
-{
-	while (__raw_readq(SMB_CSR(R_SMB_STATUS)) & M_SMB_BUSY)
-		;
-
-	__raw_writeq(addr & 0xff, SMB_CSR(R_SMB_CMD));
-	__raw_writeq(b & 0xff, SMB_CSR(R_SMB_DATA));
-	__raw_writeq(V_SMB_ADDR(M41T81_CCR_ADDRESS) | V_SMB_TT_WR2BYTE,
-		     SMB_CSR(R_SMB_START));
-
-	while (__raw_readq(SMB_CSR(R_SMB_STATUS)) & M_SMB_BUSY)
-		;
-
-	if (__raw_readq(SMB_CSR(R_SMB_STATUS)) & M_SMB_ERROR) {
-		/* Clear error bit by writing a 1 */
-		__raw_writeq(M_SMB_ERROR, SMB_CSR(R_SMB_STATUS));
-		return -1;
-	}
-
-	/* read the same byte again to make sure it is written */
-	__raw_writeq(V_SMB_ADDR(M41T81_CCR_ADDRESS) | V_SMB_TT_RD1BYTE,
-		     SMB_CSR(R_SMB_START));
-
-	while (__raw_readq(SMB_CSR(R_SMB_STATUS)) & M_SMB_BUSY)
-		;
-
-	return 0;
-}
-
-int m41t81_set_time(unsigned long t)
-{
-	struct rtc_time tm;
-	unsigned long flags;
-
-	/* Note we don't care about the century */
-	rtc_time_to_tm(t, &tm);
-
-	/*
-	 * Note the write order matters as it ensures the correctness.
-	 * When we write sec, 10th sec is clear.  It is reasonable to
-	 * believe we should finish writing min within a second.
-	 */
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	tm.tm_sec = BIN2BCD(tm.tm_sec);
-	m41t81_write(M41T81REG_SC, tm.tm_sec);
-
-	tm.tm_min = BIN2BCD(tm.tm_min);
-	m41t81_write(M41T81REG_MN, tm.tm_min);
-
-	tm.tm_hour = BIN2BCD(tm.tm_hour);
-	tm.tm_hour = (tm.tm_hour & 0x3f) | (m41t81_read(M41T81REG_HR) & 0xc0);
-	m41t81_write(M41T81REG_HR, tm.tm_hour);
-
-	/* tm_wday starts from 0 to 6 */
-	if (tm.tm_wday == 0) tm.tm_wday = 7;
-	tm.tm_wday = BIN2BCD(tm.tm_wday);
-	m41t81_write(M41T81REG_DY, tm.tm_wday);
-
-	tm.tm_mday = BIN2BCD(tm.tm_mday);
-	m41t81_write(M41T81REG_DT, tm.tm_mday);
-
-	/* tm_mon starts from 0, *ick* */
-	tm.tm_mon ++;
-	tm.tm_mon = BIN2BCD(tm.tm_mon);
-	m41t81_write(M41T81REG_MO, tm.tm_mon);
-
-	/* we don't do century, everything is beyond 2000 */
-	tm.tm_year %= 100;
-	tm.tm_year = BIN2BCD(tm.tm_year);
-	m41t81_write(M41T81REG_YR, tm.tm_year);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-
-	return 0;
-}
-
-unsigned long m41t81_get_time(void)
-{
-	unsigned int year, mon, day, hour, min, sec;
-	unsigned long flags;
-
-	/*
-	 * min is valid if two reads of sec are the same.
-	 */
-	for (;;) {
-		spin_lock_irqsave(&rtc_lock, flags);
-		sec = m41t81_read(M41T81REG_SC);
-		min = m41t81_read(M41T81REG_MN);
-		if (sec == m41t81_read(M41T81REG_SC)) break;
-		spin_unlock_irqrestore(&rtc_lock, flags);
-	}
-	hour = m41t81_read(M41T81REG_HR) & 0x3f;
-	day = m41t81_read(M41T81REG_DT);
-	mon = m41t81_read(M41T81REG_MO);
-	year = m41t81_read(M41T81REG_YR);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-
-	sec = BCD2BIN(sec);
-	min = BCD2BIN(min);
-	hour = BCD2BIN(hour);
-	day = BCD2BIN(day);
-	mon = BCD2BIN(mon);
-	year = BCD2BIN(year);
-
-	year += 2000;
-
-	return mktime(year, mon, day, hour, min, sec);
-}
-
-int m41t81_probe(void)
-{
-	unsigned int tmp;
-
-	/* enable chip if it is not enabled yet */
-	tmp = m41t81_read(M41T81REG_SC);
-	m41t81_write(M41T81REG_SC, tmp & 0x7f);
-
-	return (m41t81_read(M41T81REG_SC) != -1);
-}
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/mips/sibyte/swarm/setup.c linux-2.6.26-rc1-20080505/arch/mips/sibyte/swarm/setup.c
--- linux-2.6.26-rc1-20080505.macro/arch/mips/sibyte/swarm/setup.c	2007-10-23 02:55:20.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/mips/sibyte/swarm/setup.c	2008-05-05 21:10:50.000000000 +0000
@@ -1,6 +1,7 @@
 /*
  * Copyright (C) 2000, 2001, 2002, 2003, 2004 Broadcom Corporation
  * Copyright (C) 2004 by Ralf Baechle (ralf@linux-mips.org)
+ * Copyright (C) 2008  Maciej W. Rozycki
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -29,6 +30,7 @@
 #include <linux/kernel.h>
 #include <linux/screen_info.h>
 #include <linux/initrd.h>
+#include <linux/rtc.h>
 
 #include <asm/irq.h>
 #include <asm/io.h>
@@ -60,10 +62,6 @@ extern int xicor_probe(void);
 extern int xicor_set_time(unsigned long);
 extern unsigned long xicor_get_time(void);
 
-extern int m41t81_probe(void);
-extern int m41t81_set_time(unsigned long);
-extern unsigned long m41t81_get_time(void);
-
 const char *get_system_type(void)
 {
 	return "SiByte " SIBYTE_BOARD_NAME;
@@ -82,38 +80,41 @@ int swarm_be_handler(struct pt_regs *reg
 enum swarm_rtc_type {
 	RTC_NONE,
 	RTC_XICOR,
-	RTC_M4LT81
 };
 
 enum swarm_rtc_type swarm_rtc_type;
 
+unsigned long __weak rtc_read_persistent_clock(void)
+{
+	return mktime(2000, 1, 1, 0, 0, 0);
+}
+
+int __weak rtc_update_persistent_clock(struct timespec now)
+{
+	return 0;
+}
+
 unsigned long read_persistent_clock(void)
 {
 	switch (swarm_rtc_type) {
 	case RTC_XICOR:
 		return xicor_get_time();
 
-	case RTC_M4LT81:
-		return m41t81_get_time();
-
 	case RTC_NONE:
 	default:
-		return mktime(2000, 1, 1, 0, 0, 0);
+		return rtc_read_persistent_clock();
 	}
 }
 
-int rtc_mips_set_time(unsigned long sec)
+int update_persistent_clock(struct timespec now)
 {
 	switch (swarm_rtc_type) {
 	case RTC_XICOR:
-		return xicor_set_time(sec);
-
-	case RTC_M4LT81:
-		return m41t81_set_time(sec);
+		return xicor_set_time(now.tv_sec);
 
 	case RTC_NONE:
 	default:
-		return -1;
+		return rtc_update_persistent_clock(now);
 	}
 }
 
@@ -133,8 +134,6 @@ void __init plat_mem_setup(void)
 
 	if (xicor_probe())
 		swarm_rtc_type = RTC_XICOR;
-	if (m41t81_probe())
-		swarm_rtc_type = RTC_M4LT81;
 
 	printk("This kernel optimized for "
 #ifdef CONFIG_SIMULATION
