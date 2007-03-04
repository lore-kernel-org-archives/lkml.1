Return-Path: <linux-kernel-owner+w=401wt.eu-S1752105AbXCDR3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbXCDR3S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 12:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbXCDR3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 12:29:17 -0500
Received: from charon.hkfree.org ([89.248.240.1]:60766 "EHLO charon.hkfree.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbXCDR3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 12:29:16 -0500
Message-ID: <45EB01E8.5080003@assembler.cz>
Date: Sun, 04 Mar 2007 18:29:12 +0100
From: Rudolf Marek <r.marek@assembler.cz>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org,
       linux-acpi@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
References: <20070228213803.GA4877@ucw.cz>	<20070301152655.f232db64.khali@linux-fr.org>	<20070302114023.GD2163@elf.ucw.cz>	<20070302114747.GB1212@srcf.ucam.org>	<20070302151055.d2665d66.khali@linux-fr.org>	<20070302141840.GA3441@srcf.ucam.org>	<20070302220454.a0c66d04.khali@linux-fr.org>	<20070302211251.GA10035@srcf.ucam.org>	<20070303105316.d51e032d.khali@linux-fr.org>	<4dfa50520703030747g3c887f5bxe25caefd1723c635@mail.gmail.com>	<20070303155048.GA22755@srcf.ucam.org> <45E9AB8B.1070804@assembler.cz>
In-Reply-To: <45E9AB8B.1070804@assembler.cz>
Content-Type: multipart/mixed;
 boundary="------------060001060901060804030902"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060001060901060804030902
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello again,

I produced some code which I proposed in mail above. The patch is not for review
it is just a PoC to better show what I'm trying to do. It is a test case for my
motherboard which has W83627EHF chip and ACPI thermal method and w83627ehf
compete the device.

When no driver is loaded, acpi is doing its own raw access to device. However
when the w83627ehf driver is loaded, the ACPI access to ports (0x295/0x296) is
forwarded to the w83627ehf driver.

How it works? I added one pointer to the struct resource which will contain a
pointer to the structure with callback functions. I know this is not an ideal
solution, but for a test it works fine. Everytime ACPI wants do IO it will ask
via ____request_resource(conflict, &res) if some driver claimed the resource,
if so, it iterates the resource structure to the last entry, if the callback
structure exists it is called (and device driver context is passed too), if not,
raw hw access is performed.

The routines in EHF driver partly emulates the chip, the address of which next
acpi access will want to read or write is saved in the data->reg_pointer.

The actual access to the chip is done only when the data port of the chip is
accessed, and driver generic io function is called. Bank register writes are
faked to the data->reg_bank. All access to the chip which is done in these
routines respects the "virtual" bank register which was previously set by ACPI.
(current emulation is not 100% perfect, but this could be easily fixed)
If something was written to the chip, driver's register cache is invalidated.

This approach does not need any external locking because the actual device
access is done by one function of driver (which already locks).

As from ACPI point of view the device behaves same way as real HW, the big plus
is that the driver actually KNOWs what is ACPI trying to do to the chip. Of
course if the HW access is done in SMM some other countermeasures must be
invented like GBL lock or the "take ownership" stuff.

Maybe this forwarder may be used by other drivers, which may want to know what
is ACPI doing to hardware during suspend/resume methods...

As I wrote earlier the SMBus access could be also virtualized same way, there
will be only more virtual registers, real transaction will start when the ACPI
sets the "begin transaction" bits ;).

Maybe the pointer to driver context could be removed, and container_of could be
used instead to reach it. I will need some advise how to implement this
randevouz between ACPI and one Linux driver... Exploiting the resource structure
  is nice but pehaps not acceptable??? Some class maybe? We have only 1:1
relation...

Thanks,
Rudolf



--------------060001060901060804030902
Content-Type: text/x-diff;
 name="acpi-io-sync.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="acpi-io-sync.patch"

Index: linux-2.6.20/include/linux/ioport.h
===================================================================
--- linux-2.6.20.orig/include/linux/ioport.h	2007-03-04 10:31:03.457166952 +0100
+++ linux-2.6.20/include/linux/ioport.h	2007-03-04 15:55:03.458260761 +0100
@@ -14,10 +14,19 @@
  * Resources are tree-like, allowing
  * nesting etc..
  */
+
+struct resource_ops {
+	int (*read_io)(u32 size, u32 port, u32 *where, void *priv);
+	int (*write_io)(u32 size, u32 port, u32 val, void *priv);
+	void *priv_data;
+};
+
 struct resource {
 	resource_size_t start;
 	resource_size_t end;
 	const char *name;
+	//void *resource_data;
+	struct resource_ops *res_ops;
 	unsigned long flags;
 	struct resource *parent, *sibling, *child;
 };
