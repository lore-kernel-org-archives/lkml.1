Return-Path: <linux-kernel-owner+w=401wt.eu-S1754295AbZLBUZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbZLBUZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 15:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbZLBUZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:25:32 -0500
Received: from smtp-OUT05A.alice.it ([85.33.3.5]:2254 "EHLO
	smtp-OUT05A.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbZLBUZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:25:31 -0500
Date: Wed, 2 Dec 2009 21:25:21 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Daniel Ribeiro <drwyrm@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, openezx-devel@lists.openezx.org
Subject: Re: [PATCH] leds: Add LED class driver for regulator driven LEDs.
Message-Id: <20091202212521.500f7a46.ospite@studenti.unina.it>
In-Reply-To: <20091202180658.GA12292@rakim.wolfsonmicro.main>
References: <1259775625-25973-1-git-send-email-ospite@studenti.unina.it>
	<20091202180658.GA12292@rakim.wolfsonmicro.main>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i686-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__2_Dec_2009_21_25_21_+0100_vuYJB29jv3lD2Ptq"
X-OriginalArrivalTime: 02 Dec 2009 20:25:36.0013 (UTC) FILETIME=[9AEA9BD0:01CA738D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Dec_2009_21_25_21_+0100_vuYJB29jv3lD2Ptq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 2 Dec 2009 18:06:58 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Wed, Dec 02, 2009 at 06:40:25PM +0100, Antonio Ospite wrote:
>=20
> > A doubt I had was about leaving the 'supply' variable configurable from
> > platform data, or relying on some fixed value like "vled", but leaving =
it
> > configurable covers the case when we have different regulators used for
> > different LEDs or vibrators.
>=20
> There's no need to do this since the regulator API matches consumers
> based on struct device as well as name so you can have as many LEDs as
> you like all using the same supply name mapping to different regulators.
>

I need some more explanation here, I am currently using the driver with
this code:

+/* VVIB: Vibrator on A780, A1200, A910, E6, E2 */
+static struct regulator_consumer_supply pcap_regulator_VVIB_consumers
[] =3D {
+	{ .dev_name =3D "leds-regulator", .supply =3D "vibrator", },
                                                   ^^^^^^^^
+};
+
+static struct regulator_init_data pcap_regulator_VVIB_data =3D {
+	.constraints =3D {
+		.min_uV =3D 1300000,
+		.max_uV =3D 3000000,
+		.valid_ops_mask =3D REGULATOR_CHANGE_STATUS |
+					REGULATOR_CHANGE_VOLTAGE,
+	},
+	.num_consumer_supplies =3D ARRAY_SIZE
(pcap_regulator_VVIB_consumers),
+	.consumer_supplies =3D pcap_regulator_VVIB_consumers,
+};

@@ -749,6 +766,10 @@ static struct pcap_subdev a780_pcap_subdevs[] =3D {
 		.name		=3D "pcap-regulator",
 		.id		=3D VAUX3,
 		.platform_data	=3D &pcap_regulator_VAUX3_data,
+	}, {
+		.name		=3D "pcap-regulator",
+		.id		=3D VVIB,
+		.platform_data	=3D &pcap_regulator_VVIB_data,
 	},
 };


and then:

=20
@@ -872,8 +893,24 @@ static struct platform_device a780_camera =3D {
 	},
 };
=20
+/* vibrator */
+static struct led_regulator_platform_data a780_vibrator_data =3D {
+	.name   =3D "a780::vibrator",
+	.supply =3D "vibrator"
                   ^^^^^^^^ I'll get the regulator with this.
+};
+
+static struct platform_device a780_vibrator =3D {
+	.name =3D "leds-regulator",
+	.id   =3D -1,
+	.dev  =3D {
+		.platform_data =3D &a780_vibrator_data,
+	},
+};
+
+
 static struct platform_device *a780_devices[] __initdata =3D {
 	&a780_gpio_keys,
+	&a780_vibrator
 };

If I set the .supply value fixed, how can I assign different
regulators to different leds? Should I use the address to the platform
device (a780_vibrator in this case) for .dev when defining the
regulator in the first place?

> > Should I add a note in Documentation/ about how to use it? Tell me if s=
o.
>=20
> If you wish to, it's not essential (only one existing LED driver appears
> to do this) and the comment in the header file is probably adequate.
>

Ok.

> > +static inline int led_regulator_get_max_brightness(struct regulator *s=
upply)
> > +{
> > +	return regulator_count_voltages(supply);
> > +}
>=20
> More graceful handling of regulators that don't implement list_voltage
> might be nice (for simple on/off control - not all regulators have
> configurable voltages).  If a regulator doesn't support list_voltage
> you'll get -EINVAL.
>

Ok, I need to study the regulator framework a bit more, but I think I
got the logic you are referring to, if we can actually list voltages
then max_brightness is the number of voltages as it is now, else if we
can only change status then max_brightness is 1 (one).

> > +	vcc =3D regulator_get(&pdev->dev, pdata->supply);
> > +	if (IS_ERR(vcc)) {
> > +		dev_err(&pdev->dev, "Cannot get vcc for %s\n", pdata->name);
> > +		return PTR_ERR(vcc);;
> > +	}
>=20
> You almost certainly want regulator_get_exclusive() here; this driver
> can't function properly if something else is using the regulator and
> holding the LED on or off without it.  You'll also want to check the
> status of the LED on startup and update your internal status to match
> that.

Will do, thanks for reviewing the code.

Regards,
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

--Signature=_Wed__2_Dec_2009_21_25_21_+0100_vuYJB29jv3lD2Ptq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksWzTEACgkQ5xr2akVTsAHGPQCfa2WyzXExo9U6lYiqS0ueipSZ
WpMAoIuz2x4279j3un2EMIqZya9Gm1Gl
=Xe0i
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Dec_2009_21_25_21_+0100_vuYJB29jv3lD2Ptq--
