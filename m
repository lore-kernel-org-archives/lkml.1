Return-Path: <linux-kernel-owner+w=401wt.eu-S1765017AbZANRWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765017AbZANRWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761398AbZANRW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:22:29 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:63969 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350AbZANRW1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:22:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=ANJmaL8zyV2nDLosEmTfNcEM/0YcgX+EEX/YxIiAJ4I1zv3mTNMXEdvX7RDFot6oxE
         GZVP0HvJ0jiRfZXpb56v9znYBRast9QzkacFr4dvNq09TqU9edVYViD4Rl6j5odqnlnN
         mpBoX7W8wwywtAOdXXxTFqpZhjFxDd/uocTsQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Simon Holm =?iso-8859-1?q?Th=F8gersen?= <odie@cs.aau.dk>
Subject: Re: regression: 295f000 breaks suspend to disk
Date: Wed, 14 Jan 2009 18:16:47 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-06859-gede6f5a-dirty; KDE/4.1.3; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
References: <1231797615.2797.5.camel@odie.local>
In-Reply-To: <1231797615.2797.5.camel@odie.local>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901141816.47422.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 January 2009, Simon Holm Thøgersen wrote:
> commit 295f000 ("ide: don't execute the next queued command from the
> hard-IRQ context (v2)") breaks suspend to disk for me. On
> 'echo disk > /sys/power/state' the systems hangs, letting me switch
> virtual consoles, but not responding to Alt+SysRq

Thanks, please try the patch below (it fixes the problem for me):

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: fix suspend regression

On Monday 12 January 2009, Simon Holm Thøgersen wrote:
> commit 295f000 ("ide: don't execute the next queued command from the
> hard-IRQ context (v2)") breaks suspend to disk for me. On
> 'echo disk > /sys/power/state' the systems hangs, letting me switch
> virtual consoles, but not responding to Alt+SysRq

Restart the request queue early for REQ_TYPE_PM_RESUME requests
(though there is only one resume request for the whole resume
sequence it stays in the queue until is fully completed and now
depends on kblockd for processing consequential resume states).

Reported-and-bisected-by: Simon Holm Thøgersen <odie@cs.aau.dk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-pm.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: b/drivers/ide/ide-pm.c
===================================================================
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -186,12 +186,10 @@ void ide_complete_pm_request(ide_drive_t
 	       blk_pm_suspend_request(rq) ? "suspend" : "resume");
 #endif
 	spin_lock_irqsave(q->queue_lock, flags);
-	if (blk_pm_suspend_request(rq)) {
+	if (blk_pm_suspend_request(rq))
 		blk_stop_queue(q);
-	} else {
+	else
 		drive->dev_flags &= ~IDE_DFLAG_BLOCKED;
-		blk_start_queue(q);
-	}
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	drive->hwif->rq = NULL;
@@ -219,6 +217,8 @@ void ide_check_pm_state(ide_drive_t *dri
 		 * point.
 		 */
 		ide_hwif_t *hwif = drive->hwif;
+		struct request_queue *q = drive->queue;
+		unsigned long flags;
 		int rc;
 #ifdef DEBUG_PM
 		printk("%s: Wakeup request inited, waiting for !BSY...\n", drive->name);
@@ -231,5 +231,9 @@ void ide_check_pm_state(ide_drive_t *dri
 		rc = ide_wait_not_busy(hwif, 100000);
 		if (rc)
 			printk(KERN_WARNING "%s: drive not ready on wakeup\n", drive->name);
+
+		spin_lock_irqsave(q->queue_lock, flags);
+		blk_start_queue(q);
+		spin_unlock_irqrestore(q->queue_lock, flags);
 	}
 }
