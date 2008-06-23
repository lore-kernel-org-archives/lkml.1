Return-Path: <linux-kernel-owner+w=401wt.eu-S1757475AbYFWJAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbYFWJAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 05:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbYFWJAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 05:00:40 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48856 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbYFWJAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 05:00:39 -0400
Date: Mon, 23 Jun 2008 11:01:31 +0200
From: Pavel Machek <pavel@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Andreas Schwab <schwab@suse.de>,
       kernel list <linux-kernel@vger.kernel.org>, benh@kernel.crashing.org,
       jgarzik@pobox.com, IDE/ATA development list <linux-ide@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: sata_svw data corruption, strange problems
Message-ID: <20080623090130.GF1850@elf.ucw.cz>
References: <20080617093602.GA28140@elf.ucw.cz> <485EF061.3010601@kernel.org> <20080623082055.GB1850@elf.ucw.cz> <je63s0sfxv.fsf@sykes.suse.de> <20080623085338.GE1850@elf.ucw.cz> <485F6540.6000907@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485F6540.6000907@kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-06-23 17:56:32, Tejun Heo wrote:
> Pavel Machek wrote:
> > On Mon 2008-06-23 10:39:40, Andreas Schwab wrote:
> >> Pavel Machek <pavel@suse.cz> writes:
> >>
> >>> +	   controller, the controller could hang. In other cases it
> >>> +	   could return partial data returning in data
> >>> +	   corruption. This problem has been seen in PPC systems and
> >> s/returning/resulting/ ?
> > 
> > Fix thinko in sata_svw comment.
> > 
> > Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> Please collapse into one patch.  Thanks.

--- 

Clarify comment in sata_svw.c.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 16aa683..fb13b82 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -253,21 +253,29 @@ static void k2_bmdma_start_mmio(struct a
 	/* start host DMA transaction */
 	dmactl = readb(mmio + ATA_DMA_CMD);
 	writeb(dmactl | ATA_DMA_START, mmio + ATA_DMA_CMD);
-	/* There is a race condition in certain SATA controllers that can
-	   be seen when the r/w command is given to the controller before the
-	   host DMA is started. On a Read command, the controller would initiate
-	   the command to the drive even before it sees the DMA start. When there
-	   are very fast drives connected to the controller, or when the data request
-	   hits in the drive cache, there is the possibility that the drive returns a part
-	   or all of the requested data to the controller before the DMA start is issued.
-	   In this case, the controller would become confused as to what to do with the data.
-	   In the worst case when all the data is returned back to the controller, the
-	   controller could hang. In other cases it could return partial data returning
-	   in data corruption. This problem has been seen in PPC systems and can also appear
-	   on an system with very fast disks, where the SATA controller is sitting behind a
-	   number of bridges, and hence there is significant latency between the r/w command
-	   and the start command. */
-	/* issue r/w command if the access is to ATA*/
+	/* This works around possible data corruption.
+
+	   On certain SATA controllers that can be seen when the r/w
+	   command is given to the controller before the host DMA is
+	   started.
+
+	   On a Read command, the controller would initiate the
+	   command to the drive even before it sees the DMA
+	   start. When there are very fast drives connected to the
+	   controller, or when the data request hits in the drive
+	   cache, there is the possibility that the drive returns a
+	   part or all of the requested data to the controller before
+	   the DMA start is issued.  In this case, the controller
+	   would become confused as to what to do with the data.  In
+	   the worst case when all the data is returned back to the
+	   controller, the controller could hang. In other cases it
+	   could return partial data returning in data
+	   corruption. This problem has been seen in PPC systems and
+	   can also appear on an system with very fast disks, where
+	   the SATA controller is sitting behind a number of bridges,
+	   and hence there is significant latency between the r/w
+	   command and the start command. */
+	/* issue r/w command if the access is to ATA */
 	if (qc->tf.protocol == ATA_PROT_DMA)
 		ap->ops->sff_exec_command(ap, &qc->tf);
 }


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
