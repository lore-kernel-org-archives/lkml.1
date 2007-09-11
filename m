Return-Path: <linux-kernel-owner+w=401wt.eu-S1762906AbXIKJjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762906AbXIKJjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 05:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757540AbXIKJjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 05:39:09 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37313 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762329AbXIKJjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 05:39:06 -0400
Message-ID: <46E66228.3010901@bull.net>
Date: Tue, 11 Sep 2007 11:38:48 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND 2][PATCH 0/4] Virtual Machine Time Accounting
References: <46E550D7.6090805@bull.net> <20070910194143.GA6052@elte.hu>
In-Reply-To: <20070910194143.GA6052@elte.hu>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 11/09/2007 11:44:45,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 11/09/2007 11:44:46,
	Serialize complete at 11/09/2007 11:44:46
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3CFB1F741389F40AEEE51442"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3CFB1F741389F40AEEE51442
Content-Type: multipart/mixed;
 boundary="------------010901030108030501050307"

This is a multi-part message in MIME format.
--------------010901030108030501050307
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> * Laurent Vivier <Laurent.Vivier@bull.net> wrote:
>=20
>> This new version remove conditional compilation on GUEST_ACCOUNTING.
>=20
> excellent! For all 4 patches:
>=20
>  Acked-by: Ingo Molnar <mingo@elte.hu>
>=20
> i'd suggest inclusion into 2.6.24.

Thank you.

> can the /proc change break anything? Any old procps version perhaps?

I've tested top and ps from procps 3.0.5, 3.1.8, 3.1.14, 3.2.1 and 3.2.7 =
without
any problem.

And as values are read with a sscanf() by procps, I think adding a field =
at the
end of the  line is not a problem.

For those who want to play, I've attached a patch to procps-3.2.7 to disp=
lay
guest time in top.

Regards,
Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth

--------------010901030108030501050307
Content-Type: text/plain;
 name="stat_guest"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="stat_guest"

Index: procps-3.2.7/top.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- procps-3.2.7.orig/top.c	2007-08-08 16:13:17.000000000 +0200
+++ procps-3.2.7/top.c	2007-08-10 16:46:01.000000000 +0200
@@ -935,7 +935,8 @@
    cpus[Cpu_tot].x =3D 0;  // FIXME: can't tell by kernel version number=

    cpus[Cpu_tot].y =3D 0;  // FIXME: can't tell by kernel version number=

    cpus[Cpu_tot].z =3D 0;  // FIXME: can't tell by kernel version number=

-   num =3D sscanf(buf, "cpu %Lu %Lu %Lu %Lu %Lu %Lu %Lu %Lu",
+   cpus[Cpu_tot].g =3D 0;  // FIXME: can't tell by kernel version number=

+   num =3D sscanf(buf, "cpu %Lu %Lu %Lu %Lu %Lu %Lu %Lu %Lu %Lu",
       &cpus[Cpu_tot].u,
       &cpus[Cpu_tot].n,
       &cpus[Cpu_tot].s,
@@ -943,7 +944,8 @@
       &cpus[Cpu_tot].w,
       &cpus[Cpu_tot].x,
       &cpus[Cpu_tot].y,
-      &cpus[Cpu_tot].z
+      &cpus[Cpu_tot].z,
+      &cpus[Cpu_tot].g
    );
    if (num < 4)
          std_err("failed /proc/stat read");
@@ -960,9 +962,10 @@
       cpus[i].x =3D 0;  // FIXME: can't tell by kernel version number
       cpus[i].y =3D 0;  // FIXME: can't tell by kernel version number
       cpus[i].z =3D 0;  // FIXME: can't tell by kernel version number
-      num =3D sscanf(buf, "cpu%u %Lu %Lu %Lu %Lu %Lu %Lu %Lu %Lu",
+      cpus[i].g =3D 0;  // FIXME: can't tell by kernel version number
+      num =3D sscanf(buf, "cpu%u %Lu %Lu %Lu %Lu %Lu %Lu %Lu %Lu %Lu",
          &cpus[i].id,
-         &cpus[i].u, &cpus[i].n, &cpus[i].s, &cpus[i].i, &cpus[i].w, &cp=
us[i].x, &cpus[i].y, &cpus[i].z
+         &cpus[i].u, &cpus[i].n, &cpus[i].s, &cpus[i].i, &cpus[i].w, &cp=
us[i].x, &cpus[i].y, &cpus[i].z, &cpus[i].g
       );
       if (num < 4)
             std_err("failed /proc/stat read");
@@ -2879,10 +2882,11 @@
    // we'll trim to zero if we get negative time ticks,
    // which has happened with some SMP kernels (pre-2.4?)
 #define TRIMz(x)  ((tz =3D (SIC_t)(x)) < 0 ? 0 : tz)
-   SIC_t u_frme, s_frme, n_frme, i_frme, w_frme, x_frme, y_frme, z_frme,=
 tot_frme, tz;
+   SIC_t u_frme, s_frme, n_frme, i_frme, w_frme, x_frme, y_frme, z_frme,=
 g_frme, tot_frme, tz, u_tmp;
    float scale;
=20
-   u_frme =3D cpu->u - cpu->u_sav;
+   u_tmp =3D cpu->u - cpu->g;
+   u_frme =3D TRIMz(u_tmp - cpu->u_sav);
    s_frme =3D cpu->s - cpu->s_sav;
    n_frme =3D cpu->n - cpu->n_sav;
    i_frme =3D TRIMz(cpu->i - cpu->i_sav);
@@ -2890,7 +2894,8 @@
    x_frme =3D cpu->x - cpu->x_sav;
    y_frme =3D cpu->y - cpu->y_sav;
    z_frme =3D cpu->z - cpu->z_sav;
-   tot_frme =3D u_frme + s_frme + n_frme + i_frme + w_frme + x_frme + y_=
frme + z_frme;
+   g_frme =3D cpu->g - cpu->g_sav;
+   tot_frme =3D u_frme + s_frme + n_frme + i_frme + w_frme + x_frme + y_=
frme + z_frme + g_frme;
    if (tot_frme < 1) tot_frme =3D 1;
    scale =3D 100.0 / (float)tot_frme;
=20
@@ -2908,13 +2913,14 @@
          (float)w_frme * scale,
          (float)x_frme * scale,
          (float)y_frme * scale,
-         (float)z_frme * scale
+         (float)z_frme * scale,
+         (float)g_frme * scale
       )
    );
    Msg_row +=3D 1;
