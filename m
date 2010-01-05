Return-Path: <linux-kernel-owner+w=401wt.eu-S932155Ab0AETw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab0AETw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301Ab0AETwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:52:55 -0500
Received: from kroah.org ([198.145.64.141]:46014 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736Ab0AETwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:52:53 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 11:49:14 2010
Message-Id: <20100105194914.456262307@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 11:47:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [02/10] pata_cmd64x: fix overclocking of UDMA0-2 modes
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
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
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -219,7 +219,7 @@ static void cmd64x_set_dmamode(struct at
 		regU |= udma_data[adev->dma_mode - XFER_UDMA_0] << shift;
 		/* Merge the control bits */
 		regU |= 1 << adev->devno; /* UDMA on */
-		if (adev->dma_mode > 2)	/* 15nS timing */
+		if (adev->dma_mode > XFER_UDMA_2) /* 15nS timing */
 			regU |= 4 << adev->devno;
 	} else {
 		regU &= ~ (1 << adev->devno);	/* UDMA off */


