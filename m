Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbZCaHpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbZCaHpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 03:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756463AbZCaHpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 03:45:17 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:25624 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbZCaHpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 03:45:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=m/SzpG5HsmGzAwbVbKhi6+WJ8Md6HhX4EEyM3nI7uS5ybYnegC8DaVIwz73n5INI85
         uu2l9/ceOlYrcDJ4IZ178iSZE/ojih0/HxQ/NvJ135Vb2My/zVS1za/HL4tO0v6Wr7fu
         x0Ezg0dxGR7/4JUf9LQZz54lV0+tqRXqWfE98=
Date: Tue, 31 Mar 2009 09:45:08 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Michael Roth <mroth@nessie.de>, linux-kernel@vger.kernel.org
Subject: Re: Bug in 2.6.29 ide-cd: Kernel freeze: bisected + unacceptable
	workaround
Message-ID: <20090331074508.GA16403@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Michael Roth <mroth@nessie.de>, linux-kernel@vger.kernel.org
References: <49CFCB2A.4020505@nessie.de> <49CFEA24.10700@nessie.de> <20090330072713.GA13776@liondog.tnic> <200903302228.54601.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903302228.54601.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > @Bart: can you take at look at this. Somehow, if the device is behind a
> > PCI IDE controller, the order of issuing the command and enabling DMA is
> > important. Seen something like that before?
> 
> Spec is unclear on the ordering but empirically it seems that some hosts
> may need packet command to start DMA.  I think that we should proceed with
> your patch (please repost with patch description) and also apply the same
> change to the rest of ATAPI devices in a subsequent patch.

Why two patches, do we really need to differentiate between ide-cd and
other ATAPI devices? Besides the patch is so simple: 4 lines moved up.
Anyway, I lightly tested it with ide-cd and ide-floppy and both seem to
take it ok. Also, if I remember correctly, the original ide-cd behavior
was to issue the command and _then_ start DMA so we're back to that. I
guess now we should be concerned whether the other ATAPI devices can
handle the reverse situation where you first issue a command and _then_
start DMA.. Hmm...

--
From: Borislav Petkov <petkovbb@gmail.com>
Date: Tue, 31 Mar 2009 09:36:44 +0200
Subject: [PATCH] ide-atapi: start DMA after issuing a packet command
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Apparently¹, some ATAPI devices want to see the packet command first
before enabling DMA otherwise they simply hang indefinitely. Reorder the
two steps and start DMA only after having issued the command first.

[1] http://marc.info/?l=linux-kernel&m=123835520317235&w=2

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index c139cc7..3e43b88 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -563,6 +563,10 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 					     : ide_pc_intr),
 			timeout);
 
+	/* Send the actual packet */
+	if ((drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) == 0)
+		hwif->tp_ops->output_data(drive, NULL, rq->cmd, cmd_len);
+
 	/* Begin DMA, if necessary */
 	if (dev_is_idecd(drive)) {
 		if (drive->dma)
@@ -574,10 +578,6 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 		}
 	}
 
-	/* Send the actual packet */
-	if ((drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) == 0)
-		hwif->tp_ops->output_data(drive, NULL, rq->cmd, cmd_len);
-
 	return ide_started;
 }
 
-- 
1.6.2.1


-- 
Regards/Gruss,
    Boris.