=20
    // remember for next time around
-   cpu->u_sav =3D cpu->u;
+   cpu->u_sav =3D u_tmp;
    cpu->s_sav =3D cpu->s;
    cpu->n_sav =3D cpu->n;
    cpu->i_sav =3D cpu->i;
@@ -2922,6 +2928,7 @@
    cpu->x_sav =3D cpu->x;
    cpu->y_sav =3D cpu->y;
    cpu->z_sav =3D cpu->z;
+   cpu->g_sav =3D cpu->g;
=20
 #undef TRIMz
 }
Index: procps-3.2.7/top.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- procps-3.2.7.orig/top.h	2007-08-08 16:14:47.000000000 +0200
+++ procps-3.2.7/top.h	2007-08-08 17:01:45.000000000 +0200
@@ -211,8 +211,8 @@
 // calculations.  It exists primarily for SMP support but serves
 // all environments.
 typedef struct CPU_t {
-   TIC_t u, n, s, i, w, x, y, z; // as represented in /proc/stat
-   TIC_t u_sav, s_sav, n_sav, i_sav, w_sav, x_sav, y_sav, z_sav; // in t=
he order of our display
+   TIC_t u, n, s, i, w, x, y, z, g; // as represented in /proc/stat
+   TIC_t u_sav, s_sav, n_sav, i_sav, w_sav, x_sav, y_sav, z_sav, g_sav; =
// in the order of our display
    unsigned id;  // the CPU ID number
 } CPU_t;
=20
@@ -390,7 +390,7 @@
 #define STATES_line2x6  "%s\03" \
    " %#4.1f%% \02us,\03 %#4.1f%% \02sy,\03 %#4.1f%% \02ni,\03 %#4.1f%% \=
02id,\03 %#4.1f%% \02wa,\03 %#4.1f%% \02hi,\03 %#4.1f%% \02si\03\n"
 #define STATES_line2x7  "%s\03" \
-   "%#5.1f%%\02us,\03%#5.1f%%\02sy,\03%#5.1f%%\02ni,\03%#5.1f%%\02id,\03=
%#5.1f%%\02wa,\03%#5.1f%%\02hi,\03%#5.1f%%\02si,\03%#5.1f%%\02st\03\n"
+  "%#4.1f%%\02us,\03%#4.1f%%\02sy,\03%#4.1f%%\02ni,\03%#5.1f%%\02id,\03%=
#4.1f%%\02wa,\03%#4.1f%%\02hi,\03%#4.1f%%\02si,\03%#4.1f%%\02st\03,\02%#4=
=2E1f%%\02g\n"
 #ifdef CASEUP_SUMMK
 #define MEMORY_line1  "Mem: \03" \
    " %8luK \02total,\03 %8luK \02used,\03 %8luK \02free,\03 %8luK \02buf=
fers\03\n"

--------------010901030108030501050307--

--------------enig3CFB1F741389F40AEEE51442
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFG5mIr9Kffa9pFVzwRAs5dAJwPxj+/wdZOzysjiIfiY1R7qyRdQgCgn/g7
soCY8tEKxCmEFlUWq98HCys=
=WSB8
-----END PGP SIGNATURE-----

--------------enig3CFB1F741389F40AEEE51442--
