Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbZIRNPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbZIRNPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 09:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbZIRNPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 09:15:30 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39361 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756123AbZIRNP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 09:15:28 -0400
X-Sasl-enc: aMaNFGcam416EcVglX9/rKYKwgicXG7To4vpcTWbR68L 1253279729
Message-ID: <4AB387E3.6030709@imap.cc>
Date: Fri, 18 Sep 2009 15:15:15 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/48] 2.6.27.32-stable review
References: <200909112223.n8BMMSHG002530@hera.kernel.org> <20090916210956.GB24567@kroah.com>
In-Reply-To: <20090916210956.GB24567@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAB653D9D33BF3F50FAD7AE60"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAB653D9D33BF3F50FAD7AE60
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 16.09.2009 23:09 schrieb Greg KH:
> Can you send me what you need applied to the latest 2.6.27-stable tree
> to fix this up so we can finally resolve this?

The patch that should have been applied is here:

http://patchwork.kernel.org/patch/13845/

I'm including it below for completeness.

The patch that was applied to 2.6.27-stable instead is this:

http://patchwork.kernel.org/patch/20855/
(commit 221418f9a25cd96aff99d6aba41c177f6eb00853)

The difference is in blob 5 which inserts the new code at the wrong place=
=2E
I have no idea who or what caused that change.

So commit 221418f9a25cd96aff99d6aba41c177f6eb00853 should be reverted and=

my original patch below applied instead. The patch by Stefan Bader is
equivalent to that but additionally backports two pr_err() calls from
mainline.

Thanks,
Tilman



-------- Original-Nachricht --------
Betreff: [PATCH 2.6.27/28-stable] bas_gigaset: correctly allocate USB int=
errupt transfer buffer
Datum: Mon, 23 Mar 2009 22:47:06 +0100 (CET)
Von: Tilman Schmidt <tilman@imap.cc>
An: stable@kernel.org
CC: Kolja Waschk <kawk@users.sourceforge.net>, Hansjoerg Lipp <hjlipp@web=
=2Ede>, davem@davemloft.net, linux-kernel@vger.kernel.org,        netdev@=
vger.kernel.org

Greg,

the following patch backports the Gigaset driver bugfix merged for
2.6.29 as commit 170ebf85160dd128e1c4206cc197cce7d1424705 to both
v2.6.27.x and v2.6.28.x. I would appreciate to see it included in
your stable series.

Thanks,
Tilman

bas_gigaset: correctly allocate USB interrupt transfer buffer

commit 170ebf85160dd128e1c4206cc197cce7d1424705 upstream.

Every USB transfer buffer has to be allocated individually by kmalloc.

Impact: bugfix, no functional change

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Tested-by: Kolja Waschk <kawk@users.sourceforge.net>
---
 drivers/isdn/gigaset/bas-gigaset.c |   15 +++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/isdn/gigaset/bas-gigaset.c	2008-12-25 00:26:37.000000000 +0=
100
+++ b/drivers/isdn/gigaset/bas-gigaset.c	2009-03-17 23:38:30.000000000 +0=
100
@@ -46,6 +46,9 @@ MODULE_PARM_DESC(cidmode, "Call-ID mode"
 /* length limit according to Siemens 3070usb-protokoll.doc ch. 2.1 */
 #define IF_WRITEBUF 264
=20
+/* interrupt pipe message size according to ibid. ch. 2.2 */
+#define IP_MSGSIZE 3
+
 /* Values for the Gigaset 307x */
 #define USB_GIGA_VENDOR_ID      0x0681
 #define USB_3070_PRODUCT_ID     0x0001
@@ -110,7 +113,7 @@ struct bas_cardstate {
 	unsigned char		*rcvbuf;	/* AT reply receive buffer */
=20
 	struct urb		*urb_int_in;	/* URB for interrupt pipe */
-	unsigned char		int_in_buf[3];
+	unsigned char		*int_in_buf;
=20
 	spinlock_t		lock;		/* locks all following */
 	int			basstate;	/* bitmap (BS_*) */
@@ -657,7 +660,7 @@ static void read_int_callback(struct urb
 	}
=20
 	/* drop incomplete packets even if the missing bytes wouldn't matter */=

-	if (unlikely(urb->actual_length < 3)) {
+	if (unlikely(urb->actual_length < IP_MSGSIZE)) {
 		dev_warn(cs->dev, "incomplete interrupt packet (%d bytes)\n",
 			 urb->actual_length);
 		goto resubmit;
@@ -2127,6 +2130,7 @@ static void gigaset_reinitbcshw(struct b
 static void gigaset_freecshw(struct cardstate *cs)
 {
 	/* timers, URBs and rcvbuf are disposed of in disconnect */
+	kfree(cs->hw.bas->int_in_buf);
 	kfree(cs->hw.bas);
 	cs->hw.bas =3D NULL;
 }
@@ -2138,6 +2142,11 @@ static int gigaset_initcshw(struct cards
 	cs->hw.bas =3D ucs =3D kmalloc(sizeof *ucs, GFP_KERNEL);
 	if (!ucs)
 		return 0;
+	ucs->int_in_buf =3D kmalloc(IP_MSGSIZE, GFP_KERNEL);
+	if (!ucs->int_in_buf) {
+		kfree(ucs);
+		return 0;
+	}
=20
 	ucs->urb_cmd_in =3D NULL;
 	ucs->urb_cmd_out =3D NULL;
@@ -2290,7 +2299,7 @@ static int gigaset_probe(struct usb_inte
 	usb_fill_int_urb(ucs->urb_int_in, udev,
 			 usb_rcvintpipe(udev,
 					(endpoint->bEndpointAddress) & 0x0f),
-			 ucs->int_in_buf, 3, read_int_callback, cs,
+			 ucs->int_in_buf, IP_MSGSIZE, read_int_callback, cs,
 			 endpoint->bInterval);
 	if ((rc =3D usb_submit_urb(ucs->urb_int_in, GFP_KERNEL)) !=3D 0) {
 		dev_err(cs->dev, "could not submit interrupt URB: %s\n",



--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigAB653D9D33BF3F50FAD7AE60
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFKs4ftQ3+did9BuFsRAtzeAJ9wV8MjEXS3P0HqYYJHWpVKKTyosACeNJbg
IItjtNvS2EcfZ5tJ7TdM9m8=
=88Zj
-----END PGP SIGNATURE-----

--------------enigAB653D9D33BF3F50FAD7AE60--
