Return-Path: <linux-kernel-owner+w=401wt.eu-S970944AbXHMO1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970944AbXHMO1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967555AbXHML1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:27:47 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:47820
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967309AbXHML1o convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:27:44 -0400
Message-Id: <46C05C8A.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 13 Aug 2007 12:28:42 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] floppy: tolerate DMA channel unavailability
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The floppy driver is already written to be able to operate in virtual
DMA mode. Thus it can easily be adjusted to tolerate failure from
fd_request_dma() as long as virtual DMA mode is not disallowed.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 drivers/block/floppy.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

--- linux-2.6.23-rc3/drivers/block/floppy.c	2007-08-13 08:59:58.000000000 +0200
+++ 2.6.23-rc3-floppy-no-dma/drivers/block/floppy.c	2007-08-07 10:40:43.000000000 +0200
@@ -4397,11 +4397,15 @@ static int floppy_grab_irq_and_dma(void)
 	if (fd_request_dma()) {
 		DPRINT("Unable to grab DMA%d for the floppy driver\n",
 		       FLOPPY_DMA);
-		fd_free_irq();
-		spin_lock_irqsave(&floppy_usage_lock, flags);
-		usage_count--;
-		spin_unlock_irqrestore(&floppy_usage_lock, flags);
-		return -1;
+		if (can_use_virtual_dma & 2)
+			use_virtual_dma = can_use_virtual_dma = 1;
+		if (!(can_use_virtual_dma & 1)) {
+			fd_free_irq();
+			spin_lock_irqsave(&floppy_usage_lock, flags);
+			usage_count--;
+			spin_unlock_irqrestore(&floppy_usage_lock, flags);
+			return -1;
+		}
 	}
 
 	for (fdc = 0; fdc < N_FDC; fdc++) {



