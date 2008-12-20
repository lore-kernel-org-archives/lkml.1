Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbYLTLmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbYLTLmT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 06:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbYLTLmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 06:42:10 -0500
Received: from smtprelay11.ispgateway.de ([80.67.29.28]:55436 "EHLO
	smtprelay11.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbYLTLmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 06:42:09 -0500
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Dec 2008 06:42:09 EST
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH 2/3] virtio: indirect ring entries (VIRTIO_RING_F_INDIRECT_DESC)
Date: Sat, 20 Dec 2008 12:38:06 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; x86_64; ; )
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>
References: <1229620222-22216-1-git-send-email-markmc@redhat.com> <1229620222-22216-2-git-send-email-markmc@redhat.com> <1229620222-22216-3-git-send-email-markmc@redhat.com>
In-Reply-To: <1229620222-22216-3-git-send-email-markmc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812201238.07510.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thursday 18 December 2008, Mark McLoughlin wrote:
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 5777196..2330c4b 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -70,6 +73,55 @@ struct vring_virtqueue
>  
>  #define to_vvq(_vq) container_of(_vq, struct vring_virtqueue, vq)
>  
> +/* Set up an indirect table of descriptors and add it to the queue. */
> +static int vring_add_indirect(struct vring_virtqueue *vq,
> +			      struct scatterlist sg[],
> +			      unsigned int out,
> +			      unsigned int in)
> +{
> +	struct vring_desc *desc;
> +	unsigned head;
> +	int i;
> +
> +	desc = kmalloc((out + in) * sizeof(struct vring_desc), GFP_ATOMIC);

kmalloc() returns ZERO_SIZE_PTR, if (out + in) == 0

> +	if (!desc)
> +		return vq->vring.num;
> +
> +	/* Transfer entries from the sg list into the indirect page */
> +	for (i = 0; i < out; i++) {
> +		desc[i].flags = VRING_DESC_F_NEXT;
> +		desc[i].addr = sg_phys(sg);
> +		desc[i].len = sg->length;
> +		desc[i].next = i+1;
> +		sg++;
> +	}
> +	for (; i < (out + in); i++) {
> +		desc[i].flags = VRING_DESC_F_NEXT|VRING_DESC_F_WRITE;
> +		desc[i].addr = sg_phys(sg);
> +		desc[i].len = sg->length;
> +		desc[i].next = i+1;
> +		sg++;
> +	}
> +
> +	/* Last one doesn't continue. */
> +	desc[i-1].flags &= ~VRING_DESC_F_NEXT;
> +	desc[i-1].next = 0;

So this array index can fail (be -1).
Please check and avoid within this function.


Best Regards

Ingo Oeser
