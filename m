Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbYGPIY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbYGPIY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 04:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbYGPIYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 04:24:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52422 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201AbYGPIYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 04:24:06 -0400
Date: Wed, 16 Jul 2008 10:23:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jean Delvare <khali@linux-fr.org>
Cc: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>,
       Ben Dooks <ben-linux@fluff.org>, Greg KH <gregkh@suse.de>
Subject: [crash, bisected] I2C, kobject (ffff81003e8c4160): tried to init
	an initialized object (was: Re: [GIT PULL] i2c updates for 2.6.27,
	round 1)
Message-ID: <20080716082352.GA30483@elte.hu>
References: <20080714224945.629446fa@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080714224945.629446fa@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi Jean,

* Jean Delvare <khali@linux-fr.org> wrote:

>       i2c-nforce2: Add support for multiplexing on the Tyan S4985

-tip random boot testing started triggering the following upstream boot 
crash, starting two days ago when the i2c tree was merged:

[   11.772002] kobject (ffff81003e8c4160): tried to init an initialized object, something is seriously wrong.
[   11.784004] Pid: 1, comm: swapper Not tainted 2.6.26-00007-g279e902-dirty #19896
[   11.793651] 
[   11.793651] Call Trace:
[   11.793651]  [<ffffffff8054471a>] kobject_init+0x7a/0x80
[   11.798969]  [<ffffffff805f0f9d>] device_initialize+0x2d/0xd0
[   11.806323]  [<ffffffff805f19a1>] device_register+0x11/0x20
[   11.811903]  [<ffffffff8087ee3b>] i2c_register_adapter+0xab/0x1d0
[   11.817666]  [<ffffffff8087f0e6>] i2c_add_adapter+0x96/0xb0
[   11.823761]  [<ffffffff81196372>] nforce2_s4985_init+0x272/0x370
[   11.829358]  [<ffffffff8027516a>] ? getnstimeofday+0x3a/0xc0
[   11.835365]  [<ffffffff802728ba>] ? ktime_get_ts+0x4a/0x60
[   11.840853]  [<ffffffff81196100>] ? nforce2_s4985_init+0x0/0x370
[   11.846859]  [<ffffffff81160aa3>] kernel_init+0x123/0x300
[   11.852261]  [<ffffffff81160140>] ? early_idt_handler+0x0/0x74
[   11.857957]  [<ffffffff80228548>] child_rip+0xa/0x12
[   11.863781]  [<ffffffff81160140>] ? early_idt_handler+0x0/0x74
[   11.868757]  [<ffffffff81160980>] ? kernel_init+0x0/0x300
[   11.874160]  [<ffffffff8022853e>] ? child_rip+0x0/0x12
[   11.879989] 
[   11.881141] general protection fault: 0000 [1] SMP 
[   11.881141] CPU 1 

with this config:

   http://redhat.com/~mingo/misc/config-Wed_Jul_16_02_26_04_CEST_2008.bad

today i had time to do a bisection run, and it came up with this commit:

| 279e902445557897707d325182916a6e28ba80de is first bad commit
| commit 279e902445557897707d325182916a6e28ba80de
| Author: Jean Delvare <khali@linux-fr.org>
| Date:   Mon Jul 14 22:38:21 2008 +0200
|
|    i2c-nforce2: Add support for multiplexing on the Tyan S4985

the crash is reproducible and i can test any fix patch in short order. 
As a quick temporary hack i've reverted this patch for now via the patch 
below, to keep the tests going. (Can send more details about the 
test-system if needed.)

btw., Greg, the kobject debugging check and output is really nice, 
informative and useful! It likely pinpoints the real bug here.

	Ingo

