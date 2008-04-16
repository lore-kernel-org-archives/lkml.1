Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbYDPVco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbYDPVco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 17:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYDPVce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 17:32:34 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34037 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbYDPVcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 17:32:33 -0400
Message-ID: <4806706E.10701@us.ibm.com>
Date: Wed, 16 Apr 2008 16:32:30 -0500
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ryan Harper <ryanh@us.ibm.com>, virtualization@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       Hollis Blanchard <hollisb@us.ibm.com>
Subject: Re: [PATCH] add virtio disk geometry feature
References: <1208372197-20815-1-git-send-email-ryanh@us.ibm.com> <200804170715.55041.rusty@rustcorp.com.au>
In-Reply-To: <200804170715.55041.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thursday 17 April 2008 04:56:37 Ryan Harper wrote:
>   
>> From: Ryan Harper <ryanh@us.ibm.com>
>>
>> Rather than faking up some geometry, allow the backend to push the disk
>> geometry via virtio pci config option.  Keep the old geo code around for
>> compatibility.
>>     
>
> Hi Ryan,
>
>    Looks good! Some brief review below.  Mainly just "how I would have done
> things" stuff.  BTW, does this help in real life?  I assume something in
> userspace wants it?
>   

Boot loaders (like grub) query the geometry from the kernel to figure 
out how to setup the stage1/stage2.  We've seen strange issues with grub 
thinking it has crazy geometries when installed on a virtio disk (as 
opposed to booting from virtio with an existing disk).

Ryan: have you tested a hardy install with your patches?  Does it help 
when installing to virtio?  I could pretty reliably reproduce the 
strangeness with a 20GB disk image FWIW.

> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -157,10 +157,25 @@ static int virtblk_ioctl(struct inode *i
>  /* We provide getgeo only to please some old bootloader/partitioning tools */
>  static int virtblk_getgeo(struct block_device *bd, struct hd_geometry *geo)
>  {
> -	/* some standard values, similar to sd */
> -	geo->heads = 1 << 6;
> -	geo->sectors = 1 << 5;
> -	geo->cylinders = get_capacity(bd->bd_disk) >> 11;
> +	struct virtio_blk *vblk = bd->bd_disk->private_data;
> +	struct virtio_blk_geometry vgeo;
> +	int err;
> +
> +	/* see if the host passed in geometry config */
> +	err = virtio_config_val(vblk->vdev, VIRTIO_BLK_F_GEOMETRY,
> +				offsetof(struct virtio_blk_config, geometry),
> +				&vgeo);
> +
> +	if (!err) {
> +		geo->heads = vgeo.heads;
> +		geo->sectors = vgeo.sectors;
> +		geo->cylinders = vgeo.cylinders;
> +	} else {
> +		/* some standard values, similar to sd */
> +		geo->heads = 1 << 6;
> +		geo->sectors = 1 << 5;
> +		geo->cylinders = get_capacity(bd->bd_disk) >> 11;
> +	}
>  	return 0;
>  }
>   

You're probably breaking PPC since the values in the config space are in 
little endian format.  virtio_config_val does automagic endianness 
conversion if the size is 2, 4, or 8.  In this case, the structure size 
is 4 so the endianness conversion will do the wrong thing.

Magic endianness conversion based on read size is looking pretty evil to 
me... Perhaps we need explicit *_val[8,16,32,64]?

Regards,

Anthony Liguori

