Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbXKERJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbXKERJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbXKERHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:07:04 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59483 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756240AbXKERG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:06:59 -0500
Date: Mon, 5 Nov 2007 18:06:34 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Luca Olivetti <luca@ventoso.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] cleanup dvb-usb/af9005*
Message-ID: <20071105170634.GB12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- remove all the module trick code and build af9005-remote always
  into the af9005 module
- make needlessly global code static
- #if 0 unused functions

One might say that always including af9005-remote into the af9005 module 
might cause needless bloat, but the fun fact is that altogether the 
af9005 module becomes *smaller* (dvb-usb-af9005.ko goes down from 41884 
to 41244 bytes in the configuration I tested) despite *additionally* 
containing af9005-remote...

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/dvb/dvb-usb/Kconfig         |    7 --
 drivers/media/dvb/dvb-usb/Makefile        |    5 -
 drivers/media/dvb/dvb-usb/af9005-remote.c |   31 ++--------
 drivers/media/dvb/dvb-usb/af9005.c        |   63 ++++++++--------------
 drivers/media/dvb/dvb-usb/af9005.h        |    9 ---
 5 files changed, 33 insertions(+), 82 deletions(-)

d7216ff4e314d0ad37ea5f7c4c110bf7865999a5 
diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index d73934d..e3227ae 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -232,10 +232,3 @@ config DVB_USB_AF9005
 	  Say Y here to support the Afatech AF9005 based DVB-T USB1.1 receiver
 	  and the TerraTec Cinergy T USB XE (Rev.1)
 
-config DVB_USB_AF9005_REMOTE
-	tristate "Afatech AF9005 default remote control support"
-	depends on DVB_USB_AF9005
-	help
-	  Say Y here to support the default remote control decoding for the
-	  Afatech AF9005 based receiver.
-
diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-usb/Makefile
index 73ac0a9..75dc642 100644
--- a/drivers/media/dvb/dvb-usb/Makefile
+++ b/drivers/media/dvb/dvb-usb/Makefile
@@ -55,10 +55,7 @@ dvb-usb-opera-objs = opera1.o
 obj-$(CONFIG_DVB_USB_OPERA1) += dvb-usb-opera.o
 
 
-dvb-usb-af9005-objs = af9005.o af9005-fe.o
+dvb-usb-af9005-objs = af9005.o af9005-fe.o af9005-remote.o
 obj-$(CONFIG_DVB_USB_AF9005) += dvb-usb-af9005.o
 
-dvb-usb-af9005-remote-objs = af9005-remote.o
-obj-$(CONFIG_DVB_USB_AF9005_REMOTE) += dvb-usb-af9005-remote.o
-
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
diff --git a/drivers/media/dvb/dvb-usb/af9005-remote.c b/drivers/media/dvb/dvb-usb/af9005-remote.c
index ff00c0e..de670ff 100644
--- a/drivers/media/dvb/dvb-usb/af9005-remote.c
+++ b/drivers/media/dvb/dvb-usb/af9005-remote.c
@@ -24,14 +24,6 @@
  * see Documentation/dvb/REDME.dvb-usb for more information
  */
 #include "af9005.h"
