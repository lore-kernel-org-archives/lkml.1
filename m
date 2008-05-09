Return-Path: <linux-kernel-owner+w=401wt.eu-S934638AbYEIAtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934638AbYEIAtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 20:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756162AbYEIAtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 20:49:42 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:65072 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755633AbYEIAtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 20:49:39 -0400
Date: Fri, 9 May 2008 01:43:32 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: David Brownell <david-b@pacbell.net>
cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, ab@mycable.de, mgreer@mvista.com,
       i2c@lm-sensors.org, rtc-linux@googlegroups.com,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 4/4] RTC: SMBus support for the M41T80,
In-Reply-To: <200805071625.20430.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.55.0805080306080.32613@cliff.in.clinika.pl>
References: <200805070120.03821.david-b@pacbell.net>
 <Pine.LNX.4.55.0805072226180.25644@cliff.in.clinika.pl>
 <200805071625.20430.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

 Please do not remove other lists cc-ed as there are people interested in 
this piece of hardware who are neither on i2c nor on rtc-linux (I am on 
neither of the lists too).

> >  Do you mean our generic I2C code emulates SMBus calls if the hardware
> > does not support them directly?  Well, it looks to me it indeed does and
> > you are right, but I have assumed, perhaps mistakenly, (but I generally
> > trust if a piece of code is there, it is for a reason), that this driver
> > checks for I2C_FUNC_SMBUS_BYTE_DATA for a purpose.
> 
> That purpose being:  it makes those SMBus calls explicitly.
> (And it makes i2c_transfer calls explicitly too...)

 Then, given the emulation, the client should be satisfied with either of
the flags instead of both at a time.  Exactly how I changed it.

> > The extensions are 16-bit commands 
> > (required by another RTC chip used on some of these boards) and an obscure
> > subset of the process call and block read/write commands (called an EEPROM
> > read and an extended write/read, respectively).
> 
> Subset of process call??  That's send-three-bytes, receive-two-bytes.
> Not possible to subset it ... anything else isn't a process call!!

 I misinterpreted the SMBus spec -- I have thought the receive part is
variable, sorry.  The controller implements a command which issues a write
byte transfer followed by a receive four bytes transfer.  Not quite a
process call although the idea is the same.

> Presumably those block read/write commands aren't quite enough
> for you to implement i2c_smbus_read_i2c_block_data() and friend?

 You can issue a block read of up to 5 bytes (6 if you add the PEC byte
which is not interpreted by the controller in any way).  And you can issue
a block write of up to 4 bytes (5 with PEC).  That's clearly not enough
for the m41t81 let alone a generic implementation.

 But as Atsushi-san pointed out, the block transfer transactions
implemented by the M41T81 do not quite follow the rules of SMBus block
transfers, so the call is out of question -- either i2c_transfer() or a
sequence of byte transactions have to be used.

> >  I feel a bit uneasy about unconditional emulation of SMBus block calls
> > with a series of corresponding byte read/write calls.  The reason is it
> > changes the semantics
> 
> No it doesn't.  The I2C signal transitions (SCL/SDA) will be
> exactly the same.  It's IMO very misleading to call it "emulation"
> since it's nothing more than a different software interface to
> the same functionality.

 It is not the same.  Assuming a write for a block transfer you have:

start:address:ack:command:ack:data:ack:data:ack:data:ack...stop

on the wire while for a series of byte calls you have:

start:address:ack:command:ack:data:ack:stop:start:address:ack:command:ack:data:ack:stop:start:address:ack:command:ack:data:ack...stop

This is what I mean here -- I gather you are thinking in the terms of raw 
I2C block vs SMBus block transfer.

> > Admittedly in this case the effect 
> > of the difference can be eliminated by rereading the least significant 
> > part of the timestamp considered, but it cannot be universally guaranteed.  
> > Which is why I would prefer not to hide these details behind an interface.
> 
> That would be internal to the m41t80 driver, not part of the
> i2c core.  (As your patch already does ...)

 It could be useful enough for other drivers to have the emulated calls 
available as a part of the API.  No need to rush adding that though 
obviously -- we can wait till we have a user (now that this driver has 
been ruled out).

