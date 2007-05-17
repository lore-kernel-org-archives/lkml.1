Return-Path: <linux-kernel-owner+w=401wt.eu-S933152AbXEQFb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbXEQFb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 01:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756322AbXEQFbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 01:31:19 -0400
Received: from mail.suse.de ([195.135.220.2]:58362 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358AbXEQFbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 01:31:17 -0400
From: Neil Brown <neilb@suse.de>
To: david@lang.hm, Jeff Zheng <Jeff.Zheng@endace.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Thu, 17 May 2007 15:31:07 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17995.59547.368508.202596@notabene.brown>
Subject: RE: Software raid0 will crash the file-system, when each disk is
 5TB
In-Reply-To: message from Neil Brown on Thursday May 17
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com>
	<6bffcb0e0705151629j78920ca2r9337dccdfc1bb6a9@mail.gmail.com>
	<17994.19043.771733.453896@notabene.brown>
	<659F626D666070439A4A5965CD6EBF406B31C5@gazelle.ad.endace.com>
	<17995.42562.870806.396617@notabene.brown>
	<659F626D666070439A4A5965CD6EBF406B33ED@gazelle.ad.endace.com>
	<17995.49602.427417.500049@notabene.brown>
	<Pine.LNX.4.64.0705162145060.31624@asgard.lang.hm>
	<17995.57891.56738.592100@notabene.brown>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday May 17, neilb@suse.de wrote:
> 
> Uhm, I just noticed something.
> 'chunk' is unsigned long, and when it gets shifted up, we might lose
> bits.  That could still happen with the 4*2.75T arrangement, but is
> much more likely in the 2*5.5T arrangement.

Actually, it cannot be a problem with the 4*2.75T arrangement.
  chuck << chunksize_bits

will not exceed the size of the underlying device *in*kilobytes*.
In that case that is 0xAE9EC800 which will git in a 32bit long.
We don't double it to make sectors until after we add
zone->dev_offset, which is "sector_t" and so 64bit arithmetic is used.

So I'm quite certain this bug will cause exactly the problems
experienced!!

> 
> Jeff, can you try this patch?

Don't bother about the other tests I mentioned, just try this one.
Thanks.

NeilBrown

> Signed-off-by: Neil Brown <neilb@suse.de>
> 
> ### Diffstat output
>  ./drivers/md/raid0.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff .prev/drivers/md/raid0.c ./drivers/md/raid0.c
> --- .prev/drivers/md/raid0.c	2007-05-17 10:33:30.000000000 +1000
> +++ ./drivers/md/raid0.c	2007-05-17 15:02:15.000000000 +1000
> @@ -475,7 +475,7 @@ static int raid0_make_request (request_q
>  		x = block >> chunksize_bits;
>  		tmp_dev = zone->dev[sector_div(x, zone->nb_dev)];
>  	}
> -	rsect = (((chunk << chunksize_bits) + zone->dev_offset)<<1)
> +	rsect = ((((sector_t)chunk << chunksize_bits) + zone->dev_offset)<<1)
>  		+ sect_in_chunk;
>   
>  	bio->bi_bdev = tmp_dev->bdev;
