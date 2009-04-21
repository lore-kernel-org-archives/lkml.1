Return-Path: <linux-kernel-owner+w=401wt.eu-S1757745AbZDUTYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745AbZDUTYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 15:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbZDUTYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 15:24:42 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:32841 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883AbZDUTYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 15:24:40 -0400
Date: Tue, 21 Apr 2009 21:24:30 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH] go7007: Convert to the new i2c device binding model (v2)
Message-ID: <20090421212430.57819f8f@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the go7007 driver away from the legacy i2c binding model, which
is going away really soon now.

The I2C addresses of the audio and video chips in s2250-board didn't
look quite right, apparently they were left-aligned values when Linux
wants right-aligned values, so I fixed them too.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
Note: I just pushed this to Linus, as this is blocking the removal of
the legacy i2c binding model, and I see no point in waiting for a
driver which clearly doesn't work today anyway.

 drivers/staging/go7007/go7007-driver.c  |   11 +++-
 drivers/staging/go7007/go7007-i2c.c     |   83 -------------------------------
 drivers/staging/go7007/go7007-priv.h    |    1 
 drivers/staging/go7007/go7007-usb.c     |   14 ++++-
 drivers/staging/go7007/s2250-board.c    |   71 +++++++++++---------------
 drivers/staging/go7007/wis-i2c.h        |    9 ---
 drivers/staging/go7007/wis-ov7640.c     |   54 +++++---------------
 drivers/staging/go7007/wis-saa7113.c    |   60 +++++++---------------
 drivers/staging/go7007/wis-saa7115.c    |   60 +++++++---------------
 drivers/staging/go7007/wis-sony-tuner.c |   60 ++++++----------------
 drivers/staging/go7007/wis-tw2804.c     |   57 ++++++---------------
 drivers/staging/go7007/wis-tw9903.c     |   60 +++++++---------------
 drivers/staging/go7007/wis-uda1342.c    |   52 +++++--------------
 13 files changed, 175 insertions(+), 417 deletions(-)

