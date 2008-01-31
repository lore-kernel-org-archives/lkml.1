Return-Path: <linux-kernel-owner+w=401wt.eu-S932817AbYAaWgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817AbYAaWgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759696AbYAaWgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:36:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbYAaWgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:36:07 -0500
Date: Thu, 31 Jan 2008 17:35:56 -0500 (EST)
Message-Id: <20080131.173556.38717303.k-ueda@ct.jp.nec.com>
To: petkovbb@gmail.com, petkovbb@googlemail.com
Cc: jens.axboe@oracle.com, nai.xia@gmail.com, rdreier@cisco.com,
       bzolnier@gmail.com, flo@rfc822.org, linux-kernel@vger.kernel.org,
       j-nomura@ce.jp.nec.com, linux-ide@vger.kernel.org, k-ueda@ct.jp.nec.com
Subject: Re: kernel BUG at ide-cd.c:1726 in 2.6.24-03863-g0ba6c33 &&
 -g8561b089
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <20080131213740.GA4500@gollum.tnic>
References: <ab418ea90801302349u945788jeed1f42021801dbf@mail.gmail.com>
	<20080131130558.GV15220@kernel.dk>
	<20080131213740.GA4500@gollum.tnic>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

Thank you for the confirmation of original behavior.

On Thu, 31 Jan 2008 22:37:40 +0100, Borislav Petkov wrote:
> On Thu, Jan 31, 2008 at 02:05:58PM +0100, Jens Axboe wrote:
> > On Thu, Jan 31 2008, Nai Xia wrote:
> > > My dmesg relevant info is quite similar:
> > > 
> > > [    6.875041] Freeing unused kernel memory: 320k freed
> > > [    8.143120] ide-cd: rq still having bio: dev hdc: type=2, flags=114c8
> > > [    8.144439]
> > > [    8.144439] sector 10824201199534213, nr/cnr 0/0
> > > [    8.144439] bio cf029280, biotail cf029280, buffer 00000000, data
> > > 00000000, len 158
> > > [    8.144439] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> > > [    8.144439] backup: data_len=158  bi_size=158
> > > [    8.160756] ide-cd: rq still having bio: dev hdc: type=2, flags=114c8
> > > [    8.160756]
> > > [    8.160756] sector 2669858, nr/cnr 0/0
> > > [    8.160756] bio cf029300, biotail cf029300, buffer 00000000, data
> > > 00000000, len 158
> > > [    8.160756] cdb: 12 01 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> > > [    8.160756] backup: data_len=158  bi_size=158
> > > [   14.851101] eth0: link up
> > > [   27.121883] eth0: no IPv6 routers present
> > > 
> > > 
> > > And by the way, Kiyoshi,
> > > This can be reproduced in a typical setup vmware workstation 6.02 with
> > > a vritual IDE cdrom,
> > > in case you wanna catch that with your own eyes. :-)
> > > Thanks for your trying hard to correct this annoying bug.
> > 
> > The below fix should be enough. It's perfectly legal to have leftover
> > byte counts when the drive signals completion, happens all the time for
> > eg user issued commands where you don't know an exact byte count.
> 
> Actually, this behavior has been the case even before the __blk_end_request()
> changes. I did test plain 2.6.24 with the following
> 
> 
> --- linux-2.6/drivers/ide/ide-cd.c	2008-01-31 22:18:59.000000000 +0100
> +++ linux-2.6/drivers/ide/ide-cd.c-new	2008-01-31 22:18:50.000000000 +0100
> @@ -1711,8 +1711,12 @@ static ide_startstop_t cdrom_newpc_intr(
>  	/*
>  	 * If DRQ is clear, the command has completed.
>  	 */
> -	if ((stat & DRQ_STAT) == 0)
> +	if ((stat & DRQ_STAT) == 0) {
> +		blk_dump_rq_flags(rq, "ide-cd: rq still having bio");
> +		printk("backup: data_len=%u  bi_size=%u\n",
> +				rq->data_len, rq->bio->bi_size);
>  		goto end_request;
> +	}
>  
>  	/*
>  	 * check which way to transfer data
> 
> 
> to see whether we've been getting residual byte counts:
> 
> Jan 31 22:10:06 gollum kernel: [   26.702877] ide-cd: rq still having bio: dev hdc: type=2, flags=114c8
> Jan 31 22:10:06 gollum kernel: [   26.702945]
> Jan 31 22:10:06 gollum kernel: [   26.702946] sector 2673511, nr/cnr 0/0
> Jan 31 22:10:06 gollum kernel: [   26.703052] bio dfa8ec40, biotail dfa8ec40, buffer 00000000, data 00000000, len 158
> Jan 31 22:10:06 gollum kernel: [   26.703122] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> Jan 31 22:10:06 gollum kernel: [   26.703877] backup: data_len=158  bi_size=158
> 
> ... so we've been simply silently ignoring this until now so i guess we don't
> need to BUG() for something that's totally benign.

end_that_request_last() is not called when __blk_end_reuqest()
returns 1.  Then, the issuer isn't waken up.
So I think the BUG() or error messages should be there.

And fortunately, the issuer seems not to mind whether
end_that_request_first() is called for the remaining bio or not.

So I think Jens' patch is fine.

Thanks,
Kiyoshi Ueda