> >  I think a pair of functions called i2c_smbus_read_i2c_byte_data() and
> > i2c_smbus_write_i2c_byte_data() could be added to the core though.
> 
> Too late.  Those calls have been in the I2C core for a long
> time now.  ;)

 A mental shortcut, sorry.  I meant these functions would perform block
transfers internally either by calling
i2c_smbus_xfer(I2C_SMBUS_I2C_BLOCK_DATA)/i2c_transfer() or, if neither
supported by a given controller, by performing an appropriate sequence of
i2c_smbus_xfer(I2C_SMBUS_BYTE_DATA) calls.

> > Their 
> > implementations might choose either byte or block transfers as available
> > within a given SMBus controller and they could be used by drivers known
> > for sure not to care about which kind of the transfers is uses (either
> > because the relevant piece of hardware does not care or because the driver
> > caters for either scenario).  What do you think?
> 
> You shouldn't think about changing the i2c core for that.

 It would not be a great idea to have the same piece of code duplicated in 
all the client drivers needing it, but we can certainly wait with that -- 
see above.

> >  BTW, as mentioned elsewhere the SMBus controller of the BCM1250A SOC can
> > be switched into a bit-banged raw I2C mode, where you can send whatever
> > you want over the bus and block tranfers would not be a problem at all,
> > but hopefully you agree this is not necessarily the best idea ever.
> 
> Between two drivers that both busy-wait and burn CPU cycles, I'd
> much rather have the one that provides the full functionality
> needed for the bus.  So I'd choose that bitbanger, no question.

 I suppose some care would have to be taken with the bit-banger so that 
the clock's frequency is not a complex function of time on its own.  Which 
means interrupts disabled, etc.

> If the SMBus driver were more functional, AND didn't busy-wait,
> then I'd consider using the native hardware.

 Oh, that can be rectified, no problem.  The controller does have
interrupt outputs that can be asserted on the busy-to-non-busy transition
as well as an error.  There is one per each of the two buses.  Plus the
silicon will retry aborted transfers itself up to 15 times before it gives
up with an error.  I can prepare a separate patch to address this issue --
I hate these devices operating in a polled manner unnecessarily too.

 BTW, the SOC has enough internal interrupt sources you can almost assume
if anything looks remotely like being able to make reasonable use of an
interrupt line it most likely has one.  It's somewhat worse outside the
SOC on this particular board -- to the best of my knowledge, the M41T81's
interrupt output is unfortunately not routed anywhere -- otherwise it's
alarm feature could be reasonably utilised; perhaps the periodic interrupt
as well.

 The reason is probably they did run out of external interrupt inputs --
of all the 16 allocatable GPIO lines, 10 are taken by a PCMCIA interface
and 2 are used for outputs.  The remaining four are actually used as
interrupts, but all taken by other devices.  There are some 16 (IIRC)  
unused interrupt inputs in the HT-PCI bridge, but that bridge was made by
some other company Broadcom might have not wanted to support too
aggresively. ;-)

 Here is a new version of the patch.  I hope I have addressed all your
concerns, but I am officially dead at the moment, so please do not disturb
me until this is no longer the case.

  Maciej

patch-2.6.26-rc1-20080505-m41t80-smbus-13
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/drivers/rtc/rtc-m41t80.c linux-2.6.26-rc1-20080505/drivers/rtc/rtc-m41t80.c
--- linux-2.6.26-rc1-20080505.macro/drivers/rtc/rtc-m41t80.c	2008-05-05 02:55:40.000000000 +0000
+++ linux-2.6.26-rc1-20080505/drivers/rtc/rtc-m41t80.c	2008-05-09 00:32:39.000000000 +0000
@@ -6,6 +6,8 @@
  * Based on m41t00.c by Mark A. Greer <mgreer@mvista.com>
  *
  * 2006 (c) mycable GmbH
+ * Copyright (c) 2008  Maciej W. Rozycki
+ * Copyright (c) 2008  Atsushi Nemoto
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -15,6 +17,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/i2c.h>
@@ -36,6 +39,8 @@
 #define M41T80_REG_DAY	5
 #define M41T80_REG_MON	6
 #define M41T80_REG_YEAR	7
+#define M41T80_REG_CONTROL	8
+#define M41T80_REG_WATCHDOG	9
 #define M41T80_REG_ALARM_MON	0xa
 #define M41T80_REG_ALARM_DAY	0xb
 #define M41T80_REG_ALARM_HOUR	0xc
