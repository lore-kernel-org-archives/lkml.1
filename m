Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbZKIUbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbZKIUbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 15:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbZKIUbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 15:31:39 -0500
Received: from hera.cwi.nl ([192.16.191.8]:52566 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863AbZKIUbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 15:31:39 -0500
X-Greylist: delayed 1967 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Nov 2009 15:31:38 EST
Date: Mon, 9 Nov 2009 20:58:32 +0100
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: Karel Zak <kzak@redhat.com>
Cc: Andries Brouwer <Andries.Brouwer@cwi.nl>,
       Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] partitions: use sector size for EFI GPT
Message-ID: <20091109195832.GA25240@ub>
References: <1256294176-32113-1-git-send-email-kzak@redhat.com> <20091109130827.GO5610@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109130827.GO5610@nb.net.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 02:08:27PM +0100, Karel Zak wrote:
> On Fri, Oct 23, 2009 at 12:36:15PM +0200, Karel Zak wrote:
> > Currently, kernel uses strictly 512-byte sectors for EFI GPT parsing.
> > That's wrong.
> 
>  Ping? Does anyone care about new disks with non-512byte sectors? 
>  (or fs/partitions is unmaintained area? ;-)

[as you must have noticed, I hardly do any kernel work any more;
probably there aren't many who know more about the ugly details
of DOS-type partition tables, but on the other hand nobody needs
such knowledge either]

>  The current kernel EFI GPT code in not compatible with the latest 
>  userspace and GPT partitions on disks with >512byte sectors will be 
>  *invisible* for Linux kernel.

Yes, I see that the current UEFI standard requires the use of the
disks block size. Roughly speaking I agree with your patch.

(Just read some current kernel code. The old hardsect_size stuff was
renamed to logical_block_size - funny, originally that was precisely
what hardsect was not.)

static size_t
read_lba(struct block_device *bdev, u64 lba, u8 * buffer, size_t count)
{
        size_t totalreadcount = 0;
	sector_t n = lba * (bdev_logical_block_size(bdev) / 512);

        if (!bdev || !buffer || lba > last_lba(bdev))
                return 0;

        while (count) {
                int copied = 512;
                Sector sect;
                unsigned char *data = read_dev_sector(bdev, n++, &sect);
                if (!data)
                        break;
                if (copied > count)
                        copied = count;
                memcpy(buffer, data, copied);
                put_dev_sector(sect);
                buffer += copied;
                totalreadcount +=copied;
                count -= copied;
        }
        return totalreadcount;
}

Ugly - it looks as if you call read_dev_sector 8 times and each time
do a put_dev_sector afterwards to forget it again. Doesnt that mean
that in order to read a 4096-byte sector the kernel goes to the hardware
8 times?

Andries

