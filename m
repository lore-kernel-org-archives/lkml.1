Return-Path: <linux-kernel-owner+w=401wt.eu-S1760791AbXKHHCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760791AbXKHHCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 02:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758226AbXKHHBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 02:01:54 -0500
Received: from brick.kernel.dk ([87.55.233.238]:29030 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757775AbXKHHBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 02:01:53 -0500
Date: Thu, 8 Nov 2007 08:01:49 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Roland Dreier <roland@digitalvampire.org>
Cc: Romano Giannetti <romanol@upcomillas.es>, Willy Tarreau <w@1wt.eu>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
Message-ID: <20071108070149.GC5011@kernel.dk>
References: <1194259886.6927.9.camel@localhost> <20071105132218.495f244e@poseidon.drzeus.cx> <1194270393.27789.2.camel@localhost> <20071105162633.09e54290@poseidon.drzeus.cx> <1194343121.6953.6.camel@rukbat> <20071106195148.GD1045@1wt.eu> <1194385693.12938.5.camel@rukbat> <1194387459.5205.2.camel@rukbat> <1194472374.7176.4.camel@rukbat> <87zlxpzkxh.fsf@shaolin.home.digitalvampire.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zlxpzkxh.fsf@shaolin.home.digitalvampire.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07 2007, Roland Dreier wrote:
>  > Well, I spent the last 36 hours (more or less) trying to bisect the SD
>  > problem. The method I used was to insert the card, umount it, and make 8 dd
>  > in a row; the kernel is "bad" if they differs, "good" if they are the same. 
>  > 
>  > I could not finish the bisect. The last pair good/bad were:
>  > 
>  > bad:   [7aeacf982203fb4dea2f3434eefdc268cfd5d6d9] 
>  >        [BLOCK] blk_rq_map_sg: force clear termination bit
>  > good:  [e38f981758118d829cd40cfe9c09e3fa81e422aa] 
>  >        exportfs: update documentation
> 
> Thanks, that helps.  I read over the mmc changes in between those two
> commits, and I think I found the problem... could you please try the
> patch below (on top of the latest kernel) and report back how it
> works?  Unfortunately I am traveling and I don't have an SD card with
> me to test on my laptop...
> 
> Pierre, assuming Romano tests this patch successfully, please apply!
> 
> Thanks,
>   Roland
> 
> <-- patch below -->
> 
> mmc: Fix sg helper copy-and-paste error
> 
> Commit 45711f1a ("[SG] Update drivers to use sg helpers") had the
> following bogus change in drivers/mmc/card/queue.c:
> 
>     > -			src_buf = page_address(src->page) + src->offset;
>     > +			src_buf = sg_virt(dst);
> 
> (Notice that "src" is converted to "dst").  Turn this "dst" back into
> the intended "src".
> 
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Roland Dreier <roland@digitalvampire.org>
> ---
> diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
> index 9203a0b..1b9c9b6 100644
> --- a/drivers/mmc/card/queue.c
> +++ b/drivers/mmc/card/queue.c
> @@ -310,7 +310,7 @@ static void copy_sg(struct scatterlist *dst, unsigned int dst_len,
>  		}
>  
>  		if (src_size == 0) {
> -			src_buf = sg_virt(dst);
> +			src_buf = sg_virt(src);
>  			src_size = src->length;
>  		}
>  

How embarassing, sorry about that! Pierre, shall I shove this upstream
or will you?

-- 
Jens Axboe

