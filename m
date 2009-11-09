Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbZKIVeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbZKIVeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 16:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbZKIVeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 16:34:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683AbZKIVeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 16:34:21 -0500
Date: Mon, 9 Nov 2009 22:33:38 +0100
From: Karel Zak <kzak@redhat.com>
To: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] partitions: use sector size for EFI GPT
Message-ID: <20091109213338.GP5610@nb.net.home>
References: <1256294176-32113-1-git-send-email-kzak@redhat.com> <20091109130827.GO5610@nb.net.home> <20091109195832.GA25240@ub>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109195832.GA25240@ub>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 08:58:32PM +0100, Andries E. Brouwer wrote:
> static size_t
> read_lba(struct block_device *bdev, u64 lba, u8 * buffer, size_t count)
> {
>         size_t totalreadcount = 0;
> 	sector_t n = lba * (bdev_logical_block_size(bdev) / 512);
> 
>         if (!bdev || !buffer || lba > last_lba(bdev))
>                 return 0;
> 
>         while (count) {
>                 int copied = 512;
>                 Sector sect;
>                 unsigned char *data = read_dev_sector(bdev, n++, &sect);
>                 if (!data)
>                         break;
>                 if (copied > count)
>                         copied = count;
>                 memcpy(buffer, data, copied);
>                 put_dev_sector(sect);
>                 buffer += copied;
>                 totalreadcount +=copied;
>                 count -= copied;
>         }
>         return totalreadcount;
> }
> 
> Ugly - it looks as if you call read_dev_sector 8 times and each time

 Yes, the function is really not elegant, but it follows the way how
 all fs/partitions code reads sectors from disks.

> do a put_dev_sector afterwards to forget it again. Doesnt that mean
> that in order to read a 4096-byte sector the kernel goes to the hardware
> 8 times?

 read_dev_sector() works with 512-byte sectors and it's interface to
 read_mapping_page() which works with pages from cache.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
