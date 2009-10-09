Return-Path: <linux-kernel-owner+w=401wt.eu-S1761832AbZJIXTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761832AbZJIXTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761701AbZJIXRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:17:43 -0400
Received: from kroah.org ([198.145.64.141]:36848 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761693AbZJIXRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:17:42 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:02 2009
Message-Id: <20091009231002.869068404@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:08:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 22/26] sis5513: fix PIO setup for ATAPI devices
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=sis5513-fix-pio-setup-for-atapi-devices.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit e13ee546bb06453939014c7b854e77fb643fd6f1 upstream.

Clear prefetch setting before potentially (re-)enabling it in
config_drive_art_rwp() so the transition of the device type on
the port from ATA to ATAPI (i.e. during warm-plug operation)
is handled correctly.

This is a really old bug (it probably goes back to very early
days of the driver) but it was only affecting warm-plug operation
until the recent "ide: try to use PIO Mode 0 during probe if
possible" change (commit 6029336426a2b43e4bc6f4a84be8789a047d139e).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Tested-by: David Fries <david@fries.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/sis5513.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/ide/sis5513.c
+++ b/drivers/ide/sis5513.c
@@ -2,7 +2,7 @@
  * Copyright (C) 1999-2000	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2002		Lionel Bouton <Lionel.Bouton@inet6.fr>, Maintainer
  * Copyright (C) 2003		Vojtech Pavlik <vojtech@suse.cz>
- * Copyright (C) 2007		Bartlomiej Zolnierkiewicz
+ * Copyright (C) 2007-2009	Bartlomiej Zolnierkiewicz
  *
  * May be copied or modified under the terms of the GNU General Public License
  *
@@ -281,11 +281,13 @@ static void config_drive_art_rwp(ide_dri
 
 	pci_read_config_byte(dev, 0x4b, &reg4bh);
 
+	rw_prefetch = reg4bh & ~(0x11 << drive->dn);
+
 	if (drive->media == ide_disk)
-		rw_prefetch = 0x11 << drive->dn;
+		rw_prefetch |= 0x11 << drive->dn;
 
-	if ((reg4bh & (0x11 << drive->dn)) != rw_prefetch)
-		pci_write_config_byte(dev, 0x4b, reg4bh|rw_prefetch);
+	if (reg4bh != rw_prefetch)
+		pci_write_config_byte(dev, 0x4b, rw_prefetch);
 }
 
 static void sis_set_pio_mode(ide_drive_t *drive, const u8 pio)


