Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbZLAOtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbZLAOtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 09:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbZLAOtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 09:49:41 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52318 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbZLAOtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 09:49:40 -0500
Subject: Re: virtio: Add memory statistics reporting to the balloon driver
 (V4)
From: Adam Litke <agl@us.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <200912011254.22861.rusty@rustcorp.com.au>
References: <1259597655.30369.2.camel@aglitke>
	 <200912011254.22861.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 01 Dec 2009 08:49:45 -0600
Message-ID: <1259678985.2816.0.camel@aglitke>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Rusty.

Acked-by: Adam Litke <agl@us.ibm.com>

On Tue, 2009-12-01 at 12:54 +1030, Rusty Russell wrote:
> On Tue, 1 Dec 2009 02:44:15 am Adam Litke wrote:
> > Changes since V3:
> 
> OK, I applied this.  And here's the fixes I applied afterwards (to save YA
> round trip: please ack and I'll fold them together)
> 
> virtio: balloon fixes
> 
> 1) Tag and val args to update_stat() are no longer __le.
> 2) pages_to_bytes() should promote to u64 so we don't truncate.
> 3) Fix two checkpatch.pl warnings.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  drivers/virtio/virtio_balloon.c |    8 +++++---
>  include/linux/virtio_balloon.h  |    3 +--
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -158,14 +158,15 @@ static void leak_balloon(struct virtio_b
>  }
> 
>  static inline void update_stat(struct virtio_balloon *vb, int idx,
> -				__le16 tag, __le64 val)
> +			       u16 tag, u64 val)
>  {
>  	BUG_ON(idx >= VIRTIO_BALLOON_S_NR);
>  	vb->stats[idx].tag = tag;
>  	vb->stats[idx].val = val;
>  }
> 
> -#define pages_to_bytes(x) ((x) << PAGE_SHIFT)
> +#define pages_to_bytes(x) ((u64)(x) << PAGE_SHIFT)
> +
>  static void update_balloon_stats(struct virtio_balloon *vb)
>  {
>  	unsigned long events[NR_VM_EVENT_ITEMS];
> @@ -296,7 +297,8 @@ static int virtballoon_probe(struct virt
>  		 * use it to signal us later.
>  		 */
>  		sg_init_one(&sg, vb->stats, sizeof vb->stats);
> -		if (vb->stats_vq->vq_ops->add_buf(vb->stats_vq, &sg, 1, 0, vb) < 0)
> +		if (vb->stats_vq->vq_ops->add_buf(vb->stats_vq,
> +						  &sg, 1, 0, vb) < 0)
>  			BUG();
>  		vb->stats_vq->vq_ops->kick(vb->stats_vq);
>  	}
> diff --git a/include/linux/virtio_balloon.h b/include/linux/virtio_balloon.h
> --- a/include/linux/virtio_balloon.h
> +++ b/include/linux/virtio_balloon.h
> @@ -28,8 +28,7 @@ struct virtio_balloon_config
>  #define VIRTIO_BALLOON_S_MEMTOT   5   /* Total amount of memory */
>  #define VIRTIO_BALLOON_S_NR       6
> 
> -struct virtio_balloon_stat
> -{
> +struct virtio_balloon_stat {
>  	u16 tag;
>  	u64 val;
>  } __attribute__((packed));
> 
> 


-- 
Thanks,
Adam