@@ -58,7 +63,7 @@
 #define M41T80_FEATURE_HT	(1 << 0)
 #define M41T80_FEATURE_BL	(1 << 1)
 
-#define DRV_VERSION "0.05"
+#define DRV_VERSION "0.06"
 
 static const struct i2c_device_id m41t80_id[] = {
 	{ "m41t80", 0 },
@@ -78,31 +83,104 @@ struct m41t80_data {
 	struct rtc_device *rtc;
 };
 
-static int m41t80_get_datetime(struct i2c_client *client,
-			       struct rtc_time *tm)
+
+static int m41t80_i2c_write(struct i2c_client *client, u8 reg, u8 num, u8 *buf)
+{
+	u8 wbuf[num + 1];
+	struct i2c_msg msgs[] = {
+		{
+			.addr	= client->addr,
+			.flags	= 0,
+			.len	= num + 1,
+			.buf	= wbuf,
+		},
+	};
+
+	wbuf[0] = reg;
+	memcpy(wbuf + 1, buf, num);
+	return i2c_transfer(client->adapter, msgs, 1);
+}
+
+static int m41t80_i2c_read(struct i2c_client *client, u8 reg, u8 num, u8 *buf)
 {
-	u8 buf[M41T80_DATETIME_REG_SIZE], dt_addr[1] = { M41T80_REG_SEC };
 	struct i2c_msg msgs[] = {
 		{
 			.addr	= client->addr,
 			.flags	= 0,
 			.len	= 1,
-			.buf	= dt_addr,
+			.buf	= &reg,
 		},
 		{
 			.addr	= client->addr,
 			.flags	= I2C_M_RD,
-			.len	= M41T80_DATETIME_REG_SIZE - M41T80_REG_SEC,
-			.buf	= buf + M41T80_REG_SEC,
+			.len	= num,
+			.buf	= buf,
 		},
 	};
 
-	if (i2c_transfer(client->adapter, msgs, 2) < 0) {
-		dev_err(&client->dev, "read error\n");
-		return -EIO;
-	}
+	return i2c_transfer(client->adapter, msgs, 2);
+}
+
+static int m41t80_transfer(struct i2c_client *client, int write,
+			   u8 reg, u8 num, u8 *buf)
+{
+	int i, rc;
+
+	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		if (write)
+			i = m41t80_i2c_write(client, reg, num, buf);
+		else
+			i = m41t80_i2c_read(client, reg, num, buf);
+	} else {
+		if (write)
+			for (i = 0; i < num; i++) {
+				rc = i2c_smbus_write_byte_data(client, reg + i,
+							       buf[i]);
+				if (rc < 0)
+					return rc;
+			}
+		else
+			for (i = 0; i < num; i++) {
+				rc = i2c_smbus_read_byte_data(client, reg + i);
+				if (rc < 0)
+					return rc;
+				buf[i] = rc;
+			}
+	}
+	return i;
+}
+
+static int m41t80_get_datetime(struct i2c_client *client, struct rtc_time *tm)
+{
+	u8 buf[M41T80_DATETIME_REG_SIZE];
+	int loops = 2;
+	int sec0, sec1;
+
+	/*
+	 * Time registers are latched by this chip if an I2C block
+	 * transfer is used, but with SMBus-style byte accesses
+	 * this is not the case, so check seconds for a wraparound.
+	 */
+	do {
+		if (m41t80_transfer(client, 0, M41T80_REG_SEC,
+				    M41T80_DATETIME_REG_SIZE - M41T80_REG_SEC,
+				    buf + M41T80_REG_SEC) < 0) {
+			dev_err(&client->dev, "read error\n");
+			return -EIO;
+		}
+		sec0 = buf[M41T80_REG_SEC];
+
+		sec1 = i2c_smbus_read_byte_data(client, M41T80_REG_SEC);
+		if (sec1 < 0) {
+			dev_err(&client->dev, "read error\n");
+			return -EIO;
+		}
+
+		sec0 = BCD2BIN(sec0 & 0x7f);
+		sec1 = BCD2BIN(sec1 & 0x7f);
+	} while (sec1 < sec0 && --loops);
 
-	tm->tm_sec = BCD2BIN(buf[M41T80_REG_SEC] & 0x7f);
+	tm->tm_sec = sec1;
 	tm->tm_min = BCD2BIN(buf[M41T80_REG_MIN] & 0x7f);
 	tm->tm_hour = BCD2BIN(buf[M41T80_REG_HOUR] & 0x3f);
 	tm->tm_mday = BCD2BIN(buf[M41T80_REG_DAY] & 0x3f);
@@ -117,39 +195,16 @@ static int m41t80_get_datetime(struct i2
 /* Sets the given date and time to the real time clock. */
 static int m41t80_set_datetime(struct i2c_client *client, struct rtc_time *tm)
 {
-	u8 wbuf[1 + M41T80_DATETIME_REG_SIZE];
-	u8 *buf = &wbuf[1];
-	u8 dt_addr[1] = { M41T80_REG_SEC };
-	struct i2c_msg msgs_in[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1,
-			.buf	= dt_addr,
-		},
-		{
-			.addr	= client->addr,
-			.flags	= I2C_M_RD,
-			.len	= M41T80_DATETIME_REG_SIZE - M41T80_REG_SEC,
-			.buf	= buf + M41T80_REG_SEC,
-		},
-	};
-	struct i2c_msg msgs[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1 + M41T80_DATETIME_REG_SIZE,
-			.buf	= wbuf,
-		 },
-	};
+	u8 buf[M41T80_DATETIME_REG_SIZE];
 
 	/* Read current reg values into buf[1..7] */
-	if (i2c_transfer(client->adapter, msgs_in, 2) < 0) {
+	if (m41t80_transfer(client, 0, M41T80_REG_SEC,
+			    M41T80_DATETIME_REG_SIZE - M41T80_REG_SEC,
+			    buf + M41T80_REG_SEC) < 0) {
 		dev_err(&client->dev, "read error\n");
 		return -EIO;
 	}
 
-	wbuf[0] = 0; /* offset into rtc's regs */
 	/* Merge time-data and register flags into buf[0..7] */
 	buf[M41T80_REG_SSEC] = 0;
 	buf[M41T80_REG_SEC] =
@@ -167,7 +222,8 @@ static int m41t80_set_datetime(struct i2
 	/* assume 20YY not 19YY */
 	buf[M41T80_REG_YEAR] = BIN2BCD(tm->tm_year % 100);
 
-	if (i2c_transfer(client->adapter, msgs, 1) != 1) {
+	if (m41t80_transfer(client, 1, M41T80_REG_SSEC,
+			    M41T80_DATETIME_REG_SIZE, buf) < 0) {
 		dev_err(&client->dev, "write error\n");
 		return -EIO;
 	}
@@ -241,34 +297,11 @@ err:
 static int m41t80_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	u8 wbuf[1 + M41T80_ALARM_REG_SIZE];
-	u8 *buf = &wbuf[1];
+	u8 buf[M41T80_ALARM_REG_SIZE];
 	u8 *reg = buf - M41T80_REG_ALARM_MON;
-	u8 dt_addr[1] = { M41T80_REG_ALARM_MON };
-	struct i2c_msg msgs_in[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1,
-			.buf	= dt_addr,
-		},
-		{
-			.addr	= client->addr,
-			.flags	= I2C_M_RD,
-			.len	= M41T80_ALARM_REG_SIZE,
-			.buf	= buf,
-		},
-	};
-	struct i2c_msg msgs[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1 + M41T80_ALARM_REG_SIZE,
-			.buf	= wbuf,
-		 },
-	};
 
-	if (i2c_transfer(client->adapter, msgs_in, 2) < 0) {
+	if (m41t80_transfer(client, 0, M41T80_REG_ALARM_MON,
+			    M41T80_ALARM_REG_SIZE, buf) < 0) {
 		dev_err(&client->dev, "read error\n");
 		return -EIO;
 	}
@@ -278,7 +311,6 @@ static int m41t80_rtc_set_alarm(struct d
 	reg[M41T80_REG_ALARM_MIN] = 0;
 	reg[M41T80_REG_ALARM_SEC] = 0;
 
-	wbuf[0] = M41T80_REG_ALARM_MON; /* offset into rtc's regs */
 	reg[M41T80_REG_ALARM_SEC] |= t->time.tm_sec >= 0 ?
 		BIN2BCD(t->time.tm_sec) : 0x80;
 	reg[M41T80_REG_ALARM_MIN] |= t->time.tm_min >= 0 ?
@@ -292,7 +324,8 @@ static int m41t80_rtc_set_alarm(struct d
 	else
 		reg[M41T80_REG_ALARM_DAY] |= 0x40;
 
-	if (i2c_transfer(client->adapter, msgs, 1) != 1) {
+	if (m41t80_transfer(client, 1, M41T80_REG_ALARM_MON,
+			    M41T80_ALARM_REG_SIZE, buf) < 0) {
 		dev_err(&client->dev, "write error\n");
 		return -EIO;
 	}
@@ -311,25 +344,11 @@ static int m41t80_rtc_set_alarm(struct d
 static int m41t80_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	u8 buf[M41T80_ALARM_REG_SIZE + 1]; /* all alarm regs and flags */
-	u8 dt_addr[1] = { M41T80_REG_ALARM_MON };
+	u8 buf[M41T80_ALARM_REG_SIZE + 1];	/* all alarm regs and flags */
 	u8 *reg = buf - M41T80_REG_ALARM_MON;
-	struct i2c_msg msgs[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1,
-			.buf	= dt_addr,
-		},
-		{
-			.addr	= client->addr,
-			.flags	= I2C_M_RD,
-			.len	= M41T80_ALARM_REG_SIZE + 1,
-			.buf	= buf,
-		},
-	};
 
-	if (i2c_transfer(client->adapter, msgs, 2) < 0) {
+	if (m41t80_transfer(client, 0, M41T80_REG_ALARM_MON,
+			    M41T80_ALARM_REG_SIZE + 1, buf) < 0) {
 		dev_err(&client->dev, "read error\n");
 		return -EIO;
 	}
@@ -488,26 +507,16 @@ static int boot_flag;
  */
 static void wdt_ping(void)
 {
-	unsigned char i2c_data[2];
-	struct i2c_msg msgs1[1] = {
-		{
-			.addr	= save_client->addr,
-			.flags	= 0,
-			.len	= 2,
-			.buf	= i2c_data,
-		},
-	};
-	i2c_data[0] = 0x09;		/* watchdog register */
+	u8 wdt = 0x80;				/* WDS = 1 (0x80)  */
 
 	if (wdt_margin > 31)
-		i2c_data[1] = (wdt_margin & 0xFC) | 0x83; /* resolution = 4s */
+		/* mulitplier = WD_TIMO / 4, resolution = 4s (0x3)  */
+		wdt |= (wdt_margin & 0xfc) | 0x3;
 	else
-		/*
-		 * WDS = 1 (0x80), mulitplier = WD_TIMO, resolution = 1s (0x02)
-		 */
-		i2c_data[1] = wdt_margin<<2 | 0x82;
+		/* mulitplier = WD_TIMO, resolution = 1s (0x2)  */
+		wdt |= wdt_margin << 2 | 0x2;
 
-	i2c_transfer(save_client->adapter, msgs1, 1);
+	i2c_smbus_write_byte_data(save_client, M41T80_REG_WATCHDOG, wdt);
 }
 
 /**
@@ -517,36 +526,8 @@ static void wdt_ping(void)
  */
 static void wdt_disable(void)
 {
-	unsigned char i2c_data[2], i2c_buf[0x10];
-	struct i2c_msg msgs0[2] = {
-		{
-			.addr	= save_client->addr,
-			.flags	= 0,
-			.len	= 1,
-			.buf	= i2c_data,
-		},
-		{
-			.addr	= save_client->addr,
-			.flags	= I2C_M_RD,
-			.len	= 1,
-			.buf	= i2c_buf,
-		},
-	};
-	struct i2c_msg msgs1[1] = {
-		{
-			.addr	= save_client->addr,
-			.flags	= 0,
-			.len	= 2,
-			.buf	= i2c_data,
-		},
-	};
-
-	i2c_data[0] = 0x09;
-	i2c_transfer(save_client->adapter, msgs0, 2);
-
-	i2c_data[0] = 0x09;
-	i2c_data[1] = 0x00;
-	i2c_transfer(save_client->adapter, msgs1, 1);
+	i2c_smbus_read_byte_data(save_client, M41T80_REG_WATCHDOG);
+	i2c_smbus_write_byte_data(save_client, M41T80_REG_WATCHDOG, 0);
 }
 
 /**
@@ -629,14 +610,12 @@ static int wdt_ioctl(struct inode *inode
 			return -EFAULT;
 
 		if (rv & WDIOS_DISABLECARD) {
-			printk(KERN_INFO
-			       "rtc-m41t80: disable watchdog\n");
+			pr_info("rtc-m41t80: disable watchdog\n");
 			wdt_disable();
 		}
 
 		if (rv & WDIOS_ENABLECARD) {
-			printk(KERN_INFO
-			       "rtc-m41t80: enable watchdog\n");
+			pr_info("rtc-m41t80: enable watchdog\n");
 			wdt_ping();
 		}
 
@@ -732,19 +711,28 @@ static struct notifier_block wdt_notifie
 static int m41t80_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	int rc = 0;
 	struct rtc_device *rtc = NULL;
 	struct rtc_time tm;
 	struct m41t80_data *clientdata = NULL;
+	int rc = 0;
+	int reg;
 
-	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C
-				     | I2C_FUNC_SMBUS_BYTE_DATA)) {
+	if ((i2c_get_functionality(client->adapter) &
+	     (I2C_FUNC_I2C | I2C_FUNC_SMBUS_BYTE_DATA)) == 0) {
 		rc = -ENODEV;
 		goto exit;
 	}
 
+	/* Trivially check it's there; keep the result for the HT check.  */
+	reg = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_HOUR);
+	if (reg < 0) {
+		rc = -ENXIO;
+		goto exit;
+	}
+
 	dev_info(&client->dev,
-		 "chip found, driver version " DRV_VERSION "\n");
+		 "%s chip found, driver version " DRV_VERSION "\n",
+		 client->name);
 
 	clientdata = kzalloc(sizeof(*clientdata), GFP_KERNEL);
 	if (!clientdata) {
@@ -765,11 +753,7 @@ static int m41t80_probe(struct i2c_clien
 	i2c_set_clientdata(client, clientdata);
 
 	/* Make sure HT (Halt Update) bit is cleared */
-	rc = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_HOUR);
-	if (rc < 0)
-		goto ht_err;
-
-	if (rc & M41T80_ALHOUR_HT) {
+	if (reg & M41T80_ALHOUR_HT) {
 		if (clientdata->features & M41T80_FEATURE_HT) {
 			m41t80_get_datetime(client, &tm);
 			dev_info(&client->dev, "HT bit was set!\n");
@@ -780,20 +764,19 @@ static int m41t80_probe(struct i2c_clien
 				 tm.tm_mon + 1, tm.tm_mday, tm.tm_hour,
 				 tm.tm_min, tm.tm_sec);
 		}
-		if (i2c_smbus_write_byte_data(client,
-					      M41T80_REG_ALARM_HOUR,
-					      rc & ~M41T80_ALHOUR_HT) < 0)
+		if (i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_HOUR,
+					      reg & ~M41T80_ALHOUR_HT) < 0)
 			goto ht_err;
 	}
 
 	/* Make sure ST (stop) bit is cleared */
-	rc = i2c_smbus_read_byte_data(client, M41T80_REG_SEC);
-	if (rc < 0)
+	reg = i2c_smbus_read_byte_data(client, M41T80_REG_SEC);
+	if (reg < 0)
 		goto st_err;
 
-	if (rc & M41T80_SEC_ST) {
+	if (reg & M41T80_SEC_ST) {
 		if (i2c_smbus_write_byte_data(client, M41T80_REG_SEC,
-					      rc & ~M41T80_SEC_ST) < 0)
+					      reg & ~M41T80_SEC_ST) < 0)
 			goto st_err;
 	}
 
@@ -803,6 +786,7 @@ static int m41t80_probe(struct i2c_clien
 
 #ifdef CONFIG_RTC_DRV_M41T80_WDT
 	if (clientdata->features & M41T80_FEATURE_HT) {
+		save_client = client;
 		rc = misc_register(&wdt_dev);
 		if (rc)
 			goto exit;
@@ -811,7 +795,6 @@ static int m41t80_probe(struct i2c_clien
 			misc_deregister(&wdt_dev);
 			goto exit;
 		}
-		save_client = client;
 	}
 #endif
 	return 0;
