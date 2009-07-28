Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbZG1Xt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbZG1Xt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZG1Xt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:49:56 -0400
Received: from kroah.org ([198.145.64.141]:35741 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882AbZG1Xtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:55 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:55 2009
Message-Id: <20090728234155.196271019@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nicolas Pitre <nico@marvell.com>
Subject: [patch 26/71] mvsdio: fix handling of partial word at the end of PIO transfer
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=mvsdio-fix-handling-of-partial-word-at-the-end-of-pio-transfer.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nicolas Pitre <nico@cam.org>

commit 6cdbf734493d6e8f5afc6f539b82897772809d43 upstream.

Standard data flow for MMC/SD/SDIO cards requires that the mvsdio
controller be set for big endian operation.  This is causing problems
with buffers which length is not a multiple of 4 bytes as the last
partial word doesn't get shifted all the way and stored properly in
memory.  Let's compensate for this.

Signed-off-by: Nicolas Pitre <nico@marvell.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/mvsdio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -384,7 +384,7 @@ static irqreturn_t mvsd_irq(int irq, voi
 				u16 val[2] = {0, 0};
 				val[0] = mvsd_read(MVSD_FIFO);
 				val[1] = mvsd_read(MVSD_FIFO);
-				memcpy(p, &val, s);
+				memcpy(p, ((void *)&val) + 4 - s, s);
 				s = 0;
 				intr_status = mvsd_read(MVSD_NOR_INTR_STATUS);
 			}
@@ -423,7 +423,7 @@ static irqreturn_t mvsd_irq(int irq, voi
 		if (s < 4) {
 			if (s && (intr_status & MVSD_NOR_TX_AVAIL)) {
 				u16 val[2] = {0, 0};
-				memcpy(&val, p, s);
+				memcpy(((void *)&val) + 4 - s, p, s);
 				mvsd_write(MVSD_FIFO, val[0]);
 				mvsd_write(MVSD_FIFO, val[1]);
 				s = 0;


