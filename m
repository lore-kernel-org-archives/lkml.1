Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbZHUHaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbZHUHaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 03:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbZHUHap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 03:30:45 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:39739 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbZHUHao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 03:30:44 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] virtio-blk: set QUEUE_ORDERED_DRAIN by default
Date: Fri, 21 Aug 2009 09:30:39 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30-release; KDE/4.3.0; i686; ; )
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
References: <20090820205616.GA5503@lst.de>
In-Reply-To: <20090820205616.GA5503@lst.de>
MIME-Version: 1.0
Message-Id: <200908210930.39861.borntraeger@de.ibm.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 20 August 2009 22:56:16 schrieb Christoph Hellwig:
> Currently virtio-blk doesn't set any QUEUE_ORDERED_ flag by default, which
> means it does not allow filesystems to use barriers.  But the typical use
> case for virtio-blk is to use a backed that uses synchronous I/O, and in
> that case we can simply set QUEUE_ORDERED_DRAIN to make the block layer
> drain the request queue around barrier I/O and provide the semantics that
> the filesystems need.  This is what the SCSI disk driver does for disks
> that have the write cache disabled.
>
> With this patch we incorrectly advertise barrier support if someone
> configure qemu with write back caching.  While this displays wrong
> information in the guest there is nothing that guest could have done
> even if we rightfully told it that we do not support any barriers.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Make sense to me.
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

[...]
> -	/* If barriers are supported, tell block layer that queue is ordered */
> +	/*
> +	 * If barriers are supported, tell block layer that queue is ordered.
> +	 *
> +	 * If no barriers are supported assume the host uses synchronous
> +	 * writes and just drain the the queue before and after the barrier.
> +	 */
>  	if (virtio_has_feature(vdev, VIRTIO_BLK_F_BARRIER))
>  		blk_queue_ordered(vblk->disk->queue, QUEUE_ORDERED_TAG, NULL);
> +	else
> +		blk_queue_ordered(vblk->disk->queue, QUEUE_ORDERED_DRAIN, NULL);
[...]
