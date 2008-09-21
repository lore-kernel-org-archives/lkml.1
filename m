Return-Path: <linux-kernel-owner+w=401wt.eu-S1751955AbYIUEFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbYIUEFQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 00:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbYIUEFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 00:05:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750728AbYIUEFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 00:05:03 -0400
Date: Sat, 20 Sep 2008 21:04:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Find bio sector offset given idx and offset
Message-Id: <20080920210444.f083da7b.akpm@linux-foundation.org>
In-Reply-To: <yq17i96nyom.fsf@sermon.lab.mkp.net>
References: <yq17i96nyom.fsf@sermon.lab.mkp.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Sep 2008 20:13:29 -0400 "Martin K. Petersen" <martin.petersen@oracle.com> wrote:

> @@ -1300,6 +1300,30 @@ struct bio_pair *bio_split(struct bio *bi, mempool_t *pool, int first_sectors)
>  	return bp;
>  }
>  
> +sector_t bio_sector_offset(struct bio *bio, unsigned short index, unsigned int offset)
> +{
> +	struct bio_vec *bv;
> +	unsigned int sector_sz = bio->bi_bdev->bd_disk->queue->hardsect_size;
> +	sector_t sectors;
> +	int i;
> +
> +	sectors = 0;
> +
> +	BUG_ON(index >= bio->bi_vcnt);
> +
> +	bio_for_each_segment(bv, bio, i) {
> +		if (i == index) {
> +			if (offset > bv->bv_offset)
> +				sectors += (offset - bv->bv_offset) / sector_sz;
> +			return sectors;
> +		}
> +
> +		sectors += bv->bv_len / sector_sz;
> +	}
> +
> +	BUG();
> +}
> +EXPORT_SYMBOL(bio_sector_offset);

Please avoid sending out kenrel-wide exported-to-modules utility
functions which have no documentation.

Not only is it a bad thing from a maintainability and reliability point
of view - it also makes code review significantly less effective.
