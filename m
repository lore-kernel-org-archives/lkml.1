Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204AbXBWWmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbXBWWmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 17:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbXBWWmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 17:42:21 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:54877 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbXBWWmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 17:42:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=thunder.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Sender:Reply-To;
	b=bIh2nCwQsJu/Um9cw/nMf/SmoMmpz56BQR7+m90ep1L3f1DFRyFPgQNMykiseai6ajycCPgaGwhPJ0+YSR1D3uYf9vmJ94Vf4bVWvZ94ydJsBomxBqRym2QRPO3TgaOe;
Message-ID: <45DF6DAC.4070203@simon.arlott.org.uk>
Date: Fri, 23 Feb 2007 22:41:48 +0000
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cxacru: Export detailed device info through sysfs.
References: <45DF6AB3.4010705@simon.arlott.org.uk>
In-Reply-To: <45DF6AB3.4010705@simon.arlott.org.uk>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigF60448E820F8FAF6AEADA680"
Reply-To: Simon Arlott <53da383c213f97d3a61hkj7b0006ku47@thunder.lp0.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF60448E820F8FAF6AEADA680
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 23/02/07 22:29, Simon Arlott wrote:
> When the device is polled for status there is a lot of useful status
> information available that is ignored. This patch stores the device
> info array when the status is polled and adds sysfs files to the usb
> device to allow userspace to query it. Since the device updates its
> status internally once a second the poll time is changed to this, and
> round_jiffies_relative is used to avoid waking the cpu unnecessarily.

I also have a patch that can call the ADSL start/stop function on the
device via sysfs, but it's inherently unstable because requests to start
when running or stop when stopped will blocking until the state is change=
d.

redrum 3-2:1.0 # echo no >adsl_running
Feb 23 22:35:28 redrum [ 8574.166565] ATM dev 0: ADSL line: down

redrum 3-2:1.0 # echo yes >adsl_running
Feb 23 22:35:34 redrum [ 8580.169400] ATM dev 0: ADSL line: initializing
---

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index c8b69bf..33d6a7e 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -171,6 +171,9 @@ struct cxacru_data {
 	struct completion snd_done;
 };
=20
+static int cxacru_cm(struct cxacru_data *instance, enum cxacru_cm_reques=
t cm,
+			u8 *wdata, int wsize, u8 *rdata, int rsize);
+
 /* Card info exported through sysfs */
 #define CXACRU__ATTR_INIT(_name) \
 static DEVICE_ATTR(_name, S_IRUGO, cxacru_sysfs_show_##_name, NULL)
@@ -186,10 +189,16 @@ static ssize_t cxacru_sysfs_show_##_name
 } \
 CXACRU__ATTR_INIT(_name)
=20
+#define CXACRU_CMD_INIT(_name) \
+static DEVICE_ATTR(_name, S_IWUSR | S_IRUGO, \
+	cxacru_sysfs_show_##_name, cxacru_sysfs_store_##_name)
+
 #define CXACRU_ATTR_CREATE(_v, _t, _name) CXACRU_DEVICE_CREATE_FILE(_nam=
e)
+#define CXACRU_CMD_CREATE(_name)          CXACRU_DEVICE_CREATE_FILE(_nam=
e)
 #define CXACRU__ATTR_CREATE(_name)        CXACRU_DEVICE_CREATE_FILE(_nam=
e)
=20
 #define CXACRU_ATTR_REMOVE(_v, _t, _name) CXACRU_DEVICE_REMOVE_FILE(_nam=
e)
+#define CXACRU_CMD_REMOVE(_name)          CXACRU_DEVICE_REMOVE_FILE(_nam=
e)
 #define CXACRU__ATTR_REMOVE(_name)        CXACRU_DEVICE_REMOVE_FILE(_nam=
e)
=20
 static ssize_t cxacru_sysfs_showattr_u32(u32 value, char *buf)
@@ -213,6 +222,7 @@ static ssize_t cxacru_sysfs_showattr_dB(
 	}
 }
=20
+/*
 static ssize_t cxacru_sysfs_showattr_bool(u32 value, char *buf)
 {
 	switch (value) {
@@ -221,6 +231,7 @@ static ssize_t cxacru_sysfs_showattr_boo
 	default: return 0;
 	}
 }
+*/
=20
 static ssize_t cxacru_sysfs_showattr_LINK(u32 value, char *buf)
 {
@@ -278,6 +289,66 @@ static ssize_t cxacru_sysfs_show_mac_add
 			atm_dev->esi[3], atm_dev->esi[4], atm_dev->esi[5]);
 }
