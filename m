Return-Path: <linux-kernel-owner+w=401wt.eu-S1757634AbZDWHgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbZDWHgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbZDWH2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:28:51 -0400
Received: from sous-sol.org ([216.99.217.87]:48392 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755198AbZDWH2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:28:50 -0400
Message-Id: <20090423072354.829910686@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:48 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Borislav Petkov <petkovbb@gmail.com>, Michael Roth <mroth@nessie.de>
Subject: [patch 028/100] ide-atapi: start DMA after issuing a packet command
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=ide-atapi-start-dma-after-issuing-a-packet-command.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Borislav Petkov <petkovbb@gmail.com>

upstream commit: 2eba08270990b99fb5429b76ee97184ddd272f7f

Apparently¹, some ATAPI devices want to see the packet command first
before enabling DMA otherwise they simply hang indefinitely. Reorder the
two steps and start DMA only after having issued the command first.

[1] http://marc.info/?l=linux-kernel&m=123835520317235&w=2

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
Reported-by: Michael Roth <mroth@nessie.de>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/ide/ide-atapi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -568,6 +568,10 @@ static ide_startstop_t ide_transfer_pc(i
 					     : ide_pc_intr),
 			timeout, expiry);
 
+	/* Send the actual packet */
+	if ((drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) == 0)
+		hwif->tp_ops->output_data(drive, NULL, rq->cmd, cmd_len);
+
 	/* Begin DMA, if necessary */
 	if (dev_is_idecd(drive)) {
 		if (drive->dma)
@@ -579,10 +583,6 @@ static ide_startstop_t ide_transfer_pc(i
 		}
 	}
 
-	/* Send the actual packet */
-	if ((drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) == 0)
-		hwif->tp_ops->output_data(drive, NULL, rq->cmd, cmd_len);
-
 	return ide_started;
 }
 

