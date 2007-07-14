Return-Path: <linux-kernel-owner+w=401wt.eu-S1764268AbXGNAI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764268AbXGNAI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 20:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764033AbXGNAIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 20:08:47 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:59583 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764047AbXGNAIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 20:08:46 -0400
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jul 2007 20:08:45 EDT
Date: Fri, 13 Jul 2007 19:01:51 -0500
From: David Fries <david@fries.net>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] eepro100 resume patch
Message-ID: <20070714000151.GA31482@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
User-Agent: Mutt/1.5.4i
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

When I did a software suspend to disk then resumed the Intel network
card using eepro100 driver would be unable to transmit packets.  I
tracked this down and found a register write after the print message
"DP83840 specific setup" which wasn't being executed when the system
was restored.  This fix moves that write and another write which
forces the link speed and duplex.

After doing this work and preparing the patch I checked out the
mailing list only to find a patch that removes the eepro100.  I then
updated Kconfig, though I wonder why it didn't have a similar message
in it long time ago.

I too had tried the e100 driver some time ago and it didn't work,
eepro100 did and I've been using it so long that I've almost forgotten
about that.  I just gave the e100 driver a try and I've been running
for about an hour now without any problems and it does resume after a
suspend to disk operation.

Signed-off-by: David Fries <David@Fries.net>

Index: drivers/net/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: /home/david/kernel/k/spacedout/patches/linux/drivers/net/Attic/Kc=
onfig,v
retrieving revision 1.1.2.1
diff -u -r1.1.2.1 Kconfig
--- drivers/net/Kconfig	13 Jul 2007 23:16:36 -0000	1.1.2.1
+++ drivers/net/Kconfig	13 Jul 2007 23:31:29 -0000
@@ -1467,6 +1467,11 @@
 	depends on NET_PCI && PCI
 	select MII
 	help
+	  ** Warning ** eepro100 (this driver) has been requested to be
+	  removed from the kernel source tree.  Please use e100 and report
+	  any bugs as that is the driver that will be supported going
+	  forward.
+
 	  If you have an Intel EtherExpress PRO/100 PCI network (Ethernet)
 	  card, say Y and read the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
Index: drivers/net/eepro100.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: /home/david/kernel/k/spacedout/patches/linux/drivers/net/eepro100=
=2Ec,v
retrieving revision 1.4
retrieving revision 1.5
diff -u -r1.4 -r1.5
--- drivers/net/eepro100.c	10 Jul 2007 23:56:54 -0000	1.4
+++ drivers/net/eepro100.c	13 Jul 2007 22:10:16 -0000	1.5
@@ -446,6 +446,7 @@
 	unsigned short partner;			/* Link partner caps. */
 	struct mii_if_info mii_if;		/* MII API hooks, info */
 	u32 msg_enable;				/* debug message level */
+	int option;				/* Module options for this card */
 };
=20
 /* The parameters for a CmdConfigure operation.
@@ -717,6 +718,8 @@
=20
 	/* we must initialize this early, for mdio_{read,write} */
 	sp->regs =3D ioaddr;
+	/* store override options for later use. */
+	sp->option =3D option;
=20
 #if 1 || defined(kernel_bloat)
 	/* OK, this is pure kernel bloat.  I don't like it when other drivers
@@ -743,20 +746,22 @@
 				   phys[(eeprom[7]>>8)&7]);
 		if (((eeprom[6]>>8) & 0x3f) =3D=3D DP83840
 			||  ((eeprom[6]>>8) & 0x3f) =3D=3D DP83840A) {
-			int mdi_reg23 =3D mdio_read(dev, eeprom[6] & 0x1f, 23) | 0x0422;
+			int mdi_reg23_orig =3D mdio_read(dev, eeprom[6] & 0x1f, 23);
+			int mdi_reg23 =3D mdi_reg23_orig | 0x0422;
 			if (congenb)
 			  mdi_reg23 |=3D 0x0100;
-			printk(KERN_INFO"  DP83840 specific setup, setting register 23 to %4.4x=
=2E\n",
-				   mdi_reg23);
-			mdio_write(dev, eeprom[6] & 0x1f, 23, mdi_reg23);
+			/* Print the message here, write in speedo_resume, which
+			 * is called both on module load and from
+			 * eepro100_resume.
+			 */
+			printk(KERN_INFO"  DP83840 specific setup, setting register 23 to %4.4x=
, was %4.4x.\n",
+				   mdi_reg23, mdi_reg23_orig);
 		}
 		if ((option >=3D 0) && (option & 0x70)) {
+			/* Print here, write in speedo_resume. */
 			printk(KERN_INFO "  Forcing %dMbs %s-duplex operation.\n",
 				   (option & 0x20 ? 100 : 10),
 				   (option & 0x10 ? "full" : "half"));
-			mdio_write(dev, eeprom[6] & 0x1f, MII_BMCR,
-					   ((option & 0x20) ? 0x2000 : 0) | 	/* 100mbps? */
-					   ((option & 0x10) ? 0x0100 : 0)); /* Full duplex? */
 		}
=20
 		/* Perform a system self-test. */
@@ -1050,6 +1055,24 @@
 	struct speedo_private *sp =3D netdev_priv(dev);
 	void __iomem *ioaddr =3D sp->regs;
=20
+	/* DP83840 specific setup, moved here from from speedo_found1 because
+	 * it needs to called after resume, ie suspend to disk.
+	 * 07-11-2007 David Fries <david@fries.net>
+	 */
+	if (((sp->phy[0]>>8) & 0x3f) =3D=3D DP83840
+		||  ((sp->phy[0]>>8) & 0x3f) =3D=3D DP83840A) {
+		int mdi_reg23 =3D mdio_read(dev, sp->phy[0] & 0x1f, 23) | 0x0422;
+		if (congenb)
+			mdi_reg23 |=3D 0x0100;
+		mdio_write(dev, sp->phy[0] & 0x1f, 23, mdi_reg23);
+	}
+	if ((sp->option >=3D 0) && (sp->option & 0x70)) {
+		mdio_write(dev, sp->phy[0] & 0x1f, MII_BMCR,
+			((sp->option & 0x20) ? 0x2000 : 0) | 	/* 100mbps? */
+			((sp->option & 0x10) ? 0x0100 : 0)); /* Full duplex? */
+	}
+
+
 	/* Start with a Tx threshold of 256 (0x..20.... 8 byte units). */
 	sp->tx_threshold =3D 0x01208000;
=20


--=20
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFGmBJvAI852cse6PARArfXAKC8ydmCCdxfCjm08QiBFpqEEnt06wCgzVkC
kmSQdQpHBfJ1yM24Gc/f+n8=
=Jf1S
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
