Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbYBRTRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbYBRTRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 14:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYBRTRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 14:17:03 -0500
Received: from blue.zero.ad.jp ([211.11.96.147]:55521 "EHLO blue.zero.ad.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbYBRTRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 14:17:01 -0500
X-Greylist: delayed 1124 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Feb 2008 14:17:01 EST
Date: Mon, 18 Feb 2008 13:58:27 -0500 (EST)
Message-Id: <20080218.135827.74754725.k-ueda@ct.jp.nec.com>
To: schwab@suse.de
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       petkovbb@gmail.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com
Subject: Re: 2.6.25-rc1/2 CD/DVD burning broken
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <58cb370e0802180759h4d44b9bci86f02919a48c7979@mail.gmail.com>
References: <jelk5k62uy.fsf@sykes.suse.de>
	<58cb370e0802180759h4d44b9bci86f02919a48c7979@mail.gmail.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On Sat, 16 Feb 2008 21:52:21 +0100, Andreas Schwab wrote:
> Since commit aaa04c28cb9a1efd42541fdb7ab648231c2a2263 [blk_end_request:
> changing ide-cd (take 4)] I cannot burn any CD/DVD any more, getting the
> following error from wodim:
> 
> Errno: 0 (Success), write_g1 scsi sendcmd: no error
> CDB:  2A 00 00 00 00 00 00 00 1F 00
> status: 0x2 (CHECK CONDITION)
> Sense Bytes: 70 00 05 00 00 00 00 0E 00 00 00 00 21 02 00 00
> Sense Key: 0x5 Illegal Request, Segment 0
> Sense Code: 0x21 Qual 0x02 (invalid address for write) Fru 0x0
> Sense flags: Blk 0 (not valid) 
> resid: 63488

Could you try this patch?
I've only done a compile test, so this patch may not work.

During the conversion to blk_end_request, the code was changed
*not* to set rq->data_len = 0.
I removed that part because I thought it was just a trigger to
call post_transform_command().  However, since data_len can be
used as a residual length of the transfer, it might have to remain
there.
Actually, wodim seems checking the residual count how far it wrote
(e.g. wodim/wodim.c:write_track_data()).

This patch brings back the rq->data_len = 0.

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
