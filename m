Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbZGSAfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbZGSAfA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 20:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbZGSAe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 20:34:58 -0400
Received: from relais.videotron.ca ([24.201.245.36]:48869 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbZGSAe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 20:34:58 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sat, 18 Jul 2009 20:34:37 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] [MMC] mvsdio: fix handling of partial word at the end of PIO
 transfer
Message-id: <alpine.LFD.2.00.0907182026070.3138@xanadu.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Standard data flow for MMC/SD/SDIO cards requires that the mvsdio
controller be set for big endian operation.  This is causing problems
with buffers which length is not a multiple of 4 bytes as the last
partial word doesn't get shifted all the way and stored properly in
memory.  Let's compensate for this.

Signed-off-by: Nicolas Pitre <nico@marvell.com>
CC: stable@kernel.org
---

Since Pierre is (quite unfortunately) stepping down from MMC 
maintenance, I'm resending this to you in the hope this will reach 
mainline in a timely manner.  Some SDIO devices are broken without this.

diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index b56d72f..34e2348 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -384,7 +384,7 @@ static irqreturn_t mvsd_irq(int irq, void *dev)
 				u16 val[2] = {0, 0};
 				val[0] = mvsd_read(MVSD_FIFO);
 				val[1] = mvsd_read(MVSD_FIFO);
-				memcpy(p, &val, s);
+				memcpy(p, ((void *)&val) + 4 - s, s);
 				s = 0;
 				intr_status = mvsd_read(MVSD_NOR_INTR_STATUS);
 			}
@@ -423,7 +423,7 @@ static irqreturn_t mvsd_irq(int irq, void *dev)
 		if (s < 4) {
 			if (s && (intr_status & MVSD_NOR_TX_AVAIL)) {
 				u16 val[2] = {0, 0};
-				memcpy(&val, p, s);
+				memcpy(((void *)&val) + 4 - s, p, s);
 				mvsd_write(MVSD_FIFO, val[0]);
 				mvsd_write(MVSD_FIFO, val[1]);
 				s = 0;
