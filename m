Return-Path: <linux-kernel-owner+w=401wt.eu-S933562AbYAaNGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562AbYAaNGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 08:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765601AbYAaNGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 08:06:05 -0500
Received: from brick.kernel.dk ([87.55.233.238]:3931 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765290AbYAaNGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 08:06:02 -0500
Date: Thu, 31 Jan 2008 14:05:58 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Nai Xia <nai.xia@gmail.com>
Cc: Roland Dreier <rdreier@cisco.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
       bzolnier@gmail.com, bbpetkov@yahoo.de, flo@rfc822.org,
       linux-kernel@vger.kernel.org, j-nomura@ce.jp.nec.com,
       linux-ide@vger.kernel.org
Subject: Re: kernel BUG at ide-cd.c:1726 in 2.6.24-03863-g0ba6c33 && -g8561b089
Message-ID: <20080131130558.GV15220@kernel.dk>
References: <20080129.151353.48534987.k-ueda@ct.jp.nec.com> <adar6g0e0g2.fsf@cisco.com> <20080129.182356.70224412.k-ueda@ct.jp.nec.com> <20080130.202659.104027826.k-ueda@ct.jp.nec.com> <adamyqmafl3.fsf@cisco.com> <ab418ea90801302349u945788jeed1f42021801dbf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab418ea90801302349u945788jeed1f42021801dbf@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31 2008, Nai Xia wrote:
> My dmesg relevant info is quite similar:
> 
> [    6.875041] Freeing unused kernel memory: 320k freed
> [    8.143120] ide-cd: rq still having bio: dev hdc: type=2, flags=114c8
> [    8.144439]
> [    8.144439] sector 10824201199534213, nr/cnr 0/0
> [    8.144439] bio cf029280, biotail cf029280, buffer 00000000, data
> 00000000, len 158
> [    8.144439] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> [    8.144439] backup: data_len=158  bi_size=158
> [    8.160756] ide-cd: rq still having bio: dev hdc: type=2, flags=114c8
> [    8.160756]
> [    8.160756] sector 2669858, nr/cnr 0/0
> [    8.160756] bio cf029300, biotail cf029300, buffer 00000000, data
> 00000000, len 158
> [    8.160756] cdb: 12 01 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> [    8.160756] backup: data_len=158  bi_size=158
> [   14.851101] eth0: link up
> [   27.121883] eth0: no IPv6 routers present
> 
> 
> And by the way, Kiyoshi,
> This can be reproduced in a typical setup vmware workstation 6.02 with
> a vritual IDE cdrom,
> in case you wanna catch that with your own eyes. :-)
> Thanks for your trying hard to correct this annoying bug.

The below fix should be enough. It's perfectly legal to have leftover
byte counts when the drive signals completion, happens all the time for
eg user issued commands where you don't know an exact byte count.

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 74c6087..bee05a3 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1722,7 +1722,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	 */
 	if ((stat & DRQ_STAT) == 0) {
 		spin_lock_irqsave(&ide_lock, flags);
-		if (__blk_end_request(rq, 0, 0))
+		if (__blk_end_request(rq, 0, rq->data_len))
 			BUG();
 		HWGROUP(drive)->rq = NULL;
 		spin_unlock_irqrestore(&ide_lock, flags);

-- 
Jens Axboe

