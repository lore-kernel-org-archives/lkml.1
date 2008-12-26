Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbYLZNqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbYLZNqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 08:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbYLZNqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 08:46:05 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:47186 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbYLZNqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 08:46:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=cAPJL34wl5W17PTZMwpJu//4Qe9fRfVISpunGrdrDs1w+FkB7oG1+ePfxVhAV/Udcw
         QdnsbsKia8+aRVvEZea/vUk0n4fF8h3QvPwvFl4jYs+Yskwz1RMJeDVNBkYXuz07L5fb
         4B9SLoznFPkewgLBpxf05iRJTOeo2iDNN2FYw=
Date: Fri, 26 Dec 2008 14:45:56 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/8] ide-cd: first conversion batch
Message-ID: <20081226134556.GA23503@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1229586052-3542-1-git-send-email-petkovbb@gmail.com> <200812192115.41068.bzolnier@gmail.com> <20081220062849.GA14770@gollum.tnic> <200812212005.56973.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812212005.56973.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

On Sun, Dec 21, 2008 at 08:05:56PM +0100, Bartlomiej Zolnierkiewicz wrote:

[.. ]
> > don't do cdrom_decode_status for DRQ_INTERRUPT devices but this is
> > probably not that relevant anymore since we busy-wait for DRQ to get set
> > through ide_wait_stat, as we talked about it before - it being a bugfix for
> > all atapi devices. If there's still interest for that (and I think it
> 
> Yes, this change is OK but for bisectability reasons it would be better
> to do it in pre-patch (which would fix ide-cd.c accordingly).
> 
> [ The other changes in functionality are small and acceptable for this
>   patch (i.e. ide_wait_stat() prints error message now) except the change
>   of the ordering between ->dma_start and ->output_data calls -- which
>   also seems to deserve patch on its own. ]

sorry for the delay but you know how it is, Christmas and all. Anyway,
here are the patches attached as you requested, just in time for the
merge window.

--
From: Borislav Petkov <petkovbb@gmail.com>
Date: Thu, 25 Dec 2008 18:12:34 +0100
Subject: [PATCH 09/11] ide-cd: wait for DRQ to get set per default

... instead of assuming it is set for accelerated DRQ type devices.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 6c7dd8f..1c1ba43 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -572,24 +572,17 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive)
 
 	ide_debug_log(IDE_DBG_PC, "Call %s\n", __func__);
 
-	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
-		/*
-		 * Here we should have been called after receiving an interrupt
-		 * from the device.  DRQ should how be set.
-		 */
-
-		/* check for errors */
-		if (cdrom_decode_status(drive, ATA_DRQ, NULL))
-			return ide_stopped;
+	/* we must wait for DRQ to get set */
+	if (ide_wait_stat(&startstop, drive, ATA_DRQ, ATA_BUSY, WAIT_READY)) {
+		printk(KERN_ERR "%s: timeout while waiting for DRQ to assert\n",
+				drive->name);
+		return startstop;
+	}
 
+	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
 		/* ok, next interrupt will be DMA interrupt */
 		if (drive->dma)
 			drive->waiting_for_dma = 1;
-	} else {
-		/* otherwise, we must wait for DRQ to get set */
-		if (ide_wait_stat(&startstop, drive, ATA_DRQ,
-				  ATA_BUSY, WAIT_READY))
-			return startstop;
 	}
 
 	/* arm the interrupt handler */
-- 
1.6.0.4


-- 
Regards/Gruss,
    Boris.
