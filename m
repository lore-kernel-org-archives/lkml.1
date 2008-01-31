Return-Path: <linux-kernel-owner+w=401wt.eu-S1761810AbYAaB2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761810AbYAaB2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 20:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760689AbYAaB1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 20:27:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759751AbYAaB1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 20:27:48 -0500
Date: Wed, 30 Jan 2008 20:26:59 -0500 (EST)
Message-Id: <20080130.202659.104027826.k-ueda@ct.jp.nec.com>
To: bzolnier@gmail.com, rdreier@cisco.com, bbpetkov@yahoo.de
Cc: nai.xia@gmail.com, flo@rfc822.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com,
       linux-ide@vger.kernel.org
Subject: Re: kernel BUG at ide-cd.c:1726 in 2.6.24-03863-g0ba6c33 &&
 -g8561b089
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <20080129.182356.70224412.k-ueda@ct.jp.nec.com>
References: <20080129.151353.48534987.k-ueda@ct.jp.nec.com>
	<adar6g0e0g2.fsf@cisco.com>
	<20080129.182356.70224412.k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland, Borislav, Bart,

Added linux-ide ML, since we may be able to get helps from other
ide experts.  This thread started from:
    http://lkml.org/lkml/2008/1/29/140

On Tue, 29 Jan 2008 18:23:56 -0500 (EST), Kiyoshi Ueda wrote:
> Hi Bart, 
> 
> On Tue, 29 Jan 2008 14:22:53 -0800, Roland Dreier wrote:
> > Hi, I saw the same BUG from ide-cd on one of my systems.  I applied
> > the debugging patch to replace the BUG with blk_dump_rq_flags(), and I
> > got the output below (full boot log and .config attached to this
> > email).
> > 
> > Please let me know if there's anything else that would help debug the
> > problem.
> 
> Thank you for the information, Roland.
> 
>  
> > [    4.072271] Uniform CD-ROM driver Revision: 3.20
> > [    4.098236] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
> > [    4.100269]
> > [    4.100269] sector 1949759, nr/cnr 0/0
> > [    4.100269] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d8
> > [    4.100269] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> > [    4.101005] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
> > [    4.104269]
> > [    4.104269] sector 1949759, nr/cnr 0/0
> > [    4.104269] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d2
> > [    4.104269] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> > [    4.109203] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
> > [    4.112270]
> > [    4.112270] sector 1949759, nr/cnr 0/0
> > [    4.112270] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d8
> > [    4.112270] cdb: 12 01 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> > [    4.112945] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
> > [    4.116270]
> > [    4.116270] sector 1949759, nr/cnr 0/0
> > [    4.116270] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d2
> > [    4.116270] cdb: 12 01 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> 
> Bart,
> This means that the rq still has a bio even after DRQ_STAT is cleared.
> The original ide-cd code was calling only end_that_request_last() there.
> So I thought that the rq should have no bio when DRQ_STAT is cleared,
> otherwise the bio leaks.
> 
> Was my understanding wrong and is that correct behavior in ide-cd?

I borrowed a box having the same nForce chipset and tried sg_inq
command to submit the GPCMD_INQUIRY ("cdb: 12" of the debug message).
I confirmed that ide-cd run through the code path (DRQ_STAT == 0)
by the same debug patch, but requests always don't have bio there
on my test box.  So I can't reproduce the problem yet.
-----------------------------------------------------------------------
ide-cd: rq: dev hda: type=2, flags=114c8

sector 37958141, nr/cnr 0/0
bio 00000000, biotail f78e4980, buffer 00000000, data 00000000, len 0
cdb: 12 00 00 00 24 00 00 00 00 00 00 00 00 00 00 00
-----------------------------------------------------------------------


The original code was calling only end_that_request_last() here,
but no problem happened.
This may mean that the upper layer can handle the rq correctly,
no matter whether the rq still has a bio or not.
If so, we should be able to unlink the bio by calling
end_that_request_chunk() with remaining data size.



Roland,
Could you try the patch below and give me all boot messages again?

This patch displays debug messages against requests still having bio,
then tries to unlink all bios from the rq before the rq is completed.
So your system may be able to continue to work correctly
after displaying debug messages.
I'd like to see the debug messages and know whether your system
still gets the problem or not.

--- a/drivers/ide/ide-cd.c	2008-01-30 18:24:51.000000000 -0500
+++ b/drivers/ide/ide-cd.c	2008-01-30 18:24:33.000000000 -0500
@@ -1722,8 +1722,18 @@ static ide_startstop_t cdrom_newpc_intr(
 	 */
 	if ((stat & DRQ_STAT) == 0) {
 		spin_lock_irqsave(&ide_lock, flags);
-		if (__blk_end_request(rq, 0, 0))
-			BUG();
+		if (__blk_end_request(rq, 0, 0)) {
+			blk_dump_rq_flags(rq, "ide-cd: rq still having bio");
+			printk("backup: data_len=%u  bi_size=%u\n",
+				rq->data_len, rq->bio->bi_size);
+
+			if (__blk_end_request(rq, 0, rq->data_len)) {
+				blk_dump_rq_flags(rq, "ide-cd: BAD rq");
+				printk("backup: data_len=%u  bi_size=%u\n",
+					rq->data_len, rq->bio->bi_size);
+				BUG();
+			}
+		}
 		HWGROUP(drive)->rq = NULL;
 		spin_unlock_irqrestore(&ide_lock, flags);
 
Thanks,
Kiyoshi Ueda
