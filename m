Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbZFETAD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbZFETAD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:00:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbZFES7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:59:54 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51229 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbZFES7y (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:59:54 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: scripts/ver_linux lossage on Fedora 11
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1244228393_3985P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Jun 2009 14:59:53 -0400
Message-ID: <124717.1244228393@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1244228393_3985P
Content-Type: text/plain; charset=us-ascii

I found a few places where ver_linux fails to DTRT on Fedora 11

1) mount version
mount --version | awk '{print $NF}' | sed -e s/^mount-// -e s/\)$//

Unfortunately, Fedora's mount command says:

% mount --version
mount from util-linux-ng 2.14.2 (with libblkid and selinux support)

2) nsf-utils

showmount --version 2>&1 | grep nfs-utils | awk \
'NR==1{print "nfs-utils             ", $NF}'

% showmount --version
showmount for 1.1.5
% rpm -q nfs-utils
nfs-utils-1.1.5-6.fc11.x86_64

3) udev

udevinfo -V 2>&1 | grep version | awk '{print "udev                  ", $3}

% udevinfo -V
the program '/bin/bash' called 'udevinfo', it should use 'udevadm info <options>', this will stop working in a future release
141
% udevadm --version
141

Patch for 2 of these attached.  The showmount one may best be fixed by getting
the --version output fixed to include 'nfs-utils' - or do people think
changing it to another egrep [0-9] is the proper approach? If so, I'll do up
an updated patch...

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--- linux-2.6.30-rc7-mmotm0602/scripts/ver_linux.dist	2009-03-23 19:12:14.000000000 -0400
+++ linux-2.6.30-rc7-mmotm0602/scripts/ver_linux	2009-06-03 14:17:43.000000000 -0400
@@ -23,7 +23,7 @@ echo -n "util-linux             "
 fdformat --version | awk '{print $NF}' | sed -e s/^util-linux-// -e s/\)$//
 
 echo -n "mount                  "
-mount --version | awk '{print $NF}' | sed -e s/^mount-// -e s/\)$//
+mount --version | egrep -o '[0-9]+\.[0-9\.]+' 
 
 depmod -V  2>&1 | awk 'NR==1 {print "module-init-tools     ",$NF}'
 
@@ -87,8 +87,13 @@ oprofiled --version 2>&1 | awk \
 
 expr --v 2>&1 | awk 'NR==1{print "Sh-utils              ", $NF}'
 
+# older udev used this
 udevinfo -V 2>&1 | grep version | awk '{print "udev                  ", $3}'
 
+# and newer use this
+echo -n "udev                   "
+udevadm --version
+
 iwconfig --version 2>&1 | awk \
 '(NR==1 && ($3 == "version")) {print "wireless-tools        ",$4}'
 



--==_Exmh_1244228393_3985P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKKWspcC3lWbTT17ARArxFAJ9f5zXWqTCA+rA5zNhgF5e5XBNyagCgv1Ea
o2O5bCMP0NVHQobFwUGkOn0=
=13m1
-----END PGP SIGNATURE-----

--==_Exmh_1244228393_3985P--
