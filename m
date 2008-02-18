Return-Path: <linux-kernel-owner+w=401wt.eu-S1762311AbYBRXOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762311AbYBRXOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 18:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbYBRXO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 18:14:26 -0500
Received: from blue.zero.ad.jp ([211.11.96.147]:46110 "EHLO blue.zero.ad.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388AbYBRXOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 18:14:25 -0500
Date: Mon, 18 Feb 2008 18:14:38 -0500 (EST)
Message-Id: <20080218.181438.78703739.k-ueda@ct.jp.nec.com>
To: bzolnier@gmail.com
Cc: petkovbb@gmail.com, schwab@suse.de, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH] ide-cd: fix missing residual count setting in DMA mode
 (Was 2.6.25-rc1/2 CD/DVD burning broken)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <20080218223747.GA4169@gollum.tnic>
References: <20080218.135827.74754725.k-ueda@ct.jp.nec.com>
	<20080218202041.GA4734@gollum.tnic>
	<20080218223747.GA4169@gollum.tnic>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 18 Feb 2008 23:37:48 +0100, Borislav Petkov wrote:
> On Mon, Feb 18, 2008 at 09:20:41PM +0100, Borislav Petkov wrote:
> > On Mon, Feb 18, 2008 at 01:58:27PM -0500, Kiyoshi Ueda wrote:
> > > Hi Andreas,
> > > 
> > > On Sat, 16 Feb 2008 21:52:21 +0100, Andreas Schwab wrote:
> > > > Since commit aaa04c28cb9a1efd42541fdb7ab648231c2a2263 [blk_end_request:
> > > > changing ide-cd (take 4)] I cannot burn any CD/DVD any more, getting the
> > > > following error from wodim:
> > > > 
> > > > Errno: 0 (Success), write_g1 scsi sendcmd: no error
> > > > CDB:  2A 00 00 00 00 00 00 00 1F 00
> > > > status: 0x2 (CHECK CONDITION)
> > > > Sense Bytes: 70 00 05 00 00 00 00 0E 00 00 00 00 21 02 00 00
> > > > Sense Key: 0x5 Illegal Request, Segment 0
> > > > Sense Code: 0x21 Qual 0x02 (invalid address for write) Fru 0x0
> > > > Sense flags: Blk 0 (not valid) 
> > > > resid: 63488
> > > 
> > > Could you try this patch?
> > > I've only done a compile test, so this patch may not work.
> > > 
> > > During the conversion to blk_end_request, the code was changed
> > > *not* to set rq->data_len = 0.
> > > I removed that part because I thought it was just a trigger to
> > > call post_transform_command().  However, since data_len can be
> > > used as a residual length of the transfer, it might have to remain
> > > there.
> > > Actually, wodim seems checking the residual count how far it wrote
> > > (e.g. wodim/wodim.c:write_track_data()).
> > 
> > and there seems to be some discrepancy between the different burning tools for i
> > just did test burning a cdimage with cdrdao unter 2.6.25-rc2 and it _works_
> > flawlessly:
> > 
> > # cdrdao write --device /dev/hdc test.toc
> > 
> > Cdrdao version 1.2.2 - (C) Andreas Mueller <andreas@daneb.de>
> >   SCSI interface library - (C) Joerg Schilling
> >   Paranoia DAE library - (C) Monty
> > 
> > Check http://cdrdao.sourceforge.net/drives.html#dt for current driver tables.
> > 
> > Using libscg version 'ubuntu-0.8ubuntu1'
> > 
> > /dev/hdc: TOSHIBA ODD-DVD SD-R6372	Rev: 1730
> > Using driver: Generic SCSI-3/MMC - Version 2.0 (options 0x0000)
> > 
> > Starting write at speed 4...
> > Pausing 10 seconds - hit CTRL-C to abort.
> > Process can be aborted with QUIT signal (usually CTRL-\).
> > Turning BURN-Proof on
> > Executing power calibration...
> > Power calibration successful.
> > Writing track 01 (mode MODE1_RAW/MODE1_RAW )...
> > Wrote 1 of 18 MB (Buffers 100%  94%).
> > Wrote 2 of 18 MB (Buffers 100%  94%).
> > Wrote 3 of 18 MB (Buffers 100%  94%).
> > Wrote 4 of 18 MB (Buffers 100%  94%).
> > Wrote 5 of 18 MB (Buffers 100%  94%).
> > Wrote 6 of 18 MB (Buffers 100%  94%).
> > Wrote 7 of 18 MB (Buffers 100%  94%).
> > Wrote 8 of 18 MB (Buffers 100%  94%).
> > Wrote 9 of 18 MB (Buffers 100%  94%).
> > Wrote 10 of 18 MB (Buffers 100%  94%).
> > Wrote 11 of 18 MB (Buffers 100%  94%).
> > Wrote 12 of 18 MB (Buffers 100%  94%).
> > Wrote 13 of 18 MB (Buffers 100%  94%).
> > Wrote 14 of 18 MB (Buffers 100%  94%).
> > Wrote 15 of 18 MB (Buffers 100%  94%).
> > Wrote 16 of 18 MB (Buffers 100%  94%).
> > Wrote 17 of 18 MB (Buffers 100%  94%).
> > Wrote 18 of 18 MB (Buffers 100%  94%).
> > 
> > Wrote 8056 blocks. Buffer fill min 100%/max 100%.
> > Flushing cache...
> > Writing finished successfully.
> > 
> > > This patch brings back the rq->data_len = 0.
> > > 
> > > --- 2.6.25-rc2/drivers/ide/ide-cd.c	2008-02-15 15:57:20.000000000 -0500
> > > +++ ide-fix/drivers/ide/ide-cd.c	2008-02-18 01:23:40.000000000 -0500
> > > @@ -1207,9 +1207,13 @@ static ide_startstop_t cdrom_newpc_intr(
> > >  end_request:
> > >  	if (blk_pc_request(rq)) {
> > >  		unsigned long flags;
> > > +		unsigned int dlen = rq->data_len;
> > > +
> > > +		if (dma)
> > > +			rq->data_len = 0;
> > >  
> > >  		spin_lock_irqsave(&ide_lock, flags);
> > > -		if (__blk_end_request(rq, 0, rq->data_len))
> > > +		if (__blk_end_request(rq, 0, dlen))
> > >  			BUG();
> > >  		HWGROUP(drive)->rq = NULL;
> > >  		spin_unlock_irqrestore(&ide_lock, flags);
> > > 
> > > Thanks,
> > > Kiyoshi Ueda
> > 
> > next will test the one above...
> 
> 
> confirmed here too - burning succeeds both with wodim and cdrdao.

Thank you for testing, Laura, Andreas, Boris.
And I'm really sorry about the bug, all.


Bart,
Please review and apply the patch below to fix the bug.


[PATCH] ide-cd: fix missing residual count setting in DMA mode

This patch fixes the missing residual count setting in DMA mode,
which was introduced during the conversion to blk-end-request.
The residual count could be used by the request submitter.
So if it isn't set correctly, some upper layers does not work.
(e.g. wodim for CD burning.)

The bug is in only DMA mode.
In PIO mode, we are setting the residual count correctly,
so no need to fix.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/ide/ide-cd.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- 2.6.25-rc2/drivers/ide/ide-cd.c	2008-02-15 15:57:20.000000000 -0500
+++ ide-fix/drivers/ide/ide-cd.c	2008-02-18 01:23:40.000000000 -0500
@@ -1207,9 +1207,13 @@ static ide_startstop_t cdrom_newpc_intr(
 end_request:
 	if (blk_pc_request(rq)) {
 		unsigned long flags;
+		unsigned int dlen = rq->data_len;
+
+		if (dma)
+			rq->data_len = 0;
 
 		spin_lock_irqsave(&ide_lock, flags);
-		if (__blk_end_request(rq, 0, rq->data_len))
+		if (__blk_end_request(rq, 0, dlen))
 			BUG();
 		HWGROUP(drive)->rq = NULL;
 		spin_unlock_irqrestore(&ide_lock, flags);

Thanks,
Kiyoshi Ueda
