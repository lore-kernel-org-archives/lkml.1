Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbYLHQxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbYLHQxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 11:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbYLHQxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 11:53:13 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:19660 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbYLHQxM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 11:53:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=fvt4t8RnyV8u7BUOOFLh4lPBhxX/R2hWd05MK87TUEqzuIshqw0D273T7jDq0uBlyc
         VK4uM8rvWFd/3oq+FggJLSIkvlfA0s0zo8wDa1HkyXV97kficqTYMuIavfmz2rAawuzO
         77QbKoMR7Ew73d9UAc26XZe321psVk0Eg0Zxo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Paul Collins <paul@burly.ondioline.org>
Subject: Re: [REGRESSION] commit "ide: respect current DMA setting during resume" breaks resume on PowerBook G4
Date: Mon, 8 Dec 2008 17:51:49 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc6-next-20081128; KDE/4.1.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl
References: <87wseb8mkm.fsf@burly.wgtn.ondioline.org>
In-Reply-To: <87wseb8mkm.fsf@burly.wgtn.ondioline.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200812081751.51063.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2008, Paul Collins wrote:
> Commit e9eb8388306364295308132265c00bea685f409f ("ide: respect current
> DMA setting during resume") breaks resume on my PowerBook G4.
> 
> I get a stream of the following:
> 
>     hda: task_out_intr: status=0x51 { DriveReady SeekComplete Error }
>     hda: task_out_intr: error=0x04 { DriveStatusError }
>     ide: failed opcode was: unknown
> 
> and generally the machine hangs, although once it reported
> 
>     ide0: reset: success
> 
> and resumed successfully.

Sorry about this.  I'll send the following patch to Linus in few minutes...

>From 1a659880ee755d96eeabe64bded059abed6d5ef5 Mon Sep 17 00:00:00 2001
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Mon, 8 Dec 2008 17:42:35 +0100
Subject: [PATCH] Revert "ide: respect current DMA setting during resume"

This reverts commit e9eb8388306364295308132265c00bea685f409f since
it could break resume (thanks to Paul Collins for the report).

I'll look into sorting this out properly for 2.6.29
but for 2.6.28 it is the best to just revert my patch.

Reported-by: Paul Collins <paul@burly.ondioline.org>
Cc: rjw@sisk.pl
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 7d275b2..cc35d6d 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -208,8 +208,10 @@ static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *
 		 */
 		if (drive->hwif->dma_ops == NULL)
 			break;
-		if (drive->dev_flags & IDE_DFLAG_USING_DMA)
-			ide_set_dma(drive);
+		/*
+		 * TODO: respect IDE_DFLAG_USING_DMA
+		 */
+		ide_set_dma(drive);
 		break;
 	}
 
-- 
1.6.0.4
