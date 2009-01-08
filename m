Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbZAHJtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbZAHJtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 04:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZAHJs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 04:48:57 -0500
Received: from mx01.admin-box.com ([78.47.249.108]:37215 "EHLO
	mx01.admin-box.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZAHJsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 04:48:55 -0500
X-Greylist: delayed 1422 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2009 04:48:55 EST
Subject: Re: LED (leds_hp_disk) causes BUG: scheduling while atomic
From: Daniel Troeder <daniel@admin-box.com>
To: Pavel Machek <pavel@suse.cz>
Cc: deller@gmx.de, kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20090106101415.GA13972@elf.ucw.cz>
References: <1231156352.9735.6.camel@maya.local>
	 <20090106101415.GA13972@elf.ucw.cz>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GWsZvMgL78u8OYQlUdrh"
Date: Thu, 08 Jan 2009 09:04:15 +0100
Message-Id: <1231401855.8422.15.camel@maya.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GWsZvMgL78u8OYQlUdrh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Am Dienstag, den 06.01.2009, 11:14 +0100 schrieb Pavel Machek:
> > I have a HP Compaq nc2400 notebook, and having recently installed 2.6.2=
8
> > (gentoo patchset, self configured), I have observed the following:
> >=20
> > When {I manually, udev automatically} load the leds_hp_disk module, my
> > disk-led flashes regularly _without_ disk activity. When I look at my
> > dmesg I see the following:
>=20
> Yes, that's a (mis-feature).
>=20
> > [  724.376881] BUG: scheduling while atomic: swapper/0/0x10000100
> > [  724.376886] Modules linked in: leds_hp_disk i915 drm snd_pcm_oss
>=20
> And that's a bug. I know what causes it, but i don't have right fix
> yet.
>=20
> If you are interested, take latest -mm (mmotm from userweb) and apply
> this manually:
>=20
> --- linux-mm/drivers/hwmon/hp_accel.c   2009-01-06 10:54:40.000000000
> +0100
> +++ linux/drivers/hwmon/hp_accel.c      2008-12-10 09:36:21.000000000
> +0100
> @@ -174,11 +174,35 @@
>  }
> =20
>  static struct led_classdev hpled_led =3D {
> -       .name                   =3D "hp:red:hddprotection",
> -       .default_trigger        =3D "heartbeat",
> +       .name                   =3D "hp:red:hddprotect",
> +       .default_trigger        =3D "none",
>         .brightness_set         =3D hpled_set,
>  };
>=20
>=20
> ...led will stop blinking, and messages will be gone. (But note that
> if you turn on heartbeat or similar trigger, you'll still get the
> "scheduling in interrupt" nastyness...)
> 							Pavel
Hello :)

Sorry it took me so long to reply - I built a kernel based on
vanilla-2.6.28 and applied patches with quilt to .DATE=3D2009-01-05-12-50.
That worked well, except that when booted, the xfs driver corrupts each
time my MUAs (evolution) configuration :(

But not your problem... the LED-scheduling-problem went away (no more
blinking, on more kernel-BUG and I get:

[   31.822317] lis3lv02d: laptop model unknown, using default axes
configuration
[   31.822367] Registered led device: hp:red:hddprotect
[   32.059496] input: ST LIS3LV02DL Accelerometer
as /devices/platform/lis3lv02d/input/input8
[   32.081954] lis3lv02d driver loaded.

$ lsmod | egrep 'lis3lv02d|hp_accel'
hp_accel                6656  0=20
led_class               3908  2 iwl3945,hp_accel
lis3lv02d               5956  1 hp_accel

/sys/devices/platform/lis3lv02d
/sys/bus/platform/devices/lis3lv02d
/sys/bus/acpi/drivers/lis3lv02d
/sys/module/lis3lv02d
/sys/module/hp_accel

I was shortly confused, because CONFIG_LEDS_HP_DISK went away and got
integrated into CONFIG_SENSORS_LIS3LV02D with
lis3lv02d-merge-with-leds-hp-disk.patch :)

Bye,
Daniel

--=-GWsZvMgL78u8OYQlUdrh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAklls38ACgkQg3+4tbudSIdFkwCgnKotEZEy19a5+wgjcslcFRZZ
uvsAniobfB6neZ51PXvhnv9nMV10/Fmr
=tZPr
-----END PGP SIGNATURE-----

--=-GWsZvMgL78u8OYQlUdrh--

