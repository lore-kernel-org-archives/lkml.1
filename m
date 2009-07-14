Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbZGNNsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbZGNNsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 09:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbZGNNs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 09:48:29 -0400
Received: from mail-qy0-f192.google.com ([209.85.221.192]:43845 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbZGNNs2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 09:48:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=F5mi89A290VHo0f7xbWcBr+BbXFh/6AzFqEZzhP/Nv1fu4u8Q2qGwDwMp64blkvQ/9
         shu9F+XvBPjumoLURXUpDHotP42Rv2KKj2SDlEE1ldKt5FQZJTNBaAb5f+Os4swh6ydN
         /aF+C/HQy5UlQDErGmAz6uuAr55Bp/XfHPVPg=
MIME-Version: 1.0
In-Reply-To: <1247572794-24107-1-git-send-email-dfeng@redhat.com>
References: <1247572794-24107-1-git-send-email-dfeng@redhat.com>
Date: Tue, 14 Jul 2009 21:48:28 +0800
Message-ID: <2375c9f90907140648t5401f785r53f38b49dbcc6f95@mail.gmail.com>
Subject: Re: [RFC PATCH] block: slightly optimize blkdev_ioctl BLKRA{SET,GET}
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 7:59 PM, Xiaotian Feng<dfeng@redhat.com> wrote:
> Slightly optimize blkdev_ioctl by using shift instead of multiply
> and divide.

Not necessary, I believe gcc can do this by itself.

Have you checked its asm code?

>
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> ---
>  block/ioctl.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/block/ioctl.c b/block/ioctl.c
> index 500e4c7..f8c7362 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -305,7 +305,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
>                bdi = blk_get_backing_dev_info(bdev);
>                if (bdi == NULL)
>                        return -ENOTTY;
> -               return put_long(arg, (bdi->ra_pages * PAGE_CACHE_SIZE) / 512);
> +               return put_long(arg, bdi->ra_pages << (PAGE_CACHE_SHIFT - 9));
>        case BLKROGET:
>                return put_int(arg, bdev_read_only(bdev) != 0);
>        case BLKBSZGET: /* get the logical block size (cf. BLKSSZGET) */
> @@ -321,7 +321,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
>                bdi = blk_get_backing_dev_info(bdev);
>                if (bdi == NULL)
>                        return -ENOTTY;
> -               bdi->ra_pages = (arg * 512) / PAGE_CACHE_SIZE;
> +               bdi->ra_pages = arg >> (PAGE_CACHE_SHIFT - 9);
>                return 0;
>        case BLKBSZSET:
>                /* set the logical block size */
> --
> 1.6.2.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