=20
+
+static ssize_t cxacru_sysfs_show_adsl_running(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct usb_interface *intf =3D to_usb_interface(dev);
+	struct usbatm_data *usbatm_instance =3D usb_get_intfdata(intf);
+	struct cxacru_data *instance =3D usbatm_instance->driver_data;
+
+	switch (instance->card_info[CXINF_LINE_STARTABLE]) {
+	case 0: return snprintf(buf, PAGE_SIZE, "yes\n");
+	case 1: return snprintf(buf, PAGE_SIZE, "no\n");
+	default: return 0;
+	}
+}
+
+static ssize_t cxacru_sysfs_store_adsl_running(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	int ret;
+	struct usb_interface *intf =3D to_usb_interface(dev);
+	struct usbatm_data *usbatm_instance =3D usb_get_intfdata(intf);
+	struct cxacru_data *instance =3D usbatm_instance->driver_data;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EACCES;
+
+	switch (instance->card_info[CXINF_LINE_STARTABLE]) {
+	case 0: /* ADSL running */
+		if (count !=3D 3
+				|| strncmp(buf, "no", strlen("no"))
+				|| strncmp(buf, "no\n", strlen("no\n")))
+			return 0;
+		=09
+		ret =3D cxacru_cm(instance, CM_REQUEST_CHIP_ADSL_LINE_STOP, NULL, 0, N=
ULL, 0);
+		if (ret < 0) {
+			atm_err(usbatm_instance, "cxacru_sysfs_store_atm_running:"
+					" CHIP_ADSL_LINE_STOP returned %d\n", ret);
+			return ret;
+		}
+		// TODO: poll twice more then stop
+		return strlen(buf);
+	case 1: /* ADSL not running */
+		if (count !=3D 4
+				|| strncmp(buf, "yes", strlen("yes"))
+				|| strncmp(buf, "yes\n", strlen("yes\n")))
+			return 0;
+
+		ret =3D cxacru_cm(instance, CM_REQUEST_CHIP_ADSL_LINE_START, NULL, 0, =
NULL, 0);
+		if (ret < 0) {
+			atm_err(usbatm_instance, "cxacru_sysfs_store_atm_running:"
+					" CHIP_ADSL_LINE_START returned %d\n", ret);
+			return ret;
+		}
+		// TODO: resume polling
+		return strlen(buf);
+	default:
+		return -EINVAL;
+	}
+}
+
 /*
  * All device attributes are included in CXACRU_ALL_FILES
  * so that the same list can be used multiple times:
@@ -308,11 +379,11 @@ CXACRU_ATTR_##_action(CXINF_UPSTREAM_FEC
 CXACRU_ATTR_##_action(CXINF_DOWNSTREAM_FEC_ERRORS,     u32,  downstream_=
fec_errors); \
 CXACRU_ATTR_##_action(CXINF_UPSTREAM_HEC_ERRORS,       u32,  upstream_he=
c_errors); \
 CXACRU_ATTR_##_action(CXINF_DOWNSTREAM_HEC_ERRORS,     u32,  downstream_=
hec_errors); \
-CXACRU_ATTR_##_action(CXINF_LINE_STARTABLE,            bool, line_starta=
ble); \
 CXACRU_ATTR_##_action(CXINF_MODULATION,                MODU, modulation)=
; \
 CXACRU_ATTR_##_action(CXINF_ADSL_HEADEND,              u32,  adsl_headen=
d); \
 CXACRU_ATTR_##_action(CXINF_ADSL_HEADEND_ENVIRONMENT,  u32,  adsl_headen=
d_environment); \
-CXACRU_ATTR_##_action(CXINF_CONTROLLER_VERSION,        u32,  adsl_contro=
ller_version);
+CXACRU_ATTR_##_action(CXINF_CONTROLLER_VERSION,        u32,  adsl_contro=
ller_version); \
+CXACRU_CMD_##_action(                                        adsl_runnin=
g);
=20
 CXACRU_ALL_FILES(INIT);
=20

--=20
Simon Arlott


--------------enigF60448E820F8FAF6AEADA680
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iQIVAwUBRd9traRtx1WjQ8ihAQpAgBAAnD9IlvhM4c8LRaoT8x2NjzRWsVYnT150
1S7gcsG2/23BxYVmYTTxtQ8JK26a0pFqVqkq7SBwHXs9wyg12owvESxNLOzojIvW
egakmPuErWBJmuVOt4ZNRElNft2qDNygIgToaCNSGBi+H0v+44OJ8fGO1oPiOqYo
lr+EBx2TWeuMb6tnf5YxH06dpeYhwcLwXAc9sSz8yNcqpc/6R/XHKHVAI751wMRC
BJVugOvIVnOe8fPTEDeM0Eog2tEoT301X5m05Ym6PdNGc1FdUsTXBOl7mp/dCXc2
NJaNl5OQrX8qO1+Wo7eVcC61t/I+QWbhIpTFd9GnupmksFgFDpPbcfdj1c9L8LW9
K9rWfqSxvDztUdWSdaokWO1328+GRmlUn22/ztfCa8KEcEslbRcvd47+3Plzdl+j
tWjM5djImHEXZ4ht02VC/GLwP22VzM7MFNrSXJTCtJ3q3kzQvAdWey+EyTF2rz2N
ySe5pnp+ap2/fYjeBE0vknsAEuVm2ZxBV+S/5Rmpp5o89mLDWppysFX3SqGaSNSd
fm/FKzzXi72yTTGcMc9ZRUSbVBqM97oeVD/u7AnDlgwlXs61wksLJK8+IoQC6B9P
WfL3E8zqtxxA2czkcu6xm0Cj4/jZFrNThvD7Z6mT9qkU9jNYelN78sS8JxWwNyHf
xL51vkBzbhE=
=sPF2
-----END PGP SIGNATURE-----

--------------enigF60448E820F8FAF6AEADA680--
