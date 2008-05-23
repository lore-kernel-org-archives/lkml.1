Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbYEWX2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbYEWX2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 19:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbYEWX2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 19:28:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41578 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbYEWX2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 19:28:30 -0400
Subject: Re: [PATCH 1/3] firmware: allow firmware files to be built into
	kernel	image
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       aoliva@redhat.com, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org
In-Reply-To: <20080523213147.1b6be3d0@core>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <s5hbq2xul4s.wl%tiwai@suse.de>
	 <1211554711.28967.25.camel@pmac.infradead.org>
	 <20080523163303.492c89e4@core>
	 <1211570047.28967.75.camel@pmac.infradead.org>
	 <1211571743.28967.83.camel@pmac.infradead.org>
	 <20080523213147.1b6be3d0@core>
Content-Type: text/plain
Date: Sat, 24 May 2008 00:28:12 +0100
Message-Id: <1211585292.31212.44.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-23 at 21:31 +0100, Alan Cox wrote:
> > That's fairly much the kind of thing I was expecting we might see, I'm
> > not sure it's reasonable to suddenly declare that overwriting the
> > firmware is forbidden. I'd done the version which avoided the extra
> > vmalloc and copy, but I've just reverted it.
> 
> It saves us a lot of memory in several cases where the drivers hang onto
> the firmware so I definitely think we should fix the folks assuming they
> can widdle on the firmware. That doesn't look hard to do and could save
> 50K+ on many systems.

OK, it's done. The interesting ones were:

 cxusb, for which I posted the patch
 myri10ge, which reads back into fw->data so I made it allocate a new
    buffer
 cx25840, which sends the firmware in 46-byte chunks, each with a 2-byte
    header that gets copied into fw->data. Again solved with a new
    buffer.
 or51211, which passes the buffer in an i2c_msg so I just cast it to u8*

git.infradead.org/users/dwmw2/firmware-2.6.git

diff --git a/Makefile b/Makefile
index 20b3235..ac2ab7e 100644
--- a/Makefile
+++ b/Makefile
@@ -450,7 +450,7 @@ scripts: scripts_basic include/config/auto.conf
 
 # Objects we will link into vmlinux / subdirs we need to visit
 init-y		:= init/
-drivers-y	:= drivers/ sound/
+drivers-y	:= drivers/ sound/ firmware/
 net-y		:= net/
 libs-y		:= lib/
 core-y		:= usr/
diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index d7da109..687f097 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -34,6 +34,18 @@ config FW_LOADER
 	  require userspace firmware loading support, but a module built outside
 	  the kernel tree does.
 
+config BUILTIN_FIRMWARE
+       string "Firmware blobs to build into the kernel binary"
+       depends on FW_LOADER
+       help
+         This option allows firmware to be built into the kernel, for the cases
+	 where the user either cannot or doesn't want to provide it from
+	 userspace at runtime (for example, when the firmware in question is
+	 required for accessing the boot device, and the user doesn't want to
+	 use an initrd). Multiple files should be separated with spaces, and
+	 the required files should exist under the firmware/ directory in
+	 the source tree.
+
 config DEBUG_DRIVER
 	bool "Driver Core verbose debug messages"
 	depends on DEBUG_KERNEL
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 9fd4a85..c09f060 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -49,6 +49,14 @@ struct firmware_priv {
 	struct timer_list timeout;
 };
 
