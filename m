Return-Path: <linux-kernel-owner+w=401wt.eu-S933058AbYBMRg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058AbYBMRg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764634AbYBMRfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:35:46 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:14772 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934048AbYBMRfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:35:44 -0500
Date: Wed, 13 Feb 2008 18:35:06 +0100
From: Christian Krafft <krafft@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: parabelboi@bopserverein.de, linuxppc-dev@ozlabs.org
Subject: Re: [Patch 0/2] powerpc: avoid userspace poking to legacy ioports
Message-ID: <20080213183506.7f3e3145@de.ibm.com>
In-Reply-To: <20080213182800.5c6940a8@de.ibm.com>
References: <20080213182800.5c6940a8@de.ibm.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/_wYLmS1NbLHChwWL=X7NGlm";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_wYLmS1NbLHChwWL=X7NGlm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

sensors_detect crashes kernel on PowerPC, as it pokes directly to memory.
This patch adds a check_legacy_ioports to read_port and write_port.
It will now return ENXIO, instead of oopsing.

Signed-off-by: Christian Krafft <krafft@de.ibm.com>

Index: linux.git/drivers/char/mem.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.git.orig/drivers/char/mem.c
+++ linux.git/drivers/char/mem.c
@@ -566,8 +566,13 @@ static ssize_t read_port(struct file * f
 	char __user *tmp =3D buf;
=20
 	if (!access_ok(VERIFY_WRITE, buf, count))
-		return -EFAULT;=20
+		return -EFAULT;
+
 	while (count-- > 0 && i < 65536) {
+#ifdef CONFIG_PPC_MERGE
+		if (check_legacy_ioport(i))
+			return -ENXIO;
+#endif
 		if (__put_user(inb(i),tmp) < 0)=20
 			return -EFAULT; =20
 		i++;
@@ -585,6 +590,7 @@ static ssize_t write_port(struct file *=20
=20
 	if (!access_ok(VERIFY_READ,buf,count))
 		return -EFAULT;
+
 	while (count-- > 0 && i < 65536) {
 		char c;
 		if (__get_user(c, tmp)) {
@@ -592,6 +598,10 @@ static ssize_t write_port(struct file *=20
 				break;
 			return -EFAULT;=20
 		}
+#ifdef CONFIG_PPC_MERGE
+		if (check_legacy_ioport(i))
+			return -ENXIO;
+#endif
 		outb(c,i);
 		i++;
 		tmp++;


--=20
Mit freundlichen Gruessen,
kind regards,

Christian Krafft
IBM Systems & Technology Group,
Linux Kernel Development
IT Specialist


Vorsitzender des Aufsichtsrats:	Martin Jetter
Geschaeftsfuehrung:		Herbert Kircher
Sitz der Gesellschaft:		Boeblingen
Registriergericht:		Amtsgericht Stuttgart, HRB 243294

--Sig_/_wYLmS1NbLHChwWL=X7NGlm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHsypM6rqK4qDx+dcRAlT5AJ9MxPye669npMZstG3636Hho1K2QgCcDl4e
US7ZWRXGItZIEv/zPYV1PdA=
=crdG
-----END PGP SIGNATURE-----

--Sig_/_wYLmS1NbLHChwWL=X7NGlm--
