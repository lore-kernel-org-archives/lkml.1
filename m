Return-Path: <linux-kernel-owner+w=401wt.eu-S933225AbXBWW3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225AbXBWW3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 17:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933252AbXBWW33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 17:29:29 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:47070 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933225AbXBWW32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 17:29:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=thunder.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:X-Enigmail-Version:OpenPGP:Content-Type:Sender:Reply-To;
	b=f0OPfCLc983TjTFGrKEGYacnZohLdWEfqI+TJagtREMT52B9GJtqvaD3l9yxZmm89TkY1AUilv9l0bvUdLvTaOr/Uo0N8veXlQaqTX/0nhHX/ybnfvLIx89bMg3MGjIx;
Message-ID: <45DF6AB3.4010705@simon.arlott.org.uk>
Date: Fri, 23 Feb 2007 22:29:07 +0000
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Duncan Sands <duncan.sands@math.u-psud.fr>
Subject: [PATCH] cxacru: Export detailed device info through sysfs.
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig1D15DAAAB03C38C51AA839A4"
Reply-To: Simon Arlott <683ac83ca2668c1e2d1hkius0006gx02@thunder.lp0.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1D15DAAAB03C38C51AA839A4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

When the device is polled for status there is a lot of useful status
information available that is ignored. This patch stores the device
info array when the status is polled and adds sysfs files to the usb
device to allow userspace to query it. Since the device updates its
status internally once a second the poll time is changed to this, and
round_jiffies_relative is used to avoid waking the cpu unnecessarily.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 drivers/usb/atm/cxacru.c |  181 ++++++++++++++++++++++++++++++++++++++++=
++++--
 1 files changed, 176 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 71e19ae..c8b69bf 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -34,14 +34,14 @@ #include <linux/timer.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/init.h>
-#include <linux/device.h>	/* FIXME: linux/firmware.h should include it i=
tself */
+#include <linux/device.h>
 #include <linux/firmware.h>
 #include <linux/mutex.h>
=20
 #include "usbatm.h"
=20
-#define DRIVER_AUTHOR	"Roman Kagan, David Woodhouse, Duncan Sands"
-#define DRIVER_VERSION	"0.2"
+#define DRIVER_AUTHOR	"Roman Kagan, David Woodhouse, Duncan Sands, Simon=
 Arlott"
+#define DRIVER_VERSION	"0.3"
 #define DRIVER_DESC	"Conexant AccessRunner ADSL USB modem driver"
=20
 static const char cxacru_driver_name[] =3D "cxacru";
@@ -64,7 +64,7 @@ #define BR_STACK_ADDR	0x00187f10
 #define SDRAM_ENA	0x1
=20
 #define CMD_TIMEOUT	2000	/* msecs */
-#define POLL_INTERVAL	5000	/* msecs */
+#define POLL_INTERVAL	1	/* secs */
=20
 /* commands for interaction with the modem through the control channel b=
efore
  * firmware is loaded  */
