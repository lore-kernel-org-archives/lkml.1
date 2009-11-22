Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbZKVJjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbZKVJjD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 04:39:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbZKVJjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 04:39:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbZKVJjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 04:39:01 -0500
Date: Sun, 22 Nov 2009 11:36:32 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: Fix warnings and bad type handling
Message-ID: <20091122093630.GA13160@redhat.com>
References: <20091117154213.3683.94554.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117154213.3683.94554.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 03:42:15PM +0000, Alan Cox wrote:
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Thanks!
Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> 
>  drivers/vhost/vhost.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 97233d5..46b20f7 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -334,7 +334,10 @@ static long vhost_set_vring(struct vhost_dev *d, int ioctl, void __user *argp)
>  			r = -EINVAL;
>  			break;
>  		}
> -		r = init_used(vq, (struct vring_used __user *)a.used_user_addr);
> +		/* For 32bit we will ignore the top 32bits of the user
> +		   data */

I am not sure this comment is helpful here: we actually verify that the
top 32 bits are set to 0, a couple of lines above this:

                if ((u64)(unsigned long)a.desc_user_addr != a.desc_user_addr ||
                    (u64)(unsigned long)a.used_user_addr != a.used_user_addr ||
                    (u64)(unsigned long)a.avail_user_addr != a.avail_user_addr) {
                        r = -EFAULT;
                        break;
                }


> +		r = init_used(vq, (struct vring_used __user *)(unsigned long)
> +						a.used_user_addr);
>  		if (r)
>  			break;
>  		vq->log_used = !!(a.flags & (0x1 << VHOST_VRING_F_LOG));
