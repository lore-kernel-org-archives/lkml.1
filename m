Return-Path: <linux-kernel-owner+w=401wt.eu-S1759673AbXFCKzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673AbXFCKzX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 06:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbXFCKzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 06:55:10 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:58130 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745AbXFCKzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 06:55:08 -0400
Date: Sun, 3 Jun 2007 12:55:04 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: Christoph Hellwig <hch@lst.de>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       linux-scsi@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: [PATCH] m68k: Atari SCSI driver update_timeout removal
Message-ID: <Pine.LNX.4.64.0706031250190.9351@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>

Atari SCSI driver fixes: remove update_timeout kludge

Signed-off-by: Michael Schmitz <schmitz@debian.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Hellwig <hch@lst.de>
---
This removes the timeout kludge in commit
fb810d121bceb945c5e576356bccba11cbfad7e3 that was NAK'ed by Christoph.

 drivers/scsi/atari_NCR5380.c |   44 +------------------------------------------
 1 file changed, 2 insertions(+), 42 deletions(-)

--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -894,45 +894,6 @@ static int NCR5380_init(struct Scsi_Host
 }
 
 /*
- * our own old-style timeout update
- */
-/*
- * The strategy is to cause the timer code to call scsi_times_out()
- * when the soonest timeout is pending.
- * The arguments are used when we are queueing a new command, because
- * we do not want to subtract the time used from this time, but when we
- * set the timer, we want to take this value into account.
- */
-
-int atari_scsi_update_timeout(Scsi_Cmnd * SCset, int timeout)
-{
-	int rtn;
-
-	/*
-	 * We are using the new error handling code to actually register/deregister
-	 * timers for timeout.
-	 */
-
-	if (!timer_pending(&SCset->eh_timeout))
-		rtn = 0;
-	else
-		rtn = SCset->eh_timeout.expires - jiffies;
-
-	if (timeout == 0) {
-		del_timer(&SCset->eh_timeout);
-		SCset->eh_timeout.data = (unsigned long)NULL;
-		SCset->eh_timeout.expires = 0;
-	} else {
-		if (SCset->eh_timeout.data != (unsigned long)NULL)
-			del_timer(&SCset->eh_timeout);
-		SCset->eh_timeout.data = (unsigned long)SCset;
-		SCset->eh_timeout.expires = jiffies + timeout;
-		add_timer(&SCset->eh_timeout);
-	}
-	return rtn;
-}
-
-/*
  * Function : int NCR5380_queue_command (Scsi_Cmnd *cmd,
  *	void (*done)(Scsi_Cmnd *))
  *
@@ -956,7 +917,6 @@ static int NCR5380_queue_command(Scsi_Cm
 	Scsi_Cmnd *tmp;
 	int oldto;
 	unsigned long flags;
-	// extern int update_timeout(Scsi_Cmnd * SCset, int timeout);
 
 #if (NDEBUG & NDEBUG_NO_WRITE)
 	switch (cmd->cmnd[0]) {
@@ -1029,9 +989,9 @@ static int NCR5380_queue_command(Scsi_Cm
 	 * alter queues and touch the lock.
 	 */
 	if (!IS_A_TT()) {
-		oldto = atari_scsi_update_timeout(cmd, 0);
+		/* perhaps stop command timer here */
 		falcon_get_lock();
-		atari_scsi_update_timeout(cmd, oldto);
+		/* perhaps restart command timer here */
 	}
 	if (!(hostdata->issue_queue) || (cmd->cmnd[0] == REQUEST_SENSE)) {
 		LIST(cmd, hostdata->issue_queue);

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