@@ -159,6 +159,7 @@ struct cxacru_data {
=20
 	int line_status;
 	struct delayed_work poll_work;
+	u32 card_info[CXINF_MAX+1];
=20
 	/* contol handles */
 	struct mutex cm_serialize;
@@ -170,6 +171,151 @@ struct cxacru_data {
 	struct completion snd_done;
 };
=20
+/* Card info exported through sysfs */
+#define CXACRU__ATTR_INIT(_name) \
+static DEVICE_ATTR(_name, S_IRUGO, cxacru_sysfs_show_##_name, NULL)
+
+#define CXACRU_ATTR_INIT(_value, _type, _name) \
+static ssize_t cxacru_sysfs_show_##_name(struct device *dev, \
+	struct device_attribute *attr, char *buf) \
+{ \
+	struct usb_interface *intf =3D to_usb_interface(dev); \
+	struct usbatm_data *usbatm_instance =3D usb_get_intfdata(intf); \
+	struct cxacru_data *instance =3D usbatm_instance->driver_data; \
+	return cxacru_sysfs_showattr_##_type(instance->card_info[_value], buf);=
 \
+} \
+CXACRU__ATTR_INIT(_name)
+
+#define CXACRU_ATTR_CREATE(_v, _t, _name) CXACRU_DEVICE_CREATE_FILE(_nam=
e)
+#define CXACRU__ATTR_CREATE(_name)        CXACRU_DEVICE_CREATE_FILE(_nam=
e)
+
+#define CXACRU_ATTR_REMOVE(_v, _t, _name) CXACRU_DEVICE_REMOVE_FILE(_nam=
e)
+#define CXACRU__ATTR_REMOVE(_name)        CXACRU_DEVICE_REMOVE_FILE(_nam=
e)
+
+static ssize_t cxacru_sysfs_showattr_u32(u32 value, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%u\n", value);
+}
+
+static ssize_t cxacru_sysfs_showattr_s8(s8 value, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", value);
+}
+
+static ssize_t cxacru_sysfs_showattr_dB(s16 value, char *buf)
+{
+	if (unlikely(value < 0)) {
+		return snprintf(buf, PAGE_SIZE, "%d.%02u\n",
+						value / 100, -value % 100);
+	} else {
+		return snprintf(buf, PAGE_SIZE, "%d.%02u\n",
+						value / 100, value % 100);
+	}
+}
+
+static ssize_t cxacru_sysfs_showattr_bool(u32 value, char *buf)
+{
+	switch (value) {
+	case 0: return snprintf(buf, PAGE_SIZE, "no\n");
+	case 1: return snprintf(buf, PAGE_SIZE, "yes\n");
+	default: return 0;
+	}
+}
+
+static ssize_t cxacru_sysfs_showattr_LINK(u32 value, char *buf)
+{
+	switch (value) {
+	case 1: return snprintf(buf, PAGE_SIZE, "not connected\n");
+	case 2: return snprintf(buf, PAGE_SIZE, "connected\n");
+	case 3: return snprintf(buf, PAGE_SIZE, "lost\n");
+	default: return snprintf(buf, PAGE_SIZE, "unknown (%u)\n", value);
+	}
+}
+
+static ssize_t cxacru_sysfs_showattr_LINE(u32 value, char *buf)
+{
+	switch (value) {
+	case 0: return snprintf(buf, PAGE_SIZE, "down\n");
+	case 1: return snprintf(buf, PAGE_SIZE, "attempting to activate\n");
+	case 2: return snprintf(buf, PAGE_SIZE, "training\n");
+	case 3: return snprintf(buf, PAGE_SIZE, "channel analysis\n");
+	case 4: return snprintf(buf, PAGE_SIZE, "exchange\n");
+	case 5: return snprintf(buf, PAGE_SIZE, "up\n");
+	case 6: return snprintf(buf, PAGE_SIZE, "waiting\n");
+	case 7: return snprintf(buf, PAGE_SIZE, "initialising\n");
+	default: return snprintf(buf, PAGE_SIZE, "unknown (%u)\n", value);
+	}
+}
+
+static ssize_t cxacru_sysfs_showattr_MODU(u32 value, char *buf)
+{
+	switch (value) {
+	case 0: return 0;
+	case 1: return snprintf(buf, PAGE_SIZE, "ANSI T1.413\n");
+	case 2: return snprintf(buf, PAGE_SIZE, "ITU-T G.992.1 (G.DMT)\n");
+	case 3: return snprintf(buf, PAGE_SIZE, "ITU-T G.992.2 (G.LITE)\n");
+	default: return snprintf(buf, PAGE_SIZE, "unknown (%u)\n", value);
+	}
+}
+
+/*
+ * This could use MAC_ADDRESS_HIGH and MAC_ADDRESS_LOW, but since
+ * this data is already in atm_dev there's no point.
+ *
+ * MAC_ADDRESS_HIGH =3D 0x????5544
+ * MAC_ADDRESS_LOW  =3D 0x33221100
+ * Where 00-55 are bytes 0-5 of the MAC.
+ */
+static ssize_t cxacru_sysfs_show_mac_address(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct usb_interface *intf =3D to_usb_interface(dev);
+	struct usbatm_data *usbatm_instance =3D usb_get_intfdata(intf);
+	struct atm_dev *atm_dev =3D usbatm_instance->atm_dev;
+
+	return snprintf(buf, PAGE_SIZE, "%02x:%02x:%02x:%02x:%02x:%02x\n",
+			atm_dev->esi[0], atm_dev->esi[1], atm_dev->esi[2],
+			atm_dev->esi[3], atm_dev->esi[4], atm_dev->esi[5]);
+}
+
+/*
+ * All device attributes are included in CXACRU_ALL_FILES
+ * so that the same list can be used multiple times:
+ *     INIT   (define the device attributes)
+ *     CREATE (create all the device files)
+ *     REMOVE (remove all the device files)
+ *
+ * With the last two being defined as needed in the functions
+ * they are used in before calling CXACRU_ALL_FILES()
+ */
+#define CXACRU_ALL_FILES(_action) \
+CXACRU_ATTR_##_action(CXINF_DOWNSTREAM_RATE,           u32,  downstream_=
rate); \
+CXACRU_ATTR_##_action(CXINF_UPSTREAM_RATE,             u32,  upstream_ra=
te); \
+CXACRU_ATTR_##_action(CXINF_LINK_STATUS,               LINK, link_status=
); \
+CXACRU_ATTR_##_action(CXINF_LINE_STATUS,               LINE, line_status=
); \
+CXACRU__ATTR_##_action(                                      mac_address=
); \
+CXACRU_ATTR_##_action(CXINF_UPSTREAM_SNR_MARGIN,       dB,   upstream_sn=
r_margin); \
+CXACRU_ATTR_##_action(CXINF_DOWNSTREAM_SNR_MARGIN,     dB,   downstream_=
snr_margin); \
+CXACRU_ATTR_##_action(CXINF_UPSTREAM_ATTENUATION,      dB,   upstream_at=
tenuation); \
+CXACRU_ATTR_##_action(CXINF_DOWNSTREAM_ATTENUATION,    dB,   downstream_=
attenuation); \
+CXACRU_ATTR_##_action(CXINF_TRANSMITTER_POWER,         s8,   transmitter=
_power); \
+CXACRU_ATTR_##_action(CXINF_UPSTREAM_BITS_PER_FRAME,   u32,  upstream_bi=
ts_per_frame); \
+CXACRU_ATTR_##_action(CXINF_DOWNSTREAM_BITS_PER_FRAME, u32,  downstream_=
bits_per_frame); \
+CXACRU_ATTR_##_action(CXINF_STARTUP_ATTEMPTS,          u32,  startup_att=
empts); \
+CXACRU_ATTR_##_action(CXINF_UPSTREAM_CRC_ERRORS,       u32,  upstream_cr=
c_errors); \
+CXACRU_ATTR_##_action(CXINF_DOWNSTREAM_CRC_ERRORS,     u32,  downstream_=
crc_errors); \
+CXACRU_ATTR_##_action(CXINF_UPSTREAM_FEC_ERRORS,       u32,  upstream_fe=
c_errors); \
+CXACRU_ATTR_##_action(CXINF_DOWNSTREAM_FEC_ERRORS,     u32,  downstream_=
fec_errors); \
+CXACRU_ATTR_##_action(CXINF_UPSTREAM_HEC_ERRORS,       u32,  upstream_he=
c_errors); \
+CXACRU_ATTR_##_action(CXINF_DOWNSTREAM_HEC_ERRORS,     u32,  downstream_=
hec_errors); \
+CXACRU_ATTR_##_action(CXINF_LINE_STARTABLE,            bool, line_starta=
ble); \
+CXACRU_ATTR_##_action(CXINF_MODULATION,                MODU, modulation)=
; \
+CXACRU_ATTR_##_action(CXINF_ADSL_HEADEND,              u32,  adsl_headen=
d); \
+CXACRU_ATTR_##_action(CXINF_ADSL_HEADEND_ENVIRONMENT,  u32,  adsl_headen=
d_environment); \
+CXACRU_ATTR_##_action(CXINF_CONTROLLER_VERSION,        u32,  adsl_contro=
ller_version);
+
+CXACRU_ALL_FILES(INIT);
+
 /* the following three functions are stolen from drivers/usb/core/messag=
e.c */
 static void cxacru_blocking_completion(struct urb *urb)
 {
@@ -395,6 +541,8 @@ static void cxacru_poll_status(struct wo
 		goto reschedule;
 	}
=20
+	memcpy(instance->card_info, buf, sizeof(instance->card_info));
+
 	if (instance->line_status =3D=3D buf[CXINF_LINE_STATUS])
 		goto reschedule;
=20
@@ -449,7 +597,8 @@ static void cxacru_poll_status(struct wo
 		break;
 	}
 reschedule:
-	schedule_delayed_work(&instance->poll_work, msecs_to_jiffies(POLL_INTER=
VAL));
+	schedule_delayed_work(&instance->poll_work,
+			round_jiffies_relative(msecs_to_jiffies(POLL_INTERVAL*1000)));
 }
