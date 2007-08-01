Return-Path: <linux-kernel-owner+w=401wt.eu-S1764659AbXHAM5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764659AbXHAM5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 08:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761920AbXHAM5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 08:57:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:41803 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761605AbXHAM5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 08:57:38 -0400
Message-ID: <fa686aa40708010557k5e72932l7f0d05b83c09878b@mail.gmail.com>
Date: Wed, 1 Aug 2007 06:57:36 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Christoph Hellwig" <hch@lst.de>
Subject: Re: [PATCH] sysace: HDIO_GETGEO has it's own method for ages
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070730220029.GA28003@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070730220029.GA28003@lst.de>
X-Google-Sender-Auth: 84058daf984e0d2c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/07, Christoph Hellwig <hch@lst.de> wrote:
> The way this driver triesto implement HDIO_GETGEO it'll never be
> called.  Then again on ppc it probably will never be called anyway
> because it's utterly pointless.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Heh, that's what I get for following LDD3 exactly for writing my block
dev, and not keeping up with API changes.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

>
> Index: linux-2.6/drivers/block/xsysace.c
> ===================================================================
> --- linux-2.6.orig/drivers/block/xsysace.c      2007-07-30 22:53:11.000000000 +0200
> +++ linux-2.6/drivers/block/xsysace.c   2007-07-30 22:54:43.000000000 +0200
> @@ -902,26 +902,17 @@ static int ace_release(struct inode *ino
>         return 0;
>  }
>
> -static int ace_ioctl(struct inode *inode, struct file *filp,
> -                    unsigned int cmd, unsigned long arg)
> +static int ace_getgeo(struct block_device *bdev, struct hd_geometry *geo)
>  {
> -       struct ace_device *ace = inode->i_bdev->bd_disk->private_data;
> -       struct hd_geometry __user *geo = (struct hd_geometry __user *)arg;
> -       struct hd_geometry g;
> -       dev_dbg(ace->dev, "ace_ioctl()\n");
> -
> -       switch (cmd) {
> -       case HDIO_GETGEO:
> -               g.heads = ace->cf_id.heads;
> -               g.sectors = ace->cf_id.sectors;
> -               g.cylinders = ace->cf_id.cyls;
> -               g.start = 0;
> -               return copy_to_user(geo, &g, sizeof(g)) ? -EFAULT : 0;
> +       struct ace_device *ace = bdev->bd_disk->private_data;
>
> -       default:
> -               return -ENOTTY;
> -       }
> -       return -ENOTTY;
> +       dev_dbg(ace->dev, "ace_getgeo()\n");
> +
> +       geo->heads = ace->cf_id.heads;
> +       geo->sectors = ace->cf_id.sectors;
> +       geo->cylinders = ace->cf_id.cyls;
> +
> +       return 0;
>  }
>
>  static struct block_device_operations ace_fops = {
> @@ -930,7 +921,7 @@ static struct block_device_operations ac
>         .release = ace_release,
>         .media_changed = ace_media_changed,
>         .revalidate_disk = ace_revalidate_disk,
> -       .ioctl = ace_ioctl,
> +       .getgeo = ace_getgeo,
>  };
>
>  /* --------------------------------------------------------------------
>


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
