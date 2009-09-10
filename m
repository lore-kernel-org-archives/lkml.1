Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbZIJU3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbZIJU3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbZIJU3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:29:06 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41876 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbZIJU3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:29:05 -0400
Date: Thu, 10 Sep 2009 22:29:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ed Cashin <ecashin@coraid.com>
Cc: alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org, apw@canonical.com,
       bonbons@linux-vserver.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aoe: end barrier bios with EOPNOTSUPP
Message-ID: <20090910202907.GY18599@kernel.dk>
References: <20090909180804.3e62331a@lxorguk.ukuu.org.uk> <30b7855d211ab5b6bef6fe2cd9b76295@coraid.com> <20090909205835.GK18599@kernel.dk> <810bbe1723b0a205f9b5018a5ddaa722@coraid.com> <20090910074820.GS18599@kernel.dk> <84f18127dcdb4762bf9dc6796846087f@coraid.com> <20090910195021.GW18599@kernel.dk> <aa669085856b88bee82d150efe84b682@coraid.com> <178912f8877bbbbbd5aa5cd4a082f8a9@coraid.com> <6b358a82605cc6a12b76538a8f020667@coraid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b358a82605cc6a12b76538a8f020667@coraid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10 2009, Ed Cashin wrote:
> aoe: end barrier bios with EOPNOTSUPP
> 
> BugLink: http://bugzilla.kernel.org/show_bug.cgi?id=13942
> 
> Bruno Premont noticed that aoe throws a BUG during umount of an XFS in
> 2.6.31:
> 
> [ 5259.349897] aoe: bi_io_vec is NULL
> [ 5259.349940] ------------[ cut here ]------------
> [ 5259.349958] kernel BUG at /usr/src/linux-2.6/drivers/block/aoe/aoeblk.c:177!
> [ 5259.349990] invalid opcode: 0000 [#1]
> 
> The bio in question is a barrier.  Jens Axboe suggested that such bios
> need to be recognized and ended with -EOPNOTSUPP by any driver that
> provides its own ->make_request_fn handler and does not handle
> barriers.
> 
> In testing the changes below eliminate the BUG.
> 
> Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
> ---
>  drivers/block/aoe/aoeblk.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
> index 2307a27..22efb33 100644
> --- a/drivers/block/aoe/aoeblk.c
> +++ b/drivers/block/aoe/aoeblk.c
> @@ -172,6 +172,9 @@ aoeblk_make_request(struct request_queue *q, struct bio *bio)
>  		BUG();
>  		bio_endio(bio, -ENXIO);
>  		return 0;
> +	} else if (bio_barrier(bio)) {
> +		bio_endio(bio, -EOPNOTSUPP);
> +		return 0;
>  	} else if (bio->bi_io_vec == NULL) {
>  		printk(KERN_ERR "aoe: bi_io_vec is NULL\n");
>  		BUG();
> -- 
> 1.5.6.5

I have applied this with a note that proper barrier support is coming.

-- 
Jens Axboe

