Return-Path: <linux-kernel-owner+w=401wt.eu-S1762329AbXGXSIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762329AbXGXSIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbXGXSIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:08:39 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40163 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753432AbXGXSIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:08:38 -0400
X-Sasl-enc: khNtBp1E0DZydHJz3nhR1nUNNwMP9JRW+GT9HbDptUzF 1185300515
Message-ID: <46A64019.4010508@imap.cc>
Date: Tue, 24 Jul 2007 20:08:25 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Olaf Hering <olh@suse.de>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: 2.6.22-git17 boot failure
References: <46A3EC92.3050504@imap.cc> <46A3FBB7.9000608@imap.cc> <46A46BF9.6010906@goop.org> <46A481FD.2030607@imap.cc> <46A4C081.6070305@goop.org> <46A504A3.3070205@imap.cc> <46A51079.5030006@goop.org> <46A53396.2060902@imap.cc> <46A5444D.4080304@goop.org> <20070724091018.GA26724@one.firstfloor.org> <20070724095614.GB625@suse.de>
In-Reply-To: <20070724095614.GB625@suse.de>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7A60E1707D5D139EE784AFD3"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7A60E1707D5D139EE784AFD3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Alright, I know what's going on now, and it looks like a problem with
the Opensuse init script. In fact, the initrd for the Xen enabled
kernel got a *different* init script than the one for the non-Xen one.
The difference being:

--- /tmp/testing/init   2007-07-24 15:53:58.000000000 +0200
+++ /tmp/xentest/init   2007-07-24 15:54:16.000000000 +0200
@@ -308,6 +308,9 @@
     fi
 fi

+caps=3D"$(</proc/xen/capabilities)"
+if [ "$caps" !=3D "${caps%control_d*}" ]; then
+
 params=3D
 for p in $(cat /proc/cmdline) ; do
   case $p in
@@ -509,6 +512,32 @@
 echo "Loading dm-snapshot"
 modprobe dm-snapshot $params

+else
+
+params=3D
+for p in $(cat /proc/cmdline) ; do
+  case $p in
+    dm-mod.*)
+      params=3D"$params ${p#dm-mod.}"
+      ;;
+  esac
+done
+echo "Loading dm-mod"
+modprobe dm-mod $params
+
+params=3D
+for p in $(cat /proc/cmdline) ; do
+  case $p in
+    dm-snapshot.*)
+      params=3D"$params ${p#dm-snapshot.}"
+      ;;
+  esac
+done
+echo "Loading dm-snapshot"
+modprobe dm-snapshot $params
+
+fi
+
 echo -n "Waiting for /dev/mapper/control to appear: "
 for i in 1 2 3 4 5; do
     [ -e /dev/mapper/control ] && break

In clear: the Xen init script reads /proc/xen/capabilities and if it
doesn't find the magic string "control_d" in it, willfully *skips*
loading all the SCSI and ATA stuff.

The missing piece then is the innocent little line:

/init: line 311: /proc/xen/capabilities: No such file or directory

appearing on my screen during boot ... BOOM!

If I just diligently type all the skipped modprobe commands

$ modprobe scsi_mod
$ modprobe sd_mod
$ modprobe processor
$ modprobe thermal
$ modprobe libata
$ modprobe ahci
$ modprobe pata_marvell
$ modprobe scsi_transport_spi
$ modprobe aic7xxx
$ modprobe fan
$ modprobe edd
$ ^D

into the fallback shell by hand, the system comes up without further ado.=


So there, case solved. Now you sort it out who's to fix what. :-)

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)


--------------enig7A60E1707D5D139EE784AFD3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGpkAhMdB4Whm86/kRAkceAJ4yg1YR0pQ75ZdunbazsYMfLhUvQACeKlqH
TXungK2cmKtTjp7f65Cv0aA=
=7unF
-----END PGP SIGNATURE-----

--------------enig7A60E1707D5D139EE784AFD3--