-/* debug */
-int dvb_usb_af9005_remote_debug;
-module_param_named(debug, dvb_usb_af9005_remote_debug, int, 0644);
-MODULE_PARM_DESC(debug,
-		 "enable (1) or disable (0) debug messages."
-		 DVB_USB_DEBUG_STATUS);
-
-#define deb_decode(args...)   dprintk(dvb_usb_af9005_remote_debug,0x01,args)
 
 struct dvb_usb_rc_key af9005_rc_keys[] = {
 
@@ -99,12 +91,12 @@ int af9005_rc_decode(struct dvb_usb_device *d, u8 * data, int len, u32 * event,
 				if (d->last_event == repeatable_keys[i]) {
 					*state = REMOTE_KEY_REPEAT;
 					*event = d->last_event;
-					deb_decode("repeat key, event %x\n",
+					deb_rem("repeat key, event %x\n",
 						   *event);
 					return 0;
 				}
 			}
-			deb_decode("repeated key ignored (non repeatable)\n");
+			deb_rem("repeated key ignored (non repeatable)\n");
 			return 0;
 		} else if (len >= 33 * 4) {	/*32 bits + start code */
 			result = 0;
@@ -117,9 +109,9 @@ int af9005_rc_decode(struct dvb_usb_device *d, u8 * data, int len, u32 * event,
 				if (mark * 2 > space)
 					result += 1;
 			}
-			deb_decode("key pressed, raw value %x\n", result);
+			deb_rem("key pressed, raw value %x\n", result);
 			if ((result & 0xff000000) != 0xfe000000) {
-				deb_decode
+				deb_rem
 				    ("doesn't start with 0xfe, ignored\n");
 				return 0;
 			}
@@ -127,7 +119,7 @@ int af9005_rc_decode(struct dvb_usb_device *d, u8 * data, int len, u32 * event,
 			dat = (result >> 8) & 0xff;
 			invdat = (~result) & 0xff;
 			if (dat != invdat) {
-				deb_decode("code != inverted code\n");
+				deb_rem("code != inverted code\n");
 				return 0;
 			}
 			for (i = 0; i < af9005_rc_keys_size; i++) {
@@ -135,23 +127,14 @@ int af9005_rc_decode(struct dvb_usb_device *d, u8 * data, int len, u32 * event,
 				    && af9005_rc_keys[i].data == dat) {
 					*event = af9005_rc_keys[i].event;
 					*state = REMOTE_KEY_PRESSED;
-					deb_decode
+					deb_rem
 					    ("key pressed, event %x\n", *event);
 					return 0;
 				}
 			}
-			deb_decode("not found in table\n");
+			deb_rem("not found in table\n");
 		}
 	}
 	return 0;
 }
 
-EXPORT_SYMBOL(af9005_rc_keys);
-EXPORT_SYMBOL(af9005_rc_keys_size);
-EXPORT_SYMBOL(af9005_rc_decode);
-
-MODULE_AUTHOR("Luca Olivetti <luca@ventoso.org>");
-MODULE_DESCRIPTION
-    ("Standard remote control decoder for Afatech 9005 DVB-T USB1.1 stick");
-MODULE_VERSION("1.0");
-MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/dvb-usb/af9005.c b/drivers/media/dvb/dvb-usb/af9005.c
index 7db6eee..c088280 100644
--- a/drivers/media/dvb/dvb-usb/af9005.c
+++ b/drivers/media/dvb/dvb-usb/af9005.c
@@ -30,21 +30,15 @@ MODULE_PARM_DESC(debug,
 		 "set debugging level (1=info,xfer=2,rc=4,reg=8,i2c=16,fw=32 (or-able))."
 		 DVB_USB_DEBUG_STATUS);
 /* enable obnoxious led */
-int dvb_usb_af9005_led = 1;
+static int dvb_usb_af9005_led = 1;
 module_param_named(led, dvb_usb_af9005_led, bool, 0644);
 MODULE_PARM_DESC(led, "enable led (default: 1).");
 
 /* eeprom dump */
-int dvb_usb_af9005_dump_eeprom = 0;
+static int dvb_usb_af9005_dump_eeprom = 0;
 module_param_named(dump_eeprom, dvb_usb_af9005_dump_eeprom, int, 0);
 MODULE_PARM_DESC(dump_eeprom, "dump contents of the eeprom.");
 
