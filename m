Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbXLFMsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbXLFMsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbXLFMmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:42:55 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53724 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbXLFMmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:42:51 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <1756cef44b33372567336fe3f7ec3f7896e67644.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2007 15:54:01 +0100
Subject: [PATCH 21/47] New version of CRISv32 I2C driver.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Add i2c_write and i2c_read as functions.
- Use spinlocks for critical regions.
- Add config item to set I2C data and clock port.
- Put unneeded testcode inside #if 0.
- Remove CVS id tag.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/drivers/i2c.c |  199 +++++++++++++++++++++++++++++++++++---
 arch/cris/arch-v32/drivers/i2c.h |    2 +
 2 files changed, 187 insertions(+), 14 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/i2c.c b/arch/cris/arch-v32/drivers/i2c.c
index f1edd2e..4eda323 100644
--- a/arch/cris/arch-v32/drivers/i2c.c
+++ b/arch/cris/arch-v32/drivers/i2c.c
@@ -19,10 +19,10 @@
 *!
 *! ---------------------------------------------------------------------------
 *!
-*! (C) Copyright 1999-2002 Axis Communications AB, LUND, SWEDEN
+*! (C) Copyright 1999-2007 Axis Communications AB, LUND, SWEDEN
 *!
 *!***************************************************************************/
-/* $Id: i2c.c,v 1.2 2005/05/09 15:29:49 starvik Exp $ */
+
 /****************** INCLUDE FILES SECTION ***********************************/
 
 #include <linux/module.h>
@@ -79,6 +79,8 @@ static const char i2c_name[] = "i2c";
 
 #define i2c_delay(usecs) udelay(usecs)
 
+static DEFINE_SPINLOCK(i2c_lock); /* Protect directions etc */
+
 /****************** VARIABLE SECTION ************************************/
 
 static struct crisv32_iopin cris_i2c_clk;
@@ -252,6 +254,7 @@ i2c_getack(void)
 	 * generate ACK clock pulse
 	 */
 	i2c_clk(I2C_CLOCK_HIGH);
+#if 0
 	/*
 	 * Use PORT PB instead of I2C
 	 * for input. (I2C not working)
@@ -264,6 +267,8 @@ i2c_getack(void)
 	i2c_data(1);
 	i2c_disable();
 	i2c_dir_in();
+#endif
+
 	/*
 	 * now wait for ack
 	 */
@@ -271,11 +276,11 @@ i2c_getack(void)
 	/*
 	 * check for ack
 	 */
-	if(i2c_getbit())
+	if (i2c_getbit())
 		ack = 0;
 	i2c_delay(CLOCK_HIGH_TIME/2);
-	if(!ack){
-		if(!i2c_getbit()) /* receiver pulled SDA low */
+	if (!ack) {
+		if (!i2c_getbit()) /* receiver pulld SDA low */
 			ack = 1;
 		i2c_delay(CLOCK_HIGH_TIME/2);
 	}
@@ -285,6 +290,7 @@ i2c_getack(void)
     * before we enable our output. If we keep data high
     * and enable output, we would generate a stop condition.
     */
+#if 0
    i2c_data(I2C_DATA_LOW);
 
 	/*
@@ -292,6 +298,7 @@ i2c_getack(void)
 	 */
 	i2c_enable();
 	i2c_dir_out();
+#endif
 	i2c_clk(I2C_CLOCK_LOW);
 	i2c_delay(CLOCK_HIGH_TIME/4);
 	/*
@@ -375,6 +382,137 @@ i2c_sendnack(void)
 
 /*#---------------------------------------------------------------------------
 *#
+*# FUNCTION NAME: i2c_write
+*#
+*# DESCRIPTION  : Writes a value to an I2C device
+*#
+*#--------------------------------------------------------------------------*/
+int
+i2c_write(unsigned char theSlave, void *data, size_t nbytes)
+{
+	int error, cntr = 3;
+	unsigned char bytes_wrote = 0;
+	unsigned char value;
+	unsigned long flags;
+
+	spin_lock(&i2c_lock);
+
+	do {
+		error = 0;
+		/*
+		 * we don't like to be interrupted
+		 */
+		local_irq_save(flags);
+
+		i2c_start();
+		/*
+		 * send slave address
+		 */
+		i2c_outbyte((theSlave & 0xfe));
+		/*
+		 * wait for ack
+		 */
+		if (!i2c_getack())
+			error = 1;
+		/*
+		 * send data
+		 */
+		for (bytes_wrote = 0; bytes_wrote < nbytes; bytes_wrote++) {
+			memcpy(&value, data + bytes_wrote, sizeof value);
+			i2c_outbyte(value);
+			/*
+			 * now it's time to wait for ack
+			 */
+			if (!i2c_getack())
+				error |= 4;
+		}
+		/*
+		 * end byte stream
+		 */
+		i2c_stop();
+		/*
+		 * enable interrupt again
+		 */
+		local_irq_restore(flags);
+
+	} while (error && cntr--);
+
+	i2c_delay(CLOCK_LOW_TIME);
+
+	spin_unlock(&i2c_lock);
+
+	return -error;
+}
+
+/*#---------------------------------------------------------------------------
+*#
+*# FUNCTION NAME: i2c_read
+*#
+*# DESCRIPTION  : Reads a value from an I2C device
+*#
+*#--------------------------------------------------------------------------*/
+int
+i2c_read(unsigned char theSlave, void *data, size_t nbytes)
+{
+	unsigned char b = 0;
+	unsigned char bytes_read = 0;
+	int error, cntr = 3;
+	unsigned long flags;
+
+	spin_lock(&i2c_lock);
+
+	do {
+		error = 0;
+		memset(data, 0, nbytes);
+		/*
+		 * we don't like to be interrupted
+		 */
+		local_irq_save(flags);
+		/*
+		 * generate start condition
+		 */
+		i2c_start();
+		/*
+		 * send slave address
+		 */
+		i2c_outbyte((theSlave | 0x01));
+		/*
+		 * wait for ack
+		 */
+		if (!i2c_getack())
+			error = 1;
+		/*
+		 * fetch data
+		 */
+		for (bytes_read = 0; bytes_read < nbytes; bytes_read++) {
+			b = i2c_inbyte();
+			memcpy(data + bytes_read, &b, sizeof b);
+
+			if (bytes_read < (nbytes - 1))
+				i2c_sendack();
+		}
+		/*
+		 * last received byte needs to be nacked
+		 * instead of acked
+		 */
+		i2c_sendnack();
+		/*
+		 * end sequence
+		 */
+		i2c_stop();
+		/*
+		 * enable interrupt again
+		 */
+		local_irq_restore(flags);
+	} while (error && cntr--);
+
+	spin_unlock(&i2c_lock);
+
+	return -error;
+}
+
+/*#---------------------------------------------------------------------------
+*#
 *# FUNCTION NAME: i2c_writereg
 *#
 *# DESCRIPTION  : Writes a value to an I2C device
@@ -387,6 +525,8 @@ i2c_writereg(unsigned char theSlave, unsigned char theReg,
 	int error, cntr = 3;
 	unsigned long flags;
 
+	spin_lock(&i2c_lock);
+
 	do {
 		error = 0;
 		/*
@@ -431,11 +571,12 @@ i2c_writereg(unsigned char theSlave, unsigned char theReg,
 		 * enable interrupt again
 		 */
 		local_irq_restore(flags);
-
 	} while(error && cntr--);
 
 	i2c_delay(CLOCK_LOW_TIME);
 
