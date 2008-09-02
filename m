Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbYIBXGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbYIBXGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 19:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbYIBXGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 19:06:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37690 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753407AbYIBXGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 19:06:41 -0400
Date: Wed, 3 Sep 2008 00:05:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: jeff@garzik.org, torvalds@osdl.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] ahci: Fix long standing Marvell regressions
Message-ID: <20080903000538.7500eaf8@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pata_marvell: Undo the regressions Jeff caused

From: Alan Cox <alan@redhat.com>

I've been chasing Jeff about this for months so am now giving up and sending
it directly. Jeff added the Marvell device identifiers to the ahci driver
without making the AHCI driver handle the PATA port. This means a lot of users
can't use current kernels and in most distro cases can't even install. This has
been going on since March 2008 for the 6121 Marvell, and late 2007 for the 6145.

This was all pointed out at the time and repeatedly ignored. Bugs assigned
to Jeff about this are ignored also.

To quote Jeff in email

"Just switch the order of 'ahci' and 'pata_marvell' in
/etc/modprobe.conf, then use Fedora's tools regenerate the initrd.

See?  It's not rocket science, and the current configuration can be
easily made to work for Fedora users."

(Which isn't trivial, isn't end user, shouldn't be needed, and as it usually
breaks at install time is in fact impossible)

To quote Jeff in August 2007

"   mv-ahci-pata
Marvell 6121/6141 PATA support.  Needs fixing in the 'PATA controller
command' area before it is usable, and can go upstream."

Only he applied it all anyway later and broke everything.

The actual fix for the moment is very simple. If the user has included
the pata_marvell driver let it drive the ports. If they've only selected
for SATA support give them the AHCI driver which will run the port a fraction
faster.


Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/ata/Kconfig |    6 ++++--
 drivers/ata/ahci.c  |    5 +++++
 2 files changed, 9 insertions(+), 2 deletions(-)


diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index ae84949..11c8c19 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -448,8 +448,10 @@ config PATA_MARVELL
 	tristate "Marvell PATA support via legacy mode"
 	depends on PCI
 	help
-	  This option enables limited support for the Marvell 88SE6145 ATA
-	  controller.
+	  This option enables limited support for the Marvell 88SE61xx ATA
+	  controllers. If you wish to use only the SATA ports then select
+	  the AHCI driver alone. If you wish to the use the PATA port or
+	  both SATA and PATA include this driver.
 
 	  If unsure, say N.
 
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index c729e69..546865a 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -581,9 +581,14 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(SI, 0x1185), board_ahci },		/* SiS 968 */
 	{ PCI_VDEVICE(SI, 0x0186), board_ahci },		/* SiS 968 */
 
+#if  !defined(CONFIG_PATA_MARVELL) && !defined(CONFIG_PATA_MARVELL_MODULE)
 	/* Marvell */
+	/* The AHCI driver can only drive the SATA ports, the PATA driver
+	   can drive them all so if both drivers are selected make sure
+	   AHCI stays out of the way */
 	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
 	{ PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },	/* 6121 */
+#endif
 
 	/* Generic, PCI class code for AHCI */
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
