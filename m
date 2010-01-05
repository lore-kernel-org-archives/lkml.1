Return-Path: <linux-kernel-owner+w=401wt.eu-S1753702Ab0AEAev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab0AEAev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195Ab0AEAer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:34:47 -0500
Received: from kroah.org ([198.145.64.141]:34114 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094Ab0AEAeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:44 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jgarzik@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/97] pata_cmd64x: fix overclocking of UDMA0-2 modes
Date: Mon,  4 Jan 2010 16:32:23 -0800
Message-Id: <1262651630-7354-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 509426bd46ad0903dca409803e0ee3d30f99f1e8 upstream.

adev->dma_mode stores the transfer mode value not UDMA mode number
so the condition in cmd64x_set_dmamode() is always true and the higher
UDMA clock is always selected.  This can potentially result in data
corruption when UDMA33 device is used, when 40-wire cable is used or
when the error recovery code decides to lower the device speed down.

The issue was introduced in the commit 6a40da0 ("libata cmd64x: whack
into a shape that looks like the documentation") which goes back to
kernel 2.6.20.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ata/pata_cmd64x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index f98dffe..f0bad9b 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -219,7 +219,7 @@ static void cmd64x_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 		regU |= udma_data[adev->dma_mode - XFER_UDMA_0] << shift;
 		/* Merge the control bits */
 		regU |= 1 << adev->devno; /* UDMA on */
-		if (adev->dma_mode > 2)	/* 15nS timing */
+		if (adev->dma_mode > XFER_UDMA_2) /* 15nS timing */
 			regU |= 4 << adev->devno;
 	} else {
 		regU &= ~ (1 << adev->devno);	/* UDMA off */
-- 
1.6.6

