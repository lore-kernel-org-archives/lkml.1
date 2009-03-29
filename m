Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbZC2UNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbZC2UNx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 16:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbZC2UNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 16:13:44 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:37478 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbZC2UNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 16:13:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=fEsur6SYf35jaojGwz6z+6icfLUne/QLRt8TM3A9826Mgu0SLAWw1sEUA1JC/xhwdW
         HM5naAWoMXg1RsHlk4HUTBBmPeUN7mkAQAhh6d+5JfQfFYXXGJ7LhoC1kg8ckus+t/J/
         CsSkwnevkjYQVY4A6AnP9BPt0PlKjprJIfQLM=
Date: Sun, 29 Mar 2009 22:13:37 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Michael Roth <mroth@nessie.de>
Cc: linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Bug in 2.6.29 ide-cd: Kernel freeze: bisected + unacceptable
	workaround
Message-ID: <20090329201337.GA9962@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Michael Roth <mroth@nessie.de>,
	linux-kernel@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <49CFCB2A.4020505@nessie.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <49CFCB2A.4020505@nessie.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Sun, Mar 29, 2009 at 09:25:30PM +0200, Michael Roth wrote:
>
> commit 1e91477aa335fc1c97eb15649ed1a1714cc758ec
> Author: Borislav Petkov <petkovbb@gmail.com>
> Date:   Tue Jan 6 17:20:57 2009 +0100
> 
>     ide-cd: start DMA before sending the actual packet command
> 
>     as it is done for all other IDE ATAPI devices.
> 
>     There should be no functionality change resulting from this patch.
> 
>     Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
>     Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> 
> I tried to revert this patch in 2.6.29 but the revert produced a merge
> conflict and I don't have the knowledge to resolve this conflict.

Well, its kinda strange that this piece of code could be the problem
since the bits it touches are gone (this'll explain the confict when
attempting to revert the patch.) Can we please see a dmesg of a working
kernel on your machine and also is it possible to catch any kernel
output of the crash, any oops or something when your machine freezes -
the more the better. Probably over a serial console would be best but
photographed with a digicam and uploaded somewhere as a screenshot would
do too.

> So as a quick workaround I disabled ide-cd in my kernel config:
> 
> # CONFIG_BLK_DEV_IDECD is not set
> 
> which does the trick but is of course no solution. (I'm writing
> this email with 2.6.29 and disabled ide-cd.)

You could also try the following patch to see whether that is of any
help:

---
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index e9d042d..99fb0b0 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -567,10 +567,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 			timeout, expiry);
 
 	/* Begin DMA, if necessary */
-	if (dev_is_idecd(drive)) {
-		if (drive->dma)
-			hwif->dma_ops->dma_start(drive);
-	} else {
+	if (!dev_is_idecd(drive)) {
 		if (pc->flags & PC_FLAG_DMA_OK) {
 			pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
 			hwif->dma_ops->dma_start(drive);
@@ -581,6 +578,12 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 	if ((drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) == 0)
 		hwif->tp_ops->output_data(drive, NULL, rq->cmd, cmd_len);
 
+	/* Begin DMA, if necessary */
+	if (dev_is_idecd(drive)) {
+		if (drive->dma)
+			hwif->dma_ops->dma_start(drive);
+	}
+
 	return ide_started;
 }

--

Thanks.

-- 
Regards/Gruss,
    Boris.