----------------->
commit 244439bcf780ac3ecbb427acd43d3444f9254008
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jul 16 10:17:30 2008 +0200

    Revert "i2c-nforce2: Add support for multiplexing on the Tyan S4985"
    
    This reverts commit 279e902445557897707d325182916a6e28ba80de.
    
    Boot test failure with:
    
      http://redhat.com/~mingo/misc/config-Wed_Jul_16_02_26_04_CEST_2008.bad
    
    causes this crash:
    
    [   11.772002] kobject (ffff81003e8c4160): tried to init an initialized object, something is seriously wrong.
    [   11.784004] Pid: 1, comm: swapper Not tainted 2.6.26-00007-g279e902-dirty #19896
    [   11.793651]
    [   11.793651] Call Trace:
    [   11.793651]  [<ffffffff8054471a>] kobject_init+0x7a/0x80
    [   11.798969]  [<ffffffff805f0f9d>] device_initialize+0x2d/0xd0
    [   11.806323]  [<ffffffff805f19a1>] device_register+0x11/0x20
    [   11.811903]  [<ffffffff8087ee3b>] i2c_register_adapter+0xab/0x1d0
    [   11.817666]  [<ffffffff8087f0e6>] i2c_add_adapter+0x96/0xb0
    [   11.823761]  [<ffffffff81196372>] nforce2_s4985_init+0x272/0x370
    [   11.829358]  [<ffffffff8027516a>] ? getnstimeofday+0x3a/0xc0
    [   11.835365]  [<ffffffff802728ba>] ? ktime_get_ts+0x4a/0x60
    [   11.840853]  [<ffffffff81196100>] ? nforce2_s4985_init+0x0/0x370
    [   11.846859]  [<ffffffff81160aa3>] kernel_init+0x123/0x300
    [   11.852261]  [<ffffffff81160140>] ? early_idt_handler+0x0/0x74
    [   11.857957]  [<ffffffff80228548>] child_rip+0xa/0x12
    [   11.863781]  [<ffffffff81160140>] ? early_idt_handler+0x0/0x74
    [   11.868757]  [<ffffffff81160980>] ? kernel_init+0x0/0x300
    [   11.874160]  [<ffffffff8022853e>] ? child_rip+0x0/0x12
    [   11.879989]
    [   11.881141] general protection fault: 0000 [1] SMP
    [   11.881141] CPU 1
    
    Conflicts:
    
    	drivers/i2c/busses/Kconfig
    	drivers/i2c/busses/Makefile
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/i2c/busses/Kconfig             |   37 ++---
 drivers/i2c/busses/Makefile            |    1 -
 drivers/i2c/busses/i2c-nforce2-s4985.c |  257 --------------------------------
 drivers/i2c/busses/i2c-nforce2.c       |   16 --
 4 files changed, 12 insertions(+), 299 deletions(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 6ee997b..2a3819d 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -136,28 +136,15 @@ config I2C_PIIX4
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-piix4.
 
-config I2C_NFORCE2
-	tristate "Nvidia nForce2, nForce3 and nForce4"
-	depends on PCI
-	help
-	  If you say yes to this option, support will be included for the Nvidia
-	  nForce2, nForce3 and nForce4 families of mainboard I2C interfaces.
-
-	  This driver can also be built as a module.  If so, the module
-	  will be called i2c-nforce2.
-
-config I2C_NFORCE2_S4985
-	tristate "SMBus multiplexing on the Tyan S4985"
-	depends on I2C_NFORCE2 && EXPERIMENTAL
+config I2C_MV64XXX
+	tristate "Marvell mv64xxx I2C Controller"
+	depends on (MV64X60 || PLAT_ORION) && EXPERIMENTAL
 	help
-	  Enabling this option will add specific SMBus support for the Tyan
-	  S4985 motherboard.  On this 4-CPU board, the SMBus is multiplexed
-	  over 4 different channels, where the various memory module EEPROMs
-	  live.  Saying yes here will give you access to these in addition
-	  to the trunk.
+	  If you say yes to this option, support will be included for the
+	  built-in I2C interface on the Marvell 64xxx line of host bridges.
 
 	  This driver can also be built as a module.  If so, the module
-	  will be called i2c-nforce2-s4985.
+	  will be called i2c-mv64xxx.
 
 config I2C_SIS5595
 	tristate "SiS 5595"
@@ -376,15 +363,15 @@ config I2C_MPC
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-mpc.
 
-config I2C_MV64XXX
-	tristate "Marvell mv64xxx I2C Controller"
-	depends on (MV64X60 || PLAT_ORION) && EXPERIMENTAL
+config I2C_NFORCE2
+	tristate "Nvidia nForce2, nForce3 and nForce4"
+	depends on PCI
 	help
-	  If you say yes to this option, support will be included for the
-	  built-in I2C interface on the Marvell 64xxx line of host bridges.
+	  If you say yes to this option, support will be included for the Nvidia
+	  nForce2, nForce3 and nForce4 families of mainboard I2C interfaces.
 
 	  This driver can also be built as a module.  If so, the module
-	  will be called i2c-mv64xxx.
+	  will be called i2c-nforce2.
 
 config I2C_OCORES
 	tristate "OpenCores I2C Controller"
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 97dbfa2..1adb173 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -12,7 +12,6 @@ obj-$(CONFIG_I2C_AMD8111)	+= i2c-amd8111.o
 obj-$(CONFIG_I2C_I801)		+= i2c-i801.o
 obj-$(CONFIG_I2C_ISCH)		+= i2c-isch.o
 obj-$(CONFIG_I2C_NFORCE2)	+= i2c-nforce2.o
-obj-$(CONFIG_I2C_NFORCE2_S4985)	+= i2c-nforce2-s4985.o
 obj-$(CONFIG_I2C_PIIX4)		+= i2c-piix4.o
 obj-$(CONFIG_I2C_SIS5595)	+= i2c-sis5595.o
 obj-$(CONFIG_I2C_SIS630)	+= i2c-sis630.o
diff --git a/drivers/i2c/busses/i2c-nforce2-s4985.c b/drivers/i2c/busses/i2c-nforce2-s4985.c
deleted file mode 100644
index 6a8995d..0000000
--- a/drivers/i2c/busses/i2c-nforce2-s4985.c
+++ /dev/null
@@ -1,257 +0,0 @@
-/*
- * i2c-nforce2-s4985.c - i2c-nforce2 extras for the Tyan S4985 motherboard
- *
- * Copyright (C) 2008 Jean Delvare <khali@linux-fr.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-/*
- * We select the channels by sending commands to the Philips
- * PCA9556 chip at I2C address 0x18. The main adapter is used for
- * the non-multiplexed part of the bus, and 4 virtual adapters
- * are defined for the multiplexed addresses: 0x50-0x53 (memory
- * module EEPROM) located on channels 1-4. We define one virtual
- * adapter per CPU, which corresponds to one multiplexed channel:
- *   CPU0: virtual adapter 1, channel 1
- *   CPU1: virtual adapter 2, channel 2
- *   CPU2: virtual adapter 3, channel 3
- *   CPU3: virtual adapter 4, channel 4
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/init.h>
-#include <linux/i2c.h>
-#include <linux/mutex.h>
-
-extern struct i2c_adapter *nforce2_smbus;
-
-static struct i2c_adapter *s4985_adapter;
-static struct i2c_algorithm *s4985_algo;
-
-/* Wrapper access functions for multiplexed SMBus */
-static DEFINE_MUTEX(nforce2_lock);
-
-static s32 nforce2_access_virt0(struct i2c_adapter *adap, u16 addr,
-				unsigned short flags, char read_write,
-				u8 command, int size,
-				union i2c_smbus_data *data)
-{
-	int error;
-
-	/* We exclude the multiplexed addresses */
-	if ((addr & 0xfc) == 0x50 || (addr & 0xfc) == 0x30
-	 || addr == 0x18)
-		return -ENXIO;
-
-	mutex_lock(&nforce2_lock);
-	error = nforce2_smbus->algo->smbus_xfer(adap, addr, flags, read_write,
-						command, size, data);
-	mutex_unlock(&nforce2_lock);
-
-	return error;
-}
-
-/* We remember the last used channels combination so as to only switch
-   channels when it is really needed. This greatly reduces the SMBus
-   overhead, but also assumes that nobody will be writing to the PCA9556
-   in our back. */
-static u8 last_channels;
-
-static inline s32 nforce2_access_channel(struct i2c_adapter *adap, u16 addr,
-					 unsigned short flags, char read_write,
-					 u8 command, int size,
-					 union i2c_smbus_data *data,
-					 u8 channels)
-{
-	int error;
-
-	/* We exclude the non-multiplexed addresses */
-	if ((addr & 0xfc) != 0x50 && (addr & 0xfc) != 0x30)
-		return -ENXIO;
-
-	mutex_lock(&nforce2_lock);
-	if (last_channels != channels) {
-		union i2c_smbus_data mplxdata;
-		mplxdata.byte = channels;
-
-		error = nforce2_smbus->algo->smbus_xfer(adap, 0x18, 0,
-							I2C_SMBUS_WRITE, 0x01,
-							I2C_SMBUS_BYTE_DATA,
-							&mplxdata);
-		if (error)
-			goto UNLOCK;
-		last_channels = channels;
-	}
-	error = nforce2_smbus->algo->smbus_xfer(adap, addr, flags, read_write,
-						command, size, data);
-
-UNLOCK:
-	mutex_unlock(&nforce2_lock);
-	return error;
-}
-
-static s32 nforce2_access_virt1(struct i2c_adapter *adap, u16 addr,
-				unsigned short flags, char read_write,
-				u8 command, int size,
-				union i2c_smbus_data *data)
-{
-	/* CPU0: channel 1 enabled */
-	return nforce2_access_channel(adap, addr, flags, read_write, command,
-				      size, data, 0x02);
-}
-
-static s32 nforce2_access_virt2(struct i2c_adapter *adap, u16 addr,
-				unsigned short flags, char read_write,
-				u8 command, int size,
-				union i2c_smbus_data *data)
-{
-	/* CPU1: channel 2 enabled */
-	return nforce2_access_channel(adap, addr, flags, read_write, command,
-				      size, data, 0x04);
-}
-
-static s32 nforce2_access_virt3(struct i2c_adapter *adap, u16 addr,
-				unsigned short flags, char read_write,
-				u8 command, int size,
-				union i2c_smbus_data *data)
-{
-	/* CPU2: channel 3 enabled */
-	return nforce2_access_channel(adap, addr, flags, read_write, command,
-				      size, data, 0x08);
-}
-
-static s32 nforce2_access_virt4(struct i2c_adapter *adap, u16 addr,
-				unsigned short flags, char read_write,
-				u8 command, int size,
-				union i2c_smbus_data *data)
-{
-	/* CPU3: channel 4 enabled */
-	return nforce2_access_channel(adap, addr, flags, read_write, command,
-				      size, data, 0x10);
-}
-
-static int __init nforce2_s4985_init(void)
-{
-	int i, error;
-	union i2c_smbus_data ioconfig;
-
-	/* Unregister physical bus */
-	if (!nforce2_smbus)
-		return -ENODEV;
-	error = i2c_del_adapter(nforce2_smbus);
-	if (error) {
-		dev_err(&nforce2_smbus->dev, "Physical bus removal failed\n");
-		goto ERROR0;
-	}
-
-	printk(KERN_INFO "Enabling SMBus multiplexing for Tyan S4985\n");
-	/* Define the 5 virtual adapters and algorithms structures */
-	s4985_adapter = kzalloc(5 * sizeof(struct i2c_adapter), GFP_KERNEL);
-	if (!s4985_adapter) {
-		error = -ENOMEM;
-		goto ERROR1;
-	}
-	s4985_algo = kzalloc(5 * sizeof(struct i2c_algorithm), GFP_KERNEL);
-	if (!s4985_algo) {
-		error = -ENOMEM;
-		goto ERROR2;
-	}
-
-	/* Fill in the new structures */
-	s4985_algo[0] = *(nforce2_smbus->algo);
-	s4985_algo[0].smbus_xfer = nforce2_access_virt0;
-	s4985_adapter[0] = *nforce2_smbus;
-	s4985_adapter[0].algo = s4985_algo;
-	s4985_adapter[0].dev.parent = nforce2_smbus->dev.parent;
-	for (i = 1; i < 5; i++) {
-		s4985_algo[i] = *(nforce2_smbus->algo);
-		s4985_adapter[i] = *nforce2_smbus;
-		snprintf(s4985_adapter[i].name, sizeof(s4985_adapter[i].name),
-			 "SMBus nForce2 adapter (CPU%d)", i - 1);
-		s4985_adapter[i].algo = s4985_algo + i;
-		s4985_adapter[i].dev.parent = nforce2_smbus->dev.parent;
-	}
-	s4985_algo[1].smbus_xfer = nforce2_access_virt1;
-	s4985_algo[2].smbus_xfer = nforce2_access_virt2;
-	s4985_algo[3].smbus_xfer = nforce2_access_virt3;
-	s4985_algo[4].smbus_xfer = nforce2_access_virt4;
-
-	/* Configure the PCA9556 multiplexer */
-	ioconfig.byte = 0x00; /* All I/O to output mode */
-	error = nforce2_smbus->algo->smbus_xfer(nforce2_smbus, 0x18, 0,
-						I2C_SMBUS_WRITE, 0x03,
-						I2C_SMBUS_BYTE_DATA, &ioconfig);
-	if (error) {
-		dev_err(&nforce2_smbus->dev, "PCA9556 configuration failed\n");
-		error = -EIO;
-		goto ERROR3;
-	}
-
-	/* Register virtual adapters */
-	for (i = 0; i < 5; i++) {
-		error = i2c_add_adapter(s4985_adapter + i);
-		if (error) {
-			dev_err(&nforce2_smbus->dev,
-				"Virtual adapter %d registration "
-				"failed, module not inserted\n", i);
-			for (i--; i >= 0; i--)
-				i2c_del_adapter(s4985_adapter + i);
-			goto ERROR3;
-		}
-	}
-
-	return 0;
-
-ERROR3:
-	kfree(s4985_algo);
-	s4985_algo = NULL;
-ERROR2:
-	kfree(s4985_adapter);
-	s4985_adapter = NULL;
-ERROR1:
-	/* Restore physical bus */
-	i2c_add_adapter(nforce2_smbus);
-ERROR0:
-	return error;
-}
-
-static void __exit nforce2_s4985_exit(void)
-{
-	if (s4985_adapter) {
-		int i;
-
-		for (i = 0; i < 5; i++)
-			i2c_del_adapter(s4985_adapter+i);
-		kfree(s4985_adapter);
-		s4985_adapter = NULL;
-	}
-	kfree(s4985_algo);
-	s4985_algo = NULL;
-
-	/* Restore physical bus */
-	if (i2c_add_adapter(nforce2_smbus))
-		dev_err(&nforce2_smbus->dev, "Physical bus restoration "
-			"failed\n");
-}
-
-MODULE_AUTHOR("Jean Delvare <khali@linux-fr.org>");
-MODULE_DESCRIPTION("S4985 SMBus multiplexing");
-MODULE_LICENSE("GPL");
-
-module_init(nforce2_s4985_init);
-module_exit(nforce2_s4985_exit);
diff --git a/drivers/i2c/busses/i2c-nforce2.c b/drivers/i2c/busses/i2c-nforce2.c
index 3b19bc4..7048e55 100644
--- a/drivers/i2c/busses/i2c-nforce2.c
+++ b/drivers/i2c/busses/i2c-nforce2.c
@@ -125,20 +125,6 @@ static struct dmi_system_id __devinitdata nforce2_dmi_blacklist2[] = {
 
 static struct pci_driver nforce2_driver;
 
-/* For multiplexing support, we need a global reference to the 1st
-   SMBus channel */
-#if defined CONFIG_I2C_NFORCE2_S4985 || defined CONFIG_I2C_NFORCE2_S4985_MODULE
-struct i2c_adapter *nforce2_smbus;
-EXPORT_SYMBOL_GPL(nforce2_smbus);
-
-static void nforce2_set_reference(struct i2c_adapter *adap)
-{
-	nforce2_smbus = adap;
-}
-#else
-static inline void nforce2_set_reference(struct i2c_adapter *adap) { }
-#endif
-
 static void nforce2_abort(struct i2c_adapter *adap)
 {
 	struct nforce2_smbus *smbus = adap->algo_data;
@@ -419,7 +405,6 @@ static int __devinit nforce2_probe(struct pci_dev *dev, const struct pci_device_
 		return -ENODEV;
 	}
 
-	nforce2_set_reference(&smbuses[0].adapter);
 	return 0;
 }
 
@@ -428,7 +413,6 @@ static void __devexit nforce2_remove(struct pci_dev *dev)
 {
 	struct nforce2_smbus *smbuses = (void*) pci_get_drvdata(dev);
 
-	nforce2_set_reference(NULL);
 	if (smbuses[0].base) {
 		i2c_del_adapter(&smbuses[0].adapter);
 		release_region(smbuses[0].base, smbuses[0].size);
