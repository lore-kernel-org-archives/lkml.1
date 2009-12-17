Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbZLQBiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbZLQBiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932558AbZLQBg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:36:56 -0500
Received: from kroah.org ([198.145.64.141]:47979 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763626AbZLQBU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:27 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:03 2009
Message-Id: <20091217011603.486845303@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikulas Patocka <mpatocka@redhat.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [43/90] ide: Serialize CMD643 and CMD646 to fix a hardware bug with SSD
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 9bd7496f5dd488e109e91d9d5743915fb4dfbfde ]

CMD646 corrupts data on concurrent transfers on both channels when IDE SSD is
connected to one of the channels.

Setup that demonstrates this hardware bug: Ultra 5, onboard CMD646, rev 3.
/dev/hda is 8GB Seagate ST38410A in MWDMA2
/dev/hdd is 32GB SSD SiliconHardDisk in MWDMA2

- When reading /dev/hdd (for example with dd or fsck), reads from /dev/hda
  are corrupted, there are twiddled single bits 1->0 and some full 32-bit
  words corrupted, sometimes commands fail (which switches /dev/hda to
  PIO mode but the corruptions happen even in PIO).
- Reads from /dev/hdd don't seem to be corrupted (i.e. fsck passes fine).
- When I connected normal rotating harddisk to /dev/hdd, there was no
  corruption, so the corruption is something specific to SSD.
- I tried the same setup on a PCI card with CMD649 and saw no corruption.

This patch serializes the operation for CMD646 and 643 (I didn't test
CMD643 but it may have the same hw bug too because it's earlier design).
CMD649 is good. I don't know anything about CMD 648.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Tested-by: Frans Pop <elendil@planet.nl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ide/cmd64x.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -379,7 +379,8 @@ static const struct ide_port_info cmd64x
 		.enablebits	= {{0x00,0x00,0x00}, {0x51,0x08,0x08}},
 		.port_ops	= &cmd64x_port_ops,
 		.host_flags	= IDE_HFLAG_CLEAR_SIMPLEX |
-				  IDE_HFLAG_ABUSE_PREFETCH,
+				  IDE_HFLAG_ABUSE_PREFETCH |
+				  IDE_HFLAG_SERIALIZE,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= 0x00, /* no udma */
@@ -389,7 +390,8 @@ static const struct ide_port_info cmd64x
 		.init_chipset	= init_chipset_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.port_ops	= &cmd648_port_ops,
-		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
+		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH |
+				  IDE_HFLAG_SERIALIZE,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA2,


