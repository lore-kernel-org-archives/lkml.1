Return-Path: <linux-kernel-owner+w=401wt.eu-S932849AbXBXLW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbXBXLW2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 06:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933499AbXBXLW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 06:22:28 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:58053 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932849AbXBXLW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 06:22:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=thunder.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:X-Enigmail-Version:OpenPGP:Content-Type:Sender:Reply-To;
	b=ffaYnlfIEt5TJdWlAate7aPklvBwNzI57joORlB8XR1BDGySJMmadceoAfSFm6Vym7ltp/X4rMOU8GRXifpAauhE4fBLI0Ufy0bcFFSacdlJhxuE3rhw7HouiMc+PjXK;
Message-ID: <45E01FEF.5040705@simon.arlott.org.uk>
Date: Sat, 24 Feb 2007 11:22:23 +0000
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Duncan Sands <duncan.sands@math.u-psud.fr>
Subject: [PATCH] usbatm: Create sysfs link "device" from atm class device
 to usb interface.
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigDB4A462EF5537B71D57FE173"
Reply-To: Simon Arlott <9dfdc7cb9aecd747d41hkuyv0007hc1q@thunder.lp0.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDB4A462EF5537B71D57FE173
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

There is currently no path from the ATM device in /sys to the USB device'=
s interface that the driver is using; this patch creates a "device" symli=
nk. It is then possible to get to the cxacru ADSL statistics (http://lkml=
=2Eorg/lkml/2007/2/23/328):

/sys/class/atm/cxacru0/device $ ls *_rate *_margin *_attenuation
downstream_attenuation  downstream_snr_margin  upstream_rate
downstream_rate         upstream_attenuation   upstream_snr_margin

If this link is not appropriate I'd have to create device files in /sys/c=
lass/atm/cxacru0 instead - which seems less appropriate since the ADSL st=
atistics are for the USB device not ATM (which is running over the ADSL).=


Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 drivers/usb/atm/usbatm.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
index d91ed11..d0f1976 100644
--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -969,6 +969,12 @@ static int usbatm_atm_init(struct usbatm
 	/* temp init ATM device, set to 128kbit */
 	atm_dev->link_rate =3D 128 * 1000 / 424;
=20
+	ret =3D sysfs_create_link(&atm_dev->class_dev.kobj, &instance->usb_intf=
->dev.kobj, "device");
+	if (ret) {
+		atm_err(instance, "%s: sysfs_create_link failed: %d\n", __func__, ret)=
;
+		goto fail_sysfs;
+	}
+
 	if (instance->driver->atm_start && ((ret =3D instance->driver->atm_star=
t(instance, atm_dev)) < 0)) {
 		atm_err(instance, "%s: atm_start failed: %d!\n", __func__, ret);
 		goto fail;
@@ -987,6 +993,8 @@ static int usbatm_atm_init(struct usbatm
 	return 0;
=20
  fail:
+	sysfs_remove_link(&atm_dev->class_dev.kobj, "device");
+ fail_sysfs:
 	instance->atm_dev =3D NULL;
 	atm_dev_deregister(atm_dev); /* usbatm_atm_dev_close will eventually be=
 called */
 	return ret;
@@ -1319,8 +1327,10 @@ void usbatm_usb_disconnect(struct usb_in
 	kfree(instance->cell_buf);
=20
 	/* ATM finalize */
-	if (instance->atm_dev)
+	if (instance->atm_dev) {
+		sysfs_remove_link(&instance->atm_dev->class_dev.kobj, "device");
 		atm_dev_deregister(instance->atm_dev);
+	}
=20
 	usbatm_put_instance(instance);	/* taken in usbatm_usb_probe */
 }
--=20
1.4.3.1


--=20
Simon Arlott


--------------enigDB4A462EF5537B71D57FE173
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iQIVAwUBReAf76Rtx1WjQ8ihAQpVQA/8CFguH1M2mwpqRWhmx4cH3F5HF7YLvrNN
EWuRjcNz02l8gGTSffz8R94pe0NtDFKnOcD1bh0jBo2h11uIuQ64xHJr4LPMKYbB
zOVNJQa++ZulQ1q89Hu6WlyWiFgg1lGe1zIUvsBz2YR+cDfkiMgs0y6CH7XY7Os0
/99Gn+B/0BIn3xUkwZW7d57zFcFLw/tApdpLnlhsVxqbR85AVA3IpE4xp3H8Olt0
kmOdyzQc9ta8ZJUaLAz5C24A+GEP3eI5ZJnJbQKVdlJSCBaN1htKcgZBISAt9rvg
55Lkcr5QBILWOvTodOIZ48D8PHdXFkoWV43KPMIER5DaR9fERyIT5SXVM8sDpMuO
fcCxqU9yqJ+I0cCHK1nP6MJzY9wePhYw5WKr4gruKnpeNFrfj+0dhJUkyWSsfLBk
4zvVFWTM4ufZe94BumazCXVssthgGhhYgRo2qtJawQD7QesN0JzHH6pmtT24dqmS
3vkeUJp0oHefHk7kEslRNcwXEYHMhRu6W39Stm8HceGcIEJdSziQYuf+sD6nuOvV
egyvFTRjFR1i0Gf9p7O/2vkvH+sMnpoIjlsjwSm92b0GYXZyiYNH6z3pcmh/9ZhR
1vutKfecLsD9luAbnWONhC7C/RCd5vL7ooCGyf8pY+2Tve0yDyL7WKqpotxu8fVe
NHl5g1yLXvY=
=XTLE
-----END PGP SIGNATURE-----

--------------enigDB4A462EF5537B71D57FE173--
