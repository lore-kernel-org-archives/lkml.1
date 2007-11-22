Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbXKVU0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbXKVU0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 15:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbXKVU0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 15:26:04 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:35825 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbXKVU0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 15:26:03 -0500
Date: Thu, 22 Nov 2007 21:26:01 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix plip 2
In-Reply-To: <Pine.LNX.4.64.0711222053170.15336@artax.karlin.mff.cuni.cz>
Message-ID: <Pine.LNX.4.64.0711222120501.15336@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0711222053170.15336@artax.karlin.mff.cuni.cz>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1908636959-111217521-1195763161=:15336"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1908636959-111217521-1195763161=:15336
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE

This is my second patch for plip. Plip passes string "name" that is=20
allocated on stack to parport_register_device. parport_register_device=20
holds the pointer to "name" and when the registering function exits, it=20
points nowhere.

On some machine, this bug causes bad names to appear in /proc filesystem,=
=20
such as /proc/sys/dev/parport/parport0/devices/T^/=C1X^/=C1, on others, the=
=20
plip proc node is completely missing.

The patch also fixes documentation to note this requirement.

Mikulas

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

diff -u -r linux-2.6.24-rc2/Documentation/parport-lowlevel.txt linux-2.6.24=
-test/Documentation/parport-lowlevel.txt
--- linux-2.6.24-rc2/Documentation/parport-lowlevel.txt=092007-11-06 22:57:=
46.000000000 +0100
+++ linux-2.6.24-test/Documentation/parport-lowlevel.txt=092007-11-22 21:11=
:28.000000000 +0100
@@ -339,6 +339,10 @@
 ('port').  Once you have done that, you will be able to use
 parport_claim and parport_release in order to use the port.
=20
+The ('name') argument is the name of the device that appears in /proc
+filesystem. The string must be valid for the whole lifetime of the
+device (until parport_unregister_device is called).
+
 This function will register three callbacks into your driver:
 'preempt', 'wakeup' and 'irq'.  Each of these may be NULL in order to
 indicate that you do not want a callback.
diff -u -r linux-2.6.24-rc2/drivers/net/plip.c linux-2.6.24-test/drivers/ne=
t/plip.c
--- linux-2.6.24-rc2/drivers/net/plip.c=092007-11-06 22:57:46.000000000 +01=
00
+++ linux-2.6.24-test/drivers/net/plip.c=092007-11-22 21:11:28.000000000 +0=
100
@@ -1269,7 +1269,7 @@
=20
 =09=09nl =3D netdev_priv(dev);
 =09=09nl->dev =3D dev;
-=09=09nl->pardev =3D parport_register_device(port, name, plip_preempt,
+=09=09nl->pardev =3D parport_register_device(port, dev->name, plip_preempt=
,
 =09=09=09=09=09=09 plip_wakeup, plip_interrupt,
 =09=09=09=09=09=09 0, dev);
=20
--1908636959-111217521-1195763161=:15336--