Index: linux-2.6.20/drivers/acpi/osl.c
===================================================================
--- linux-2.6.20.orig/drivers/acpi/osl.c	2007-03-04 10:31:30.626715256 +0100
+++ linux-2.6.20/drivers/acpi/osl.c	2007-03-04 16:18:29.958412636 +0100
@@ -36,6 +36,7 @@
 #include <linux/delay.h>
 #include <linux/workqueue.h>
 #include <linux/nmi.h>
+#include <linux/ioport.h>
 #include <acpi/acpi.h>
 #include <asm/io.h>
 #include <acpi/acpi_bus.h>
@@ -331,13 +332,8 @@
 	return ++t;
 }
 
-acpi_status acpi_os_read_port(acpi_io_address port, u32 * value, u32 width)
+static acpi_status acpi_os_read_port_raw(acpi_io_address port, u32 * value, u32 width)
 {
-	u32 dummy;
-
-	if (!value)
-		value = &dummy;
-
 	switch (width) {
 	case 8:
 		*(u8 *) value = inb(port);
@@ -355,10 +351,51 @@
 	return AE_OK;
 }
 
+acpi_status acpi_os_read_port(acpi_io_address port, u32 * value, u32 width)
+{
+	acpi_status ret = AE_OK;
+	struct resource *conflict, res;
+	u32 dummy;
+	int retval;
+
+	if (!value)
+		value = &dummy;
+
+	printk("%s: Port %x\n", __FUNCTION__ , (int) port);
+	res.flags = 0;
+	res.name = "ACPI Access";
+	res.start = port;
+	res.end = port + width/8 - 1;
+	
+	conflict = ____request_resource(&ioport_resource, &res);
+
+	while ((conflict) && (conflict->child))
+		conflict = ____request_resource(conflict, &res);
+
+	if ((conflict) && (conflict->res_ops) && (conflict->res_ops->write_io)) {
+		printk("Redir called\n");
+		retval = conflict->res_ops->read_io(width, port, value, conflict->res_ops->priv_data);
+
+		//this needs coding fix
+		if (retval < 0) {
+			ret = acpi_os_read_port_raw(port, value, width);
+		} else {
+			ret = AE_OK;
+		}
+	} else {
+		printk("Ordinary job\n");
+		ret = acpi_os_read_port_raw(port, value, width);
+		if (conflict == NULL)
+			release_resource(&res);
+	}
+
+	return ret;
+}
+
 EXPORT_SYMBOL(acpi_os_read_port);
 
-acpi_status acpi_os_write_port(acpi_io_address port, u32 value, u32 width)
-{
+static acpi_status acpi_os_write_port_raw(acpi_io_address port, u32 value, u32 width) {
+
 	switch (width) {
 	case 8:
 		outb(value, port);
@@ -376,6 +413,41 @@
 	return AE_OK;
 }
 
+acpi_status acpi_os_write_port(acpi_io_address port, u32 value, u32 width)
+{
+	struct resource *conflict, res;
+	acpi_status ret = AE_OK;
+	int retval;
+	res.flags = 0;
+	res.start = port;
+	res.end = port + width/8 - 1;
+	res.name = "ACPI Access";
+	printk("%s: Port %x\n", __FUNCTION__ , (int) port);
+	
+	conflict = ____request_resource(&ioport_resource, &res);
+
+	while ((conflict) && (conflict->child))
+		conflict = ____request_resource(conflict, &res);
+
+	if ((conflict) && (conflict->res_ops) && (conflict->res_ops->write_io)) {
+		printk("Redir called\n");
+		retval = conflict->res_ops->write_io(width, port, value,
+							conflict->res_ops->priv_data);
+		//this needs coding fix
+		if (retval < 0) {
+			ret = acpi_os_write_port_raw(port, value, width);
+		} else {
+			ret = AE_OK;
+		}
+	} else {
+		printk("Ordinary job\n");
+		ret = acpi_os_write_port_raw(port, value, width);
+		if (conflict == NULL)
+			release_resource(&res);
+	}
+	return ret;
+}
+
 EXPORT_SYMBOL(acpi_os_write_port);
 
 acpi_status
Index: linux-2.6.20/drivers/hwmon/w83627ehf.c
===================================================================
--- linux-2.6.20.orig/drivers/hwmon/w83627ehf.c	2007-03-04 10:31:03.689180173 +0100
+++ linux-2.6.20/drivers/hwmon/w83627ehf.c	2007-03-04 15:51:23.737739602 +0100
@@ -245,6 +245,9 @@
 	char valid;		/* !=0 if following fields are valid */
 	unsigned long last_updated;	/* In jiffies */
 
+	u8 reg_pointer;
+	u8 reg_bank;
+
 	/* Register values */
 	u8 in[10];		/* Register value */
 	u8 in_max[10];		/* Register value */
@@ -270,6 +273,7 @@
 
 	u8 fan_min_output[4]; /* minimum fan speed */
 	u8 fan_stop_time[4];
+	struct resource_ops res_ops;
 };
 
 static inline int is_word_sized(u16 reg)
@@ -344,6 +348,74 @@
 	return 0;
 }
 
+
+//we may return error/unsuppored and legacy acpi outb/inb stuff might take a chance
+
+static int acpi_emul_read(u32 size, u32 port, u32 *where, void *priv_data) {
+	struct i2c_client *client =  (struct i2c_client *) priv_data;
+	struct w83627ehf_data *data =  i2c_get_clientdata(client);
+	u16 tmp, reg = (data->reg_bank << 8) | data->reg_pointer;
+
+	if (size != 8) {
+		printk("this io port size is not emulated\n");
+		return -EINVAL;
+	}
+
+	if (port != (client->addr + DATA_REG_OFFSET)) {
+		printk("this port %x is not emulated\n", port);
+		return -EINVAL;
+	}
+
+	printk("%s: client addr %x port: %x \n", __FUNCTION__ , client->addr, port);
+	printk("Calling read with bank %x reg %x (%x)\n",
+			data->reg_bank, data->reg_pointer,reg);
+
+	tmp = w83627ehf_read_value(client, reg);
+	*((u8 *) where) = (is_word_sized(reg)) ? tmp >> 8 : tmp;
+	return 0;
+}
+
+static int acpi_emul_write(u32 size, u32 port, u32 val, void *priv_data) {
+	struct i2c_client *client = (struct i2c_client *) priv_data;
+	struct w83627ehf_data *data = i2c_get_clientdata(client);
+	u16 reg;
+
+	if (size != 8) {
+		printk("this io port size is not emulated\n");
+		return -EINVAL;
+	}
+
+	printk("%s client addr %x port %x\n", __FUNCTION__ , client->addr, port);
+
+	if (port == (client->addr + ADDR_REG_OFFSET)) {
+		data->reg_pointer = val;
+	} else if (port == (client->addr + DATA_REG_OFFSET)) {
+
+		if (data->reg_pointer == W83627EHF_REG_BANK) {
+			data->reg_bank = val & 0x3;
+			printk("REG bank changed %x\n", data->reg_bank);
+		} else { 
+			reg = (data->reg_bank << 8) | data->reg_pointer;
+			printk("Calling write with bank %x reg %x value %x\n",
+				data->reg_bank, data->reg_pointer, val);
+			
+			if (is_word_sized(reg)) {
+				u16 tmp = w83627ehf_read_value(client, reg);
+				tmp &= 0xff;
+				w83627ehf_write_value(client, reg, (val << 8) | tmp);
+			} else {
+				w83627ehf_write_value(client, reg, val);
+			}
+			data->valid = 0; /* invalidate cache */
+		}
+	} else {
+		printk("this port %x is not emulated\n", port);
+		return -EINVAL;	
+	}
+	return 0;
+}
+
+
 /* This function assumes that the caller holds data->update_lock */
 static void w83627ehf_write_fan_div(struct i2c_client *client, int nr)
 {
@@ -1173,11 +1245,12 @@
 	struct i2c_client *client;
 	struct w83627ehf_data *data;
 	struct device *dev;
+	struct resource *res;
 	u8 fan4pin, fan5pin;
 	int i, err = 0;
 
-	if (!request_region(address + REGION_OFFSET, REGION_LENGTH,
-	                    w83627ehf_driver.driver.name)) {
+	if (!(res = request_region(address + REGION_OFFSET, REGION_LENGTH,
+	                    w83627ehf_driver.driver.name))) {
 		err = -EBUSY;
 		goto exit;
 	}
@@ -1292,6 +1365,13 @@
 		goto exit_remove;
 	}
 
+	/* there is race condition right now */
+	
+	printk("RES %p res->res_ops %p client %p\n",res, res->res_ops, client);
+	data->res_ops.write_io = &acpi_emul_write;
+	data->res_ops.read_io = &acpi_emul_read;
+	data->res_ops.priv_data = client;
+	res->res_ops=&data->res_ops;
 	return 0;
 
 exit_remove:
@@ -1315,6 +1395,7 @@
 
 	if ((err = i2c_detach_client(client)))
 		return err;
+
 	release_region(client->addr + REGION_OFFSET, REGION_LENGTH);
 	kfree(data);
 

--------------060001060901060804030902--