=20
 static int cxacru_fw(struct usb_device *usb_dev, enum cxacru_fw_request =
fw,
@@ -684,6 +833,7 @@ static int cxacru_bind(struct usbatm_dat
=20
 	instance->usbatm =3D usbatm_instance;
 	instance->modem_type =3D (struct cxacru_modem_type *) id->driver_info;
+	memset(instance->card_info, 0, sizeof(instance->card_info));
=20
 	instance->rcv_buf =3D (u8 *) __get_free_page(GFP_KERNEL);
 	if (!instance->rcv_buf) {
@@ -710,6 +860,13 @@ static int cxacru_bind(struct usbatm_dat
 		goto fail;
 	}
=20
+	#define CXACRU_DEVICE_CREATE_FILE(_name) \
+		ret =3D device_create_file(&intf->dev, &dev_attr_##_name); \
+		if (unlikely(ret)) \
+			goto fail_sysfs;
+	CXACRU_ALL_FILES(CREATE);
+	#undef CXACRU_DEVICE_CREATE_FILE
+
 	usb_fill_int_urb(instance->rcv_urb,
 			usb_dev, usb_rcvintpipe(usb_dev, CXACRU_EP_CMD),
 			instance->rcv_buf, PAGE_SIZE,
@@ -730,6 +887,14 @@ static int cxacru_bind(struct usbatm_dat
=20
 	return 0;
=20
+ fail_sysfs:
+	dbg("cxacru_bind: device_create_file failed (%d)\n", ret);
+
+	#define CXACRU_DEVICE_REMOVE_FILE(_name) \
+		device_remove_file(&intf->dev, &dev_attr_##_name);
+	CXACRU_ALL_FILES(REMOVE);
+	#undef CXACRU_DEVICE_REVOVE_FILE
+
  fail:
 	free_page((unsigned long) instance->snd_buf);
 	free_page((unsigned long) instance->rcv_buf);
@@ -762,6 +927,12 @@ static void cxacru_unbind(struct usbatm_
=20
 	free_page((unsigned long) instance->snd_buf);
 	free_page((unsigned long) instance->rcv_buf);
+
+	#define CXACRU_DEVICE_REMOVE_FILE(_name) \
+		device_remove_file(&intf->dev, &dev_attr_##_name);
+	CXACRU_ALL_FILES(REMOVE);
+	#undef CXACRU_DEVICE_REVOVE_FILE
+
 	kfree(instance);
=20
 	usbatm_instance->driver_data =3D NULL;
--=20
1.4.3.1


--=20
Simon Arlott


--------------enig1D15DAAAB03C38C51AA839A4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iQIVAwUBRd9qt6Rtx1WjQ8ihAQoMYQ//aLyHV3QhFWx2Dy9B6waAjtmBbN3iXitX
rXaxgWKZ2UCU3vxNfjw0fPFI8uw4XuICW6x6vZ+TUPtiIc6RQIKyYGCIz0p2Yq3Z
8nA9dvdeewEwweeZjcpB7TR6v26hFETqWBEfv9MUDwapfyi9CXSAqFTaP3nzib73
5zOjZ2jb0h5XEhTDGBbkTfvC+vYhpOkhB1M3lB35RVCgghgLRxs1AN4E4ctml96E
/lZZmKXNPdr3fFQ5zVChxRvvU79QuDJWqjnwKYnuB15uhTgOKoK14bgzj1XGZgn/
o5OfwD4aIiEcyveJszTcfNzgO4JzSUzM5ii4IRLdASfVI/IAEPsvK15Y6V546lS+
cGVS1VZS32fE5MvzgPdXxUaI7WOIKuxOnBvF15s1Zuhppf1co/Sm9x3tVeJ9IwuB
QbrKjn6Tj5m3r4GjcQNvMRJfgxd1lI+jUTm7mNPfMMg0ZGs1ILm5/k3RmMYCMJDv
y8sUWnphSq4Y2PLz16PPOhCKfu/OUw7r7keA0MvMNfOFNLD77oBuKgKxs2ZiQ2rM
FevFiKxazf82yxKGdR16IvpQsQew7my3Xxk2DCYIjEfeflm7z3JJFujJMCNZ+Tdt
Pa+MWLxxW4OWY1EZXlTDTtWEFlDooTBd8D/wbR9u6x/LWbXOl8kwFOldRzawRunS
sDCHHHlm0ws=
=y6Dp
-----END PGP SIGNATURE-----

--------------enig1D15DAAAB03C38C51AA839A4--
