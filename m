Return-Path: <linux-kernel-owner+w=401wt.eu-S1752005AbXB0Soj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbXB0Soj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 13:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbXB0Soi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 13:44:38 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:48951 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751967AbXB0Soh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 13:44:37 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: "Fabio Comolli" <fabio.comolli@gmail.com>
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 1)
Date: Tue, 27 Feb 2007 20:44:52 +0200
User-Agent: KMail/1.9.6
Cc: "Ismail =?utf-8?q?D=C3=B6nmez?=" <ismail@pardus.org.tr>,
       "Adrian Bunk" <bunk@stusta.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       lenb@kernel.org, linux-acpi@vger.kernel.org, luming.yu@intel.com,
       "Konstantin Karasyov" <konstantin.a.karasyov@intel.com>,
       vladimir.p.lebedev@intel.com, hal@lists.freedesktop.org
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <200702271525.48645.ismail@pardus.org.tr> <b637ec0b0702270614i25b6be9fmfb4b12ddd789a467@mail.gmail.com>
In-Reply-To: <b637ec0b0702270614i25b6be9fmfb4b12ddd789a467@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2456952.OoKZrhALRy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702272044.56544.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2456952.OoKZrhALRy
Content-Type: multipart/mixed;
  boundary="Boundary-01=_lwH5FRFUBkAGmGG"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_lwH5FRFUBkAGmGG
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

27 =C5=9Eub 2007 Sal tarihinde, Fabio Comolli =C5=9Funlar=C4=B1 yazm=C4=B1=
=C5=9Ft=C4=B1:=20
> Confirmed, although the problem I see is probably different from
> Ismael's one: in my case /proc/acpi/adapter/AC is present but
> kpowersave does not work (it works in 2.6.20).
>
> The only file I seem to be missing is /proc/acpi/info, but I don't
> know it is important or not.

Then these problems are not same, =C4=B0smail's problem was an ACPI one and=
 im sure=20
that solved but yours seems a userspace problem (hal checks /proc/acpi/info=
=20
and kpowersave uses hal) introduced by "/proc/acpi/info deprecated=20
by /sys/firmware/acpi/info" [1]. You can try untested attached patch agains=
t=20
hal-git tree, so i'm adding hal list into CC also.

[1] http://www.mail-archive.com/linux-acpi@vger.kernel.org/msg04285.html
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--Boundary-01=_lwH5FRFUBkAGmGG
Content-Type: text/x-diff;
  charset="utf-8";
  name="hal_acpi.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="hal_acpi.patch"

diff --git a/hald/linux/acpi.c b/hald/linux/acpi.c
index 30e5fdf..1714627 100644
=2D-- a/hald/linux/acpi.c
+++ b/hald/linux/acpi.c
@@ -1055,7 +1055,7 @@ acpi_synthesize_hotplug_events (void)
 	HalDevice *computer;
 	gchar path[HAL_PATH_MAX];
=20
=2D	if (!g_file_test ("/proc/acpi/info", G_FILE_TEST_EXISTS))
+	if (!g_file_test ("/proc/acpi/", G_FILE_TEST_IS_DIR))
 		return FALSE;
=20
 	if ((computer =3D hal_device_store_find (hald_get_gdl (), "/org/freedeskt=
op/Hal/devices/computer")) =3D=3D NULL &&
@@ -1066,8 +1066,14 @@ acpi_synthesize_hotplug_events (void)
=20
 	/* Set appropriate properties on the computer object */
 	hal_device_property_set_string (computer, "power_management.type", "acpi"=
);
=2D	hal_util_set_string_elem_from_file (computer, "power_management.acpi.li=
nux.version",
+	if (g_file_test ("/proc/acpi/info", G_FILE_TEST_EXISTS)) {
+		hal_util_set_string_elem_from_file (computer, "power_management.acpi.lin=
ux.version",
 					    "/proc/acpi", "info", "version", 0, FALSE);
+	}
+	else {
+		hal_util_set_string_elem_from_file (computer, "power_management.acpi.lin=
ux.version",
+					    "%s/firmware/acpi", sysfs_path, "info", "version", 0, FALSE);
+	}
=20
 	/* collect batteries */
 	snprintf (path, sizeof (path), "%s/acpi/battery", get_hal_proc_path ());

--Boundary-01=_lwH5FRFUBkAGmGG--

--nextPart2456952.OoKZrhALRy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iD8DBQBF5Hwoy7E6i0LKo6YRAkf7AKCpQXyI4ZIx7O5L4CB55FLKvPRJuACgv+GB
BmOkjkyDcpLVjz8wBtQzDRM=
=Dg7g
-----END PGP SIGNATURE-----

--nextPart2456952.OoKZrhALRy--