+#ifdef CONFIG_FW_LOADER
+extern struct builtin_fw __start_builtin_fw[];
+extern struct builtin_fw __end_builtin_fw[];
+#else /* Module case. Avoid ifdefs later; it'll all optimise out */
+static struct builtin_fw *__start_builtin_fw = NULL;
+static struct builtin_fw *__end_builtin_fw = NULL;
+#endif
+
 static void
 fw_load_abort(struct firmware_priv *fw_priv)
 {
@@ -257,7 +265,7 @@ firmware_data_write(struct kobject *kobj, struct bin_attribute *bin_attr,
 	if (retval)
 		goto out;
 
-	memcpy(fw->data + offset, buffer, count);
+	memcpy((u8 *)fw->data + offset, buffer, count);
 
 	fw->size = max_t(size_t, offset + count, fw->size);
 	retval = count;
@@ -391,13 +399,12 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	struct device *f_dev;
 	struct firmware_priv *fw_priv;
 	struct firmware *firmware;
+	struct builtin_fw *builtin;
 	int retval;
 
 	if (!firmware_p)
 		return -EINVAL;
 
-	printk(KERN_INFO "firmware: requesting %s\n", name);
-
 	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
 	if (!firmware) {
 		printk(KERN_ERR "%s: kmalloc(struct firmware) failed\n",
@@ -406,6 +413,20 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 		goto out;
 	}
 
+	for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
+	     builtin++) {
+		if (strcmp(name, builtin->name))
+			continue;
+		printk(KERN_INFO "firmware: using built-in firmware %s\n",
+		       name);
+		firmware->size = builtin->size;
+		firmware->data = builtin->data;
+		return 0;
+	}
+
+	if (uevent)
+		printk(KERN_INFO "firmware: requesting %s\n", name);
+
 	retval = fw_setup_device(firmware, &f_dev, name, device, uevent);
 	if (retval)
 		goto error_kfree_fw;
@@ -473,8 +494,16 @@ request_firmware(const struct firmware **firmware_p, const char *name,
 void
 release_firmware(const struct firmware *fw)
 {
+	struct builtin_fw *builtin;
+
 	if (fw) {
+		for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
+		     builtin++) {
+			if (fw->data == builtin->data)
+				goto free_fw;
+		}
 		vfree(fw->data);
+	free_fw:
 		kfree(fw);
 	}
 }
diff --git a/drivers/bluetooth/bfusb.c b/drivers/bluetooth/bfusb.c
index b990805..0c211ad 100644
--- a/drivers/bluetooth/bfusb.c
+++ b/drivers/bluetooth/bfusb.c
@@ -566,7 +566,8 @@ static int bfusb_ioctl(struct hci_dev *hdev, unsigned int cmd, unsigned long arg
 	return -ENOIOCTLCMD;
 }
 
-static int bfusb_load_firmware(struct bfusb_data *data, unsigned char *firmware, int count)
+static int bfusb_load_firmware(struct bfusb_data *data,
+			       const unsigned char *firmware, int count)
 {
 	unsigned char *buf;
 	int err, pipe, len, size, sent = 0;
diff --git a/drivers/bluetooth/bt3c_cs.c b/drivers/bluetooth/bt3c_cs.c
index 7703d6e..593b7c5 100644
--- a/drivers/bluetooth/bt3c_cs.c
+++ b/drivers/bluetooth/bt3c_cs.c
@@ -470,7 +470,8 @@ static int bt3c_hci_ioctl(struct hci_dev *hdev, unsigned int cmd, unsigned long
 /* ======================== Card services HCI interaction ======================== */
 
 
-static int bt3c_load_firmware(bt3c_info_t *info, unsigned char *firmware, int count)
+static int bt3c_load_firmware(bt3c_info_t *info, const unsigned char *firmware,
+			      int count)
 {
 	char *ptr = (char *) firmware;
 	char b[9];
diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index ef73e72..6bff9d8 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -4668,7 +4668,7 @@ static inline int __devinit cyc_isfwstr(const char *str, unsigned int size)
 	return 0;
 }
 
-static inline void __devinit cyz_fpga_copy(void __iomem *fpga, u8 *data,
+static inline void __devinit cyz_fpga_copy(void __iomem *fpga, const u8 *data,
 		unsigned int size)
 {
 	for (; size > 0; size--) {
@@ -4701,10 +4701,10 @@ static int __devinit __cyz_load_fw(const struct firmware *fw,
 		const char *name, const u32 mailbox, void __iomem *base,
 		void __iomem *fpga)
 {
-	void *ptr = fw->data;
-	struct zfile_header *h = ptr;
-	struct zfile_config *c, *cs;
-	struct zfile_block *b, *bs;
+	const void *ptr = fw->data;
+	const struct zfile_header *h = ptr;
+	const struct zfile_config *c, *cs;
+	const struct zfile_block *b, *bs;
 	unsigned int a, tmp, len = fw->size;
 #define BAD_FW KERN_ERR "Bad firmware: "
 	if (len < sizeof(*h)) {
diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index 9e9003c..0a6e26a 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -255,7 +255,7 @@ static int load_all_firmwares(struct dvb_frontend *fe)
 {
 	struct xc2028_data    *priv = fe->tuner_priv;
 	const struct firmware *fw   = NULL;
-	unsigned char         *p, *endp;
+	const unsigned char   *p, *endp;
 	int                   rc = 0;
 	int		      n, n_array;
 	char		      name[33];
diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index ceae6db..d21a5a7 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -277,7 +277,7 @@ static int xc_read_reg(struct xc5000_priv *priv, u16 regAddr, u16 *i2cData)
 	return result;
 }
 
-static int xc_load_i2c_sequence(struct dvb_frontend *fe, u8 i2c_sequence[])
+static int xc_load_i2c_sequence(struct dvb_frontend *fe, const u8 *i2c_sequence)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
 
diff --git a/drivers/media/dvb/dvb-usb/cxusb.c b/drivers/media/dvb/dvb-usb/cxusb.c
index 720fcd1..94bb482 100644
--- a/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/drivers/media/dvb/dvb-usb/cxusb.c
@@ -24,6 +24,7 @@
  * see Documentation/dvb/README.dvb-usb for more information
  */
 #include <media/tuner.h>
+#include <linux/vmalloc.h>
 
 #include "cxusb.h"
 
@@ -700,12 +701,26 @@ static int bluebird_patch_dvico_firmware_download(struct usb_device *udev,
 
 		if (fw->data[idoff] == (USB_VID_DVICO & 0xff) &&
 		    fw->data[idoff + 1] == USB_VID_DVICO >> 8) {
-			fw->data[idoff + 2] =
+			struct firmware new_fw;
+			u8 *new_fw_data = vmalloc(fw->size);
+			int ret;
+
+			if (!new_fw_data)
+				return -ENOMEM;
+
+			memcpy(new_fw_data, fw->data, fw->size);
+			new_fw.size = fw->size;
+			new_fw.data = fw->data;
+
+			new_fw_data[idoff + 2] =
 				le16_to_cpu(udev->descriptor.idProduct) + 1;
-			fw->data[idoff + 3] =
+			new_fw_data[idoff + 3] =
 				le16_to_cpu(udev->descriptor.idProduct) >> 8;
 
-			return usb_cypress_load_firmware(udev, fw, CYPRESS_FX2);
+			ret = usb_cypress_load_firmware(udev, &new_fw,
+							CYPRESS_FX2);
+			vfree(new_fw_data);
+			return ret;
 		}
 	}
 
diff --git a/drivers/media/dvb/dvb-usb/gp8psk.c b/drivers/media/dvb/dvb-usb/gp8psk.c
index 9a942af..85836da 100644
--- a/drivers/media/dvb/dvb-usb/gp8psk.c
+++ b/drivers/media/dvb/dvb-usb/gp8psk.c
@@ -86,7 +86,8 @@ static int gp8psk_load_bcm4500fw(struct dvb_usb_device *d)
 {
 	int ret;
 	const struct firmware *fw = NULL;
-	u8 *ptr, *buf;
+	const u8 *ptr;
+	u8 *buf;
 	if ((ret = request_firmware(&fw, bcm4500_firmware,
 					&d->udev->dev)) != 0) {
 		err("did not find the bcm4500 firmware file. (%s) "
diff --git a/drivers/media/dvb/frontends/bcm3510.c b/drivers/media/dvb/frontends/bcm3510.c
index d268e65..cf5e576 100644
--- a/drivers/media/dvb/frontends/bcm3510.c
+++ b/drivers/media/dvb/frontends/bcm3510.c
@@ -590,7 +590,8 @@ static void bcm3510_release(struct dvb_frontend* fe)
  */
 #define BCM3510_DEFAULT_FIRMWARE "dvb-fe-bcm3510-01.fw"
 
-static int bcm3510_write_ram(struct bcm3510_state *st, u16 addr, u8 *b, u16 len)
+static int bcm3510_write_ram(struct bcm3510_state *st, u16 addr, const u8 *b,
+			     u16 len)
 {
 	int ret = 0,i;
 	bcm3510_register_value vH, vL,vD;
@@ -614,7 +615,7 @@ static int bcm3510_download_firmware(struct dvb_frontend* fe)
 	struct bcm3510_state* st = fe->demodulator_priv;
 	const struct firmware *fw;
 	u16 addr,len;
-	u8  *b;
+	const u8 *b;
 	int ret,i;
 
 	deb_info("requesting firmware\n");
diff --git a/drivers/media/dvb/frontends/nxt200x.c b/drivers/media/dvb/frontends/nxt200x.c
index 23d0228..af29835 100644
--- a/drivers/media/dvb/frontends/nxt200x.c
+++ b/drivers/media/dvb/frontends/nxt200x.c
@@ -93,7 +93,8 @@ static u8 i2c_readbytes (struct nxt200x_state* state, u8 addr, u8* buf, u8 len)
 	return 0;
 }
 
-static int nxt200x_writebytes (struct nxt200x_state* state, u8 reg, u8 *buf, u8 len)
+static int nxt200x_writebytes (struct nxt200x_state* state, u8 reg,
+			       const u8 *buf, u8 len)
 {
 	u8 buf2 [len+1];
 	int err;
diff --git a/drivers/media/dvb/frontends/or51211.c b/drivers/media/dvb/frontends/or51211.c
index 7eaa476..6afe12a 100644
--- a/drivers/media/dvb/frontends/or51211.c
+++ b/drivers/media/dvb/frontends/or51211.c
@@ -69,7 +69,7 @@ struct or51211_state {
 	u32 current_frequency;
 };
 
-static int i2c_writebytes (struct or51211_state* state, u8 reg, u8 *buf,
+static int i2c_writebytes (struct or51211_state* state, u8 reg, const u8 *buf,
 			   int len)
 {
 	int err;
@@ -77,7 +77,7 @@ static int i2c_writebytes (struct or51211_state* state, u8 reg, u8 *buf,
 	msg.addr	= reg;
 	msg.flags	= 0;
 	msg.len		= len;
-	msg.buf		= buf;
+	msg.buf		= (u8 *)buf;
 
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
 		printk(KERN_WARNING "or51211: i2c_writebytes error "
diff --git a/drivers/media/dvb/frontends/sp8870.c b/drivers/media/dvb/frontends/sp8870.c
index aa78aa1..1c9a9b4 100644
--- a/drivers/media/dvb/frontends/sp8870.c
+++ b/drivers/media/dvb/frontends/sp8870.c
@@ -98,7 +98,7 @@ static int sp8870_readreg (struct sp8870_state* state, u16 reg)
 static int sp8870_firmware_upload (struct sp8870_state* state, const struct firmware *fw)
 {
 	struct i2c_msg msg;
-	char *fw_buf = fw->data;
+	const char *fw_buf = fw->data;
 	int fw_pos;
 	u8 tx_buf[255];
 	int tx_len;
diff --git a/drivers/media/dvb/frontends/sp887x.c b/drivers/media/dvb/frontends/sp887x.c
index 49f5587..4543609 100644
--- a/drivers/media/dvb/frontends/sp887x.c
+++ b/drivers/media/dvb/frontends/sp887x.c
@@ -140,7 +140,7 @@ static int sp887x_initial_setup (struct dvb_frontend* fe, const struct firmware
 	u8 buf [BLOCKSIZE+2];
 	int i;
 	int fw_size = fw->size;
-	unsigned char *mem = fw->data;
+	const unsigned char *mem = fw->data;
 
 	dprintk("%s\n", __func__);
 
diff --git a/drivers/media/dvb/frontends/tda10048.c b/drivers/media/dvb/frontends/tda10048.c
index 090fb7d..0ab8d86 100644
--- a/drivers/media/dvb/frontends/tda10048.c
+++ b/drivers/media/dvb/frontends/tda10048.c
@@ -233,7 +233,7 @@ static u8 tda10048_readreg(struct tda10048_state *state, u8 reg)
 }
 
 static int tda10048_writeregbulk(struct tda10048_state *state, u8 reg,
-	u8 *data, u16 len)
+				 const u8 *data, u16 len)
 {
 	int ret = -EREMOTEIO;
 	struct i2c_msg msg;
diff --git a/drivers/media/dvb/frontends/tda1004x.c b/drivers/media/dvb/frontends/tda1004x.c
index 4997384..ff6b427 100644
--- a/drivers/media/dvb/frontends/tda1004x.c
+++ b/drivers/media/dvb/frontends/tda1004x.c
@@ -317,7 +317,7 @@ static int tda10046h_set_bandwidth(struct tda1004x_state *state,
 }
 
 static int tda1004x_do_upload(struct tda1004x_state *state,
-			      unsigned char *mem, unsigned int len,
+			      const unsigned char *mem, unsigned int len,
 			      u8 dspCodeCounterReg, u8 dspCodeInReg)
 {
 	u8 buf[65];
diff --git a/drivers/media/dvb/ttusb-dec/ttusb_dec.c b/drivers/media/dvb/ttusb-dec/ttusb_dec.c
index 42eee04..8af88f1 100644
--- a/drivers/media/dvb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/dvb/ttusb-dec/ttusb_dec.c
@@ -1275,7 +1275,7 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
 	u8 b1[] = { 0x61 };
 	u8 *b;
 	char idstring[21];
-	u8 *firmware = NULL;
+	const u8 *firmware = NULL;
 	size_t firmware_size = 0;
 	u16 firmware_csum = 0;
 	u16 firmware_csum_ns;
diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index f20a01c..f93f1ad 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -3767,7 +3767,8 @@ static int terratec_active_radio_upgrade(struct bttv *btv)
 #define BTTV_ALT_DCLK		0x100000
 #define BTTV_ALT_NCONFIG	0x800000
 
-static int __devinit pvr_altera_load(struct bttv *btv, u8 *micro, u32 microlen)
+static int __devinit pvr_altera_load(struct bttv *btv, const u8 *micro,
+				     u32 microlen)
 {
 	u32 n;
 	u8 bits;
diff --git a/drivers/media/video/cx25840/cx25840-firmware.c b/drivers/media/video/cx25840/cx25840-firmware.c
index 620d295..5c08ede 100644
--- a/drivers/media/video/cx25840/cx25840-firmware.c
+++ b/drivers/media/video/cx25840/cx25840-firmware.c
@@ -79,7 +79,7 @@ static int check_fw_load(struct i2c_client *client, int size)
 	return 0;
 }
 
-static int fw_write(struct i2c_client *client, u8 *data, int size)
+static int fw_write(struct i2c_client *client, const u8 *data, int size)
 {
 	if (i2c_master_send(client, data, size) < size) {
 		v4l_err(client, "firmware load i2c failure\n");
@@ -93,7 +93,8 @@ int cx25840_loadfw(struct i2c_client *client)
 {
 	struct cx25840_state *state = i2c_get_clientdata(client);
 	const struct firmware *fw = NULL;
-	u8 buffer[4], *ptr;
+	u8 buffer[FWSEND];
+	const u8 *ptr;
 	int size, retval;
 
 	if (state->is_cx23885)
@@ -108,6 +109,8 @@ int cx25840_loadfw(struct i2c_client *client)
 
 	buffer[0] = 0x08;
 	buffer[1] = 0x02;
+
+	/* Do we really need to do the first two bytes first? */
 	buffer[2] = fw->data[0];
 	buffer[3] = fw->data[1];
 	retval = fw_write(client, buffer, 4);
@@ -118,19 +121,21 @@ int cx25840_loadfw(struct i2c_client *client)
 	}
 
 	size = fw->size - 2;
-	ptr = fw->data;
+	ptr = fw->data + 2;
 	while (size > 0) {
-		ptr[0] = 0x08;
-		ptr[1] = 0x02;
-		retval = fw_write(client, ptr, min(FWSEND, size + 2));
+		int len = min(FWSEND - 2, size);
+
+		memcpy(buffer + 2, ptr, len);
+
+		retval = fw_write(client, ptr, len + 2);
 
 		if (retval < 0) {
 			release_firmware(fw);
 			return retval;
 		}
 
-		size -= FWSEND - 2;
-		ptr += FWSEND - 2;
+		size -= len;
+		ptr += len;
 	}
 
 	end_fw_load(client);
diff --git a/drivers/net/cxgb3/common.h b/drivers/net/cxgb3/common.h
index 579bee4..8e8ebd7 100644
--- a/drivers/net/cxgb3/common.h
+++ b/drivers/net/cxgb3/common.h
@@ -686,8 +686,9 @@ int t3_seeprom_write(struct adapter *adapter, u32 addr, __le32 data);
 int t3_seeprom_wp(struct adapter *adapter, int enable);
 int t3_get_tp_version(struct adapter *adapter, u32 *vers);
 int t3_check_tpsram_version(struct adapter *adapter, int *must_load);
-int t3_check_tpsram(struct adapter *adapter, u8 *tp_ram, unsigned int size);
-int t3_set_proto_sram(struct adapter *adap, u8 *data);
+int t3_check_tpsram(struct adapter *adapter, const u8 *tp_ram,
+		    unsigned int size);
+int t3_set_proto_sram(struct adapter *adap, const u8 *data);
 int t3_read_flash(struct adapter *adapter, unsigned int addr,
 		  unsigned int nwords, u32 *data, int byte_oriented);
 int t3_load_fw(struct adapter *adapter, const u8 * fw_data, unsigned int size);
diff --git a/drivers/net/cxgb3/t3_hw.c b/drivers/net/cxgb3/t3_hw.c
index d405a93..47d5178 100644
--- a/drivers/net/cxgb3/t3_hw.c
+++ b/drivers/net/cxgb3/t3_hw.c
@@ -923,7 +923,8 @@ int t3_check_tpsram_version(struct adapter *adapter, int *must_load)
  *	Checks if an adapter's tp sram is compatible with the driver.
  *	Returns 0 if the versions are compatible, a negative error otherwise.
  */
-int t3_check_tpsram(struct adapter *adapter, u8 *tp_sram, unsigned int size)
+int t3_check_tpsram(struct adapter *adapter, const u8 *tp_sram,
+		    unsigned int size)
 {
 	u32 csum;
 	unsigned int i;
@@ -2875,10 +2876,10 @@ static void ulp_config(struct adapter *adap, const struct tp_params *p)
  *
  *	Write the contents of the protocol SRAM.
  */
-int t3_set_proto_sram(struct adapter *adap, u8 *data)
+int t3_set_proto_sram(struct adapter *adap, const u8 *data)
 {
 	int i;
-	__be32 *buf = (__be32 *)data;
+	const __be32 *buf = (const __be32 *)data;
 
 	for (i = 0; i < PROTO_SRAM_LINES; i++) {
 		t3_write_reg(adap, A_TP_EMBED_OP_FIELD5, be32_to_cpu(*buf++));
diff --git a/drivers/net/irda/irda-usb.c b/drivers/net/irda/irda-usb.c
index 6f50ed7..18b471c 100644
--- a/drivers/net/irda/irda-usb.c
+++ b/drivers/net/irda/irda-usb.c
@@ -1024,7 +1024,7 @@ static int irda_usb_is_receiving(struct irda_usb_cb *self)
  *   Upload firmware code to SigmaTel 421X IRDA-USB dongle
  */
 static int stir421x_fw_upload(struct irda_usb_cb *self,
-			     unsigned char *patch,
+			     const unsigned char *patch,
 			     const unsigned int patch_len)
 {
         int ret = -ENOMEM;
@@ -1073,11 +1073,11 @@ static int stir421x_fw_upload(struct irda_usb_cb *self,
   */
 static int stir421x_patch_device(struct irda_usb_cb *self)
 {
-        unsigned int i;
-        int ret;
-        char stir421x_fw_name[11];
-        const struct firmware *fw;
-        unsigned char *fw_version_ptr; /* pointer to version string */
+	unsigned int i;
+	int ret;
+	char stir421x_fw_name[11];
+	const struct firmware *fw;
+	const unsigned char *fw_version_ptr; /* pointer to version string */
 	unsigned long fw_version = 0;
 
         /*
diff --git a/drivers/net/myri10ge/myri10ge.c b/drivers/net/myri10ge/myri10ge.c
index c91b12e..ab7a80b 100644
--- a/drivers/net/myri10ge/myri10ge.c
+++ b/drivers/net/myri10ge/myri10ge.c
@@ -529,6 +529,7 @@ static int myri10ge_load_hotplug_firmware(struct myri10ge_priv *mgp, u32 * size)
 	unsigned crc, reread_crc;
 	const struct firmware *fw;
 	struct device *dev = &mgp->pdev->dev;
+	unsigned char *fw_readback;
 	struct mcp_gen_header *hdr;
 	size_t hdr_offset;
 	int status;
@@ -571,9 +572,15 @@ static int myri10ge_load_hotplug_firmware(struct myri10ge_priv *mgp, u32 * size)
 		mb();
 		readb(mgp->sram);
 	}
+	fw_readback = vmalloc(fw->size);
+	if (!fw_readback) {
+		status = -ENOMEM;
+		goto abort_with_fw;
+	}
 	/* corruption checking is good for parity recovery and buggy chipset */
-	memcpy_fromio(fw->data, mgp->sram + MYRI10GE_FW_OFFSET, fw->size);
-	reread_crc = crc32(~0, fw->data, fw->size);
+	memcpy_fromio(fw_readback, mgp->sram + MYRI10GE_FW_OFFSET, fw->size);
+	reread_crc = crc32(~0, fw_readback, fw->size);
+	vfree(fw_readback);
 	if (crc != reread_crc) {
 		dev_err(dev, "CRC failed(fw-len=%u), got 0x%x (expect 0x%x)\n",
 			(unsigned)fw->size, reread_crc, crc);
diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index 438e63e..d1acef7 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -560,7 +560,7 @@ static const struct {
 static void build_wpa_mib(struct atmel_private *priv);
 static int atmel_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 static void atmel_copy_to_card(struct net_device *dev, u16 dest,
-			       unsigned char *src, u16 len);
+			       const unsigned char *src, u16 len);
 static void atmel_copy_to_host(struct net_device *dev, unsigned char *dest,
 			       u16 src, u16 len);
 static void atmel_set_gcr(struct net_device *dev, u16 mask);
@@ -3853,7 +3853,7 @@ static int reset_atmel_card(struct net_device *dev)
 	if (priv->card_type == CARD_TYPE_EEPROM) {
 		/* copy in firmware if needed */
 		const struct firmware *fw_entry = NULL;
-		unsigned char *fw;
+		const unsigned char *fw;
 		int len = priv->firmware_length;
 		if (!(fw = priv->firmware)) {
 			if (priv->firmware_type == ATMEL_FW_TYPE_NONE) {
@@ -4120,7 +4120,7 @@ static void atmel_writeAR(struct net_device *dev, u16 data)
 }
 
 static void atmel_copy_to_card(struct net_device *dev, u16 dest,
-			       unsigned char *src, u16 len)
+			       const unsigned char *src, u16 len)
 {
 	int i;
 	atmel_writeAR(dev, dest);
diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
index 54280e2..d075b44 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -122,7 +122,7 @@ static inline void if_cs_write16(struct if_cs_card *card, uint reg, u16 val)
 static inline void if_cs_write16_rep(
 	struct if_cs_card *card,
 	uint reg,
-	void *buf,
+	const void *buf,
 	unsigned long count)
 {
 	if (debug_output)
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 51f664b..3dd537b 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -392,7 +392,7 @@ static int if_sdio_prog_helper(struct if_sdio_card *card)
 	unsigned long timeout;
 	u8 *chunk_buffer;
 	u32 chunk_size;
-	u8 *firmware;
+	const u8 *firmware;
 	size_t size;
 
 	lbs_deb_enter(LBS_DEB_SDIO);
@@ -508,7 +508,7 @@ static int if_sdio_prog_real(struct if_sdio_card *card)
 	unsigned long timeout;
 	u8 *chunk_buffer;
 	u32 chunk_size;
-	u8 *firmware;
+	const u8 *firmware;
 	size_t size, req_size;
 
 	lbs_deb_enter(LBS_DEB_SDIO);
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 8032df7..a25b670 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -293,7 +293,7 @@ static void if_usb_disconnect(struct usb_interface *intf)
 static int if_usb_send_fw_pkt(struct if_usb_card *cardp)
 {
 	struct fwdata *fwdata = cardp->ep_out_buf;
-	uint8_t *firmware = cardp->fw->data;
+	const uint8_t *firmware = cardp->fw->data;
 
 	/* If we got a CRC failure on the last block, back
 	   up and retry it */
@@ -746,7 +746,7 @@ static int if_usb_issue_boot_command(struct if_usb_card *cardp, int ivalue)
  *         len               image length
  *  @return     0 or -1
  */
-static int check_fwfile_format(uint8_t *data, uint32_t totlen)
+static int check_fwfile_format(const uint8_t *data, uint32_t totlen)
 {
 	uint32_t bincmd, exit;
 	uint32_t blksize, offset, len;
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 98ddbb3..6728254 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -375,7 +375,8 @@ static int p54u_upload_firmware_3887(struct ieee80211_hw *dev)
 	const struct firmware *fw_entry = NULL;
 	int err, alen;
 	u8 carry = 0;
-	u8 *buf, *tmp, *data;
+	u8 *buf, *tmp;
+	const u8 *data;
 	unsigned int left, remains, block_size;
 	struct x2_header *hdr;
 	unsigned long timeout;
@@ -522,7 +523,7 @@ static int p54u_upload_firmware_net2280(struct ieee80211_hw *dev)
 	void *buf;
 	__le32 reg;
 	unsigned int remains, offset;
-	u8 *data;
+	const u8 *data;
 
 	buf = kmalloc(512, GFP_KERNEL);
 	if (!buf) {
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 57bdc15..79eabaa 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -506,8 +506,8 @@ struct rt2x00lib_ops {
 	 */
 	int (*probe_hw) (struct rt2x00_dev *rt2x00dev);
 	char *(*get_firmware_name) (struct rt2x00_dev *rt2x00dev);
-	u16 (*get_firmware_crc) (void *data, const size_t len);
-	int (*load_firmware) (struct rt2x00_dev *rt2x00dev, void *data,
+	u16 (*get_firmware_crc) (const void *data, const size_t len);
+	int (*load_firmware) (struct rt2x00_dev *rt2x00dev, const void *data,
 			      const size_t len);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 9d1cdb9..b41967e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -82,7 +82,7 @@ static inline void rt2x00pci_register_write(struct rt2x00_dev *rt2x00dev,
 static inline void
 rt2x00pci_register_multiwrite(struct rt2x00_dev *rt2x00dev,
 			      const unsigned long offset,
-			      void *value, const u16 length)
+			      const void *value, const u16 length)
 {
 	memcpy_toio(rt2x00dev->csr.base + offset, value, length);
 }
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 14bc7b2..bb78de5 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -915,7 +915,7 @@ static char *rt61pci_get_firmware_name(struct rt2x00_dev *rt2x00dev)
 	return fw_name;
 }
 
-static u16 rt61pci_get_firmware_crc(void *data, const size_t len)
+static u16 rt61pci_get_firmware_crc(const void *data, const size_t len)
 {
 	u16 crc;
 
@@ -932,7 +932,7 @@ static u16 rt61pci_get_firmware_crc(void *data, const size_t len)
 	return crc;
 }
 
-static int rt61pci_load_firmware(struct rt2x00_dev *rt2x00dev, void *data,
+static int rt61pci_load_firmware(struct rt2x00_dev *rt2x00dev, const void *data,
 				 const size_t len)
 {
 	int i;
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index da19a3a..36c2f17 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -850,7 +850,7 @@ static char *rt73usb_get_firmware_name(struct rt2x00_dev *rt2x00dev)
 	return FIRMWARE_RT2571;
 }
 
-static u16 rt73usb_get_firmware_crc(void *data, const size_t len)
+static u16 rt73usb_get_firmware_crc(const void *data, const size_t len)
 {
 	u16 crc;
 
@@ -867,13 +867,13 @@ static u16 rt73usb_get_firmware_crc(void *data, const size_t len)
 	return crc;
 }
 
-static int rt73usb_load_firmware(struct rt2x00_dev *rt2x00dev, void *data,
+static int rt73usb_load_firmware(struct rt2x00_dev *rt2x00dev, const void *data,
 				 const size_t len)
 {
 	unsigned int i;
 	int status;
 	u32 reg;
-	char *ptr = data;
+	const char *ptr = data;
 	char *cache;
 	int buflen;
 	int timeout;
diff --git a/drivers/net/wireless/zd1201.c b/drivers/net/wireless/zd1201.c
index d5c0c66..78baa0f 100644
--- a/drivers/net/wireless/zd1201.c
+++ b/drivers/net/wireless/zd1201.c
@@ -49,7 +49,7 @@ MODULE_DEVICE_TABLE(usb, zd1201_table);
 static int zd1201_fw_upload(struct usb_device *dev, int apfw)
 {
 	const struct firmware *fw_entry;
-	char *data;
+	const char *data;
 	unsigned long len;
 	int err;
 	unsigned char ret;
diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index 4446e3d..8630a75 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -1093,9 +1093,9 @@ out:
  * @bytes_to_verify: total bytes to verify
  */
 int asd_verify_flash_seg(struct asd_ha_struct *asd_ha,
-		void *src, u32 dest_offset, u32 bytes_to_verify)
+			 const void *src, u32 dest_offset, u32 bytes_to_verify)
 {
-	u8 *src_buf;
+	const u8 *src_buf;
 	u8 flash_char;
 	int err;
 	u32 nv_offset, reg, i;
@@ -1105,7 +1105,7 @@ int asd_verify_flash_seg(struct asd_ha_struct *asd_ha,
 
 	err = FLASH_OK;
 	nv_offset = dest_offset;
-	src_buf = (u8 *)src;
+	src_buf = (const u8 *)src;
 	for (i = 0; i < bytes_to_verify; i++) {
 		flash_char = asd_read_reg_byte(asd_ha, reg + nv_offset + i);
 		if (flash_char != src_buf[i]) {
@@ -1124,9 +1124,9 @@ int asd_verify_flash_seg(struct asd_ha_struct *asd_ha,
  * @bytes_to_write: total bytes to write
  */
 int asd_write_flash_seg(struct asd_ha_struct *asd_ha,
-		void *src, u32 dest_offset, u32 bytes_to_write)
+			const void *src, u32 dest_offset, u32 bytes_to_write)
 {
-	u8 *src_buf;
+	const u8 *src_buf;
 	u32 nv_offset, reg, i;
 	int err;
 
@@ -1153,7 +1153,7 @@ int asd_write_flash_seg(struct asd_ha_struct *asd_ha,
 		return err;
 	}
 
-	src_buf = (u8 *)src;
+	src_buf = (const u8 *)src;
 	for (i = 0; i < bytes_to_write; i++) {
 		/* Setup program command sequence */
 		switch (asd_ha->hw_prof.flash.method) {
diff --git a/drivers/scsi/aic94xx/aic94xx_sds.h b/drivers/scsi/aic94xx/aic94xx_sds.h
index bb9795a..a06dc01 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.h
+++ b/drivers/scsi/aic94xx/aic94xx_sds.h
@@ -110,9 +110,9 @@ struct bios_file_header {
 };
 
 int asd_verify_flash_seg(struct asd_ha_struct *asd_ha,
-		void *src, u32 dest_offset, u32 bytes_to_verify);
+		const void *src, u32 dest_offset, u32 bytes_to_verify);
 int asd_write_flash_seg(struct asd_ha_struct *asd_ha,
-		void *src, u32 dest_offset, u32 bytes_to_write);
+		const void *src, u32 dest_offset, u32 bytes_to_write);
 int asd_chk_write_status(struct asd_ha_struct *asd_ha,
 		u32 sector_addr, u8 erase_flag);
 int asd_check_flash_type(struct asd_ha_struct *asd_ha);
diff --git a/drivers/scsi/aic94xx/aic94xx_seq.c b/drivers/scsi/aic94xx/aic94xx_seq.c
index f4272ac..8f98e33 100644
--- a/drivers/scsi/aic94xx/aic94xx_seq.c
+++ b/drivers/scsi/aic94xx/aic94xx_seq.c
@@ -46,7 +46,7 @@
 static const struct firmware *sequencer_fw;
 static u16 cseq_vecs[CSEQ_NUM_VECS], lseq_vecs[LSEQ_NUM_VECS], mode2_task,
 	cseq_idle_loop, lseq_idle_loop;
-static u8 *cseq_code, *lseq_code;
+static const u8 *cseq_code, *lseq_code;
 static u32 cseq_code_size, lseq_code_size;
 
 static u16 first_scb_site_no = 0xFFFF;
@@ -1235,7 +1235,8 @@ int asd_release_firmware(void)
 static int asd_request_firmware(struct asd_ha_struct *asd_ha)
 {
 	int err, i;
-	struct sequencer_file_header header, *hdr_ptr;
+	struct sequencer_file_header header;
+	const struct sequencer_file_header *hdr_ptr;
 	u32 csum = 0;
 	u16 *ptr_cseq_vecs, *ptr_lseq_vecs;
 
@@ -1249,7 +1250,7 @@ static int asd_request_firmware(struct asd_ha_struct *asd_ha)
 	if (err)
 		return err;
 
-	hdr_ptr = (struct sequencer_file_header *)sequencer_fw->data;
+	hdr_ptr = (const struct sequencer_file_header *)sequencer_fw->data;
 
 	header.csum = le32_to_cpu(hdr_ptr->csum);
 	header.major = le32_to_cpu(hdr_ptr->major);
diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 5ea3093..90583d6 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -820,7 +820,7 @@ reschedule:
 }
 
 static int cxacru_fw(struct usb_device *usb_dev, enum cxacru_fw_request fw,
-		     u8 code1, u8 code2, u32 addr, u8 *data, int size)
+		     u8 code1, u8 code2, u32 addr, const u8 *data, int size)
 {
 	int ret;
 	u8 *buf;
diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index 5f71ff3..cb01b51 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -579,7 +579,7 @@ MODULE_PARM_DESC(annex,
  * uea_send_modem_cmd - Send a command for pre-firmware devices.
  */
 static int uea_send_modem_cmd(struct usb_device *usb,
-		u16 addr, u16 size, u8 * buff)
+			      u16 addr, u16 size, const u8 *buff)
 {
 	int ret = -ENOMEM;
 	u8 *xfer_buff;
@@ -604,7 +604,8 @@ static int uea_send_modem_cmd(struct usb_device *usb,
 static void uea_upload_pre_firmware(const struct firmware *fw_entry, void *context)
 {
 	struct usb_device *usb = context;
-	u8 *pfw, value;
+	const u8 *pfw;
+	u8 value;
 	u32 crc = 0;
 	int ret, size;
 
@@ -720,7 +721,7 @@ static int uea_load_firmware(struct usb_device *usb, unsigned int ver)
 /*
  * Make sure that the DSP code provided is safe to use.
  */
-static int check_dsp_e1(u8 *dsp, unsigned int len)
+static int check_dsp_e1(const u8 *dsp, unsigned int len)
 {
 	u8 pagecount, blockcount;
 	u16 blocksize;
@@ -771,7 +772,7 @@ static int check_dsp_e1(u8 *dsp, unsigned int len)
 	return 0;
 }
 
-static int check_dsp_e4(u8 *dsp, int len)
+static int check_dsp_e4(const u8 *dsp, int len)
 {
 	int i;
 	struct l1_code *p = (struct l1_code *) dsp;
@@ -819,7 +820,7 @@ static int check_dsp_e4(u8 *dsp, int len)
 /*
  * send data to the idma pipe
  * */
-static int uea_idma_write(struct uea_softc *sc, void *data, u32 size)
+static int uea_idma_write(struct uea_softc *sc, const void *data, u32 size)
 {
 	int ret = -ENOMEM;
 	u8 *xfer_buff;
@@ -903,7 +904,7 @@ static void uea_load_page_e1(struct work_struct *work)
 	u16 ovl = sc->ovl;
 	struct block_info_e1 bi;
 
-	u8 *p;
+	const u8 *p;
 	u8 pagecount, blockcount;
 	u16 blockaddr, blocksize;
 	u32 pageoffset;
@@ -986,7 +987,7 @@ static void __uea_load_page_e4(struct uea_softc *sc, u8 pageno, int boot)
 	bi.wReserved = cpu_to_be16(UEA_RESERVED);
 
 	do {
-		u8 *blockoffset;
+		const u8 *blockoffset;
 		unsigned int blocksize;
 
 		blockidx = &p->page_header[blockno];
@@ -1095,7 +1096,7 @@ static inline int wait_cmv_ack(struct uea_softc *sc)
 #define UCDC_SEND_ENCAPSULATED_COMMAND 0x00
 
 static int uea_request(struct uea_softc *sc,
-		u16 value, u16 index, u16 size, void *data)
+		u16 value, u16 index, u16 size, const void *data)
 {
 	u8 *xfer_buff;
 	int ret = -ENOMEM;
@@ -1891,7 +1892,8 @@ static int load_XILINX_firmware(struct uea_softc *sc)
 {
 	const struct firmware *fw_entry;
 	int ret, size, u, ln;
-	u8 *pfw, value;
+	const u8 *pfw;
+	u8 value;
 	char *fw_name = FW_DIR "930-fpga.bin";
 
 	uea_enters(INS_TO_USBDEV(sc));
diff --git a/firmware/Makefile b/firmware/Makefile
new file mode 100644
index 0000000..f6b0c3c
--- /dev/null
+++ b/firmware/Makefile
@@ -0,0 +1,24 @@
+#
+# kbuild file for firmware/
+#
+
+firmware_bins := $(subst ",,$(CONFIG_BUILTIN_FIRMWARE))
+firmware_objs := $(patsubst %,%.o, $(firmware_bins))
+firmware_srcs := $(patsubst %,$(obj)/%.c, $(firmware_bins))
+
+
+quiet_cmd_fwbin = MK_FW   $@
+      cmd_fwbin = echo '/* File automatically generated */' > $@ ;	\
+		  echo '\#include <linux/firmware.h>' >> $@ ;		\
+		  echo 'static const unsigned char fw[] = {' >> $@ ;	\
+		  od -t x1 -A none -v $(srctree)/$(patsubst %.c,%,$@) | \
+		   sed -e 's/ /, 0x/g' -e 's/^,//' -e 's/$$/,/' >> $@ ; \
+		  echo '};' >> $@ ;					\
+		  echo 'DECLARE_BUILTIN_FIRMWARE("$(patsubst firmware/%.c,%,$@)",fw);' >> $@
+
+$(firmware_srcs): $(obj)/%.c: $(srctree)/$(obj)/%
+	$(call cmd,fwbin)
+
+obj-y := $(firmware_objs)
+
+targets := $(firmware_objs)
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f054778..8d71a40 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -86,6 +86,13 @@
 		VMLINUX_SYMBOL(__end_pci_fixups_resume) = .;		\
 	}								\
 									\
+	/* Built-in firmware blobs */					\
+	.builtin_fw        : AT(ADDR(.builtin_fw) - LOAD_OFFSET) {	\
+		VMLINUX_SYMBOL(__start_builtin_fw) = .;			\
+		*(.builtin_fw)						\
+		VMLINUX_SYMBOL(__end_builtin_fw) = .;			\
+	}								\
+									\
 	/* RapidIO route ops */						\
 	.rio_route        : AT(ADDR(.rio_route) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start_rio_route_ops) = .;		\
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 4d10c73..279eaad 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -1,18 +1,39 @@
 #ifndef _LINUX_FIRMWARE_H
 #define _LINUX_FIRMWARE_H
+
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/compiler.h>
+
 #define FIRMWARE_NAME_MAX 30 
 #define FW_ACTION_NOHOTPLUG 0
 #define FW_ACTION_HOTPLUG 1
 
 struct firmware {
 	size_t size;
-	u8 *data;
+	const u8 *data;
 };
 
 struct device;
 
+struct builtin_fw {
+	char *name;
+	void *data;
+	unsigned long size;
+};
+
+/* We have to play tricks here much like stringify() to get the
+   __COUNTER__ macro to be expanded as we want it */
+#define __fw_concat1(x,y) x##y
+#define __fw_concat(x,y) __fw_concat1(x,y)
+
+#define DECLARE_BUILTIN_FIRMWARE(name, blob)				     \
+	DECLARE_BUILTIN_FIRMWARE_SIZE(name, &(blob), sizeof(blob))
+
+#define DECLARE_BUILTIN_FIRMWARE_SIZE(name, blob, size)			     \
+	static const struct builtin_fw __fw_concat(__builtin_fw,__COUNTER__) \
+	__used __section(.builtin_fw) = { name, blob, size }
+
 #if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
 int request_firmware(const struct firmware **fw, const char *name,
 		     struct device *device);
diff --git a/sound/drivers/vx/vx_core.c b/sound/drivers/vx/vx_core.c
index 9953886..585af2e 100644
--- a/sound/drivers/vx/vx_core.c
+++ b/sound/drivers/vx/vx_core.c
@@ -453,7 +453,7 @@ int snd_vx_load_boot_image(struct vx_core *chip, const struct firmware *boot)
 			vx_outb(chip, TXM, 0);
 			vx_outb(chip, TXL, 0);
 		} else {
-			unsigned char *image = boot->data + i;
+			const unsigned char *image = boot->data + i;
 			if (vx_wait_isr_bit(chip, ISR_TX_EMPTY) < 0) {
 				snd_printk(KERN_ERR "dsp boot failed at %d\n", i);
 				return -EIO;
@@ -671,7 +671,7 @@ int snd_vx_dsp_load(struct vx_core *chip, const struct firmware *dsp)
 	unsigned int i;
 	int err;
 	unsigned int csum = 0;
-	unsigned char *image, *cptr;
+	const unsigned char *image, *cptr;
 
 	snd_assert(dsp->size % 3 == 0, return -EINVAL);
 
diff --git a/sound/pci/korg1212/Makefile b/sound/pci/korg1212/Makefile
index f11ce1b..7a5ebdf 100644
--- a/sound/pci/korg1212/Makefile
+++ b/sound/pci/korg1212/Makefile
@@ -7,3 +7,4 @@ snd-korg1212-objs := korg1212.o
 
 # Toplevel Module Dependency
 obj-$(CONFIG_SND_KORG1212) += snd-korg1212.o
+obj-$(CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL) += korg1212-firmware.o
diff --git a/sound/pci/korg1212/korg1212-firmware.h b/sound/pci/korg1212/korg1212-firmware.c
similarity index 99%
rename from sound/pci/korg1212/korg1212-firmware.h
rename to sound/pci/korg1212/korg1212-firmware.c
index f6f5b91..2468ee2 100644
--- a/sound/pci/korg1212/korg1212-firmware.h
+++ b/sound/pci/korg1212/korg1212-firmware.c
@@ -1,3 +1,4 @@
+#include <linux/firmware.h>
 static char dspCode [] = {
 0x01,0xff,0x18,0xff,0xf5,0xff,0xcf,0xff,0x00,0xff,0x00,0xff,0xff,0xff,0x00,0xff,
 0x00,0xff,0x00,0xff,0xff,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0xff,0xff,0x00,0xff,
@@ -985,3 +986,6 @@ static char dspCode [] = {
 0x00,0xff,0x40,0xff,0xff,0xff,0xc4,0xff,0x00,0xff,0x0a,0xff,0xff,0xff,0x0f,0xff,
 0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
 0xff,0xff,0xff,0xff };
+
+DECLARE_BUILTIN_FIRMWARE("korg/k1212.dsp", dspCode);
+
diff --git a/sound/pci/korg1212/korg1212.c b/sound/pci/korg1212/korg1212.c
index f4c85b5..4a44c0f 100644
--- a/sound/pci/korg1212/korg1212.c
+++ b/sound/pci/korg1212/korg1212.c
@@ -260,14 +260,6 @@ enum MonitorModeSelector {
 #define COMMAND_ACK_DELAY   13         // number of RTC ticks to wait for an acknowledgement
                                        //    from the card after sending a command.
 
-#ifdef CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL
-#include "korg1212-firmware.h"
-static const struct firmware static_dsp_code = {
-	.data = (u8 *)dspCode,
-	.size = sizeof dspCode
-};
-#endif
-
 enum ClockSourceIndex {
    K1212_CLKIDX_AdatAt44_1K = 0,    // selects source as ADAT at 44.1 kHz
    K1212_CLKIDX_AdatAt48K,          // selects source as ADAT at 48 kHz
@@ -412,9 +404,7 @@ struct snd_korg1212 {
 MODULE_DESCRIPTION("korg1212");
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("{{KORG,korg1212}}");
-#ifndef CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL
 MODULE_FIRMWARE("korg/k1212.dsp");
-#endif
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;     /* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	   /* ID for this card */
@@ -2348,9 +2338,6 @@ static int __devinit snd_korg1212_create(struct snd_card *card, struct pci_dev *
         korg1212->AdatTimeCodePhy = korg1212->sharedBufferPhy +
 		offsetof(struct KorgSharedBuffer, AdatTimeCode);
 
-#ifdef CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL
-	dsp_code = &static_dsp_code;
-#else
 	err = request_firmware(&dsp_code, "korg/k1212.dsp", &pci->dev);
 	if (err < 0) {
 		release_firmware(dsp_code);
@@ -2358,15 +2345,12 @@ static int __devinit snd_korg1212_create(struct snd_card *card, struct pci_dev *
 		snd_korg1212_free(korg1212);
 		return err;
 	}
-#endif
 
 	if (snd_dma_alloc_pages(SNDRV_DMA_TYPE_DEV, snd_dma_pci_data(pci),
 				dsp_code->size, &korg1212->dma_dsp) < 0) {
 		snd_printk(KERN_ERR "korg1212: cannot allocate dsp code memory (%zd bytes)\n", dsp_code->size);
                 snd_korg1212_free(korg1212);
-#ifndef CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL
 		release_firmware(dsp_code);
-#endif
                 return -ENOMEM;
         }
 
@@ -2376,9 +2360,7 @@ static int __devinit snd_korg1212_create(struct snd_card *card, struct pci_dev *
 
 	memcpy(korg1212->dma_dsp.area, dsp_code->data, dsp_code->size);
 
-#ifndef CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL
 	release_firmware(dsp_code);
-#endif
 
 	rc = snd_korg1212_Send1212Command(korg1212, K1212_DB_RebootCard, 0, 0, 0, 0);
 
diff --git a/sound/pci/pcxhr/pcxhr_core.c b/sound/pci/pcxhr/pcxhr_core.c
index 78aa81f..957e6af 100644
--- a/sound/pci/pcxhr/pcxhr_core.c
+++ b/sound/pci/pcxhr/pcxhr_core.c
@@ -269,7 +269,7 @@ int pcxhr_load_xilinx_binary(struct pcxhr_mgr *mgr, const struct firmware *xilin
 	unsigned int chipsc;
 	unsigned char data;
 	unsigned char mask;
-	unsigned char *image;
+	const unsigned char *image;
 
 	/* test first xilinx */
 	chipsc = PCXHR_INPL(mgr, PCXHR_PLX_CHIPSC);
@@ -316,7 +316,7 @@ static int pcxhr_download_dsp(struct pcxhr_mgr *mgr, const struct firmware *dsp)
 	int err;
 	unsigned int i;
 	unsigned int len;
-	unsigned char *data;
+	const unsigned char *data;
 	unsigned char dummy;
 	/* check the length of boot image */
 	snd_assert(dsp->size > 0, return -EINVAL);
diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index 979f7da..6a35962 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -682,7 +682,7 @@ static union firmware_version firmware_versions[] = {
 	},
 };
 
-static u32 atoh(unsigned char *in, unsigned int len)
+static u32 atoh(const unsigned char *in, unsigned int len)
 {
 	u32 sum = 0;
 	unsigned int mult = 1;
@@ -702,12 +702,12 @@ static u32 atoh(unsigned char *in, unsigned int len)
 	return sum;
 }
 
-static int senddata(struct cmdif *cif, unsigned char *in, u32 offset)
+static int senddata(struct cmdif *cif, const unsigned char *in, u32 offset)
 {
 	u32 addr;
 	u32 data;
 	u32 i;
-	unsigned char *p;
+	const unsigned char *p;
 
 	i = atoh(&in[1], 2);
 	addr = offset + atoh(&in[3], 4);
@@ -726,10 +726,10 @@ static int senddata(struct cmdif *cif, unsigned char *in, u32 offset)
 	return 0;
 }
 
-static int loadfirmware(struct cmdif *cif, unsigned char *img,
+static int loadfirmware(struct cmdif *cif, const unsigned char *img,
 			unsigned int size)
 {
-	unsigned char *in;
+	const unsigned char *in;
 	u32 laddr, saddr, t, val;
 	int err = 0;
 
diff --git a/sound/pci/vx222/vx222_ops.c b/sound/pci/vx222/vx222_ops.c
index b4bfc1a..631f3a6 100644
--- a/sound/pci/vx222/vx222_ops.c
+++ b/sound/pci/vx222/vx222_ops.c
@@ -359,7 +359,7 @@ static int vx2_load_xilinx_binary(struct vx_core *chip, const struct firmware *x
 {
 	unsigned int i;
 	unsigned int port;
-	unsigned char *image;
+	const unsigned char *image;
 
 	/* XILINX reset (wait at least 1 milisecond between reset on and off). */
 	vx_outl(chip, CNTRL, VX_CNTRL_REGISTER_VALUE | VX_XILINX_RESET_MASK);


-- 
dwmw2

