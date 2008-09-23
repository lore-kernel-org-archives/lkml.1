Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbYIWMgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbYIWMgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 08:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbYIWMgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 08:36:05 -0400
Received: from postman.teamix.net ([194.150.191.120]:56915 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750920AbYIWMgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 08:36:03 -0400
From: Martin Steigerwald <ms@teamix.de>
Organization: team(ix) GmbH
To: util-linux-ng@vger.kernel.org
Subject: [PATCH] Support for CFS SCHED_IDLE priority in chrt
Date: Tue, 23 Sep 2008 14:35:49 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart174601390.pSdAnut40Y";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809231435.54985.ms@teamix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart174601390.pSdAnut40Y
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Please keep CC to linux-kernel or CC to me personally as I am not subscribe=
d=20
to util-linux-ng.

Hi!

Since I do not dare to break kernel code[1], I try the same with userspace=
=20
code. The following patch should add SCHED_IDLE support to chrt. Beware it =
is=20
complety untested, since I get:

ms@mango> autoconf      ~/lokal/Kernel/Dokumentation/util-linux-ng
configure.ac:7: error: possibly undefined macro: AM_INIT_AUTOMAKE
      If this token and others are legitimate, please use m4_pattern_allow.
      See the Autoconf documentation.
configure.ac:37: error: possibly undefined macro: AM_CONDITIONAL
configure.ac:190: error: possibly undefined macro: AM_GNU_GETTEXT_VERSION
configure.ac:191: error: possibly undefined macro: AM_GNU_GETTEXT
ms@mango> ./configure      ~/lokal/Kernel/Dokumentation/util-linux-ng
configure: error: cannot find install-sh or install.sh in config "."/config

when trying to compile util-linux-ng from GIT. (Note: I have no glue about=
=20
autoconf, I only ever started an pre-existing ./configure script). I tried=
=20
with autoconf 2.61-8 from Debian Lenny.

I will test this commit if someone gives me a hint on how to compile=20
util-linux-ng.

[1] http://marc.info/?l=3Dlinux-kernel&m=3D122217132330769&w=3D2

=2D--
=46rom 8c6c5154bc5b53c0ccad8faa0ee3fe07bae447a5 Mon Sep 17 00:00:00 2001
=46rom: Martin Steigerwald <ms@teamix.de>
Date: Tue, 23 Sep 2008 14:23:03 +0200
Subject: [PATCH] Support CFS SCHED_IDLE priority and document it

Support CFS_SCHED_IDLE priority and document it.

Beware, this is completely untested, since I autoconf 2.61-8 from Debian
Lenny produced errors.

Signed-off-by: Martin Steigerwald <ms@teamix.de>
=2D--
 schedutils/chrt.1 |   11 +++++++++--
 schedutils/chrt.c |   23 +++++++++++++++++++++++
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/schedutils/chrt.1 b/schedutils/chrt.1
index dbc2958..67a9421 100644
=2D-- a/schedutils/chrt.1
+++ b/schedutils/chrt.1
@@ -45,13 +45,16 @@ runs COMMAND with the given attributes.  Both policy (o=
ne=20
of
 .BR SCHED_OTHER ,
 .BR SCHED_FIFO ,
 .BR SCHED_RR ,
+.BR SCHED_BATCH,
 or
=2D.BR SCHED_BATCH )
+.BR SCHED_IDLE)
 and priority can be set and retrieved.
 .PP
 The
 .BR SCHED_BATCH
=2Dpolicy is supported since Linux 2.6.16.
+policy is supported since Linux 2.6.16. The
+.BR SCHED_IDLE
+policy is supported since Linux 2.6.23.
 .SH OPTIONS
 .TP
 .B -p, --pid
@@ -65,6 +68,10 @@ set scheduling policy to
 set scheduling policy to
 .BR SCHED_FIFO
 .TP
+.B -i, --idle
+set schedulng policy to
+.BR SCHED_IDLE
+.TP
 .B -m, --max
 show minimum and maximum valid priorities, then exit
 .TP
diff --git a/schedutils/chrt.c b/schedutils/chrt.c
index ba07dbe..5da8f6b 100644
=2D-- a/schedutils/chrt.c
+++ b/schedutils/chrt.c
@@ -35,6 +35,14 @@
 # define SCHED_BATCH 3
 #endif
=20
+/* the SCHED_IDLE is supported since Linux 2.6.23
+ * commit id 0e6aca43e08a62a48d6770e9a159dbec167bf4c6
+ * -- temporary workaround for people with old glibc headers
+ */
+#ifndef SCHED_IDLE
+# define SCHED_IDLE 5
+#endif
+
 static void show_usage(const char *cmd)
 {
 	fprintf(stderr, "chrt (%s)\n", PACKAGE_STRING);
@@ -45,6 +53,8 @@ static void show_usage(const char *cmd)
 			"set policy to SCHED_BATCH\n");
 	fprintf(stderr, "  -f, --fifo                         "
 			"set policy to SCHED_FIFO\n");
+	fprintf(stderr, "  -i, --idle                         "
+			"set policy to SCHED_IDLE\n");
 	fprintf(stderr, "  -p, --pid                          "
 			"operate on existing given pid\n");
 	fprintf(stderr, "  -m, --max                          "
@@ -87,6 +97,8 @@ static void show_rt_info(const char *what, pid_t pid)
 	case SCHED_FIFO:
 		printf("SCHED_FIFO\n");
 		break;
+	case SCHED_IDLE:
+		printf("SCHED_IDLE\n");
 	case SCHED_RR:
 		printf("SCHED_RR\n");
 		break;
@@ -138,6 +150,13 @@ static void show_min_max(void)
 		printf("SCHED_BATCH min/max priority\t: %d/%d\n", min, max);
 	else
 		printf("SCHED_BATCH not supported?\n");
+
+	max =3D sched_get_priority_max(SCHED_IDLE);
+	min =3D sched_get_priority_min(SCHED_IDLE);
+	if (max >=3D 0 && min >=3D 0)
+		printf("SCHED_IDLE min/max priority\t: %d/%d\n", min, max);
+	else
+		printf("SCHED_IDLE not supported?\n");
 }
=20
 int main(int argc, char *argv[])
@@ -149,6 +168,7 @@ int main(int argc, char *argv[])
 	struct option longopts[] =3D {
 		{ "batch",	0, NULL, 'b' },
 		{ "fifo",	0, NULL, 'f' },
+		{ "idle",	0, NULL, 'i' },
 		{ "pid",	0, NULL, 'p' },
 		{ "help",	0, NULL, 'h' },
 		{ "max",        0, NULL, 'm' },
@@ -170,6 +190,9 @@ int main(int argc, char *argv[])
 		case 'f':
 			policy =3D SCHED_FIFO;
 			break;
+		case 'i':
+			policy =3D SCHED_IDLE;
+			break;
 		case 'm':
 			show_min_max();
 			return 0;

=2D-=20
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

--nextPart174601390.pSdAnut40Y
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjY4qYACgkQHhDFkwOZrpAOfQCfcbkNRcbdVsTptYoqshM5IIBC
a24AnA0k9A1yMGV6T9za21zkpF52DQ+S
=mlfG
-----END PGP SIGNATURE-----

--nextPart174601390.pSdAnut40Y--