--- linux-2.6.30-rc2.orig/drivers/staging/go7007/go7007-driver.c	2009-04-21 11:41:32.000000000 +0200
+++ linux-2.6.30-rc2/drivers/staging/go7007/go7007-driver.c	2009-04-21 13:04:14.000000000 +0200
@@ -191,8 +191,10 @@ int go7007_reset_encoder(struct go7007 *
 /*
  * Attempt to instantiate an I2C client by ID, probably loading a module.
  */
-static int init_i2c_module(struct i2c_adapter *adapter, int id, int addr)
+static int init_i2c_module(struct i2c_adapter *adapter, const char *type,
+			   int id, int addr)
 {
+	struct i2c_board_info info;
 	char *modname;
 
 	switch (id) {
@@ -226,7 +228,11 @@ static int init_i2c_module(struct i2c_ad
 	}
 	if (modname != NULL)
 		request_module(modname);
-	if (wis_i2c_probe_device(adapter, id, addr) == 1)
+
+	memset(&info, 0, sizeof(struct i2c_board_info));
+	info.addr = addr;
+	strlcpy(info.type, type, I2C_NAME_SIZE);
+	if (!i2c_new_device(adapter, &info))
 		return 0;
 	if (modname != NULL)
 		printk(KERN_INFO
@@ -266,6 +272,7 @@ int go7007_register_encoder(struct go700
 	if (go->i2c_adapter_online) {
 		for (i = 0; i < go->board_info->num_i2c_devs; ++i)
 			init_i2c_module(&go->i2c_adapter,
+					go->board_info->i2c_devs[i].type,
 					go->board_info->i2c_devs[i].id,
 					go->board_info->i2c_devs[i].addr);
 		if (go->board_id == GO7007_BOARDID_ADLINK_MPG24)
--- linux-2.6.30-rc2.orig/drivers/staging/go7007/go7007-i2c.c	2009-04-21 11:41:32.000000000 +0200
+++ linux-2.6.30-rc2/drivers/staging/go7007/go7007-i2c.c	2009-04-21 13:04:14.000000000 +0200
@@ -31,87 +31,6 @@
 #include "go7007-priv.h"
 #include "wis-i2c.h"
 
-/************** Registration interface for I2C client drivers **************/
-
-/* Since there's no way to auto-probe the I2C devices connected to the I2C
- * bus on the go7007, we have this silly little registration system that
- * client drivers can use to register their I2C driver ID and their
- * detect_client function (the one that's normally passed to i2c_probe).
- *
- * When a new go7007 device is connected, we can look up in a board info
- * table by the USB or PCI vendor/product/revision ID to determine
- * which I2C client module to load.  The client driver module will register
- * itself here, and then we can call the registered detect_client function
- * to force-load a new client at the address listed in the board info table.
- *
- * Really the I2C subsystem should have a way to force-load I2C client
- * drivers when we have a priori knowledge of what's on the bus, especially
- * since the existing I2C auto-probe mechanism is so hokey, but we'll use
- * our own mechanism for the time being. */
-
-struct wis_i2c_client_driver {
-	unsigned int id;
-	found_proc found_proc;
-	struct list_head list;
-};
-
-static LIST_HEAD(i2c_client_drivers);
-static DECLARE_MUTEX(i2c_client_driver_list_lock);
-
-/* Client drivers register here by their I2C driver ID */
-int wis_i2c_add_driver(unsigned int id, found_proc found_proc)
-{
-	struct wis_i2c_client_driver *driver;
-
-	driver = kmalloc(sizeof(struct wis_i2c_client_driver), GFP_KERNEL);
-	if (driver == NULL)
-		return -ENOMEM;
-	driver->id = id;
-	driver->found_proc = found_proc;
-
-	down(&i2c_client_driver_list_lock);
-	list_add_tail(&driver->list, &i2c_client_drivers);
-	up(&i2c_client_driver_list_lock);
-
-	return 0;
-}
-EXPORT_SYMBOL(wis_i2c_add_driver);
-
-void wis_i2c_del_driver(found_proc found_proc)
-{
-	struct wis_i2c_client_driver *driver, *next;
-
-	down(&i2c_client_driver_list_lock);
-	list_for_each_entry_safe(driver, next, &i2c_client_drivers, list)
-		if (driver->found_proc == found_proc) {
-			list_del(&driver->list);
-			kfree(driver);
-		}
-	up(&i2c_client_driver_list_lock);
-}
-EXPORT_SYMBOL(wis_i2c_del_driver);
-
-/* The main go7007 driver calls this to instantiate a client by driver
- * ID and bus address, which are both stored in the board info table */
-int wis_i2c_probe_device(struct i2c_adapter *adapter,
-				unsigned int id, int addr)
-{
-	struct wis_i2c_client_driver *driver;
-	int found = 0;
-
-	if (addr < 0 || addr > 0x7f)
-		return -1;
-	down(&i2c_client_driver_list_lock);
-	list_for_each_entry(driver, &i2c_client_drivers, list)
-		if (driver->id == id) {
-			if (driver->found_proc(adapter, addr, 0) == 0)
-				found = 1;
-			break;
-		}
-	up(&i2c_client_driver_list_lock);
-	return found;
-}
-
 /********************* Driver for on-board I2C adapter *********************/
 
 /* #define GO7007_I2C_DEBUG */
@@ -287,9 +206,7 @@ static struct i2c_algorithm go7007_algo
 
 static struct i2c_adapter go7007_adap_templ = {
 	.owner			= THIS_MODULE,
-	.class			= I2C_CLASS_TV_ANALOG,
 	.name			= "WIS GO7007SB",
-	.id			= I2C_ALGO_GO7007,
 	.algo			= &go7007_algo,
 };
 
--- linux-2.6.30-rc2.orig/drivers/staging/go7007/go7007-priv.h	2009-04-21 11:41:32.000000000 +0200
+++ linux-2.6.30-rc2/drivers/staging/go7007/go7007-priv.h	2009-04-21 13:04:14.000000000 +0200
@@ -87,6 +87,7 @@ struct go7007_board_info {
 	int audio_main_div;
 	int num_i2c_devs;
 	struct {
+		const char *type;
 		int id;
 		int addr;
 	} i2c_devs[4];
--- linux-2.6.30-rc2.orig/drivers/staging/go7007/go7007-usb.c	2009-04-21 11:41:32.000000000 +0200
+++ linux-2.6.30-rc2/drivers/staging/go7007/go7007-usb.c	2009-04-21 15:39:16.000000000 +0200
@@ -91,6 +91,7 @@ static struct go7007_usb_board board_mat
 		.num_i2c_devs	 = 1,
 		.i2c_devs	 = {
 			{
+				.type	= "wis_saa7115",
 				.id	= I2C_DRIVERID_WIS_SAA7115,
 				.addr	= 0x20,
 			},
@@ -127,6 +128,7 @@ static struct go7007_usb_board board_mat
 		.num_i2c_devs	 = 1,
 		.i2c_devs	 = {
 			{
+				.type	= "wis_saa7113",
 				.id	= I2C_DRIVERID_WIS_SAA7113,
 				.addr	= 0x25,
 			},
@@ -164,6 +166,7 @@ static struct go7007_usb_board board_sta
 		.num_i2c_devs	 = 1,
 		.i2c_devs	 = {
 			{
+				.type	= "wis_saa7115",
 				.id	= I2C_DRIVERID_WIS_SAA7115,
 				.addr	= 0x20,
 			},
@@ -209,14 +212,17 @@ static struct go7007_usb_board board_px_
 		.num_i2c_devs	 = 3,
 		.i2c_devs	 = {
 			{
+				.type	= "wis_saa7115",
 				.id	= I2C_DRIVERID_WIS_SAA7115,
 				.addr	= 0x20,
 			},
 			{
+				.type	= "wis_uda1342",
 				.id	= I2C_DRIVERID_WIS_UDA1342,
 				.addr	= 0x1a,
 			},
 			{
+				.type	= "wis_sony_tuner",
 				.id	= I2C_DRIVERID_WIS_SONY_TUNER,
 				.addr	= 0x60,
 			},
@@ -264,6 +270,7 @@ static struct go7007_usb_board board_xme
 		.num_i2c_devs	  = 1,
 		.i2c_devs	  = {
 			{
+				.type	= "wis_ov7640",
 				.id	= I2C_DRIVERID_WIS_OV7640,
 				.addr	= 0x21,
 			},
@@ -296,6 +303,7 @@ static struct go7007_usb_board board_mat
 		.num_i2c_devs	 = 1,
 		.i2c_devs	 = {
 			{
+				.type	= "wis_tw9903",
 				.id	= I2C_DRIVERID_WIS_TW9903,
 				.addr	= 0x44,
 			},
@@ -385,6 +393,7 @@ static struct go7007_usb_board board_adl
 		.num_i2c_devs	 = 1,
 		.i2c_devs	 = {
 			{
+				.type	= "wis_twTW2804",
 				.id	= I2C_DRIVERID_WIS_TW2804,
 				.addr	= 0x00, /* yes, really */
 			},
@@ -415,8 +424,9 @@ static struct go7007_usb_board board_sen
 		.num_i2c_devs	 = 1,
 		.i2c_devs	 = {
 			{
+				.type	= "s2250_board",
 				.id	= I2C_DRIVERID_S2250,
-				.addr	= 0x34,
+				.addr	= 0x43,
 			},
 		},
 		.num_inputs	 = 2,
@@ -943,9 +953,7 @@ static struct i2c_algorithm go7007_usb_a
 
 static struct i2c_adapter go7007_usb_adap_templ = {
 	.owner			= THIS_MODULE,
-	.class			= I2C_CLASS_TV_ANALOG,
 	.name			= "WIS GO7007SB EZ-USB",
-	.id			= I2C_ALGO_GO7007_USB,
 	.algo			= &go7007_usb_algo,
 };
 
--- linux-2.6.30-rc2.orig/drivers/staging/go7007/s2250-board.c	2009-04-21 11:41:32.000000000 +0200
+++ linux-2.6.30-rc2/drivers/staging/go7007/s2250-board.c	2009-04-21 15:38:52.000000000 +0200
@@ -28,7 +28,6 @@ extern int s2250loader_init(void);
 extern void s2250loader_cleanup(void);
 
 #define TLV320_ADDRESS      0x34
-#define S2250_VIDDEC        0x86
 #define VPX322_ADDR_ANALOGCONTROL1	0x02
 #define VPX322_ADDR_BRIGHTNESS0		0x0127
 #define VPX322_ADDR_BRIGHTNESS1		0x0131
@@ -123,6 +122,7 @@ struct s2250 {
 	int hue;
 	int reg12b_val;
 	int audio_input;
+	struct i2c_client *audio;
 };
 
 /* from go7007-usb.c which is Copyright (C) 2005-2006 Micronas USA Inc.*/
@@ -452,16 +452,15 @@ static int s2250_command(struct i2c_clie
 	{
 		struct v4l2_audio *audio = arg;
 
-		client->addr = TLV320_ADDRESS;
 		switch (audio->index) {
 		case 0:
-			write_reg(client, 0x08, 0x02); /* Line In */
+			write_reg(dec->audio, 0x08, 0x02); /* Line In */
 			break;
 		case 1:
-			write_reg(client, 0x08, 0x04); /* Mic */
+			write_reg(dec->audio, 0x08, 0x04); /* Mic */
 			break;
 		case 2:
-			write_reg(client, 0x08, 0x05); /* Mic Boost */
+			write_reg(dec->audio, 0x08, 0x05); /* Mic Boost */
 			break;
 		default:
 			return -EINVAL;
@@ -477,31 +476,23 @@ static int s2250_command(struct i2c_clie
 	return 0;
 }
 
-static struct i2c_driver s2250_driver;
-
-static struct i2c_client s2250_client_templ = {
-	.name		= "Sensoray 2250",
-	.driver		= &s2250_driver,
-};
-
-static int s2250_detect(struct i2c_adapter *adapter, int addr, int kind)
+static int s2250_probe(struct i2c_client *client,
+		       const struct i2c_device_id *id)
 {
-	struct i2c_client *client;
+	struct i2c_client *audio;
+	struct i2c_adapter *adapter = client->adapter;
 	struct s2250 *dec;
 	u8 *data;
 	struct go7007 *go = i2c_get_adapdata(adapter);
 	struct go7007_usb *usb = go->hpi_context;
 
-	client = kmalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (client == NULL)
+	audio = i2c_new_dummy(adapter, TLV320_ADDRESS >> 1);
+	if (audio == NULL)
 		return -ENOMEM;
-	memcpy(client, &s2250_client_templ,
-	       sizeof(s2250_client_templ));
-	client->adapter = adapter;
 
 	dec = kmalloc(sizeof(struct s2250), GFP_KERNEL);
 	if (dec == NULL) {
-		kfree(client);
+		i2c_unregister_device(audio);
 		return -ENOMEM;
 	}
 
@@ -510,7 +501,7 @@ static int s2250_detect(struct i2c_adapt
 	dec->contrast = 50;
 	dec->saturation = 50;
 	dec->hue = 0;
-	client->addr = TLV320_ADDRESS;
+	dec->audio = audio;
 	i2c_set_clientdata(client, dec);
 
 	printk(KERN_DEBUG
@@ -518,28 +509,25 @@ static int s2250_detect(struct i2c_adapt
 	       adapter->name);
 
 	/* initialize the audio */
-	client->addr = TLV320_ADDRESS;
-	if (write_regs(client, aud_regs) < 0) {
+	if (write_regs(audio, aud_regs) < 0) {
 		printk(KERN_ERR
 		       "s2250: error initializing audio\n");
-		kfree(client);
+		i2c_unregister_device(audio);
 		kfree(dec);
 		return 0;
 	}
-	client->addr = S2250_VIDDEC;
-	i2c_set_clientdata(client, dec);
 
 	if (write_regs(client, vid_regs) < 0) {
 		printk(KERN_ERR
 		       "s2250: error initializing decoder\n");
-		kfree(client);
+		i2c_unregister_device(audio);
 		kfree(dec);
 		return 0;
 	}
 	if (write_regs_fp(client, vid_regs_fp) < 0) {
 		printk(KERN_ERR
 		       "s2250: error initializing decoder\n");
-		kfree(client);
+		i2c_unregister_device(audio);
 		kfree(dec);
 		return 0;
 	}
@@ -575,32 +563,33 @@ static int s2250_detect(struct i2c_adapt
 		up(&usb->i2c_lock);
 	}
 
-	i2c_attach_client(client);
 	printk("s2250: initialized successfully\n");
 	return 0;
 }
 
-static int s2250_detach(struct i2c_client *client)
+static int s2250_remove(struct i2c_client *client)
 {
 	struct s2250 *dec = i2c_get_clientdata(client);
-	int r;
-
-	r = i2c_detach_client(client);
-	if (r < 0)
-		return r;
 
-	kfree(client);
+	i2c_set_clientdata(client, NULL);
+	kfree(dec->audio);
 	kfree(dec);
 	return 0;
 }
 
+static struct i2c_device_id s2250_id[] = {
+	{ "s2250_board", 0 },
+	{ }
+};
+
 static struct i2c_driver s2250_driver = {
 	.driver = {
 		.name	= "Sensoray 2250 board driver",
 	},
-	.id		= I2C_DRIVERID_S2250,
-	.detach_client	= s2250_detach,
+	.probe		= s2250_probe,
+	.remove		= s2250_remove,
 	.command	= s2250_command,
+	.id_table	= s2250_id,
 };
 
 static int __init s2250_init(void)
@@ -613,13 +602,13 @@ static int __init s2250_init(void)
 
 	r = i2c_add_driver(&s2250_driver);
 	if (r < 0)
-		return r;
-	return wis_i2c_add_driver(s2250_driver.id, s2250_detect);
+		s2250loader_cleanup();
+
+	return r;
 }
 
 static void __exit s2250_cleanup(void)
 {
-	wis_i2c_del_driver(s2250_detect);
 	i2c_del_driver(&s2250_driver);
 
 	s2250loader_cleanup();
--- linux-2.6.30-rc2.orig/drivers/staging/go7007/wis-i2c.h	2009-04-21 11:41:32.000000000 +0200
+++ linux-2.6.30-rc2/drivers/staging/go7007/wis-i2c.h	2009-04-21 13:04:14.000000000 +0200
@@ -24,21 +24,12 @@
 #define	I2C_DRIVERID_WIS_OV7640		0xf0f5
 #define	I2C_DRIVERID_WIS_TW2804		0xf0f6
 #define	I2C_DRIVERID_S2250		0xf0f7
-#define	I2C_ALGO_GO7007			0xf00000
-#define	I2C_ALGO_GO7007_USB		0xf10000
 
 /* Flag to indicate that the client needs to be accessed with SCCB semantics */
 /* We re-use the I2C_M_TEN value so the flag passes through the masks in the
  * core I2C code.  Major kludge, but the I2C layer ain't exactly flexible. */
 #define	I2C_CLIENT_SCCB			0x10
 
-typedef int (*found_proc) (struct i2c_adapter *, int, int);
-int wis_i2c_add_driver(unsigned int id, found_proc found_proc);
-void wis_i2c_del_driver(found_proc found_proc);
-
-int wis_i2c_probe_device(struct i2c_adapter *adapter,
-				unsigned int id, int addr);
-
 /* Definitions for new video decoder commands */
 
 struct video_decoder_resolution {
--- linux-2.6.30-rc2.orig/drivers/staging/go7007/wis-ov7640.c	2009-04-21 11:41:32.000000000 +0200
+++ linux-2.6.30-rc2/drivers/staging/go7007/wis-ov7640.c	2009-04-21 13:04:14.000000000 +0200
@@ -50,76 +50,54 @@ static int write_regs(struct i2c_client
 	return 0;
 }
 
-static struct i2c_driver wis_ov7640_driver;
-
-static struct i2c_client wis_ov7640_client_templ = {
-	.name		= "OV7640 (WIS)",
-	.driver		= &wis_ov7640_driver,
-};
-
-static int wis_ov7640_detect(struct i2c_adapter *adapter, int addr, int kind)
+static int wis_ov7640_probe(struct i2c_client *client,
+			    const struct i2c_device_id *id)
 {
-	struct i2c_client *client;
+	struct i2c_adapter *adapter = client->adapter;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
-		return 0;
+		return -ENODEV;
 
-	client = kmalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (client == NULL)
-		return -ENOMEM;
-	memcpy(client, &wis_ov7640_client_templ,
-			sizeof(wis_ov7640_client_templ));
-	client->adapter = adapter;
-	client->addr = addr;
 	client->flags = I2C_CLIENT_SCCB;
 
 	printk(KERN_DEBUG
 		"wis-ov7640: initializing OV7640 at address %d on %s\n",
-		addr, adapter->name);
+		client->addr, adapter->name);
 
 	if (write_regs(client, initial_registers) < 0) {
 		printk(KERN_ERR "wis-ov7640: error initializing OV7640\n");
-		kfree(client);
-		return 0;
+		return -ENODEV;
 	}
 
-	i2c_attach_client(client);
 	return 0;
 }
 
-static int wis_ov7640_detach(struct i2c_client *client)
+static int wis_ov7640_remove(struct i2c_client *client)
 {
-	int r;
-
-	r = i2c_detach_client(client);
-	if (r < 0)
-		return r;
-
-	kfree(client);
 	return 0;
 }
 
+static struct i2c_device_id wis_ov7640_id[] = {
+	{ "wis_ov7640", 0 },
+	{ }
+};
+
 static struct i2c_driver wis_ov7640_driver = {
 	.driver = {
 		.name	= "WIS OV7640 I2C driver",
 	},
-	.id		= I2C_DRIVERID_WIS_OV7640,
-	.detach_client	= wis_ov7640_detach,
+	.probe		= wis_ov7640_probe,
+	.remove		= wis_ov7640_remove,
+	.id_table	= wis_ov7640_id,
 };
 
 static int __init wis_ov7640_init(void)
 {
-	int r;
-
-	r = i2c_add_driver(&wis_ov7640_driver);
-	if (r < 0)
-		return r;
-	return wis_i2c_add_driver(wis_ov7640_driver.id, wis_ov7640_detect);
+	return i2c_add_driver(&wis_ov7640_driver);
 }
 
 static void __exit wis_ov7640_cleanup(void)
 {
-	wis_i2c_del_driver(wis_ov7640_detect);
 	i2c_del_driver(&wis_ov7640_driver);
 }
 
--- linux-2.6.30-rc2.orig/drivers/staging/go7007/wis-saa7113.c	2009-04-21 11:41:32.000000000 +0200
+++ linux-2.6.30-rc2/drivers/staging/go7007/wis-saa7113.c	2009-04-21 13:04:14.000000000 +0200
@@ -261,34 +261,19 @@ static int wis_saa7113_command(struct i2
 	return 0;
 }
 
-static struct i2c_driver wis_saa7113_driver;
-
-static struct i2c_client wis_saa7113_client_templ = {
-	.name		= "SAA7113 (WIS)",
-	.driver		= &wis_saa7113_driver,
-};
-
-static int wis_saa7113_detect(struct i2c_adapter *adapter, int addr, int kind)
+static int wis_saa7113_probe(struct i2c_client *client,
+			     const struct i2c_device_id *id)
 {
-	struct i2c_client *client;
+	struct i2c_adapter *adapter = client->adapter;
 	struct wis_saa7113 *dec;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
-		return 0;
-
-	client = kmalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (client == NULL)
-		return -ENOMEM;
-	memcpy(client, &wis_saa7113_client_templ,
-			sizeof(wis_saa7113_client_templ));
-	client->adapter = adapter;
-	client->addr = addr;
+		return -ENODEV;
 
 	dec = kmalloc(sizeof(struct wis_saa7113), GFP_KERNEL);
-	if (dec == NULL) {
-		kfree(client);
+	if (dec == NULL)
 		return -ENOMEM;
-	}
+
 	dec->norm = V4L2_STD_NTSC;
 	dec->brightness = 128;
 	dec->contrast = 71;
@@ -298,56 +283,49 @@ static int wis_saa7113_detect(struct i2c
 
 	printk(KERN_DEBUG
 		"wis-saa7113: initializing SAA7113 at address %d on %s\n",
-		addr, adapter->name);
+		client->addr, adapter->name);
 
 	if (write_regs(client, initial_registers) < 0) {
 		printk(KERN_ERR
 			"wis-saa7113: error initializing SAA7113\n");
-		kfree(client);
 		kfree(dec);
-		return 0;
+		return -ENODEV;
 	}
 
-	i2c_attach_client(client);
 	return 0;
 }
 
-static int wis_saa7113_detach(struct i2c_client *client)
+static int wis_saa7113_remove(struct i2c_client *client)
 {
 	struct wis_saa7113 *dec = i2c_get_clientdata(client);
-	int r;
-
-	r = i2c_detach_client(client);
-	if (r < 0)
-		return r;
 
-	kfree(client);
+	i2c_set_clientdata(client, NULL);
 	kfree(dec);
 	return 0;
 }
 
+static struct i2c_device_id wis_saa7113_id[] = {
+	{ "wis_saa7113", 0 },
+	{ }
+};
+
 static struct i2c_driver wis_saa7113_driver = {
 	.driver = {
 		.name	= "WIS SAA7113 I2C driver",
 	},
-	.id		= I2C_DRIVERID_WIS_SAA7113,
-	.detach_client	= wis_saa7113_detach,
+	.probe		= wis_saa7113_probe,
+	.remove		= wis_saa7113_remove,
 	.command	= wis_saa7113_command,
+	.id_table	= wis_saa7113_id,
 };
 
 static int __init wis_saa7113_init(void)
 {
-	int r;
-
-	r = i2c_add_driver(&wis_saa7113_driver);
-	if (r < 0)
-		return r;
-	return wis_i2c_add_driver(wis_saa7113_driver.id, wis_saa7113_detect);
+	return i2c_add_driver(&wis_saa7113_driver);
 }
 
 static void __exit wis_saa7113_cleanup(void)
 {
-	wis_i2c_del_driver(wis_saa7113_detect);
 	i2c_del_driver(&wis_saa7113_driver);
 }
 
--- linux-2.6.30-rc2.orig/drivers/staging/go7007/wis-saa7115.c	2009-04-21 11:41:32.000000000 +0200
+++ linux-2.6.30-rc2/drivers/staging/go7007/wis-saa7115.c	2009-04-21 13:04:14.000000000 +0200
@@ -394,34 +394,19 @@ static int wis_saa7115_command(struct i2
 	return 0;
 }
 
-static struct i2c_driver wis_saa7115_driver;
-
-static struct i2c_client wis_saa7115_client_templ = {
-	.name		= "SAA7115 (WIS)",
-	.driver		= &wis_saa7115_driver,
-};
-
-static int wis_saa7115_detect(struct i2c_adapter *adapter, int addr, int kind)
+static int wis_saa7115_probe(struct i2c_client *client,
+			     const struct i2c_device_id *id)
 {
-	struct i2c_client *client;
+	struct i2c_adapter *adapter = client->adapter;
 	struct wis_saa7115 *dec;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
-		return 0;
-
-	client = kmalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (client == NULL)
-		return -ENOMEM;
-	memcpy(client, &wis_saa7115_client_templ,
-			sizeof(wis_saa7115_client_templ));
-	client->adapter = adapter;
-	client->addr = addr;
+		return -ENODEV;
 
 	dec = kmalloc(sizeof(struct wis_saa7115), GFP_KERNEL);
-	if (dec == NULL) {
-		kfree(client);
+	if (dec == NULL)
 		return -ENOMEM;
-	}
+
 	dec->norm = V4L2_STD_NTSC;
 	dec->brightness = 128;
 	dec->contrast = 64;
@@ -431,56 +416,49 @@ static int wis_saa7115_detect(struct i2c
 
 	printk(KERN_DEBUG
 		"wis-saa7115: initializing SAA7115 at address %d on %s\n",
-		addr, adapter->name);
+		client->addr, adapter->name);
 
 	if (write_regs(client, initial_registers) < 0) {
 		printk(KERN_ERR
 			"wis-saa7115: error initializing SAA7115\n");
-		kfree(client);
 		kfree(dec);
-		return 0;
+		return -ENODEV;
 	}
 
-	i2c_attach_client(client);
 	return 0;
 }
 
-static int wis_saa7115_detach(struct i2c_client *client)
+static int wis_saa7115_remove(struct i2c_client *client)
 {
 	struct wis_saa7115 *dec = i2c_get_clientdata(client);
-	int r;
-
-	r = i2c_detach_client(client);
-	if (r < 0)
-		return r;
 
-	kfree(client);
+	i2c_set_clientdata(client, NULL);
 	kfree(dec);
 	return 0;
 }
 
+static struct i2c_device_id wis_saa7115_id[] = {
+	{ "wis_saa7115", 0 },
+	{ }
+};
+
 static struct i2c_driver wis_saa7115_driver = {
 	.driver = {
 		.name	= "WIS SAA7115 I2C driver",
 	},
-	.id		= I2C_DRIVERID_WIS_SAA7115,
-	.detach_client	= wis_saa7115_detach,
+	.probe		= wis_saa7115_probe,
+	.remove		= wis_saa7115_remove,
 	.command	= wis_saa7115_command,
+	.id_table	= wis_saa7115_id,
 };
 
 static int __init wis_saa7115_init(void)
 {
-	int r;
-
-	r = i2c_add_driver(&wis_saa7115_driver);
-	if (r < 0)
-		return r;
-	return wis_i2c_add_driver(wis_saa7115_driver.id, wis_saa7115_detect);
+	return i2c_add_driver(&wis_saa7115_driver);
 }
 
 static void __exit wis_saa7115_cleanup(void)
 {
-	wis_i2c_del_driver(wis_saa7115_detect);
 	i2c_del_driver(&wis_saa7115_driver);
 }
 
--- linux-2.6.30-rc2.orig/drivers/staging/go7007/wis-sony-tuner.c	2009-04-21 11:41:32.000000000 +0200
+++ linux-2.6.30-rc2/drivers/staging/go7007/wis-sony-tuner.c	2009-04-21 13:04:14.000000000 +0200
@@ -653,35 +653,19 @@ static int tuner_command(struct i2c_clie
 	return 0;
 }
 
-static struct i2c_driver wis_sony_tuner_driver;
-
-static struct i2c_client wis_sony_tuner_client_templ = {
-	.name		= "Sony TV Tuner (WIS)",
-	.driver		= &wis_sony_tuner_driver,
-};
-
-static int wis_sony_tuner_detect(struct i2c_adapter *adapter,
-					int addr, int kind)
+static int wis_sony_tuner_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
 {
-	struct i2c_client *client;
+	struct i2c_adapter *adapter = client->adapter;
 	struct wis_sony_tuner *t;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
-		return 0;
-
-	client = kmalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (client == NULL)
-		return -ENOMEM;
-	memcpy(client, &wis_sony_tuner_client_templ,
-			sizeof(wis_sony_tuner_client_templ));
-	client->adapter = adapter;
-	client->addr = addr;
+		return -ENODEV;
 
 	t = kmalloc(sizeof(struct wis_sony_tuner), GFP_KERNEL);
-	if (t == NULL) {
-		kfree(client);
+	if (t == NULL)
 		return -ENOMEM;
-	}
+
 	t->type = -1;
 	t->freq = 0;
 	t->mpxmode = 0;
@@ -690,50 +674,42 @@ static int wis_sony_tuner_detect(struct
 
 	printk(KERN_DEBUG
 		"wis-sony-tuner: initializing tuner at address %d on %s\n",
-		addr, adapter->name);
-
-	i2c_attach_client(client);
+		client->addr, adapter->name);
 
 	return 0;
 }
 
-static int wis_sony_tuner_detach(struct i2c_client *client)
+static int wis_sony_tuner_remove(struct i2c_client *client)
 {
 	struct wis_sony_tuner *t = i2c_get_clientdata(client);
-	int r;
-
-	r = i2c_detach_client(client);
-	if (r < 0)
-		return r;
 
+	i2c_set_clientdata(client, NULL);
 	kfree(t);
-	kfree(client);
 	return 0;
 }
 
+static struct i2c_device_id wis_sony_tuner_id[] = {
+	{ "wis_sony_tuner", 0 },
+	{ }
+};
+
 static struct i2c_driver wis_sony_tuner_driver = {
 	.driver = {
 		.name	= "WIS Sony TV Tuner I2C driver",
 	},
-	.id		= I2C_DRIVERID_WIS_SONY_TUNER,
-	.detach_client	= wis_sony_tuner_detach,
+	.probe		= wis_sony_tuner_probe,
+	.remove		= wis_sony_tuner_remove,
 	.command	= tuner_command,
+	.id_table	= wis_sony_tuner_id,
 };
 
 static int __init wis_sony_tuner_init(void)
 {
-	int r;
-
-	r = i2c_add_driver(&wis_sony_tuner_driver);
-	if (r < 0)
-		return r;
-	return wis_i2c_add_driver(wis_sony_tuner_driver.id,
-					wis_sony_tuner_detect);
+	return i2c_add_driver(&wis_sony_tuner_driver);
 }
 
 static void __exit wis_sony_tuner_cleanup(void)
 {
-	wis_i2c_del_driver(wis_sony_tuner_detect);
 	i2c_del_driver(&wis_sony_tuner_driver);
 }
 
--- linux-2.6.30-rc2.orig/drivers/staging/go7007/wis-tw2804.c	2009-04-21 11:41:32.000000000 +0200
+++ linux-2.6.30-rc2/drivers/staging/go7007/wis-tw2804.c	2009-04-21 13:04:14.000000000 +0200
@@ -291,34 +291,19 @@ static int wis_tw2804_command(struct i2c
 	return 0;
 }
 
-static struct i2c_driver wis_tw2804_driver;
-
-static struct i2c_client wis_tw2804_client_templ = {
-	.name		= "TW2804 (WIS)",
-	.driver		= &wis_tw2804_driver,
-};
-
-static int wis_tw2804_detect(struct i2c_adapter *adapter, int addr, int kind)
+static int wis_tw2804_probe(struct i2c_client *client,
+			    const struct i2c_device_id *id)
 {
-	struct i2c_client *client;
+	struct i2c_adapter *adapter = client->adapter;
 	struct wis_tw2804 *dec;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
-		return 0;
-
-	client = kmalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (client == NULL)
-		return -ENOMEM;
-	memcpy(client, &wis_tw2804_client_templ,
-			sizeof(wis_tw2804_client_templ));
-	client->adapter = adapter;
-	client->addr = addr;
+		return -ENODEV;
 
 	dec = kmalloc(sizeof(struct wis_tw2804), GFP_KERNEL);
-	if (dec == NULL) {
-		kfree(client);
+	if (dec == NULL)
 		return -ENOMEM;
-	}
+
 	dec->channel = -1;
 	dec->norm = V4L2_STD_NTSC;
 	dec->brightness = 128;
@@ -328,48 +313,42 @@ static int wis_tw2804_detect(struct i2c_
 	i2c_set_clientdata(client, dec);
 
 	printk(KERN_DEBUG "wis-tw2804: creating TW2804 at address %d on %s\n",
-		addr, adapter->name);
+		client->addr, adapter->name);
 
-	i2c_attach_client(client);
 	return 0;
 }
 
-static int wis_tw2804_detach(struct i2c_client *client)
+static int wis_tw2804_remove(struct i2c_client *client)
 {
 	struct wis_tw2804 *dec = i2c_get_clientdata(client);
-	int r;
-
-	r = i2c_detach_client(client);
-	if (r < 0)
-		return r;
 
-	kfree(client);
+	i2c_set_clientdata(client, NULL);
 	kfree(dec);
 	return 0;
 }
 
+static struct i2c_device_id wis_tw2804_id[] = {
+	{ "wis_tw2804", 0 },
+	{ }
+};
+
 static struct i2c_driver wis_tw2804_driver = {
 	.driver = {
 		.name	= "WIS TW2804 I2C driver",
 	},
-	.id		= I2C_DRIVERID_WIS_TW2804,
-	.detach_client	= wis_tw2804_detach,
+	.probe		= wis_tw2804_probe,
+	.remove		= wis_tw2804_remove,
 	.command	= wis_tw2804_command,
+	.id_table	= wis_tw2804_id,
 };
 
 static int __init wis_tw2804_init(void)
 {
-	int r;
-
-	r = i2c_add_driver(&wis_tw2804_driver);
-	if (r < 0)
-		return r;
-	return wis_i2c_add_driver(wis_tw2804_driver.id, wis_tw2804_detect);
+	return i2c_add_driver(&wis_tw2804_driver);
 }
 
 static void __exit wis_tw2804_cleanup(void)
 {
-	wis_i2c_del_driver(wis_tw2804_detect);
 	i2c_del_driver(&wis_tw2804_driver);
 }
 
--- linux-2.6.30-rc2.orig/drivers/staging/go7007/wis-tw9903.c	2009-04-21 11:41:32.000000000 +0200
+++ linux-2.6.30-rc2/drivers/staging/go7007/wis-tw9903.c	2009-04-21 13:04:14.000000000 +0200
@@ -267,34 +267,19 @@ static int wis_tw9903_command(struct i2c
 	return 0;
 }
 
-static struct i2c_driver wis_tw9903_driver;
-
-static struct i2c_client wis_tw9903_client_templ = {
-	.name		= "TW9903 (WIS)",
-	.driver		= &wis_tw9903_driver,
-};
-
-static int wis_tw9903_detect(struct i2c_adapter *adapter, int addr, int kind)
+static int wis_tw9903_probe(struct i2c_client *client,
+			    const struct i2c_device_id *id)
 {
-	struct i2c_client *client;
+	struct i2c_adapter *adapter = client->adapter;
 	struct wis_tw9903 *dec;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
-		return 0;
-
-	client = kmalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (client == NULL)
-		return -ENOMEM;
-	memcpy(client, &wis_tw9903_client_templ,
-			sizeof(wis_tw9903_client_templ));
-	client->adapter = adapter;
-	client->addr = addr;
+		return -ENODEV;
 
 	dec = kmalloc(sizeof(struct wis_tw9903), GFP_KERNEL);
-	if (dec == NULL) {
-		kfree(client);
+	if (dec == NULL)
 		return -ENOMEM;
-	}
+
 	dec->norm = V4L2_STD_NTSC;
 	dec->brightness = 0;
 	dec->contrast = 0x60;
@@ -303,55 +288,48 @@ static int wis_tw9903_detect(struct i2c_
 
 	printk(KERN_DEBUG
 		"wis-tw9903: initializing TW9903 at address %d on %s\n",
-		addr, adapter->name);
+		client->addr, adapter->name);
 
 	if (write_regs(client, initial_registers) < 0) {
 		printk(KERN_ERR "wis-tw9903: error initializing TW9903\n");
-		kfree(client);
 		kfree(dec);
-		return 0;
+		return -ENODEV;
 	}
 
-	i2c_attach_client(client);
 	return 0;
 }
 
-static int wis_tw9903_detach(struct i2c_client *client)
+static int wis_tw9903_remove(struct i2c_client *client)
 {
 	struct wis_tw9903 *dec = i2c_get_clientdata(client);
-	int r;
-
-	r = i2c_detach_client(client);
-	if (r < 0)
-		return r;
 
-	kfree(client);
+	i2c_set_clientdata(client, NULL);
 	kfree(dec);
 	return 0;
 }
 
+static struct i2c_device_id wis_tw9903_id[] = {
+	{ "wis_tw9903", 0 },
+	{ }
+};
+
 static struct i2c_driver wis_tw9903_driver = {
 	.driver = {
 		.name	= "WIS TW9903 I2C driver",
 	},
-	.id		= I2C_DRIVERID_WIS_TW9903,
-	.detach_client	= wis_tw9903_detach,
+	.probe		= wis_tw9903_probe,
+	.remove		= wis_tw9903_remove,
 	.command	= wis_tw9903_command,
+	.id_table	= wis_tw9903_id,
 };
 
 static int __init wis_tw9903_init(void)
 {
-	int r;
-
-	r = i2c_add_driver(&wis_tw9903_driver);
-	if (r < 0)
-		return r;
-	return wis_i2c_add_driver(wis_tw9903_driver.id, wis_tw9903_detect);
+	return i2c_add_driver(&wis_tw9903_driver);
 }
 
 static void __exit wis_tw9903_cleanup(void)
 {
-	wis_i2c_del_driver(wis_tw9903_detect);
 	i2c_del_driver(&wis_tw9903_driver);
 }
 
--- linux-2.6.30-rc2.orig/drivers/staging/go7007/wis-uda1342.c	2009-04-21 11:41:32.000000000 +0200
+++ linux-2.6.30-rc2/drivers/staging/go7007/wis-uda1342.c	2009-04-21 13:04:14.000000000 +0200
@@ -59,73 +59,51 @@ static int wis_uda1342_command(struct i2
 	return 0;
 }
 
-static struct i2c_driver wis_uda1342_driver;
-
-static struct i2c_client wis_uda1342_client_templ = {
-	.name		= "UDA1342 (WIS)",
-	.driver		= &wis_uda1342_driver,
-};
-
-static int wis_uda1342_detect(struct i2c_adapter *adapter, int addr, int kind)
+static int wis_uda1342_probe(struct i2c_client *client,
+			     const struct i2c_device_id *id)
 {
-	struct i2c_client *client;
+	struct i2c_adapter *adapter = client->adapter;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
-		return 0;
-
-	client = kmalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (client == NULL)
-		return -ENOMEM;
-	memcpy(client, &wis_uda1342_client_templ,
-			sizeof(wis_uda1342_client_templ));
-	client->adapter = adapter;
-	client->addr = addr;
+		return -ENODEV;
 
 	printk(KERN_DEBUG
 		"wis-uda1342: initializing UDA1342 at address %d on %s\n",
-		addr, adapter->name);
+		client->addr, adapter->name);
 
 	write_reg(client, 0x00, 0x8000); /* reset registers */
 	write_reg(client, 0x00, 0x1241); /* select input 1 */
 
-	i2c_attach_client(client);
 	return 0;
 }
 
-static int wis_uda1342_detach(struct i2c_client *client)
+static int wis_uda1342_remove(struct i2c_client *client)
 {
-	int r;
-
-	r = i2c_detach_client(client);
-	if (r < 0)
-		return r;
-
-	kfree(client);
 	return 0;
 }
 
+static struct i2c_device_id wis_uda1342_id[] = {
+	{ "wis_uda1342", 0 },
+	{ }
+};
+
 static struct i2c_driver wis_uda1342_driver = {
 	.driver = {
 		.name	= "WIS UDA1342 I2C driver",
 	},
-	.id		= I2C_DRIVERID_WIS_UDA1342,
-	.detach_client	= wis_uda1342_detach,
+	.probe		= wis_uda1342_probe,
+	.remove		= wis_uda1342_remove,
 	.command	= wis_uda1342_command,
+	.id_table	= wis_uda1342_id,
 };
 
 static int __init wis_uda1342_init(void)
 {
-	int r;
-
-	r = i2c_add_driver(&wis_uda1342_driver);
-	if (r < 0)
-		return r;
-	return wis_i2c_add_driver(wis_uda1342_driver.id, wis_uda1342_detect);
+	return i2c_add_driver(&wis_uda1342_driver);
 }
 
 static void __exit wis_uda1342_cleanup(void)
 {
-	wis_i2c_del_driver(wis_uda1342_detect);
 	i2c_del_driver(&wis_uda1342_driver);
 }
 


-- 
Jean Delvare
