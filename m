Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab0CGLdy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 06:33:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab0CGLdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 06:33:53 -0500
Date: Sun, 7 Mar 2010 13:30:18 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Xin Xiaohui <xiaohui.xin@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] vhost - Fix error path in vhost_net_set_backend
Message-ID: <20100307113018.GA20121@redhat.com>
References: <20100304211014.GA10008@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100304211014.GA10008@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 04:10:14PM -0500, Jeff Dike wrote:
> commit 7bee327f8020f81a52ecb362f1fec7a4494dc98b
> Author: Jeff Dike <jdike@localhost.localdomain>
> Date:   Thu Mar 4 14:48:38 2010 -0500
> 
>     Fix vhost_net_set_backend error path
>     
>     An error could cause vhost_net_set_backend to exit without unlocking
>     vq->mutex.
>     
>     Signed-off-by: Jeff Dike <jdike@linux.intel.com>

Thanks, applied.

> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index ad37da2..4ada4b4 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -508,12 +508,12 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
>  	/* Verify that ring has been setup correctly. */
>  	if (!vhost_vq_access_ok(vq)) {
>  		r = -EFAULT;
> -		goto err;
> +		goto err_unlock_vq;
>  	}
>  	sock = get_socket(fd);
>  	if (IS_ERR(sock)) {
>  		r = PTR_ERR(sock);
> -		goto err;
> +		goto err_unlock_vq;
>  	}
>  
>  	/* start polling new socket */
> @@ -524,12 +524,14 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
>  	vhost_net_disable_vq(n, vq);
>  	rcu_assign_pointer(vq->private_data, sock);
>  	vhost_net_enable_vq(n, vq);
> -	mutex_unlock(&vq->mutex);
>  done:
>  	if (oldsock) {
>  		vhost_net_flush_vq(n, index);
>  		fput(oldsock->file);
>  	}
> +
> +err_unlock_vq:
> +	mutex_unlock(&vq->mutex);
>  err:
>  	mutex_unlock(&n->dev.mutex);
>  	return r;
