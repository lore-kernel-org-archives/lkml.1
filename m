Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab0BGJMw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 04:12:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab0BGJMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 04:12:49 -0500
Date: Sun, 7 Feb 2010 11:07:49 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
       virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] vhost-net: switch to smp barriers
Message-ID: <20100207090749.GA12968@redhat.com>
References: <20100201172101.GA10900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201172101.GA10900@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 07:21:02PM +0200, Michael S. Tsirkin wrote:
> vhost-net only uses memory barriers to control SMP effects
> (communication with userspace potentially running on a different CPU),
> so it should use SMP barriers and not mandatory barriers for memory
> access ordering, as suggested by Documentation/memory-barriers.txt
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>


Rusty, any feedback on this one?
Thanks!

> ---
>  drivers/vhost/vhost.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> The above applies on top of net-next-2.6. Does not seem to give any
> measureable performance gain, but seems to generate less code
> and I think it's better to use correct APIs.
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index c8c25db..6eb1525 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -685,7 +685,7 @@ int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
>  	int i, r;
>  
>  	/* Make sure data written is seen before log. */
> -	wmb();
> +	smp_wmb();
>  	for (i = 0; i < log_num; ++i) {
>  		u64 l = min(log[i].len, len);
>  		r = log_write(vq->log_base, log[i].addr, l);
> @@ -884,7 +884,7 @@ unsigned vhost_get_vq_desc(struct vhost_dev *dev, struct vhost_virtqueue *vq,
>  		return vq->num;
>  
>  	/* Only get avail ring entries after they have been exposed by guest. */
> -	rmb();
> +	smp_rmb();
>  
>  	/* Grab the next descriptor number they're advertising, and increment
>  	 * the index we've seen. */
> @@ -996,14 +996,14 @@ int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
>  		return -EFAULT;
>  	}
>  	/* Make sure buffer is written before we update index. */
> -	wmb();
> +	smp_wmb();
>  	if (put_user(vq->last_used_idx + 1, &vq->used->idx)) {
>  		vq_err(vq, "Failed to increment used idx");
>  		return -EFAULT;
>  	}
>  	if (unlikely(vq->log_used)) {
>  		/* Make sure data is seen before log. */
> -		wmb();
> +		smp_wmb();
>  		log_write(vq->log_base, vq->log_addr + sizeof *vq->used->ring *
>  			  (vq->last_used_idx % vq->num),
>  			  sizeof *vq->used->ring);
> @@ -1060,7 +1060,7 @@ bool vhost_enable_notify(struct vhost_virtqueue *vq)
>  	}
>  	/* They could have slipped one in as we were doing that: make
>  	 * sure it's written, then check again. */
> -	mb();
> +	smp_mb();
>  	r = get_user(avail_idx, &vq->avail->idx);
>  	if (r) {
>  		vq_err(vq, "Failed to check avail idx at %p: %d\n",
> -- 
> 1.6.6.144.g5c3af
