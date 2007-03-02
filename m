Return-Path: <linux-kernel-owner+w=401wt.eu-S933351AbXCBNwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351AbXCBNwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 08:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965347AbXCBNwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 08:52:43 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46710 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933357AbXCBNwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 08:52:42 -0500
Date: Fri, 2 Mar 2007 14:56:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, jgarzik@pobox.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] pata_qdi: Fix initialisation
Message-ID: <20070302145635.1fc6fac7@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The QDI init code contains some bugs which mean it only works if you have
a test setup that causes both a successful and failed probe. Fix this

Found by Philip Guo

(Who found it working on code analysis tools not running VLB IDE
controllers)

Signed-off-by: Alan Cox <alan@redhat.com>diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/pata_qdi.c linux-2.6.21-rc2/drivers/ata/pata_qdi.c
--- linux.vanilla-2.6.21-rc2/drivers/ata/pata_qdi.c	2007-03-01 13:36:03.000000000 +0000
+++ linux-2.6.21-rc2/drivers/ata/pata_qdi.c	2007-03-02 13:20:27.000000000 +0000
@@ -363,7 +365,8 @@
 					release_region(port, 2);
 					continue;
 				}
-				ct += qdi_init_one(port, 6500, ide_port[r & 0x01], ide_irq[r & 0x01], r & 0x04);
+				if (qdi_init_one(port, 6500, ide_port[r & 0x01], ide_irq[r & 0x01], r & 0x04) == 0)
+					ct++;
 			}
 			if (((r & 0xF0) == 0xA0) || (r & 0xF0) == 0x50) {
 				/* QD6580: dual channel */
@@ -375,11 +378,14 @@
 				res = inb(port + 3);
 				if (res & 1) {
 					/* Single channel mode */
-					ct += qdi_init_one(port, 6580, ide_port[r & 0x01], ide_irq[r & 0x01], r & 0x04);
+					if (qdi_init_one(port, 6580, ide_port[r & 0x01], ide_irq[r & 0x01], r & 0x04))
+						ct++;
 				} else {
 					/* Dual channel mode */
-					ct += qdi_init_one(port, 6580, 0x1F0, 14, r & 0x04);
-					ct += qdi_init_one(port + 2, 6580, 0x170, 15, r & 0x04);
+					if (qdi_init_one(port, 6580, 0x1F0, 14, r & 0x04) == 0)
+						ct++;
+					if (qdi_init_one(port + 2, 6580, 0x170, 15, r & 0x04) == 0)
+						ct++;
 				}
 			}
 		}