-/* remote control decoder */
-int (*rc_decode) (struct dvb_usb_device * d, u8 * data, int len, u32 * event,
-		  int *state);
-void *rc_keys;
-int *rc_keys_size;
-
 u8 regmask[8] = { 0x01, 0x03, 0x07, 0x0f, 0x1f, 0x3f, 0x7f, 0xff };
 
 struct af9005_device_state {
@@ -52,8 +46,8 @@ struct af9005_device_state {
 	int led_state;
 };
 
-int af9005_usb_generic_rw(struct dvb_usb_device *d, u8 * wbuf, u16 wlen,
-			  u8 * rbuf, u16 rlen, int delay_ms)
+static int af9005_usb_generic_rw(struct dvb_usb_device *d, u8 * wbuf, u16 wlen,
+				 u8 * rbuf, u16 rlen, int delay_ms)
 {
 	int actlen, ret = -ENOMEM;
 
@@ -96,13 +90,16 @@ int af9005_usb_generic_rw(struct dvb_usb_device *d, u8 * wbuf, u16 wlen,
 	return ret;
 }
 
+#if 0
 int af9005_usb_generic_write(struct dvb_usb_device *d, u8 * buf, u16 len)
 {
 	return af9005_usb_generic_rw(d, buf, len, NULL, 0, 0);
 }
+#endif  /*  0  */
 
-int af9005_generic_read_write(struct dvb_usb_device *d, u16 reg,
-			      int readwrite, int type, u8 * values, int len)
+static int af9005_generic_read_write(struct dvb_usb_device *d, u16 reg,
+				     int readwrite, int type, u8 * values,
+				     int len)
 {
 	struct af9005_device_state *st = d->priv;
 	u8 obuf[16] = { 0 };
@@ -205,6 +202,7 @@ int af9005_read_ofdm_register(struct dvb_usb_device *d, u16 reg, u8 * value)
 	return ret;
 }
 
+#if 0
 int af9005_read_ofdm_registers(struct dvb_usb_device *d, u16 reg,
 			       u8 * values, int len)
 {
@@ -219,6 +217,7 @@ int af9005_read_ofdm_registers(struct dvb_usb_device *d, u16 reg,
 		debug_dump(values, len, deb_reg);
 	return ret;
 }
+#endif  /*  0  */
 
 int af9005_write_ofdm_register(struct dvb_usb_device *d, u16 reg, u8 value)
 {
@@ -235,6 +234,7 @@ int af9005_write_ofdm_register(struct dvb_usb_device *d, u16 reg, u8 value)
 	return ret;
 }
 
+#if 0
 int af9005_write_ofdm_registers(struct dvb_usb_device *d, u16 reg,
 				u8 * values, int len)
 {
@@ -251,6 +251,7 @@ int af9005_write_ofdm_registers(struct dvb_usb_device *d, u16 reg,
 		deb_reg("ok\n");
 	return ret;
 }
+#endif  /*  0  */
 
 int af9005_read_register_bits(struct dvb_usb_device *d, u16 reg, u8 pos,
 			      u8 len, u8 * value)
@@ -355,8 +356,8 @@ int af9005_write_tuner_registers(struct dvb_usb_device *d, u16 reg,
 	return 0;
 }
 
-int af9005_read_tuner_registers(struct dvb_usb_device *d, u16 reg, u8 addr,
-				u8 * values, int len)
+static int af9005_read_tuner_registers(struct dvb_usb_device *d, u16 reg,
+				       u8 addr, u8 * values, int len)
 {
 	/* don't let the name of this function mislead you: it's just used
 	   as an interface from the firmware to the i2c bus. The actual
@@ -763,7 +764,8 @@ static int af9005_boot_packet(struct usb_device *udev, int type, u8 * reply)
 	return 0;
 }
 
-int af9005_download_firmware(struct usb_device *udev, const struct firmware *fw)
+static int af9005_download_firmware(struct usb_device *udev,
+				    const struct firmware *fw)
 {
 	int i, packets, ret, act_len;
 
@@ -875,10 +877,7 @@ static int af9005_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 	u8 ibuf[256];
 
 	*state = REMOTE_NO_KEY_PRESSED;
-	if (rc_decode == NULL) {
-		/* it shouldn't never come here */
-		return 0;
-	}
+
 	/* deb_info("rc_query\n"); */
 	obuf[0] = 3;		/* rest of packet length low */
 	obuf[1] = 0;		/* rest of packet lentgh high */
@@ -906,12 +905,12 @@ static int af9005_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 	if (len > 0) {
 		deb_rc("rc data (%d) ", len);
 		debug_dump((ibuf + 6), len, deb_rc);
-		ret = rc_decode(d, &ibuf[6], len, event, state);
+		ret = af9005_rc_decode(d, &ibuf[6], len, event, state);
 		if (ret) {
-			err("rc_decode failed");
+			err("af9005_rc_decode failed");
 			return ret;
 		} else {
-			deb_rc("rc_decode state %x event %x\n", *state, *event);
+			deb_rc("af9005_rc_decode state %x event %x\n", *state, *event);
 			if (*state == REMOTE_KEY_REPEAT)
 				*event = d->last_event;
 		}
@@ -1105,29 +1104,15 @@ static int __init af9005_usb_module_init(void)
 		err("usb_register failed. (%d)", result);
 		return result;
 	}
-	rc_decode = symbol_request(af9005_rc_decode);
-	rc_keys = symbol_request(af9005_rc_keys);
-	rc_keys_size = symbol_request(af9005_rc_keys_size);
-	if (rc_decode == NULL || rc_keys == NULL || rc_keys_size == NULL) {
-		err("af9005_rc_decode function not found, disabling remote");
-		af9005_properties.rc_query = NULL;
-	} else {
-		af9005_properties.rc_key_map = rc_keys;
-		af9005_properties.rc_key_map_size = *rc_keys_size;
-	}
+
+	af9005_properties.rc_key_map = af9005_rc_keys;
+	af9005_properties.rc_key_map_size = af9005_rc_keys_size;
 
 	return 0;
 }
 
 static void __exit af9005_usb_module_exit(void)
 {
-	/* release rc decode symbols */
-	if (rc_decode != NULL)
-		symbol_put(af9005_rc_decode);
-	if (rc_keys != NULL)
-		symbol_put(af9005_rc_keys);
-	if (rc_keys_size != NULL)
-		symbol_put(af9005_rc_keys_size);
 	/* deregister this driver from the USB subsystem */
 	usb_deregister(&af9005_usb_driver);
 }
diff --git a/drivers/media/dvb/dvb-usb/af9005.h b/drivers/media/dvb/dvb-usb/af9005.h
index 0bc48a0..f2cd050 100644
--- a/drivers/media/dvb/dvb-usb/af9005.h
+++ b/drivers/media/dvb/dvb-usb/af9005.h
@@ -34,8 +34,7 @@ extern int dvb_usb_af9005_debug;
 #define deb_reg(args...)  dprintk(dvb_usb_af9005_debug,0x08,args)
 #define deb_i2c(args...)  dprintk(dvb_usb_af9005_debug,0x10,args)
 #define deb_fw(args...)   dprintk(dvb_usb_af9005_debug,0x20,args)
-
-extern int dvb_usb_af9005_led;
+#define deb_rem(args...)  dprintk(dvb_usb_af9005_debug,0x40,args)
 
 /* firmware */
 #define FW_BULKOUT_SIZE 250
@@ -3464,14 +3463,8 @@ enum {
 extern struct dvb_frontend *af9005_fe_attach(struct dvb_usb_device *d);
 extern int af9005_read_ofdm_register(struct dvb_usb_device *d, u16 reg,
 				     u8 * value);
-extern int af9005_read_ofdm_registers(struct dvb_usb_device *d, u16 reg,
-				      u8 * values, int len);
 extern int af9005_write_ofdm_register(struct dvb_usb_device *d, u16 reg,
 				      u8 value);
-extern int af9005_write_ofdm_registers(struct dvb_usb_device *d, u16 reg,
-				       u8 * values, int len);
-extern int af9005_read_tuner_registers(struct dvb_usb_device *d, u16 reg,
-				       u8 addr, u8 * values, int len);
 extern int af9005_write_tuner_registers(struct dvb_usb_device *d, u16 reg,
 					u8 * values, int len);
 extern int af9005_read_register_bits(struct dvb_usb_device *d, u16 reg,



