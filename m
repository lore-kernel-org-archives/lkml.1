Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbZEPT2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbZEPT2Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 15:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbZEPT2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 15:28:16 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:47603 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbZEPT2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 15:28:15 -0400
Date: Sat, 16 May 2009 14:00:56 +0200
From: Nico Schottelius <nico-linux-20090330@schottelius.org>
To: Nico Schottelius <nico-linux-20090330@schottelius.org>,
       Sam Ravnborg <sam@ravnborg.org>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: setlocalversion bug [Was: Linux 2.6.30-rc6]
Message-ID: <20090516120056.GB1724@ikn.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090330@schottelius.org>,
	Sam Ravnborg <sam@ravnborg.org>, Jeff Garzik <jeff@garzik.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0905152120140.3301@localhost.localdomain> <4A0E62D4.5080004@garzik.org> <20090516084801.GA16044@uranus.ravnborg.org> <20090516095803.GA1724@ikn.schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oC1+HKm2/end4ao3"
Content-Disposition: inline
In-Reply-To: <20090516095803.GA1724@ikn.schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.30-rc5-next-20090515-05297-g9bbe396 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oC1+HKm2/end4ao3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Sam, Jeff,

fixed and tested it, patch agains 2.6.30-r6 is included below test output.
Also added contact information in case more bugs are found.

# tagged commit
[13:34] ikn:linux-2.6% git describe=20
v2.6.30-rc6
[13:34] ikn:linux-2.6% ./setlocalversion
[13:39] ikn:linux-2.6%=20

# past tagged commit
[13:40] ikn:linux-2.6% git checkout HEAD~1
Previous HEAD position was 72357d5... Merge branch 'for-linus' of git://git=
=2Ekernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6
HEAD is now at 7c7327d... Merge git://git.kernel.org/pub/scm/linux/kernel/g=
it/holtmann/bluetooth-2.6
[13:40] ikn:linux-2.6% git describe=20
v2.6.30-rc5-299-g7c7327d
[13:40] ikn:linux-2.6% ./setlocalversion=20
-00299-g7c7327d
[13:40] ikn:linux-2.6%=20

# fresh git repo, no tag
[13:44] ikn:g2test% ~/b/linux/linux-2.6/setlocalversion=20
-gcb3ca5e

---

Subject: [PATCH] Fix scripts/setlocalversion with tagged git commit

Produce correct output for
- tagged commit (v2.6.30-rc6)
- past tagged commit (v2.6.30-rc5-299-g7c7327d)
- no tag


--- scripts/setlocalversion	2009-05-16 13:34:36.996220867 +0200
+++ setlocalversion	2009-05-16 13:57:26.623233727 +0200
@@ -1,5 +1,13 @@
 #!/bin/sh
-# Print additional version information for non-release trees.
+#
+# This scripts adds local version information from the version
+# control systems git, mercurial (hg) and subversion (svn).
+#
+# If something goes wrong, send a mail the kernel build mailinglist
+# (see MAINTAINERS) and CC Nico Schottelius
+# <nico-linuxsetlocalversion -at- schottelius.org>.
+#
+#
=20
 usage() {
 	echo "Usage: $0 [srctree]" >&2
@@ -10,12 +18,20 @@
=20
 # Check for git and a git repo.
 if head=3D`git rev-parse --verify --short HEAD 2>/dev/null`; then
-	# Do we have an untagged tag?
-	if atag=3D`git describe 2>/dev/null`; then
-		echo "$atag" | awk -F- '{printf("-%05d-%s", $(NF-1),$(NF))}'
-	# add -g${head}, if there is no usable tag
-	else
-		printf '%s%s' -g $head
+
+	# If we are at a tagged commit (like "v2.6.30-rc6"), we ignore it,=20
+	# because this version is defined in the top level Makefile.
+	if [ -z "`git describe --exact-match 2>/dev/null`" ]; then
+
+		# If we are past a tagged commit (like "v2.6.30-rc5-302-g72357d5"),
+		# we pretty print it.
+		if atag=3D"`git describe 2>/dev/null`"; then
+			echo "$atag" | awk -F- '{printf("-%05d-%s", $(NF-1),$(NF))}'
+
+		# If we don't have a tag at all we print -g{commitish}.
+		else
+			printf '%s%s' -g $head
+		fi
 	fi
=20
 	# Is this git on svn?

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--oC1+HKm2/end4ao3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoOqvgACgkQuL75KpiFGIxcrQCgxKT+WfXf0rBb60O8Jzzn7pkp
0sYAnjre095O/v+AHPnvESfuFarT/jWf
=U3yh
-----END PGP SIGNATURE-----

--oC1+HKm2/end4ao3--
