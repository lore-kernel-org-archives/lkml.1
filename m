Return-Path: <linux-kernel-owner+w=401wt.eu-S1764208AbXHQHOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764208AbXHQHOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 03:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756477AbXHQHOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 03:14:04 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:41767 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756045AbXHQHNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 03:13:22 -0400
Date: Fri, 17 Aug 2007 09:13:19 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: NeilBrown <neilb@suse.de>
cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>
Subject: Re: [PATCH 002 of 6] Introduce rq_for_each_segment replacing
 rq_for_each_bio
In-Reply-To: <1070816112100.12182@suse.de>
Message-ID: <Pine.LNX.4.62.0708170910120.8381@pademelon.sonytel.be>
References: <20070816211551.11839.patches@notabene> <1070816112100.12182@suse.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-995176808-1187334658=:8381"
Content-ID: <Pine.LNX.4.62.0708170911090.8381@pademelon.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-995176808-1187334658=:8381
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.62.0708170911091.8381@pademelon.sonytel.be>

On Thu, 16 Aug 2007, NeilBrown wrote:
> Every usage of rq_for_each_bio wraps a usage of
> bio_for_each_segment, so these can be combined into
> rq_for_each_segment.
> 
> We define "struct req_iterator" to hold the 'bio' and 'index' that
> are needed for the double iteration.

> --- .prev/drivers/block/ps3disk.c	2007-08-16 20:37:26.000000000 +1000
> +++ ./drivers/block/ps3disk.c	2007-08-16 20:50:07.000000000 +1000
> @@ -91,30 +91,30 @@ static void ps3disk_scatter_gather(struc
>  				   struct request *req, int gather)
>  {
>  	unsigned int offset = 0;
> -	struct bio *bio;
> -	sector_t sector;
> +	struct req_iterator iter;
>  	struct bio_vec *bvec;
> -	unsigned int i = 0, j;
> +	unsigned int i = 0;
>  	size_t size;
>  	void *buf;
>  
> -	rq_for_each_bio(bio, req) {
> -		sector = bio->bi_sector;
> +	rq_for_each_segment(bvec, req, iter) {
> +		unsigned long flags;
>  		dev_dbg(&dev->sbd.core,
>  			"%s:%u: bio %u: %u segs %u sectors from %lu\n",
> -			__func__, __LINE__, i, bio_segments(bio),
> -			bio_sectors(bio), sector);
> -		bio_for_each_segment(bvec, bio, j) {
> +			__func__, __LINE__, i, bio_segments(iter.bio),
> +			bio_sectors(iter.bio),
> +			(unsigned long)iter.bio->bi_sector);
                        ^^^^^^^^^^^^^^^
Superfluous cast: PS3 is 64-bit only, and casts are evil.

> +
>  			size = bvec->bv_len;
> -			buf = __bio_kmap_atomic(bio, j, KM_IRQ0);
> +			buf = bvec_kmap_irq(bvec, flags);

As you already mentioned in the preample of the patch series, this changes
functionality.

>  			if (gather)
>  				memcpy(dev->bounce_buf+offset, buf, size);
>  			else
>  				memcpy(buf, dev->bounce_buf+offset, size);
>  			offset += size;
>  			flush_kernel_dcache_page(bio_iovec_idx(bio, j)->bv_page);
> -			__bio_kunmap_atomic(bio, KM_IRQ0);
> -		}
> +			bio_kunmap_bvec(bvec, flags);
> +
>  		i++;
>  	}
>  }

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-995176808-1187334658=:8381--