+	spin_unlock(&i2c_lock);
+
 	return -error;
 }
 
@@ -453,6 +594,8 @@ i2c_readreg(unsigned char theSlave, unsigned char theReg)
 	int error, cntr = 3;
 	unsigned long flags;
 
+	spin_lock(&i2c_lock);
+
 	do {
 		error = 0;
 		/*
@@ -482,7 +625,7 @@ i2c_readreg(unsigned char theSlave, unsigned char theReg)
 		 * now it's time to wait for ack
 		 */
 		if(!i2c_getack())
-			error = 1;
+			error |= 2;
 		/*
 		 * repeat start condition
 		 */
@@ -496,7 +639,7 @@ i2c_readreg(unsigned char theSlave, unsigned char theReg)
 		 * wait for ack
 		 */
 		if(!i2c_getack())
-			error = 1;
+			error |= 4;
 		/*
 		 * fetch register
 		 */
@@ -517,6 +660,8 @@ i2c_readreg(unsigned char theSlave, unsigned char theReg)
 
 	} while(error && cntr--);
 
+	spin_unlock(&i2c_lock);
+
 	return b;
 }
 
@@ -583,12 +728,37 @@ static const struct file_operations i2c_fops = {
 int __init
 i2c_init(void)
 {
-	int res;
+	static int res;
+	static int first = 1;
 
-	/* Setup and enable the Port B I2C interface */
+	if (!first)
+		return res;
+
+	first = 0;
+
+	/* Setup and enable the DATA and CLK pins */
+
+	res = crisv32_io_get_name(&cris_i2c_data,
+		CONFIG_ETRAX_V32_I2C_DATA_PORT);
+	if (res < 0)
+		return res;
+
+	res = crisv32_io_get_name(&cris_i2c_clk, CONFIG_ETRAX_V32_I2C_CLK_PORT);
+	crisv32_io_set_dir(&cris_i2c_clk, crisv32_io_dir_out);
+
+	return res;
+}
 
-        crisv32_io_get_name(&cris_i2c_data, CONFIG_ETRAX_I2C_DATA_PORT);
-        crisv32_io_get_name(&cris_i2c_clk, CONFIG_ETRAX_I2C_CLK_PORT);
+
+int __init
+i2c_register(void)
+{
+
+	int res;
+
+	res = i2c_init();
+	if (res < 0)
+		return res;
 
 	/* register char device */
 
@@ -598,13 +768,14 @@ i2c_init(void)
 		return res;
 	}
 
-	printk(KERN_INFO "I2C driver v2.2, (c) 1999-2001 Axis Communications AB\n");
+	printk(KERN_INFO
+		"I2C driver v2.2, (c) 1999-2007 Axis Communications AB\n");
 
 	return 0;
 }
 
 /* this makes sure that i2c_init is called during boot */
 
-module_init(i2c_init);
+module_init(i2c_register);
 
 /****************** END OF FILE i2c.c ********************************/
diff --git a/arch/cris/arch-v32/drivers/i2c.h b/arch/cris/arch-v32/drivers/i2c.h
index bfe1a13..c073cf4 100644
--- a/arch/cris/arch-v32/drivers/i2c.h
+++ b/arch/cris/arch-v32/drivers/i2c.h
@@ -3,6 +3,8 @@
 
 /* High level I2C actions */
 int __init i2c_init(void);
+int i2c_write(unsigned char theSlave, void *data, size_t nbytes);
+int i2c_read(unsigned char theSlave, void *data, size_t nbytes);
 int i2c_writereg(unsigned char theSlave, unsigned char theReg, unsigned char theValue);
 unsigned char i2c_readreg(unsigned char theSlave, unsigned char theReg);
 
-- 
1.5.3.6.970.gd25430

