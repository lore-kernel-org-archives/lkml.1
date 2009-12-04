Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbZLDM6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbZLDM6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 07:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932093AbZLDM6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 07:58:47 -0500
Received: from smtp-out13.alice.it ([85.33.2.18]:3812 "EHLO
	smtp-out13.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbZLDM6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 07:58:46 -0500
Date: Fri, 4 Dec 2009 13:57:57 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Richard Purdie <rpurdie@rpsys.net>,
       Daniel Ribeiro <drwyrm@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, openezx-devel@lists.openezx.org
Subject: Re: [PATCH] leds: Add LED class driver for regulator driven LEDs.
Message-Id: <20091204135757.d7533e20.ospite@studenti.unina.it>
In-Reply-To: <20091202204121.GB18311@rakim.wolfsonmicro.main>
References: <1259775625-25973-1-git-send-email-ospite@studenti.unina.it>
	<1259778235.3588.141.camel@odin>
	<20091202213131.1393a956.ospite@studenti.unina.it>
	<20091202204121.GB18311@rakim.wolfsonmicro.main>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.4; i686-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__4_Dec_2009_13_57_57_+0100_OlMHRmQ_/qdaLBG2"
X-OriginalArrivalTime: 04 Dec 2009 12:58:05.0198 (UTC) FILETIME=[6B68E2E0:01CA74E1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Dec_2009_13_57_57_+0100_OlMHRmQ_/qdaLBG2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 2 Dec 2009 20:41:22 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Wed, Dec 02, 2009 at 09:31:31PM +0100, Antonio Ospite wrote:
> > Liam Girdwood <lrg@slimlogic.co.uk> wrote:
>=20
> > > Some regulators may not support voltage change (via hw design or
> > > constraints) so set_voltage() will fail. We probably want to handle t=
his
> > > regulator type so we don't call set_voltage().
>=20
> > Ok, I'll read more about the regulator framework to find out how to
> > check regulator capabilities.
>=20
> Checking for errors when counting and listing the voltages ought to
> cover this.

This is the incremental change I have in mind; if it's ok, then
a v2 is on its way.

diff --git a/drivers/leds/leds-regulator.c b/drivers/leds/leds-regulator.c
index f4c508b..8146d12 100644
--- a/drivers/leds/leds-regulator.c
+++ b/drivers/leds/leds-regulator.c
@@ -34,14 +34,23 @@ struct regulator_led {

 static inline int led_regulator_get_max_brightness(struct regulator *suppl=
y)
 {
-       return regulator_count_voltages(supply);
+       int ret =3D regulator_count_voltages(supply);
+
+       /* even if regulator can't change voltages,
+        * we still assume it can change status
+        * and the LED can be turned on and off.
+        */
+       if (ret =3D=3D -EINVAL)
+               return 1;
+
+       return ret;
 }

 static int led_regulator_get_vdd(struct regulator *supply,
                enum led_brightness brightness)
 {
        if (brightness =3D=3D 0)
-               return 0;
+               return -EINVAL;

        return regulator_list_voltage(supply, brightness - 1);
 }
@@ -95,13 +104,15 @@ static void led_work(struct work_struct *work)
        }

        voltage =3D led_regulator_get_vdd(led->vcc, led->value);
-       dev_dbg(led->cdev.dev, "brightness: %d voltage: %d",
-                       led->value, voltage);
-
-       ret =3D regulator_set_voltage(led->vcc, voltage, voltage);
-       if (ret !=3D 0)
-               dev_err(led->cdev.dev, "Failed to set voltage %d: %d\n",
-                       voltage, ret);
+       if (voltage) {
+               dev_dbg(led->cdev.dev, "brightness: %d voltage: %d",
+                               led->value, voltage);
+
+               ret =3D regulator_set_voltage(led->vcc, voltage, voltage);
+               if (ret !=3D 0)
+                       dev_err(led->cdev.dev, "Failed to set voltage %d: %=
d\n",
+                               voltage, ret);
+       }

        regulator_led_enable(led);


In the last hunk I could have checked (max_brightness > 1) in place
of (voltage) given the first hunk, any opinion?

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Fri__4_Dec_2009_13_57_57_+0100_OlMHRmQ_/qdaLBG2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksZB1UACgkQ5xr2akVTsAGC4QCgpUmeTBpelYRR8kGJoLtvBiml
23AAoJn6qqnqgnSXPzIGa2DaBa0VuN5F
=lmPP
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Dec_2009_13_57_57_+0100_OlMHRmQ_/qdaLBG2--
