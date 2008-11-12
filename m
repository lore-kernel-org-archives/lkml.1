Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbYKLVek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbYKLVek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbYKLVdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:33:13 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:8933 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbYKLVdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:33:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=bYGKZRkWS75XHRIt5FTOUk0tmReisYMaILD8UucVc8akzN36q0L0L0XZyKd0CMe4Az
         eoGNODIheQSrv+H7g0CNGoCPSeTPpUEglWq+cmxXtyNRu65HzlOYQOcHDXqPCeNWfQZo
         C/zo91vDv5QRRTZ+NywLiuBDcTyguuKlet9B4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 6/6] ide: remove IDE PM hack from do_ide_request()
Date: Wed, 12 Nov 2008 22:17:51 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811122217.52043.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now tell block layer that there is still work to do using
blk_plug_device() so hack for IDE Power Management can be removed
(it was buggy for hwgroups having more than 4 devices anyway).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -786,7 +786,6 @@ void do_ide_request(struct request_queue
 	ide_hwif_t	*hwif;
 	struct request	*rq;
 	ide_startstop_t	startstop;
-	int             loops = 0;
 
 	/* caller must own hwgroup->lock */
 	BUG_ON(!irqs_disabled());
@@ -844,7 +843,7 @@ void do_ide_request(struct request_queue
 
 		if (drive != orig_drive)
 			goto plug_device;
-again:
+
 		hwif = drive->hwif;
 
 		if (hwif != hwgroup->hwif) {
@@ -882,16 +881,10 @@ again:
 		 * though. I hope that doesn't happen too much, hopefully not
 		 * unless the subdriver triggers such a thing in its own PM
 		 * state machine.
-		 *
-		 * We count how many times we loop here to make sure we service
-		 * all drives in the hwgroup without looping for ever
 		 */
 		if ((drive->dev_flags & IDE_DFLAG_BLOCKED) &&
 		    blk_pm_request(rq) == 0 &&
 		    (rq->cmd_flags & REQ_PREEMPT) == 0) {
-			drive = drive->next ? drive->next : hwgroup->drive;
-			if (loops++ < 4 && !blk_queue_plugged(drive->queue))
-				goto again;
 			/* We clear busy, there should be no pending ATA command at this point. */
 			hwgroup->busy = 0;
 			goto plug_device;
