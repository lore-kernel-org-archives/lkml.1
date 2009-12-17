Return-Path: <linux-kernel-owner+w=401wt.eu-S936022AbZLQBhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936022AbZLQBhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936041AbZLQBgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:36:53 -0500
Received: from kroah.org ([198.145.64.141]:47979 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763631AbZLQBU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:29 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:03 2009
Message-Id: <20091217011603.801085521@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [45/90] Revert "ide: try to use PIO Mode 0 during probe if possible"
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 0fb18c4777ff424c1db694af98443a201fa4fc30 ]

This reverts commit 6029336426a2b43e4bc6f4a84be8789a047d139e.

Ok, we really do need to revert this, even with Bart's sis5513.c
fix in there.

The problem is that several driver's ->set_pio_mode() method
depends upon the drive->media type being set properly.  Most
of them use this to enable prefetching, which can only be done
for disk media.

But the commit being reverted here calls ->set_pio_mode() before
it's setup.  Actually it considers everything disk because that
is the default media type set by ide_port_init_devices_data().

The set of drivers that depend upon the media type in their
->set_pio_method() are:

drivers/ide/alim15x3.c
drivers/ide/it8172.c
drivers/ide/it8213.c
drivers/ide/pdc202xx_old.c
drivers/ide/piix.c
drivers/ide/qd65xx.c
drivers/ide/sis5513.c
drivers/ide/slc90e66.c

And it is possible that we could fix this by guarding the prefetching
and other media dependent setting changes with a test on
IDE_PFLAG_PROBING in hwif->port_flags, that's simply too risky for
2.6.32-rcX and -stable.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ide/ide-probe.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1035,15 +1035,6 @@ static void ide_port_init_devices(ide_hw
 		if (port_ops && port_ops->init_dev)
 			port_ops->init_dev(drive);
 	}
-
-	ide_port_for_each_dev(i, drive, hwif) {
-		/*
-		 * default to PIO Mode 0 before we figure out
-		 * the most suited mode for the attached device
-		 */
-		if (port_ops && port_ops->set_pio_mode)
-			port_ops->set_pio_mode(drive, 0);
-	}
 }
 
 static void ide_init_port(ide_hwif_t *hwif, unsigned int port,


