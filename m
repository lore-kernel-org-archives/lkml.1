Return-Path: <linux-kernel-owner+w=401wt.eu-S934416AbYAaRGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934416AbYAaRGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760755AbYAaRGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:06:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760169AbYAaRGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:06:34 -0500
Date: Thu, 31 Jan 2008 12:04:45 -0500 (EST)
Message-Id: <20080131.120445.48535245.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: nai.xia@gmail.com, rdreier@cisco.com, bzolnier@gmail.com,
       bbpetkov@yahoo.de, flo@rfc822.org, linux-kernel@vger.kernel.org,
       j-nomura@ce.jp.nec.com, linux-ide@vger.kernel.org, mingo@elte.hu,
       clameter@sgi.com, travis@sgi.com, k-ueda@ct.jp.nec.com
Subject: Re: kernel BUG at ide-cd.c:1726 in 2.6.24-03863-g0ba6c33 &&
 -g8561b089
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <20080131130558.GV15220@kernel.dk>
References: <adamyqmafl3.fsf@cisco.com>
	<ab418ea90801302349u945788jeed1f42021801dbf@mail.gmail.com>
	<20080131130558.GV15220@kernel.dk>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

On Thu, 31 Jan 2008 14:05:58 +0100, Jens Axboe wrote:
> On Thu, Jan 31 2008, Nai Xia wrote:
> > My dmesg relevant info is quite similar:
> > 
> > [    6.875041] Freeing unused kernel memory: 320k freed
> > [    8.143120] ide-cd: rq still having bio: dev hdc: type=2, flags=114c8
> > [    8.144439]
> > [    8.144439] sector 10824201199534213, nr/cnr 0/0
> > [    8.144439] bio cf029280, biotail cf029280, buffer 00000000, data
> > 00000000, len 158
> > [    8.144439] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> > [    8.144439] backup: data_len=158  bi_size=158
> > [    8.160756] ide-cd: rq still having bio: dev hdc: type=2, flags=114c8
> > [    8.160756]
> > [    8.160756] sector 2669858, nr/cnr 0/0
> > [    8.160756] bio cf029300, biotail cf029300, buffer 00000000, data
> > 00000000, len 158
> > [    8.160756] cdb: 12 01 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> > [    8.160756] backup: data_len=158  bi_size=158
> > [   14.851101] eth0: link up
> > [   27.121883] eth0: no IPv6 routers present
> > 
> > 
> > And by the way, Kiyoshi,
> > This can be reproduced in a typical setup vmware workstation 6.02 with
> > a vritual IDE cdrom,
> > in case you wanna catch that with your own eyes. :-)
> > Thanks for your trying hard to correct this annoying bug.
> 
> The below fix should be enough. It's perfectly legal to have leftover
> byte counts when the drive signals completion, happens all the time for
> eg user issued commands where you don't know an exact byte count.
> 
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index 74c6087..bee05a3 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -1722,7 +1722,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
>  	 */
>  	if ((stat & DRQ_STAT) == 0) {
>  		spin_lock_irqsave(&ide_lock, flags);
> -		if (__blk_end_request(rq, 0, 0))
> +		if (__blk_end_request(rq, 0, rq->data_len))
>  			BUG();
>  		HWGROUP(drive)->rq = NULL;
>  		spin_unlock_irqrestore(&ide_lock, flags);

OK, I undarstand the leftover is legal.

By the way, is it safe to always return success if there is a leftover?
I thought we might have to complete the rq with -EIO in such case.

Thanks,
Kiyoshi Ueda
