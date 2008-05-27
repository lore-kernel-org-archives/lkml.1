Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbYE0Fhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbYE0Fhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 01:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYE0Fhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 01:37:43 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:3616 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbYE0Fhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 01:37:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=YM4+Km3ZYDgOgF/XQBFDAolvyGcjvYTL8JpoOuZijQbs3frh+eURtvS37C9xsUViB+IiWhoY+8Y0xT5qLvPvDWUH1C8s06p+v9fcERhxux9/0A8tcfQXX35Fglap3YBkcHLy5hQOdgCt0sEyrkFF1HNe59B606GxNS6+ap+V4Ds=
Date: Tue, 27 May 2008 07:37:37 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/40] ide-floppy: merge idefloppy_transfer_pc() and
	idefloppy_transfer_pc1()
Message-ID: <20080527053737.GA19760@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain> <20080518185633.5636.61364.sendpatchset@localhost.localdomain> <20080521052429.GA2414@gollum.tnic> <200805272057.42444.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805272057.42444.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 08:57:42PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 21 May 2008, Borislav Petkov wrote:
> > On Sun, May 18, 2008 at 08:56:33PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > * Check IDEFLOPPY_FLAG_ZIP_DRIVE flag in idefloppy_transfer_pc1()
> > >   and skip idefloppy_transfer_pc2()-phase if the flag is not set.
> > > 
> > > * Always use idefloppy_transfer_pc1() in idefloppy_issue_pc()
> > >   and remove no longer needed idefloppy_transfer_pc().
> > 
> > ... and also probably mv idefloppy_transfer_pc1() to something like
> > idefloppy_start_transfer_pc() and rename idefloppy_transfer_pc2() to something
> > more appropriate like e.g. idefloppy_do_transfer_pc() or similar and do away
> > with those misleading names and probably even the comments are superfluous then.
> 
> Probably the most intuitive would be to do:
> 
> 	idefloppy_transfer_pc1() -> idefloppy_transfer_pc()
> 
> and
> 
> 	idefloppy_transfer_pc2() -> idefloppy_do_transfer_pc()
> 
> but I don't feel too strong about it and welcome other ideas
> (preferably in form of patches :).

^Hint^! :) Sure, what about the following:
--

From: Borislav Petkov <petkovbb@gmail.com>
Date: Tue, 27 May 2008 07:31:37 +0200
Subject: [PATCH] ide-floppy: fix unfortunate function naming

mv idefloppy_transfer_pc1 idefloppy_start_pc_transfer
mv idefloppy_transfer_pc2 idefloppy_transfer_pc

which describes their functionality and disambiguates them. There should be no
functionality change introduced by this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-floppy.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 0f3602a..b368943 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -399,12 +399,8 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
  * service routine. In interrupt mode, the device sends an interrupt to signal
  * that it is ready to receive a packet. However, we need to delay about 2-3
  * ticks before issuing the packet or we gets in trouble.
- *
- * So, follow carefully. transfer_pc1 is called as an interrupt (or directly).
- * In either case, when the device says it's ready for a packet, we schedule
- * the packet transfer to occur about 2-3 ticks later in transfer_pc2.
  */
-static int idefloppy_transfer_pc2(ide_drive_t *drive)
+static int idefloppy_transfer_pc(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 
@@ -415,7 +411,13 @@ static int idefloppy_transfer_pc2(ide_drive_t *drive)
 	return IDEFLOPPY_WAIT_CMD;
 }
 
-static ide_startstop_t idefloppy_transfer_pc1(ide_drive_t *drive)
+
+/*
+ * Called as an interrupt (or directly). When the device says it's ready for a
+ * packet, we schedule the packet transfer to occur about 2-3 ticks later in
+ * transfer_pc.
+ */
+static ide_startstop_t idefloppy_start_pc_transfer(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	struct ide_atapi_pc *pc = floppy->pc;
@@ -432,7 +434,7 @@ static ide_startstop_t idefloppy_transfer_pc1(ide_drive_t *drive)
 	 */
 	if (pc->flags & PC_FLAG_ZIP_DRIVE) {
 		timeout = floppy->ticks;
-		expiry = &idefloppy_transfer_pc2;
+		expiry = &idefloppy_transfer_pc;
 	} else {
 		timeout = IDEFLOPPY_WAIT_CMD;
 		expiry = NULL;
@@ -483,7 +485,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 
 	pc->retries++;
 
-	return ide_issue_pc(drive, pc, idefloppy_transfer_pc1,
+	return ide_issue_pc(drive, pc, idefloppy_start_pc_transfer,
 			    IDEFLOPPY_WAIT_CMD, NULL);
 }
 
-- 
1.5.5.1

-- 
Regards/Gruﬂ,
    Boris.
